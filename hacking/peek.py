#!/usr/bin/env python3
import os
import sys
import mmap
import struct
import urwid
import asyncio
from collections import defaultdict
import re

import yaml
from yaml import load, dump
from yaml import SafeLoader, SafeDumper
from yaml.resolver import Resolver

debuglog = open('/tmp/rarlog', 'w')

HEX_RE = re.compile('^[0-9a-fA-F]$')

""" DevMem
Class to read and write data aligned to word boundaries of /dev/mem
"""
class DevMem:
    # Size of a word that will be used for reading/writing
    word = 1
    mask = ~(word - 1)

    def __init__(self, base_addr, length = 1, filename = '/dev/mem',
                 debug = 0):

        if base_addr < 0 or length < 0: raise AssertionError
        self._debug = debug

        self.base_addr = base_addr & ~(mmap.PAGESIZE - 1)
        self.base_addr_offset = base_addr - self.base_addr

        stop = base_addr + length * self.word
        if (stop % self.mask):
            stop = (stop + self.word) & ~(self.word - 1)

        self.length = stop - self.base_addr
        self.fname = filename

        # Check filesize (doesn't work with /dev/mem)
        #filesize = os.stat(self.fname).st_size
        #if (self.base_addr + self.length) > filesize:
        #    self.length = filesize - self.base_addr

        self.debug('init with base_addr = {0} and length = {1} on {2}'.
                format(hex(self.base_addr), hex(self.length), self.fname))

        # Open file and mmap
        f = os.open(self.fname, os.O_RDWR | os.O_SYNC)
        self.mem = mmap.mmap(f, self.length, mmap.MAP_SHARED,
                mmap.PROT_READ | mmap.PROT_WRITE,
                offset=self.base_addr)


    """
    Read length number of words from offset
    """
    def read(self, offset, length):
        if offset < 0 or length < 0: raise AssertionError

        # Make reading easier (and faster... won't resolve dot in loops)
        mem = self.mem

        self.debug('reading {0} bytes from offset {1}'.
                   format(length * self.word, hex(offset)))

        # Compensate for the base_address not being what the user requested
        # and then seek to the aligned offset.
        virt_base_addr = self.base_addr_offset & self.mask
        mem.seek(virt_base_addr + offset)

        # Read length words of size self.word and return it
        data = mem.read(length)

        abs_addr = self.base_addr + virt_base_addr
        return data


    """
    Write length number of words to offset
    """
    def write(self, offset, din):
        if offset < 0 or len(din) <= 0: raise AssertionError

        self.debug('writing {0} bytes to offset {1}'.
                format(len(din), hex(offset)))

        # Make reading easier (and faster... won't resolve dot in loops)
        mem = self.mem

        # Compensate for the base_address not being what the user requested
        # offset += self.base_addr_offset

        # Check that the operation is going write to an aligned location
        if (offset & ~self.mask): raise AssertionError

        # Seek to the aligned offset
        virt_base_addr = self.base_addr_offset & self.mask
        mem.seek(virt_base_addr + offset)

        # Write one word at a time
        mem.write(din)

    def debug_set(self, value):
        self._debug = value

    def debug(self, debug_str):
        if self._debug: print('DevMem Debug: {0}'.format(debug_str))


def make_hex(buf):
    return ' '.join(f'{c:02x}' for c in buf)

class TextClick(urwid.Text):
    def __init__(self, markup, align='left', wrap='space', layout=None, callback=()):
        super().__init__(markup, align, wrap, layout)
        if callback:
            self.set_callback(*callback)

    def set_callback(self, callback, *args):
        self._callback = callback
        self._cbargs = args
    def mouse_event(self, size, event, button, col, row, focus):
        if hasattr(self, '_callback'):
            return self._callback(event, button, *self._cbargs)
        return False


class Config:
    def __init__(self, filename):
        self.is_dirty = False

        with open(filename, 'r') as f:
            self.config = load(f, SafeLoader)
            if self.config is None:
                self.config = {}
                self.is_dirty = True
        self.filename = filename

    def save(self):
        with open(self.filename, 'w') as f:
            dump(self.config, f)

    def __setitem__(self, item, value):
        self.config[item] = value

    def __getitem__(self, item):
        return self.config[item]

    def __repr__(self):
        return f'Config {self.is_dirty} {repr(self.config)}'

    def dirty(self):
        self.is_dirty = True

    def ensure_path(self, path, default):
        cur = self.config
        for p in path[:-1]:
            if p not in cur:
                cur[p] = {}
            cur = cur[p]
        if path[-1] not in cur:
            cur[path[-1]] = default

groups = {
    1: (urwid.LIGHT_RED, 'black'),
    2: (urwid.LIGHT_GREEN, 'black'),
    3: (urwid.YELLOW, 'black'),
    4: (urwid.LIGHT_BLUE, 'black'),
    5: (urwid.LIGHT_MAGENTA, 'black'),
}

palette = {
    'head': ('light red', 'black'),
    'foot': ('yellow', 'black'),
    'popbg': ('white', 'dark red'),
    **{f'grp{key}': value for key, value in groups.items()},
    **{f'grp{-key}': tuple(reversed(value)) for key, value in groups.items()},
    #'grpNone': ('light red', 'black'),
    'grp0': ('black', 'white'),
}

modes = (
    'Normal',
    'Diff',
)

class DataDisplay(urwid.GridFlow):
    def __init__(self, app, size=256):
        self.app = app
        self.data = [0 for i in range(0, size)]
        self.attr = [None for i in range(0, size)]
        self.mode = False
        self.bucketed_data = defaultdict(list)
        self.debug = ''
        super().__init__([TextClick((None, f'{self.data[i]:02x}'), callback=(self.cb, i)) for i in range(0, size)], 2, 1, 0, 'left')

    def cb(self, event, button, i):
        attr = self.attr[i]
        sign = attr is not None and attr <= 0
        if sign:
            attr = abs(attr)

        if event == 'mouse press':
            if button == 1:
                attr = (attr or 0) + 1
                if attr in groups:
                    self.attr[i] = -attr if sign else attr
                else:
                    self.attr[i] = 0 if sign else attr
                return True
            elif button == 2:
                self.attr[i] = 0 if sign else None
                return True
            elif button == 3:
                self.app.popup(i)
                return True
        return False


    def update(self, data):
        diff = self.mode
        self.bucketed_data.clear()
        for i, c in enumerate(data):
            attr = self.attr[i]
            sign = attr is not None and attr <= 0
            if diff:
                if self.data[i] != c and (attr is None or attr > 0):
                    attr = -(attr or 0)
            elif attr is not None and attr <= 0:
                attr = abs(attr) or None
            txt = self.contents[i][0]
            txt.set_text((f'grp{attr}', f'{c:02x}'))
            txt._invalidate()
            if attr:
                self.bucketed_data[abs(attr)].append((i, c))
            self.attr[i] = attr
        self.data = data
        self._invalidate()

class DataGroup(urwid.GridFlow):
    def __init__(self, app, number):
        self.app = app
        self.number = number
        self.data = []
        super().__init__([TextClick((f'grp{number}', f'{number}:\n'))], 2, 2, 0, 'left')

    def update(self, data):
        self.data = data
        len_content = len(self.contents) - 1
        len_data = len(data)
        if len_content < len_data:
            self.contents.extend([(TextClick(''), self.options()) for i in range(0, len_data - len_content)])
        elif len_content > len_data:
            self.contents = self.contents[0:len_data - len_content]

        for i, (addr, value) in enumerate(data):
            txt = self.contents[i+1][0]
            txt.set_text(f'{addr:02x}\n{value:02x}')
            txt._invalidate()
        self._invalidate()

class HexEdit(urwid.Edit):
    def valid_char(self, ch):
        return HEX_RE.match(ch) and len(self.edit_text) < 2

class PopUpDialog(urwid.WidgetWrap):
    signals = ['close', 'write']

    def __init__(self, offset):
        self.offset = offset
        close_button = urwid.Button('Close')
        write_button = urwid.Button('Write')
        edit = HexEdit('Value')
        urwid.connect_signal(close_button, 'click',
                             lambda button:self._emit("close"))
        urwid.connect_signal(write_button, 'click',
                             lambda button: self._emit("write", self.offset, int(edit.edit_text, 16)) if edit.edit_text else self._emit('close'))
        pile = urwid.Pile([
            edit,
            close_button,
            write_button,
        ])
        fill = urwid.Filler(pile)
        self.__super.__init__(urwid.AttrWrap(fill, 'popbg'))


class DataWritePopup(urwid.PopUpLauncher):
    signals = ['write']
    def create_pop_up(self):
        pop_up = PopUpDialog(self._offset)
        urwid.connect_signal(pop_up, 'close', lambda button: self.close_pop_up())
        urwid.connect_signal(pop_up, 'write', self.__write)
        return pop_up
    def __write(self, pop_up, offset, value):
        self._emit('write', offset, value)
        self.close_pop_up()
    def get_pop_up_parameters(self):
        return {'left':10, 'top':10, 'overlay_width':32, 'overlay_height':7}

class App:
    def __init__(self):
        self.dev = DevMem(0xfe410500, 256);
        self.header_items = [('pack', urwid.Text('P33k M3M'))]
        self.footer_items = [('pack', urwid.Text('footer'))]
        self.body_data = DataDisplay(self, 256)

        self.body_data_groups = [DataGroup(self, i) for i in range(1, 6)]

        self.body_items = [self.body_data, *self.body_data_groups]
        self.header = urwid.Columns(self.header_items)
        self.footer = urwid.Columns(self.footer_items)
        self.body = DataWritePopup(
            urwid.Filler(urwid.Pile(self.body_items), valign='top'),
        )
        urwid.connect_signal(self.body, 'write', self.__write)
        self.frame = urwid.Frame(
            urwid.AttrMap(self.body, 'body'),
            urwid.AttrMap(self.header, 'head'),
            urwid.AttrMap(self.footer, 'foot'),
        )

        self.config = Config('config.yaml')

        self.config.ensure_path(('selections', ), dict())

        for attr, addrs in self.config['selections'].items():
            for i in addrs:
                self.body_data.attr[i] = attr

    def __write(self, _, offset, value):
        txt = self.footer_items[0][1]
        txt.set_text(repr((offset, [value])))
        txt._invalidate()
        self.dev.write(offset, bytes([value]))

    def update(self):
        self.body_data.update(self.dev.read(0, 256))
        for i, grp in enumerate(self.body_data_groups):
            grp.update(self.body_data.bucketed_data.get(i + 1, []))
        self.body._invalidate()
    def unhandled_input(self, event):
        if event == 'd':
            self.body_data.mode = not self.body_data.mode
            return True
        self.footer_items[0][1].set_text(repr(event))

    def popup(self, offset):
        self.body._offset = offset
        self.body.open_pop_up()
        self.footer_items[0][1].set_text(repr(offset))

    def run(self):
        try:
            evl = urwid.AsyncioEventLoop(loop=asyncio.get_event_loop())
            evl.enter_idle(self.update)
            loop = urwid.MainLoop(
                self.frame,
                (tuple([key, *value]) for key, value in palette.items()),
                event_loop=evl,
                unhandled_input=self.unhandled_input,
                pop_ups=True,
            )
            loop.run()
        except KeyboardInterrupt:
            pass
        selections = {key: set() for key in groups.keys()}
        for i, attr in enumerate(self.body_data.attr):
            if attr is None or attr == 0:
                continue
            attr = abs(attr)
            if attr in selections:
                selections[attr].add(i)
        self.config['selections'] = selections
        self.config.save()


if __name__ == '__main__':
    app = App()
    app.run()

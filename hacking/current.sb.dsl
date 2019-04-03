    Scope (_SB)
    {
        OperationRegion (EH2R, SystemMemory, H2RA, H2RL)
        Field (EH2R, ByteAcc, NoLock, Preserve)
        {
            Offset (0x30),
            BTNS,   8,
            RNGS,   8,
            OBLS,   8,
            Offset (0x40),
            B0BN,   8,
            B0BH,   8,
            B0FQ,   8,
            B0CR,   8,
            B3BN,   8,
            B3BH,   8,
            B3FQ,   8,
            B3CR,   8,
            BHBN,   8,
            BHCR,   8,
            BHBH,   8,
            BSBN,   8,
            BSBH,   8,
            BSFQ,   8,
            BSCR,   8,
            Offset (0x50),
            R0BN,   8,
            R0BH,   8,
            R0FQ,   8,
            R0CR,   8,
            R3BN,   8,
            R3BH,   8,
            R3FQ,   8,
            R3CR,   8,
            RHBN,   8,
            RHCR,   8,
            RHBH,   8,
            RSBN,   8,
            RSBH,   8,
            RSFQ,   8,
            RSCR,   8,
            Offset (0x60),
            O0BN,   8,
            O0BH,   8,
            O0FQ,   8,
            O0CR,   8,
            O3BN,   8,
            O3BH,   8,
            O3FQ,   8,
            O3CR,   8,
            Offset (0x69),
            OHBN,   8,
            OHCR,   8,
            OHBH,   8,
            OSBN,   8,
            OSBH,   8,
            OSFQ,   8,
            OSCR,   8
        }

        Name (TEMP, Buffer (0x05){})
        CreateByteField (TEMP, Zero, TMP0)
        CreateByteField (TEMP, One, TMP1)
        CreateByteField (TEMP, 0x02, TMP2)
        CreateByteField (TEMP, 0x03, TMP3)
        CreateByteField (TEMP, 0x04, TMP4)
        TMP0 = Zero
        TMP1 = Zero
        TMP2 = Zero
        TMP3 = Zero
        TMP4 = Zero
        Method (IDTP, 0, NotSerialized)
        {
            If ((TMP0 == Zero))
            {
                TMP1 = 0x06
            }

            If ((TMP0 == One))
            {
                TMP1 = Zero
            }

            If ((TMP0 == 0x02))
            {
                TMP1 = One
            }

            If ((TMP0 == 0x03))
            {
                TMP1 = 0x04
            }

            Return (Zero)
        }

        Method (IDTR, 0, NotSerialized)
        {
            If ((TMP0 == Zero))
            {
                TMP1 = One
            }

            If ((TMP0 == One))
            {
                TMP1 = 0x02
            }

            If ((TMP0 == 0x04))
            {
                TMP1 = 0x03
            }

            If ((TMP0 == 0x06))
            {
                TMP1 = Zero
            }

            Return (Zero)
        }

        Method (BM2I, 0, NotSerialized)
        {
            Local0 = Zero
            If ((TMP0 == One))
            {
                TMP1 = Zero
                Return (Zero)
            }

            If ((TMP0 == 0x02))
            {
                TMP1 = One
                Return (Zero)
            }

            If ((TMP0 == 0x04))
            {
                TMP1 = 0x02
                Return (Zero)
            }

            If ((TMP0 == 0x08))
            {
                TMP1 = 0x03
                Return (Zero)
            }

            If ((TMP0 == 0x10))
            {
                TMP1 = 0x04
                Return (Zero)
            }

            If ((TMP0 == 0x20))
            {
                TMP1 = 0x05
                Return (Zero)
            }

            If ((TMP0 == 0x40))
            {
                TMP1 = 0x06
                Return (Zero)
            }

            If ((TMP0 == 0x80))
            {
                TMP1 = 0x07
                Return (Zero)
            }
        }

        Method (RC2W, 0, NotSerialized)
        {
            If ((TMP0 == One))
            {
                TMP1 = 0x40
            }

            If ((TMP0 == 0x02))
            {
                TMP1 = 0x10
            }

            If ((TMP0 == 0x03))
            {
                TMP1 = 0x08
            }

            If ((TMP0 == 0x04))
            {
                TMP1 = 0x04
            }

            If ((TMP0 == 0x05))
            {
                TMP1 = One
            }

            If ((TMP0 == 0x06))
            {
                TMP1 = 0x02
            }

            If ((TMP0 == 0x07))
            {
                TMP1 = 0x20
            }

            Return (Zero)
        }

        Method (RC2E, 0, NotSerialized)
        {
            If ((TMP0 == One))
            {
                TMP1 = 0x05
            }

            If ((TMP0 == 0x02))
            {
                TMP1 = 0x06
            }

            If ((TMP0 == 0x04))
            {
                TMP1 = 0x04
            }

            If ((TMP0 == 0x08))
            {
                TMP1 = 0x05
            }

            If ((TMP0 == 0x10))
            {
                TMP1 = 0x02
            }

            If ((TMP0 == 0x20))
            {
                TMP1 = 0x07
            }

            If ((TMP0 == 0x40))
            {
                TMP1 = One
            }

            Return (Zero)
        }

        Method (GLED, 2, NotSerialized)
        {
            CreateDWordField (Arg1, Zero, BUFF)
            If ((BUFF != 0x44534943))
            {
                Return (Zero)
            }

            BUFF = Zero
            CreateByteField (Arg0, Zero, CMD0)
            CreateByteField (Arg0, One, CMD1)
            CreateByteField (Arg0, 0x02, CMD2)
            CreateByteField (Arg0, 0x03, CMD3)
            CreateByteField (Arg1, Zero, BUF0)
            CreateByteField (Arg1, One, BUF1)
            CreateByteField (Arg1, 0x02, BUF2)
            CreateByteField (Arg1, 0x03, BUF3)
            BUF0 = 0xE1
        }

        Method (SLED, 2, NotSerialized)
        {
            CreateDWordField (Arg1, Zero, BUFF)
            If ((BUFF != 0x44534943))
            {
                Return (Zero)
            }

            BUFF = Zero
            CreateByteField (Arg0, Zero, CMD0)
            CreateByteField (Arg0, One, CMD1)
            CreateByteField (Arg0, 0x02, CMD2)
            CreateByteField (Arg0, 0x03, CMD3)
            CreateByteField (Arg1, Zero, BUF0)
            CreateByteField (Arg1, One, BUF1)
            CreateByteField (Arg1, 0x02, BUF2)
            CreateByteField (Arg1, 0x03, BUF3)
            BUF0 = 0xE1
        }

        Method (ECHN, 3, NotSerialized)
        {
            CreateDWordField (Arg2, Zero, BUFF)
            If ((BUFF != 0x44534943))
            {
                Return (Zero)
            }

            BUFF = Zero
            CreateByteField (Arg1, Zero, CMD0)
            CreateByteField (Arg1, One, CMD1)
            CreateByteField (Arg1, 0x02, CMD2)
            CreateByteField (Arg1, 0x03, CMD3)
            CreateByteField (Arg2, Zero, BUF0)
            CreateByteField (Arg2, One, BUF1)
            CreateByteField (Arg2, 0x02, BUF2)
            CreateByteField (Arg2, 0x03, BUF3)
            If ((Arg0 == 0x04))
            {
                BUF0 = Zero
                TMP0 = Zero
                TMP1 = Zero
                BUF0 = Zero
                BUF1 = Zero
                BUF2 = Zero
                BUF3 = Zero
                If ((CMD0 == Zero))
                {
                    If ((CMD1 == Zero))
                    {
                        TMP0 = BTNS /* \_SB_.BTNS */
                        IDTP ()
                    }

                    If ((CMD1 == One))
                    {
                        TMP0 = OBLS /* \_SB_.OBLS */
                        IDTP ()
                    }

                    If ((CMD1 == 0x02))
                    {
                        BUF0 = 0xE1
                    }

                    If ((CMD1 == 0x03))
                    {
                        BUF0 = 0xE1
                    }

                    If ((CMD1 == 0x04))
                    {
                        BUF0 = 0xE1
                    }

                    If ((CMD1 == 0x05))
                    {
                        BUF0 = 0xE1
                    }

                    If ((CMD1 == 0x06))
                    {
                        BUF0 = 0xE1
                    }

                    If ((CMD1 == 0x07))
                    {
                        TMP0 = RNGS /* \_SB_.RNGS */
                        IDTP ()
                    }

                    If ((CMD1 > 0x07))
                    {
                        BUF0 = 0xE4
                    }

                    BUF1 = TMP1 /* \_SB_.TMP1 */
                    Return (Zero)
                }
            }

            If ((Arg0 == 0x06))
            {
                BUF0 = Zero
                If ((CMD0 == Zero))
                {
                    TMP0 = CMD0 /* \_SB_.ECHN.CMD0 */
                    IDTR ()
                    BTNS = TMP1 /* \_SB_.TMP1 */
                    If ((CMD1 == Zero))
                    {
                        If ((CMD2 == Zero))
                        {
                            B0BN = CMD3 /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == One))
                        {
                            B0BH = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == 0x02))
                        {
                            B0FQ = CMD3 /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == 0x03))
                        {
                            B0CR = CMD3 /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == 0x04)){}
                        If ((CMD2 == 0x05)){}
                    }

                    If ((CMD1 == 0x04))
                    {
                        If ((CMD2 == Zero))
                        {
                            BSBN = CMD3 /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == One))
                        {
                            BSBH = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == 0x02))
                        {
                            BSFQ = CMD3 /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == 0x03))
                        {
                            BSCR = CMD3 /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == 0x04)){}
                        If ((CMD2 == 0x05)){}
                    }
                }

                If ((CMD0 == One))
                {
                    TMP0 = CMD0 /* \_SB_.ECHN.CMD0 */
                    IDTR ()
                    OBLS = TMP1 /* \_SB_.TMP1 */
                    If ((CMD1 == Zero))
                    {
                        If ((CMD2 == Zero))
                        {
                            O0BN = CMD3 /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == One))
                        {
                            O0BH = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == 0x02))
                        {
                            O0FQ = CMD3 /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == 0x03))
                        {
                            O0CR = CMD3 /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == 0x04)){}
                        If ((CMD2 == 0x05)){}
                        If ((CMD2 == 0x06))
                        {
                            O3BN = CMD3 /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == 0x07))
                        {
                            O3BH = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == 0x08))
                        {
                            O3FQ = CMD3 /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == 0x09))
                        {
                            O3CR = CMD3 /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == 0x0A)){}
                        If ((CMD2 == 0x0B)){}
                    }

                    If ((CMD1 == 0x04))
                    {
                        If ((CMD2 == Zero))
                        {
                            OSBN = CMD3 /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == One))
                        {
                            OSBH = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == 0x02))
                        {
                            OSFQ = CMD3 /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == 0x03))
                        {
                            OSCR = CMD3 /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == 0x04)){}
                        If ((CMD2 == 0x05)){}
                    }
                }

                If ((CMD0 == 0x02))
                {
                    BUF0 = 0xE1
                }

                If ((CMD0 == 0x03))
                {
                    BUF0 = 0xE1
                }

                If ((CMD0 == 0x04))
                {
                    BUF0 = 0xE1
                }

                If ((CMD0 == 0x05))
                {
                    BUF0 = 0xE1
                }

                If ((CMD0 == 0x06))
                {
                    BUF0 = 0xE1
                }

                If ((CMD0 == 0x07))
                {
                    TMP0 = CMD0 /* \_SB_.ECHN.CMD0 */
                    IDTR ()
                    RNGS = TMP1 /* \_SB_.TMP1 */
                    If ((CMD1 == Zero))
                    {
                        If ((CMD2 == Zero))
                        {
                            R0BN = CMD3 /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == One))
                        {
                            R0BH = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == 0x02))
                        {
                            R0FQ = CMD3 /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == 0x03))
                        {
                            TMP0 = CMD3 /* \_SB_.ECHN.CMD3 */
                            RC2E ()
                            R0CR = TMP1 /* \_SB_.TMP1 */
                        }

                        If ((CMD2 == 0x04)){}
                        If ((CMD2 == 0x05)){}
                        If ((CMD2 == 0x06))
                        {
                            R3BN = CMD3 /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == 0x07))
                        {
                            R3BH = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == 0x08))
                        {
                            R3FQ = CMD3 /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == 0x09))
                        {
                            TMP0 = CMD3 /* \_SB_.ECHN.CMD3 */
                            RC2E ()
                            R3CR = TMP1 /* \_SB_.TMP1 */
                        }

                        If ((CMD2 == 0x0A)){}
                        If ((CMD2 == 0x0B)){}
                    }

                    If ((CMD1 == 0x04))
                    {
                        If ((CMD2 == Zero))
                        {
                            RSBN = CMD3 /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == One))
                        {
                            RSBH = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == 0x02))
                        {
                            RSFQ = CMD3 /* \_SB_.ECHN.CMD3 */
                        }

                        If ((CMD2 == 0x03))
                        {
                            TMP0 = CMD3 /* \_SB_.ECHN.CMD3 */
                            RC2E ()
                            RSCR = TMP1 /* \_SB_.TMP1 */
                        }

                        If ((CMD2 == 0x04)){}
                        If ((CMD2 == 0x05)){}
                    }
                }

                If ((CMD0 > 0x07))
                {
                    BUF0 = 0xE4
                }

                Return (Zero)
            }
        }
    }

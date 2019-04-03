Method (ECHN, 3, NotSerialized)
{
    // Arg0 == Method ID
    // Arg1 == Input
    // Arg2 == Output?
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
    If ((Arg0 == 0x04)) // New Get LED status
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

    If ((Arg0 == 0x06)) // Set the value to the control item of the Indicator option and the LED type
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

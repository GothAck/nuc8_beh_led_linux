Method (ECHN, 3, NotSerialized) // Every other fucking function
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
    If ((Arg0 == 0x03)) // Query LED support capability
    {
        BUF0 = Zero
        If ((CMD0 == Zero)) // List all LED types support in the platform
        {
            DBG8 = 0xEC
            BUF1 = 0x7D // ref table 2.1
            BUF0 = Zero
        }

        If ((CMD0 == One)) // Query to know the LED Color Type for the LED type
        {
            BUF1 = 0x04 // ref table 2.2
            BUF0 = Zero
        }

        If ((CMD0 == 0x02)) // Query to know all Indicator options support for the LED type
        {
            BUF1 = 0x7F // ref table 2.3
            BUF0 = Zero
        }

        If ((CMD0 == 0x03)) // Query to know all Control items support for the Indicator option of
        {
            BUF0 = Zero
            // CMD2 == Index of Indicator option (refer to Table 3.3 LED Indicator options)
            If ((CMD2 == Zero))
            {
                BUF1 = 0xFF
                BUF2 = 0xF0
                BUF3 = Zero
            }

            If ((CMD2 == One))
            {
                BUF1 = 0x1F
                BUF2 = Zero
                BUF3 = Zero
            }

            If ((CMD2 == 0x02))
            {
                BUF1 = 0x1F
                BUF2 = Zero
                BUF3 = Zero
            }

            If ((CMD2 == 0x03))
            {
                BUF1 = 0x0F
                BUF2 = Zero
                BUF3 = Zero
            }

            If ((CMD2 == 0x04))
            {
                BUF1 = 0x3E
                BUF2 = Zero
                BUF3 = Zero
            }

            If ((CMD2 == 0x05))
            {
                BUF1 = 0x1F
                BUF2 = Zero
                BUF3 = Zero
            }

            If ((CMD2 > 0x05))
            {
                BUF0 = 0xE4 // invalid parameter
            }
        }

        Return (Zero)
    }

    If ((Arg0 == 0x04)) // New Get LED status
    {
        BUF0 = Zero
        TMP0 = Zero
        TMP1 = Zero
        BUF0 = Zero
        BUF1 = Zero
        BUF2 = Zero
        BUF3 = Zero
        If ((CMD0 == Zero)) // Get current Indicator option for the LED type
        {
            // CMD1 == Index of LED Type (refer to Table 3.1 LED Type)
            If ((CMD1 == Zero))
            {
                TMP0 = BT00 /* \_SB_.BT00 */
                IDTP () // ID to ?
                BUF1 = TMP1 /* \_SB_.TMP1 */
            }

            If ((CMD1 == One))
            {
                BUF0 = 0xE1 // function not support
            }

            If ((CMD1 == 0x02))
            {
                TMP0 = SK00 /* \_SB_.SK00 */
                IDTP ()
                BUF1 = TMP1 /* \_SB_.TMP1 */
            }

            If ((CMD1 == 0x03))
            {
                TMP0 = EY00 /* \_SB_.EY00 */
                IDTP ()
                BUF1 = TMP1 /* \_SB_.TMP1 */
            }

            If ((CMD1 == 0x04))
            {
                TMP0 = HD00 /* \_SB_.HD00 */
                IDTP ()
                BUF1 = TMP1 /* \_SB_.TMP1 */
            }

            If ((CMD1 == 0x05))
            {
                TMP0 = ET00 /* \_SB_.ET00 */
                IDTP ()
                BUF1 = TMP1 /* \_SB_.TMP1 */
            }

            If ((CMD1 == 0x06))
            {
                TMP0 = PG00 /* \_SB_.PG00 */
                IDTP ()
                BUF1 = TMP1 /* \_SB_.TMP1 */
            }

            If ((CMD1 > 0x06))
            {
                BUF0 = 0xE4 // invalid parameter
            }

            Return (Zero)
        }

        If ((CMD0 == One)) // Get current setting for the control item of the Indicator option and the LED type
        {
            // CMD1 == Index of LED Type (refer to Table 3.1 LED Type)
            If ((CMD1 == Zero))
            {
                // CMD2 == Index of Indicator option (refer to Table 3.3 LED Indicator options)
                If ((CMD2 == Zero)) // ???
                {
                    If ((CMD3 == Zero)) // ???
                    {
                        BUF1 = BT01 /* \_SB_.BT01 */
                    }

                    If ((CMD3 == One))  // red
                    {
                        TMP0 = BT02 /* \_SB_.BT02 */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == 0x02)) // green
                    {
                        BUF1 = BT03 /* \_SB_.BT03 */
                    }

                    If ((CMD3 == 0x03)) // blue
                    {
                        BUF1 = BT18 /* \_SB_.BT18 */
                    }

                    If ((CMD3 == 0x04)) // behavior (0x00 == normally off, on when active)
                    {
                        BUF1 = BT19 /* \_SB_.BT19 */
                    }

                    If ((CMD3 == 0x05)) // ???
                    {
                        BUF1 = BT1A /* \_SB_.BT1A */
                    }

                    If ((CMD3 == 0x06)) // ???
                    {
                        BUF1 = BT05 /* \_SB_.BT05 */
                    }

                    If ((CMD3 == 0x07)) // ???
                    {
                        TMP0 = BT06 /* \_SB_.BT06 */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == 0x08)) // ???
                    {
                        BUF1 = BT07 /* \_SB_.BT07 */
                    }

                    If ((CMD3 == 0x09)) // ???
                    {
                        BUF1 = BT1B /* \_SB_.BT1B */
                    }

                    If ((CMD3 == 0x0A)) // ???
                    {
                        BUF1 = BT1C /* \_SB_.BT1C */
                    }

                    If ((CMD3 == 0x0B)) // ???
                    {
                        BUF1 = BT1D /* \_SB_.BT1D */
                    }
                }

                If ((CMD2 == One))
                {
                    If ((CMD3 == Zero))
                    {
                        BUF1 = BT0D /* \_SB_.BT0D */
                    }

                    If ((CMD3 == One))
                    {
                        BUF1 = BT18 /* \_SB_.BT18 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = BT19 /* \_SB_.BT19 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = BT1A /* \_SB_.BT1A */
                    }

                    If ((CMD3 == 0x04))
                    {
                        TMP0 = BT0E /* \_SB_.BT0E */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }
                }

                If ((CMD2 == 0x02))
                {
                    If ((CMD3 == Zero))
                    {
                        TMP0 = BT10 /* \_SB_.BT10 */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == One))
                    {
                        BUF1 = BT11 /* \_SB_.BT11 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = BT18 /* \_SB_.BT18 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = BT19 /* \_SB_.BT19 */
                    }

                    If ((CMD3 == 0x04))
                    {
                        BUF1 = BT1A /* \_SB_.BT1A */
                    }
                }

                If ((CMD2 == 0x03))
                {
                    If ((CMD3 == Zero))
                    {
                        BUF1 = BT16 /* \_SB_.BT16 */
                    }

                    If ((CMD3 == One))
                    {
                        BUF1 = BT18 /* \_SB_.BT18 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = BT19 /* \_SB_.BT19 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = BT1A /* \_SB_.BT1A */
                    }
                }

                If ((CMD2 == 0x04))
                {
                    If ((CMD3 == One))
                    {
                        TMP0 = BT1E /* \_SB_.BT1E */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = BT1F /* \_SB_.BT1F */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = BT18 /* \_SB_.BT18 */
                    }

                    If ((CMD3 == 0x04))
                    {
                        BUF1 = BT19 /* \_SB_.BT19 */
                    }

                    If ((CMD3 == 0x05))
                    {
                        BUF1 = BT1A /* \_SB_.BT1A */
                    }
                }

                If ((CMD2 == 0x05))
                {
                    If ((CMD3 == Zero))
                    {
                        TMP0 = BT13 /* \_SB_.BT13 */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == One))
                    {
                        BUF1 = BT14 /* \_SB_.BT14 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = BT18 /* \_SB_.BT18 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = BT19 /* \_SB_.BT19 */
                    }

                    If ((CMD3 == 0x04))
                    {
                        BUF1 = BT1A /* \_SB_.BT1A */
                    }
                }
            }

            If ((CMD1 == One)) // 00, 01
            {
                BUF0 = 0xE1 // function not support
            }

            If ((CMD1 == 0x02))
            {
                If ((CMD2 == Zero))
                {
                    If ((CMD3 == Zero))
                    {
                        BUF1 = SK01 /* \_SB_.SK01 */
                    }

                    If ((CMD3 == One))
                    {
                        TMP0 = SK02 /* \_SB_.SK02 */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = SK03 /* \_SB_.SK03 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = SK18 /* \_SB_.SK18 */
                    }

                    If ((CMD3 == 0x04))
                    {
                        BUF1 = SK19 /* \_SB_.SK19 */
                    }

                    If ((CMD3 == 0x05))
                    {
                        BUF1 = SK1A /* \_SB_.SK1A */
                    }

                    If ((CMD3 == 0x06))
                    {
                        BUF1 = SK05 /* \_SB_.SK05 */
                    }

                    If ((CMD3 == 0x07))
                    {
                        TMP0 = SK06 /* \_SB_.SK06 */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == 0x08))
                    {
                        BUF1 = SK07 /* \_SB_.SK07 */
                    }

                    If ((CMD3 == 0x09))
                    {
                        BUF1 = SK1B /* \_SB_.SK1B */
                    }

                    If ((CMD3 == 0x0A))
                    {
                        BUF1 = SK1C /* \_SB_.SK1C */
                    }

                    If ((CMD3 == 0x0B))
                    {
                        BUF1 = SK1D /* \_SB_.SK1D */
                    }
                }

                If ((CMD2 == One))
                {
                    If ((CMD3 == Zero))
                    {
                        BUF1 = SK0D /* \_SB_.SK0D */
                    }

                    If ((CMD3 == One))
                    {
                        BUF1 = SK18 /* \_SB_.SK18 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = SK19 /* \_SB_.SK19 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = SK1A /* \_SB_.SK1A */
                    }

                    If ((CMD3 == 0x04))
                    {
                        TMP0 = SK0E /* \_SB_.SK0E */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }
                }

                If ((CMD2 == 0x02))
                {
                    If ((CMD3 == Zero))
                    {
                        TMP0 = SK10 /* \_SB_.SK10 */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == One))
                    {
                        BUF1 = SK11 /* \_SB_.SK11 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = SK18 /* \_SB_.SK18 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = SK19 /* \_SB_.SK19 */
                    }

                    If ((CMD3 == 0x04))
                    {
                        BUF1 = SK1A /* \_SB_.SK1A */
                    }
                }

                If ((CMD2 == 0x03))
                {
                    If ((CMD3 == Zero))
                    {
                        BUF1 = SK16 /* \_SB_.SK16 */
                    }

                    If ((CMD3 == One))
                    {
                        BUF1 = SK18 /* \_SB_.SK18 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = SK19 /* \_SB_.SK19 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = SK1A /* \_SB_.SK1A */
                    }
                }

                If ((CMD2 == 0x04))
                {
                    If ((CMD3 == One))
                    {
                        TMP0 = SK1E /* \_SB_.SK1E */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = SK1F /* \_SB_.SK1F */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = SK18 /* \_SB_.SK18 */
                    }

                    If ((CMD3 == 0x04))
                    {
                        BUF1 = SK19 /* \_SB_.SK19 */
                    }

                    If ((CMD3 == 0x05))
                    {
                        BUF1 = SK1A /* \_SB_.SK1A */
                    }
                }

                If ((CMD2 == 0x05))
                {
                    If ((CMD3 == Zero))
                    {
                        TMP0 = SK13 /* \_SB_.SK13 */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == One))
                    {
                        BUF1 = SK14 /* \_SB_.SK14 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = SK18 /* \_SB_.SK18 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = SK19 /* \_SB_.SK19 */
                    }

                    If ((CMD3 == 0x04))
                    {
                        BUF1 = SK1A /* \_SB_.SK1A */
                    }
                }
            }

            If ((CMD1 == 0x03))
            {
                If ((CMD2 == Zero))
                {
                    If ((CMD3 == Zero))
                    {
                        BUF1 = EY01 /* \_SB_.EY01 */
                    }

                    If ((CMD3 == One))
                    {
                        TMP0 = EY02 /* \_SB_.EY02 */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = EY03 /* \_SB_.EY03 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = EY18 /* \_SB_.EY18 */
                    }

                    If ((CMD3 == 0x04))
                    {
                        BUF1 = EY19 /* \_SB_.EY19 */
                    }

                    If ((CMD3 == 0x05))
                    {
                        BUF1 = EY1A /* \_SB_.EY1A */
                    }

                    If ((CMD3 == 0x06))
                    {
                        BUF1 = EY05 /* \_SB_.EY05 */
                    }

                    If ((CMD3 == 0x07))
                    {
                        TMP0 = EY06 /* \_SB_.EY06 */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == 0x08))
                    {
                        BUF1 = EY07 /* \_SB_.EY07 */
                    }

                    If ((CMD3 == 0x09))
                    {
                        BUF1 = EY1B /* \_SB_.EY1B */
                    }

                    If ((CMD3 == 0x0A))
                    {
                        BUF1 = EY1C /* \_SB_.EY1C */
                    }

                    If ((CMD3 == 0x0B))
                    {
                        BUF1 = EY1D /* \_SB_.EY1D */
                    }
                }

                If ((CMD2 == One))
                {
                    If ((CMD3 == Zero))
                    {
                        BUF1 = EY0D /* \_SB_.EY0D */
                    }

                    If ((CMD3 == One))
                    {
                        BUF1 = EY18 /* \_SB_.EY18 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = EY19 /* \_SB_.EY19 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = EY1A /* \_SB_.EY1A */
                    }

                    If ((CMD3 == 0x04))
                    {
                        TMP0 = EY0E /* \_SB_.EY0E */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }
                }

                If ((CMD2 == 0x02))
                {
                    If ((CMD3 == Zero))
                    {
                        TMP0 = EY10 /* \_SB_.EY10 */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == One))
                    {
                        BUF1 = EY11 /* \_SB_.EY11 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = EY18 /* \_SB_.EY18 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = EY19 /* \_SB_.EY19 */
                    }

                    If ((CMD3 == 0x04))
                    {
                        BUF1 = EY1A /* \_SB_.EY1A */
                    }
                }

                If ((CMD2 == 0x03))
                {
                    If ((CMD3 == Zero))
                    {
                        BUF1 = EY16 /* \_SB_.EY16 */
                    }

                    If ((CMD3 == One))
                    {
                        BUF1 = EY18 /* \_SB_.EY18 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = EY19 /* \_SB_.EY19 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = EY1A /* \_SB_.EY1A */
                    }
                }

                If ((CMD2 == 0x04))
                {
                    If ((CMD3 == One))
                    {
                        TMP0 = EY1E /* \_SB_.EY1E */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = EY1F /* \_SB_.EY1F */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = EY18 /* \_SB_.EY18 */
                    }

                    If ((CMD3 == 0x04))
                    {
                        BUF1 = EY19 /* \_SB_.EY19 */
                    }

                    If ((CMD3 == 0x05))
                    {
                        BUF1 = EY1A /* \_SB_.EY1A */
                    }
                }

                If ((CMD2 == 0x05))
                {
                    If ((CMD3 == Zero))
                    {
                        TMP0 = EY13 /* \_SB_.EY13 */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == One))
                    {
                        BUF1 = EY14 /* \_SB_.EY14 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = EY18 /* \_SB_.EY18 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = EY19 /* \_SB_.EY19 */
                    }

                    If ((CMD3 == 0x04))
                    {
                        BUF1 = EY1A /* \_SB_.EY1A */
                    }
                }
            }

            If ((CMD1 == 0x04))
            {
                If ((CMD2 == Zero))
                {
                    If ((CMD3 == Zero))
                    {
                        BUF1 = HD01 /* \_SB_.HD01 */
                    }

                    If ((CMD3 == One))
                    {
                        TMP0 = HD02 /* \_SB_.HD02 */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = HD03 /* \_SB_.HD03 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = HD18 /* \_SB_.HD18 */
                    }

                    If ((CMD3 == 0x04))
                    {
                        BUF1 = HD19 /* \_SB_.HD19 */
                    }

                    If ((CMD3 == 0x05))
                    {
                        BUF1 = HD1A /* \_SB_.HD1A */
                    }

                    If ((CMD3 == 0x06))
                    {
                        BUF1 = HD05 /* \_SB_.HD05 */
                    }

                    If ((CMD3 == 0x07))
                    {
                        TMP0 = HD06 /* \_SB_.HD06 */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == 0x08))
                    {
                        BUF1 = HD07 /* \_SB_.HD07 */
                    }

                    If ((CMD3 == 0x09))
                    {
                        BUF1 = HD1B /* \_SB_.HD1B */
                    }

                    If ((CMD3 == 0x0A))
                    {
                        BUF1 = HD1C /* \_SB_.HD1C */
                    }

                    If ((CMD3 == 0x0B))
                    {
                        BUF1 = HD1D /* \_SB_.HD1D */
                    }
                }

                If ((CMD2 == One))
                {
                    If ((CMD3 == Zero))
                    {
                        BUF1 = HD0D /* \_SB_.HD0D */
                    }

                    If ((CMD3 == One))
                    {
                        BUF1 = HD18 /* \_SB_.HD18 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = HD19 /* \_SB_.HD19 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = HD1A /* \_SB_.HD1A */
                    }

                    If ((CMD3 == 0x04))
                    {
                        TMP0 = HD0E /* \_SB_.HD0E */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }
                }

                If ((CMD2 == 0x02))
                {
                    If ((CMD3 == Zero))
                    {
                        TMP0 = HD10 /* \_SB_.HD10 */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == One))
                    {
                        BUF1 = HD11 /* \_SB_.HD11 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = HD18 /* \_SB_.HD18 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = HD19 /* \_SB_.HD19 */
                    }

                    If ((CMD3 == 0x04))
                    {
                        BUF1 = HD1A /* \_SB_.HD1A */
                    }
                }

                If ((CMD2 == 0x03))
                {
                    If ((CMD3 == Zero))
                    {
                        BUF1 = HD16 /* \_SB_.HD16 */
                    }

                    If ((CMD3 == One))
                    {
                        BUF1 = HD18 /* \_SB_.HD18 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = HD19 /* \_SB_.HD19 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = HD1A /* \_SB_.HD1A */
                    }
                }

                If ((CMD2 == 0x04))
                {
                    If ((CMD3 == One))
                    {
                        TMP0 = HD1E /* \_SB_.HD1E */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = HD1F /* \_SB_.HD1F */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = HD18 /* \_SB_.HD18 */
                    }

                    If ((CMD3 == 0x04))
                    {
                        BUF1 = HD19 /* \_SB_.HD19 */
                    }

                    If ((CMD3 == 0x05))
                    {
                        BUF1 = HD1A /* \_SB_.HD1A */
                    }
                }

                If ((CMD2 == 0x05))
                {
                    If ((CMD3 == Zero))
                    {
                        TMP0 = HD13 /* \_SB_.HD13 */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == One))
                    {
                        BUF1 = HD14 /* \_SB_.HD14 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = HD18 /* \_SB_.HD18 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = HD19 /* \_SB_.HD19 */
                    }

                    If ((CMD3 == 0x04))
                    {
                        BUF1 = HD1A /* \_SB_.HD1A */
                    }
                }
            }

            If ((CMD1 == 0x05))
            {
                If ((CMD2 == Zero))
                {
                    If ((CMD3 == Zero))
                    {
                        BUF1 = ET01 /* \_SB_.ET01 */
                    }

                    If ((CMD3 == One))
                    {
                        TMP0 = ET02 /* \_SB_.ET02 */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = ET03 /* \_SB_.ET03 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = ET18 /* \_SB_.ET18 */
                    }

                    If ((CMD3 == 0x04))
                    {
                        BUF1 = ET19 /* \_SB_.ET19 */
                    }

                    If ((CMD3 == 0x05))
                    {
                        BUF1 = ET1A /* \_SB_.ET1A */
                    }

                    If ((CMD3 == 0x06))
                    {
                        BUF1 = ET05 /* \_SB_.ET05 */
                    }

                    If ((CMD3 == 0x07))
                    {
                        TMP0 = ET06 /* \_SB_.ET06 */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == 0x08))
                    {
                        BUF1 = ET07 /* \_SB_.ET07 */
                    }

                    If ((CMD3 == 0x09))
                    {
                        BUF1 = ET1B /* \_SB_.ET1B */
                    }

                    If ((CMD3 == 0x0A))
                    {
                        BUF1 = ET1C /* \_SB_.ET1C */
                    }

                    If ((CMD3 == 0x0B))
                    {
                        BUF1 = ET1D /* \_SB_.ET1D */
                    }
                }

                If ((CMD2 == One))
                {
                    If ((CMD3 == Zero))
                    {
                        BUF1 = ET0D /* \_SB_.ET0D */
                    }

                    If ((CMD3 == One))
                    {
                        BUF1 = ET18 /* \_SB_.ET18 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = ET19 /* \_SB_.ET19 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = ET1A /* \_SB_.ET1A */
                    }

                    If ((CMD3 == 0x04))
                    {
                        TMP0 = ET0E /* \_SB_.ET0E */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }
                }

                If ((CMD2 == 0x02))
                {
                    If ((CMD3 == Zero))
                    {
                        TMP0 = ET10 /* \_SB_.ET10 */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == One))
                    {
                        BUF1 = ET11 /* \_SB_.ET11 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = ET18 /* \_SB_.ET18 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = ET19 /* \_SB_.ET19 */
                    }

                    If ((CMD3 == 0x04))
                    {
                        BUF1 = ET1A /* \_SB_.ET1A */
                    }
                }

                If ((CMD2 == 0x03))
                {
                    If ((CMD3 == Zero))
                    {
                        BUF1 = ET16 /* \_SB_.ET16 */
                    }

                    If ((CMD3 == One))
                    {
                        BUF1 = ET18 /* \_SB_.ET18 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = ET19 /* \_SB_.ET19 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = ET1A /* \_SB_.ET1A */
                    }
                }

                If ((CMD2 == 0x04))
                {
                    If ((CMD3 == One))
                    {
                        TMP0 = ET1E /* \_SB_.ET1E */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = ET1F /* \_SB_.ET1F */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = ET18 /* \_SB_.ET18 */
                    }

                    If ((CMD3 == 0x04))
                    {
                        BUF1 = ET19 /* \_SB_.ET19 */
                    }

                    If ((CMD3 == 0x05))
                    {
                        BUF1 = ET1A /* \_SB_.ET1A */
                    }
                }

                If ((CMD2 == 0x05))
                {
                    If ((CMD3 == Zero))
                    {
                        TMP0 = ET13 /* \_SB_.ET13 */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == One))
                    {
                        BUF1 = ET14 /* \_SB_.ET14 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = ET18 /* \_SB_.ET18 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = ET19 /* \_SB_.ET19 */
                    }

                    If ((CMD3 == 0x04))
                    {
                        BUF1 = ET1A /* \_SB_.ET1A */
                    }
                }
            }

            If ((CMD1 == 0x06))
            {
                If ((CMD2 == Zero))
                {
                    If ((CMD3 == Zero))
                    {
                        BUF1 = PG01 /* \_SB_.PG01 */
                    }

                    If ((CMD3 == One))
                    {
                        TMP0 = PG02 /* \_SB_.PG02 */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = PG03 /* \_SB_.PG03 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = PG18 /* \_SB_.PG18 */
                    }

                    If ((CMD3 == 0x04))
                    {
                        BUF1 = PG19 /* \_SB_.PG19 */
                    }

                    If ((CMD3 == 0x05))
                    {
                        BUF1 = PG1A /* \_SB_.PG1A */
                    }

                    If ((CMD3 == 0x06))
                    {
                        BUF1 = PG05 /* \_SB_.PG05 */
                    }

                    If ((CMD3 == 0x07))
                    {
                        TMP0 = PG06 /* \_SB_.PG06 */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == 0x08))
                    {
                        BUF1 = PG07 /* \_SB_.PG07 */
                    }

                    If ((CMD3 == 0x09))
                    {
                        BUF1 = PG1B /* \_SB_.PG1B */
                    }

                    If ((CMD3 == 0x0A))
                    {
                        BUF1 = PG1C /* \_SB_.PG1C */
                    }

                    If ((CMD3 == 0x0B))
                    {
                        BUF1 = PG1D /* \_SB_.PG1D */
                    }
                }

                If ((CMD2 == One))
                {
                    If ((CMD3 == Zero))
                    {
                        BUF1 = PG0D /* \_SB_.PG0D */
                    }

                    If ((CMD3 == One))
                    {
                        BUF1 = PG18 /* \_SB_.PG18 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = PG19 /* \_SB_.PG19 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = PG1A /* \_SB_.PG1A */
                    }

                    If ((CMD3 == 0x04))
                    {
                        TMP0 = PG0E /* \_SB_.PG0E */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }
                }

                If ((CMD2 == 0x02))
                {
                    If ((CMD3 == Zero))
                    {
                        TMP0 = PG10 /* \_SB_.PG10 */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == One))
                    {
                        BUF1 = PG11 /* \_SB_.PG11 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = PG18 /* \_SB_.PG18 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = PG19 /* \_SB_.PG19 */
                    }

                    If ((CMD3 == 0x04))
                    {
                        BUF1 = PG1A /* \_SB_.PG1A */
                    }
                }

                If ((CMD2 == 0x03))
                {
                    If ((CMD3 == Zero))
                    {
                        BUF1 = PG16 /* \_SB_.PG16 */
                    }

                    If ((CMD3 == One))
                    {
                        BUF1 = PG18 /* \_SB_.PG18 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = PG19 /* \_SB_.PG19 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = PG1A /* \_SB_.PG1A */
                    }
                }

                If ((CMD2 == 0x04))
                {
                    If ((CMD3 == One))
                    {
                        TMP0 = PG1E /* \_SB_.PG1E */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = PG1F /* \_SB_.PG1F */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = PG18 /* \_SB_.PG18 */
                    }

                    If ((CMD3 == 0x04))
                    {
                        BUF1 = PG19 /* \_SB_.PG19 */
                    }

                    If ((CMD3 == 0x05))
                    {
                        BUF1 = PG1A /* \_SB_.PG1A */
                    }
                }

                If ((CMD2 == 0x05))
                {
                    If ((CMD3 == Zero))
                    {
                        TMP0 = PG13 /* \_SB_.PG13 */
                        BM2I () // Bitmap to integer
                        BUF1 = TMP1 /* \_SB_.TMP1 */
                    }

                    If ((CMD3 == One))
                    {
                        BUF1 = PG14 /* \_SB_.PG14 */
                    }

                    If ((CMD3 == 0x02))
                    {
                        BUF1 = PG18 /* \_SB_.PG18 */
                    }

                    If ((CMD3 == 0x03))
                    {
                        BUF1 = PG19 /* \_SB_.PG19 */
                    }

                    If ((CMD3 == 0x04))
                    {
                        BUF1 = PG1A /* \_SB_.PG1A */
                    }
                }
            }

            If ((CMD1 > 0x06))
            {
                BUF0 = 0xE4 // invalid parameter
            }

            Return (Zero)
        }
    }

    If ((Arg0 == 0x05)) // Set an Indicator option for the LED type
    {
        TMP0 = Zero
        TMP1 = Zero
        TMP2 = Zero
        TMP3 = Zero
        BUF0 = Zero
        BUF1 = Zero
        BUF2 = Zero
        BUF3 = Zero
        BUF0 = Zero
        // CMD0 == Index of LED Type (refer to Table 3.1 LED Type)
        If ((CMD0 == Zero))
        {
            If (((BT00 & 0x40) != 0x40))
            {
                BUF0 = 0xE4 // invalid parameter
                Return (Zero)
            }

            TMP0 = CMD1 /* \_SB_.ECHN.CMD1 */
            IDTR ()
            BT00 = TMP1 /* \_SB_.TMP1 */
        }

        If ((CMD0 == One))
        {
            BUF0 = 0xE1 // function not support
        }

        If ((CMD0 == 0x02))
        {
            If (((SK00 & 0x40) != 0x40))
            {
                BUF0 = 0xE4 // invalid parameter
                Return (Zero)
            }

            TMP0 = CMD1 /* \_SB_.ECHN.CMD1 */
            IDTR ()
            SK00 = TMP1 /* \_SB_.TMP1 */
        }

        If ((CMD0 == 0x03))
        {
            If (((EY00 & 0x40) != 0x40))
            {
                BUF0 = 0xE4 // invalid parameter
                Return (Zero)
            }

            TMP0 = CMD1 /* \_SB_.ECHN.CMD1 */
            IDTR ()
            EY00 = TMP1 /* \_SB_.TMP1 */
        }

        If ((CMD0 == 0x04))
        {
            If (((HD00 & 0x40) != 0x40))
            {
                BUF0 = 0xE4 // invalid parameter
                Return (Zero)
            }

            TMP0 = CMD1 /* \_SB_.ECHN.CMD1 */
            IDTR ()
            HD00 = TMP1 /* \_SB_.TMP1 */
        }

        If ((CMD0 == 0x05))
        {
            If (((ET00 & 0x40) != 0x40))
            {
                BUF0 = 0xE4 // invalid parameter
                Return (Zero)
            }

            TMP0 = CMD1 /* \_SB_.ECHN.CMD1 */
            IDTR ()
            ET00 = TMP1 /* \_SB_.TMP1 */
        }

        If ((CMD0 == 0x06))
        {
            If (((PG00 & 0x40) != 0x40))
            {
                BUF0 = 0xE4 // invalid parameter
                Return (Zero)
            }

            TMP0 = CMD1 /* \_SB_.ECHN.CMD1 */
            IDTR ()
            PG00 = TMP1 /* \_SB_.TMP1 */
        }

        If ((CMD1 > 0x06))
        {
            BUF0 = 0xE4 // invalid parameter
        }

        Return (Zero)
    }

    If ((Arg0 == 0x06)) // Set the value to the control item of the Indicator option and the LED type
    {
        BUF0 = Zero
        // CMD0 == Index of LED Type (refer to Table 3.1 LED Type)
        If ((CMD0 == Zero))
        {
            If (((BT00 & 0x40) != 0x40))
            {
                BUF0 = 0xE4 // invalid parameter
                Return (Zero)
            }

            If ((CMD1 == Zero))
            {
                If ((CMD2 == Zero))
                {
                    BT01 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    BT02 = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    BT03 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    BT18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    BT19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x05))
                {
                    BT1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x06))
                {
                    BT05 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x07))
                {
                    BT06 = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x08))
                {
                    BT07 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x09))
                {
                    BT1B = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x0A))
                {
                    BT1C = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x0B))
                {
                    BT1D = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == One))
            {
                If ((CMD2 == Zero))
                {
                    BT0D = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    BT18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    BT19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    BT1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    BT0E = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == 0x02))
            {
                If ((CMD2 == Zero))
                {
                    BT10 = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    BT11 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    BT18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    BT19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    BT1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == 0x03))
            {
                If ((CMD2 == Zero))
                {
                    BT16 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    BT18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    BT19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    BT1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == 0x04))
            {
                If ((CMD2 == One))
                {
                    BT1E = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    BT1F = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    BT18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    BT19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x05))
                {
                    BT1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == 0x05))
            {
                If ((CMD2 == Zero))
                {
                    BT13 = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    BT14 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    BT18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    BT19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    BT1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }
        }

        If ((CMD0 == One))
        {
            BUF0 = 0xE1 // function not support
        }

        If ((CMD0 == 0x02))
        {
            If (((SK00 & 0x40) != 0x40))
            {
                BUF0 = 0xE4 // invalid parameter
                Return (Zero)
            }

            If ((CMD1 == Zero))
            {
                If ((CMD2 == Zero))
                {
                    SK01 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    SK02 = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    SK03 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    SK18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    SK19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x05))
                {
                    SK1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x06))
                {
                    SK05 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x07))
                {
                    SK06 = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x08))
                {
                    SK07 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x09))
                {
                    SK1B = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x0A))
                {
                    SK1C = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x0B))
                {
                    SK1D = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == One))
            {
                If ((CMD2 == Zero))
                {
                    SK0D = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    SK18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    SK19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    SK1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    SK0E = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == 0x02))
            {
                If ((CMD2 == Zero))
                {
                    SK10 = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    SK11 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    SK18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    SK19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    SK1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == 0x03))
            {
                If ((CMD2 == Zero))
                {
                    SK16 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    SK18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    SK19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    SK1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == 0x04))
            {
                If ((CMD2 == One))
                {
                    SK1E = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    SK1F = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    SK18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    SK19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x05))
                {
                    SK1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == 0x05))
            {
                If ((CMD2 == Zero))
                {
                    SK13 = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    SK14 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    SK18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    SK19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    SK1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }
        }

        If ((CMD0 == 0x03))
        {
            If (((EY00 & 0x40) != 0x40))
            {
                BUF0 = 0xE4 // invalid parameter
                Return (Zero)
            }

            If ((CMD1 == Zero))
            {
                If ((CMD2 == Zero))
                {
                    EY01 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    EY02 = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    EY03 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    EY18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    EY19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x05))
                {
                    EY1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x06))
                {
                    EY05 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x07))
                {
                    EY06 = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x08))
                {
                    EY07 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x09))
                {
                    EY1B = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x0A))
                {
                    EY1C = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x0B))
                {
                    EY1D = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == One))
            {
                If ((CMD2 == Zero))
                {
                    EY0D = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    EY18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    EY19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    EY1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    EY0E = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == 0x02))
            {
                If ((CMD2 == Zero))
                {
                    EY10 = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    EY11 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    EY18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    EY19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    EY1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == 0x03))
            {
                If ((CMD2 == Zero))
                {
                    EY16 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    EY18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    EY19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    EY1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == 0x04))
            {
                If ((CMD2 == One))
                {
                    EY1E = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    EY1F = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    EY18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    EY19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x05))
                {
                    EY1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == 0x05))
            {
                If ((CMD2 == Zero))
                {
                    EY13 = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    EY14 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    EY18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    EY19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    EY1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }
        }

        If ((CMD0 == 0x04))
        {
            If (((HD00 & 0x40) != 0x40))
            {
                BUF0 = 0xE4 // invalid parameter
                Return (Zero)
            }

            If ((CMD1 == Zero))
            {
                If ((CMD2 == Zero))
                {
                    HD01 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    HD02 = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    HD03 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    HD18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    HD19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x05))
                {
                    HD1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x06))
                {
                    HD05 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x07))
                {
                    HD06 = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x08))
                {
                    HD07 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x09))
                {
                    HD1B = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x0A))
                {
                    HD1C = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x0B))
                {
                    HD1D = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == One))
            {
                If ((CMD2 == Zero))
                {
                    HD0D = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    HD18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    HD19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    HD1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    HD0E = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == 0x02))
            {
                If ((CMD2 == Zero))
                {
                    HD10 = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    HD11 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    HD18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    HD19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    HD1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == 0x03))
            {
                If ((CMD2 == Zero))
                {
                    HD16 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    HD18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    HD19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    HD1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == 0x04))
            {
                If ((CMD2 == One))
                {
                    HD1E = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    HD1F = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    HD18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    HD19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x05))
                {
                    HD1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == 0x05))
            {
                If ((CMD2 == Zero))
                {
                    HD13 = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    HD14 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    HD18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    HD19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    HD1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }
        }

        If ((CMD0 == 0x05))
        {
            If (((ET00 & 0x40) != 0x40))
            {
                BUF0 = 0xE4 // invalid parameter
                Return (Zero)
            }

            If ((CMD1 == Zero))
            {
                If ((CMD2 == Zero))
                {
                    ET01 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    ET02 = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    ET03 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    ET18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    ET19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x05))
                {
                    ET1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x06))
                {
                    ET05 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x07))
                {
                    ET06 = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x08))
                {
                    ET07 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x09))
                {
                    ET1B = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x0A))
                {
                    ET1C = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x0B))
                {
                    ET1D = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == One))
            {
                If ((CMD2 == Zero))
                {
                    ET0D = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    ET18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    ET19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    ET1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    ET0E = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == 0x02))
            {
                If ((CMD2 == Zero))
                {
                    ET10 = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    ET11 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    ET18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    ET19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    ET1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == 0x03))
            {
                If ((CMD2 == Zero))
                {
                    ET16 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    ET18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    ET19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    ET1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == 0x04))
            {
                If ((CMD2 == One))
                {
                    ET1E = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    ET1F = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    ET18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    ET19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x05))
                {
                    ET1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == 0x05))
            {
                If ((CMD2 == Zero))
                {
                    ET13 = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    ET14 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    ET18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    ET19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    ET1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }
        }

        If ((CMD0 == 0x06))
        {
            If (((PG00 & 0x40) != 0x40))
            {
                BUF0 = 0xE4 // invalid parameter
                Return (Zero)
            }

            If ((CMD1 == Zero))
            {
                If ((CMD2 == Zero))
                {
                    PG01 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    PG02 = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    PG03 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    PG18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    PG19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x05))
                {
                    PG1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x06))
                {
                    PG05 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x07))
                {
                    PG06 = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x08))
                {
                    PG07 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x09))
                {
                    PG1B = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x0A))
                {
                    PG1C = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x0B))
                {
                    PG1D = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == One))
            {
                If ((CMD2 == Zero))
                {
                    PG0D = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    PG18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    PG19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    PG1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    PG0E = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == 0x02))
            {
                If ((CMD2 == Zero))
                {
                    PG10 = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    PG11 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    PG18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    PG19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    PG1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == 0x03))
            {
                If ((CMD2 == Zero))
                {
                    PG16 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    PG18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    PG19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    PG1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == 0x04))
            {
                If ((CMD2 == One))
                {
                    PG1E = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    PG1F = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    PG18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    PG19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x05))
                {
                    PG1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }

            If ((CMD1 == 0x05))
            {
                If ((CMD2 == Zero))
                {
                    PG13 = (One << CMD3) /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == One))
                {
                    PG14 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x02))
                {
                    PG18 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x03))
                {
                    PG19 = CMD3 /* \_SB_.ECHN.CMD3 */
                }

                If ((CMD2 == 0x04))
                {
                    PG1A = CMD3 /* \_SB_.ECHN.CMD3 */
                }
            }
        }

        If ((CMD1 > 0x06))
        {
            BUF0 = 0xE4 // invalid parameter
        }

        Return (Zero)
    }

    If ((Arg0 == 0x07)) // Notification of LED App
    {
        If ((CMD0 == One)) // Notification for saving all LED configurations
        {
            TMP0 = (E5FF | 0x02)
            E5FF = TMP0 /* \_SB_.TMP0 */
            BUF0 = Zero
            Return (Zero)
        }

        BUF0 = 0xE1 // function not support
        Return (Zero)
    }
}

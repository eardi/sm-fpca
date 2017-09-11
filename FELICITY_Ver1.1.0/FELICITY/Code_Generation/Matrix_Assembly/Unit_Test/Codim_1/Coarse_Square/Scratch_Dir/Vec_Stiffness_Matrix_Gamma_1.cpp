
    // Copy the other sub-matrix
    for (unsigned int j = 0; j < COL_NB; j++)
        {
        for (unsigned int i = 0; i < ROW_NB; i++)
            {
            A[j*ROW_NB + i] = SubMAT_Info[0].Local_Mat_Data[j*ROW_NB + i];
            }
        }

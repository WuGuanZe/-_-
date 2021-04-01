# 碩士論文_實驗成果

MRI_gland_seg程式說明

乳腺切割步驟(格式:[目錄]程式名稱)

1.使用 DICOMViewer.m 整理 DICOM 影像，rename 到同一目錄中準備進行處理

2.使用 dicom_test.m 讀入 DICOM 影像目錄，乳房區域切割成功後輸出 'breast_area.mat' (乳房區域)

3_1.若乳房區域切割不佳，使用 read_mat.m ，讀入 'breast_area.mat' ，輸出 'breast_area.raw' (乳房區域 Binary Raw Image)，再用 ITK-SNAP 讀入 DICOM 影像目錄與 'breast_area.raw' 修正後輸  
    出 'breast_area.nii' (NiTFI 格式乳房區域）

3_2.若乳房區域切割失敗，可用 ITK-SNAP 手動產生 'breast_area.nii' (NiTFI 格式乳房區域)

4.若是 3_1 與 3_2 情形，使用 nii2mat.m，讀入 'breast_area.nii' 轉輸出成 'breast_area_nii.mat' (修正後乳房區域)

5.使用 breast_split.m ，讀入 'breast_area.mat' 或 'breast_area_nii.mat' ，分開左右乳房區域，產生 'breast_left.mat' (左乳房） 'breast_right.mat' (右乳房）

6.使用 mri_gland_segv5_fullautomatic.m 或 mri_gland_segv5_semiautomatic.m ，讀入 DICOM 影像目錄與左右乳房區域 .mat 進行乳腺切割，輸出乳房、乳腺體積與密度

註：
    mri_gland_segv5_fullautomatic - 計算三維乳腺區域的質心，當種子點作區域成長法 (Region Growing)
    mri_gland_segv5_semiautomatic - 手動選擇一個初始的種子點，並計算 7x7x7 範圍內的所有種子點 Max、Min、Mean 數值 ，然後利用 Mean 的數
                                    值當成種子點作區域成長法 (Region Growing)

select [Loan_Type], [USD], [EUR], [UAH] from
(select [Principal_UAH_Amount], [Loan_Type], [Orig_Ccy] from [dbo].[V_Loans_LLP_Detailed]) as Data_Source
pivot( sum([Principal_UAH_Amount]) for [Orig_Ccy] in ([USD], [EUR], [UAH])) as Pivot_Table;
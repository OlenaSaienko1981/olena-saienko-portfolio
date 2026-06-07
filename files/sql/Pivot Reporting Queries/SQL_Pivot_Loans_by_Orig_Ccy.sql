select [Customer_Name], [UAH], [USD], [EUR] from
(select [Principal_UAH_Amount], [Customer_Name], [Orig_Ccy] from [dbo].[V_Loans_LLP_Detailed]) as Data_Source
pivot( sum([Principal_UAH_Amount]) for [Orig_Ccy] in ([UAH], [USD], [EUR])) as Pivot_Table;
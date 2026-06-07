select [Orig_Ccy], [Less than 1 Month], [1-3 Months], [3-6 Months], [6-12 Months], [1-5 Years] from
(select [Principal_UAH_Amount], [Orig_Ccy], [Remaining_Days_Type] from [dbo].[V_Loans_LLP_Detailed]) as Data_Source
pivot( sum([Principal_UAH_Amount]) for [Remaining_Days_Type] in ([Less than 1 Month], [1-3 Months], [3-6 Months], 
[6-12 Months], [1-5 Years])) as Pivot_Table;
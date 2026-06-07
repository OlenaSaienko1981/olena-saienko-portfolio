select [Orig_Ccy], count([Tranche_ID]) as Number_of_Tranches, count(distinct [Customer_ID]) as Number_of_Customers
from [dbo].[Loans]
group by [Orig_Ccy];
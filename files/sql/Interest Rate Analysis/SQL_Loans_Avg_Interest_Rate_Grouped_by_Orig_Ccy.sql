select [Orig_Ccy], avg([Interest_Rate]) as Avg_Interest_Rate 
from [dbo].[Loans]
group by [Orig_Ccy];
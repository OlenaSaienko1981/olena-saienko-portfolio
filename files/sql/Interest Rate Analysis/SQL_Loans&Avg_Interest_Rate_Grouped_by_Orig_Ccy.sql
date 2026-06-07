select [dbo].[Loans].Orig_Ccy, sum([dbo].[Loans].Orig_Amount * [dbo].[FX_exch_rates].FX_exch_rate) as Total_UAH_Amount,
avg([dbo].[Loans].Interest_Rate) as Interest_Rate 
from [dbo].[Loans]
inner join [dbo].[FX_exch_rates]
on [dbo].[FX_exch_rates].Orig_Ccy = [dbo].[Loans].Orig_Ccy
group by [dbo].[Loans].Orig_Ccy;
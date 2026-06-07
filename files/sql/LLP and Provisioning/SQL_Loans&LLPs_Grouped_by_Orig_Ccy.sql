select [dbo].[Loans].Orig_Ccy, sum([dbo].[Loans].Orig_Amount * [dbo].[FX_exch_rates].FX_exch_rate) as Gross_Loans,
sum([dbo].[LLPs].Orig_Amount * [dbo].[FX_exch_rates].FX_exch_rate) as Provisions, 
sum([dbo].[Loans].Orig_Amount * [dbo].[FX_exch_rates].FX_exch_rate) - 
sum([dbo].[LLPs].Orig_Amount * [dbo].[FX_exch_rates].FX_exch_rate)
as Net_Loans 
from [dbo].[Loans]
inner join [dbo].[LLPs]
on [dbo].[LLPs].Tranche_ID = [dbo].[Loans].Tranche_ID
inner join [dbo].[FX_exch_rates]
on [dbo].[FX_exch_rates].Orig_Ccy = [dbo].[Loans].Orig_Ccy
group by [dbo].[Loans].Orig_Ccy;
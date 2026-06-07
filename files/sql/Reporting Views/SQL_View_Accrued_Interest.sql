create view V_Accrued_Interest
as
select [dbo].[Accrued_Interest].Orig_Ccy, [dbo].[Accrued_Interest].Orig_Amount, 
[dbo].[Accrued_Interest].Orig_Amount * [dbo].[FX_exch_rates].FX_exch_rate as Accrued_Interest_UAH_Amount, 
substring ([dbo].[Accrued_Interest].Description, 21, 12) as Tranche_ID
from [dbo].[Accrued_Interest]
join [dbo].[FX_exch_rates]
on [dbo].[FX_exch_rates].Orig_Ccy = [dbo].[Accrued_Interest].Orig_Ccy
select Ccy_Type = case [dbo].[Loans].Orig_Ccy
when 'USD' then 'FX'
when 'EUR' then 'FX'
else 'UAH'
end,
sum([dbo].[Loans].Orig_Amount * [dbo].[FX_exch_rates].FX_exch_rate) as Total_Principal_UAH_Amount,
sum([dbo].[LLPs].Orig_Amount * [dbo].[FX_exch_rates].FX_exch_rate) as Total_LLP_Amount 
from [dbo].[Loans]
inner join [dbo].[LLPs]
on [dbo].[LLPs].Tranche_ID = [dbo].[Loans].Tranche_ID
inner join [dbo].[FX_exch_rates]
on [dbo].[FX_exch_rates].Orig_Ccy = [dbo].[Loans].Orig_Ccy
group by case [dbo].[Loans].Orig_Ccy
when 'USD' then 'FX'
when 'EUR' then 'FX'
else 'UAH'
end;





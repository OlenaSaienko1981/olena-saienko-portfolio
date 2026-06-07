select Aging_Detail = case
when datediff(day, [End_Date], '2020.11.30') <= 0 then 'No Delay'
when datediff(day, [End_Date], '2020.11.30') > 0 and datediff(day, [End_Date], '2020.11.30') <= 90 then 'Delayed under 90'
when datediff(day, [End_Date], '2020.11.30') > 90 and datediff(day, [End_Date], '2020.11.30') <= 360 then 'Impaired 90-360'
else 'Impaired over 360'
end,
sum([dbo].[Loans].Orig_Amount * [dbo].[FX_exch_rates].FX_exch_rate) as Gross_Loans, 
sum([dbo].[LLPs].Orig_Amount * [dbo].[FX_exch_rates].FX_exch_rate) as Provisions,
sum([dbo].[Loans].Orig_Amount * [dbo].[FX_exch_rates].FX_exch_rate) - 
sum([dbo].[LLPs].Orig_Amount * [dbo].[FX_exch_rates].FX_exch_rate)
as Net_Loans
from [dbo].[Loans]
inner join [dbo].[LLPs]
on [dbo].[LLPs].Tranche_ID = [dbo].[Loans].Tranche_ID
inner join [dbo].[FX_exch_rates]
on [dbo].[FX_exch_rates].Orig_Ccy = [dbo].[Loans].Orig_Ccy
group by case
when datediff(day, [End_Date], '2020.11.30') <= 0 then 'No Delay'
when datediff(day, [End_Date], '2020.11.30') > 0 and datediff(day, [End_Date], '2020.11.30') <= 90 then 'Delayed under 90'
when datediff(day, [End_Date], '2020.11.30') > 90 and datediff(day, [End_Date], '2020.11.30') <= 360 then 'Impaired 90-360'
else 'Impaired over 360'
end;
WITH hotelCTE as (
SELECT *
FROM dbo.[2018]
UNION
SELECT *
FROM dbo.[2019]
UNION 
SELECT *
FROM dbo.[2020]
)
SELECT *
FROM hotelCTE
LEFT JOIN dbo.market_segment
ON hotelCTE.market_segment = market_segment.market_segment
LEFT JOIN dbo.meal_cost
ON hotelCTE.meal = meal_cost.meal



-- First query to get revenue
SELECT ROUND(SUM((stays_in_week_nights + stays_in_weekend_nights)* adr),0) AS 'Revenue',
		arrival_date_year as 'Year',
		hotel as 'Hotel_type'
FROM hotelCTE
GROUP BY arrival_date_year, hotel
ORDER BY arrival_date_year ASC;


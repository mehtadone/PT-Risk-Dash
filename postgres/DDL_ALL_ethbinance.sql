--*******************ethbinance
CREATE SCHEMA IF NOT EXISTS ethbinance;

GRANT USAGE ON SCHEMA ethbinance TO grafanareader;

--*************
--Historical totals
--*************
--DROP TABLE IF EXISTS ethbinance.hist_totals CASCADE;
CREATE TABLE ethbinance.hist_totals (
	id BIGSERIAL NOT NULL CONSTRAINT hist_totals_pk PRIMARY KEY
  , created_at TIMESTAMP
  , balance NUMERIC
  , totalPairsCurrentValue NUMERIC
  , totalPairsRealCost NUMERIC
  , totalDCACurrentValue NUMERIC
  , totalDCARealCost NUMERIC
  , totalPendingCurrentValue NUMERIC
  , totalPendingTargetPrice NUMERIC
  , totalProfitYesterday NUMERIC
  , totalProfitToday NUMERIC
  , totalProfitWeek NUMERIC
  , version TEXT
  , market TEXT
  , sitename TEXT
  , exchangeUrl TEXT
  , exchange TEXT
  , ETHUSDTPrice NUMERIC
  , ETHUSDTPercChange NUMERIC
  , BTCUSDTPrice NUMERIC
  , BTCUSDTPercChange NUMERIC
  , timeZoneOffset TEXT
  , pendingOrderTime TEXT
);

COMMENT ON TABLE ethbinance.hist_totals IS 'Historical totals';
COMMENT ON COLUMN ethbinance.hist_totals.id IS 'The primary key for the record.';
COMMENT ON COLUMN ethbinance.hist_totals.created_at IS 'Datetime that the event was recorded.';
--SELECT * FROM ethbinance.hist_totals
--*************


--*************
--Historical sells
--*************
--DROP TABLE IF EXISTS ethbinance.hist_sells CASCADE;
CREATE TABLE ethbinance.hist_sells (
	id BIGSERIAL NOT NULL CONSTRAINT hist_sells_pk PRIMARY KEY
  , created_at TIMESTAMP
  , soldAmount NUMERIC
  , soldDate TIMESTAMP
  , boughtTimes NUMERIC
  , market TEXT
  , profit NUMERIC
  , avg_totalCost NUMERIC
  , avg_totalAmount NUMERIC
  , avg_totalAmountWithSold NUMERIC
  , avg_avgPrice NUMERIC
  , avg_avgCost NUMERIC
  , avg_firstBoughtDate TIMESTAMP
  , avg_totalWeightedPrice NUMERIC
  , avg_orderNumber NUMERIC
  , avg_fee NUMERIC
  , currentPrice NUMERIC
  , sellStrategy TEXT
  , volume NUMERIC
  , triggerValue NUMERIC
  , percChange NUMERIC
);

COMMENT ON TABLE ethbinance.hist_sells IS 'Historical sells';
COMMENT ON COLUMN ethbinance.hist_sells.id IS 'The primary key for the record.';
COMMENT ON COLUMN ethbinance.hist_sells.created_at IS 'Datetime that the event was recorded.';

--SELECT * FROM ethbinance.hist_sells

--*************
--logs
--*************
--DROP TABLE IF EXISTS ethbinance.logs CASCADE;
CREATE TABLE ethbinance.logs (
  id BIGSERIAL NOT NULL CONSTRAINT logs_pk PRIMARY KEY
  , started_at TIMESTAMP
  , finished_at TIMESTAMP
  , script_name TEXT
  , host TEXT
  , port TEXT
  , schema_name TEXT
);

--select * from ethbinance.logs
--*************


--*************
--Historical gains(pairs)
--*************
--DROP TABLE IF EXISTS ethbinance.hist_gains CASCADE;
CREATE TABLE ethbinance.hist_gains (
  id BIGSERIAL NOT NULL CONSTRAINT hist_gains_pk PRIMARY KEY
  , created_at TIMESTAMP
  , combinedProfit NUMERIC
  , market TEXT
  , profit NUMERIC
  , avg_totalCost NUMERIC
  , avg_totalAmount NUMERIC
  , avg_totalAmountWithSold NUMERIC
  , avg_avgPrice NUMERIC 
  , avg_avgCost NUMERIC
  , avg_firstBoughtDate TIMESTAMP
  , avg_totalWeightedPrice NUMERIC
  , avg_orderNumber NUMERIC
  , avg_fee NUMERIC
  , currentPrice NUMERIC
  , sellStrategy TEXT
  , volume NUMERIC
  , triggerValue NUMERIC
  , percChange NUMERIC
);

COMMENT ON TABLE ethbinance.hist_gains IS 'Historical gains';
COMMENT ON COLUMN ethbinance.hist_gains.id IS 'The primary key for the record.';
COMMENT ON COLUMN ethbinance.hist_gains.created_at IS 'Datetime that the event was recorded.';

--SELECT * FROM ethbinance.hist_gains
--*************

--*************
--Historical dca(pairs)
--*************
--DROP TABLE IF EXISTS ethbinance.hist_dca CASCADE;
CREATE TABLE ethbinance.hist_dca (
  id BIGSERIAL NOT NULL CONSTRAINT hist_dca_pk PRIMARY KEY
  , created_at TIMESTAMP
  , BBLow NUMERIC
  , BBTrigger NUMERIC
  , positive TEXT
  , highbb NUMERIC
  , boughtTimes NUMERIC
  , buyProfit NUMERIC
  , lastOrderNumber TEXT
  , unfilledAmount NUMERIC
  , market TEXT
  , profit NUMERIC
  , avg_totalCost NUMERIC
  , avg_totalAmount NUMERIC
  , avg_totalAmountWithSold NUMERIC
  , avg_avgPrice NUMERIC
  , avg_avgCost NUMERIC
  , avg_firstBoughtDate TIMESTAMP
  , avg_totalWeightedPrice NUMERIC
  , avg_orderNumber NUMERIC
  , avg_fee NUMERIC
  , currentPrice NUMERIC
  , sellStrategy TEXT
  , buyStrategy TEXT
  , volume NUMERIC
  , triggerValue NUMERIC
  , percChange NUMERIC
);

COMMENT ON TABLE ethbinance.hist_dca IS 'Historical dca';
COMMENT ON COLUMN ethbinance.hist_dca.id IS 'The primary key for the record.';
COMMENT ON COLUMN ethbinance.hist_dca.created_at IS 'Datetime that the event was recorded.';

--SELECT * FROM ethbinance.hist_dca
--*************


--DROP TABLE IF EXISTS ethbinance.hist_sells CASCADE;
CREATE TABLE ethbinance.hist_prices (
	id BIGSERIAL NOT NULL CONSTRAINT hist_prices_pk PRIMARY KEY
  , created_at TIMESTAMP
  , GBP NUMERIC
  , USD NUMERIC
  , EUR NUMERIC
);

COMMENT ON TABLE ethbinance.hist_prices IS 'Historical pricess';
COMMENT ON COLUMN ethbinance.hist_prices.id IS 'The primary key for the record.';
COMMENT ON COLUMN ethbinance.hist_prices.created_at IS 'Datetime that the event was recorded.';

--SELECT * FROM ethbinance.hist_prices

--Panel:Current DCA Log
--DROP TABLE IF EXISTS ethbinance.dash002_tracker_logs_001_dca CASCADE;
CREATE TABLE ethbinance.dash002_tracker_logs_001_dca (
  coin TEXT
  , dca_level NUMERIC
  , gain_loss NUMERIC
  , avg_price NUMERIC
  , avg_cost NUMERIC
  , days_in_dca NUMERIC
  , current_price NUMERIC
  , sell_strategy TEXT
  , profit_sell_trigger NUMERIC
  , daily_change NUMERIC
);

--Panel:Current Pairs Log
--DROP TABLE IF EXISTS ethbinance.dash002_tracker_logs_002_pairs CASCADE;
CREATE TABLE ethbinance.dash002_tracker_logs_002_pairs (
  coin TEXT
  , dca_level NUMERIC
  , gain_loss NUMERIC
  , avg_price NUMERIC
  , avg_cost NUMERIC
  , days_in_dca NUMERIC
  , current_price NUMERIC
  , sell_strategy TEXT
  , profit_sell_trigger NUMERIC
  , daily_change NUMERIC
);

--Panel:Sell Log
--DROP TABLE IF EXISTS ethbinance.dash002_tracker_logs_003_sell CASCADE;
CREATE TABLE ethbinance.dash002_tracker_logs_003_sell (
  id BIGSERIAL NOT NULL CONSTRAINT dash002_tracker_logs_003_sell_pk PRIMARY KEY
  , soldDate TIMESTAMP
  , soldAmount NUMERIC
  , market TEXT
  , currentPrice NUMERIC
  
  , dca_level NUMERIC
  , profit NUMERIC
  , avg_price NUMERIC
  , avg_cost NUMERIC
  , first_purchased TIMESTAMP
  , sell_strategy TEXT
  , sell_trigger NUMERIC
  , fee NUMERIC
  
  , CONSTRAINT unique_dash002_tracker_logs_003_sell UNIQUE (soldDate, soldAmount, market, currentPrice)
);

--Panel:Profits
--DROP TABLE IF EXISTS ethbinance.dash002_tracker_logs_004_profits CASCADE;

CREATE TABLE ethbinance.dash002_tracker_logs_004_profits (
  dt TIMESTAMP NOT NULL CONSTRAINT dash002_tracker_logs_004_profits_pk PRIMARY KEY 
  , profit_c NUMERIC --SUM((currentPrice * soldAmount * 0.998) - (avg_avgPrice * soldAmount))
  --v1.1
  , GBP NUMERIC
  , USD NUMERIC
  , EUR NUMERIC
  , profit_c_GBP NUMERIC
  , Unrealised_PnL NUMERIC
  , Unrealised_PnL_GBP NUMERIC
  , total_current_value NUMERIC
  , profit_c_percent NUMERIC
  , nbr_trans NUMERIC
);


--******************************
--update function
--******************************
CREATE OR REPLACE FUNCTION ethbinance.dash002_tracker_logs_upd (
  p_update_datetime TIMESTAMP
  , p_begin_sales_date TIMESTAMP DEFAULT NULL --if need upadate Sales from another period
) RETURNS TEXT AS $$
DECLARE
  -- v1.00 first release
  v_begin_update_sales_date TIMESTAMP;
  v_ret TEXT;

  v_update_datetime TIMESTAMP;
BEGIN

  IF p_begin_sales_date IS NULL THEN
    v_begin_update_sales_date := p_update_datetime;
  ELSE
    v_begin_update_sales_date := p_begin_sales_date;
  END IF;
  
  v_update_datetime := p_update_datetime;

--Panel:Current DCA Log
  TRUNCATE TABLE ethbinance.dash002_tracker_logs_001_dca;
  
  INSERT INTO ethbinance.dash002_tracker_logs_001_dca(
    coin
    , dca_level
    , gain_loss
    , avg_price
    , avg_cost
    , days_in_dca
    , current_price
    , sell_strategy
    , profit_sell_trigger
    , daily_change
  )
  SELECT 
    market AS coin
    , boughtTimes AS dca_level
    , profit AS gain_loss
    , avg_avgPrice AS avg_price
    , avg_avgCost AS avg_cost
    --($today - $tmpfirstBought)/(60 * 60 * 24); 
    , (EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) - EXTRACT(EPOCH FROM avg_firstBoughtDate))/(60 * 60 * 24) AS days_in_dca
    , currentPrice AS current_price
    , sellStrategy AS sell_strategy
    , triggerValue AS profit_sell_trigger
    , percChange AS daily_change
  FROM ethbinance.hist_dca h
  WHERE h.created_at = (SELECT created_at FROM ethbinance.hist_dca WHERE created_at >= v_update_datetime ORDER BY created_at DESC LIMIT 1);
  
--Panel:Current Pairs Log
  TRUNCATE TABLE ethbinance.dash002_tracker_logs_002_pairs;
  
  INSERT INTO ethbinance.dash002_tracker_logs_002_pairs(
    coin
    , dca_level
    , gain_loss
    , avg_price
    , avg_cost
    , days_in_dca
    , current_price
    , sell_strategy
    , profit_sell_trigger
    , daily_change
  )
  SELECT 
    market AS coin
    , NULL AS dca_level
    , profit AS gain_loss
    , avg_avgPrice AS avg_price
    , avg_avgCost AS avg_cost
    --($today - $tmpfirstBought)/(60 * 60 * 24); 
    , (EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) - EXTRACT(EPOCH FROM avg_firstBoughtDate))/(60 * 60 * 24) AS days_in_dca
    , currentPrice AS current_price
    , sellStrategy AS sell_strategy
    , triggerValue AS profit_sell_trigger
    , percChange AS daily_change
  FROM ethbinance.hist_gains h
  WHERE h.created_at = (SELECT created_at FROM ethbinance.hist_gains WHERE created_at >= v_update_datetime ORDER BY created_at DESC LIMIT 1);

--Panel:Sell Log 
  INSERT INTO ethbinance.dash002_tracker_logs_003_sell (
    soldDate
    , soldAmount
    , market
    , currentPrice
    
    , dca_level
    , profit
    , avg_price
    , avg_cost
    , first_purchased
    , sell_strategy
    , sell_trigger
    , fee
  )
  SELECT soldDate
    , soldAmount
    , market
    , currentPrice
    
    , boughtTimes AS dca_level
    , profit AS profit
    , avg_avgPrice AS avg_price
    , avg_avgCost AS avg_cost
    , avg_firstBoughtDate AS first_purchased
    , sellStrategy AS sell_strategy
    , triggerValue AS sell_trigger
    , avg_fee AS fee
  FROM (
    SELECT h.*
      , ROW_NUMBER() OVER (PARTITION BY soldDate, soldAmount, market, currentPrice ORDER BY h.created_at DESC) rn
    FROM ethbinance.hist_sells h
    --WHERE h.created_at >= v_begin_update_sales_date
  ) c
  WHERE rn = 1
  ON CONFLICT (soldDate, soldAmount, market, currentPrice) 
    DO UPDATE SET
     dca_level = EXCLUDED.dca_level
    , profit = EXCLUDED.profit
    , avg_price = EXCLUDED.avg_price
    , avg_cost = EXCLUDED.avg_cost
    , first_purchased = EXCLUDED.first_purchased
    , sell_strategy = EXCLUDED.sell_strategy
    , sell_trigger = EXCLUDED.sell_trigger
    , fee = EXCLUDED.fee
  ;
  
  TRUNCATE TABLE ethbinance.dash002_tracker_logs_004_profits;
  
  INSERT INTO ethbinance.dash002_tracker_logs_004_profits(
    dt
    , profit_c
    , GBP
    , USD
    , EUR
    , profit_c_GBP
    , Unrealised_PnL
    , Unrealised_PnL_GBP
    , total_current_value
    , profit_c_percent
    , nbr_trans
  )
  SELECT st.dt
    , st.profit_c
    , pr.GBP
    , pr.USD
    , pr.EUR
    , st.profit_c*pr.GBP profit_c_GBP
    , st.Unrealised_PnL
    , st.Unrealised_PnL*pr.GBP Unrealised_PnL_GBP
    , st.total_current_value
    , st.profit_c*100.0/NULLIF(st.total_current_value,0) profit_c_percent
    , st.nbr_trans
  FROM (
    SELECT COALESCE(s.dt,t.dt) dt
      , s.profit_c
      , t.total_current_value
      , s.nbr_trans
      , s.profit_c
        - COALESCE((
          SELECT SUM(avg_avgCost - avg_totalAmount*currentPrice)
          FROM ethbinance.hist_dca h
          WHERE h.created_at = (SELECT started_at FROM ethbinance.logs WHERE DATE_TRUNC('day',started_at) = s.dt ORDER BY started_at DESC LIMIT 1)
        ),0) 
        - COALESCE((
          SELECT SUM(avg_avgCost - avg_totalAmount*currentPrice)
          FROM ethbinance.hist_gains h
          WHERE h.created_at = (SELECT started_at FROM ethbinance.logs WHERE DATE_TRUNC('day',started_at) = s.dt ORDER BY started_at DESC LIMIT 1)
        ),0) Unrealised_PnL
    FROM (
      SELECT DATE_TRUNC('day',s.soldDate) dt
        , SUM((currentPrice * soldAmount * 0.998) - (avg_price * soldAmount)) profit_c
        , COUNT(*) nbr_trans
      FROM ethbinance.dash002_tracker_logs_003_sell s
      GROUP BY DATE_TRUNC('day',soldDate)
    ) s
    FULL JOIN (
      SELECT dt, total_current_value
      FROM (
        SELECT DATE_TRUNC('day', h.created_at) dt
          , balance + totalPairsCurrentValue + totalDCACurrentValue + totalPendingCurrentValue total_current_value
          , ROW_NUMBER() OVER (PARTITION BY DATE_TRUNC('day', h.created_at) ORDER BY h.created_at DESC) rn
        FROM ethbinance.hist_totals h
      ) totals
      WHERE rn = 1
    ) t ON t.dt = s.dt
  ) st
  LEFT OUTER JOIN (
    SELECT dt, GBP, USD, EUR
    FROM (
      SELECT DATE_TRUNC('day', h.created_at) dt
        , GBP
        , USD
        , EUR
        , ROW_NUMBER() OVER (PARTITION BY DATE_TRUNC('day', h.created_at) ORDER BY h.created_at DESC) rn
      FROM ethbinance.hist_prices h
    ) prices
    WHERE rn = 1
  ) pr ON pr.dt = st.dt
  ORDER BY st.dt;
  
  v_ret := 'data recalculate from ' || to_char(v_update_datetime, 'YYYY-MM-DD HH24:MI:SS');
  RETURN v_ret;
--*****************************
--log of changes

--version: 1.00
--Date: 2018-02-07
--first release
END;
$$ LANGUAGE plpgsql;


--Grants
GRANT SELECT ON ethbinance.dash002_tracker_logs_001_dca TO grafanareader;
GRANT SELECT ON ethbinance.dash002_tracker_logs_002_pairs TO grafanareader;
GRANT SELECT ON ethbinance.dash002_tracker_logs_003_sell TO grafanareader;
GRANT SELECT ON ethbinance.dash002_tracker_logs_004_profits TO grafanareader;

GRANT SELECT ON ethbinance.hist_totals TO grafanareader;
GRANT SELECT ON ethbinance.logs TO grafanareader;
GRANT SELECT ON ethbinance.hist_gains TO grafanareader;
GRANT SELECT ON ethbinance.hist_dca TO grafanareader;
GRANT SELECT ON ethbinance.hist_prices TO grafanareader;









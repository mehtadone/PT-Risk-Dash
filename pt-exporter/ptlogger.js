/**
 * Created by Taras on 2018-02-16.
 *
 * version 2.02
 */
'use strict';
require('ssl-root-cas').inject();
const request = require('superagent')
const agent = request.agent()
const pg = require('pg');


const clientPG = new pg.Client({
  host: 'localhost',
  port: 5432,
  database: 'pt_binance',
  user: 'pt_binance',
  password: 'pt_binance',
});

// --------------------------------------------------------------------------------

function die(msg) { throw(msg) }

const start = async(host,port,password, schema_name) => {

  const data = await getData(host,port,password);

  const {
    sellLogData, gainLogData, watchModeLogData,
    pendingLogData, dcaLogData, dcaBackupLogData,
    bbBuyLogData, gainBuyLogData, dcaBuyOrdersHistory,
    storedAverageMap, dustLogData,
    settings, notifications,
  ...totals
  } = data;

//v2.1
  const dataPrices = await getPriceData(schema_name);
  const {
    ...Prices
  } = dataPrices;

  await clientPG.connect();

  try {

    await clientPG.query('BEGIN');

    const create_at = new Date();

    //save to log
    const SQL_ins_logs = 'INSERT INTO ' + schema_name + '.logs(started_at' +
      ', script_name' +
      ', host' +
      ', port' +
      ', schema_name' +
      ') ' +
      'VALUES(' +
      '$1, $2, $3, $4, $5' +
      ') RETURNING id;'
    const SQL_ins_logs_values = [
      create_at
      , 'ptlogger_pg_v2'
      , host
      , port
      , schema_name
    ];
    const res_log = await clientPG.query(SQL_ins_logs, SQL_ins_logs_values);

    //save to log
    const SQL_ins_hist_prices = 'INSERT INTO ' + schema_name + '.hist_prices(created_at' +
      ', GBP' +
      ', USD' +
      ', EUR' +
      ') ' +
      'VALUES(' +
      '$1, $2, $3, $4' +
      ');'
    const SQL_ins_hist_prices_values = [
      create_at
      , dataPrices.GBP
      , dataPrices.USD
      , dataPrices.EUR
    ];
    //console.log(SQL_ins_hist_prices);
    //console.log(SQL_ins_hist_prices_values);
    const res_hist_prices = await clientPG.query(SQL_ins_hist_prices, SQL_ins_hist_prices_values);
    // try {
    //   const res_log = await clientPG.query(SQL_ins_logs, SQL_ins_logs_values);
    //   console.log(res_log.rows[0])
    // } catch (err) {
    //   console.log(err.stack);
    // }
    //res_log.rows[0].id

    const SQL_ins_hist_totals = 'INSERT INTO ' + schema_name + '.hist_totals(created_at' +
      ', balance' +
      ', totalPairsCurrentValue' +
      ', totalPairsRealCost' +
      ', totalDCACurrentValue' +
      ', totalDCARealCost' +
      ', totalPendingCurrentValue' +
      ', totalPendingTargetPrice' +
      ', totalProfitYesterday' +
      ', totalProfitToday' +
      ', totalProfitWeek' +
      ', version' +
      ', market' +
      ', sitename' +
      ', exchangeUrl' +
      ', exchange' +
      ', ETHUSDTPrice' +
      ', ETHUSDTPercChange' +
      ', BTCUSDTPrice' +
      ', BTCUSDTPercChange' +
      ', timeZoneOffset' +
      ', pendingOrderTime' +
      ') ' +
      'VALUES(' +
      '$1, $2, $3, $4, $5, $6, $7, $8, $9, $10' +
      ', $11, $12, $13, $14, $15, $16, $17, $18, $19, $20' +
      ', $21, $22' +
      ');'
    const SQL_ins_hist_totals_values = [
      create_at
      , totals.balance
      , totals.totalPairsCurrentValue
      , totals.totalPairsRealCost
      , totals.totalDCACurrentValue
      , totals.totalDCARealCost
      , totals.totalPendingCurrentValue
      , totals.totalPendingTargetPrice
      , totals.totalProfitYesterday
      , totals.totalProfitToday
      , totals.totalProfitWeek
      , totals.version
      , totals.market
      , totals.sitename
      , totals.exchangeUrl
      , totals.exchange
      , totals.ETHUSDTPrice
      , totals.ETHUSDTPercChange
      , totals.BTCUSDTPrice
      , totals.BTCUSDTPercChange
      , totals.timeZoneOffset
      , totals.pendingOrderTime
    ];
    const SQL_ins_hist_totals_res = await clientPG.query(SQL_ins_hist_totals, SQL_ins_hist_totals_values);

    // try {
    //   const res = await clientPG.query(SQL_ins_hist_totals, SQL_ins_hist_totals_values);
    // } catch (err) {
    //   console.log(err.stack);
    // }

    const SQL_ins_hist_sell = 'INSERT INTO ' + schema_name + '.hist_sells(created_at' +
      ', soldAmount' +
      ', soldDate' +
      ', boughtTimes' +
      ', market' +
      ', profit' +
      ', avg_totalCost' +
      ', avg_totalAmount' +
      ', avg_totalAmountWithSold' +
      ', avg_avgPrice' +
      ', avg_avgCost' +
      ', avg_firstBoughtDate' +
      ', avg_totalWeightedPrice' +
      ', avg_orderNumber' +
      ', avg_fee' +
      ', currentPrice' +
      ', sellStrategy' +
      ', volume' +
      ', triggerValue' +
      ', percChange' +
      ') ' +
      'VALUES(' +
      '$1, $2, $3, $4, $5, $6, $7, $8, $9, $10' +
      ', $11, $12, $13, $14, $15, $16, $17, $18, $19, $20' +
      ');'
    for (var item of sellLogData) {
      //console.log( i + ": " + item.soldAmount);
      //const item = sellLogData[0];
      const SQL_ins_hist_sell_values = [
        create_at
        , item.soldAmount
        , new Date(item.soldDate.date.year, item.soldDate.date.month - 1, item.soldDate.date.day
          , item.soldDate.time.hour, item.soldDate.time.minute, item.soldDate.time.second
          , item.soldDate.time.nano / 1000)
        , item.boughtTimes
        , item.market
        , item.profit
        , item.averageCalculator.totalCost
        , item.averageCalculator.totalAmount
        , item.averageCalculator.totalAmountWithSold
        , item.averageCalculator.avgPrice
        , item.averageCalculator.avgCost
        , new Date(item.averageCalculator.firstBoughtDate.date.year, item.averageCalculator.firstBoughtDate.date.month - 1, item.averageCalculator.firstBoughtDate.date.day
          , item.averageCalculator.firstBoughtDate.time.hour, item.averageCalculator.firstBoughtDate.time.minute, item.averageCalculator.firstBoughtDate.time.second
          , item.averageCalculator.firstBoughtDate.time.nano / 1000)
        , item.averageCalculator.totalWeightedPrice
        , item.averageCalculator.orderNumber
        , item.averageCalculator.fee
        , item.currentPrice
        , item.sellStrategy
        , item.volume
        , item.triggerValue
        , item.percChange
      ];
      const SQL_ins_hist_sell_res = await clientPG.query(SQL_ins_hist_sell, SQL_ins_hist_sell_values);

      // try {
      //   const res = await clientPG.query(SQL_ins_hist_sell, SQL_ins_hist_sell_values);
      // } catch (err) {
      //   console.log(err.stack);
      // }
    }
    ;

    const SQL_ins_hist_gains = 'INSERT INTO ' + schema_name + '.hist_gains(created_at' +
      ', combinedProfit' +
      ', market' +
      ', profit' +
      ', avg_totalCost' +
      ', avg_totalAmount' +
      ', avg_totalAmountWithSold' +
      ', avg_avgPrice' +
      ', avg_avgCost' +
      ', avg_firstBoughtDate' +
      ', avg_totalWeightedPrice' +
      ', avg_orderNumber' +
      ', avg_fee' +
      ', currentPrice' +
      ', sellStrategy' +
      ', volume' +
      ', triggerValue' +
      ', percChange' +
      ') ' +
      'VALUES(' +
      '$1, $2, $3, $4, $5, $6, $7, $8, $9, $10' +
      ', $11, $12, $13, $14, $15, $16, $17, $18' +
      ');'
    for (var item of gainLogData) {
      //console.log( i + ": " + item.soldAmount);
      //const item = sellLogData[0];
      const SQL_ins_hist_gain_values = [
        create_at
        , item.combinedProfit
        , item.market
        , item.profit
        , item.averageCalculator.totalCost
        , item.averageCalculator.totalAmount
        , item.averageCalculator.totalAmntWithSold
        , item.averageCalculator.vgPrice
        , item.averageCalculator.avgCost
        , new Date(item.averageCalculator.firstBoughtDate.date.year, item.averageCalculator.firstBoughtDate.date.month - 1, item.averageCalculator.firstBoughtDate.date.day
          , item.averageCalculator.firstBoughtDate.time.hour, item.averageCalculator.firstBoughtDate.time.minute, item.averageCalculator.firstBoughtDate.time.second
          , item.averageCalculator.firstBoughtDate.time.nano / 1000)
        , item.averageCalculator.totalWeightedPrice
        , item.averageCalculator.orderNumber
        , item.averageCalculator.fee
        , item.currentPrice
        , item.sellStrategy
        , item.volume
        , item.triggerValue
        , item.percChange
      ];
      const SQL_ins_hist_gain_res = await clientPG.query(SQL_ins_hist_gains, SQL_ins_hist_gain_values);


      // try {
      //   const res = await clientPG.query(SQL_ins_hist_gains, SQL_ins_hist_gain_values);
      // } catch (err) {
      //   console.log(err.stack);
      // };
    }
    ;

    const SQL_ins_hist_dca = 'INSERT INTO ' + schema_name + '.hist_dca(created_at' +
      ', BBLow' +
      ', BBTrigger' +
      ', positive' +
      ', highbb' +
      ', boughtTimes' +
      ', buyProfit' +
      ', lastOrderNumber' +
      ', unfilledAmount' +
      ', market' +
      ', profit' +
      ', avg_totalCost' +
      ', avg_totalAmount' +
      ', avg_totalAmountWithSold' +
      ', avg_avgPrice' +
      ', avg_avgCost' +
      ', avg_firstBoughtDate' +
      ', avg_totalWeightedPrice' +
      ', avg_orderNumber' +
      ', avg_fee' +
      ', currentPrice' +
      ', sellStrategy' +
      ', buyStrategy' +
      ', volume' +
      ', triggerValue' +
      ', percChange' +
      ') ' +
      'VALUES(' +
      '$1, $2, $3, $4, $5, $6, $7, $8, $9, $10' +
      ', $11, $12, $13, $14, $15, $16, $17, $18, $19, $20' +
      ', $21, $22, $23, $24, $25, $26' +
      ');'
    for (var item of dcaLogData) {
      //console.log( i + ": " + item.soldAmount);
      //const item = sellLogData[0];
      const SQL_ins_hist_dca_values = [
        create_at
        , item.BBLow
        , item.BBTrigger
        , item.positive
        , item.highbb
        , item.boughtTimes
        , item.buyProfit
        , item.lastOrderNumber
        , item.unfilledAmount
        , item.market
        , item.profit
        , item.averageCalculator.totalCost
        , item.averageCalculator.totalAmount
        , item.averageCalculator.totalAmountWithSold
        , item.averageCalculator.avgPrice
        , item.averageCalculator.avgCost
        , new Date(item.averageCalculator.firstBoughtDate.date.year, item.averageCalculator.firstBoughtDate.date.month - 1, item.averageCalculator.firstBoughtDate.date.day
          , item.averageCalculator.firstBoughtDate.time.hour, item.averageCalculator.firstBoughtDate.time.minute, item.averageCalculator.firstBoughtDate.time.second
          , item.averageCalculator.firstBoughtDate.time.nano / 1000)
        , item.averageCalculator.totalWeightedPrice
        , item.averageCalculator.orderNumber
        , item.averageCalculator.fee
        , item.currentPrice
        , item.sellStrategy
        , item.buyStrategy
        , item.volume
        , item.triggerValue
        , item.percChange
      ];
      const SQL_ins_hist_dca_res = await clientPG.query(SQL_ins_hist_dca, SQL_ins_hist_dca_values);

      // try {
      //   const res = await clientPG.query(SQL_ins_hist_dca, SQL_ins_hist_dca_values);
      // } catch (err) {
      //   console.log(err.stack);
      // }
      // ;
    }
    ;

    //recalculate dashs
    //const SQL_dash001_tracker_upd = 'select ' + schema_name + '.dash001_tracker_upd() info;';
    //const SQL_dash001_tracker_upd_res = await clientPG.query(SQL_dash001_tracker_upd);

    // try {
    //   const res = await clientPG.query(SQL_dash001_tracker_upd);
    //   //console.log(res.rows[0]);
    // } catch (err) {
    //   console.log(err.stack);
    // }
    // ;

    const SQL_dash002_tracker_logs_upd = 'select ' + schema_name + '.dash002_tracker_logs_upd($1);';
    const SQL_dash002_tracker_logs_upd_values = [
      create_at
    ];
    const SQL_dash002_tracker_logs_upd_res = await clientPG.query(SQL_dash002_tracker_logs_upd, SQL_dash002_tracker_logs_upd_values);

    //update log
    const SQL_upd_logs = 'UPDATE ' + schema_name + '.logs SET finished_at = $1 WHERE id = $2;';
    const SQL_upd_logs_values = [
      new Date()
      , res_log.rows[0].id
    ];
    const SQL_upd_logs_res = await clientPG.query(SQL_upd_logs, SQL_upd_logs_values);

    await clientPG.query('COMMIT');
  } catch (e) {
    await clientPG.query('ROLLBACK');
    console.log(e.stack);
  }

  await clientPG.end();
}

const getData = async(host,port,password) => {
  const urlBase = `http://${host}:${port}`;
  const auth = await agent.post(`${urlBase}/login`).send(`password=${password}`);
  const results = await agent.get(`${urlBase}/monitoring/data`).accept('json');
  return results.body;
}

const getPriceData = async(schema_name) => {
  const urlPrice = (schema_name == 'binance' || schema_name == 'trex') ? `https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=GBP,USD,EUR` :
    (schema_name == 'ethbinance') ? `https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=GBP,USD,EUR` :
      'NONE';
  //console.log(urlPrice);
  if (urlPrice != 'NONE') {
    const resultsPrice = await agent.get(`${urlPrice}`).accept('json');
    return resultsPrice.body;
  }
  else
    return '{}';
}

(async () => {
  const args = process.argv.slice(2);
  const [host, port, password, p_schema_name] = args;

  if (!host || !port || !password) {
    die('Must specify <host> <port> <password> <schema name>')
  };


  console.log(`Processing ${host}:${port} schema[${p_schema_name}]`);
  start(host,port,password, p_schema_name);
})()
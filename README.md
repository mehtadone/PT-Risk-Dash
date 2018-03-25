

## What is this?
This is a dashboard I built for personal use that utilises Grafana, postgresql and a script to take statistics from the Profit Trailer json file to a database so that I can view metrics that are important to me. It is not ideal as it does not take information from the exchange but will work as an approximation for now. 

## Why did you do this?
Having spent 15 years developing software for Forex trading desks, the most important tool in their arsenal is a risk management tool. Any proprietary trading desk or a flow desk, needs to see their risk exposure, not just the big fat profit figure. This is something that was missing for me, and hence I put this together. 

## Who is this for?
This is not a simple one click install application. It requires a bit of installation and expertise to put together. There are far better and easier tools out there if you want profit figures only. This is for someone who wants to manage their risk, and also over multiple bots.

## How much is it?
Nothing. It is fully open source, like CryptoGramBot. 

## How do I install it? (To be improved)

1. Install Grafana beta 5
2. Install postgresdb, if not already installed
3. Run sql scripts on new postgres db
(db is called pt_binance. Probably should be renamed)
4. Run js file on a cron job with parameters
(host,port,password, schema_name)
There maybe some dependencies you'll to install for node. If you run the js file manually, you'll see them. There are 2 or 3
5. Import the json dashboards into grafana. (Trex, Binance BTC, Binance ETH and PT Combined BTC added as an example)

## Huge thanks

- Inspiration from [GeekLingo](https://github.com/geeklingo/Guppy-Dashboard)
- YoJeff for his initial grafana script
- The PT Crew

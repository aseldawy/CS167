# Project D: Twitter Data Analysis

## Objectives
- Apply the techniques we learned on a real big-data application.
- Translate high-level requirements into a big-data processing pipeline.
- Break down a big problem into smaller parts that can be solved separately.
- Build a machine learning pipeline in Spark

## Overview
This project analyzes a Twitter dataset. Our goal is to predict the topic of each tweet from its text.
For simplicity, we will only consider the text of the tweet and the description of the user account that
created the tweet but in reality other factor could also be used such as the number of retweets and likes.

## Prerequisites
Download samples of the data with different sizes to test your program while developing.
There are samples of
[1,000 points](https://drive.google.com/open?id=1CoNIq2cymgr7sie8KcDU4HL7cEu-RAEb),
[10,000 points](https://drive.google.com/open?id=1CnmVPg8L3deF0EhCBy4Orh3GoSdjosJ4),
and [100,000 points](https://drive.google.com/open?id=1Cn_E45y0kVXZZRlb7BE9n6F7pwhrcPvZ).
You do not have to decompress these files before processing.

## Task 1: Data preparation 1
The first task performs some preprocessing to prepare the data for analysis.
This includes mainly two tasks.
First, keep only the relevant attributes to reduce the complexity and size of the data.
Second, extract the top 20 keywords. We will use them as our topics.

- Load the given input file using the `json` format.
- Keep only the following attributes {id, text, entities.hashtags.txt, user.description, retweet_count, reply_count, and quoted_status_id}
- Store the output in a new JSON file named `tweets_clean`.
- The output is supposed to be in the following schema.
```
root
 |-- id: long (nullable = true)
 |-- text: string (nullable = true)
 |-- hashtags: array (nullable = true)
 |    |-- element: string (containsNull = true)
 |-- user_description: string (nullable = true)
 |-- retweet_count: long (nullable = true)
 |-- reply_count: long (nullable = true)
 |-- quoted_status_id: long (nullable = true)
```
- A few sample records are shown below for your reference.
```json
{"id":921633443708096512,"text":"He referred to his place as home so my heart is SO warm rn https://t.co/xZS41dUF55","hashtags":[],"user_description":"constantly grumpy","retweet_count":0,"reply_count":0}
{"id":921633445788258304,"text":"@ShirazHassan my son want to purchase his camera for his assignments as BJMC students so which the good in nowadays??. Regards","hashtags":[],"user_description":"Cheif operating officer with 300 crore Indian conglomerate in edibles Oils. HQ Raipur Chattisgarh","retweet_count":0,"reply_count":0}
{"id":921633446623137792,"text":"حمزة العيلي وهو\" محروس\" الزوج الثاني لهيفاء وهبي بالمسلسل جداً نظيف وواضح وغلبان تتعاطف معه كثير بالمسلسل\nالمسلسل جميل وماننسى دور عمرو واكد","hashtags":[],"retweet_count":0,"reply_count":0}
{"id":921633444391555073,"text":"矢沢な皆さん❣️\n琵琶湖ホールで会いましょうね😘\n#トラバス2017 https://t.co/G4IMOC4VIF","hashtags":["トラバス2017"],"user_description":"JR草津駅東口徒歩約4分❣️昭和歌謡からロックまて♫老若男女が楽しめるカラオケバーです🎤","retweet_count":0,"reply_count":0}
{"id":921633447558266880,"text":"It's beautiful https://t.co/1RHtFBEFnk","hashtags":[],"user_description":"Football, healthcare, stem cell research, technology, cycling, politics. I believe in an Australian Republic #SydneyIsSkyBlue","retweet_count":0,"reply_count":0}
```
- Download [this sample output](https://drive.google.com/open?id=1EDI4xS0qQJkMsk4Pt9WkhGX9QVsa_hX1)
  to double-check your result.
- On the clean data, run a top-k SQL query to select the top 20 most frequent hashtags as follows.
  - Use the function `explode` to produce one list of all hashtags from the column `hashtags`.
  - Run a count query for each hashtag.
  - `ORDER` the result `BY` counts in descending order.
  - `LIMIT` the number of results to 20.
- Collect the result in an array of keywords. Here is a comma-separated list of the top-20 keywords for the 1k dataset.
```text
ALDUBxEBLoveis,no309,FurkanPalalı,LalOn,sbhawks,DoktorlarDenklikistiyor,Benimisteğim,احتاج_بالوقت_هذا,happy,السعودية,nowplaying,CNIextravaganza2017,love,beautiful,art,türkiye,vegalta,KittyLive,tossademar,鯛
```

In the report, include the top 20 keywords you found for the 10k dataset.

### Task 2: Data preparation 2
Add a new column for each tweet that indicates its topic.
The topic is any of the hashtags that appear in the most frequent list.
If a tweet contains more than one top hashtags, any of them can be used.

- If the result of Task 1 is not available to you yet,
  download [this sample file](https://drive.google.com/open?id=1EDI4xS0qQJkMsk4Pt9WkhGX9QVsa_hX1) to start working.
- Load the file as a JSON file.
- Use the function `array_intersect` to compute the intersection between the list of hashtags and the list of topics.
- Since the result of `array_intersect` is an array, keep only the first entry of it.
- Keep only the records that have a topic, i.e., filter out the cases where the result of the `array_intersect` is empty.
- Store the output in a JSON file named `tweets_topic`.
- The result should have the following schema. Notice the additional attribute `topic` that replaces the hashtags.
```text
root
 |-- id: long (nullable = true)
 |-- text: string (nullable = true)
 |-- topic: string (nullable = true)
 |-- user_description: string (nullable = true)
 |-- retweet_count: long (nullable = true)
 |-- reply_count: long (nullable = true)
 |-- quoted_status_id: long (nullable = true)
```
And here are a few sample records.

```json
{"id":921633446644080641,"text":"#negramaroofficial #love #smile #pic #follow4follow #followme #finoallimbrunire #amorecheritorni… https://t.co/o3LPaMxBrj","hashtag":"love","user_description":"Negramanteinside_romanainside\nSe non sei Giuliano Sangiorgi lasciami stare.","retweet_count":0,"reply_count":0}
{"id":921633445045866497,"text":"#CNIextravaganza2017 Testimoni dari Bpk. Agung Handaya sebagai Double Diamond mengenai CNI I-Plan 2017 #bisnisCNI https://t.co/6fEs7eQPWh","hashtag":"CNIextravaganza2017","user_description":"Hebat Produknya Hebat Bisnisnya","retweet_count":0,"reply_count":0}
{"id":921633449882128384,"text":"#DoktorlarDenklikistiyor #Benimisteğim https://t.co/decAepZqMN","hashtag":"DoktorlarDenklikistiyor","user_description":"emin ben","retweet_count":0,"reply_count":0}
{"id":921633451773648896,"text":"Na miss ko mag tweet na may ALDUB hashtag  #ALDUBxEBLoveis","hashtag":"ALDUBxEBLoveis","user_description":"Resilient. Objective. Rational.\nLove is a grave mental disease. - Plato","retweet_count":0,"reply_count":0}
{"id":921633452289642497,"text":"#FurkanPalalı Değil güzel bir mutluluk kaynağı olun #LalOn #no309 084","hashtag":"no309","retweet_count":0,"reply_count":0}
```

Finally, you can download
[this sample file](https://drive.google.com/open?id=1EEwaBE5Es6yOpQ54y-iANtHLyFmvZABe)
to double-check your result.

In the report, include the total number of records in the `tweets_topic` dataset for the 10k dataset.

### Task 3: Topic prediction
Build a machine learning model that assigns a topic for each tweet based on the classified tweets.
The model should learn the relationship between all features and the topic.
Then, it applies this model to all data to predict one topic for each tweet.
The machine learning pipeline should include the following.

- A `Tokenzier` that finds all the tokens (words) from the tweets text and user description.
- A `HashingTF` transformer that converts the tokens into a set of numeric features.
- A `StringIndexer` that converts each topic to an index.
- A `LogisticRgression` or another classifier that predicts the topic from the set of features.

After that, you will do the regular training-test split to train on one set and test on the other.

Here is a sample of how part of your result might look like. The actual results will probably differ depending on how the model worked.

|id                | text                                                                                                                  |topic                  |user_description                                                                                                     |label|prediction|
|------------------|-----------------------------------------------------------------------------------------------------------------------|-----------------------|---------------------------------------------------------------------------------------------------------------------|-----|----------|
|921633452289642497| #FurkanPalalı Değil güzel bir mutluluk kaynağı olun #LalOn #no309 084                                                 |no309                  |null                                                                                                                 |1.0  |1.0       |
|921633507558002688| #happy #Saturday \n#cake #birthdaycake #weddingcake #bespokecake #celebrationcake #nakedcake… https://t.co/4nTkMMUJuj |happy                  |Pastry chef, personal cook, mum. Cakes + bakes from my little bakery in tooting market, London cakes@nuvolabakery.com|10.0 |6.0       |
|921633512825991169| #DoktorlarDenklikistiyor #Benimisteğim https://t.co/FLXcDHJLJl                                                        |DoktorlarDenklikistiyor|emin ben                                                                                                             |3.0  |3.0       |
|921633514587656192| Indigo Son #art #human #nature #figure #artofvisuals #color @ Los Angeles, California https://t.co/95DYGZOd1S         |art                    |I am an artist. So, there!                                                                                           |8.0  |6.0       |

- Compute the precision and recall of the result you found and include them in the report for the 10k dataset. 


user_data = LOAD '/pig/in/u.data' USING PigStorage('\t') AS (user_id:chararray, item_id:chararray, rating:int, timestamp:long);
item_data = LOAD '/pig/in/u.item' USING PigStorage('|') AS (movie_id:chararray, movie_title:chararray, release_date:chararray, video_release_date:chararray, IMDb_URL:chararray, unknown:chararray, Action:chararray, Adventure:chararray, Animation:chararray, Childrens:chararray, Comedy:chararray, Crime:chararray, Documentary:chararray, Drama:chararray, Fantasy:chararray, FilmNoir:chararray, Horror:chararray, Musical:chararray, Mystery:chararray, Romance:chararray, SciFi:chararray, Thriller:chararray, War:chararray, Western:chararray);

grouped_user_data = GROUP user_data BY item_id;

avg_user_data = FOREACH grouped_user_data GENERATE group AS item_id, ROUND_TO( AVG(user_data.rating), 2) AS average_rating;

joined_data = JOIN avg_user_data BY item_id, item_data BY movie_id;


selected_output = FOREACH joined_data GENERATE avg_user_data::item_id, item_data::movie_title, item_data::release_date, item_data::IMDb_URL, avg_user_data::average_rating;

STORE selected_output INTO '/pig/out/movie_ratings' using PigStorage('|');



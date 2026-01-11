-- bai 8
use social_network_pro;

create index idx_user_gender on users(gender);

create or replace view view_popular_posts as
select p.post_id, u.username, p.content, count(distinct l.user_id) as like_count, count(distinct c.comment_id) as comment_count
from posts p
join users u on u.user_id = p.user_id
left join likes l on l.post_id = p.post_id
left join comments c on c.post_id = p.post_id
group by p.post_id;

select * from view_popular_posts;

select post_id, username, content, like_count, comment_count, (like_count + comment_count) as total_interactions
from view_popular_posts
where (like_count + comment_count) > 10
order by total_interactions desc;
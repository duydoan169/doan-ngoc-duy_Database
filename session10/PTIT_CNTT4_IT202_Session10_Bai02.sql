-- bai 2
USE social_network_pro;

create or replace view view_user_post as
select user_id, count(post_id) as total_user_post from posts
group by user_id;

select * from view_user_post;

select users.full_name, view_user_post.total_user_post
from view_user_post join
users on users.user_id = view_user_post.user_id;
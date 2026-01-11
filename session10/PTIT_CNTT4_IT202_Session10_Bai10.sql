-- bai 10
use social_network_pro;

create index idx_username on users(username);

create view view_user_activity_2 as
select u.user_id,
       count(distinct p.post_id) total_posts,
       count(distinct f.friend_id) total_friends
from users u
left join posts p on u.user_id = p.user_id
left join friends f
    on (u.user_id = f.user_id or u.user_id = f.friend_user_id)
    and f.status = 'accepted'
group by u.user_id;

select *
from view_user_activity_2;

select u.full_name,
       v.total_posts,
       v.total_friends,
       case
           when v.total_friends > 5 then 'Nhiều bạn bè'
           when v.total_friends between 2 and 5 then 'Vừa đủ bạn bè'
           else 'Ít bạn bè'
       friend_description,
       case
           when v.total_posts > 10 then v.total_posts * 1.1
           when v.total_posts between 5 and 10 then v.total_posts
           else v.total_posts * 0.9
       post_activity_score
from users u
join view_user_activity_2 v on u.user_id = v.user_id
where v.total_posts > 0
order by v.total_posts desc;

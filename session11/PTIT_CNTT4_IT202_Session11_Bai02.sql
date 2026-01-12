use social_network_pro;

delimiter $$

create procedure CalculatePostLikes (
	in p_post_id int,
    out post_likes int
)
begin
	set post_likes = (select count(post_id) from likes
    where post_id = p_post_id);
end $$

delimiter ;

call CalculatePostLikes(101, @post_likes);
select @post_likes;

drop procedure CalculatePostLikes;
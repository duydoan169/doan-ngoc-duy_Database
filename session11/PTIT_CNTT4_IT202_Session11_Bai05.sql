use social_network_pro;

delimiter $$

create procedure CalculateUserActivityScore (
	in p_user_id int,
	out activity_score int,
	out activity_level varchar(50)
)
begin
	declare post_count int;
	declare comment_count int;
	declare like_count int;

	set post_count = (
		select count(*) from posts
		where user_id = p_user_id
	);

	set comment_count = (
		select count(*) from comments
		where user_id = p_user_id
	);

	set like_count = (
		select count(*) from likes l
		join posts p on l.post_id = p.post_id
		where p.user_id = p_user_id
	);

	set activity_score = post_count * 10 + comment_count * 5 + like_count * 3;

	if activity_score > 500 then
		set activity_level = 'Rất tích cực';
	elseif activity_score >= 200 then
		set activity_level = 'Tích cực';
	else
		set activity_level = 'Bình thường';
	end if;
end $$

delimiter ;

call CalculateUserActivityScore(1, @score, @level);
select @score, @level;

drop procedure CalculateUserActivityScore;

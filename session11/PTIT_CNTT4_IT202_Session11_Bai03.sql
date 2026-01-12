use social_network_pro;

delimiter $$

create procedure CalculateBonusPoints(
	in p_user_id int,
    inout p_bonus_points int
)
begin
	declare post_count int;
    set post_count = (select count(post_id) from posts
    where user_id = p_user_id);
    
    if post_count >= 20 then
		set p_bonus_points = p_bonus_points + 100;
	elseif post_count >= 10 then
		set p_bonus_points = p_bonus_points + 50;
	end if;
end $$

delimiter ;

set @bonus_points=100;
call CalculateBonusPoints(1, @bonus_points);
select @bonus_points as bonus_points;

drop procedure CalculateBonusPoints;

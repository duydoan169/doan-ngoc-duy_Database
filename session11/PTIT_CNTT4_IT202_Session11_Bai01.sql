use social_network_pro;

delimiter $$

create procedure bai01 ( in p_user_id int )
begin 
	select post_id, content, created_at from posts 
    where user_id = p_user_id;
end $$

delimiter ;

call bai01(1);

drop procedure bai01;

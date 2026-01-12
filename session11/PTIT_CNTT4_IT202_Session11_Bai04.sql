use social_network_pro;

delimiter $$

create procedure CreatePostWithValidation (
	in p_user_id int,
    in p_content text,
    out result_message varchar(255)
)
begin
	if char_length(p_content) < 5 then
		set result_message = "Nội dung quá ngắn";
	else
		insert into posts (user_id, content) values
        (p_user_id, p_content);
        set result_message = "Thêm bài viết thành công";
	end if;
end $$
delimiter ;

call CreatePostWithValidation(1, "abcdefg", @res);
select @res;
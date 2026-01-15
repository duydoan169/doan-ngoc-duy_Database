-- bai 4
-- bai 5
use social_network;

create table comments (
	comment_id int auto_increment primary key,
	post_id int not null,
	user_id int not null,
	content text not null,
	created_at datetime default current_timestamp,
	foreign key (post_id) references posts(post_id),
	foreign key (user_id) references users(user_id)
);

alter table posts
add column comments_count int default 0;

delimiter $$

create procedure post_comment(
	in p_post_id int,
	in p_user_id int,
	in p_content text
)
begin
	start transaction;

	insert into comments (post_id, user_id, content)
	values (p_post_id, p_user_id, p_content);

	savepoint after_insert;

	begin
		declare continue handler for sqlexception
		begin
			rollback to after_insert;
		end;

		update posts
		set comments_count = comments_count + 1
		where post_id = p_post_id;
	end;

	commit;
end $$

delimiter ;

call post_comment(1, 1, 'binh luan thanh cong');

call post_comment(999, 1, 'binh luan gay loi');


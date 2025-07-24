create table users
(
    user_id             integer      not null
        primary key,
    username            varchar(50)  not null
        unique,
    email               varchar(100) not null
        unique,
    password_hash       varchar(255) not null,
    first_name          varchar(50)  not null,
    last_name           varchar(50)  not null,
    bio                 text,
    profile_picture_url varchar(255),
    date_joined         timestamp default CURRENT_TIMESTAMP,
    is_active           boolean   default true,
    follower_count      integer   default 0,
    following_count     integer   default 0
);

alter table users
    owner to postgres;

create table posts
(
    post_id       integer not null
        primary key,
    user_id       integer not null
        references users
            on delete cascade,
    content       text    not null,
    image_url     varchar(255),
    created_at    timestamp default CURRENT_TIMESTAMP,
    updated_at    timestamp default CURRENT_TIMESTAMP,
    like_count    integer   default 0,
    comment_count integer   default 0,
    is_public     boolean   default true
);

alter table posts
    owner to postgres;

create index idx_posts_user_id
    on posts (user_id);

create index idx_posts_created_at
    on posts (created_at);

create table comments
(
    comment_id integer not null
        primary key,
    post_id    integer not null
        references posts
            on delete cascade,
    user_id    integer not null
        references users
            on delete cascade,
    content    text    not null,
    created_at timestamp default CURRENT_TIMESTAMP,
    updated_at timestamp default CURRENT_TIMESTAMP,
    like_count integer   default 0
);

alter table comments
    owner to postgres;

create index idx_comments_post_id
    on comments (post_id);

create index idx_comments_user_id
    on comments (user_id);

create table likes
(
    user_id    integer not null
        references users
            on delete cascade,
    post_id    integer not null
        references posts
            on delete cascade,
    created_at timestamp default CURRENT_TIMESTAMP,
    primary key (user_id, post_id)
);

alter table likes
    owner to postgres;

create index idx_likes_post_id
    on likes (post_id);

create table followers
(
    follower_id  integer not null
        references users
            on delete cascade,
    following_id integer not null
        references users
            on delete cascade,
    followed_at  timestamp default CURRENT_TIMESTAMP,
    primary key (follower_id, following_id)
);

alter table followers
    owner to postgres;


DROP TABLE IF EXISTS likes;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS followers;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS users;

-- TABLE CREATION - COMPATIBLE VERSION

-- 1. USERS TABLE
CREATE TABLE users (
    user_id INTEGER PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    bio TEXT,
    profile_picture_url VARCHAR(255),
    date_joined TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    follower_count INTEGER DEFAULT 0,
    following_count INTEGER DEFAULT 0
);

-- 2. POSTS TABLE
CREATE TABLE posts (
    post_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    content TEXT NOT NULL,
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    like_count INTEGER DEFAULT 0,
    comment_count INTEGER DEFAULT 0,
    is_public BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 3. COMMENTS TABLE
CREATE TABLE comments (
    comment_id INTEGER PRIMARY KEY,
    post_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    like_count INTEGER DEFAULT 0,
    FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 4. LIKES TABLE
CREATE TABLE likes (
    user_id INTEGER NOT NULL,
    post_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, post_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE
);

-- 5. FOLLOWERS TABLE
CREATE TABLE followers (
    follower_id INTEGER NOT NULL,
    following_id INTEGER NOT NULL,
    followed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (follower_id, following_id),
    FOREIGN KEY (follower_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (following_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE INDEX idx_posts_user_id ON posts(user_id);
CREATE INDEX idx_posts_created_at ON posts(created_at);
CREATE INDEX idx_comments_post_id ON comments(post_id);
CREATE INDEX idx_comments_user_id ON comments(user_id);
CREATE INDEX idx_likes_post_id ON likes(post_id);


-- Insert Users with explicit IDs
INSERT INTO users (user_id, username, email, password_hash, first_name, last_name, bio) VALUES
(1, 'cholna', 'cholna@email.com', '$2y$10$hash1', 'Chotna', 'Tith', 'Tech enthusiast and coffee lover'),
(2, 'sreynet', 'sreynet@email.com', '$2y$10$hash2', 'Sreynet', 'Mon', 'Digital artist and photographer'),
(3, 'ratana', 'ratana@email.com', '$2y$10$hash3', 'Ratana', 'Svay', 'Fitness trainer and nutrition coach'),
(4, 'panhawath', 'panhawath@email.com', '$2y$10$hash4', 'Panhawath', 'Mey', 'Travel blogger exploring the world'),
(5, 'dana', 'dana@email.com', '$2y$10$hash5', 'Dana', 'Dorn', 'Software developer and tech reviewer');

-- Insert Posts with explicit IDs
INSERT INTO posts (post_id, user_id, content, image_url) VALUES
(1, 1, 'Mondulkiri<3', 'https://i.pinimg.com/736x/24/63/6d/24636d71bc263af5c2174584759254cf.jpg'),
(2, 2, 'Phnom Chisor, Takeo', 'https://i.pinimg.com/1200x/c5/15/62/c51562b6243f6f46790ee51482ddd7be.jpg'),
(3, 3, 'Kratie', 'https://i.pinimg.com/1200x/c3/53/b8/c353b89c2e26908472af464f27d66650.jpg'),
(4, 4, 'Kampot', 'https://i.pinimg.com/736x/c6/ff/eb/c6ffeb0c94b7eb628c6b1781ead730ea.jpg'),
(5, 1, 'SiemReap', 'https://i.pinimg.com/736x/f6/39/50/f639501ed992a75fb4cb00564af798a5.jpg'),
(6, 5, 'Battambang', 'https://i.pinimg.com/1200x/75/b2/f2/75b2f2359f37b636b2da4fdc3fb08acf.jpg'),
(7, 2, 'Pailin', 'https://i.pinimg.com/736x/b5/46/5b/b5465bf0110bad51aaa847ed4b4c9825.jpg'),
(8, 3, 'Phnom Penh', 'https://i.pinimg.com/1200x/5f/b3/e9/5fb3e9b12a18cc1f59a16c0abe30e783.jpg');

-- Insert Comments with explicit IDs (now matching the posts' content/location)
INSERT INTO comments (comment_id, post_id, user_id, content) VALUES
(1, 1, 2, 'Mondulkiri is so peaceful! Did you visit the waterfalls?'),
(2, 1, 3, 'That view in Mondulkiri is breathtaking! Perfect getaway.'),
(3, 2, 1, 'Phnom Chisor is such a hidden gem! The history is incredible.'),
(4, 2, 4, 'Love the view from the top of Phnom Chisor! Great shot!'),
(5, 3, 1, 'I miss Kratie! Did you get to see the dolphins?'),
(6, 3, 4, 'The Mekong sunset in Kratie is magical. Beautiful photo!'),
(7, 4, 2, 'Kampot vibes are unmatched! Did you go kayaking on the river?'),
(8, 4, 5, 'Kampot pepper farms are amazing! Hope you brought some back.'),
(9, 5, 3, 'Angkor Wat is incredible! Did you go at sunrise?'),
(10, 6, 1, 'Battambang has such charm! Did you ride the bamboo train?'),
(11, 7, 4, 'Pailin is so underrated! Love seeing it get more attention.'),
(12, 8, 1, 'Phnom Penh’s skyline has changed so much! Awesome shot!');

-- Insert Likes
INSERT INTO likes (user_id, post_id) VALUES
(2, 1), (3, 1), (4, 1), (5, 1),  -- Post 1 has 4 likes
(1, 2), (3, 2), (4, 2), (5, 2),  -- Post 2 has 4 likes
(1, 3), (2, 3), (4, 3), (5, 3),  -- Post 3 has 4 likes
(1, 4), (2, 4), (3, 4), (5, 4),  -- Post 4 has 4 likes
(2, 5), (3, 5), (4, 5),          -- Post 5 has 3 likes
(1, 6), (2, 6), (3, 6), (4, 6),  -- Post 6 has 4 likes
(1, 7), (3, 7), (4, 7), (5, 7),  -- Post 7 has 4 likes
(2, 8), (4, 8), (5, 8);          -- Post 8 has 3 likes

-- Insert Follower Relationships
INSERT INTO followers (follower_id, following_id) VALUES
(1, 2), (1, 3), (1, 4),
(2, 1), (2, 4), (2, 5),
(3, 1), (3, 2), (3, 4),
(4, 1), (4, 2), (4, 3), (4, 5),
(5, 1), (5, 2), (5, 3);


UPDATE posts SET like_count = (
    SELECT COUNT(*) FROM likes WHERE likes.post_id = posts.post_id
);

UPDATE posts SET comment_count = (
    SELECT COUNT(*) FROM comments WHERE comments.post_id = posts.post_id
);

UPDATE users SET follower_count = (
    SELECT COUNT(*) FROM followers WHERE followers.following_id = users.user_id
);

UPDATE users SET following_count = (
    SELECT COUNT(*) FROM followers WHERE followers.follower_id = users.user_id
);

-- 1. Get all posts with user information
SELECT
    p.post_id,
    u.username,
    u.first_name || ' ' || u.last_name AS full_name,
    p.content,
    p.created_at,
    p.like_count,
    p.comment_count
FROM posts p
INNER JOIN users u ON p.user_id = u.user_id
ORDER BY p.created_at DESC;

-- 2. Get posts with their comments
SELECT
    p.post_id,
    u1.username AS post_author,
    p.content AS post_content,
    c.content AS comment_content,
    u2.username AS comment_author,
    c.created_at AS comment_date
FROM posts p
INNER JOIN users u1 ON p.user_id = u1.user_id
LEFT JOIN comments c ON p.post_id = c.post_id
LEFT JOIN users u2 ON c.user_id = u2.user_id
ORDER BY p.created_at DESC, c.created_at ASC;

-- 3. Get user feed (posts from followed users)
SELECT
    p.post_id,
    u.username,
    p.content,
    p.created_at,
    p.like_count,
    p.comment_count
FROM posts p
INNER JOIN users u ON p.user_id = u.user_id
INNER JOIN followers f ON u.user_id = f.following_id
WHERE f.follower_id = 1  -- Feed for John (user_id = 1)
ORDER BY p.created_at DESC;

-- 4. Most popular posts
SELECT
    p.post_id,
    u.username,
    p.content,
    p.like_count,
    p.comment_count,
    (p.like_count + p.comment_count) AS engagement_score
FROM posts p
INNER JOIN users u ON p.user_id = u.user_id
ORDER BY engagement_score DESC
LIMIT 5;

-- 5. User activity summary
SELECT
    u.username,
    u.first_name || ' ' || u.last_name AS full_name,
    COUNT(DISTINCT p.post_id) AS total_posts,
    COUNT(DISTINCT c.comment_id) AS total_comments,
    COUNT(DISTINCT l.post_id) AS total_likes_given,
    u.follower_count,
    u.following_count
FROM users u
LEFT JOIN posts p ON u.user_id = p.user_id
LEFT JOIN comments c ON u.user_id = c.user_id
LEFT JOIN likes l ON u.user_id = l.user_id
GROUP BY u.user_id, u.username, u.first_name, u.last_name, u.follower_count, u.following_count;

-- 6. Posts liked by specific user
SELECT
    p.post_id,
    u.username AS post_author,
    p.content,
    p.created_at,
    l.created_at AS liked_at
FROM likes l
INNER JOIN posts p ON l.post_id = p.post_id
INNER JOIN users u ON p.user_id = u.user_id
WHERE l.user_id = 1  -- Posts liked by John
ORDER BY l.created_at DESC;

-- 7. Mutual followers
SELECT
    u1.username AS user1,
    u2.username AS user2
FROM followers f1
INNER JOIN followers f2 ON f1.follower_id = f2.following_id AND f1.following_id = f2.follower_id
INNER JOIN users u1 ON f1.follower_id = u1.user_id
INNER JOIN users u2 ON f1.following_id = u2.user_id
WHERE f1.follower_id < f1.following_id;

-- 1. Update post content for specific user
UPDATE posts
SET content = 'UPDATED: Just finished my morning coffee and ready to tackle the day! Coffee MondayMotivation Updated',
    updated_at = CURRENT_TIMESTAMP
WHERE post_id = 1 AND user_id = (
    SELECT user_id FROM users WHERE username = 'cholna_tith'
);

-- 2. Update user bio with post count
UPDATE users
SET bio = bio || ' | Posts: ' || (
    SELECT COUNT(*)
    FROM posts
    WHERE posts.user_id = users.user_id
)
WHERE user_id IN (1, 2, 3, 4, 5);

-- 1. Delete comments older than 180 days (simulated)
DELETE FROM comments
WHERE comment_id IN (
    SELECT c.comment_id
    FROM comments c
    INNER JOIN posts p ON c.post_id = p.post_id
    WHERE c.created_at < datetime('now', '-180 days')
);

-- 2. Remove likes from inactive users
DELETE FROM likes
WHERE user_id IN (
    SELECT user_id FROM users WHERE is_active = 0
);

-- 3. Remove follower relationships with inactive users
DELETE FROM followers
WHERE following_id IN (
    SELECT user_id FROM users WHERE is_active = 0
);

-- 1. Top content creators by engagement
SELECT
    u.username,
    COUNT(p.post_id) AS total_posts,
    SUM(p.like_count) AS total_likes,
    SUM(p.comment_count) AS total_comments,
    ROUND(AVG(CAST(p.like_count AS REAL)), 2) AS avg_likes_per_post
FROM users u
INNER JOIN posts p ON u.user_id = p.user_id
GROUP BY u.user_id, u.username
ORDER BY total_likes DESC;

-- 2. Most active commenters
SELECT
    u.username,
    COUNT(c.comment_id) AS total_comments,
    COUNT(DISTINCT c.post_id) AS posts_commented_on
FROM users u
INNER JOIN comments c ON u.user_id = c.user_id
GROUP BY u.user_id, u.username
ORDER BY total_comments DESC;

-- 3. Network influence analysis
SELECT
    u.username,
    u.follower_count,
    u.following_count,
    COUNT(p.post_id) AS total_posts,
    SUM(p.like_count) AS total_likes_received
FROM users u
LEFT JOIN posts p ON u.user_id = p.user_id
GROUP BY u.user_id, u.username, u.follower_count, u.following_count
ORDER BY u.follower_count DESC;

-- Verify data integrity
SELECT 'Users' AS table_name, COUNT(*) AS record_count FROM users
UNION ALL
SELECT 'Posts', COUNT(*) FROM posts
UNION ALL
SELECT 'Comments', COUNT(*) FROM comments
UNION ALL
SELECT 'Likes', COUNT(*) FROM likes
UNION ALL
SELECT 'Followers', COUNT(*) FROM followers;


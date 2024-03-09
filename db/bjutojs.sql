/*
SQLyog Professional v12.09 (64 bit)
MySQL - 5.7.34 : Database - bjutoj
*********************************************************************
*/


/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE IF NOT EXISTS`bjutoj` DEFAULT CHARACTER SET utf8;

USE `bjutoj`;

/*Table structure for table `announcement` */

DROP TABLE IF EXISTS `announcement`;

-- 创建 `announcement` 表，用于存储公告信息。
CREATE TABLE `announcement` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT, -- 公告 ID，自增长整数型。
  `title` varchar(255) NOT NULL, -- 公告标题，最大长度为 255 字符。
  `content` longtext, -- 公告内容，使用长文本类型存储。
  `uid` varchar(255) DEFAULT NULL, -- 公告发布者的 UUID。
  `status` int(11) DEFAULT '0' COMMENT '0可见，1不可见', -- 公告状态，默认为可见状态。
  `gid` bigint(20) unsigned DEFAULT NULL, -- 所属小组的 ID。
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP, -- 公告创建时间。
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 公告修改时间。
  PRIMARY KEY (`id`), -- 主键为公告 ID。
  KEY `uid` (`uid`), -- 根据发布者 UUID 创建索引。
  CONSTRAINT `announcement_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE, -- 外键约束，关联用户信息表。
  CONSTRAINT `announcement_ibfk_2` FOREIGN KEY (`gid`) REFERENCES `group` (`id`) ON DELETE CASCADE ON UPDATE CASCADE -- 外键约束，关联小组表。
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

/*Table structure for table `auth` */

DROP TABLE IF EXISTS `auth`;

-- 创建 `auth` 表，用于存储权限信息。
CREATE TABLE `auth` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT, -- 权限 ID，自增长整数型。
  `name` varchar(100) DEFAULT NULL COMMENT '权限名称', -- 权限名称，最大长度为 100 字符。
  `permission` varchar(100) DEFAULT NULL COMMENT '权限字符串', -- 权限字符串，最大长度为 100 字符。
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0可用，1不可用', -- 权限状态，默认为可用状态。
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP, -- 权限创建时间。
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 权限修改时间。
  PRIMARY KEY (`id`) -- 主键为权限 ID。
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

/*Table structure for table `category` */

DROP TABLE IF EXISTS `category`;

-- 创建 `category` 表，用于存储分类信息。
CREATE TABLE `category` (
  `id` int(11) NOT NULL AUTO_INCREMENT, -- 分类 ID，自增长整数型。
  `name` varchar(255) DEFAULT NULL, -- 分类名称，最大长度为 255 字符。
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP, -- 分类创建时间。
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 分类修改时间。
  PRIMARY KEY (`id`) -- 主键为分类 ID。
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

/*Table structure for table `code_template` */

DROP TABLE IF EXISTS `code_template`;

-- 创建 `code_template` 表，用于存储代码模板信息。
CREATE TABLE `code_template` (
  `id` int(11) NOT NULL AUTO_INCREMENT, -- 模板 ID，自增长整数型。
  `pid` bigint(20) unsigned NOT NULL, -- 关联的问题 ID。
  `lid` bigint(20) unsigned NOT NULL, -- 关联的语言 ID。
  `code` longtext NOT NULL, -- 代码模板内容，长文本类型。
  `status` tinyint(1) DEFAULT '0', -- 模板状态，默认为 0。
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP, -- 模板创建时间。
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 模板修改时间。
  PRIMARY KEY (`id`), -- 主键为模板 ID。
  KEY `pid` (`pid`), -- 与问题 ID 建立索引。
  KEY `lid` (`lid`), -- 与语言 ID 建立索引。
  CONSTRAINT `code_template_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `problem` (`id`) ON DELETE CASCADE ON UPDATE CASCADE, -- 外键约束，关联 problem 表的 id 字段。
  CONSTRAINT `code_template_ibfk_2` FOREIGN KEY (`lid`) REFERENCES `language` (`id`) ON DELETE CASCADE ON UPDATE CASCADE -- 外键约束，关联 language 表的 id 字段。
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

/*Table structure for table `comment` */

DROP TABLE IF EXISTS `comment`;

-- 创建 `comment` 表，用于存储评论信息。
CREATE TABLE `comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT, -- 评论ID，自增长整数型。
  `cid` bigint(20) unsigned DEFAULT NULL COMMENT 'null表示无引用比赛', -- 关联的比赛ID，可为空。
  `did` int(11) DEFAULT NULL COMMENT 'null表示无引用讨论', -- 关联的讨论ID，可为空。
  `content` longtext COMMENT '评论内容', -- 评论内容，长文本类型。
  `from_uid` varchar(32) NOT NULL COMMENT '评论者id', -- 评论者ID。
  `from_name` varchar(255) DEFAULT NULL COMMENT '评论者用户名', -- 评论者用户名，可为空。
  `from_avatar` varchar(255) DEFAULT NULL COMMENT '评论组头像地址', -- 评论者头像地址，可为空。
  `from_role` varchar(20) DEFAULT NULL COMMENT '评论者角色', -- 评论者角色，可为空。
  `like_num` int(11) DEFAULT '0' COMMENT '点赞数量', -- 点赞数量，默认为0。
  `status` int(11) DEFAULT '0' COMMENT '是否封禁或逻辑删除该评论', -- 评论状态，默认为0。
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP, -- 评论创建时间。
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 评论修改时间。
  PRIMARY KEY (`id`), -- 主键为评论ID。
  KEY `uid` (`from_uid`), -- 与评论者ID建立索引。
  KEY `from_avatar` (`from_avatar`), -- 与评论者头像地址建立索引。
  KEY `comment_ibfk_7` (`did`), -- 与讨论ID建立索引。
  KEY `cid` (`cid`), -- 与比赛ID建立索引。
  CONSTRAINT `comment_ibfk_6` FOREIGN KEY (`from_avatar`) REFERENCES `user_info` (`avatar`) ON DELETE CASCADE ON UPDATE CASCADE, -- 外键约束，关联user_info表的avatar字段。
  CONSTRAINT `comment_ibfk_7` FOREIGN KEY (`did`) REFERENCES `discussion` (`id`) ON DELETE CASCADE ON UPDATE CASCADE, -- 外键约束，关联discussion表的id字段。
  CONSTRAINT `comment_ibfk_8` FOREIGN KEY (`cid`) REFERENCES `contest` (`id`) ON DELETE CASCADE ON UPDATE CASCADE -- 外键约束，关联contest表的id字段。
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

/*Table structure for table `comment_like` */

DROP TABLE IF EXISTS `comment_like`;

-- 创建 `comment_like` 表，用于存储评论点赞信息。
CREATE TABLE `comment_like` (
  `id` int(11) NOT NULL AUTO_INCREMENT, -- 点赞ID，自增长整数型。
  `uid` varchar(255) NOT NULL, -- 点赞者ID，不能为空。
  `cid` int(11) NOT NULL, -- 关联的评论ID，不能为空。
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP, -- 点赞创建时间。
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 点赞修改时间。
  PRIMARY KEY (`id`), -- 主键为点赞ID。
  KEY `uid` (`uid`), -- 与点赞者ID建立索引。
  KEY `cid` (`cid`), -- 与评论ID建立索引。
  CONSTRAINT `comment_like_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE, -- 外键约束，关联user_info表的uuid字段。
  CONSTRAINT `comment_like_ibfk_2` FOREIGN KEY (`cid`) REFERENCES `comment` (`id`) ON DELETE CASCADE ON UPDATE CASCADE -- 外键约束，关联comment表的id字段。
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

/*Table structure for table `contest` */

DROP TABLE IF EXISTS `contest`;

-- 创建 `contest` 表，用于存储比赛信息。
CREATE TABLE `contest` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT, -- 比赛ID，自增长整数型。
  `uid` varchar(32) NOT NULL COMMENT '比赛创建者id', -- 比赛创建者ID，不能为空。
  `author` varchar(255) DEFAULT NULL COMMENT '比赛创建者的用户名', -- 比赛创建者的用户名。
  `title` varchar(255) DEFAULT NULL COMMENT '比赛标题', -- 比赛标题。
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '0为acm赛制，1为比分赛制', -- 比赛类型，0表示ACM赛制，1表示比分赛制。
  `description` longtext COMMENT '比赛说明', -- 比赛说明。
  `source` int(11) DEFAULT '0' COMMENT '比赛来源，原创为0，克隆赛为比赛id', -- 比赛来源，原创为0，克隆赛为比赛ID。
  `auth` int(11) NOT NULL COMMENT '0为公开赛，1为私有赛（访问有密码），2为保护赛（提交有密码）', -- 比赛权限，0表示公开赛，1表示私有赛（访问有密码），2表示保护赛（提交有密码）。
  `pwd` varchar(255) DEFAULT NULL COMMENT '比赛密码', -- 比赛密码。
  `start_time` datetime DEFAULT NULL COMMENT '开始时间', -- 比赛开始时间。
  `end_time` datetime DEFAULT NULL COMMENT '结束时间', -- 比赛结束时间。
  `duration` bigint(20) DEFAULT NULL COMMENT '比赛时长(s)', -- 比赛时长（秒）。
  `seal_rank` tinyint(1) DEFAULT '0' COMMENT '是否开启封榜', -- 是否开启封榜，1表示开启，0表示关闭。
  `seal_rank_time` datetime DEFAULT NULL COMMENT '封榜起始时间，一直到比赛结束，不刷新榜单', -- 封榜起始时间，一直到比赛结束，不刷新榜单。
  `auto_real_rank` tinyint(1) DEFAULT '1' COMMENT '比赛结束是否自动解除封榜,自动转换成真实榜单', -- 比赛结束是否自动解除封榜，1表示自动解除封榜并转换为真实榜单，0表示不自动解除封榜。
  `status` int(11) DEFAULT NULL COMMENT '-1为未开始，0为进行中，1为已结束', -- 比赛状态，-1表示未开始，0表示进行中，1表示已结束。
  `visible` tinyint(1) DEFAULT '1' COMMENT '是否可见', -- 比赛是否可见，1表示可见，0表示不可见。
  `open_print` tinyint(1) DEFAULT '0' COMMENT '是否打开打印功能', -- 是否打开打印功能，1表示打开，0表示关闭。
  `open_account_limit` tinyint(1) DEFAULT '0' COMMENT '是否开启账号限制', -- 是否开启账号限制，1表示开启，0表示关闭。
  `account_limit_rule` mediumtext COMMENT '账号限制规则', -- 账号限制规则。
  `rank_show_name` varchar(20) DEFAULT 'username' COMMENT '排行榜显示（username、nickname、realname）', -- 排行榜显示方式，可选值为username、nickname、realname。
  `open_rank` tinyint(1) DEFAULT '0' COMMENT '是否开放比赛榜单', -- 是否开放比赛榜单，1表示开放，0表示关闭。
  `star_account` mediumtext COMMENT '打星用户列表', -- 打星用户列表。
  `oi_rank_score_type` varchar(255) DEFAULT 'Recent' COMMENT 'oi排行榜得分方式，Recent、Highest', -- OI排行榜得分方式，可选值为Recent、Highest。
  `is_group` tinyint(1) DEFAULT '0', -- 是否为团队比赛，1表示是，0表示否。
  `gid` bigint(20) unsigned DEFAULT NULL, -- 关联的团队ID。
  `award_type` int(11) DEFAULT '0' COMMENT '奖项类型：0(不设置),1(设置占比),2(设置人数)', -- 奖项类型，0表示不设置奖项，1表示按占比设置奖项，2表示按人数设置奖项。
  `award_config` text DEFAULT NULL COMMENT '奖项配置 json', -- 奖项配置JSON。
  `allow_end_submit` tinyint(1) DEFAULT '0' COMMENT '是否允许比赛结束后进行提交', -- 是否允许比赛结束后进行提交，1表示允许，0表示不允许。
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP, -- 比赛创建时间。
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 比赛修改时间。
  PRIMARY KEY (`id`,`uid`), -- 主键为比赛ID和创建者ID。
  KEY `uid` (`uid`), -- 与比赛创建者ID建立索引。
  CONSTRAINT `contest_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE, -- 外键约束，关联user_info表的uuid字段。
  CONSTRAINT `contest_ibfk_2` FOREIGN KEY (`gid`) REFERENCES `group` (`id`) ON DELETE CASCADE ON UPDATE CASCADE -- 外键约束，关联group表的id字段。
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8;

/*Table structure for table `contest_announcement` */

DROP TABLE IF EXISTS `contest_announcement`;

-- 创建 `contest_announcement` 表，用于关联比赛和公告信息。
CREATE TABLE `contest_announcement` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT, -- 公告ID，自增长整数型。
  `aid` bigint(20) unsigned NOT NULL COMMENT '公告id', -- 公告ID，不能为空。
  `cid` bigint(20) unsigned NOT NULL COMMENT '比赛id', -- 比赛ID，不能为空。
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP, -- 创建时间，默认为当前时间戳。
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 修改时间，默认为当前时间戳，更新时自动更新时间。
  PRIMARY KEY (`id`), -- 主键为公告ID。
  KEY `contest_announcement_ibfk_1` (`cid`), -- 与比赛ID建立索引。
  KEY `contest_announcement_ibfk_2` (`aid`), -- 与公告ID建立索引。
  CONSTRAINT `contest_announcement_ibfk_1` FOREIGN KEY (`cid`) REFERENCES `contest` (`id`) ON DELETE CASCADE ON UPDATE CASCADE, -- 外键约束，关联contest表的id字段，级联删除和更新操作。
  CONSTRAINT `contest_announcement_ibfk_2` FOREIGN KEY (`aid`) REFERENCES `announcement` (`id`) ON DELETE CASCADE ON UPDATE CASCADE -- 外键约束，关联announcement表的id字段，级联删除和更新操作。
) ENGINE=InnoDB DEFAULT CHARSET=utf8; -- 使用InnoDB存储引擎，字符集为utf8。


/*Table structure for table `contest_explanation` */

DROP TABLE IF EXISTS `contest_explanation`;

-- 创建 `contest_explanation` 表，用于存储比赛解释说明信息。
CREATE TABLE `contest_explanation` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT, -- 解释说明ID，自增长整数型。
  `cid` bigint(20) unsigned NOT NULL, -- 比赛ID，不能为空。
  `uid` varchar(32) NOT NULL COMMENT '发布者（必须为比赛创建者或者超级管理员才能）', -- 发布者ID，不能为空，必须为比赛创建者或者超级管理员。
  `content` longtext COMMENT '内容(支持markdown)', -- 解释说明内容，支持Markdown格式。
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP, -- 创建时间，默认为当前时间戳。
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 修改时间，默认为当前时间戳，更新时自动更新时间。
  PRIMARY KEY (`id`), -- 主键为解释说明ID。
  KEY `uid` (`uid`), -- 与发布者ID建立索引。
  KEY `contest_explanation_ibfk_1` (`cid`), -- 与比赛ID建立索引。
  CONSTRAINT `contest_explanation_ibfk_1` FOREIGN KEY (`cid`) REFERENCES `contest` (`id`) ON DELETE CASCADE ON UPDATE CASCADE, -- 外键约束，关联contest表的id字段，级联删除和更新操作。
  CONSTRAINT `contest_explanation_ibfk_2` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE -- 外键约束，关联user_info表的uuid字段，级联删除和更新操作。
) ENGINE=InnoDB DEFAULT CHARSET=utf8; -- 使用InnoDB存储引擎，字符集为utf8。


/*Table structure for table `contest_problem` */

DROP TABLE IF EXISTS `contest_print`;

-- 创建 `contest_print` 表，用于存储比赛打印信息。
CREATE TABLE `contest_print` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT, -- 打印信息ID，自增长整数型。
  `username` varchar(100) DEFAULT NULL, -- 用户名，可为空。
  `realname` varchar(100) DEFAULT NULL, -- 真实姓名，可为空。
  `cid` bigint(20) unsigned DEFAULT NULL, -- 比赛ID，可为空。
  `content` longtext NOT NULL, -- 打印内容，不能为空。
  `status` int(11) DEFAULT '0', -- 状态，默认为0。
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP, -- 创建时间，默认为当前时间戳。
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP, -- 修改时间，默认为当前时间戳。
  PRIMARY KEY (`id`), -- 主键为打印信息ID。
  KEY `cid` (`cid`), -- 与比赛ID建立索引。
  KEY `username` (`username`), -- 与用户名建立索引。
  CONSTRAINT `contest_print_ibfk_1` FOREIGN KEY (`cid`) REFERENCES `contest` (`id`) ON DELETE CASCADE ON UPDATE CASCADE, -- 外键约束，关联contest表的id字段，级联删除和更新操作。
  CONSTRAINT `contest_print_ibfk_2` FOREIGN KEY (`username`) REFERENCES `user_info` (`username`) ON DELETE CASCADE ON UPDATE CASCADE -- 外键约束，关联user_info表的username字段，级联删除和更新操作。
) ENGINE=InnoDB DEFAULT CHARSET=utf8; -- 使用InnoDB存储引擎，字符集为utf8。



DROP TABLE IF EXISTS `contest_problem`;

-- 创建 `contest_problem` 表，用于存储比赛题目信息。
CREATE TABLE `contest_problem` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键', -- 题目信息ID，自增长整数型。
  `display_id` varchar(255) NOT NULL COMMENT '该题目在比赛中的顺序id', -- 在比赛中的顺序ID，字符串类型。
  `cid` bigint(20) unsigned NOT NULL COMMENT '比赛id', -- 比赛ID，非空。
  `pid` bigint(20) unsigned NOT NULL COMMENT '题目id', -- 题目ID，非空。
  `display_title` varchar(255) NOT NULL COMMENT '该题目在比赛中的标题，默认为原名字', -- 在比赛中的标题，字符串类型。
  `color` varchar(255) DEFAULT NULL COMMENT '气球颜色', -- 气球颜色，可为空。
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP, -- 创建时间，默认为当前时间戳。
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 修改时间，默认为当前时间戳。
  PRIMARY KEY (`id`,`cid`,`pid`), -- 主键由题目信息ID、比赛ID和题目ID组成。
  UNIQUE KEY `display_id` (`display_id`,`cid`,`pid`), -- 唯一键由在比赛中的顺序ID、比赛ID和题目ID组成。
  KEY `contest_problem_ibfk_1` (`cid`), -- 与比赛ID建立索引。
  KEY `contest_problem_ibfk_2` (`pid`), -- 与题目ID建立索引。
  CONSTRAINT `contest_problem_ibfk_1` FOREIGN KEY (`cid`) REFERENCES `contest` (`id`) ON DELETE CASCADE ON UPDATE CASCADE, -- 外键约束，关联contest表的id字段，级联删除和更新操作。
  CONSTRAINT `contest_problem_ibfk_2` FOREIGN KEY (`pid`) REFERENCES `problem` (`id`) ON DELETE CASCADE ON UPDATE CASCADE -- 外键约束，关联problem表的id字段，级联删除和更新操作。
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8; -- 使用InnoDB存储引擎，设置自增起始值为1，字符集为utf8。


/*Table structure for table `contest_record` */

DROP TABLE IF EXISTS `contest_record`;

-- 创建 `contest_record` 表，用于存储比赛记录信息。
CREATE TABLE `contest_record` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键', -- 记录ID，自增长整数型。
  `cid` bigint(20) unsigned DEFAULT NULL COMMENT '比赛id', -- 比赛ID，可为空。
  `uid` varchar(255) NOT NULL COMMENT '用户id', -- 用户ID，非空。
  `pid` bigint(20) unsigned DEFAULT NULL COMMENT '题目id', -- 题目ID，可为空。
  `cpid` bigint(20) unsigned DEFAULT NULL COMMENT '比赛中的题目的id', -- 比赛中的题目ID，可为空。
  `username` varchar(255) DEFAULT NULL COMMENT '用户名', -- 用户名，可为空。
  `realname` varchar(255) DEFAULT NULL COMMENT '真实姓名', -- 真实姓名，可为空。
  `display_id` varchar(255) DEFAULT NULL COMMENT '比赛中展示的id', -- 比赛中展示的ID，可为空。
  `submit_id` bigint(20) unsigned NOT NULL COMMENT '提交id，用于可重判', -- 提交ID，非空，用于可重判。
  `status` int(11) DEFAULT NULL COMMENT '提交结果，0表示未AC通过不罚时，1表示AC通过，-1为未AC通过算罚时', -- 提交结果，表示不同的提交状态。
  `submit_time` datetime NOT NULL COMMENT '具体提交时间', -- 具体提交时间，非空。
  `time` bigint(20) unsigned DEFAULT NULL COMMENT '提交时间，为提交时间减去比赛时间', -- 提交时间，为提交时间减去比赛时间。
  `score` int(11) DEFAULT NULL COMMENT 'OI比赛的得分', -- OI比赛的得分，可为空。
  `use_time` int(11) DEFAULT NULL COMMENT '运行耗时', -- 运行耗时，可为空。
  `first_blood` tinyint(1) DEFAULT '0' COMMENT '是否为一血AC(废弃)', -- 是否为一血AC（已废弃），默认为0。
  `checked` tinyint(1) DEFAULT '0' COMMENT 'AC是否已校验', -- AC是否已校验，可为空，默认为0。
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP, -- 创建时间，默认为当前时间戳。
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP, -- 修改时间，默认为当前时间戳。
  PRIMARY KEY (`id`,`submit_id`), -- 主键由记录ID和提交ID组成。
  KEY `uid` (`uid`), -- 与用户ID建立索引。
  KEY `pid` (`pid`), -- 与题目ID建立索引。
  KEY `cpid` (`cpid`), -- 与比赛中的题目ID建立索引。
  KEY `submit_id` (`submit_id`), -- 与提交ID建立索引。
  KEY `index_cid` (`cid`), -- 与比赛ID建立索引。
  KEY `index_time` (`time`), -- 与提交时间建立索引。
  CONSTRAINT `contest_record_ibfk_1` FOREIGN KEY (`cid`) REFERENCES `contest` (`id`) ON DELETE CASCADE ON UPDATE CASCADE, -- 外键约束，关联contest表的id字段，级联删除和更新操作。
  CONSTRAINT `contest_record_ibfk_2` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE, -- 外键约束，关联user_info表的uuid字段，级联删除和更新操作。
  CONSTRAINT `contest_record_ibfk_3` FOREIGN KEY (`pid`) REFERENCES `problem` (`id`) ON DELETE CASCADE ON UPDATE CASCADE, -- 外键约束，关联problem表的id字段，级联删除和更新操作。
  CONSTRAINT `contest_record_ibfk_4` FOREIGN KEY (`cpid`) REFERENCES `contest_problem` (`id`) ON DELETE CASCADE ON UPDATE CASCADE, -- 外键约束，关联contest_problem表的id字段，级联删除和更新操作。
  CONSTRAINT `contest_record_ibfk_5` FOREIGN KEY (`submit_id`) REFERENCES `judge` (`submit_id`) ON DELETE CASCADE ON UPDATE CASCADE -- 外键约束，关联judge表的submit_id字段，级联删除和更新操作。
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8; -- 使用InnoDB存储引擎，设置自增起始值为1，字符集为utf8。


/*Table structure for table `contest_register` */

DROP TABLE IF EXISTS `contest_register`;

-- 创建 `contest_register` 表，用于存储比赛注册信息。
CREATE TABLE `contest_register` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT, -- 自增的注册ID，无符号长整型。
  `cid` bigint(20) unsigned NOT NULL COMMENT '比赛id', -- 比赛ID，无符号长整型，不能为空。
  `uid` varchar(32) NOT NULL COMMENT '用户id', -- 用户ID，字符串类型，不能为空。
  `status` int(11) DEFAULT '0' COMMENT '默认为0表示正常，1为失效。', -- 注册状态，默认为0表示正常，1表示失效。整型。
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP, -- 创建时间，默认为当前时间戳。
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 最后修改时间，默认为当前时间戳，当记录被更新时自动更新该字段的值。
  PRIMARY KEY (`id`,`cid`,`uid`), -- 主键由id、cid和uid组成。
  UNIQUE KEY `cid_uid_unique` (`cid`,`uid`), -- 唯一索引，确保(cid, uid)的组合唯一。
  KEY `contest_register_ibfk_2` (`uid`), -- uid外键索引。
  CONSTRAINT `contest_register_ibfk_1` FOREIGN KEY (`cid`) REFERENCES `contest` (`id`) ON DELETE CASCADE ON UPDATE CASCADE, -- 外键约束，关联contest表的id字段，级联删除和更新操作。
  CONSTRAINT `contest_register_ibfk_2` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE -- 外键约束，关联user_info表的uuid字段，级联删除和更新操作。
) ENGINE=InnoDB DEFAULT CHARSET=utf8; -- 使用InnoDB存储引擎，字符集为utf8。


/*Table structure for table `contest_score` */

DROP TABLE IF EXISTS `contest_score`;

-- 创建 `contest_score` 表，用于存储比赛得分信息。
CREATE TABLE `contest_score` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT, -- 得分记录ID，无符号长整型。
  `cid` bigint(20) unsigned NOT NULL, -- 比赛ID，无符号长整型，不能为空。
  `last` int(11) DEFAULT NULL COMMENT 'Previous score before the contest', -- 比赛前的得分，整型，默认为空值。
  `change` int(11) DEFAULT NULL COMMENT 'Score change', -- 得分变化，整型，默认为空值。
  `now` int(11) DEFAULT NULL COMMENT 'Current score', -- 当前的得分，整型，默认为空值。
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP, -- 创建时间，默认为当前时间戳。
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 最后修改时间，默认为当前时间戳，当记录被更新时自动更新该字段的值。

  PRIMARY KEY (`id`,`cid`), -- 主键由id和cid组成。
  KEY `contest_score_ibfk_1` (`cid`), -- cid外键索引。
  CONSTRAINT `contest_score_ibfk_1` FOREIGN KEY (`cid`) REFERENCES `contest` (`id`) ON DELETE CASCADE ON UPDATE CASCADE -- 外键约束，关联contest表的id字段，级联删除和更新操作。
) ENGINE=InnoDB DEFAULT CHARSET=utf8; -- 使用InnoDB存储引擎，字符集为utf8。


/*Table structure for table `discussion` */

DROP TABLE IF EXISTS `discussion`;

-- 创建 `discussion` 表，用于存储讨论信息。
CREATE TABLE `discussion` (
  `id` int(11) NOT NULL AUTO_INCREMENT, -- 讨论ID，整型，不能为空，自动递增。
  `category_id` int(11) NOT NULL COMMENT '分类id', -- 分类ID，整型，不能为空，用于标识讨论所属分类。
  `title` varchar(255) DEFAULT NULL COMMENT '讨论标题', -- 讨论标题，字符串，最大长度255，可以为空。
  `description` varchar(255) DEFAULT NULL COMMENT '讨论简介', -- 讨论简介，字符串，最大长度255，可以为空。
  `content` longtext COMMENT '讨论内容', -- 讨论内容，长文本类型，用于存储较长的讨论内容。
  `pid` varchar(255) DEFAULT NULL COMMENT '关联题目id', -- 关联题目ID，字符串，最大长度255，可以为空，用于关联特定题目。
  `uid` varchar(32) NOT NULL COMMENT '发表者id', -- 发表者ID，字符串，最大长度32，不能为空。
  `author` varchar(255) NOT NULL COMMENT '发表者用户名', -- 发表者用户名，字符串，最大长度255，不能为空。
  `avatar` varchar(255) DEFAULT NULL COMMENT '发表讨论者头像', -- 发表讨论者头像，字符串，最大长度255，可以为空。
  `role` varchar(25) DEFAULT 'user' COMMENT '发表者角色', -- 发表者角色，字符串，最大长度25，默认为'user'。
  `view_num` int(11) DEFAULT '0' COMMENT '浏览数量', -- 浏览数量，整型，默认为0。
  `like_num` int(11) DEFAULT '0' COMMENT '点赞数量', -- 点赞数量，整型，默认为0。
  `top_priority` tinyint(1) DEFAULT '0' COMMENT '优先级，是否置顶', -- 优先级，是否置顶，布尔类型，默认为0。
  `comment_num` int(11) DEFAULT '0' COMMENT '评论数量', -- 评论数量，整型，默认为0。
  `status` int(1) DEFAULT '0' COMMENT '是否封禁该讨论', -- 讨论状态，整型，默认为0，用于标识讨论是否被封禁。
  `gid` bigint(20) unsigned DEFAULT NULL, -- 组ID，无符号长整型，可以为空。
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP, -- 创建时间，默认为当前时间戳。
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 最后修改时间，默认为当前时间戳，当记录被更新时自动更新该字段的值。

  PRIMARY KEY (`id`), -- 主键由id组成。
  KEY `category_id` (`category_id`), -- category_id索引。
  KEY `discussion_ibfk_4` (`avatar`), -- avatar索引。
  KEY `discussion_ibfk_1` (`uid`), -- uid索引。
  KEY `pid` (`pid`), -- pid索引。
  CONSTRAINT `discussion_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE NO ACTION ON UPDATE CASCADE, -- uid外键约束，关联user_info表的uuid字段，不执行删除操作，执行级联更新操作。
  CONSTRAINT `discussion_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE, -- category_id外键约束，关联category表的id字段，不执行删除操作，执行级联更新操作。
  CONSTRAINT `discussion_ibfk_4` FOREIGN KEY (`avatar`) REFERENCES `user_info` (`avatar`) ON DELETE NO ACTION ON UPDATE CASCADE, -- avatar外键约束，关联user_info表的avatar字段，不执行删除操作，执行级联更新操作。
  CONSTRAINT `discussion_ibfk_6` FOREIGN KEY (`pid`) REFERENCES `problem` (`problem_id`) ON DELETE CASCADE ON UPDATE CASCADE, -- pid外键约束，关联problem表的problem_id字段，执行级联删除和更新操作。
  CONSTRAINT `discussion_ibfk_3` FOREIGN KEY (`gid`) REFERENCES `group` (`id`) ON DELETE CASCADE ON UPDATE CASCADE -- gid外键约束，关联group表的id字段，执行级联删除和更新操作。
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8; -- 使用InnoDB存储引擎，初始自增值为1，字符集为utf8。


/*Table structure for table `discussion_like` */

DROP TABLE IF EXISTS `discussion_like`;

CREATE TABLE `discussion_like` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(255) NOT NULL,
  `did` int(11) NOT NULL,
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `did` (`did`),
  KEY `uid` (`uid`),
  CONSTRAINT `discussion_like_ibfk_1` FOREIGN KEY (`did`) REFERENCES `discussion` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `discussion_like_ibfk_2` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

/*Table structure for table `discussion_report` */

DROP TABLE IF EXISTS `discussion_report`;

-- 创建 `discussion_like` 表，用于存储讨论点赞信息。
CREATE TABLE `discussion_like` (
  `id` int(11) NOT NULL AUTO_INCREMENT, -- 点赞ID，整型，不能为空，自动递增。
  `uid` varchar(255) NOT NULL, -- 用户ID，字符串，最大长度255，不能为空。
  `did` int(11) NOT NULL, -- 讨论ID，整型，不能为空。
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP, -- 创建时间，默认为当前时间戳。
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 最后修改时间，默认为当前时间戳，当记录被更新时自动更新该字段的值。

  PRIMARY KEY (`id`), -- 主键由id组成。
  KEY `did` (`did`), -- did索引。
  KEY `uid` (`uid`), -- uid索引。
  CONSTRAINT `discussion_like_ibfk_1` FOREIGN KEY (`did`) REFERENCES `discussion` (`id`) ON DELETE CASCADE ON UPDATE CASCADE, -- did外键约束，关联discussion表的id字段，执行级联删除和更新操作。
  CONSTRAINT `discussion_like_ibfk_2` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE -- uid外键约束，关联user_info表的uuid字段，执行级联删除和更新操作。
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8; -- 使用InnoDB存储引擎，初始自增值为1，字符集为utf8。


/*Table structure for table `file` */

DROP TABLE IF EXISTS `file`;

-- 创建 `file` 表，用于存储文件信息。
CREATE TABLE `file` (
  `id` bigint(32) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键', -- 文件ID，无符号长整型，不能为空，自动递增。
  `uid` varchar(32) DEFAULT NULL COMMENT '用户id', -- 用户ID，字符串，最大长度32，可以为空。
  `name` varchar(255) NOT NULL COMMENT '文件名', -- 文件名，字符串，最大长度255，不能为空。
  `suffix` varchar(255) NOT NULL COMMENT '文件后缀格式', -- 文件后缀格式，字符串，最大长度255，不能为空。
  `folder_path` varchar(255) NOT NULL COMMENT '文件所在文件夹的路径', -- 文件所在文件夹的路径，字符串，最大长度255，不能为空。
  `file_path` varchar(255) DEFAULT NULL COMMENT '文件绝对路径', -- 文件绝对路径，字符串，最大长度255，可以为空。
  `type` varchar(255) DEFAULT NULL COMMENT '文件所属类型，例如avatar', -- 文件所属类型，例如avatar，字符串，最大长度255，可以为空。
  `delete` tinyint(1) DEFAULT '0' COMMENT '是否删除', -- 是否删除，布尔类型，默认为0。
  `gid` bigint(20) unsigned DEFAULT NULL, -- 组ID，无符号长整型，可以为空。
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP, -- 创建时间，默认为当前时间戳。
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 最后修改时间，默认为当前时间戳，当记录被更新时自动更新该字段的值。

  PRIMARY KEY (`id`), -- 主键由id组成。
  KEY `uid` (`uid`), -- uid索引。
  CONSTRAINT `file_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE SET NULL ON UPDATE CASCADE, -- uid外键约束，关联user_info表的uuid字段，执行级联设置为空和更新操作。
  CONSTRAINT `file_ibfk_2` FOREIGN KEY (`gid`) REFERENCES `group` (`id`) ON DELETE SET NULL ON UPDATE CASCADE -- gid外键约束，关联group表的id字段，执行级联设置为空和更新操作。
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8; -- 使用InnoDB存储引擎，初始自增值为1，字符集为utf8。

/*Table structure for table `judge` */

DROP TABLE IF EXISTS `judge`;

-- 创建 `judge` 表，用于存储用户提交的判题记录。
CREATE TABLE `judge` (
  `submit_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT, -- 提交ID，无符号长整型，不能为空，自动递增。
  `pid` bigint(20) unsigned NOT NULL COMMENT '题目id', -- 题目ID，无符号长整型，不能为空。
  `display_pid` varchar(255) NOT NULL COMMENT '题目展示id', -- 题目展示ID，字符串，最大长度255，不能为空。
  `uid` varchar(32) NOT NULL COMMENT '用户id', -- 用户ID，字符串，最大长度32，不能为空。
  `username` varchar(255) DEFAULT NULL COMMENT '用户名', -- 用户名，字符串，最大长度255，可以为空。
  `submit_time` datetime NOT NULL COMMENT '提交的时间', -- 提交时间，日期时间类型，不能为空。
  `status` int(11) DEFAULT NULL COMMENT '结果码具体参考文档', -- 判题结果码，整型，最大长度11，可以为空。
  `share` tinyint(1) DEFAULT '0' COMMENT '0为仅自己可见，1为全部人可见。', -- 是否共享判题结果，布尔类型，默认为0。
  `error_message` mediumtext COMMENT '错误提醒（编译错误，或者vj提醒）', -- 错误提示信息，中等文本类型，可以为空。
  `time` int(11) DEFAULT NULL COMMENT '运行时间(ms)', -- 运行时间，整型，最大长度11，可以为空。
  `memory` int(11) DEFAULT NULL COMMENT '运行内存（kb）', -- 运行内存，整型，最大长度11，可以为空。
  `score` int(11) DEFAULT NULL COMMENT 'IO判题则不为空', -- 得分，整型，最大长度11，可以为空。
  `length` int(11) DEFAULT NULL COMMENT '代码长度', -- 代码长度，整型，最大长度11，可以为空。
  `code` longtext NOT NULL COMMENT '代码', -- 代码内容，长文本类型，不能为空。
  `language` varchar(255) DEFAULT NULL COMMENT '代码语言', -- 代码语言，字符串，最大长度255，可以为空。
  `gid` bigint(20) unsigned DEFAULT NULL COMMENT '团队id，不为团队内提交则为null', -- 所在团队ID，无符号长整型，可以为空。
  `cid` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '比赛id，非比赛题目默认为0', -- 比赛ID，无符号长整型，不能为空，默认为0。
  `cpid` bigint(20) unsigned DEFAULT '0' COMMENT '比赛中题目排序id，非比赛题目默认为0', -- 比赛中的题目ID，无符号长整型，默认为0。
  `judger` varchar(20) DEFAULT NULL COMMENT '判题机ip', -- 判题机IP，字符串，最大长度20，可以为空。
  `ip` varchar(20) DEFAULT NULL COMMENT '提交者所在ip', -- 提交者IP，字符串，最大长度20，可以为空。
  `version` int(11) NOT NULL DEFAULT '0' COMMENT '乐观锁', -- 乐观锁机制，整型，最大长度11，不能为空，初始值为0。
  `oi_rank_score` int(11) NULL DEFAULT '0' COMMENT 'oi排行榜得分', -- OI排行榜得分，整型，最大长度11，可以为空，默认值为0。
  `vjudge_submit_id` bigint(20) unsigned NULL  COMMENT 'vjudge判题在其它oj的提交id', -- vjudge判题在其他OJ的提交ID，无符号长整型，可以为空。
  `vjudge_username` varchar(255) NULL  COMMENT 'vjudge判题在其它oj的提交用户名', -- vjudge判题在其他OJ的提交用户名，字符串，最大长度255，可以为空。
  `vjudge_password` varchar(255) NULL  COMMENT 'vjudge判题在其它oj的提交账号密码', -- vjudge判题在其他OJ的提交账号密码，字符串，最大长度255，可以为空。
  `is_manual` tinyint(1) DEFAULT '0' COMMENT '是否为人工评测', -- 是否为人工评测，布尔类型，默认为0。
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP, -- 创建时间，默认为当前时间戳。
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 最后修改时间，默认为当前时间戳，当记录被更新时自动更新该字段的值。

  PRIMARY KEY (`submit_id`,`pid`,`display_pid`,`uid`,`cid`), -- 主键由submit_id、pid、display_pid、uid和cid组成。
  KEY `pid` (`pid`), -- pid索引。
  KEY `uid` (`uid`), -- uid索引。
  KEY `username` (`username`), -- username索引。
  CONSTRAINT `judge_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `problem` (`id`) ON DELETE CASCADE ON UPDATE CASCADE, -- pid外键约束，关联problem表的id字段，执行级联删除和更新操作。
  CONSTRAINT `judge_ibfk_2` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE, -- uid外键约束，关联user_info表的uuid字段，执行级联删除和更新操作。
  CONSTRAINT `judge_ibfk_3` FOREIGN KEY (`username`) REFERENCES `user_info` (`username`) ON DELETE CASCADE ON UPDATE CASCADE, -- username外键约束，关联user_info表的username字段，执行级联删除和更新操作。
  CONSTRAINT `judge_ibfk_4` FOREIGN KEY (`gid`) REFERENCES `group` (`id`) ON DELETE CASCADE ON UPDATE CASCADE -- gid外键约束，关联group表的id字段，执行级联删除和更新操作。
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8; -- 使用InnoDB存储引擎，初始自增值为1，字符集为utf8。


/*Table structure for table `judge_case` */

DROP TABLE IF EXISTS `judge_case`;

CREATE TABLE `judge_case` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `submit_id` bigint(20) unsigned NOT NULL COMMENT '提交判题id',
  `uid` varchar(32) NOT NULL COMMENT '用户id',
  `pid` bigint(20) unsigned NOT NULL COMMENT '题目id',
  `case_id` bigint(20) DEFAULT NULL COMMENT '测试样例id',
  `status` int(11) DEFAULT NULL COMMENT '具体看结果码',
  `time` int(11) DEFAULT NULL COMMENT '测试该样例所用时间ms',
  `memory` int(11) DEFAULT NULL COMMENT '测试该样例所用空间KB',
  `score` int(11) DEFAULT NULL COMMENT 'IO得分',
  `group_num` int(11) DEFAULT NULL COMMENT 'subtask分组的组号',
  `seq` int(11) DEFAULT NULL COMMENT '排序',
  `mode` varchar(255) DEFAULT 'default' COMMENT 'default,subtask_lowest,subtask_average',
  `input_data` longtext COMMENT '样例输入，比赛不可看',
  `output_data` longtext COMMENT '样例输出，比赛不可看',
  `user_output` longtext COMMENT '用户样例输出，比赛不可看',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`submit_id`,`uid`,`pid`),
  KEY `case_id` (`case_id`),
  KEY `judge_case_ibfk_1` (`uid`),
  KEY `judge_case_ibfk_2` (`pid`),
  KEY `judge_case_ibfk_3` (`submit_id`),
  CONSTRAINT `judge_case_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `judge_case_ibfk_2` FOREIGN KEY (`pid`) REFERENCES `problem` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `judge_case_ibfk_3` FOREIGN KEY (`submit_id`) REFERENCES `judge` (`submit_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

/*Table structure for table `judge_server` */

DROP TABLE IF EXISTS `judge_server`;

CREATE TABLE `judge_server` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL COMMENT '判题服务名字',
  `ip` varchar(255) NOT NULL COMMENT '判题机ip',
  `port` int(11) NOT NULL COMMENT '判题机端口号',
  `url` varchar(255) DEFAULT NULL COMMENT 'ip:port',
  `cpu_core` int(11) DEFAULT '0' COMMENT '判题机所在服务器cpu核心数',
  `task_number` int(11) NOT NULL DEFAULT '0' COMMENT '当前判题数',
  `max_task_number` int(11) NOT NULL COMMENT '判题并发最大数',
  `status` int(11) DEFAULT '0' COMMENT '0可用，1不可用',
  `is_remote` tinyint(1) DEFAULT NULL COMMENT '是否开启远程判题vj',
  `cf_submittable` tinyint(1) DEFAULT 1 NULL COMMENT '是否可提交CF',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `index_judge_remote` (`is_remote`),
  KEY `index_judge_url` (`url`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

/*Table structure for table `language` */

DROP TABLE IF EXISTS `language`;

CREATE TABLE `language` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `content_type` varchar(255) DEFAULT NULL COMMENT '语言类型',
  `description` varchar(255) DEFAULT NULL COMMENT '语言描述',
  `name` varchar(255) DEFAULT NULL COMMENT '语言名字',
  `compile_command` mediumtext COMMENT '编译指令',
  `template` longtext COMMENT '模板',
  `code_template` longtext COMMENT '语言默认代码模板',
  `is_spj` tinyint(1) DEFAULT '0' COMMENT '是否可作为特殊判题的一种语言',
  `oj` varchar(255) DEFAULT NULL COMMENT '该语言属于哪个oj，自身oj用ME',
  `seq` int(11) DEFAULT '0' COMMENT '语言排序',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

/*Table structure for table `problem` */

DROP TABLE IF EXISTS `problem`;

CREATE TABLE `problem` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `problem_id` varchar(255) NOT NULL COMMENT '问题的自定义ID 例如（bjutoj-1000）',
  `title` varchar(255) NOT NULL COMMENT '题目',
  `author` varchar(255) DEFAULT '未知' COMMENT '作者',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '0为ACM,1为OI',
  `time_limit` int(11) DEFAULT '1000' COMMENT '单位ms',
  `memory_limit` int(11) DEFAULT '65535' COMMENT '单位kb',
  `stack_limit` int(11) DEFAULT '128' COMMENT '单位mb',
  `description` longtext COMMENT '描述',
  `input` longtext COMMENT '输入描述',
  `output` longtext COMMENT '输出描述',
  `examples` longtext COMMENT '题面样例',
  `is_remote` tinyint(1) DEFAULT '0' COMMENT '是否为vj判题',
  `source` text COMMENT '题目来源',
  `difficulty` int(11) DEFAULT '0' COMMENT '题目难度,0简单，1中等，2困难',
  `hint` longtext COMMENT '备注,提醒',
  `auth` int(11) DEFAULT '1' COMMENT '默认为1公开，2为私有，3为比赛题目',
  `io_score` int(11) DEFAULT '100' COMMENT '当该题目为io题目时的分数',
  `code_share` tinyint(1) DEFAULT '1' COMMENT '该题目对应的相关提交代码，用户是否可用分享',
  `judge_mode` varchar(255) DEFAULT 'default' COMMENT '题目评测模式,default、spj、interactive',
  `judge_case_mode` varchar(255) DEFAULT 'default' COMMENT '题目样例评测模式,default,subtask_lowest,subtask_average',
  `user_extra_file` mediumtext DEFAULT NULL COMMENT '题目评测时用户程序的额外文件 json key:name value:content',
  `judge_extra_file` mediumtext DEFAULT NULL COMMENT '题目评测时交互或特殊程序的额外文件 json key:name value:content',
  `spj_code` longtext COMMENT '特判程序或交互程序代码',
  `spj_language` varchar(255) DEFAULT NULL COMMENT '特判程序或交互程序代码的语言',
  `is_remove_end_blank` tinyint(1) DEFAULT '1' COMMENT '是否默认去除用户代码的文末空格',
  `open_case_result` tinyint(1) DEFAULT '1' COMMENT '是否默认开启该题目的测试样例结果查看',
  `is_upload_case` tinyint(1) DEFAULT '1' COMMENT '题目测试数据是否是上传文件的',
  `case_version` varchar(40) DEFAULT '0' COMMENT '题目测试数据的版本号',
  `modified_user` varchar(255) DEFAULT NULL COMMENT '修改题目的管理员用户名',
  `is_group` tinyint(1) DEFAULT '0',
  `gid` bigint(20) unsigned DEFAULT NULL,
  `apply_public_progress` int(11) DEFAULT NULL COMMENT '申请公开的进度：null为未申请，1为申请中，2为申请通过，3为申请拒绝',
  `is_file_io` tinyint(1) DEFAULT '0' COMMENT '是否是file io自定义输入输出文件模式',
  `io_read_file_name` varchar(255) DEFAULT NULL COMMENT '题目指定的file io输入文件的名称',
  `io_write_file_name` varchar(255) DEFAULT NULL COMMENT '题目指定的file io输出文件的名称',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `author` (`author`),
  KEY `problem_id` (`problem_id`),
  CONSTRAINT `problem_ibfk_1` FOREIGN KEY (`author`) REFERENCES `user_info` (`username`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `problem_ibfk_2` FOREIGN KEY (`gid`) REFERENCES `group` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8;

/*Table structure for table `problem_case` */

DROP TABLE IF EXISTS `problem_case`;

CREATE TABLE `problem_case` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `pid` bigint(20) unsigned NOT NULL COMMENT '题目id',
  `input` longtext COMMENT '测试样例的输入',
  `output` longtext COMMENT '测试样例的输出',
  `score` int(11) DEFAULT NULL COMMENT '该测试样例的IO得分',
  `status` int(11) DEFAULT '0' COMMENT '0可用，1不可用',
  `group_num` int(11) DEFAULT '1' COMMENT 'subtask分组的编号',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`),
  CONSTRAINT `problem_case_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `problem` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


/*Table structure for table `problem_language` */

DROP TABLE IF EXISTS `problem_language`;

CREATE TABLE `problem_language` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `pid` bigint(20) unsigned NOT NULL,
  `lid` bigint(20) unsigned NOT NULL,
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`),
  KEY `lid` (`lid`),
  CONSTRAINT `problem_language_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `problem` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `problem_language_ibfk_2` FOREIGN KEY (`lid`) REFERENCES `language` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

/*Table structure for table `problem_tag` */

DROP TABLE IF EXISTS `problem_tag`;

CREATE TABLE `problem_tag` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `pid` bigint(20) unsigned NOT NULL,
  `tid` bigint(20) unsigned NOT NULL,
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`),
  KEY `tid` (`tid`),
  CONSTRAINT `problem_tag_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `problem` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `problem_tag_ibfk_2` FOREIGN KEY (`tid`) REFERENCES `tag` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

/*Table structure for table `reply` */

DROP TABLE IF EXISTS `reply`;

CREATE TABLE `reply` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `comment_id` int(11) NOT NULL COMMENT '被回复的评论id',
  `from_uid` varchar(255) NOT NULL COMMENT '发起回复的用户id',
  `from_name` varchar(255) NOT NULL COMMENT '发起回复的用户名',
  `from_avatar` varchar(255) DEFAULT NULL COMMENT '发起回复的用户头像地址',
  `from_role` varchar(255) DEFAULT NULL COMMENT '发起回复的用户角色',
  `to_uid` varchar(255) NOT NULL COMMENT '被回复的用户id',
  `to_name` varchar(255) NOT NULL COMMENT '被回复的用户名',
  `to_avatar` varchar(255) DEFAULT NULL COMMENT '被回复的用户头像地址',
  `content` longtext COMMENT '回复的内容',
  `status` int(11) DEFAULT '0' COMMENT '是否封禁或逻辑删除该回复',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `comment_id` (`comment_id`),
  KEY `from_avatar` (`from_avatar`),
  KEY `to_avatar` (`to_avatar`),
  CONSTRAINT `reply_ibfk_1` FOREIGN KEY (`comment_id`) REFERENCES `comment` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `reply_ibfk_2` FOREIGN KEY (`from_avatar`) REFERENCES `user_info` (`avatar`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `reply_ibfk_3` FOREIGN KEY (`to_avatar`) REFERENCES `user_info` (`avatar`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

/*Table structure for table `role` */

DROP TABLE IF EXISTS `role`;

CREATE TABLE `role` (
  `id` bigint(20) unsigned zerofill NOT NULL,
  `role` varchar(50) NOT NULL COMMENT '角色',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '默认0可用，1不可用',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `role_auth` */

DROP TABLE IF EXISTS `role_auth`;

CREATE TABLE `role_auth` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `auth_id` bigint(20) unsigned NOT NULL,
  `role_id` bigint(20) unsigned NOT NULL,
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `auth_id` (`auth_id`) USING BTREE,
  KEY `role_id` (`role_id`) USING BTREE,
  CONSTRAINT `role_auth_ibfk_1` FOREIGN KEY (`auth_id`) REFERENCES `auth` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `role_auth_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

/*Table structure for table `session` */

DROP TABLE IF EXISTS `session`;

CREATE TABLE `session` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uid` varchar(255) NOT NULL,
  `user_agent` varchar(512) DEFAULT NULL,
  `ip` varchar(255) DEFAULT NULL,
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`),
  CONSTRAINT `session_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `tag_classification`;
CREATE TABLE `tag_classification`  (
	`id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
	`name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签分类名称',
	`oj` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签分类所属oj',
	`gmt_create` datetime NULL DEFAULT NULL,
	`gmt_modified` datetime NULL DEFAULT NULL,
	`rank` int(10) UNSIGNED ZEROFILL NULL DEFAULT NULL COMMENT '标签分类优先级 越小越高',
	 PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

/*Table structure for table `tag` */

DROP TABLE IF EXISTS `tag`;

CREATE TABLE `tag` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT '标签名字',
  `color` varchar(10) DEFAULT NULL COMMENT '标签颜色',
  `oj` varchar(255) DEFAULT 'ME' COMMENT '标签所属oj',
  `gid` bigint(20) unsigned DEFAULT NULL,
  `tcid` bigint(20) unsigned DEFAULT NULL,
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`,`oj`, `gid`),
  CONSTRAINT `tag_ibfk_1` FOREIGN KEY (`gid`) REFERENCES `group` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tag_ibfk_2` FOREIGN KEY (`tcid`) REFERENCES `tag_classification` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


/*Table structure for table `user_acproblem` */

DROP TABLE IF EXISTS `user_acproblem`;

CREATE TABLE `user_acproblem` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` varchar(32) NOT NULL COMMENT '用户id',
  `pid` bigint(20) unsigned NOT NULL COMMENT 'ac的题目id',
  `submit_id` bigint(20) unsigned NOT NULL COMMENT '提交id',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `submit_id` (`submit_id`),
  KEY `uid` (`uid`),
  KEY `pid` (`pid`),
  CONSTRAINT `user_acproblem_ibfk_2` FOREIGN KEY (`pid`) REFERENCES `problem` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_acproblem_ibfk_3` FOREIGN KEY (`submit_id`) REFERENCES `judge` (`submit_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

/*Table structure for table `user_info` */

DROP TABLE IF EXISTS `user_info`;

CREATE TABLE `user_info` (
  `uuid` varchar(32) NOT NULL,
  `username` varchar(100) NOT NULL COMMENT '用户名',
  `password` varchar(100) NOT NULL COMMENT '密码',
  `nickname` varchar(100) DEFAULT NULL COMMENT '昵称',
  `school` varchar(100) DEFAULT NULL COMMENT '学校',
  `course` varchar(100) DEFAULT NULL COMMENT '专业',
  `number` varchar(20) DEFAULT NULL COMMENT '学号',
  `realname` varchar(100) DEFAULT NULL COMMENT '真实姓名',
  `gender` varchar(20) DEFAULT 'secrecy' NOT NULL  COMMENT '性别',
  `github` varchar(255) DEFAULT NULL COMMENT 'github地址',
  `blog` varchar(255) DEFAULT NULL COMMENT '博客地址',
  `cf_username` varchar(255) DEFAULT NULL COMMENT 'cf的username',
  `email` varchar(320) DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像地址',
  `signature` mediumtext COMMENT '个性签名',
  `title_name` varchar(255) DEFAULT NULL COMMENT '头衔、称号',
  `title_color` varchar(255) DEFAULT NULL COMMENT '头衔、称号的颜色',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '0可用，1不可用',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`uuid`),
  UNIQUE KEY `USERNAME_UNIQUE` (`username`),
  UNIQUE KEY `EMAIL_UNIQUE` (`email`),
  UNIQUE KEY `avatar` (`avatar`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `user_record` */

DROP TABLE IF EXISTS `user_record`;

CREATE TABLE `user_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` varchar(32) NOT NULL COMMENT '用户id',
  `rating` int(11) DEFAULT NULL COMMENT 'cf得分',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`uid`),
  KEY `uid` (`uid`),
  CONSTRAINT `user_record_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

/*Table structure for table `user_role` */

DROP TABLE IF EXISTS `user_role`;

CREATE TABLE `user_role` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uid` varchar(32) NOT NULL,
  `role_id` bigint(20) unsigned NOT NULL,
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`) USING BTREE,
  KEY `role_id` (`role_id`) USING BTREE,
  CONSTRAINT `user_role_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_role_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

/*Table structure for table `remote_judge_account` */

DROP TABLE IF EXISTS `remote_judge_account`;

CREATE TABLE `remote_judge_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `oj` varchar(50) NOT NULL COMMENT '远程oj名字',
  `username` varchar(255) NOT NULL COMMENT '账号',
  `password` varchar(255) NOT NULL COMMENT '密码',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否可用',
  `version` bigint(20) DEFAULT '0' COMMENT '版本控制',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `admin_sys_notice`;

CREATE TABLE `admin_sys_notice` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL COMMENT '标题',
  `content` longtext COMMENT '内容',
  `type` varchar(255) DEFAULT NULL COMMENT '发给哪些用户类型',
  `state` tinyint(1) DEFAULT '0' COMMENT '是否已拉取给用户',
  `recipient_id` varchar(32) DEFAULT NULL COMMENT '接受通知的用户id',
  `admin_id` varchar(32) DEFAULT NULL COMMENT '发送通知的管理员id',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `recipient_id` (`recipient_id`),
  KEY `admin_id` (`admin_id`),
  CONSTRAINT `admin_sys_notice_ibfk_1` FOREIGN KEY (`recipient_id`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `admin_sys_notice_ibfk_2` FOREIGN KEY (`admin_id`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `msg_remind` */

DROP TABLE IF EXISTS `msg_remind`;

CREATE TABLE `msg_remind` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `action` varchar(255) NOT NULL COMMENT '动作类型，如点赞讨论帖Like_Post、点赞评论Like_Discuss、评论Discuss、回复Reply等',
  `source_id` int(10) unsigned DEFAULT NULL COMMENT '消息来源id，讨论id或比赛id',
  `source_type` varchar(255) DEFAULT NULL COMMENT '事件源类型：''Discussion''、''Contest''等',
  `source_content` varchar(255) DEFAULT NULL COMMENT '事件源的内容，比如回复的内容，评论的帖子标题等等',
  `quote_id` int(10) unsigned DEFAULT NULL COMMENT '事件引用上一级评论或回复id',
  `quote_type` varchar(255) DEFAULT NULL COMMENT '事件引用上一级的类型：Comment、Reply',
  `url` varchar(255) DEFAULT NULL COMMENT '事件所发生的地点链接 url',
  `state` tinyint(1) DEFAULT '0' COMMENT '是否已读',
  `sender_id` varchar(32) DEFAULT NULL COMMENT '操作者的id',
  `recipient_id` varchar(32) DEFAULT NULL COMMENT '接受消息的用户id',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `sender_id` (`sender_id`),
  KEY `recipient_id` (`recipient_id`),
  CONSTRAINT `msg_remind_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `msg_remind_ibfk_2` FOREIGN KEY (`recipient_id`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `user_sys_notice` */

DROP TABLE IF EXISTS `user_sys_notice`;

CREATE TABLE `user_sys_notice` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `sys_notice_id` bigint(20) unsigned DEFAULT NULL COMMENT '系统通知的id',
  `recipient_id` varchar(32) DEFAULT NULL COMMENT '接受通知的用户id',
  `type` varchar(255) DEFAULT NULL COMMENT '消息类型，系统通知sys、我的信息mine',
  `state` tinyint(1) DEFAULT '0' COMMENT '是否已读',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '读取时间',
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `sys_notice_id` (`sys_notice_id`),
  KEY `recipient_id` (`recipient_id`),
  CONSTRAINT `user_sys_notice_ibfk_1` FOREIGN KEY (`sys_notice_id`) REFERENCES `admin_sys_notice` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_sys_notice_ibfk_2` FOREIGN KEY (`recipient_id`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


/*Table structure for table `training` */

DROP TABLE IF EXISTS `training`;

CREATE TABLE `training` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL COMMENT '训练题单名称',
  `description` longtext COMMENT '训练题单简介',
  `author` varchar(255) NOT NULL COMMENT '训练题单创建者用户名',
  `auth` varchar(255) NOT NULL COMMENT '训练题单权限类型：Public、Private',
  `private_pwd` varchar(255) DEFAULT NULL COMMENT '训练题单权限为Private时的密码',
  `rank` int DEFAULT '0' COMMENT '编号，升序',
  `status` tinyint(1) DEFAULT '1' COMMENT '是否可用',
  `is_group` tinyint(1) DEFAULT '0',
  `gid` bigint(20) unsigned DEFAULT NULL,
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `training_ibfk_1` FOREIGN KEY (`gid`) REFERENCES `group` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `training_category` */

DROP TABLE IF EXISTS `training_category`;

CREATE TABLE `training_category` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `color` varchar(255) DEFAULT NULL,
  `gid` bigint(20) unsigned DEFAULT NULL,
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `training_category_ibfk_1` FOREIGN KEY (`gid`) REFERENCES `group` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `training_problem` */

DROP TABLE IF EXISTS `training_problem`;

CREATE TABLE `training_problem` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tid` bigint unsigned NOT NULL COMMENT '训练id',
  `pid` bigint unsigned NOT NULL COMMENT '题目id',
  `rank` int DEFAULT '0',
  `display_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `tid` (`tid`),
  KEY `pid` (`pid`),
  KEY `display_id` (`display_id`),
  CONSTRAINT `training_problem_ibfk_1` FOREIGN KEY (`tid`) REFERENCES `training` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `training_problem_ibfk_2` FOREIGN KEY (`pid`) REFERENCES `problem` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `training_problem_ibfk_3` FOREIGN KEY (`display_id`) REFERENCES `problem` (`problem_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `training_record` */

DROP TABLE IF EXISTS `training_record`;

CREATE TABLE `training_record` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tid` bigint unsigned NOT NULL,
  `tpid` bigint unsigned NOT NULL,
  `pid` bigint unsigned NOT NULL,
  `uid` varchar(255) NOT NULL,
  `submit_id` bigint unsigned NOT NULL,
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `tid` (`tid`),
  KEY `tpid` (`tpid`),
  KEY `pid` (`pid`),
  KEY `uid` (`uid`),
  KEY `submit_id` (`submit_id`),
  CONSTRAINT `training_record_ibfk_1` FOREIGN KEY (`tid`) REFERENCES `training` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `training_record_ibfk_2` FOREIGN KEY (`tpid`) REFERENCES `training_problem` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `training_record_ibfk_3` FOREIGN KEY (`pid`) REFERENCES `problem` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `training_record_ibfk_4` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `training_record_ibfk_5` FOREIGN KEY (`submit_id`) REFERENCES `judge` (`submit_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `training_register` */

DROP TABLE IF EXISTS `training_register`;

CREATE TABLE `training_register` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tid` bigint unsigned NOT NULL COMMENT '训练id',
  `uid` varchar(255) NOT NULL COMMENT '用户id',
  `status` tinyint(1) DEFAULT '1' COMMENT '是否可用',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `tid` (`tid`),
  KEY `uid` (`uid`),
  CONSTRAINT `training_register_ibfk_1` FOREIGN KEY (`tid`) REFERENCES `training` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `training_register_ibfk_2` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `mapping_training_category`;

CREATE TABLE `mapping_training_category` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tid` bigint unsigned NOT NULL,
  `cid` bigint unsigned NOT NULL,
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `tid` (`tid`),
  KEY `cid` (`cid`),
  CONSTRAINT `mapping_training_category_ibfk_1` FOREIGN KEY (`tid`) REFERENCES `training` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `mapping_training_category_ibfk_2` FOREIGN KEY (`cid`) REFERENCES `training_category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `group` */

DROP TABLE IF EXISTS `group`;

CREATE TABLE `group` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像地址',
  `name` varchar(25) DEFAULT NULL COMMENT '团队名称',
  `short_name` varchar(10) DEFAULT NULL COMMENT '团队简称，创建题目时题号自动添加的前缀',
  `brief` varchar(50) COMMENT '团队简介',
  `description` longtext COMMENT '团队介绍',
  `owner` varchar(255) NOT NULL COMMENT '团队拥有者用户名',
  `uid` varchar(32) NOT NULL COMMENT '团队拥有者用户id',
  `auth` int(11) NOT NULL COMMENT '0为Public，1为Protected，2为Private',
  `visible` tinyint(1) DEFAULT '1' COMMENT '是否可见',
  `status` tinyint(1) DEFAULT '0' COMMENT '是否封禁',
  `code` varchar(6) DEFAULT NULL COMMENT '邀请码',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `NAME_UNIQUE` (`name`),
  UNIQUE KEY `short_name` (`short_name`),
  CONSTRAINT `group_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8;

/*Table structure for table `group_member` */

DROP TABLE IF EXISTS `group_member`;

CREATE TABLE `group_member` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `gid` bigint unsigned NOT NULL COMMENT '团队id',
  `uid` varchar(32) NOT NULL COMMENT '用户id',
  `auth` int(11) DEFAULT '1' COMMENT '1未审批，2拒绝，3普通成员，4团队管理员，5团队拥有者',
  `reason` varchar(100) DEFAULT NULL COMMENT '申请理由',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `gid_uid_unique` (`gid`, `uid`),
  KEY `gid` (`gid`),
  KEY `uid` (`uid`),
  CONSTRAINT `group_member_ibfk_1` FOREIGN KEY (`gid`) REFERENCES `group` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `group_member_ibfk_2` FOREIGN KEY (`uid`) REFERENCES `user_info` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


/* Trigger structure for table `contest` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `contest_trigger` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `contest_trigger` BEFORE INSERT ON `contest` FOR EACH ROW BEGIN
set new.status=(
	CASE 
	  WHEN NOW() < new.start_time THEN -1 
	  WHEN NOW() >= new.start_time AND NOW()<new.end_time THEN  0
	  WHEN NOW() >= new.end_time THEN 1
	END);
END */$$


DELIMITER ;

/*!50106 set global event_scheduler = 1*/;

/* Event structure for event `contest_event` */

/*!50106 DROP EVENT IF EXISTS `contest_event`*/;

DELIMITER $$

/*!50106 CREATE DEFINER=`root`@`localhost` EVENT `contest_event` ON SCHEDULE EVERY 1 SECOND STARTS '2021-04-18 19:04:49' ON COMPLETION PRESERVE ENABLE DO CALL contest_status() */$$
DELIMITER ;

/* Procedure structure for procedure `contest_status` */

/*!50003 DROP PROCEDURE IF EXISTS  `contest_status` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `contest_status`()
BEGIN
      UPDATE contest 
	SET STATUS = (
	CASE 
	  WHEN NOW() < start_time THEN -1 
	  WHEN NOW() >= start_time AND NOW()<end_time THEN  0
	  WHEN NOW() >= end_time THEN 1
	END);
    END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;



/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


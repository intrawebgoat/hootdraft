-- PHPDraft Database Initialization Script
-- This script requires an empty database to be initialized, and then replace the name below with your database's name.
-- NOTE: Change this to whatever your database is. Make note if your host requires a prefixed name, like ACCOUNT_phpdraft (common on shared hosting)
USE phpdraft;

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `phpdraft`
--

-- --------------------------------------------------------

--
-- Table structure for table `draft`
--

CREATE TABLE IF NOT EXISTS `draft` (
  `draft_id` int(11) NOT NULL auto_increment,
  `commish_id` INT(11) NOT NULL,
  `draft_create_time` datetime NOT NULL,
  `draft_name` text NOT NULL,
  `draft_sport` text NOT NULL,
  `draft_status` text NOT NULL,
  `draft_counter` int(11) NOT NULL default '0',
  `draft_style` text NOT NULL,
  `draft_rounds` int(2) unsigned NOT NULL default '0',
  `draft_password` text,
  `draft_start_time` datetime default NULL,
  `draft_end_time` datetime default NULL ,
  `draft_current_round` int(5) unsigned NOT NULL default '1',
  `draft_current_pick` int(5) unsigned NOT NULL default '1',
  `nfl_extended` BIT(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY  (`draft_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `managers`
--

CREATE TABLE IF NOT EXISTS `managers` (
  `manager_id` int(11) NOT NULL auto_increment,
  `draft_id` int(11) NOT NULL default '0',
  `manager_name` text NOT NULL,
  `draft_order` tinyint(3) unsigned NOT NULL default '0',
  PRIMARY KEY  (`manager_id`),
  KEY `draft_idx` (`draft_id`),
  FULLTEXT KEY `manager_idx` (`manager_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

CREATE TABLE IF NOT EXISTS `players` (
  `player_id` int(11) NOT NULL auto_increment,
  `manager_id` int(11) NOT NULL default '0',
  `first_name` text,
  `last_name` text,
  `team` char(3) default NULL,
  `position` varchar(4) default NULL,
  `pick_time` datetime default NULL,
  `pick_duration` int(10) default NULL,
  `player_counter` int(11) default NULL,
  `draft_id` int(11) unsigned NOT NULL default '0',
  `player_round` int(11) NOT NULL default '0',
  `player_pick` int(11) NOT NULL default '0',
  PRIMARY KEY  (`player_id`),
  KEY `manager_idx` (`manager_id`),
  KEY `draft_idx` (`draft_id`),
  FULLTEXT KEY `player_idx` (`first_name`,`last_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--
CREATE TABLE `users`
(
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `enabled` BIT(1) NOT NULL DEFAULT b'0',
    `email` VARCHAR(255) NOT NULL,
    `password` VARCHAR(255) NOT NULL,
    `salt` VARCHAR(16) NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `roles` VARCHAR(255) NOT NULL,
    `verificationKey` VARCHAR(16) NULL,
    `creationTime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    PRIMARY KEY (`id`),
    UNIQUE INDEX `id` (`id`),
    UNIQUE INDEX `UNIQUE_USER` (`email`, `name`)
) ENGINE=MyISAM;
ALTER TABLE `users` ADD UNIQUE `UNIQUE_USER` (`email`, `name`);

-- --------------------------------------------------------

--
-- Table structure for table `trades`
--
CREATE TABLE IF NOT EXISTS `trades` (
  `trade_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `draft_id` int(11) unsigned NOT NULL,
  `manager1_id` int(11) unsigned NOT NULL,
  `manager2_id` int(11) unsigned NOT NULL,
  `trade_time` datetime DEFAULT NULL,
  PRIMARY KEY (`trade_id`),
  KEY `manager1_idx` (`manager1_id`),
  KEY `manager2_idx` (`manager2_id`),
  KEY `draft_idx` (`draft_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `trade_assets`
--
CREATE TABLE IF NOT EXISTS `trade_assets` (
`tradeasset_id` INT( 11 ) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
`trade_id` INT( 11 ) UNSIGNED NOT NULL,
`player_id` INT( 11 ) UNSIGNED NOT NULL,
`oldmanager_id` INT( 11 ) UNSIGNED NOT NULL,
`newmanager_id` INT( 11 ) UNSIGNED NOT NULL,
`was_drafted` TINYINT( 1 ) NOT NULL,
INDEX ( `trade_id` , `player_id` , `oldmanager_id` , `newmanager_id` )
) ENGINE = MYISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- --------------------------------------------------------

--
-- Table structure for table `pro_players`
--
CREATE TABLE IF NOT EXISTS `pro_players` (
  `pro_player_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `league` text NOT NULL,
  `first_name` text NOT NULL,
  `last_name` text NOT NULL,
  `position` text NOT NULL,
  `team` text NOT NULL,
  PRIMARY KEY (`pro_player_id`),
  KEY `league_idx` (`league`(4)),
  FULLTEXT KEY `firstname_idx` (`first_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Table structure for storing round times
--
CREATE TABLE IF NOT EXISTS `round_times` (
  `round_time_id` int(11) NOT NULL auto_increment,
  `draft_id` int(11) NOT NULL,
  `is_static_time` tinyint(1),
  `draft_round` int(2),
  `round_time_seconds` int(11),
  PRIMARY KEY  (`round_time_id`),
  KEY `draft_idx` (`draft_id`),
  KEY `round_idx` (`draft_round`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
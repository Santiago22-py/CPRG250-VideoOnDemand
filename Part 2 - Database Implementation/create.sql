-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
--PARENT TABLES
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------
--CREATE STATEMENT FOR CATEGORY 
--Description: This tables hold the possible movie categories (Drama, Action etc)
--Each Category also may or may not have subcategories
-------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS category (
	category_id         bigserial PRIMARY KEY,
	category_name       varchar(80) NOT NULL,
	parent_category_id  bigint,
	CONSTRAINT category_id_fk --Constraint for foreign key
  		FOREIGN KEY (parent_category_id) REFERENCES category(category_id) ON DELETE CASCADE
);

-------------------------------------------------------------------------------------------
--CREATE STATEMENT FOR STARS
--Description: This table holds the information of both directors and actors
--Emails should be unique and are checked for format validation
-------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS stars (
	star_id bigserial PRIMARY KEY,
	star_first_name VARCHAR(80) NOT NULL,
	star_last_name  VARCHAR(80) NOT NULL,
	star_dob        DATE NOT NULL,
	star_email      VARCHAR(50) NOT NULL,
	CONSTRAINT stars_email_uk -- Constraint for unique email
		UNIQUE (star_email),
	CONSTRAINT stars_valid_email_ck -- Constraint for email format(case insensitive)
		CHECK (star_email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$')
);

-------------------------------------------------------------------------------------------
--CREATE STATEMENT FOR ADVISORY
--Description: This table holds the possible advisory classifications for a movie
-------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS advisory (
	advisory_id bigserial PRIMARY KEY,
	short_desc  varchar(80) NOT NULL,
	full_desc   text NOT NULL
);

-------------------------------------------------------------------------------------------
--CREATE STATEMENT FOR CUSTOMERS
--Description: This table holds the information from customers
-------------------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS customers (
	customer_id          bigserial PRIMARY KEY,
	customer_first_name  varchar(80) NOT NULL, 
	customer_last_name   varchar(80) NOT NULL, 
	customer_email       varchar(50) NOT NULL,
	street               varchar(50) NOT NULL,
	city                 varchar(30) NOT NULL,
	province             varchar(30) NOT NULL,
	postal_code          varchar(10) NOT NULL,
	phone                varchar(15) NOT NULL,
	default_card_number  varchar(20) NOT NULL,
	default_card_type    varchar(5)  NOT NULL,
	--Constraints
	CONSTRAINT customers_valid_email_ck -- Constraint for email format(case insensitive)
		CHECK (customer_email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'),
	CONSTRAINT customers_valid_postal_ck 
		CHECK (postal_code ~* '^[A-Za-z][0-9][A-Za-z][0-9][A-Za-z][0-9]$'),
	CONSTRAINT customers_valid_cardnum_ck
		CHECK (default_card_number ~* '^\d+$'),
	CONSTRAINT customers_valid_phone_ck
		CHECK (phone ~ '\d{3}\.\d{3}\.\d{4}$'),
	CONSTRAINT customers_card_type_ck
		CHECK (default_card_type IN ('AX', 'MC', 'VS')),
	CONSTRAINT customers_email_uk -- Constraint for unique email
		UNIQUE (customer_email)
 );

 -------------------------------------------------------------------------------------------
--CREATE STATEMENT FOR MOVIES
--Description: This table holds the information from movies
-------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS movies (
	movie_id bigserial PRIMARY KEY,
	title           text    NOT NULL,
	duration_min    integer NOT NULL,
	rating_code     text    NOT NULL,
	sd_price        numeric(8,2) NOT NULL,
	hd_price        numeric(8,2) NOT NULL,
	is_new_release  boolean NOT NULL DEFAULT false,
	is_most_popular boolean NOT NULL DEFAULT false,
	is_coming_soon  boolean NOT NULL DEFAULT false,
	--Constraints
	CONSTRAINT movies_valid_duration_ck
		CHECK (duration_min > 0)
		
);


-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
--CHILD AND BRIDGING TABLES
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------
--CREATE STATEMENT FOR MOVIESCATEGORY
--Description: This table bridges Movies and Category
-------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS moviescategory (
	movie_id    bigint NOT NULL,
	category_id bigint NOT NULL,
	PRIMARY KEY(movie_id, category_id),
	--CONSTRAINTS
	CONSTRAINT moviescategory_movie_id_fk
		FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE,
	CONSTRAINT movies_category_category_id_fk
		FOREIGN KEY (category_id) REFERENCES category(category_id) ON DELETE CASCADE
);

-------------------------------------------------------------------------------------------
--CREATE STATEMENT FOR MOVIESADVISORY
--Description: This table bridges Movies and Advisory
-------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS moviesadvisory (
	movie_id    bigint NOT NULL,
	advisory_id bigint NOT NULL,
	PRIMARY KEY(movie_id, advisory_id),
	--CONSTRAINTS
	CONSTRAINT moviesadvisory_movie_id_fk
		FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE,
	CONSTRAINT moviesadvisory_advisory_id_fk
		FOREIGN KEY (advisory_id) REFERENCES advisory(advisory_id) ON DELETE CASCADE
);


-------------------------------------------------------------------------------------------
--CREATE STATEMENT FOR MOVIESSTARS
--Description: This table bridges Movies and Stars
-------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS moviesstars (
	movie_id       bigint NOT NULL,
	star_id        bigint NOT NULL,
	star_role_type varchar(20),
	star_role_name varchar (50) DEFAULT 'Director',
	PRIMARY KEY(movie_id, star_id, star_role_type),
	--CONSTRAINTS
	CONSTRAINT moviesstars_movie_id_fk
		FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE,
	CONSTRAINT moviesstars_star_id_fk
		FOREIGN KEY (star_id) REFERENCES stars(star_id) ON DELETE CASCADE,
	CONSTRAINT moviesstars_star_type_ck
		CHECK (star_role_type IN ('Actor', 'Director'))
);

-------------------------------------------------------------------------------------------
--CREATE STATEMENT FOR RENTALS
--Description: 
-------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS rentals (
	rental_id          bigserial PRIMARY KEY,
	customer_id        bigint,
	movie_id           bigint,
	date_rented        DATE NOT NULL,
	date_watched       DATE,
	date_expires       DATE,
	rental_amount      numeric(8,2),
	credit_card_number varchar(30),
	credit_card_type   varchar (5),
	customer_rating    int,
	--CONSTRAINTS
	CONSTRAINT rentals_valid_watchedtime_ck
		CHECK (date_watched > date_rented),
	CONSTRAINT rentals_valid_expirytime_ck
		CHECK (date_expires > date_watched),
	CONSTRAINT rentals_expiry_ck
		CHECK (date_expires = date_watched + INTERVAL '24 hours'),
	CONSTRAINT rentals_valid_rating_ck
		CHECK (customer_rating BETWEEN 1 AND 5),
	CONSTRAINT rentals_valid_cardnum_ck
		CHECK (credit_card_number ~* '^\d+$'),
	CONSTRAINT rentals_card_type_ck
		CHECK (credit_card_type IN ('AX', 'MC', 'VS')),
	CONSTRAINT rentals_movie_id_fk
		FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE,
	CONSTRAINT rentals_customer_id_fk
		FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

-------------------------------------------------------------------------------------------
--CREATE STATEMENT FOR WISHLIST
--Description: 
-------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS wishlist (
	movie_id        bigint,
	customer_id     bigint,
	date_added      DATE,
	PRIMARY KEY(movie_id, customer_id),
	--CONSTRAINTS
	CONSTRAINT wishlist_movie_id_fk
		FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE,
	CONSTRAINT wishlist_customer_id_fk
		FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);
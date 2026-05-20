--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.3

-- Started on 2026-01-04 18:40:31

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 25164)
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customer_id character varying(15) NOT NULL,
    company_name character varying(40) NOT NULL,
    contact_name character varying(30),
    contact_title character varying(30),
    address character varying(60),
    city character varying(15),
    region character varying(15),
    postal_code character varying(10),
    country character varying(15),
    phone character varying(24),
    fax character varying(24)
);


ALTER TABLE public.customers OWNER TO wms_beer_warehouse_user;

--
-- TOC entry 232 (class 1259 OID 25432)
-- Name: deliver_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deliver_details (
    id integer NOT NULL,
    deliver_id character varying,
    user_id character varying,
    product_name character varying,
    ean character varying,
    expected_amount integer,
    amount integer,
    date date,
    deliver_time time with time zone,
    status character varying DEFAULT 'undone'::character varying,
    target_location character varying,
    deliver_date date
);


ALTER TABLE public.deliver_details OWNER TO wms_beer_warehouse_user;

--
-- TOC entry 231 (class 1259 OID 25431)
-- Name: deliver_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.deliver_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.deliver_details_id_seq OWNER TO wms_beer_warehouse_user;

--
-- TOC entry 4922 (class 0 OID 0)
-- Dependencies: 231
-- Name: deliver_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.deliver_details_id_seq OWNED BY public.deliver_details.id;


--
-- TOC entry 230 (class 1259 OID 25413)
-- Name: delivery_order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.delivery_order (
    deliver_id character varying NOT NULL,
    supplier character varying,
    delivery_date date,
    status character varying DEFAULT 'undone'::character varying,
    deliver_external_number character varying,
    create_date date
);


ALTER TABLE public.delivery_order OWNER TO wms_beer_warehouse_user;

--
-- TOC entry 217 (class 1259 OID 25189)
-- Name: location_weights; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location_weights (
    location character varying(10) NOT NULL,
    weightlimitonlocation integer,
    actualweightonlocation numeric,
    limitofamountonlocation integer,
    actualamountonlocation integer
);


ALTER TABLE public.location_weights OWNER TO wms_beer_warehouse_user;

--
-- TOC entry 227 (class 1259 OID 25323)
-- Name: order_picking_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_picking_details (
    id integer NOT NULL,
    product_id integer,
    product_name character varying,
    expected_amount integer,
    picked_amount integer,
    picked_location character varying,
    picked_by character varying,
    scanned_ean character varying,
    picked_time time with time zone,
    status character varying,
    order_id character varying,
    picked_date date,
    expected_ean character varying,
    product_date date
);


ALTER TABLE public.order_picking_details OWNER TO wms_beer_warehouse_user;

--
-- TOC entry 226 (class 1259 OID 25322)
-- Name: order_picking_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_picking_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_picking_details_id_seq OWNER TO wms_beer_warehouse_user;

--
-- TOC entry 4923 (class 0 OID 0)
-- Dependencies: 226
-- Name: order_picking_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_picking_details_id_seq OWNED BY public.order_picking_details.id;


--
-- TOC entry 219 (class 1259 OID 25222)
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    order_id character varying(15) NOT NULL,
    customer_id character varying(15),
    amount integer,
    create_date date,
    status character varying(20),
    price numeric(7,2),
    total_weight numeric(7,2),
    pallet_used character varying(15),
    shipping_date date
);


ALTER TABLE public.orders OWNER TO wms_beer_warehouse_user;

--
-- TOC entry 220 (class 1259 OID 25232)
-- Name: orders_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders_details (
    order_id character varying(15),
    product_name character varying(100),
    code character varying(60),
    amount integer,
    ean character varying(20),
    price_netto numeric(7,2),
    price_brutto numeric(10,2),
    product_weight numeric(5,2),
    total_price numeric(10,2),
    id integer NOT NULL,
    status character varying DEFAULT 'undone'::character varying,
    collected_amount integer DEFAULT 0
);


ALTER TABLE public.orders_details OWNER TO wms_beer_warehouse_user;

--
-- TOC entry 223 (class 1259 OID 25295)
-- Name: orders_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_details_id_seq OWNER TO wms_beer_warehouse_user;

--
-- TOC entry 4924 (class 0 OID 0)
-- Dependencies: 223
-- Name: orders_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_details_id_seq OWNED BY public.orders_details.id;


--
-- TOC entry 221 (class 1259 OID 25240)
-- Name: pallet_used; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pallet_used (
    pallet_name character varying(25),
    code character varying(10),
    price numeric(7,2),
    pallet_weight numeric(5,2)
);


ALTER TABLE public.pallet_used OWNER TO wms_beer_warehouse_user;

--
-- TOC entry 225 (class 1259 OID 25303)
-- Name: picks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.picks (
    id integer NOT NULL,
    user_id character varying,
    order_id character varying,
    product_name character varying,
    amount integer,
    date date,
    "time" time with time zone,
    product_id integer,
    location character varying,
    ean character varying
);


ALTER TABLE public.picks OWNER TO wms_beer_warehouse_user;

--
-- TOC entry 224 (class 1259 OID 25302)
-- Name: picks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.picks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.picks_id_seq OWNER TO wms_beer_warehouse_user;

--
-- TOC entry 4925 (class 0 OID 0)
-- Dependencies: 224
-- Name: picks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.picks_id_seq OWNED BY public.picks.id;


--
-- TOC entry 218 (class 1259 OID 25205)
-- Name: product_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_details (
    product_name character varying(150),
    code character varying(60),
    ean character varying(40),
    unit_weight numeric(6,2),
    purchase_price numeric(6,2) DEFAULT 10,
    id integer NOT NULL
);


ALTER TABLE public.product_details OWNER TO wms_beer_warehouse_user;

--
-- TOC entry 233 (class 1259 OID 27974)
-- Name: product_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_details_id_seq OWNER TO wms_beer_warehouse_user;

--
-- TOC entry 4926 (class 0 OID 0)
-- Dependencies: 233
-- Name: product_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_details_id_seq OWNED BY public.product_details.id;


--
-- TOC entry 236 (class 1259 OID 27991)
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id integer NOT NULL,
    code character varying,
    product_name character varying,
    ean character varying,
    amount integer,
    jednostka character varying,
    unit_weight numeric(5,2),
    location character varying,
    date date,
    reserved_amount integer,
    available_amount integer
);


ALTER TABLE public.products OWNER TO wms_beer_warehouse_user;

--
-- TOC entry 235 (class 1259 OID 27990)
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_id_seq OWNER TO wms_beer_warehouse_user;

--
-- TOC entry 4927 (class 0 OID 0)
-- Dependencies: 235
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- TOC entry 228 (class 1259 OID 25336)
-- Name: relocation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.relocation (
    id integer NOT NULL,
    initial_location character varying,
    product_name character varying,
    ean character varying,
    amount integer,
    target_location character varying,
    user_id character varying,
    date date,
    "time" time with time zone,
    status character varying
);


ALTER TABLE public.relocation OWNER TO wms_beer_warehouse_user;

--
-- TOC entry 229 (class 1259 OID 25339)
-- Name: relocation_session_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.relocation_session_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.relocation_session_id_seq OWNER TO wms_beer_warehouse_user;

--
-- TOC entry 4928 (class 0 OID 0)
-- Dependencies: 229
-- Name: relocation_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.relocation_session_id_seq OWNED BY public.relocation.id;


--
-- TOC entry 222 (class 1259 OID 25281)
-- Name: reservation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reservation (
    product_name character varying(150),
    ean character varying(40),
    amount bigint,
    reserved_amount integer,
    available_amount bigint,
    id integer NOT NULL
);


ALTER TABLE public.reservation OWNER TO wms_beer_warehouse_user;

--
-- TOC entry 234 (class 1259 OID 27981)
-- Name: reservation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reservation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reservation_id_seq OWNER TO wms_beer_warehouse_user;

--
-- TOC entry 4929 (class 0 OID 0)
-- Dependencies: 234
-- Name: reservation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reservation_id_seq OWNED BY public.reservation.id;


--
-- TOC entry 216 (class 1259 OID 25177)
-- Name: suppliers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suppliers (
    supplier_id smallint NOT NULL,
    company_name character varying(40) NOT NULL,
    contact_name character varying(30),
    contact_title character varying(30),
    address character varying(60),
    city character varying(15),
    region character varying(15),
    postal_code character varying(10),
    country character varying(15),
    phone character varying(24),
    fax character varying(24),
    homepage text
);


ALTER TABLE public.suppliers OWNER TO wms_beer_warehouse_user;

--
-- TOC entry 240 (class 1259 OID 28062)
-- Name: suppliers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.suppliers_id_seq
    START WITH 30
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.suppliers_id_seq OWNER TO wms_beer_warehouse_user;

--
-- TOC entry 239 (class 1259 OID 28061)
-- Name: suppliers_supplier_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.suppliers ALTER COLUMN supplier_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.suppliers_supplier_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 238 (class 1259 OID 28006)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    user_id character varying(2) NOT NULL,
    user_name character varying(50) NOT NULL,
    password character varying(200) NOT NULL
);


ALTER TABLE public.users OWNER TO wms_beer_warehouse_user;

--
-- TOC entry 237 (class 1259 OID 28005)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO wms_beer_warehouse_user;

--
-- TOC entry 4930 (class 0 OID 0)
-- Dependencies: 237
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 4710 (class 2604 OID 25435)
-- Name: deliver_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliver_details ALTER COLUMN id SET DEFAULT nextval('public.deliver_details_id_seq'::regclass);


--
-- TOC entry 4707 (class 2604 OID 25326)
-- Name: order_picking_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_picking_details ALTER COLUMN id SET DEFAULT nextval('public.order_picking_details_id_seq'::regclass);


--
-- TOC entry 4702 (class 2604 OID 25296)
-- Name: orders_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_details ALTER COLUMN id SET DEFAULT nextval('public.orders_details_id_seq'::regclass);


--
-- TOC entry 4706 (class 2604 OID 25306)
-- Name: picks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.picks ALTER COLUMN id SET DEFAULT nextval('public.picks_id_seq'::regclass);


--
-- TOC entry 4701 (class 2604 OID 27975)
-- Name: product_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_details ALTER COLUMN id SET DEFAULT nextval('public.product_details_id_seq'::regclass);


--
-- TOC entry 4712 (class 2604 OID 27994)
-- Name: products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- TOC entry 4708 (class 2604 OID 25340)
-- Name: relocation id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relocation ALTER COLUMN id SET DEFAULT nextval('public.relocation_session_id_seq'::regclass);


--
-- TOC entry 4705 (class 2604 OID 27982)
-- Name: reservation id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation ALTER COLUMN id SET DEFAULT nextval('public.reservation_id_seq'::regclass);


--
-- TOC entry 4713 (class 2604 OID 28009)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 4891 (class 0 OID 25164)
-- Dependencies: 215
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (customer_id, company_name, contact_name, contact_title, address, city, region, postal_code, country, phone, fax) FROM stdin;
ALFKI	Alfreds Futterkiste	Maria Anders	Sales Representative	Obere Str. 57	Berlin	\N	12209	Germany	030-0074321	030-0076545
ANATR	Ana Trujillo Emparedados y helados	Ana Trujillo	Owner	Avda. de la Constitución 2222	México D.F.	\N	05021	Mexico	(5) 555-4729	(5) 555-3745
ANTON	Antonio Moreno Taquería	Antonio Moreno	Owner	Mataderos  2312	México D.F.	\N	05023	Mexico	(5) 555-3932	\N
AROUT	Around the Horn	Thomas Hardy	Sales Representative	120 Hanover Sq.	London	\N	WA1 1DP	UK	(171) 555-7788	(171) 555-6750
BERGS	Berglunds snabbköp	Christina Berglund	Order Administrator	Berguvsvägen  8	Luleå	\N	S-958 22	Sweden	0921-12 34 65	0921-12 34 67
BLAUS	Blauer See Delikatessen	Hanna Moos	Sales Representative	Forsterstr. 57	Mannheim	\N	68306	Germany	0621-08460	0621-08924
BLONP	Blondesddsl père et fils	Frédérique Citeaux	Marketing Manager	24, place Kléber	Strasbourg	\N	67000	France	88.60.15.31	88.60.15.32
BOLID	Bólido Comidas preparadas	Martín Sommer	Owner	C/ Araquil, 67	Madrid	\N	28023	Spain	(91) 555 22 82	(91) 555 91 99
BONAP	Bon app'	Laurence Lebihan	Owner	12, rue des Bouchers	Marseille	\N	13008	France	91.24.45.40	91.24.45.41
BOTTM	Bottom-Dollar Markets	Elizabeth Lincoln	Accounting Manager	23 Tsawassen Blvd.	Tsawassen	BC	T2F 8M4	Canada	(604) 555-4729	(604) 555-3745
BSBEV	B's Beverages	Victoria Ashworth	Sales Representative	Fauntleroy Circus	London	\N	EC2 5NT	UK	(171) 555-1212	\N
CACTU	Cactus Comidas para llevar	Patricio Simpson	Sales Agent	Cerrito 333	Buenos Aires	\N	1010	Argentina	(1) 135-5555	(1) 135-4892
CENTC	Centro comercial Moctezuma	Francisco Chang	Marketing Manager	Sierras de Granada 9993	México D.F.	\N	05022	Mexico	(5) 555-3392	(5) 555-7293
CHOPS	Chop-suey Chinese	Yang Wang	Owner	Hauptstr. 29	Bern	\N	3012	Switzerland	0452-076545	\N
COMMI	Comércio Mineiro	Pedro Afonso	Sales Associate	Av. dos Lusíadas, 23	Sao Paulo	SP	05432-043	Brazil	(11) 555-7647	\N
CONSH	Consolidated Holdings	Elizabeth Brown	Sales Representative	Berkeley Gardens 12  Brewery	London	\N	WX1 6LT	UK	(171) 555-2282	(171) 555-9199
DRACD	Drachenblut Delikatessen	Sven Ottlieb	Order Administrator	Walserweg 21	Aachen	\N	52066	Germany	0241-039123	0241-059428
DUMON	Du monde entier	Janine Labrune	Owner	67, rue des Cinquante Otages	Nantes	\N	44000	France	40.67.88.88	40.67.89.89
EASTC	Eastern Connection	Ann Devon	Sales Agent	35 King George	London	\N	WX3 6FW	UK	(171) 555-0297	(171) 555-3373
ERNSH	Ernst Handel	Roland Mendel	Sales Manager	Kirchgasse 6	Graz	\N	8010	Austria	7675-3425	7675-3426
FAMIA	Familia Arquibaldo	Aria Cruz	Marketing Assistant	Rua Orós, 92	Sao Paulo	SP	05442-030	Brazil	(11) 555-9857	\N
FISSA	FISSA Fabrica Inter. Salchichas S.A.	Diego Roel	Accounting Manager	C/ Moralzarzal, 86	Madrid	\N	28034	Spain	(91) 555 94 44	(91) 555 55 93
FOLIG	Folies gourmandes	Martine Rancé	Assistant Sales Agent	184, chaussée de Tournai	Lille	\N	59000	France	20.16.10.16	20.16.10.17
FOLKO	Folk och fä HB	Maria Larsson	Owner	Åkergatan 24	Bräcke	\N	S-844 67	Sweden	0695-34 67 21	\N
FRANK	Frankenversand	Peter Franken	Marketing Manager	Berliner Platz 43	München	\N	80805	Germany	089-0877310	089-0877451
FRANR	France restauration	Carine Schmitt	Marketing Manager	54, rue Royale	Nantes	\N	44000	France	40.32.21.21	40.32.21.20
FRANS	Franchi S.p.A.	Paolo Accorti	Sales Representative	Via Monte Bianco 34	Torino	\N	10100	Italy	011-4988260	011-4988261
FURIB	Furia Bacalhau e Frutos do Mar	Lino Rodriguez	Sales Manager	Jardim das rosas n. 32	Lisboa	\N	1675	Portugal	(1) 354-2534	(1) 354-2535
GALED	Galería del gastrónomo	Eduardo Saavedra	Marketing Manager	Rambla de Cataluña, 23	Barcelona	\N	08022	Spain	(93) 203 4560	(93) 203 4561
GODOS	Godos Cocina Típica	José Pedro Freyre	Sales Manager	C/ Romero, 33	Sevilla	\N	41101	Spain	(95) 555 82 82	\N
GOURL	Gourmet Lanchonetes	André Fonseca	Sales Associate	Av. Brasil, 442	Campinas	SP	04876-786	Brazil	(11) 555-9482	\N
GREAL	Great Lakes Food Market	Howard Snyder	Marketing Manager	2732 Baker Blvd.	Eugene	OR	97403	USA	(503) 555-7555	\N
GROSR	GROSELLA-Restaurante	Manuel Pereira	Owner	5ª Ave. Los Palos Grandes	Caracas	DF	1081	Venezuela	(2) 283-2951	(2) 283-3397
HANAR	Hanari Carnes	Mario Pontes	Accounting Manager	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil	(21) 555-0091	(21) 555-8765
HILAA	HILARION-Abastos	Carlos Hernández	Sales Representative	Carrera 22 con Ave. Carlos Soublette #8-35	San Cristóbal	Táchira	5022	Venezuela	(5) 555-1340	(5) 555-1948
HUNGC	Hungry Coyote Import Store	Yoshi Latimer	Sales Representative	City Center Plaza 516 Main St.	Elgin	OR	97827	USA	(503) 555-6874	(503) 555-2376
HUNGO	Hungry Owl All-Night Grocers	Patricia McKenna	Sales Associate	8 Johnstown Road	Cork	Co. Cork	\N	Ireland	2967 542	2967 3333
ISLAT	Island Trading	Helen Bennett	Marketing Manager	Garden House Crowther Way	Cowes	Isle of Wight	PO31 7PJ	UK	(198) 555-8888	\N
KOENE	Königlich Essen	Philip Cramer	Sales Associate	Maubelstr. 90	Brandenburg	\N	14776	Germany	0555-09876	\N
LACOR	La corne d'abondance	Daniel Tonini	Sales Representative	67, avenue de l'Europe	Versailles	\N	78000	France	30.59.84.10	30.59.85.11
LAMAI	La maison d'Asie	Annette Roulet	Sales Manager	1 rue Alsace-Lorraine	Toulouse	\N	31000	France	61.77.61.10	61.77.61.11
LAUGB	Laughing Bacchus Wine Cellars	Yoshi Tannamuri	Marketing Assistant	1900 Oak St.	Vancouver	BC	V3F 2K1	Canada	(604) 555-3392	(604) 555-7293
LAZYK	Lazy K Kountry Store	John Steel	Marketing Manager	12 Orchestra Terrace	Walla Walla	WA	99362	USA	(509) 555-7969	(509) 555-6221
LEHMS	Lehmanns Marktstand	Renate Messner	Sales Representative	Magazinweg 7	Frankfurt a.M.	\N	60528	Germany	069-0245984	069-0245874
LETSS	Let's Stop N Shop	Jaime Yorres	Owner	87 Polk St. Suite 5	San Francisco	CA	94117	USA	(415) 555-5938	\N
LILAS	LILA-Supermercado	Carlos González	Accounting Manager	Carrera 52 con Ave. Bolívar #65-98 Llano Largo	Barquisimeto	Lara	3508	Venezuela	(9) 331-6954	(9) 331-7256
LINOD	LINO-Delicateses	Felipe Izquierdo	Owner	Ave. 5 de Mayo Porlamar	I. de Margarita	Nueva Esparta	4980	Venezuela	(8) 34-56-12	(8) 34-93-93
LONEP	Lonesome Pine Restaurant	Fran Wilson	Sales Manager	89 Chiaroscuro Rd.	Portland	OR	97219	USA	(503) 555-9573	(503) 555-9646
MAGAA	Magazzini Alimentari Riuniti	Giovanni Rovelli	Marketing Manager	Via Ludovico il Moro 22	Bergamo	\N	24100	Italy	035-640230	035-640231
MAISD	Maison Dewey	Catherine Dewey	Sales Agent	Rue Joseph-Bens 532	Bruxelles	\N	B-1180	Belgium	(02) 201 24 67	(02) 201 24 68
MEREP	Mère Paillarde	Jean Fresnière	Marketing Assistant	43 rue St. Laurent	Montréal	Québec	H1J 1C3	Canada	(514) 555-8054	(514) 555-8055
MORGK	Morgenstern Gesundkost	Alexander Feuer	Marketing Assistant	Heerstr. 22	Leipzig	\N	04179	Germany	0342-023176	\N
NORTS	North/South	Simon Crowther	Sales Associate	South House 300 Queensbridge	London	\N	SW7 1RZ	UK	(171) 555-7733	(171) 555-2530
OCEAN	Océano Atlántico Ltda.	Yvonne Moncada	Sales Agent	Ing. Gustavo Moncada 8585 Piso 20-A	Buenos Aires	\N	1010	Argentina	(1) 135-5333	(1) 135-5535
OLDWO	Old World Delicatessen	Rene Phillips	Sales Representative	2743 Bering St.	Anchorage	AK	99508	USA	(907) 555-7584	(907) 555-2880
OTTIK	Ottilies Käseladen	Henriette Pfalzheim	Owner	Mehrheimerstr. 369	Köln	\N	50739	Germany	0221-0644327	0221-0765721
PARIS	Paris spécialités	Marie Bertrand	Owner	265, boulevard Charonne	Paris	\N	75012	France	(1) 42.34.22.66	(1) 42.34.22.77
PERIC	Pericles Comidas clásicas	Guillermo Fernández	Sales Representative	Calle Dr. Jorge Cash 321	México D.F.	\N	05033	Mexico	(5) 552-3745	(5) 545-3745
PICCO	Piccolo und mehr	Georg Pipps	Sales Manager	Geislweg 14	Salzburg	\N	5020	Austria	6562-9722	6562-9723
PRINI	Princesa Isabel Vinhos	Isabel de Castro	Sales Representative	Estrada da saúde n. 58	Lisboa	\N	1756	Portugal	(1) 356-5634	\N
QUEDE	Que Delícia	Bernardo Batista	Accounting Manager	Rua da Panificadora, 12	Rio de Janeiro	RJ	02389-673	Brazil	(21) 555-4252	(21) 555-4545
QUEEN	Queen Cozinha	Lúcia Carvalho	Marketing Assistant	Alameda dos Canàrios, 891	Sao Paulo	SP	05487-020	Brazil	(11) 555-1189	\N
QUICK	QUICK-Stop	Horst Kloss	Accounting Manager	Taucherstraße 10	Cunewalde	\N	01307	Germany	0372-035188	\N
RANCH	Rancho grande	Sergio Gutiérrez	Sales Representative	Av. del Libertador 900	Buenos Aires	\N	1010	Argentina	(1) 123-5555	(1) 123-5556
RATTC	Rattlesnake Canyon Grocery	Paula Wilson	Assistant Sales Representative	2817 Milton Dr.	Albuquerque	NM	87110	USA	(505) 555-5939	(505) 555-3620
REGGC	Reggiani Caseifici	Maurizio Moroni	Sales Associate	Strada Provinciale 124	Reggio Emilia	\N	42100	Italy	0522-556721	0522-556722
RICAR	Ricardo Adocicados	Janete Limeira	Assistant Sales Agent	Av. Copacabana, 267	Rio de Janeiro	RJ	02389-890	Brazil	(21) 555-3412	\N
RICSU	Richter Supermarkt	Michael Holz	Sales Manager	Grenzacherweg 237	Genève	\N	1203	Switzerland	0897-034214	\N
ROMEY	Romero y tomillo	Alejandra Camino	Accounting Manager	Gran Vía, 1	Madrid	\N	28001	Spain	(91) 745 6200	(91) 745 6210
SANTG	Santé Gourmet	Jonas Bergulfsen	Owner	Erling Skakkes gate 78	Stavern	\N	4110	Norway	07-98 92 35	07-98 92 47
SAVEA	Save-a-lot Markets	Jose Pavarotti	Sales Representative	187 Suffolk Ln.	Boise	ID	83720	USA	(208) 555-8097	\N
SEVES	Seven Seas Imports	Hari Kumar	Sales Manager	90 Wadhurst Rd.	London	\N	OX15 4NB	UK	(171) 555-1717	(171) 555-5646
SIMOB	Simons bistro	Jytte Petersen	Owner	Vinbæltet 34	Kobenhavn	\N	1734	Denmark	31 12 34 56	31 13 35 57
SPECD	Spécialités du monde	Dominique Perrier	Marketing Manager	25, rue Lauriston	Paris	\N	75016	France	(1) 47.55.60.10	(1) 47.55.60.20
SPLIR	Split Rail Beer & Ale	Art Braunschweiger	Sales Manager	P.O. Box 555	Lander	WY	82520	USA	(307) 555-4680	(307) 555-6525
SUPRD	Suprêmes délices	Pascale Cartrain	Accounting Manager	Boulevard Tirou, 255	Charleroi	\N	B-6000	Belgium	(071) 23 67 22 20	(071) 23 67 22 21
THEBI	The Big Cheese	Liz Nixon	Marketing Manager	89 Jefferson Way Suite 2	Portland	OR	97201	USA	(503) 555-3612	\N
THECR	The Cracker Box	Liu Wong	Marketing Assistant	55 Grizzly Peak Rd.	Butte	MT	59801	USA	(406) 555-5834	(406) 555-8083
TOMSP	Toms Spezialitäten	Karin Josephs	Marketing Manager	Luisenstr. 48	Münster	\N	44087	Germany	0251-031259	0251-035695
TORTU	Tortuga Restaurante	Miguel Angel Paolino	Owner	Avda. Azteca 123	México D.F.	\N	05033	Mexico	(5) 555-2933	\N
TRADH	Tradição Hipermercados	Anabela Domingues	Sales Representative	Av. Inês de Castro, 414	Sao Paulo	SP	05634-030	Brazil	(11) 555-2167	(11) 555-2168
TRAIH	Trail's Head Gourmet Provisioners	Helvetius Nagy	Sales Associate	722 DaVinci Blvd.	Kirkland	WA	98034	USA	(206) 555-8257	(206) 555-2174
VAFFE	Vaffeljernet	Palle Ibsen	Sales Manager	Smagsloget 45	Århus	\N	8200	Denmark	86 21 32 43	86 22 33 44
VICTE	Victuailles en stock	Mary Saveley	Sales Agent	2, rue du Commerce	Lyon	\N	69004	France	78.32.54.86	78.32.54.87
VINET	Vins et alcools Chevalier	Paul Henriot	Accounting Manager	59 rue de l'Abbaye	Reims	\N	51100	France	26.47.15.10	26.47.15.11
WANDK	Die Wandernde Kuh	Rita Müller	Sales Representative	Adenauerallee 900	Stuttgart	\N	70563	Germany	0711-020361	0711-035428
WARTH	Wartian Herkku	Pirkko Koskitalo	Accounting Manager	Torikatu 38	Oulu	\N	90110	Finland	981-443655	981-443655
WELLI	Wellington Importadora	Paula Parente	Sales Manager	Rua do Mercado, 12	Resende	SP	08737-363	Brazil	(14) 555-8122	\N
WHITC	White Clover Markets	Karl Jablonski	Owner	305 - 14th Ave. S. Suite 3B	Seattle	WA	98128	USA	(206) 555-4112	(206) 555-4115
WILMK	Wilman Kala	Matti Karttunen	Owner/Marketing Assistant	Keskuskatu 45	Helsinki	\N	21240	Finland	90-224 8858	90-224 8858
WOLZA	Wolski  Zajazd	Zbyszek Piestrzeniewicz	Owner	ul. Filtrowa 68	Warszawa	\N	01-012	Poland	(26) 642-7012	(26) 642-7012
JABEX	JABEX	Lepek	MR	Bestwinska	Bielsko	slask	33-400	Poland	7777777	999999
\.


--
-- TOC entry 4908 (class 0 OID 25432)
-- Dependencies: 232
-- Data for Name: deliver_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deliver_details (id, deliver_id, user_id, product_name, ean, expected_amount, amount, date, deliver_time, status, target_location, deliver_date) FROM stdin;
6	PZ-001-10-2025	KS	TRZECH KUMPLI CALIFIA BUT. 0,5 L	5905669479264	150	100	2026-02-20	19:42:00+02	pending	RK-19-00	2025-10-14
7	PZ-001-10-2025	KS	TRZECH KUMPLI CALIFIA BUT. 0,5 L	5905669479264	50	50	2026-02-20	19:48:00+02	done	RG-19-02	2025-10-14
4	PZ-001-10-2025	KS	TRZECH KUMPLI MISTY BUT. 0,5 L	5905669479189	100	100	2026-02-20	20:05:00+02	done	RG-17-01	2025-10-14
5	PZ-001-10-2025	KS	TRZECH KUMPLI PILS BUT. 0,5 L	5905669479233	200	50	2026-02-20	20:10:00+02	pending	RL-19-00	2025-10-14
8	PZ-001-10-2025	KS	TRZECH KUMPLI PILS BUT. 0,5 L	5905669479233	150	160	2026-02-20	21:20:00+02	pending	RK-18-00	2025-10-14
10	PZ-001-12-2025	\N	TRZECH KUMPLI PILS BUT. 0,5 L	5905669479233	200	\N	\N	\N	undone	\N	\N
11	PZ-001-12-2025	\N	TRZECH KUMPLI CALIFIA BUT. 0,5 L	5905669479264	150	\N	\N	\N	undone	\N	\N
9	PZ-001-12-2025	KS	TRZECH KUMPLI MISTY BUT. 0,5 L	5905669479189	100	160	2026-02-20	19:45:00+01	pending	RK-19-03	2025-12-04
\.


--
-- TOC entry 4906 (class 0 OID 25413)
-- Dependencies: 230
-- Data for Name: delivery_order; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.delivery_order (deliver_id, supplier, delivery_date, status, deliver_external_number, create_date) FROM stdin;
PZ-001-10-2025	Exotic Liquids	2025-12-31	done	ZO/2000123/2025	2025-10-14
PZ-001-12-2025	Exotic Liquids	2025-12-31	undone	ZO/2000123/2025	2025-12-04
\.


--
-- TOC entry 4893 (class 0 OID 25189)
-- Dependencies: 217
-- Data for Name: location_weights; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location_weights (location, weightlimitonlocation, actualweightonlocation, limitofamountonlocation, actualamountonlocation) FROM stdin;
RA-01-00	500	324.17	540	534
RA-01-01	250	87.6	300	144
RA-01-02	750	719.95	1200	935
RA-01-03	750	897.05	1200	1165
RA-01-04	750	377.5	1200	755
RA-02-00	500	377.3	540	490
RA-02-01	250	134.48	300	294
RA-02-02	750	276	1200	1057
RA-02-03	750	356	1200	712
RA-02-04	750	672.98	1200	874
RA-03-00	500	391.16	540	508
RA-03-01	250	225.61	300	293
RA-03-02	750	762.86	1200	1181
RA-03-03	750	642.06	1200	1189
RA-03-04	750	562.68	1200	1042
RA-04-00	500	415.8	540	540
RA-04-01	250	192.46	300	299
RA-04-02	750	606.96	1200	1124
RA-04-03	750	632.94	1200	822
RA-04-04	750	891.66	1200	1158
RA-05-00	500	346.5	540	450
RA-05-01	250	154.11	300	298
RA-05-02	750	923.23	1200	1199
RA-05-03	750	792.33	1200	1029
RA-05-04	750	757.52	1200	1166
RA-06-00	500	396.55	540	515
RA-06-01	250	224.84	300	292
RA-06-02	750	546.7	1200	710
RA-06-03	750	743.82	1200	966
RA-06-04	750	871.64	1200	1132
RA-07-00	500	449.46	540	540
RA-07-01	250	192.36	300	267
RA-07-02	750	584	1200	1168
RA-07-03	750	386.54	1200	1189
RA-07-04	750	0	1200	1084
RA-08-00	500	367.29	540	477
RA-08-01	250	200.95	300	278
RA-08-02	750	0	1200	951
RA-08-03	750	0	1200	1126
RA-08-04	750	0	1200	1143
RA-09-00	500	396.45	540	540
RA-09-01	250	145.18	300	218
RA-09-02	750	0	1200	1166
RA-09-03	750	0	1200	1156
RA-09-04	750	0	1200	737
RA-10-00	500	56.7	540	530
RA-10-01	250	156.86	300	223
RA-10-02	750	0	1200	690
RA-10-03	750	0	1200	1161
RA-10-04	750	0	1200	775
RA-11-00	500	285.18	540	454
RA-11-01	250	169.33	300	296
RA-11-02	750	0	1200	1102
RA-11-03	750	0	1200	846
RA-11-04	750	0	1200	967
RA-12-00	500	195.97	540	504
RA-12-01	250	223.3	300	290
RA-12-02	750	0	1200	968
RA-12-03	750	904.75	1200	1175
RA-12-04	750	423.5	1200	847
RA-13-00	500	289.98	540	537
RA-13-01	250	231	300	300
RA-13-02	750	429.5	1200	859
RA-13-03	750	493.05	1200	1164
RA-13-04	750	642.18	1200	834
RA-14-00	500	316.35	540	536
RA-14-01	250	147.09	300	247
RA-14-02	750	766.15	1200	995
RA-14-03	750	611.38	1200	794
RA-14-04	750	248.5	1200	710
RA-15-00	500	313.2	540	511
RA-15-01	250	165.24	300	255
RA-15-02	750	897.82	1200	1166
RA-15-03	750	350	1200	700
RA-15-04	750	671.44	1200	872
RA-16-00	500	317.74	540	539
RA-16-01	250	110.15	300	179
RA-16-02	750	632.17	1200	821
RA-16-03	750	712.93	1200	1083
RA-16-04	750	435.05	1200	565
RA-17-00	500	164.15	540	535
RA-17-01	250	130.28	300	214
RA-17-02	750	577.5	1200	750
RA-17-03	750	697.62	1200	906
RA-17-04	750	613.69	1200	797
RA-18-00	500	284.12	540	538
RA-18-01	250	137.42	300	208
RA-18-02	750	677.6	1200	880
RA-18-03	750	663.74	1200	862
RA-18-04	750	509.74	1200	662
RA-19-00	500	381.9	540	537
RA-19-01	250	149.24	300	244
RA-19-02	750	1692.9	1200	3135
RA-19-03	750	0	1200	7077
RA-19-04	750	0	1200	3100
RA-20-00	70	47.26	80	80
RA-20-01	70	4	80	80
RA-20-02	70	0	80	63
RA-20-03	70	0	80	80
RA-20-04	70	0	80	80
RA-21-00	70	0	80	60
RA-21-01	70	558.16	80	72
RA-21-02	70	253.73	80	80
RA-21-03	70	50.68	80	80
RA-21-04	70	152.93	80	80
RB-01-00	500	378.35	540	538
RB-01-01	250	82.5	300	295
RB-01-02	750	1927.5	1200	3855
RB-01-03	750	0	1200	350
RB-01-04	750	0	1200	307
RB-02-00	500	335.55	540	501
RB-02-01	250	215.3	300	300
RB-02-02	750	0	1200	352
RB-02-03	750	0	1200	307
RB-02-04	750	1206.9	1200	2235
RB-03-00	500	272.44	540	530
RB-03-01	250	194.7	300	297
RB-03-02	750	0	1200	6177
RB-03-03	750	0	1200	2200
RB-03-04	750	1477.5	1200	2955
RB-04-00	500	150.66	540	478
RB-04-01	250	126.51	300	262
RB-04-02	750	720.9	1200	1335
RB-04-03	750	0	1200	5277
RB-04-04	750	0	1200	1300
RB-05-00	500	226	540	452
RB-05-01	250	215.32	300	299
RB-05-02	750	1027.5	1200	2055
RB-05-03	750	234.9	1200	435
RB-05-04	750	0	1200	4377
RB-06-00	500	257.36	540	486
RB-06-01	250	142.5	300	285
RB-06-02	750	0	1200	400
RB-06-03	750	577.5	1200	1155
RB-06-04	750	0	1200	3477
RB-07-00	500	356.15	540	539
RB-07-01	250	230.23	300	299
RB-07-02	750	127.5	1200	255
RB-07-03	750	0	1200	2577
RB-07-04	750	0	1200	1677
RB-08-00	500	368.06	540	478
RB-08-01	250	224.07	300	291
RB-08-02	750	0	1200	777
RB-08-03	750	0	1200	0
RB-08-04	750	0	1200	0
RB-09-00	500	374.99	540	487
RB-09-01	250	92.02	300	165
RB-09-02	750	0	1200	0
RB-09-03	750	0	1200	0
RB-09-04	750	0	1200	0
RB-10-00	500	425.37	540	498
RB-10-01	250	187.35	300	292
RB-10-02	750	0	1200	0
RB-10-03	750	0	1200	0
RB-10-04	750	0	1200	0
RB-11-00	500	377.3	540	490
RB-11-01	250	197.4	300	296
RB-11-02	750	0	1200	0
RB-11-03	750	0	1200	0
RB-11-04	750	0	1200	0
RB-12-00	500	376.01	540	529
RB-12-01	250	123.2	300	258
RB-12-02	750	0	1200	0
RB-12-03	750	0	1200	0
RB-12-04	750	0	1200	0
RB-13-00	500	427.68	540	456
RB-13-01	250	137.3	300	246
RB-13-02	750	0	1200	0
RB-13-03	750	0	1200	0
RB-13-04	750	0	1200	0
RB-14-00	500	171.6	540	537
RB-14-01	250	234.8	300	296
RB-14-02	750	0	1200	0
RB-14-03	750	0	1200	0
RB-14-04	750	0	1200	0
RB-15-00	500	263	540	526
RB-15-01	250	320.1	300	291
RB-15-02	750	0	1200	0
RB-15-03	750	0	1200	0
RB-15-04	750	0	1200	0
RB-16-00	500	314.37	540	477
RB-16-01	250	245.93	300	295
RB-16-02	750	0	1200	0
RB-16-03	750	0	1200	0
RB-16-04	750	0	1200	0
RB-17-00	500	0	540	478
RB-17-01	250	169.8	300	234
RB-17-02	750	0	1200	0
RB-17-03	750	0	1200	0
RB-17-04	750	0	1200	0
RB-18-00	500	415.03	540	539
RB-18-01	250	608	300	256
RB-18-02	750	0	1200	0
RB-18-03	750	0	1200	0
RB-18-04	750	0	1200	0
RB-19-00	500	343.42	540	446
RB-19-01	250	67.05	300	200
RB-19-02	750	0	1200	0
RB-19-03	750	0	1200	0
RB-19-04	750	0	1200	0
RB-20-00	70	1076.2	80	80
RB-20-01	70	324.82	80	80
RB-20-02	70	169.13	80	80
RB-20-03	70	1611.5	80	66
RB-20-04	70	103.42	80	80
RB-21-00	70	44.33	80	20
RB-21-01	70	0	80	0
RB-21-02	70	0	80	0
RB-21-03	70	0	80	0
RB-21-04	70	0	80	0
RC-01-00	500	406.56	540	528
RC-01-01	250	146.88	300	278
RC-01-02	750	0	1200	0
RC-01-03	750	0	1200	0
RC-01-04	750	0	1200	0
RC-02-00	500	0	540	446
RC-02-01	250	46.22	300	199
RC-02-02	750	0	1200	0
RC-02-03	750	0	1200	0
RC-02-04	750	0	1200	0
RC-03-00	500	218.76	540	512
RC-03-01	250	168.76	300	293
RC-03-02	750	0	1200	0
RC-03-03	750	0	1200	0
RC-03-04	750	0	1200	0
RC-04-00	500	319.57	540	536
RC-04-01	250	147.02	300	300
RC-04-02	750	0	1200	0
RC-04-03	750	0	1200	0
RC-04-04	750	0	1200	0
RC-05-00	500	302.63	540	528
RC-05-01	250	162.06	300	300
RC-05-02	750	0	1200	0
RC-05-03	750	0	1200	0
RC-05-04	750	0	1200	0
RC-06-00	500	231.8	540	539
RC-06-01	250	238.68	300	280
RC-06-02	750	0	1200	0
RC-06-03	750	0	1200	0
RC-06-04	750	0	1200	0
RC-07-00	500	468.4	540	494
RC-07-01	250	140.5	300	298
RC-07-02	750	0	1200	0
RC-07-03	750	0	1200	0
RC-07-04	750	0	1200	0
RC-08-00	500	355.32	540	540
RC-08-01	250	120.1	300	163
RC-08-02	750	0	1200	0
RC-08-03	750	0	1200	0
RC-08-04	750	0	1200	0
RC-09-00	500	350.35	540	455
RC-09-01	250	68.07	300	163
RC-09-02	750	0	1200	0
RC-09-03	750	0	1200	0
RC-09-04	750	0	1200	0
RC-10-00	500	240	540	480
RC-10-01	250	76.03	300	177
RC-10-02	750	0	1200	0
RC-10-03	750	0	1200	0
RC-10-04	750	0	1200	0
RC-11-00	500	351.62	540	511
RC-11-01	250	48.65	300	139
RC-11-02	750	0	1200	0
RC-11-03	750	0	1200	0
RC-11-04	750	0	1200	0
RC-12-00	500	375.8	540	523
RC-12-01	250	639.64	300	163
RC-12-02	750	0	1200	0
RC-12-03	750	0	1200	0
RC-12-04	750	0	1200	0
RC-13-00	500	289.44	540	536
RC-13-01	250	751.3	300	242
RC-13-02	750	0	1200	0
RC-13-03	750	0	1200	0
RC-13-04	750	0	1200	0
RC-14-00	500	288.36	540	534
RC-14-01	250	76.68	300	191
RC-14-02	750	0	1200	0
RC-14-03	750	0	1200	0
RC-14-04	750	0	1200	0
RC-15-00	500	304.83	540	484
RC-15-01	250	216.48	300	291
RC-15-02	750	0	1200	0
RC-15-03	750	0	1200	0
RC-15-04	750	0	1200	0
RC-16-00	500	383.83	540	540
RC-16-01	250	208.51	300	292
RC-16-02	750	0	1200	0
RC-16-03	750	0	1200	0
RC-16-04	750	0	1200	0
RC-17-00	500	288.9	540	535
RC-17-01	250	113.7	300	195
RC-17-02	750	0	1200	0
RC-17-03	750	0	1200	0
RC-17-04	750	0	1200	0
RC-18-00	500	379.61	540	493
RC-18-01	250	59.14	300	153
RC-18-02	750	0	1200	0
RC-18-03	750	0	1200	0
RC-18-04	750	0	1200	0
RC-19-00	500	238.68	540	442
RC-19-01	250	91.2	300	126
RC-19-02	750	0	1200	0
RC-19-03	750	0	1200	0
RC-19-04	750	0	1200	0
RC-20-00	70	0	80	0
RC-20-01	70	0	80	0
RC-20-02	70	0	80	0
RC-20-03	70	0	80	0
RC-20-04	70	0	80	0
RC-21-00	70	0	80	0
RC-21-01	70	0	80	0
RC-21-02	70	0	80	0
RC-21-03	70	0	80	0
RC-21-04	70	0	80	0
RD-01-00	500	276.48	540	512
RD-01-01	250	138.5	300	222
RD-01-02	750	0	1200	0
RD-01-03	750	0	1200	0
RD-01-04	750	0	1200	0
RD-02-00	500	254.34	540	471
RD-02-01	250	53.9	300	186
RD-02-02	750	0	1200	0
RD-02-03	750	0	1200	0
RD-02-04	750	0	1200	0
RD-03-00	500	132.3	540	529
RD-03-01	250	224.07	300	291
RD-03-02	750	0	1200	0
RD-03-03	750	0	1200	0
RD-03-04	750	0	1200	0
RD-04-00	500	272.48	540	516
RD-04-01	250	145.16	300	272
RD-04-02	750	0	1200	0
RD-04-03	750	0	1200	0
RD-04-04	750	0	1200	0
RD-05-00	500	277.56	540	526
RD-05-01	250	144.74	300	299
RD-05-02	750	0	1200	0
RD-05-03	750	0	1200	0
RD-05-04	750	0	1200	0
RD-06-00	500	357.28	540	464
RD-06-01	250	121.54	300	214
RD-06-02	750	0	1200	0
RD-06-03	750	0	1200	0
RD-06-04	750	0	1200	0
RD-07-00	500	280.26	540	519
RD-07-01	250	144.89	300	300
RD-07-02	750	0	1200	0
RD-07-03	750	0	1200	0
RD-07-04	750	0	1200	0
RD-08-00	500	262.44	540	486
RD-08-01	250	151.42	300	254
RD-08-02	750	0	1200	0
RD-08-03	750	0	1200	0
RD-08-04	750	0	1200	0
RD-09-00	500	257.04	540	476
RD-09-01	250	154.52	300	286
RD-09-02	750	0	1200	0
RD-09-03	750	0	1200	0
RD-09-04	750	0	1200	0
RD-10-00	500	338.84	540	521
RD-10-01	250	150.15	300	290
RD-10-02	750	0	1200	0
RD-10-03	750	0	1200	0
RD-10-04	750	0	1200	0
RD-11-00	500	446.05	540	536
RD-11-01	250	178.06	300	299
RD-11-02	750	0	1200	0
RD-11-03	750	0	1200	0
RD-11-04	750	0	1200	0
RD-12-00	500	348.81	540	453
RD-12-01	250	227.26	300	299
RD-12-02	750	0	1200	0
RD-12-03	750	0	1200	0
RD-12-04	750	0	1200	0
RD-13-00	500	244.07	540	521
RD-13-01	250	228.69	300	297
RD-13-02	750	0	1200	0
RD-13-03	750	0	1200	0
RD-13-04	750	0	1200	0
RD-14-00	500	328.96	540	497
RD-14-01	250	216.37	300	300
RD-14-02	750	0	1200	0
RD-14-03	750	0	1200	0
RD-14-04	750	0	1200	0
RD-15-00	500	311.77	540	488
RD-15-01	250	209.85	300	299
RD-15-02	750	0	1200	0
RD-15-03	750	0	1200	0
RD-15-04	750	0	1200	0
RD-16-00	500	128.26	540	539
RD-16-01	250	161.64	300	298
RD-16-02	750	0	1200	0
RD-16-03	750	0	1200	0
RD-16-04	750	0	1200	0
RD-17-00	500	346.5	540	450
RD-17-01	250	205.16	300	299
RD-17-02	750	0	1200	0
RD-17-03	750	0	1200	0
RD-17-04	750	0	1200	0
RD-18-00	500	358.82	540	466
RD-18-01	250	124.13	300	231
RD-18-02	750	0	1200	0
RD-18-03	750	0	1200	0
RD-18-04	750	0	1200	0
RD-19-00	500	401.94	540	522
RD-19-01	250	90.4	300	220
RD-19-02	750	0	1200	0
RD-19-03	750	0	1200	0
RD-19-04	750	0	1200	0
RD-20-00	70	0	80	0
RD-20-01	70	0	80	0
RD-20-02	70	0	80	0
RD-20-03	70	0	80	0
RD-20-04	70	0	80	0
RD-21-00	70	0	80	0
RD-21-01	70	0	80	0
RD-21-02	70	0	80	0
RD-21-03	70	0	80	0
RD-21-04	70	0	80	0
RE-01-00	500	358.82	540	466
RE-01-01	250	195.58	300	286
RE-01-02	750	0	1200	0
RE-01-03	750	0	1200	0
RE-01-04	750	0	1200	0
RE-02-00	500	377.3	540	490
RE-02-01	250	118.6	300	292
RE-02-02	750	0	1200	0
RE-02-03	750	0	1200	0
RE-02-04	750	0	1200	0
RE-03-00	500	395.01	540	513
RE-03-01	250	186.06	300	265
RE-03-02	750	0	1200	0
RE-03-03	750	0	1200	0
RE-03-04	750	0	1200	0
RE-04-00	500	365.75	540	475
RE-04-01	250	213.77	300	292
RE-04-02	750	0	1200	0
RE-04-03	750	0	1200	0
RE-04-04	750	0	1200	0
RE-05-00	500	354.2	540	460
RE-05-01	250	57.12	300	284
RE-05-02	750	0	1200	0
RE-05-03	750	0	1200	0
RE-05-04	750	0	1200	0
RE-06-00	500	369.6	540	480
RE-06-01	250	149.28	300	242
RE-06-02	750	0	1200	0
RE-06-03	750	0	1200	0
RE-06-04	750	0	1200	0
RE-07-00	500	318.78	540	538
RE-07-01	250	153.92	300	229
RE-07-02	750	0	1200	0
RE-07-03	750	0	1200	0
RE-07-04	750	0	1200	0
RE-08-00	500	415.03	540	539
RE-08-01	250	170.94	300	299
RE-08-02	750	0	1200	0
RE-08-03	750	0	1200	0
RE-08-04	750	0	1200	0
RE-09-00	500	346.5	540	450
RE-09-01	250	8	300	296
RE-09-02	750	0	1200	0
RE-09-03	750	0	1200	0
RE-09-04	750	0	1200	0
RE-10-00	500	388.08	540	504
RE-10-01	250	143.99	300	292
RE-10-02	750	0	1200	0
RE-10-03	750	0	1200	0
RE-10-04	750	0	1200	0
RE-11-00	500	414.26	540	538
RE-11-01	250	117.67	300	294
RE-11-02	750	0	1200	0
RE-11-03	750	0	1200	0
RE-11-04	750	0	1200	0
RE-12-00	500	363.44	540	472
RE-12-01	250	126.53	300	239
RE-12-02	750	0	1200	0
RE-12-03	750	0	1200	0
RE-12-04	750	0	1200	0
RE-13-00	500	371.69	540	529
RE-13-01	250	66.22	300	182
RE-13-02	750	0	1200	0
RE-13-03	750	0	1200	0
RE-13-04	750	0	1200	0
RE-14-00	500	231.87	540	513
RE-14-01	250	149.66	300	214
RE-14-02	750	0	1200	0
RE-14-03	750	0	1200	0
RE-14-04	750	0	1200	0
RE-15-00	500	331.8	540	480
RE-15-01	250	179.92	300	254
RE-15-02	750	0	1200	0
RE-15-03	750	0	1200	0
RE-15-04	750	0	1200	0
RE-16-00	500	393.47	540	511
RE-16-01	250	196.8	300	295
RE-16-02	750	0	1200	0
RE-16-03	750	0	1200	0
RE-16-04	750	0	1200	0
RE-17-00	500	277.2	540	527
RE-17-01	250	116.6	300	260
RE-17-02	750	0	1200	0
RE-17-03	750	0	1200	0
RE-17-04	750	0	1200	0
RE-18-00	500	285.67	540	540
RE-18-01	250	697.1	300	289
RE-18-02	750	0	1200	0
RE-18-03	750	0	1200	0
RE-18-04	750	0	1200	0
RE-19-00	500	313.81	540	533
RE-19-01	250	467.45	300	250
RE-19-02	750	0	1200	0
RE-19-03	750	0	1200	0
RE-19-04	750	0	1200	0
RE-20-00	70	0	80	0
RE-20-01	70	0	80	0
RE-20-02	70	0	80	0
RE-20-03	70	0	80	0
RE-20-04	70	0	80	0
RE-21-00	70	0	80	0
RE-21-01	70	0	80	0
RE-21-02	70	0	80	0
RE-21-03	70	0	80	0
RE-21-04	70	0	80	0
RF-01-00	500	356.42	540	528
RF-01-01	250	1498.9	300	285
RF-01-02	750	0	1200	0
RF-01-03	750	0	1200	0
RF-01-04	750	0	1200	0
RF-02-00	500	348.12	540	514
RF-02-01	250	344	300	147
RF-02-02	750	0	1200	0
RF-02-03	750	0	1200	0
RF-02-04	750	0	1200	0
RF-03-00	500	309.51	540	508
RF-03-01	250	121.06	300	248
RF-03-02	750	0	1200	0
RF-03-03	750	0	1200	0
RF-03-04	750	0	1200	0
RF-04-00	500	345.73	540	449
RF-04-01	250	83.3	300	263
RF-04-02	750	0	1200	0
RF-04-03	750	0	1200	0
RF-04-04	750	0	1200	0
RF-05-00	500	381.15	540	495
RF-05-01	250	95.9	300	274
RF-05-02	750	0	1200	0
RF-05-03	750	0	1200	0
RF-05-04	750	0	1200	0
RF-06-00	500	305.15	540	505
RF-06-01	250	97.55	300	271
RF-06-02	750	0	1200	0
RF-06-03	750	0	1200	0
RF-06-04	750	0	1200	0
RF-07-00	500	361.5	540	477
RF-07-01	250	139.1	300	226
RF-07-02	750	0	1200	0
RF-07-03	750	0	1200	0
RF-07-04	750	0	1200	0
RF-08-00	500	384.5	540	539
RF-08-01	250	210.44	300	289
RF-08-02	750	0	1200	0
RF-08-03	750	0	1200	0
RF-08-04	750	0	1200	0
RF-09-00	500	231	540	462
RF-09-01	250	101.4	300	266
RF-09-02	750	0	1200	0
RF-09-03	750	0	1200	0
RF-09-04	750	0	1200	0
RF-10-00	500	482.8	540	536
RF-10-01	250	148.68	300	289
RF-10-02	750	0	1200	0
RF-10-03	750	0	1200	0
RF-10-04	750	0	1200	0
RF-11-00	500	334.4	540	504
RF-11-01	250	67.5	300	169
RF-11-02	750	0	1200	0
RF-11-03	750	0	1200	0
RF-11-04	750	0	1200	0
RF-12-00	500	242	540	484
RF-12-01	250	133.6	300	290
RF-12-02	750	0	1200	0
RF-12-03	750	0	1200	0
RF-12-04	750	0	1200	0
RF-13-00	500	281.05	540	533
RF-13-01	250	176.56	300	274
RF-13-02	750	0	1200	0
RF-13-03	750	0	1200	0
RF-13-04	750	0	1200	0
RF-14-00	500	0	540	456
RF-14-01	250	123.41	300	247
RF-14-02	750	0	1200	0
RF-14-03	750	0	1200	0
RF-14-04	750	0	1200	0
RF-15-00	500	0	540	457
RF-15-01	250	104.97	300	181
RF-15-02	750	0	1200	0
RF-15-03	750	0	1200	0
RF-15-04	750	0	1200	0
RF-16-00	500	104.01	540	539
RF-16-01	250	172.29	300	282
RF-16-02	750	0	1200	0
RF-16-03	750	0	1200	0
RF-16-04	750	0	1200	0
RF-17-00	500	523.6	540	476
RF-17-01	250	100.3	300	206
RF-17-02	750	0	1200	0
RF-17-03	750	0	1200	0
RF-17-04	750	0	1200	0
RF-18-00	500	338.2	540	512
RF-18-01	250	76.89	300	183
RF-18-02	750	0	1200	0
RF-18-03	750	0	1200	0
RF-18-04	750	0	1200	0
RF-19-00	500	213.29	540	538
RF-19-01	250	152.25	300	238
RF-19-02	750	0	1200	0
RF-19-03	750	0	1200	0
RF-19-04	750	0	1200	0
RF-20-00	70	0	80	0
RF-20-01	70	0	80	0
RF-20-02	70	0	80	0
RF-20-03	70	0	80	0
RF-20-04	70	0	80	0
RF-21-00	70	0	80	0
RF-21-01	70	0	80	0
RF-21-02	70	0	80	0
RF-21-03	70	0	80	0
RF-21-04	70	0	80	0
RG-01-00	500	277.55	540	475
RG-01-01	250	144.76	300	236
RG-01-02	750	0	1200	0
RG-01-03	750	0	1200	0
RG-01-04	750	0	1200	0
RG-02-00	500	306.53	540	469
RG-02-01	250	186.18	300	246
RG-02-02	750	0	1200	0
RG-02-03	750	0	1200	0
RG-02-04	750	0	1200	0
RG-03-00	500	376.56	540	521
RG-03-01	250	83.66	300	174
RG-03-02	750	0	1200	0
RG-03-03	750	0	1200	0
RG-03-04	750	0	1200	0
RG-04-00	500	310.38	540	462
RG-04-01	250	199.31	300	300
RG-04-02	750	0	1200	0
RG-04-03	750	0	1200	0
RG-04-04	750	0	1200	0
RG-05-00	500	366.42	540	538
RG-05-01	250	150.5	300	226
RG-05-02	750	0	1200	0
RG-05-03	750	0	1200	0
RG-05-04	750	0	1200	0
RG-06-00	500	341.95	540	539
RG-06-01	250	85.86	300	133
RG-06-02	750	0	1200	0
RG-06-03	750	0	1200	0
RG-06-04	750	0	1200	0
RG-07-00	500	339.93	540	503
RG-07-01	250	50.8	300	108
RG-07-02	750	0	1200	0
RG-07-03	750	0	1200	0
RG-07-04	750	0	1200	0
RG-08-00	500	213.42	540	537
RG-08-01	250	67	300	134
RG-08-02	750	0	1200	0
RG-08-03	750	0	1200	0
RG-08-04	750	0	1200	0
RG-09-00	500	413.49	540	537
RG-09-01	250	87.04	300	155
RG-09-02	750	0	1200	0
RG-09-03	750	0	1200	0
RG-09-04	750	0	1200	0
RG-10-00	500	213.11	540	444
RG-10-01	250	143.62	300	261
RG-10-02	750	0	1200	0
RG-10-03	750	0	1200	0
RG-10-04	750	0	1200	0
RG-11-00	500	272.31	540	518
RG-11-01	250	105.72	300	204
RG-11-02	750	0	1200	0
RG-11-03	750	0	1200	0
RG-11-04	750	0	1200	0
RG-12-00	500	374.99	540	487
RG-12-01	250	135.26	300	213
RG-12-02	750	0	1200	0
RG-12-03	750	0	1200	0
RG-12-04	750	0	1200	0
RG-13-00	500	254.75	540	535
RG-13-01	250	184.29	300	271
RG-13-02	750	0	1200	0
RG-13-03	750	0	1200	0
RG-13-04	750	0	1200	0
RG-14-00	500	261.5	540	523
RG-14-01	250	187	300	233
RG-14-02	750	0	1200	0
RG-14-03	750	0	1200	0
RG-14-04	750	0	1200	0
RG-15-00	500	456.28	540	500
RG-15-01	250	87.48	300	221
RG-15-02	750	0	1200	0
RG-15-03	750	0	1200	0
RG-15-04	750	0	1200	0
RG-16-00	500	365.75	540	475
RG-16-01	250	476.2	300	253
RG-16-02	750	0	1200	0
RG-16-03	750	0	1200	0
RG-16-04	750	0	1200	0
RG-17-00	500	376.71	540	525
RG-17-01	250	148.92	300	290
RG-17-02	750	0	1200	0
RG-17-03	750	0	1200	0
RG-17-04	750	0	1200	0
RG-18-00	500	358.82	540	466
RG-18-01	250	188.81	300	293
RG-18-02	750	0	1200	0
RG-18-03	750	0	1200	0
RG-18-04	750	0	1200	0
RG-19-00	500	405.79	540	527
RG-19-01	250	133.04	300	252
RG-19-02	750	0	1200	0
RG-19-03	750	0	1200	0
RG-19-04	750	0	1200	0
RG-20-00	70	0	80	0
RG-20-01	70	0	80	0
RG-20-02	70	0	80	0
RG-20-03	70	0	80	0
RG-20-04	70	0	80	0
RG-21-00	70	0	80	0
RG-21-01	70	0	80	0
RG-21-02	70	0	80	0
RG-21-03	70	0	80	0
RG-21-04	70	0	80	0
RH-01-00	500	392.7	540	510
RH-01-01	250	143.64	300	285
RH-01-02	750	0	1200	0
RH-01-03	750	0	1200	0
RH-01-04	750	0	1200	0
RH-02-00	500	345.73	540	449
RH-02-01	250	166.77	300	298
RH-02-02	750	0	1200	0
RH-02-03	750	0	1200	0
RH-02-04	750	0	1200	0
RH-03-00	500	336.74	540	512
RH-03-01	250	208.7	300	286
RH-03-02	750	0	1200	0
RH-03-03	750	0	1200	0
RH-03-04	750	0	1200	0
RH-04-00	500	374.83	540	531
RH-04-01	250	160.38	300	297
RH-04-02	750	0	1200	0
RH-04-03	750	0	1200	0
RH-04-04	750	0	1200	0
RH-05-00	500	62.64	540	452
RH-05-01	250	182.76	300	294
RH-05-02	750	0	1200	0
RH-05-03	750	0	1200	0
RH-05-04	750	0	1200	0
RH-06-00	500	318.4	540	461
RH-06-01	250	184.03	300	299
RH-06-02	750	0	1200	0
RH-06-03	750	0	1200	0
RH-06-04	750	0	1200	0
RH-07-00	500	0	540	483
RH-07-01	250	192.5	300	298
RH-07-02	750	0	1200	0
RH-07-03	750	0	1200	0
RH-07-04	750	0	1200	0
RH-08-00	500	286.74	540	531
RH-08-01	250	108.3	300	232
RH-08-02	750	0	1200	0
RH-08-03	750	0	1200	0
RH-08-04	750	0	1200	0
RH-09-00	500	280.26	540	519
RH-09-01	250	64.2	300	223
RH-09-02	750	0	1200	0
RH-09-03	750	0	1200	0
RH-09-04	750	0	1200	0
RH-10-00	500	376.23	540	537
RH-10-01	250	25	300	177
RH-10-02	750	0	1200	0
RH-10-03	750	0	1200	0
RH-10-04	750	0	1200	0
RH-11-00	500	379.46	540	540
RH-11-01	250	31	300	160
RH-11-02	750	0	1200	0
RH-11-03	750	0	1200	0
RH-11-04	750	0	1200	0
RH-12-00	500	270	540	500
RH-12-01	250	0	300	212
RH-12-02	750	0	1200	0
RH-12-03	750	0	1200	0
RH-12-04	750	0	1200	0
RH-13-00	500	352.66	540	458
RH-13-01	250	0	300	281
RH-13-02	750	0	1200	0
RH-13-03	750	0	1200	0
RH-13-04	750	0	1200	0
RH-14-00	500	344.19	540	447
RH-14-01	250	0	300	270
RH-14-02	750	0	1200	0
RH-14-03	750	0	1200	0
RH-14-04	750	0	1200	0
RH-15-00	500	251.64	540	466
RH-15-01	250	0	300	221
RH-15-02	750	0	1200	0
RH-15-03	750	0	1200	0
RH-15-04	750	0	1200	0
RH-16-00	500	349.93	540	536
RH-16-01	250	83.54	300	190
RH-16-02	750	0	1200	0
RH-16-03	750	0	1200	0
RH-16-04	750	0	1200	0
RH-17-00	500	365.71	540	509
RH-17-01	250	114.92	300	200
RH-17-02	750	0	1200	0
RH-17-03	750	0	1200	0
RH-17-04	750	0	1200	0
RH-18-00	500	328.61	540	465
RH-18-01	250	101.7	300	164
RH-18-02	750	0	1200	0
RH-18-03	750	0	1200	0
RH-18-04	750	0	1200	0
RH-19-00	500	333.99	540	538
RH-19-01	250	197.89	300	257
RH-19-02	750	0	1200	0
RH-19-03	750	0	1200	0
RH-19-04	750	0	1200	0
RH-20-00	70	0	80	0
RH-20-01	70	0	80	0
RH-20-02	70	0	80	0
RH-20-03	70	0	80	0
RH-20-04	70	0	80	0
RH-21-00	70	0	80	0
RH-21-01	70	0	80	0
RH-21-02	70	0	80	0
RH-21-03	70	0	80	0
RH-21-04	70	0	80	0
RI-01-00	500	201.12	540	525
RI-01-01	250	212.04	300	288
RI-01-02	750	0	1200	0
RI-01-03	750	0	1200	0
RI-01-04	750	0	1200	0
RI-02-00	500	311.22	540	516
RI-02-01	250	104.89	300	207
RI-02-02	750	0	1200	0
RI-02-03	750	0	1200	0
RI-02-04	750	0	1200	0
RI-03-00	500	158.4	540	534
RI-03-01	250	116.8	300	248
RI-03-02	750	0	1200	0
RI-03-03	750	0	1200	0
RI-03-04	750	0	1200	0
RI-04-00	500	147.5	540	480
RI-04-01	250	83.85	300	192
RI-04-02	750	0	1200	0
RI-04-03	750	0	1200	0
RI-04-04	750	0	1200	0
RI-05-00	500	139.85	540	540
RI-05-01	250	64.15	300	232
RI-05-02	750	0	1200	0
RI-05-03	750	0	1200	0
RI-05-04	750	0	1200	0
RI-06-00	500	176.33	540	526
RI-06-01	250	93.25	300	211
RI-06-02	750	0	1200	0
RI-06-03	750	0	1200	0
RI-06-04	750	0	1200	0
RI-07-00	500	0	540	457
RI-07-01	250	116.15	300	235
RI-07-02	750	0	1200	0
RI-07-03	750	0	1200	0
RI-07-04	750	0	1200	0
RI-08-00	500	57.24	540	539
RI-08-01	250	0	300	203
RI-08-02	750	0	1200	0
RI-08-03	750	0	1200	0
RI-08-04	750	0	1200	0
RI-09-00	500	0	540	534
RI-09-01	250	166.06	300	299
RI-09-02	750	0	1200	0
RI-09-03	750	0	1200	0
RI-09-04	750	0	1200	0
RI-10-00	500	63.18	540	511
RI-10-01	250	180.47	300	298
RI-10-02	750	0	1200	0
RI-10-03	750	0	1200	0
RI-10-04	750	0	1200	0
RI-11-00	500	331.21	540	532
RI-11-01	250	166.75	300	278
RI-11-02	750	0	1200	0
RI-11-03	750	0	1200	0
RI-11-04	750	0	1200	0
RI-12-00	500	85.47	540	465
RI-12-01	250	171.2	300	298
RI-12-02	750	0	1200	0
RI-12-03	750	0	1200	0
RI-12-04	750	0	1200	0
RI-13-00	500	234.42	540	540
RI-13-01	250	159.38	300	298
RI-13-02	750	0	1200	0
RI-13-03	750	0	1200	0
RI-13-04	750	0	1200	0
RI-14-00	500	285.12	540	528
RI-14-01	250	220.92	300	297
RI-14-02	750	0	1200	0
RI-14-03	750	0	1200	0
RI-14-04	750	0	1200	0
RI-15-00	500	391.16	540	508
RI-15-01	250	185.14	300	296
RI-15-02	750	0	1200	0
RI-15-03	750	0	1200	0
RI-15-04	750	0	1200	0
RI-16-00	500	388.85	540	505
RI-16-01	250	172.72	300	298
RI-16-02	750	0	1200	0
RI-16-03	750	0	1200	0
RI-16-04	750	0	1200	0
RI-17-00	500	405.79	540	527
RI-17-01	250	226.38	300	294
RI-17-02	750	0	1200	0
RI-17-03	750	0	1200	0
RI-17-04	750	0	1200	0
RI-18-00	500	405.02	540	526
RI-18-01	250	76.52	300	289
RI-18-02	750	0	1200	0
RI-18-03	750	0	1200	0
RI-18-04	750	0	1200	0
RI-19-00	500	389.62	540	506
RI-19-01	250	22.54	300	272
RI-19-02	750	0	1200	0
RI-19-03	750	0	1200	0
RI-19-04	750	0	1200	0
RI-20-00	70	0	80	0
RI-20-01	70	0	80	0
RI-20-02	70	0	80	0
RI-20-03	70	0	80	0
RI-20-04	70	0	80	0
RI-21-00	70	0	80	0
RI-21-01	70	0	80	0
RI-21-02	70	0	80	0
RI-21-03	70	0	80	0
RI-21-04	70	0	80	0
RJ-01-00	500	296.11	540	444
RJ-01-01	250	91.91	300	188
RJ-01-02	750	0	1200	0
RJ-01-03	750	0	1200	0
RJ-01-04	750	0	1200	0
RJ-02-00	500	241.92	540	448
RJ-02-01	250	78.54	300	184
RJ-02-02	750	0	1200	0
RJ-02-03	750	0	1200	0
RJ-02-04	750	0	1200	0
RJ-03-00	500	331.28	540	530
RJ-03-01	250	279.5	300	161
RJ-03-02	750	0	1200	0
RJ-03-03	750	0	1200	0
RJ-03-04	750	0	1200	0
RJ-04-00	500	368.48	540	512
RJ-04-01	250	0	300	203
RJ-04-02	750	0	1200	0
RJ-04-03	750	0	1200	0
RJ-04-04	750	0	1200	0
RJ-05-00	500	319.48	540	486
RJ-05-01	250	136.5	300	153
RJ-05-02	750	0	1200	0
RJ-05-03	750	0	1200	0
RJ-05-04	750	0	1200	0
RJ-06-00	500	355.6	540	532
RJ-06-01	250	129.97	300	257
RJ-06-02	750	0	1200	0
RJ-06-03	750	0	1200	0
RJ-06-04	750	0	1200	0
RJ-07-00	500	326.05	540	538
RJ-07-01	250	203.29	300	296
RJ-07-02	750	0	1200	0
RJ-07-03	750	0	1200	0
RJ-07-04	750	0	1200	0
RJ-08-00	500	342.65	540	445
RJ-08-01	250	191.6	300	298
RJ-08-02	750	0	1200	0
RJ-08-03	750	0	1200	0
RJ-08-04	750	0	1200	0
RJ-09-00	500	328.74	540	516
RJ-09-01	250	215.2	300	291
RJ-09-02	750	0	1200	0
RJ-09-03	750	0	1200	0
RJ-09-04	750	0	1200	0
RJ-10-00	500	368.72	540	515
RJ-10-01	250	131.6	300	271
RJ-10-02	750	0	1200	0
RJ-10-03	750	0	1200	0
RJ-10-04	750	0	1200	0
RJ-11-00	500	294.54	540	512
RJ-11-01	250	163.3	300	253
RJ-11-02	750	0	1200	0
RJ-11-03	750	0	1200	0
RJ-11-04	750	0	1200	0
RJ-12-00	500	247.36	540	480
RJ-12-01	250	90.75	300	240
RJ-12-02	750	0	1200	0
RJ-12-03	750	0	1200	0
RJ-12-04	750	0	1200	0
RJ-13-00	500	543.84	540	525
RJ-13-01	250	206.99	300	286
RJ-13-02	750	0	1200	0
RJ-13-03	750	0	1200	0
RJ-13-04	750	0	1200	0
RJ-14-00	500	585.2	540	532
RJ-14-01	250	219.45	300	285
RJ-14-02	750	0	1200	0
RJ-14-03	750	0	1200	0
RJ-14-04	750	0	1200	0
RJ-15-00	500	440	540	531
RJ-15-01	250	230.23	300	299
RJ-15-02	750	0	1200	0
RJ-15-03	750	0	1200	0
RJ-15-04	750	0	1200	0
RJ-16-00	500	141.68	540	533
RJ-16-01	250	229.46	300	298
RJ-16-02	750	0	1200	0
RJ-16-03	750	0	1200	0
RJ-16-04	750	0	1200	0
RJ-17-00	500	413.49	540	537
RJ-17-01	250	177.87	300	289
RJ-17-02	750	0	1200	0
RJ-17-03	750	0	1200	0
RJ-17-04	750	0	1200	0
RJ-18-00	500	415.8	540	540
RJ-18-01	250	217.91	300	299
RJ-18-02	750	0	1200	0
RJ-18-03	750	0	1200	0
RJ-18-04	750	0	1200	0
RJ-19-00	500	411.95	540	535
RJ-19-01	250	123.97	300	289
RJ-19-02	750	0	1200	0
RJ-19-03	750	0	1200	0
RJ-19-04	750	0	1200	0
RJ-20-00	70	0	80	0
RJ-20-01	70	0	80	0
RJ-20-02	70	0	80	0
RJ-20-03	70	0	80	0
RJ-20-04	70	0	80	0
RJ-21-00	70	0	80	0
RJ-21-01	70	0	80	0
RJ-21-02	70	0	80	0
RJ-21-03	70	0	80	0
RJ-21-04	70	0	80	0
RK-01-00	500	371.14	540	482
RK-01-01	250	224.84	300	292
RK-01-02	750	0	1200	0
RK-01-03	750	0	1200	0
RK-01-04	750	0	1200	0
RK-02-00	500	375.76	540	488
RK-02-01	250	214.5	300	290
RK-02-02	750	0	1200	0
RK-02-03	750	0	1200	0
RK-02-04	750	0	1200	0
RK-03-00	500	357.28	540	464
RK-03-01	250	87.01	300	245
RK-03-02	750	0	1200	0
RK-03-03	750	0	1200	0
RK-03-04	750	0	1200	0
RK-04-00	500	294.86	540	526
RK-04-01	250	137.86	300	225
RK-04-02	750	0	1200	0
RK-04-03	750	0	1200	0
RK-04-04	750	0	1200	0
RK-05-00	500	179.41	540	539
RK-05-01	250	136.16	300	282
RK-05-02	750	0	1200	0
RK-05-03	750	0	1200	0
RK-05-04	750	0	1200	0
RK-06-00	500	0	540	485
RK-06-01	250	131	300	267
RK-06-02	750	0	1200	0
RK-06-03	750	0	1200	0
RK-06-04	750	0	1200	0
RK-07-00	500	369.6	540	480
RK-07-01	250	121.14	300	198
RK-07-02	750	0	1200	0
RK-07-03	750	0	1200	0
RK-07-04	750	0	1200	0
RK-08-00	500	359.09	540	520
RK-08-01	250	173.19	300	267
RK-08-02	750	0	1200	0
RK-08-03	750	0	1200	0
RK-08-04	750	0	1200	0
RK-09-00	500	256.5	540	513
RK-09-01	250	96.25	300	294
RK-09-02	750	0	1200	0
RK-09-03	750	0	1200	0
RK-09-04	750	0	1200	0
RK-10-00	500	0	540	499
RK-10-01	250	147.6	300	263
RK-10-02	750	0	1200	0
RK-10-03	750	0	1200	0
RK-10-04	750	0	1200	0
RK-11-00	500	255	540	510
RK-11-01	250	107.3	300	120
RK-11-02	750	0	1200	0
RK-11-03	750	0	1200	0
RK-11-04	750	0	1200	0
RK-12-00	500	304.29	540	513
RK-12-01	250	105.95	300	223
RK-12-02	750	0	1200	0
RK-12-03	750	0	1200	0
RK-12-04	750	0	1200	0
RK-13-00	500	348.81	540	453
RK-13-01	250	611.68	300	297
RK-13-02	750	0	1200	0
RK-13-03	750	0	1200	0
RK-13-04	750	0	1200	0
RK-14-00	500	415.03	540	539
RK-14-01	250	184.36	300	299
RK-14-02	750	0	1200	0
RK-14-03	750	0	1200	0
RK-14-04	750	0	1200	0
RK-15-00	500	413.49	540	537
RK-15-01	250	176.64	300	291
RK-15-02	750	0	1200	0
RK-15-03	750	0	1200	0
RK-15-04	750	0	1200	0
RK-16-00	500	352.66	540	458
RK-16-01	250	157.94	300	300
RK-16-02	750	0	1200	0
RK-16-03	750	0	1200	0
RK-16-04	750	0	1200	0
RK-17-00	500	108.48	540	537
RK-17-01	250	112.6	300	299
RK-17-02	750	0	1200	0
RK-17-03	750	0	1200	0
RK-17-04	750	0	1200	0
RK-18-00	500	298.62	540	444
RK-18-01	250	174.83	300	290
RK-18-02	750	0	1200	0
RK-18-03	750	0	1200	0
RK-18-04	750	0	1200	0
RK-19-00	500	344.14	540	478
RK-19-01	250	183.85	300	296
RK-19-02	750	0	1200	0
RK-19-03	750	0	1200	0
RK-19-04	750	0	1200	0
RK-20-00	70	0	80	0
RK-20-01	70	0	80	0
RK-20-02	70	0	80	0
RK-20-03	70	0	80	0
RK-20-04	70	0	80	0
RK-21-00	70	0	80	0
RK-21-01	70	0	80	0
RK-21-02	70	0	80	0
RK-21-03	70	0	80	0
RK-21-04	70	0	80	0
RL-01-00	500	391.16	540	508
RL-01-01	250	247.2	300	300
RL-01-02	750	0	1200	0
RL-01-03	750	0	1200	0
RL-01-04	750	0	1200	0
RL-02-00	500	363.58	540	537
RL-02-01	250	115.7	300	298
RL-02-02	750	0	1200	0
RL-02-03	750	0	1200	0
RL-02-04	750	0	1200	0
RL-03-00	500	403.48	540	524
RL-03-01	250	82.2	300	289
RL-03-02	750	0	1200	0
RL-03-03	750	0	1200	0
RL-03-04	750	0	1200	0
RL-04-00	500	289.82	540	490
RL-04-01	250	246.48	300	300
RL-04-02	750	0	1200	0
RL-04-03	750	0	1200	0
RL-04-04	750	0	1200	0
RL-05-00	500	395.01	540	513
RL-05-01	250	175.12	300	188
RL-05-02	750	0	1200	0
RL-05-03	750	0	1200	0
RL-05-04	750	0	1200	0
RL-06-00	500	402.71	540	523
RL-06-01	250	92.6	300	142
RL-06-02	750	0	1200	0
RL-06-03	750	0	1200	0
RL-06-04	750	0	1200	0
RL-07-00	500	336.84	540	496
RL-07-01	250	227.92	300	296
RL-07-02	750	0	1200	0
RL-07-03	750	0	1200	0
RL-07-04	750	0	1200	0
RL-08-00	500	379.99	540	538
RL-08-01	250	212.52	300	276
RL-08-02	750	0	1200	0
RL-08-03	750	0	1200	0
RL-08-04	750	0	1200	0
RL-09-00	500	408.87	540	531
RL-09-01	250	95.48	300	176
RL-09-02	750	0	1200	0
RL-09-03	750	0	1200	0
RL-09-04	750	0	1200	0
RL-10-00	500	309.04	540	505
RL-10-01	250	224.84	300	292
RL-10-02	750	0	1200	0
RL-10-03	750	0	1200	0
RL-10-04	750	0	1200	0
RL-11-00	500	230.11	540	463
RL-11-01	250	230.23	300	299
RL-11-02	750	0	1200	0
RL-11-03	750	0	1200	0
RL-11-04	750	0	1200	0
RL-12-00	500	386.54	540	502
RL-12-01	250	185.27	300	262
RL-12-02	750	0	1200	0
RL-12-03	750	0	1200	0
RL-12-04	750	0	1200	0
RL-13-00	500	363.61	540	523
RL-13-01	250	195.58	300	298
RL-13-02	750	0	1200	0
RL-13-03	750	0	1200	0
RL-13-04	750	0	1200	0
RL-14-00	500	323.71	540	508
RL-14-01	250	225.24	300	297
RL-14-02	750	0	1200	0
RL-14-03	750	0	1200	0
RL-14-04	750	0	1200	0
RL-15-00	500	365.48	540	509
RL-15-01	250	210.23	300	279
RL-15-02	750	0	1200	0
RL-15-03	750	0	1200	0
RL-15-04	750	0	1200	0
RL-16-00	500	279.68	540	528
RL-16-01	250	152.1	300	273
RL-16-02	750	0	1200	0
RL-16-03	750	0	1200	0
RL-16-04	750	0	1200	0
RL-17-00	500	321.09	540	524
RL-17-01	250	87.5	300	175
RL-17-02	750	0	1200	0
RL-17-03	750	0	1200	0
RL-17-04	750	0	1200	0
RL-18-00	500	341.17	540	536
RL-18-01	250	0	300	0
RL-18-02	750	0	1200	0
RL-18-03	750	0	1200	0
RL-18-04	750	0	1200	0
RL-19-00	500	265.65	540	480
RL-19-01	250	0	300	0
RL-19-02	750	0	1200	0
RL-19-03	750	0	1200	0
RL-19-04	750	0	1200	0
RL-20-00	70	0	80	0
RL-20-01	70	0	80	0
RL-20-02	70	0	80	0
RL-20-03	70	0	80	0
RL-20-04	70	0	80	0
RL-21-00	70	0	80	0
RL-21-01	70	0	80	0
RL-21-02	70	0	80	0
RL-21-03	70	0	80	0
RL-21-04	70	0	80	0
AT-01-00	500	361.13	540	469
AT-01-01	250	0	300	0
AT-01-02	750	0	1200	0
AT-01-03	750	0	1200	0
AT-01-04	750	0	1200	0
AT-02-00	500	253.33	540	540
AT-02-01	250	0	300	0
AT-02-02	750	0	1200	0
AT-02-03	750	0	1200	0
AT-02-04	750	0	1200	0
AT-03-00	500	414.26	540	538
AT-03-01	250	0	300	0
AT-03-02	750	0	1200	0
AT-03-03	750	0	1200	0
AT-03-04	750	0	1200	0
AT-04-00	500	401.17	540	521
AT-04-01	250	0	300	0
AT-04-02	750	0	1200	0
AT-04-03	750	0	1200	0
AT-04-04	750	0	1200	0
AT-05-00	500	344.96	540	448
AT-05-01	250	0	300	0
AT-05-02	750	0	1200	0
AT-05-03	750	0	1200	0
AT-05-04	750	0	1200	0
AT-06-00	500	399.63	540	519
AT-06-01	250	0	300	0
AT-06-02	750	0	1200	0
AT-06-03	750	0	1200	0
AT-06-04	750	0	1200	0
AT-07-00	500	154	540	325
AT-07-01	250	0	300	0
AT-07-02	750	0	1200	0
AT-07-03	750	0	1200	0
AT-07-04	750	0	1200	0
AT-08-00	500	0	540	0
AT-08-01	250	0	300	0
AT-08-02	750	0	1200	0
AT-08-03	750	0	1200	0
AT-08-04	750	0	1200	0
AT-09	5000	1851.12	3600	3428
AT-10	5000	779.22	3600	3410
AT-11	5000	1618.24	3600	3120
AT-12	5000	460.95	3600	2717
AT-13	5000	939.05	3600	2683
AT-14	5000	1200.15	3600	3429
AT-15	5000	841.75	3600	2405
AT-16	5000	849.8	3600	2428
AT-17	5000	0	3600	3206
AT-18	5000	0	3600	3398
AT-19	5000	0	3600	3419
AT-20	70	0	80	0
AT-21	70	0	80	0
AT-22	5000	0	3600	3290
AT-23	5000	1015.63	3600	3535
AT-24	5000	1936.55	3600	3229
AT-25	5000	1636.25	3600	2125
AT-26-00	70	132.35	80	80
AT-26-01	70	49.74	80	80
AT-26-02	70	305.66	80	80
AT-26-03	70	41.04	80	80
AT-26-04	70	880.51	80	80
AT-27-00	70	375.44	80	80
AT-27-01	70	72.62	80	75
AT-27-02	70	12.43	80	80
AT-27-03	70	0	80	80
AT-27-04	70	19.88	80	80
AT-28-00	70	400.5	80	80
AT-28-01	70	191.99	80	80
AT-28-02	70	296.67	80	80
AT-28-03	70	44.02	80	80
AT-28-04	70	350.3	80	77
AT-29-00	70	172	80	80
AT-29-01	70	546.05	80	80
AT-29-02	70	40.74	80	80
AT-29-03	70	477.15	80	80
AT-29-04	70	573.8	80	80
AT-30	5000	1725.57	3600	2241
AT-31	5000	0	3600	0
AT-32	5000	0	3600	0
AT-33	5000	0	3600	0
\.


--
-- TOC entry 4903 (class 0 OID 25323)
-- Dependencies: 227
-- Data for Name: order_picking_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_picking_details (id, product_id, product_name, expected_amount, picked_amount, picked_location, picked_by, scanned_ean, picked_time, status, order_id, picked_date, expected_ean, product_date) FROM stdin;
11	1417	IMBIOROWICZ MIУD PITNY TRУJNIAK MEADNIGHT BUT. 0,5 L	7	7	RE-01-01	KS	1	18:51:21+02	done	ZO/003/05/2025	2025-05-27	\N	\N
12	1837	MOCZYBRODA BRAIN SMASHER BUT 0,5 L	9	9	RG-11-01	KS	1	18:51:42+02	done	ZO/003/05/2025	2025-05-27	\N	\N
13	4902	WRКЇEL MILK ME BUT. 0,5 L	15	15	RL-08-01	KS	1	18:52:05+02	done	ZO/003/05/2025	2025-05-27	\N	\N
14	1611	LINDEMANS FRAMBOISE BUT. 0,25 L	9	9	AT-13	KS	1	18:52:20+02	done	ZO/003/05/2025	2025-05-27	\N	\N
15	1272	ED RED TIKKA MASALA Z BRҐZ. RYЇEM - KURCZAK	14	14	AT-27-04	KS	1	18:55:44+02	done	ZO/003/05/2025	2025-05-27	\N	\N
16	642	LINDEMANS FRAMBOISE BUT. 0,25 L	9	9	RI-04-04	KS	1	18:55:55+02	done	ZO/003/05/2025	2025-05-27	\N	\N
17	601	IMBIOROWICZ MIУD PITNY TRУJNIAK MEADNIGHT BUT. 0,5 L	7	7	RI-04-04	KS	1	18:56:12+02	done	ZO/003/05/2025	2025-05-27	\N	\N
19	1417	IMBIOROWICZ MIУD PITNY TRУJNIAK MEADNIGHT BUT. 0,5 L	7	7	RE-01-01	KS	1	19:36:40+02	done	ZO/003/05/2025	2025-05-27	\N	\N
20	1837	MOCZYBRODA BRAIN SMASHER BUT 0,5 L	9	9	RG-11-01	KS	1	19:36:54+02	done	ZO/003/05/2025	2025-05-27	\N	\N
21	4902	WRКЇEL MILK ME BUT. 0,5 L	15	15	RL-08-01	KS	1	19:37:06+02	done	ZO/003/05/2025	2025-05-27	\N	\N
22	1611	LINDEMANS FRAMBOISE BUT. 0,25 L	9	9	AT-13	KS	1	19:37:15+02	done	ZO/003/05/2025	2025-05-27	\N	\N
23	1272	ED RED TIKKA MASALA Z BRҐZ. RYЇEM - KURCZAK	14	14	AT-27-04	KS	1	19:37:28+02	done	ZO/003/05/2025	2025-05-27	\N	\N
24	642	LINDEMANS FRAMBOISE BUT. 0,25 L	9	9	RI-04-04	KS	1	19:37:37+02	done	ZO/003/05/2025	2025-05-27	\N	\N
25	601	IMBIOROWICZ MIУD PITNY TRУJNIAK MEADNIGHT BUT. 0,5 L	7	7	RI-04-04	KS	1	19:38:23+02	done	ZO/003/05/2025	2025-05-27	\N	\N
26	1417	IMBIOROWICZ MIУD PITNY TRУJNIAK MEADNIGHT BUT. 0,5 L	7	7	RE-01-01	KS	1	19:53:40+02	done	ZO/003/05/2025	2025-05-27	\N	\N
27	1837	MOCZYBRODA BRAIN SMASHER BUT 0,5 L	9	9	RG-11-01	KS	1	19:53:49+02	done	ZO/003/05/2025	2025-05-27	\N	\N
28	4902	WRКЇEL MILK ME BUT. 0,5 L	15	15	RL-08-01	KS	1	19:54:01+02	done	ZO/003/05/2025	2025-05-27	\N	\N
29	1611	LINDEMANS FRAMBOISE BUT. 0,25 L	9	9	AT-13	KS	1	19:54:09+02	done	ZO/003/05/2025	2025-05-27	\N	\N
30	1272	ED RED TIKKA MASALA Z BRҐZ. RYЇEM - KURCZAK	14	14	AT-27-04	KS	1	19:54:23+02	done	ZO/003/05/2025	2025-05-27	\N	\N
31	1440	JAN OLBRACHT KORD JACK WHISKEY BARREL AGED BUT. 0,37 L	8	8	RE-02-01	KS	5902627012822	19:33:46+02	done	ZO-002-06-2025	2025-07-02	\N	\N
32	4717	MIKKELLER SPONTAN TRIPPLE CHERRY 2020 BUT. 0,375 L	11	11	RG-09-01	KS	5704255121095	19:39:48+02	done	ZO-002-06-2025	2025-07-02	\N	\N
33	1825	MIЈOSЈAW SOSNOWE APA BUT. 0,5 L	8	8	RG-13-00	KS	5901687910765	19:41:33+02	done	ZO-002-06-2025	2025-07-02	\N	\N
34	4836	SCHLENKERLA SZKLANKA WEIZEN 0,5 L	14	14	RJ-03-01	KS	5123456789848	19:43:27+02	done	ZO-002-06-2025	2025-07-02	\N	\N
35	4485	AFFLIGEM TRIPLE  BUT. 0,33 L	10	10	AT-26-00	KS	5410263925753	19:44:47+02	done	ZO-002-06-2025	2025-07-02	\N	\N
36	1694	PINTA Hazy Morning 12,0° keg 20 l	2	2	RA-20-02	KS	5123456789712	19:58:29+02	done	ZO-001-10-2025	2025-10-16	5123456789712	2024-12-09
37	2599	ZA MIASTEM POGODA DUCHA BUT. 0,5 L	12	12	RL-11-01	KS	5906874605073	20:04:00+02	done	ZO-001-10-2025	2025-10-16	5906874605073	2024-12-09
38	992	KOMES RUSSIAN IMPERIAL STOUT BUT. 0,5 L	9	9	AT-28-03	KS	5901687910840	20:06:21+02	done	ZO-001-10-2025	2025-10-16	5901687910840	2024-12-09
39	2039	ROCKMILL SOURLAND #1 PUSZKA 0,5 L	11	11	RJ-11-00	KS	5908291862725	20:53:00+02	done	ZO-002-10-2025	2025-10-16	5908291862725	2024-12-09
41	1697	PINTA Hop Selection - Simcoe can 0,5 l	1	1	RA-20-02	KS	5904165104786	12:44:04+02	done	ZO-003-10-2025	2025-10-17	5904165104786	2024-12-09
42	43	ALEBROWAR HERR AXOLOTL WITH SABRO & HBC472 HOPS BUT. 0,5 L	12	12	RA-04-01	KS	5907771343464	12:56:03+02	done	ZO-003-10-2025	2025-10-17	5907771343464	2024-12-09
43	1467	MONVIN KIELISZEK 0,1 L	13	13	RG-15-01	KS	5123456791449	12:57:05+02	done	ZO-003-10-2025	2025-10-17	5123456791449	2024-12-09
44	1867	PIWOTEKA CZAISZ BAZК: EARL GREY BUT. 0,5 L	7	7	RH-19-01	KS	5905669428095	20:23:58+01	done	ZO-001-12-2025	2025-12-05	5905669428095	2024-12-09
45	652	FUNKY FLUID CLOUDY PUSZKA 0,5 L	10	7	RA-03-04	KS	5907772092316	20:24:52+01	part	ZO-001-12-2025	2025-12-05	5907772092316	2024-12-09
46	652	FUNKY FLUID CLOUDY PUSZKA 0,5 L	10	3	RA-03-04	KS	5907772092316	20:27:51+01	done	ZO-001-12-2025	2025-12-05	5907772092316	2024-12-09
\.


--
-- TOC entry 4895 (class 0 OID 25222)
-- Dependencies: 219
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (order_id, customer_id, amount, create_date, status, price, total_weight, pallet_used, shipping_date) FROM stdin;
ZO-001-06-2025	BSBEV	359	2025-06-26	Undone	5740.41	459.19	\N	2025-06-30
ZO-002-06-2025	LAZYK	51	2025-06-26	Undone	815.49	16.66	\N	2025-06-30
ZO-001-10-2025	HILAA	23	2025-10-16	Undone	367.77	16.17	\N	2025-11-12
ZO-002-10-2025	HUNGO	11	2025-10-16	Undone	175.89	5.94	\N	2025-11-12
ZO-003-10-2025	TOMSP	26	2025-10-16	done	415.74	9.24	\N	2025-11-12
ZO-004-10-2025	VINET	36	2025-10-17	Undone	575.64	19.36	\N	2025-11-12
ZO-005-10-2025	FOLIG	31	2025-10-17	Undone	495.69	16.46	\N	2025-11-12
ZO-001-12-2025	CENTC	17	2025-12-04	Undone	271.83	10.79	\N	2026-11-12
ZO-002-12-2025	CENTC	18	2025-12-09	Undone	287.82	13.86	\N	2025-12-15
ZO-003-12-2025	AROUT	10	2025-12-14	cancelled	159.90	\N	\N	\N
ZO-001	\N	\N	2025-12-15	\N	\N	\N	\N	\N
\.


--
-- TOC entry 4896 (class 0 OID 25232)
-- Dependencies: 220
-- Data for Name: orders_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders_details (order_id, product_name, code, amount, ean, price_netto, price_brutto, product_weight, total_price, id, status, collected_amount) FROM stdin;
ZO-001-10-2025	PINTA Hazy Morning 12,0° keg 20 l	PI Haz Mor keg 20	2	5123456789712	13.00	15.99	0.00	31.98	256	done	2
ZO-001-10-2025	ZA MIASTEM POGODA DUCHA BUT. 0,5 L	ZAM POG	12	5906874605073	13.00	15.99	0.77	191.88	258	done	12
ZO-001-10-2025	KOMES RUSSIAN IMPERIAL STOUT BUT. 0,5 L	MIЈ KOM RIS	9	5901687910840	13.00	15.99	0.77	143.91	257	done	9
ZO-002-10-2025	ROCKMILL SOURLAND #1 PUSZKA 0,5 L	ROCK_SOU_#1_PUSZ_500	11	5908291862725	13.00	15.99	0.54	175.89	259	done	11
ZO-004-10-2025	STRUISE / PIPEWORKS XENOPHON'S WINE BUT. 0,33 L	STRU XEN WIN 330	7	5425017200062	13.00	15.99	0.50	111.93	263	undone	0
ZO-004-10-2025	MALTGARDEN SUMMER MOVIE PUSZKA 0,5 L	MA_SUM_PUSZ_500	13	5907710943267	13.00	15.99	0.54	207.87	264	undone	0
ZO-004-10-2025	RODENBACH FRUITAGE BUT. 0,25 L	RODEN FRU 250	7	54125063	13.00	15.99	0.35	111.93	265	undone	0
ZO-004-10-2025	KASTEEL CUVEE DU CHATEAU BUT. 0,33 L	KAST CUV	2	5411081004811	13.00	15.99	0.50	31.98	266	undone	0
ZO-004-10-2025	KOMES BARLEY WINE BUT. 0,5 L	MIЈ KOM BAR	7	5902838990285	13.00	15.99	0.77	111.93	267	undone	0
ZO-001-12-2025	PIWOTEKA CZAISZ BAZК: EARL GREY BUT. 0,5 L	PIW_CZA_EAR_BUT_500	7	5905669428095	13.00	15.99	0.77	111.93	271	done	7
ZO-001-12-2025	FUNKY FLUID CLOUDY PUSZKA 0,5 L	FF CLO P	10	5907772092316	13.00	15.99	0.54	159.90	272	done	10
ZO-003-10-2025	PINTA Hop Selection - Simcoe can 0,5 l	PI_HS_SIM_CAN_500	1	5904165104786	13.00	15.99	0.00	15.99	261	done	1
ZO-003-10-2025	ALEBROWAR HERR AXOLOTL WITH SABRO & HBC472 HOPS BUT. 0,5 L	ALE_HER_SAB_HBC_HOP_BUT_500	12	5907771343464	13.00	15.99	0.77	191.88	262	done	12
ZO-003-10-2025	MONVIN KIELISZEK 0,1 L	MON_KIEL_100	13	5123456791449	13.00	15.99	0.00	207.87	260	done	13
ZO-005-10-2025	FUNKY FLUID WATCH YA SELF PUSZKA 0,5 L	FF_WAT_PUSZ_500	15	5903999514556	13.00	15.99	0.54	239.85	268	undone	0
ZO-005-10-2025	SMYKAN CYDR STARY SAD BUT. 0,33 L	SMYK STA	7	5905669332101	13.00	15.99	0.50	111.93	269	undone	0
ZO-005-10-2025	KASTEEL ROUGE PUSZKA 0,5 L	KAST ROU P	9	5411081006112	13.00	15.99	0.54	143.91	270	undone	0
ZO-002-12-2025	WRКЇEL MALTIC STORM BUFFALO TRACE BUT. 0,5 L	WR_MAL_BUF_BA_BUT_500	7	5904181970303	13.00	15.99	0.77	111.93	283	undone	0
ZO-002-12-2025	STAROPOLSKIE NIEMDЈE ANANASOWE BUT. 0,5 L	STAR NIE ANA	11	5903021503350	13.00	15.99	0.77	175.89	284	undone	0
ZO-001-06-2025	BOON FARO BUT. 0,25 L	BOON FAR 250	7	5412783054012	13.00	15.99	0.35	111.93	211	undone	0
ZO-001-06-2025	ZA MIASTEM LETNIA PRZYGODA BUT. 0,5 L	ZAM LET	9	5906874605103	13.00	15.99	0.77	143.91	212	undone	0
ZO-001-06-2025	3 FONTEINEN KRYSZTAЈOWY KIELISZEK ZENNE 0,645 L	KAT06720	9	5123456791154	13.00	15.99	0.00	143.91	213	undone	0
ZO-001-06-2025	VERHAEGHE CHOCOLATE CHERRY DUCHESSE DE BOURGOGNE BUT. 0,33 L	VER DUCH CHO CHE 330	9	5411364151928	13.00	15.99	0.50	143.91	214	undone	0
ZO-001-06-2025	FUNKY FLUID KALIMERA PUSZKA 0,5 L	FF_KAL_PUSZ_500	8	5903999514631	13.00	15.99	0.54	127.92	215	undone	0
ZO-001-06-2025	GOЊCISZEWO SZEWC BUT. 0,5 L	GO_SZEW_BUT_500	7	5903364108991	13.00	15.99	0.77	111.93	216	undone	0
ZO-001-06-2025	CHIMAY KIELICH W PUDEЈKU 0,33 L	KAT06696	10	5123456791185	13.00	15.99	0.00	159.90	217	undone	0
ZO-001-06-2025	MAGIC ROAD (EVERGREEN PRETTY)3 PUSZKA 0,5 L	MR_EVE_PRE3_PUSZ_500	11	5905204130773	13.00	15.99	0.54	175.89	218	undone	0
ZO-001-06-2025	TRYBUNAЈ PILS BUT. 0,5 L	TRY_PIL_BUT_500	12	5905689308124	13.00	15.99	0.77	191.88	219	undone	0
ZO-001-06-2025	STAROPOLSKIE KULTOWE BEZ GLUTENU MIODOWE BUT. 0,5 L	STAR KUL BEZ MIO	7	5903021500625	13.00	15.99	0.77	111.93	220	undone	0
ZO-001-06-2025	FUNKY FLUID EVERYDAY BUT. 0,5 L	FF EVE	14	5906395560240	13.00	15.99	0.77	223.86	221	undone	0
ZO-001-06-2025	CIESZYN LAGER BUT. 0,5 L	CIE LAG	6	5905279156005	13.00	15.99	0.77	95.94	222	undone	0
ZO-001-06-2025	DE STRUISE DARK HORSE SOUR ALE BUT. 0,75 L	DE STRU DAR HORS 750	8	5425017002758	13.00	15.99	1.10	127.92	223	undone	0
ZO-001-06-2025	MOCZYBRODA BERRYLICIOUS DELIGHT PUSZKA 0,5 L	MO_BER_PUSZ_500	13	5904673801085	13.00	15.99	0.54	207.87	224	undone	0
ZO-001-06-2025	TRZECH KUMPLI AMERICAN BEAUTY KEG 30 L	TR AME K	5	5123456789457	13.00	15.99	32.00	79.95	225	undone	0
ZO-001-06-2025	ED RED KONSERWA CHILI SIN CARNE	ED CHI SIN	5	5904083584059	13.00	15.99	0.00	79.95	226	undone	0
ZO-001-06-2025	MALTGARDEN BEAUTY IS POWER PUSZKA 0,5 L	MA_BEA_POW_PUSZ_500	5	5904050721951	13.00	15.99	0.54	79.95	227	undone	0
ZO-001-06-2025	LINDEMANS CASSIS BUT. 0,25 L	LIND CAS 250	12	5411223100555	13.00	15.99	0.35	191.88	228	undone	0
ZO-001-06-2025	CIESZYN BEZALKOHOLOWY LAGER BUT. 0,5 L	CIE BEZ LAG	11	5905279156814	13.00	15.99	0.77	175.89	229	undone	0
ZO-001-06-2025	TRZECH KUMPLI SZKLANKA NONIC 0,5 L	TR SZK NON	2	5123456791265	13.00	15.99	0.00	31.98	230	undone	0
ZO-001-06-2025	ZIEMIA OBIECANA BANIALUKI PUSZKA 0,5 L	ZO_BAN_PUSZ_500	11	5905186484666	13.00	15.99	0.54	175.89	231	undone	0
ZO-001-06-2025	DEER BEAR KAME HAME KEG 30 L	DEER KAM K 30	2	5123456789116	13.00	15.99	32.00	31.98	232	undone	0
ZO-001-06-2025	KAZIMIERZ PILSIWKO BUT. 0,5 L	KAZ PIL	13	5906660570219	13.00	15.99	0.77	207.87	233	undone	0
ZO-001-06-2025	PINTA BARREL BREWING DIRECTION 30,0° BUT. 0,33 L	PBB_DIR_BUT_330	15	5904335577495	13.00	15.99	0.50	239.85	234	undone	0
ZO-001-06-2025	LA TRAPPE ISID`OR BUT. 0,75 L	TRAP IS 750	13	8711406136775	13.00	15.99	1.10	207.87	235	undone	0
ZO-001-06-2025	WESTMALLE TRIPEL BUT. 0,33 L	WESTMA TRI 330	14	5412343201337	13.00	15.99	0.50	223.86	236	undone	0
ZO-001-06-2025	SOWIE INDUKTOR BUT. 0,5 L	SOW_IND_BUT_500	12	5907222560846	13.00	15.99	0.77	191.88	237	undone	0
ZO-001-06-2025	PINTA Bluza bordowa M	PINTA Blu bor M	7	5904165100573	13.00	15.99	0.00	111.93	238	undone	0
ZO-001-06-2025	GRYFUS SZKLANKA 0,5 L	GRY SZKL 5	9	5123456791395	13.00	15.99	0.00	143.91	239	undone	0
ZO-001-06-2025	ZA MIASTEM SPOTKANIE PRZYJACIУЈ BUT. 0,5 L	ZAM SPO	10	5906874605462	13.00	15.99	0.77	159.90	240	undone	0
ZO-001-06-2025	FUNKY FLUID ASHES & DIAMONDS RAISINS / FIGS / DATES BUT. 0,33 L	FF ASH RAI FIG	11	5903999511876	13.00	15.99	0.50	175.89	241	undone	0
ZO-001-06-2025	LINDEMANS FRAMBOISE BUT. 0,75 L	LIND FRA 750	14	5411223005249	13.00	15.99	1.10	223.86	242	undone	0
ZO-001-06-2025	KAZIMIERZ KWASIMIERZ BUT. 0,5 L	KAZ KWA	13	5906660570141	13.00	15.99	0.77	207.87	243	undone	0
ZO-001-06-2025	WESTVLETEREN 8 EXTRA BUT. 0,33 L	WESTVLET 8	5	5123456790132	13.00	15.99	0.50	79.95	244	undone	0
ZO-001-06-2025	TRYBUNAЈ PILS BUT. 0,5 L	TRY_PIL_BUT_500	6	5905689308124	13.00	15.99	0.77	95.94	245	undone	0
ZO-001-06-2025	O'HARA'S FREEBIRD IPA BUT. 0,5 L	Oha Fre Whi IPA	6	5391500601169	13.00	15.99	0.77	95.94	246	undone	0
ZO-001-06-2025	MARYENSZTADT YES WE CAN VOL. 5 PUSZKA 0,5 L	MAR_YES_WE_VOL5_PUSZ_500	10	5903424615919	13.00	15.99	0.54	159.90	247	undone	0
ZO-001-06-2025	GRIMBERGEN DESKA DEGUSTACYJNA	GRI DES DEG	12	5123456791350	13.00	15.99	0.00	191.88	248	undone	0
ZO-001-06-2025	TRZECH KUMPLI RUSTY KEG 30 L	TR RUS K	1	5123456789506	13.00	15.99	32.00	15.99	249	undone	0
ZO-001-06-2025	BROWARNY UNHOLY PUSZKA 0,5 L	BROWA_UNH_PUSZ_500	5	5905450141080	13.00	15.99	0.54	79.95	250	undone	0
ZO-002-06-2025	JAN OLBRACHT KORD JACK WHISKEY BARREL AGED BUT. 0,37 L	JO_KOR_JAC_BUT_370	8	5902627012822	13.00	15.99	0.00	127.92	251	done	8
ZO-002-06-2025	MIKKELLER SPONTAN TRIPPLE CHERRY 2020 BUT. 0,375 L	MIK SPON TRI CHE 2020 375	11	5704255121095	13.00	15.99	0.50	175.89	254	done	11
ZO-002-06-2025	MIЈOSЈAW SOSNOWE APA BUT. 0,5 L	MIЈ SOS	8	5901687910765	13.00	15.99	0.77	127.92	255	done	8
ZO-002-06-2025	SCHLENKERLA SZKLANKA WEIZEN 0,5 L	Sch szk Wei 0,5	14	5123456789848	13.00	15.99	0.00	223.86	253	done	14
ZO-002-06-2025	AFFLIGEM TRIPLE  BUT. 0,33 L	AFF TRI 330	10	5410263925753	13.00	15.99	0.50	159.90	252	done	10
\.


--
-- TOC entry 4897 (class 0 OID 25240)
-- Dependencies: 221
-- Data for Name: pallet_used; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pallet_used (pallet_name, code, price, pallet_weight) FROM stdin;
Europallet	EUR	60.00	25.00
Pallet class 2	PAL	20.00	20.00
HalfPallet	HPAL	30.00	9.50
QuaterPallet	QPAL	15.00	2.00
Industrial pallet	IPAL	50.00	28.00
\.


--
-- TOC entry 4901 (class 0 OID 25303)
-- Dependencies: 225
-- Data for Name: picks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.picks (id, user_id, order_id, product_name, amount, date, "time", product_id, location, ean) FROM stdin;
1	KS	ZO-002-06-2025	JAN OLBRACHT KORD JACK WHISKEY BARREL AGED BUT. 0,37 L	8	2025-07-02	19:33:46+02	1440	RE-02-01	\N
2	KS	ZO-002-06-2025	MIKKELLER SPONTAN TRIPPLE CHERRY 2020 BUT. 0,375 L	11	2025-07-02	19:39:48+02	4717	RG-09-01	\N
3	KS	ZO-002-06-2025	MIЈOSЈAW SOSNOWE APA BUT. 0,5 L	8	2025-07-02	19:41:33+02	1825	RG-13-00	\N
4	KS	ZO-002-06-2025	SCHLENKERLA SZKLANKA WEIZEN 0,5 L	14	2025-07-02	19:43:27+02	4836	RJ-03-01	\N
5	KS	ZO-002-06-2025	AFFLIGEM TRIPLE  BUT. 0,33 L	10	2025-07-02	19:44:47+02	4485	AT-26-00	\N
6	KS	ZO-001-10-2025	PINTA Hazy Morning 12,0° keg 20 l	2	2025-10-16	19:58:29+02	1694	RA-20-02	5123456789712
7	KS	ZO-001-10-2025	ZA MIASTEM POGODA DUCHA BUT. 0,5 L	12	2025-10-16	20:04:00+02	2599	RL-11-01	5906874605073
8	KS	ZO-001-10-2025	KOMES RUSSIAN IMPERIAL STOUT BUT. 0,5 L	9	2025-10-16	20:06:21+02	992	AT-28-03	5901687910840
9	KS	ZO-002-10-2025	ROCKMILL SOURLAND #1 PUSZKA 0,5 L	11	2025-10-16	20:53:00+02	2039	RJ-11-00	5908291862725
11	KS	ZO-003-10-2025	PINTA Hop Selection - Simcoe can 0,5 l	1	2025-10-17	12:44:04+02	1697	RA-20-02	5904165104786
12	KS	ZO-003-10-2025	ALEBROWAR HERR AXOLOTL WITH SABRO & HBC472 HOPS BUT. 0,5 L	12	2025-10-17	12:56:03+02	43	RA-04-01	5907771343464
13	KS	ZO-003-10-2025	MONVIN KIELISZEK 0,1 L	13	2025-10-17	12:57:05+02	1467	RG-15-01	5123456791449
15	KS	ZO-001-12-2025	PIWOTEKA CZAISZ BAZК: EARL GREY BUT. 0,5 L	7	2025-12-05	20:23:58+01	1867	RH-19-01	5905669428095
16	KS	ZO-001-12-2025	FUNKY FLUID CLOUDY PUSZKA 0,5 L	7	2025-12-05	20:24:52+01	652	RA-03-04	5907772092316
17	KS	ZO-001-12-2025	FUNKY FLUID CLOUDY PUSZKA 0,5 L	3	2025-12-05	20:27:51+01	652	RA-03-04	5907772092316
\.


--
-- TOC entry 4894 (class 0 OID 25205)
-- Dependencies: 218
-- Data for Name: product_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_details (product_name, code, ean, unit_weight, purchase_price, id) FROM stdin;
SMYKAN SZKLANKA 0,33 L	SMY_SZK_330	\N	0.00	10.00	1
ANCHOR SZKLANKA 1/2 PINT	Anc Szkl 1/2	5123456791391	0.00	10.00	2
CUVEE DES TROLLS KEG 5 L	CUVE TROL K 5 L	5411551010205	0.00	10.00	3
CHIMAY GOLD BUT. 0,75 L	CHIM GOL 750	5410908000425	1.10	10.00	4
MALTGARDEN PROTON BUT. 0,5 L	MALT PRO	590405072103	0.77	10.00	5
SVIJANY TACA	SVI_TACA	\N	0.00	10.00	6
KINGPIN FIDELITY PUSZKA 0,5 L	KING FID	5904730290777	0.54	10.00	7
ALEBROWAR BANA MAMA BUT. 0,5 L	ALE BAN	5907771342320	0.77	10.00	8
PIRAAT BUT. 0,33 L	PIR 330	5411663002600	0.50	10.00	9
BUTELKA ZWR SVIJANY 0,5 L	BUT SVI	\N	0.00	10.00	10
AMBER GRAND BUT. 0,5 L	AMB_GRA_BUT_500	5906591000816	0.77	10.00	11
BЈONIE KALINA MALINA BUT. 0,5 L	BЈO KAL	5908258856125	0.77	10.00	12
STU MOSTУW WAKE-UP CALL IMPERIAL BALTIC PORTER BBA (COCONUT & PALO SANTO) BUT. 0,33 L	STU_WAK_UP_CAL_BUT_330	5907614682712	0.50	10.00	13
LINDEMANS T-SHIRT MКSKI SZARY (M)	LIND_TSH_MКS_SZA_M	\N	0.00	10.00	14
PINTA Podkіadka korkowa Atak Chmielu 2011 Vintage	PINTA Pod kor ACH 2011	5903990622410	0.00	10.00	15
MALHEUR 12% BUT. 0,33 L	MALH 12% 330	5413970140396	0.50	10.00	16
BROKREACJA ALL BEERS MATTER - ENGLISH IPA KEG 30 L	BR_ALL_ENG_KEG_30	\N	32.00	10.00	17
PAX PILS SZKLANKA 0,25 L	296	5123456791033	0.00	10.00	18
BIRBANT SKULLY PUSZKA 0,5 L	BI_SKU_PUSZ_500	5904041703874	0.54	10.00	19
BOON KRIEK KIELISZEK 0,5 L	KAT06098	5123456791167	0.00	10.00	20
STU MOSTУW WRCLW LEKKI BUT. 0,5 L	STU WRC LEK	5907614682118	0.77	10.00	21
PINTA Beskidy Prawdziwe Ciemne 13,0° but. 0,5 l	PI_BES_PRA_CIE_BUT_500	5904730438995	0.00	10.00	22
P?HJALA DRAYMAN'S BLEND BUT. 0,33 L	POH DRA	4742976015096	0.50	10.00	23
MIЈOSЈAW ZESTAW MAKЈOWICZ 4 PIWA 0,5 L + LIMITOWANE SZKЈO	MIЈ ZES MAK	5902838991350	0.00	10.00	24
LA TRAPPE DUBBEL BUT. 0,75 L	TRAP DUB 750	8711406129777	1.10	10.00	25
STU MOSTУW WRCLW PILS BUT. 0,5 L	STU WRC PIL	5907614680473	0.77	10.00	26
BROKREACJA THE BARTENDER BUT. 0,5 L	BR_BAR_BUT_500	5904422197735	0.77	10.00	27
PINTA Collab PL: Brokreacja 15,0° can 0,5 l	PI_COLL_BRO_CAN_500	5904165104564	0.00	10.00	28
PETRUS POLO SHIRT XL	PET POL SHI XL	5123456791360	0.00	10.00	29
NEPOMUCEN RANGE PALE ALE BUT. 0,5 L	NE RAN	5905279959323	0.77	10.00	30
P?HJALA BALTIC PORTER DAY 2023 KEG 20 L	POH BAL POR DAY 20L	\N	21.50	10.00	31
O'HARA'S LEANN FOLLAIN PUSZKA 0,44 L	Oha Lea can	5391500602524	0.48	10.00	32
WIDAWA AUGUSTIAСSKIE BUT. 0,5 L	WID AUG	5907710904022	0.77	10.00	33
MOINETTE BLONDE BUT. 0,75 L	MOI BLO 750	5410702000119	1.10	10.00	34
RODENBACH ALEXANDER BUT. 0,33 L	RODEN ALEX 330	5410583802574	0.50	10.00	35
HOEGAARDEN KEG 6 L	HOEG K 6 L	5410228187615	0.00	10.00	36
ARTEZAN 11 BUT. 0,5 L	ART_11_BUT_500	5904708750746	0.77	10.00	37
ЈAСCUT CZARNA POLEWKA BUT. 0,5 L	LAN POL	5906395997008	0.77	10.00	38
PETRUS BLOND BUT. 0,33 L	PET BLO 330	875213000044	0.50	10.00	39
PINTA PORTERMASS Classic 30,0° keg 20 l	PI POR Cla keg 20	5123456789770	0.00	10.00	40
ST. FEUILLIEN SAISON BUT. 0,75 L	STF SAI 750	5412138317519	1.10	10.00	41
PINTA Hazy Morning 12,0° but. 0,5 l	PI Haz Mor	5904730438612	0.00	10.00	42
STAROPOLSKIE MY WAY DOPPEL WIZENBOCK BUT. 0,5 L	STAR_MY_WAY_DOP_WEI_BUT_500	5903021505774	0.77	10.00	43
PINTA Modern Drinking 15,0° keg 30 l	PI Mod keg 30	5123456789742	0.00	10.00	44
CIDER INN GЈКBSZY SMAK WYTRAWNY 4,4 %  BUT. 0,33 L	CID_INN_WYTR_BUT_330	5900468000138	0.50	10.00	45
BIRBANT RATIO PUSZKA 0,5 L	BI_RAT_PUSZ_500	5904041703829	0.54	10.00	46
VAL-DIEU BIERE DE NOЛL BUT. 0,33 L	VAL NOE 330	5413977000044	0.50	10.00	47
NEPOMUCEN SOUR MADNESS - BLACK PUSZKA 0,5 L	NE_SOU_MAD_BLA_PUSZ_500	5905701060016	0.54	10.00	48
PINTA Koszulka czarna L	PINTA Kos cza L	5904165100382	0.00	10.00	49
LA TRAPPE FLAGA	TRAP FLA	5123456791149	0.00	10.00	50
FUNKY FLUID ASHES & DIAMONDS COCONUT / COFFEE BUT. 0,33 L	FF ASH COC COF	5903999511852	0.50	10.00	51
RADUGA KINGDOM OF FRUITS BUT. 0,5 L	RAD_KIN_FRU_BUT_500	5902176772055	0.77	10.00	52
MAGIC ROAD SEASON FOR SAISON BUT. 0,5 L PROMOCJA (do 15.10.23)	MR_SEA_SAI_BUT_500_PROM	\N	0.00	10.00	53
CHYLICZKI CYDR CHOPIN BUT. 0,75 L	CHYL CHOP 750	5905279058200	1.10	10.00	54
ARTEZAN PACIFIC BUT. 0,5 L	ARTEZ PAC	5904730574051	0.77	10.00	55
ED RED KONSERWA CHILI SIN CARNE	ED CHI SIN	5904083584059	0.00	10.00	56
RECRAFT AMSTERDAM PILS PUSZKA 0,5 L	REC_AMS_PUSZ_500	5904730663748	0.54	10.00	57
ST. GUMMARUS DUBBEL KEG 20 L	STG DUB K 20	\N	21.50	10.00	58
MOCZYBRODA JACK MANGOW BUT. 0,5 L	MOCZY JAC	5903351761406	0.77	10.00	59
SOWIE JASNE PEЈNE BUT. 0,5 L	SOW_JAS_PEЈ_BUT_500	5907222560082	0.77	10.00	60
BIRBANT RED AIPA BUT. 0,5 L	BI RED	5903240620371	0.77	10.00	61
RACIBORSKIE ZESTAW BARLEY WINE + IMPERIAL PORTER + SZKЈO DEGUSTACYJNE	RAC_ZES_BAR_WIN_IMP_POR_SZK	5905249834025	0.00	10.00	62
BURLEY OAK MID LIFE RIGHTEOUS PUSZKA 0,473 L	BUR AOK MID LI 473	\N	0.53	10.00	63
ST. MARTIN TRIPLE 9% BUT. 0,33 L	STM TRI 9 330	5411065210856	0.50	10.00	64
NEPOMUCEN SPURS PUSZKA 0,5 L	NE_SPU_PUSZ_500	5905701060146	0.54	10.00	65
FORTUNA MIRABELKA BEZALKOHOLOWE BUT. 0,5 L	MIЈ_FOR_MIR_BEZ_BUT_500	5902838990988	0.77	10.00	66
DUGGES BLACK CURRANT ORGANIC PUSZKA 0,33 L	DUGG_BLA_CUR_ORG_PUSZ_330	7350038223562	0.35	10.00	67
BIRBANT KIZZY PUSZKA 0,5 L	BI_KIZ_PUSZ_500	5904041703836	0.54	10.00	68
ARTEZAN JARDIN DU CHВTEAU DRUIF BUT. 0,375 L	ART_JAR_DRU_BUT_375	5904708750609	0.50	10.00	69
PINTA PORTERMASS Smoked Plum & Coco Nibs 30,0° but. 0,33 l	PI POR Smo Coc	5904165103512	0.00	10.00	70
TRZECH KUMPLI WHEELER PUSZKA 0,5 L	TR WHE	5904252699294	0.54	10.00	71
ZAKЈADOWY BAЈAGAN BUT. 0,5 L	ZAKЈ BAЈ	5907753171597	0.77	10.00	72
SZRENIAWA MIODOWE BUT. 0,5 L	SZR_MIO_BUT_500	5903857178302	0.77	10.00	73
DUVEL 6.66 PODKЈADKI	DUV POD	5123456789852	0.00	10.00	74
MARYENSZTADT HOPPY LEMO - MANGO & CHMIEL BUT. 0,33 L	MAR_HOP_LEM_MAN_BUT_330	5903424615674	0.50	10.00	75
BЈONIE KUR ZAPIAЈ BUT. 0,5 L	BЈO KUR	5908258856101	0.77	10.00	76
PINTA Bluza czarna L	PINTA Blu cza L	5904165100535	0.00	10.00	77
SCHNEIDER TAP04 FESTWEISSE 13,4° BUT. 0,5 L	Schn TAP4	4003669016609	0.77	10.00	78
ZAKЈADOWY CO BКDZIE W LIPCU? BUT. 0,5 L	ZA_CO_BED_BUT_500	5907753172358	0.77	10.00	79
TRZECH KUMPLI UNPLUGGED IPA PUSZKA 0,5 L	TR UNP IPA P	5904252699522	0.54	10.00	80
DZIKI WSCHУD MENOTSE PUSZKA 0,5 L PROMOCJA (do 25.10.23)	DZIKI MEN_PROM	\N	0.00	10.00	81
P?HJALA COSY NIGHTS BUT. 0,33 L	POH COS NIG	4742976015508	0.50	10.00	82
MARYENSZTADT SOURTIME PASTRY SOUR IPA MANGO & PEACH BUT. 0,5 L	MAR SOU MAN PEA	5903424615964	0.77	10.00	83
BALADIN XYAUYU ORO 2018 BUT. 0,5 L	BAL XYA ORO	8032942291293	0.77	10.00	84
NEPOMUCEN JOSE BUT. 0,5 L	NE JOS	5905279959712	0.77	10.00	85
ARTEZAN NO WORRIES! BUT. 0,5 L	ARTEZ NO!	5904730574310	0.77	10.00	86
FORTUNA BEZALKOHOLOWE CZARNE BUT. 0,5 L	MIЈ FOR BEZ CZA	5902838990667	0.77	10.00	87
MIKKELLER SCOUR SCANDINAVIA SPONTAN SEABUCKTHORN BUT. 0,375 L	MIK SC 375	5704255118323	0.50	10.00	88
THE BRUERY SHARE THIS: MINT CHIP BUT. 0,75 L	BRU MIN	19962362057	1.10	10.00	89
PINTA Koszulka biaіa L	PINTA Kos bia L	5904165100436	0.00	10.00	90
FUNKY FLUID LECKER BUT. 0,5 L	FF_LEC_BUT_500	5903999514310	0.77	10.00	91
CHYLICZKI CYDR JAPOСSKI SAD BUT. 0,5 L	CHYL JAP SAD 500	5905279058224	0.77	10.00	92
LIMBURGSE WITTE POKAL 0,5 L	LIMB WIT POK 500	5123456791073	0.00	10.00	93
P?HJALA MUST KULD KEG 30 L	KAT01514	5123456789007	32.00	10.00	94
CHIMAY RED KEG 20 L	CHIM RED KEG 20	5410908002016	21.50	10.00	95
P?HJALA - LINDHEIM THE CHERRY OF MY EYE  BUT. 0,33 L	POH_LIN_THE_CHE_BUT_330	4742976016116	0.50	10.00	96
ONE MORE BEER T-SHIRT SZARY (XXL)	KAT05456	5123456791108	0.00	10.00	97
ST. FEUILLIEN GRAND CRU BUT. 0,75 L PROMOCJA (do 04.10.23)	STF GRA CRU 750_PROM	\N	0.00	10.00	98
P?HJALA MUST KULD CHAI LATTE PUSZKA 0,33 L	POH_MUS_KUL_CHA_BUT_330	4742976015423	0.35	10.00	99
O'HARA'S TROPICAL IPA BUT. 0,5 L	Oha Tro IPA	5391500602135	0.77	10.00	100
AMBER ZЈOTE LWY BUT. 0,5 L	AMB_ZЈO_LWY_BUT_500	5906591000724	0.77	10.00	101
P?HJALA VIRVATULI BUT. 0,33 L	POH VIR	4742976015607	0.50	10.00	102
CANTILLON ROSE DE GAMBRINUS 2022 BUT. 0,375 L	CANT ROS 2022 375 ml	5123456790017	0.50	10.00	103
ЈAСCUT POPROSZК O DOLEWKК BUT. 0,5 L	LAN_POP_BUT_500	5906395997978	0.77	10.00	104
ZA MIASTEM CHWILA ODDECHU BUT. 0,5 L	ZAM_CHWI_OD_BUT_500	5904905630209	0.77	10.00	105
ZIEMIA OBIECANA DOZO! PUSZKA 0,5 L	ZO_DOZ_PUSZ_500	5905186484710	0.54	10.00	106
RODENBACH ROSSO SZKLANKA 0,5 L	KAT07038	5123456791031	0.00	10.00	107
PINTA BARREL BREWING DIRECTION 30,0° BUT. 0,33 L	PBB_DIR_BUT_330	5904335577495	0.50	10.00	108
PINTA Koszulka szara S	PINTA Kos sza S	5904165101259	0.00	10.00	109
MARYENSZTADT BARREL AGED ICE BRETT PORTER DOUBLE BA - SUSZONA ЊLIWKA I CYNAMON PUSZKA 0,44 L	MAR BA ICE BRE SUS SLI CYN	5903424615131	0.48	10.00	110
LUBROW GRUBY BAMBER PUSZKA 0,33 L	LUB_GRU_PUSZ_330	5903686842924	0.35	10.00	111
FORTUNA ЊLIWKOWA BUT. 0,5 L	MIЈ FOR ЊLI	5901687910161	0.77	10.00	112
KASTEEL BARISTA CHOCOLATE QUAD KEG 20 L	KAST BAR CHO K 20 L	5123456789882	21.50	10.00	113
PINTA Szklanka PM 2022 0,5 l	PINTA Szk PM 2022	5904165102065	0.00	10.00	114
ALEBROWAR OCEAN EMPEROR BUT. 0,5 L	ALE_OCE_EMP_BUT_500	5907771342634	0.77	10.00	115
KAZIMIERZ NORMALNE PIWO BUT. 0,5 L	KAZ NOR PIW	5906660570448	0.77	10.00	116
MAGIC ROAD DESTINATION NOWHERE PUSZKA 0,5 L	MR_DES_PUSZ_500	5905204131091	0.54	10.00	117
PINTA T-shirt czarny duїe logo M	PINTA Kos DL cza M	5904165102409	0.00	10.00	118
MARYENSZTADT SOURTIME CZARNA PORZECZKA BUT. 0,5 L	MAR_SOU_CZA_POR_BUT_500	5905669542326	0.77	10.00	119
KASTEEL TRIGNAC BUT. 0,75 L	KAST TRI	5411081005344	1.10	10.00	120
ZA MIASTEM NA WYPASIE BUT. 0,5 L	ZAM NAW	5906874605042	0.77	10.00	121
ЈAСCUT LEMUR PARADISE BUT. 0,5 L	LAN_LEM_BUT_500	5906395997961	0.77	10.00	122
GOЊCISZEWO SҐSIAD BUT. 0,5 L	GO_SҐSI_BUT_500	5903364108007	0.77	10.00	123
PETRUS NITRO CHERRY CHOCO BUT. 0,33 L	PET NIT CHER CHO 330	875213001522	0.50	10.00	124
TRZECH KUMPLI SZKLANKA SHAKER 0,5 L	TR SZK SHA	5123456791266	0.00	10.00	125
KASTEEL ROUGE PUSZKA 0,5 L	KAST ROU P	5411081006112	0.54	10.00	126
FUNKY FLUID MANIAC PUSZKA 0,5 L	FF_MAN_PUSZ_500	5907772092866	0.54	10.00	127
TRZECH KUMPLI IDIOTA PUSZKA 0,33 L	TR IDI P	5904252699508	0.35	10.00	128
CIESZYN NOSZAK KEG 30 L	CIE NOS K	5123456789079	32.00	10.00	129
STU MOSTУW STRAWBERRY BERLINER WEISSE BUT. 0,5 L	STU STR BER (ART8)	5905279213388	0.77	10.00	130
NERDBREWING HOTPATH IMPERIAL CHILI STOUT - 004 ANCHO BUT. 0,33 L	OMB Ner Hot	7350080580910	0.50	10.00	131
STAROPOLSKIE PORTER BAЈTYCKI ZE ЊWIDOЊLIWҐ BUT. 0,5 L	STAR_POR_BAЈ_ЊWID_BUT_500	5903021506269	0.77	10.00	132
KAZIMIERZ MAGOG BUT. 0,33 L	KAZ MAG	5906660570639	0.50	10.00	133
KASTEEL ROUGE TABLICA REKLAMOWA	KAST ROU TAB REK	5123456791353	0.00	10.00	134
DZIKI WSCHУD FREEROKEZ BUT. 0,5 L	DZIKI_FRE_BUT_500	5906874369685	0.77	10.00	135
PINTA Hop Selection - Sabro can 0,5 l	PI_HS_SAB_CAN_500	5904165104779	0.00	10.00	136
NEPOMUCEN NACHMIELONA CHMIEL+JABЈKO+CYTRYNA BUT. 0,5 L	NE NACH JAB CYT	5905279959552	0.77	10.00	137
LITOVEL PREMIUM 12° BZW. BUT. 0,5 L	LIT_PRE_BZW_BUT_500	8593875510115	0.77	10.00	138
STU MOSTУW PALE ALE BUT. 0,5 L	STU PAL	5905279213234	0.77	10.00	139
PIWOTEKA CZAISZ BAZК: LAPSANG SOUCHONG BUT. 0,5 L	PIW_CZA_LAP_BUT_500	5905669428101	0.77	10.00	140
RACIBORSKIE PILS BUT. 0,5 L	RAC PIL	5907506252269	0.77	10.00	141
DZIKI WSCHУD KIRRAI PUSZKA 0,5 L	DZIKI_KIRR_PUSZ_500	5906874369081	0.54	10.00	142
KINGPIN WEIZEN BUT. 0,5 L	KING WEI	5904730290746	0.77	10.00	143
PIWNE PODZIEMIE KRAKEN OF DOOM – SPECIAL VERSION BUT. 0,33 L	POD_KRA_DOO_SPE_BUT_330	5904305482590	0.50	10.00	144
MARYENSZTADT KLASYCZNIE APA BUT. 0,5 L	MAR KLA APA	5905669542821	0.77	10.00	145
MARYENSZTADT BEZGLUTENOWY SESYJNE APA BUT. 0,5 L	MAR BEZ SES APA	5903678022037	0.77	10.00	146
ALEBROWAR ICE NAKED MUMMY BUT. 0,25 L	ALE ICE NAK	5907771341385	0.35	10.00	147
FISCHER BLONDE BUT. 0,65 L PROMOCJA (do 30.09.23)	KAT07061_PROM	\N	0.00	10.00	148
ZULI MELARYA IMBIR QUATRO BUT. 0,33 L	ZU_MELA_IMB_QUA_BUT_330	5904933314287	0.50	10.00	149
NERDBREWING SUSPEND MAPLE AND CINNAMON IMP OATMEAL STOUT BUT. 0,33 L	OMB Ner Sus	7350080581160	0.50	10.00	150
KINGPIN PORTER BAЈTYCKI BUT. 0,5 L	KING POR	5904730290791	0.77	10.00	151
KINGPIN PILS BUT 0,5 L	KING PIL	5904730290692	0.00	10.00	152
WESTMALLE DUBBEL BUT. 0,75 L	WESTMA DUB 750	5412343001166	1.10	10.00	153
ROCKMILL TROPICAL IMPERIAL SOUR ALE PUSZKA 0,44 L PROMOCJA (do 18.10.23)	ROCK_TRO_IMP_SOU_AL_PUSZ_440_PROM	\N	0.00	10.00	154
JURAJSKIE KWAS PRUSKI BUT. 0,5 L	JUR PRU	5905331025607	0.77	10.00	155
BROKREACJA POTION #25 BUT. 0,33 L	BR_POT_#25_BUT_330	5904422197896	0.50	10.00	156
CA' DEL BRADO ZENA - WILD GOSE BUT. 0,375 L	CDB_ZEN_BUT_375	\N	0.50	10.00	157
PRAIRIE APRICOT FUNK BUT. 0,5 L	PRAI APR	683318988408	0.77	10.00	158
NEPOMUCEN LABIRYTM BUT. 0,5 L	NE LAB	5905279959101	0.77	10.00	159
FUNKY FLUID SPLASH: WHITE PUSZKA 0,5 L	FF_SPL_WHI_PUSZ_500	5903999512491	0.54	10.00	160
NEPOMUCEN FREE PAN DA PUSZKA 0,5 L	NE PAN DA FRE	5907709756434	0.54	10.00	161
KINGPIN ATAVISTIC PUSZKA 0,5 L	KING ATA	5904730290821	0.54	10.00	162
GULDEN DRAAK CUVEE PRESTIGE MADEIRA BUT. 0,75 L	GUL DRA CUV PRE MAD	5411663708908	1.10	10.00	163
PINTA Kwas Jota 10,5° but. 0,5 l	PI Jot	5904165103048	0.00	10.00	164
IGNACУW CYDR SICERO BUT. 0,5 L	IGNAC SIC	5902768323030	0.77	10.00	165
ROCHEFORT TRAPPISTES 10* BUT. 0,33 L	ROCH 10 330	5412858000104	0.50	10.00	166
JURAJSKIE ALE SZOPKA BUT. 0,5 L	JUR ALE	5905331026062	0.77	10.00	167
FUNKY FLUID GELATO: BLUEBERRY CHEESECAKE PUSZKA 0,5 L	FF_GEL_BLU_CHEE_PUSZ_500	5903999514501	0.54	10.00	168
ZA MIASTEM CICHY WIECZУR BUT. 0,5 L	ZAM CIC	5906874605011	0.77	10.00	169
WIDAWA PREMIUM BUT. 0,5 L	WID PRE	5907710904008	0.77	10.00	170
PRZETWУRNIA CHMIELU POMPA PUSZKA 0,5 L	PCH_POM_PUSZ_500	5905476980670	0.54	10.00	171
GAULOISE BLONDE BUT. 0,33 L	GAU BLO 330	5411633331013	0.50	10.00	172
SOWIE PSZENICZNE MANGO I MARAKUJA BUT. 0,5 L	SOW_PSZE_MANG_BUT_500	5907222560228	0.77	10.00	173
MALTGARDEN BOAT TO INDIA BUT. 0,5 L	MALT BOA	5907710943472	0.77	10.00	174
STAROPOLSKIE KULTOWE BEZ GLUTENU CYTRYNOWE BUT. 0,5 L	STAR KUL BEZ CYT	5903021504395	0.77	10.00	175
HERKENRODE NOCTIS BUT. 0,33 L	HERK NOCT 330	5413699101234	0.50	10.00	176
VAULT CITY - FAITH IN SOUR PUSZKA 0,44 L	OMB VC Fai	5056412005305	0.48	10.00	177
ZA MIASTEM UЊMIECH LOSU BUT. 0,5 L	ZAM UЊM	5906874605424	0.77	10.00	178
DZIKI WSCHУD BUSZUJҐCY W ZBOЇU BUT. 0,5 L	DZIKI BUS ZBO	5906874369265	0.77	10.00	179
MIKKELLER SPONTAN LEMON BUT. 0,375 L	MIK SPON LEM 375	818534020865	0.50	10.00	180
SAMUEL SMITH OATMEAL STOUT BUT. 0,355 L	SS OST	5010149200822	0.00	10.00	181
DUBUISSON BUSH ZESTAW (2 X CARACTERE BUT. 0,33 L + 2 X TRIPLE BUT. 0,33 L +SZKЈO)	DUB BUS ZEST 2X330 + 2X330 + SZ	5411551120515	0.00	10.00	182
CHYLICZKI CYDR ANTONУWKA BUT. 0,5 L	CHYL ANT 500	5905279058101	0.77	10.00	183
DUVEL TRIPLE HOP CASHMERE BUT. 0,33 L	DUV TRI CAS 330	5411681406039	0.50	10.00	184
CIESZYN KARTONIK A4	CIE_KART_A4	5123456791385	0.00	10.00	185
WRКЇEL VIVA ESPANA TWO PUSZKA 0,5 L PROMOCJA (do 20.10.23)	WRE VIV TWO_PROM	\N	0.00	10.00	186
KASTEEL POKAL 0,33 L	KAST POK 330	5123456791082	0.00	10.00	187
INNE BECZKI TOPAZ BUT. 0,5 L	INNE TOP	5903661280963	0.77	10.00	188
ZA MIASTEM SЈONECZNY DZIEС BUT. 0,5 L	ZAM SЈO	5906874605097	0.77	10.00	189
PIWOTEKA SZTUKA ETRUSKA BUT. 0,5 L	PIW_SZT_ETR_BUT_500	5905669428064	0.77	10.00	190
TIMMERMANS KRIEK BUT. 0,25 L	TIMM KRI 250	5411516010110	0.35	10.00	191
ST. FEUILLIEN CUVЙE DE NOEL BUT. 0,75 L	STF NOE 750	5412138307510	1.10	10.00	192
NOOK MAHAGANO BUT. 0,33 L	NOOK MAH	5903240848393	0.50	10.00	193
ALEBROWAR ROWING JACK BUT. 0,5 L	ALE ROW	5907222039083	0.77	10.00	194
BROWARNY PYRAMIDS PUSZKA 0,5 L	BROW_PYRA_PUSZ_500	5905450141073	0.54	10.00	195
ZA MIASTEM OWOCNE ROZMOWY BUT. 0,5 L	ZAM_OWOC_ROZM_BUT_500	5904905630216	0.77	10.00	196
MIKKELLER RUNNING CLUB SPODNIE CZARNE (XXL)	MIK SPOD XXL	5123456791118	0.00	10.00	197
ZA MIASTEM RADOЊЖ ЇYCIA BUT. 0,5 L	ZAM RAD	5906874605196	0.77	10.00	198
TOOL GLЦGGLICH RUM, RED WINE & PORT WINE BUT. 0,375 L	KAT06759	5711474008519	0.50	10.00	199
DEER BEAR KOMPOT #2 PUSZKA 0,5 L	DE_KOMP_2_PUSZ_500	5905204172162	0.54	10.00	200
ZA MIASTEM PEЈEN RELAKS BUT. 0,5 L	ZAM_PEЈ_REL_BUT_500	5904905630223	0.77	10.00	201
RACIBORSKIE SUMMER ALE BUT. 0,5 L	RAC_SUM_ALE_BUT_500	5907506252542	0.77	10.00	202
OUD BEERSEL OUDE GUEUZE 2016 BUT. 0,75 L	OUD GUE 2016 750	5425018070121	1.10	10.00	203
ЈAСCUT DZIKI RYE BUT. 0,5 L	LAN_DZI_BUT_500	5906395997954	0.77	10.00	204
FLYING MONKEYS SZKLANKA  0,25 L	KAT07037	5123456791047	0.00	10.00	205
SCHNEIDER TAP09 AVENTINUS EISBOCK 25,5° BUT. 0,33 L	Schn TAP9	4003669018269	0.50	10.00	206
STONE OLD GUARDIAN RED WINE BA 2011 BUT. 0,5 L	KAT03197	636251802089	0.77	10.00	207
PINTA T-shirt zielony duїe logo L	PINTA Kos DL zie L	5904165102560	0.00	10.00	208
FUNKY FLUID POINT FIVE HAZY IPA PUSZKA 0,5 L	FF POI HAZ IPA	5907772092958	0.54	10.00	209
SCHNEIDER TAPX CUVEE BARRIQUE 21,5° BUT. 0,75 l	Schn TAPX Cuv	4003669022778	0.00	10.00	210
PINTA T-shirt szary duїe logo M	PINTA Kos DL sza M	5904165102508	0.00	10.00	211
TIMMERMANS OUDE KRIEK BUT. 0,375 L	TIMM OUD KRI 375	5411516002269	0.50	10.00	212
STAROPOLSKIE PORTER BAЈTYCKI BUT. 0,5 L	STAR POR BAЈ	5905669086707	0.77	10.00	213
PIWNE PODZIEMIE PERMANENT VACATION KEG 30 L	POD_PER_KEG_30	\N	32.00	10.00	214
ALEBROWAR KWAS CHLEBOWY JASNY BUT. 0,5 L	ALE_KWA_JAS_BUT_500	5907771340036	0.77	10.00	215
DRY & BITTER CZAPKA ZIMOWA ZIELONA	DRY BIT CZA ZIM ZIE	5123456791356	0.00	10.00	216
ALEBROWAR BAЈTYCKI DZIAD STOUT BUT. 0,5 L	ALE BAЈ STO	5907771342283	0.77	10.00	217
DZIKI WSCHУD NOLAN PUSZKA 0,5 L	DZIKI NOL	5906874369067	0.54	10.00	218
SCHNEIDER TAP05 HOPFENWEISSE  18,5° KEG 20 L	Schn TAP5 keg 20	2100006E34652	21.50	10.00	219
RECRAFT ЊWIКTY PATRYK BUT. 0,5 L	REC ЊWI	5900779755062	0.77	10.00	220
STU MOSTУW 8TH ANNIVERSARY MIXED FERMENTATION GRAFF  BUT. 0,375 L	STU 8TH MIX FER	5907614682514	0.50	10.00	221
STAROPOLSKIE BESTBIR ANANAS BUT. 0,5 L	STAR BES ANA	5903021500007	0.77	10.00	222
FUNKY FLUID SUSKA SECHLOСSKA PUSZKA 0,44 L	FF SUS	8720615260690	0.48	10.00	223
STAROPOLSKIE GRAPE ALE BUT. 0,5 L	STAR_GRAP_ALE_BUT_500	5903021506276	0.77	10.00	224
SCHNEEEULE BLAUE BLUMEN BUT. 0,75 L	SCHN BLA BLU	\N	1.10	10.00	225
MALTGARDEN GATE NO 8/2022 PUSZKA 0,33 L	MALT GAT 8	5904050721944	0.35	10.00	226
STU MOSTУW ART+67 DDH PALE ALE PUSZKA 0,44 L	STU_ART67_PUSZ_440	5907614682972	0.48	10.00	227
FUNKY FLUID SPLASH: PINK PUSZKA 0,5 L	FF SPL PIN	5903999513276	0.54	10.00	228
MIO MIO MATE IMBIR BUT. 0,5 L	MIO_MIO_MAT_IMB_BUT_500	4002846034689	0.77	10.00	229
ALEBROWAR ICE SWEET COW WITH COCOA NIBS BUT. 0,25 L	ALE_ICE_SWE_BUT_250	5907771343327	0.35	10.00	230
NEPOMUCEN RAJ PUSZKA 0,5 L	NE_RAJ_PUSZ_500	5905701060054	0.54	10.00	231
TRZECH KUMPLI UNPLUGGED IPA BUT. 0,33 L	TR_UNP_IPA_BUT_330	5904252699768	0.50	10.00	232
SCHLENKERLA RAUCHBIER WEIZEN 13,2° BUT. 0,5 L	SCH WEI	4037458000159	0.77	10.00	233
FUNKY FLUID CRAZY HAZY BUT. 0,5 L	FF CRA	5907772092187	0.77	10.00	234
LUBROW SЈODOWY PUSZKA 0,33 L	LUB_SЈO_PUSZ_330	5903686842702	0.35	10.00	235
GULDEN DRAAK BUT. 0,33 L	GUL DRA 330	5411663002716	0.50	10.00	236
SVIJANY MATA BAROWA	SVI_MATA_BAR	\N	0.00	10.00	237
SAMUEL SMITH IMPERIAL STOUT BUT. 0,355 L	SS IMS	5010149200846	0.00	10.00	238
ALEBROWAR VANILLA PASSION BUT. 0,5 L	ALE_VAN_PAS_BUT_500	5907771343792	0.77	10.00	239
BOSTEELS TRIPEL KARMELIET ZESTAW 4X BUT. 0,33 L + SZKЈO	BOST TRI ZEST 4X330 SZK	5410693100492	0.00	10.00	240
THE BRUERY / FUNKY BUDDHA !GUAVA LIBRE! BUT. 0,75 L	BRU GUA	653341008428	1.10	10.00	241
RECRAFT ORGANIC PILS PUSZKA 0,5 L	REC_ORG_PUSZ_500	5900779755314	0.54	10.00	242
PALATUM AQUA IMPERIALE PUSZKA 0,5 L	PAL AQU	5905159520100	0.54	10.00	243
BIRBANT CATALITYC PUSZKA 0,5 L	BI_CAT_PUSZ_500	5904041703607	0.54	10.00	244
DUVEL MATA BAROWA	KAT06153	5123456791202	0.00	10.00	245
ALEBROWAR BE LIKE MITCH BUT. 0,5 L	ALE BEL	5903364108496	0.77	10.00	246
GRYFUS GRINGO AT SUNRISE PUSZKA 0,5 L	GRY_GRI_PUSZ_500	5900779755833	0.54	10.00	247
MARYENSZTADT KLASYCZNIE GERMAN PILS BUT. 0,5 L	MAR KLA GER	5903678022181	0.77	10.00	248
PINTA T-shirt szary duїe logo S	PINTA Kos DL sza S	5904165102492	0.00	10.00	249
DZIKI WSCHУD DZIEWCZYNA SZAMANA BUT. 0,5 L	DZIKI DZI	5906874369197	0.77	10.00	250
BЈONIE HULAJ DUSZA PUSZKA 0,5 L	BЈO HUL DUS P	5908258856941	0.54	10.00	251
CIESZYN POKAL 0,3 L	CIE POK 0,3	5123456791332	0.00	10.00	252
ZAKЈADOWY PSZENICA BUT. 0,5 L	ZA_PSZ_BUT_500	5907753172235	0.77	10.00	253
FUNKY FLUID GELATO: BUBLANINA PUSZKA 0,5 L	FF_GEL_BUB_PUSZ_500	5903999514037	0.54	10.00	254
BROKREACJA THE FARMER BUT. 0,5 L	BRO FAR	5905669783040	0.77	10.00	255
BOON GUEUZE MARIAGE PARFAIT BUT. 0,75 L	BOON GMP 750	5412783052872	1.10	10.00	256
MADAME BARREL PATI CZECK BUT. 0,5 L PROMOCJA (do 30.09.23)	MB_PAT_CHE_BUT_500_PROM	\N	0.00	10.00	257
CIDER INN GЈКBSZY SMAK PУЈWYTRAWNY 4,5%  BUT.0,33 L	CID_INN_PУЈW_BUT_330	5900468000077	0.00	10.00	258
3 FONTEINEN OUDE GEUZE CUVEE ARMAND & GASTON 2016/17 BUT. 0,375 L	3 FON ARM 2016/17 0,375	5425007813012	0.50	10.00	259
ARTEZAN ZIELONE ЊWIATЈO BUT. 0,5 L	ART_ZIE_BUT_500	5904708750449	0.77	10.00	260
TIMMERMANS OUDE GUEUZE BUT. 0,375 L	TIMM OUD GUE 375	5411516002306	0.50	10.00	261
RADUGA SAMURAI REBELLION BUT. 0,5 L	RADU SAM	5907431705236	0.77	10.00	262
WRКЇEL MALTIC STORM BUFFALO TRACE BUT. 0,5 L	WR_MAL_BUF_BA_BUT_500	5904181970303	0.77	10.00	263
BIRBANT MUERTE PUSZKA 0,33 L	BI MUE	5904041703348	0.35	10.00	264
LIMBURGSE WITTE PEAR APPLE BUT. 0,33 L	LIMB WIT PEA APP 330	5413699165151	0.50	10.00	265
STELLA ARTOIS POKAL  0,5 L	KAT05068	5123456791064	0.00	10.00	266
FORTUNA MIODOWE BUT. 0,5 L	MIЈ FOR MIO	5902709615187	0.77	10.00	267
LINDEMANS LEЇAK PLAЇOWY	KAT06125	5123456791138	0.00	10.00	268
GAULOISE BLACHA REKLAMOWA	GAU BLA REK	5123456791366	0.00	10.00	269
STAROPOLSKIE BESTBIR IMBIR Z MIODEM BUT. 0,5 L	STAR BES IMB MIO	5905669086134	0.77	10.00	270
MALTGARDEN GATE NO 3/2021 BUT. 0,5 L	MALT GAT 3	5904050721401	0.77	10.00	271
LINDEMANS FARO BUT. 0,25 L	LIND FAR 250	5411223101019	0.35	10.00	272
ST. MARTIN BLONDE 7% BUT. 0,33 L	STM BLO 7 330	5411065403319	0.50	10.00	273
MARYENSZTADT GWIAZDA PУЈNOCY BUT. 0,33 L	MAR GWI	5905669542708	0.50	10.00	274
KOMES PORTER BAЈTYCKI PЈATKI DКBOWE BUT. 0,5 L	MIЈ KOM POR PЈA DКB	5901687910826	0.77	10.00	275
PRIMБTOR PREMIUM LAGER 12° BUT. 0,5 L	PRI PRE	8594006933391	0.77	10.00	276
MIKKELLER PUMA BOKSERKA SPORTOWA CZARNA (XL)	MIK PUM XL	5123456791119	0.00	10.00	277
ST. FEUILLIEN TRIPLE BUT. 0,75 L	STF TRI 750	5412138507552	1.10	10.00	278
MALTGARDEN HOW TO SPELL FUN PUSZKA 0,5 L	MA_HOW_TO_PUSZ_500	5907710943830	0.54	10.00	279
ED RED KONSERWA MASSAMAN CURRY Z KURCZAKIEM	ED MAS	59040835841037	0.00	10.00	280
STAROPOLSKIE KULTOWE JASNE BUT. 0,5 L	STAR KUL JAS	5905669086233	0.77	10.00	281
PINTA Bawarka 13,0° keg 30 l	PI Baw W keg 30	5123456789666	0.00	10.00	282
FUNKY FLUID PILS PLEASE BUT. 0,5 L	FF PIL	5906395560257	0.77	10.00	283
LINDEMANS GUEUZE CUVEE RENE BUT. 0,75 L	LIND GUE CUV 750	5411223020709	1.10	10.00	284
IGUANA Metabolizm BIO but. 0,475 L	TRY_IGU_BUT_475	5905689311117	0.00	10.00	285
STU MOSTУW ART+68 PASTRY IMPERIAL STOUT PECAN NUTS-COCONUT BUT. 0,33 L	STU_ART68_BUT_330	5907614682989	0.50	10.00	286
MIЈOSЈAW PSZENICZNE BEZALKOHOLOWE BUT. 0,5 L	MIЈ_PSZ_BEZ_BUT_500	5902838991473	0.77	10.00	287
NEPOMUCEN KEEP ON ROLLIN’ PUSZKA 0,5 L	NE_KEE_PUSZ_500	5905701060245	0.54	10.00	288
CORSENDONK AGNUS TRIPLE BUT. 0,33 L	COR AGN TRI 330	54069022	0.50	10.00	289
STAROPOLSKIE NIEMDЈE ANANASOWE BUT. 0,5 L	STAR NIE ANA	5903021503350	0.77	10.00	290
PINTA Psst... It's Your Weekend IPA - Foggy IPA 15,0° but. 0,5 l	PI_PSST_YOU_FOGG_BUT_500	5904165104700	0.00	10.00	291
TILQUIN OUDE MURE A L’ANCIENNE BUT. 0,75 L	TIL MUR 750	5425029530171	1.10	10.00	292
PALM GREEN NA BUT. 0,25 L	PAL GRE 250	5410783031019	0.35	10.00	293
BACCHUS PODKЈADKI	BACCH POD	5123456791341	0.00	10.00	294
PRZETWУRNIA CHMIELU SЈOMKA PUSZKA 0,5 L	PCH_SЈO_PUSZ_500	5905476980311	0.54	10.00	295
GRYBУW PILSVAR MIODOWY BUT. 0,5 L	GR MIO	5902516000985	0.77	10.00	296
OUD BEERSEL GEUZE VANDERVELDEN 135 BUT. 0,375 L	OUD GEU VAN 135 375	5425018070404	0.50	10.00	297
JURAJSKIE ALE MEKSYK BUT. 0,5 L	JUR MEK	5905331026376	0.77	10.00	298
FILOMELOS CYDR ANGELA BUT. 0,75 L	FIL_CYD_ANG_BUT_750	5900168509122	1.10	10.00	299
HOPPIN' FROG / TO OL SS STOUT BUT. 0,65 L	HOPP SSS	665760945994	0.00	10.00	300
PINTA BARREL BREWING TEMPLE 12,0° BUT. 0,375 L	PBB_TEM_BUT_375	5904335577525	0.50	10.00	301
GOLEM SZKЈO FIRMOWE 0,3 L	GOL SZK	5123456791225	0.00	10.00	302
GRYFUS AHOJ 2.0 BUT. 0,5 L	GRY_AHO_2.0_BUT_500	5904905850140	0.77	10.00	303
DZIK CYDR WYTRAWNY BUT. 0,5 L	DZIK_CYD_WYTR_BUT_500	5906395413492	0.77	10.00	304
DUBUISSON BUSH PRESTIGE BUT. 0,75 L	DUB BUS PRES 750	5411551677880	1.10	10.00	305
ZA MIASTEM WIELKA RADOЊЖ BUT. 0,5 L	ZAM_WIE_RAD_BUT_500	5904905630230	0.77	10.00	306
PINTA RISFACTOR Cocoa Nibs and Roasted Peanuts 30,0° but. 0,33 l	PI_RIS_COC_ROA_BUT_330	5904165104267	0.00	10.00	307
ST. BERNARDUS WIT BUT. 0,75 L	STB WIT 750	5411911001515	1.10	10.00	308
PINTA Koszulka їуіta XL	PINTA Kos їуі XL	5904165100498	0.00	10.00	309
MISSION DARK SEAS IMPERIAL STOUT BUT. 0,3 L	MISS DAR	850411004056	0.00	10.00	310
FUNKY FLUID THRILLED BLACK IPA PUSZKA 0,5 L	FF_THRI_PUSZ_500	5903999514228	0.54	10.00	311
DZIK CYDR TRAWA CYTRYNOWA 0% BUT. 0,33 L	DZIK_CYD_TRAW_BUT_330	\N	0.50	10.00	312
DEER BEAR RAMEN SHOP BUT. 0,5 L	DEER RAM SHO	5903678460013	0.77	10.00	313
MOON LARK GLOW. AMERICAN PALE ALE PUSZKA 0,5 L	ML GLO	5905255346024	0.54	10.00	314
TRZECH KUMPLI SZKLANKA NONIC 0,5 L	TR SZK NON	5123456791265	0.00	10.00	315
PINTA Barrel Brewing Grandeur but. 0,33 l	PBB Gra	5904335577341	0.00	10.00	316
O'HARA'S DOUBLE IPA BUT. 0,5 L	Oha Dou IPA	5391500600834	0.77	10.00	317
BROWAR JANA IPA BUT. 0,5 L	BRO_JA_IPA_BUT_500	5902429980145	0.77	10.00	318
JURAJSKIE JABЈKO-MIКTA BUT. 0,5 L	JUR JAB	5905331025997	0.77	10.00	319
O'HARA'S SZKLANKA NONIC 0,5 L	Oha Szkl Non 5	5123456791387	0.00	10.00	320
WESTMALLE BLACHA REKLAMOWA	KAT06766	5123456791207	0.00	10.00	321
LINDEMANS TAP HANDLE (DREWNO) 28 CM	KAT06623	5123456791019	0.00	10.00	322
PINTA Upgrade Your September 12,0° keg 20 l	PI_UPG_KEG_20	5123456780043	0.00	10.00	323
BOON KRIEK MARIAGE PARFAIT BUT. 0,375 L	BOON KMP 375	5412783053886	0.50	10.00	324
STAROPOLSKIE BESTBIR KIWI BUT. 0,5 L	STAR_BES_KIWI_BUT_500	5903021505606	0.77	10.00	325
PINTA BARREL BREWING AUTHORITY 15,0° BUT. 0,375 L	PBB_AUTH_BUT_375	5904335577655	0.50	10.00	326
KEG DU BOCQ 20L	KEG_DU_BO	\N	0.00	10.00	327
PINTA Hazy Delivery 15,0° keg 30 l	PI_HAZ_DEL_KEG_30	5123456780042	0.00	10.00	328
RODENBACH ALEXANDER BUT. 0,75 L	RODEN ALEX 750	5410583802048	1.10	10.00	329
AMBER NATURALNY BUT. 0,5 L	AMB_NAT_BUT_500	5906591002834	0.77	10.00	330
STAROPOLSKIE THE ART OF HOPPING WAKATU ORGANIC SINGLE HOP AMBER ALE BUT. 0,5 L	STAR_WAK_ORG_BUT_500	5903021505712	0.77	10.00	331
SMYKAN CYDR RENETY 2022 KEG 30 L	SMY_REN_KEG_30	\N	32.00	10.00	332
MARYENSZTADT WHEAT WINE COGNAC B.A. BUT. 0,33 L	MAR WHE WIN COG	5905669542890	0.50	10.00	333
PINTA Sangriale 15,0° but. 0,5 l	PI_SAN_BUT_500	5904165103703	0.00	10.00	334
TANKBUSTERS HELLO HELLES PUSZKA 0,5 L	TB_HEL_HEL_PUSZ_500	5904365781398	0.54	10.00	335
CIESZYN RAUCHBOCK - GRAND CHAMPION 2022 BUT. 0,33 L	CIE RAU GB	5907612240822	0.50	10.00	336
ARTEZAN A PILS BUT. 0,5 L	ARTEZ A PILS	5904730574624	0.77	10.00	337
TRZECH KUMPLI PORTER BAЈTYCKI BUT. 0,5 L	TR POR	5905669479516	0.77	10.00	338
PINTA IIPPAA 18,0° but. 0,5 l	PI IIP	5904730438766	0.00	10.00	339
LUPULUS ORGANICUS BUT. 0,33 L	LUP ORG 330	5425025122073	0.50	10.00	340
ROCKMILL INFINITY RUM BA BUT. 0,5 L	ROCK_INF_RUM_BA_BUT_500	5908291862299	0.77	10.00	341
CHYLICZKI CYDR JAPOСSKI SAD KEG 30 L	CHYL JAP SAD K	5123456789029	32.00	10.00	342
AYINGER JAHRHUNDERT BIER BUT. 0,5 L	AYI JAH	4104170022209	0.77	10.00	343
PINTA Barrel Brewing - After Hours - Rose Wild Ale 12,0° keg 10 L	PBB_ROS_WIL_KEG_10	5123456780031	0.00	10.00	344
LINDEMANS TAROT D'OR BUT. 0,25 L	LIND_TAR_D'OR_BUT_250	5411223005317	0.35	10.00	345
LA TRAPPE DUBBEL BUT 0,33 L	TRAP DUB 330	8711406000564	0.00	10.00	346
FUNKY FLUID BUONASERA PUSZKA 0,5 L	FF_BUONAS_PUSZ_500	5903999514648	0.54	10.00	347
INNE BECZKI SOURZILLA PUSZKA 0,5 L	INNE SOU	5903661281434	0.54	10.00	348
UNTITLE ART. SWEET SOUR TANGERINE PUSZKA 0,473 L	OMB UA Swe	850011756935	0.53	10.00	349
GRIMBERGEN BLONDE BUT. 0,33 L	GRI BLO 330	5410263015669	0.50	10.00	350
P?HJALA - MIKKELLER SEA FOG PUSZKA 0,33 L	KAT07116	4742976015201	0.35	10.00	351
PINTA Hazy Discovery Timisoara keg 30 l	PI_HD_TIM_KEG_30	5123456780049	0.00	10.00	352
ЈAСCUT ACIDUM FRUCTUS BUT. 0,5 L	LAN ACI	5906395997886	0.77	10.00	353
DUVEL POKAL 3 L	DUV_POK_3	5123456791454	0.00	10.00	354
FUNKY FLUID SPIFFY PUSZKA 0,5 L	FF_SPI_PUSZ_500	5903999514488	0.54	10.00	355
ST. LOUIS PREMIUM PECHE BUT. 0,25 L	ST LOU PRE PEC	5411081000363	0.35	10.00	356
ZAKЈADOWY PRODUKT WZORCOWY BUT. 0,5 L	ZAKЈ PRO	5906395388028	0.77	10.00	357
VITAMINE SEA BELOW SEA LEVEL PUSZKA 0,473 L	OMB Vit Bel	5123456790117	0.53	10.00	358
BROWARNY YANGA PUSZKA 0,44 L	BROW_YAN_PUSZ_440	5905450141141	0.48	10.00	359
DU BOCQ BLANCHE DE NAMUR SZKLANKA 0,25 L NOWA	DU BOC BLA DE NAM SZKL 250	5123456791052	0.00	10.00	360
WIDAWA LE POLONAISE C’T’UNE JOKE CABERNET CORTIS B.A. BUT. 0,75 L	WID LEP CAB	5907710904602	1.10	10.00	361
PRAIRIE PARADAISE BUT. 0,355 L	PRAI PAR	683318988323	0.00	10.00	362
PINTA Koszulka HC czarna S	PINTA Kosz HC czar S	5904165103000	0.00	10.00	363
BROKREACJA TIMBER PUSZKA 0,5 L	BR_TIM_PUSZ_500	5904422197889	0.54	10.00	364
ALEBROWAR SINGLE HOP VERMELHO HAZY APA BUT. 0,5 L	ALE_SH_VER_BUT_500	5907771343419	0.77	10.00	365
BROWAR JANA JASNE PEЈNE BUT. 0,5 L	BRO_JA_JAS_PEЈ_BUT_500	5902429980008	0.77	10.00	366
FUNKY FLUID TRIPLE GELATO: BERRIES & CREAM PUSZKA 0,5 L	FF TRI GEL BER	5903999510893	0.54	10.00	367
BOON OUDE GUEUZE VAT DISCOVERY BOX (4 X 0,375 L)	BOON OUG VAT DISC 375	5412783182944	0.00	10.00	368
TRZECH KUMPLI TAURA PUSZKA 0,5 L	TR TAU P	5904252699607	0.54	10.00	369
PINTA Beskidy APA 12,0° keg 20 l	PI Bes APA keg 20	5123456789669	0.00	10.00	370
VAL-DIEU BRUNE BUT. 0,33 L	VAL BRU 330	5413977000020	0.50	10.00	371
CIESZYN BEZALKOHOLOWY LAGER BUT. 0,5 L	CIE BEZ LAG	5905279156814	0.77	10.00	372
LINDEMANS APPLE KEG 20 L	LIND APP K 20 L	5123456789028	21.50	10.00	373
ZAKЈADOWY GOЈҐB NA DACHU BUT. 0,5 L	ZA_GOЈ_BUT_500	5907753172334	0.77	10.00	374
TRZECH KUMPLI RAGNAR PUSZKA 0,33 L	TR RAG P	5904252699577	0.35	10.00	375
LUBROW INFUSED NO. 1 PUSZKA 0,33 L	LUB_INF_NO1_PUSZ_330	5903686842832	0.35	10.00	376
MIKKELLER SPONTAN ELDERFLOWER BUT. 0,375 L	MIK SPON ELD 375	5704255115612	0.50	10.00	377
FUNKY FLUID WATCH YA SELF PUSZKA 0,5 L	FF_WAT_PUSZ_500	5903999514556	0.54	10.00	378
PINTA Beskidy Pszeniczne 13,0° keg 30 l	PI Bes Psz keg 30	5123456789676	0.00	10.00	379
OUD BEERSEL BERSALIS TRIPEL OAK AGED BUT. 0,375 L	OUD BER TRI 375	5425018070763	0.50	10.00	380
TRZECH KUMPLI KIOKIO BUT. 0,5 L	TR KIO	5905669479745	0.77	10.00	381
MAREDSOUS 8% BRUNE BUT. 0,33 L	MARE BRU 330	5411681037004	0.50	10.00	382
PINTA BARREL BREWING INFLAME 12,0° BUT. 0,750 L	PBB_INFL_BUT_750	5904335577624	0.00	10.00	383
ALEBROWAR CRAZY MIKE BUT. 0,5 L	ALE CRA	5903364108359	0.77	10.00	384
PIWNE PODZIEMIE GEORGIA PEACH MOCHI PUSZKA 0,5 L	POD_GEO_PUSZ_500	5904305482736	0.54	10.00	385
WESTMALLE TRIPEL BUT. 0,33 L	WESTMA TRI 330	5412343201337	0.50	10.00	386
KWAREMONT PITTING BLOND BUT. 0,33 L	KWA PIT BLO 330	5411831000957	0.50	10.00	387
CHYLICZKI CYDR SWEET OAK 2018 BUT. 0,5 L	CHYL SWE OAK 500	5905279058217	0.77	10.00	388
LINDEMANS APPLE TAP HANDLE	LIND TAP HAN APP	5123456791354	0.00	10.00	389
ARTEZAN SO EASY BUT. 0,5 L	ART_SO_EAS_BUT_500	5904708750814	0.77	10.00	390
WRКЇEL HEFEWEIZEN PSZENICZNE JASNE BUT. 0,5 L	WRE HEF	5904730465045	0.77	10.00	391
SMYKAN CYDR CHMIELONY SAD KEG 30 L	SMYK CHM K	5123456791297	32.00	10.00	392
MALTGARDEN WINDOW BLINDS DOWN BUT. 0,5 L	MALT WIN	5907710943298	0.77	10.00	393
LITOVEL ИERNY CITRON 4% KEG 30 L	LIT_CER_CITR_KEG_30	\N	32.00	10.00	394
LA CORNE BLONDE BUT. 0,33 L	LA COR BLO	5425026610005	0.50	10.00	395
CIESZYN WHEAT WINE BUT. 0,33 L	CIE WHE WIN	5907612240341	0.50	10.00	396
PETRUS RED CZAPKA Z DASZKIEM	PET RED CZA DAS	5123456791376	0.00	10.00	397
SCHLENKERLA RAUCHBIER MДRZEN KEG 30 L	SCH MAR K	5123456789425	32.00	10.00	398
MARYENSZTADT THE ROOTS#5 PUSZKA 0,5 L	MAR THE ROO#5	5905669542074	0.54	10.00	399
SCHNEIDER WEISSE BLACHA REKLAMOWA	SCH WEI BLA REK	5123456791345	0.00	10.00	400
GRYBУW PILSVAR GУRALSKIE BUT. 0,5 L	GR GУR	5902516000411	0.77	10.00	401
ROCKMILL SOURLAND #2 PUSZKA 0,5 L	ROCK_SOU_#2_PUSZ_500	5908291862732	0.54	10.00	402
PETRUS BLACHA REKLAMOWA	PET BLA REK	5123456791101	0.00	10.00	403
BIRBANT DRONIC PUSZKA 0,5 L	BI DRO	5904041703621	0.54	10.00	404
HANSSENS OUDE GUEUZE BUT. 0,75 L	HANS GUE 750	5430000304016	1.10	10.00	405
NEPOMUCEN SHORELINE BUT. 0,5 L	NE_SHO_BUT_500	5905191386481	0.77	10.00	406
LINDEMANS TAROT NOIR MEDALION RYBIE OKO	LIND_TAR_NOIR_MED	\N	0.00	10.00	407
ARTEZAN SAMIEC ALFA 2023 SOCIAL VANILLA BUT. 0,5 L	ARTEZ_SAM_2023_SOC_VAN_BUT_500	5904708750678	0.77	10.00	408
PINTA Psst... It's Your Weekend IPA - West Coast IPA 15,0° keg 30 l	PI_PSST_YOU_WEST_KEG_30	5123456780039	0.00	10.00	409
CA' DEL BRADO PIE VELOCE BRUX CASCADE - BRETT ALE BUT. 0,375 L	CDB_PIA_VEL_LAM_BUT_375	\N	0.50	10.00	410
RADUGA UNEXPECTED GUESTS BUT. 0,5 L PROMOCJA (do 13.09.23)	RADU UNE_PROM	\N	0.00	10.00	411
DRY& BITTER BLACHA REKLAMOWA	DRY BIT BLA REK	5123456791365	0.00	10.00	412
STU MOSTУW X MOERSLEUTEL MADNESS PUSZKA 0,33 L	STU_MAD_PUSZ_330	5907614682750	0.35	10.00	413
BOON OUDE GUEUZE BLACK LABEL N*8 BUT. 0,75 L	BOON BLA LAB N*8	5412783152787	1.10	10.00	414
MARYENSZTADT KLASYCZNIE KOЏLAK BUT. 0,5 L	MAR KLA KOЏ	5903424615001	0.77	10.00	415
KASTEEL XTRA BUT. 0,33 L	KAST XTRA	5411081009007	0.50	10.00	416
CHIMAY 150 / SPЙCIALE CENT CINQUANTE BUT. 0,75 L	CHIM 150 CINQ 750	5410908100149	1.10	10.00	417
TOOL TAP HANDLE	TOOL TAP HAN	5123456791006	0.00	10.00	418
MOCZYBRODA ЇAR TROPIKУW BUT. 0,5 L	MOCZY ЇAR	5903351761079	0.77	10.00	419
ST. HUBERTUS TRIPLE BLONDE BUT. 0,33 L	STH TRI BLO 330	5413982600000	0.50	10.00	420
PODGУRZ IMPERIALNY 652 M N.P.M BUT. 0,5 L	POD_IMP_652_BUT_500	5906874055373	0.77	10.00	421
MARYENSZTADT KLASYCZNIE CZESKA DESITKA BUT. 0,5 L	MAR_KLA_CZ_DES_BUT_500	5905669542586	0.77	10.00	422
KOMES WYMRAЇANY PORTER MALINOWY WHISKEY BA BUT. 0,33 L	KOM_WYM_POR_MAL_BUT_330	5902838991541	0.50	10.00	423
ARTEZAN WITAM BUT. 0,5 L	ARTEZ WIT	5904730574211	0.77	10.00	424
MARYENSZTADT BY THE WAY BUT 0,5 L	MAR BY THE	5903678022372	0.00	10.00	425
NEPOMUCEN LOST BUT FOUND KEG 20L	NE_LOS_BUT_FOUN_20	\N	0.00	10.00	426
NEPOMUCEN D-TONACJA 2023 PUSZKA 0,33 L	NE_DET_23_PUSZ_330	5905191386566	0.35	10.00	427
MIO MIO GUARANA GRANAT BUT. 0,5 L	MIO_MIO_GUA_GRA_BUT_500	4002846034788	0.77	10.00	428
FORTUNA CZARNE WHISKY WOOD BUT. 0,5 L	MIЈ FOR CZA WHI	5902838990544	0.77	10.00	429
KEG SCHNEIDER 20 L	KEG SCH	5123456792020	0.00	10.00	430
STRAFFE HENDRIK TRIPLE BUT. 0,33 L	KAT06217	5425017240457	0.50	10.00	431
SMYKAN CYDR KWAЊNY ZDZICHU KEG 30 L	SMYK KWA K	5123456791300	32.00	10.00	432
KRAJAN IRLANDZKIE JASNE BUT. 0,5 L	KRA IRL JAS	5907582579434	0.77	10.00	433
TOOL THROUGH THE EYES OF MORTALS BUT. 0,75 L	KAT06747	5711474009936	1.10	10.00	434
PRAIRIE BIRTHDAY BOMB! - BARREL AGED BUT. 0,355 L	PRAI BIR BA	680132989260	0.00	10.00	435
GRYFUS SEDINA BUT. 0,5 L	GRY SED	5907222685174	0.77	10.00	436
ANDERSON JEAN GINIE TEQUILA BA BUT. 0,33 L	AND JG TEQU 330	4744175010995	0.50	10.00	437
JURAJSKIE RУЇOWA PANTERA BUT. 0,5 L	JUR RУЇ	5905331026048	0.77	10.00	438
DUGGES BLOOM PUSZKA 0,33 L	DUGG_BLOO_PUSZ_330	7350038225948	0.35	10.00	439
RACIBORSKIE RADLER GREJPFRUT BEZALKOHOLOWE ZW BUT. 0,5 L	RAC_RAD_GRE_BEZ_ZW_BUT_500	5907506252528	0.77	10.00	440
GWAREK ORCHARD BLEND PUSZKA 0,5 L	GW_ORC_PUSZ_500	5903938751707	0.54	10.00	441
STAROPOLSKIE PRL PIWO JASNE 0,5 L	STAR PRL JAS	5905669086257	0.00	10.00	442
PINTA Psst... It's Your Weekend IPA - Foggy IPA 15,0° keg 30 l	PI_PSST_YOU_FOGG_KEG_30	5123456780050	0.00	10.00	443
DUVEL OTWIERACZ	KAT06151	5123456791200	0.00	10.00	444
ZA MIASTEM SIЈA WOLI BUT. 0,33 L	ZAM_SIЈ_WOL_BUT_330	5904905630070	0.50	10.00	445
HANSSENS OUDE KRIEK BUT. 0,375 L	HANS KRI 375	5430000304047	0.50	10.00	446
SMYKAN CYDR ANTONI WISIENKA KEG 30 L	SMYK ANT K	5123456791293	32.00	10.00	447
BROWAR JANA WEIZEN MARAKUJA BUT. 0,5 L	BRO_JA_WEI_MAR_BUT_500	5902429981449	0.77	10.00	448
NEPOMUCEN HENRYK PUSZKA 0,5 L	NE HENRYK	5905191386399	0.54	10.00	449
BROWAR JANA COLD IPA BUT. 0,5 L	BRO_JA_COLD_IPA_BUT_500	5902429981548	0.77	10.00	450
BOSTEELS PAUWEL KWAK POKAL 0,33 L	360	5123456791081	0.00	10.00	451
MIKKELLER RUNNING CLUB SPODNIE CZARNE (L)	MIK SPOD L	5123456791116	0.00	10.00	452
KASTEEL BARISTA CHOCOLATE QUAD BUT. 0,33 L	KAST BAR	5411081005696	0.50	10.00	453
MARYENSZTADT WILD & FUNKY WILD QUADRUPEL RIOJA BARREL AGED PUSZKA 0,44 L	MAR WIL FUN QUA	5903678022518	0.48	10.00	454
KORMORAN BEZGLUTENOWE BUT. 0,5 L	KORM BEZ	5902528442230	0.77	10.00	455
STAROPOLSKIE MY WAY DOUBLE WEST COAST IPA BUT. 0,5 L	STAR_MY_WAY_ DWCIPA_BUT_500	5903021505767	0.77	10.00	456
CA' DEL BRADO ANNIVERSARIO 2020 BUT. 0,375 L	CDB ANN 2020	5123456790119	0.50	10.00	457
VAL-DIEU BLONDE BUT. 0,33 L	VAL BLO 330	5413977000013	0.50	10.00	458
HOFSTETTNER GRANITBOCK ICE BUT. 0,33 L	HOFS GRA ICE	9007293384030	0.50	10.00	459
MATE - MATE BUT. 0,5 L	MIO_MAT_MAT_BUT_500	4260310557410	0.77	10.00	460
BUTELKA ZWROTNA RACIBУRZ 0,5 L	BUT ZWR RAC	\N	0.00	10.00	461
LINDEMANS KRIEK CUVEE RENE BUT. 0,75 L	LIND KRIE CUV 750	5411223020778	1.10	10.00	462
PIWNE PODZIEMIE PHANTASMIC REALITY KEG 30 L	POD_PHA_REA_KEG_30	\N	32.00	10.00	463
RACIBORSKIE KLASYCZNE BUT. 0,5 L	RAC KLA	5907506252726	0.77	10.00	464
LINDEMANS T-SHIRT MКSKI SZARY (L)	LIND_TSH_MКS_SZA_L	\N	0.00	10.00	465
ST. FEUILLIEN GRAND CRU BUT. 0,33 L	STF GRA CRU 330	5412138653310	0.50	10.00	466
PINTA Kwas Gamma 13,0° keg 30 l	PI Gam keg 30	5123456789703	0.00	10.00	467
KASTEEL DONKER/ TRIPEL PODKЈADKI	KAST DON TRI PODKЈ	5123456791337	0.00	10.00	468
PINTA Hop Selection - Simcoe can 0,5 l	PI_HS_SIM_CAN_500	5904165104786	0.00	10.00	469
CHIMAY RED BUT. 0,75 L	CHIM RED 750	5410908000043	1.10	10.00	470
MOERSLEUTEL 6Y MARGREET PUSZKA 0,44 L	OMB Moe Mar	8720615260522	0.48	10.00	471
FUNKY FLUID JAM SESSION PUSZKA 0,5 L	FF JAM P	5907772092279	0.54	10.00	472
CHIMAY BLUE BARRIQUE BUT. 0,375 L	CHIM BLE BAR 375	5410908002337	0.50	10.00	473
DZIKI WSCHУD TAREE'UUX PUSZKA 0,5 L	DZIKI_TAREE_PUSZ_500	5906874369210	0.54	10.00	474
MIKKELLER SPONTAN PASSION FRUIT BUT. 0,375 L	MIK SPON PASS 375	818534018732	0.50	10.00	475
KEG AYINGER / HOSL 30 L	KEG AYI	5123456792012	0.00	10.00	476
KEG LINDEMANS 20/25 L	KEG LIND	5123456792018	0.00	10.00	477
KINGPIN FREE RIDE PUSZKA 0,5 L	KIN_FRE_PUSZ_500	5904730290272	0.54	10.00	478
DWIE WIEЇE FLANDERS FA + BA BUT. 0,33 L PROMOCJA (do 30.09.23)	DW FLA FA BA_PROM	\N	0.00	10.00	479
JUPILER NA BUT. 0,25 L PROMOCJA (do 25.09.23)	JUP 250_PROM	\N	0.00	10.00	480
JUPILER KEG 6 L	JUP K 6 L	5410228177494	0.00	10.00	481
PINTA Beskidy Pils 12,0° keg 30 l	PI Bes Pil keg 30	5123456789672	0.00	10.00	482
BOON GEUZE SELECTION KEG 20 L	BOON GEU SEL K 20L	\N	21.50	10.00	483
ARTEZAN JARDIN DU CHВTEAU FRAISE BUT. 0,375 L	ART_JAR_FRA_BUT_375	5904708750623	0.50	10.00	484
FUNKY FLUID FUSION: TANKBUSTERS PUSZKA 0,5 L	FF_FUS_TAN_PUSZ_500	5903999514358	0.54	10.00	485
CA' DEL BRADO U BACCABIANCA - ITALIAN GRAPE ALE BUT. 0,375 L	CDB_U_BACCABIA_BUT_375	\N	0.50	10.00	486
LINDEMANS TAROT BLACHA	LIND_TAR_BLA	\N	0.00	10.00	487
PINTA Koszulka HC czarna 2XL	PINTA Kosz HC czar 2XL	5904165102966	0.00	10.00	488
GUMMARUS POKAL 0,33 L	351	5123456791085	0.00	10.00	489
PINTA Hazy Delivery 15,0° can 0,5 l	PI_HAZ_DEL_CAN_500	5904165103840	0.00	10.00	490
CORSENDONK PATER BUT. 0,75 L	COR PAT 750	5411491011157	1.10	10.00	491
3 FONTEINEN FRAMBOOS OOGST 2017 BUT. 0,75 L	3 FON FRA OOG 17 750	5425007818116	1.10	10.00	492
MONVIN KIELISZEK 0,1 L	MON_KIEL_100	5123456791449	0.00	10.00	493
MAGIC ROAD WON’T YOU TELL ME YOUR NAME? PUSZKA 0,5 L	MR_WON_TOU_PUSZ_500	5905204130605	0.54	10.00	494
BIRRA MANIA SICILIAN IPA BUT. 0,33 L	BM SIC	5907694918411	0.50	10.00	495
FILOMELOS CYDR PУЈ WYTRAWNY BUT. 0,75 L	FIL_CYD_PУЈ_BUT_750	5900168509092	1.10	10.00	496
LINDEMANS PECHERESSE TAP HANDLE	LIND PEC TAP HAN	5123456791013	0.00	10.00	497
VEDETT EXTRA ORDINARY IPA BUT. 0,33 L	VED EO IPA 330	5411681401775	0.50	10.00	498
CHYLICZKI CYDR LODOWY BUT. 0,375 L	CHYL LOD 375	5905279058040	0.50	10.00	499
PINTA Bluza bordowa S	PINTA Blu bor S	5904165100566	0.00	10.00	500
PINTA Otwieracz magnes IIPPAA	PINTA Otw mag IIP	5904165101624	0.00	10.00	501
FILOMELOS PERRY HULAJ GRUSZKA BUT. 0,33 L	FIL_PER_GRU_BUT_330	5900168509108	0.50	10.00	502
TOOL BLACHA REKLAMOWA	TOOL BLA REK	5123456791380	0.00	10.00	503
RADUGA NOSFERATU PUSZKA 0,5 L	RADU_NOS_PUSZ_500	5902176772024	0.54	10.00	504
POKAL DUBBEL CIESZYСSKI 0,4 L	POKAL DUB	5123456791316	0.00	10.00	505
LINDEMANS FARO TAP HANDLE	LIND FAR TAP HAN	5123456791016	0.00	10.00	506
ST. BERNARDUS ABT 12 BUT. 0,75 L	STB 12 750	5411911000310	1.10	10.00	507
MARYENSZTADT NEW BLACK - OAT STOUT CZEKOLADOWA PRALINA Z WIЊNIҐ BUT. 0,5 L	MAR NEW PRA WIЊ	5903424615933	0.77	10.00	508
PIRAAT TRIPLE HOP BUT. 0,33 L	PIR TRI HOP 330	5411663004772	0.50	10.00	509
LINDEMANS GUEUZE SZKLANKA 0,25 L	226	5123456791039	0.00	10.00	510
FUNKY FLUID MODERN POLISH IPA PUSZKA 0,5 L	FF_MOD_POL_PUSZ_500	5903999510510	0.54	10.00	511
MIKKELLER SPONTAN TRIPPLE CHERRY 2020 BUT. 0,375 L	MIK SPON TRI CHE 2020 375	5704255121095	0.50	10.00	512
P?HJALA LAAGER PUSZKA 0,44 L	POH LAA	4742976014082	0.48	10.00	513
KORMORAN CORNUS LUPUS BUT. 0,375 L	KORM COR LUP	5902528000553	0.50	10.00	514
TANKBUSTERS THIRD BIRTHDAY AND HOMIES X MOONLARK PUSZKA 0,5 L	TB_THI_MOO_PUSZ_500	5904365781473	0.54	10.00	515
KOMES BARLEY WINE BUT. 0,5 L	MIЈ KOM BAR	5902838990285	0.77	10.00	516
STAROPOLSKIE KULTOWE PROZDROWOTNE 0,0% BUT. 0,5 L PROMOCJA (do 21.10.23)	STAR KUL PRO_PROM	\N	0.00	10.00	517
JAN OLBRACHT CУRA KORYNTU BUT. 0,5 L	JO CУR	\N	0.77	10.00	518
LUBROW ZOMBIE SABRO IPA PUSZKA 0,33 L	LUB_ZOM_PUSZ_330	5903686842849	0.35	10.00	519
LINDEMANS POKAL SENSORIK 200 ANNIVERSARY 0,25 L	LIND POK SEN 200 ANN 250	5123456791132	0.00	10.00	520
ЈAСCUT ZAPOMNIANY DIABEЈ BUT. 0,33 L	LAN ZAP	5906395997879	0.50	10.00	521
TRZECH KUMPLI HOPPY WEIZEN KEG 30 L	TR_HO_WEI_KEG_30	\N	32.00	10.00	522
BROKREACJA ORIGAMI PANDA BUT. 0,5 L	BR_ORG_BUT_500	5904422197933	0.77	10.00	523
ROCKMILL INFINITY ARMAGNAC BA BUT. 0,5 L	ROCK_INF_ARM_BA_BUT_500	5908291862305	0.77	10.00	524
BROWAR JANA SZKLANKA 0,5 L	BRO_JA_SZKL_500	\N	0.00	10.00	525
TRZECH KUMPLI MISTY PUSZKA 0,5 L	TR MIS P	5904252699065	0.54	10.00	526
CIESZYN SZKLANKA WEIZEN 0,5 L	CIE SZK WEI 0,5	5123456789851	0.00	10.00	527
STAROPOLSKIE KULTOWE BEZ GLUTENU BUT. 0,5 L	STAR KUL BEZ	5905669086943	0.77	10.00	528
PINTA Collab Dois Corvos - Magnetic Poles 22,0° can 0,44 l	PI_MAG_POL_CAN_440	5600701480467	0.00	10.00	529
ЈAСCUT RAJSKY PLYN BUT. 0,5 L	LAN RAJ	5906395997473	0.77	10.00	530
STAROPOLSKIE DWORSKIE BUT. 0,5 L	STAR DWO	5903111989811	0.77	10.00	531
CHIMAY KIELICH W PUDEЈKU 0,33 L	KAT06696	5123456791185	0.00	10.00	532
VAL-DIEU BIERE DE NOЛL BUT. 0,75 L	VAL NOE 750	5413977000259	1.10	10.00	533
STU MOSTУW IMPERIAL STOUT VANILLA  BOURBON B.A. NITRO BUT. 0,33 L	STU IMP STO VAN BOU	5907614680879	0.50	10.00	534
STU MOSTУW LAST MINUTE PUSZKA 0,44 L	STU_LAST_PUSZ_440	5907614683177	0.48	10.00	535
MAGIC ROAD PRETTY STRAWBERRY, CHERRY, BLACKCURRANT & MAPLE SYRUP PUSZKA 0,5 L	MR_PRE-STR-CHE-BLA_PUSZ_500	5905204130919	0.54	10.00	536
KAZIMIERZ LATAJҐCY JELEС BARREL AGED BUT. 0,33 L	KAZ LAT BA	5906660570332	0.50	10.00	537
STU MOSTУW LAST RESORT PUSZKA 0,33 L	STU LAS	5907614682507	0.35	10.00	538
PINTA Psst... It's Your Weekend IPA - Cold IPA 15,0° keg 30 l	PI_PSST_YOU_COLD_KEG_30	5123456780030	0.00	10.00	539
VIGO Kombucha BIO Rуїa but. 0,33 l	VIG_KOM_BIO_RУЇ_BUT_330	5902768514346	0.00	10.00	540
PINTA Angielskie Њniadanie 14,0° but. 0,5 l	PI Ang	5904165100849	0.00	10.00	541
ST. BERNARDUS WATAU KIELICH 0,5 L	KAT06911	5123456791173	0.00	10.00	542
NEPOMUCEN SQUASH PUSZKA 0,5 L	NE_SQU_PUSZ_500	5905191386955	0.54	10.00	543
MALTGARDEN ENDLESS PARTY PUSZKA 0,5 L	MA_END_PAR_PUSZ_500	5904050721968	0.54	10.00	544
DUVEL POKAL 0,33 L	294	5123456791095	0.00	10.00	545
ST. BERNARDUS WATAU KIELICH  0,25 L	605	5123456791175	0.00	10.00	546
SCHNEIDER WEISSE KUFEL CERAMIKA 0,5 L	SCHNE KUF CER 0,5	5123456791255	0.00	10.00	547
LINDEMANS CASSIS TAP HANDLE	LIND TAP HAN CAS	5123456791017	0.00	10.00	548
RADUGA IS THIS THE REAL LIFE? PUSZKA 0,5 L	RAD_IS_REA_PUSZ_500	5902176772017	0.54	10.00	549
STU MOSTУW AMERICAN IPA BUT. 0,5 L	STU AME IPA	5905279213210	0.77	10.00	550
LA TRAPPE ZESTAW (6X BUT. 0,33L WITTE/BLOND/DUBBEL/ISID`OR/TRIPEL/QUADRUPEL)	TRAP ZEST 6X330	8711406344248	0.00	10.00	551
FUNKY FLUID FREE GELATO: PINA COLADA PUSZKA 0,5 L	FF FRE GEL PIN	5903999512545	0.54	10.00	552
LEELANAU / EVIL TWIN / JOLLY PUMPKIN THE DOGMATIST BUT. 0,375 L	LEE DOG	5123456790146	0.50	10.00	553
JAN OLBRACHT LEGENDY POLSKIE: CZART BUT. 0,33 L	JO LP CZA	5902627012235	0.50	10.00	554
ALCORYTHM® TACA 20 SZT.	ALCO 20	2590745162104	0.00	10.00	555
90 BPM L'AUTRE GANDALF KEG 30 L	90 BPM LAU GAN KEG 30	\N	32.00	10.00	556
ARTEZAN PAKIET POWITALNY BUT. 0,5 L	ART_PAK_POW_BUT_500	5904708750760	0.77	10.00	557
WRКЇEL CHERRY WILD BARREL AGED BUT. 0,33 L	WRE CHE WIL BA	5904730465984	0.50	10.00	558
RADUGA WAKE ME! PUSZKA 0,5 L	RAD_WAK_PUSZ_500	5902176772048	0.54	10.00	559
SOWIE PSZENICZNE BUT. 0,5 L	SOW_PSZEN_BUT_500	5907222560037	0.77	10.00	560
MAGIC ROAD BEYOND TIME PUSZKA 0,5 L	MR_BEY_TIM_PUSZ_500	5905204131244	0.54	10.00	561
ZA MIASTEM PEЈNIA ЇYCIA BUT. 0,5 L	ZAM PEЈ ЇYC	5906874605479	0.77	10.00	562
ALEBROWAR MINT OF CHANGE - MOHITO BUT. 0,5 L	ALE_MIN_OF_CHAN_BUT_500	5907771343389	0.77	10.00	563
3 FONTEINEN KRYSZTAЈOWY KIELISZEK 0,33 L	KAT06397	5123456791155	0.00	10.00	564
PETRUS BLOND BUT. 0,75 L	PET BLO 750	875213000228	1.10	10.00	565
MIЈOSЈAW PILZNER BUT. 0,5 L	MIЈ PIL	5902709615323	0.77	10.00	566
FUNKY FLUID YUZUALLY PUSZKA 0,5 L	FF_YUZ_PUSZ_	5903999513764	0.54	10.00	567
SARABANDA BACK TO THE ROOTS PUSZKA 0,5 L PROMOCJA (do 05.10.23)	SARA BAC_PROM	\N	0.00	10.00	568
TRZECH KUMPLI IMPERIAL GRAFF GRODZISKIE PUSZKA 0,5 L	TR_IMP_GRAF_GRODZ_PUSZ_500	5904252699843	0.54	10.00	569
JURAJSKIE AMERYKAСSKA PSZENICA BUT. 0,5 L	JUR AME	5905331025355	0.77	10.00	570
INNE BECZKI BLACK SANDS BUT. 0,5 L	IN_BLA_SAN_BUT_500	5901122234807	0.77	10.00	571
TRZECH KUMPLI PAN IPANI PUSZKA 0,5 L	TR PAN P	5904252699041	0.54	10.00	572
CIESZYN WILD ALE B.A. BUT. 0,33 L	CIE WIL	5907612240747	0.50	10.00	573
FUNKY FLUID HITS FROM THE BONG BUT. 0,5 L	FF HIT	5903999510459	0.77	10.00	574
DZIK CYDR PУЈSЈODKI BUT. 0,5 L	DZIK_CYD_PУЈ_BUT_500	5906395413485	0.77	10.00	575
AMAGER / DБDIVA VIEWPOINT BUT. 0,33 L	AMAG VIE	5704603303005	0.50	10.00	576
PINTA SZKLANKA PM 2023 0,5 L	PINTA_SZK_PM_2023	\N	0.00	10.00	577
WRКЇEL COOLIBER BUT. 0,5 L	WRE COO	5904730465939	0.77	10.00	578
NEPOMUCEN WALKING KEYS PUSZKA 0,5 L	NE_WALK_KEY_PUSZ_500	5905701060078	0.54	10.00	579
STU MOSTУW ART+66 DOUBLE NEIPA PUSZKA 0,44 L	STU_ART66_PUSZ_440	5907614682941	0.48	10.00	580
MOON LARK SILK. HEFEWEIZEN PUSZKA 0,5 L	ML_SIL_PUSZ_500	5905255346369	0.54	10.00	581
TRZECH KUMPLI UNPLUGGED NITRO OATMEAL STOUT BUT. 0,5 L	TR UNP NIT STO	5905669479844	0.77	10.00	582
MOON LARK / PINTA STAY HERE #3 14,0° CAN 0,5 L	PI_STA_#3_PUSZ_500	5905255346512	0.00	10.00	583
BROKREACJA WHERE IS LEITMOTIV? GUAVA-ANANAS BUT. 0,5 L	BR_WHE_LEI_GUA-ANA_BUT_500	5904422197926	0.77	10.00	584
TARNOBRZEG GANGSTAR BUT. 0,5 L	TAR_GANG_BUT_500	5903661867768	0.77	10.00	585
ST. FEUILLIEN KIELICH 0,33 L	STF KIEL 330	5123456791176	0.00	10.00	586
LINDEMANS METALOWE PUDEЈKO PREZENTOWE	KAT03218	5123456791126	0.00	10.00	587
ALEBROWAR PEACHOLINA BUT. 0,5 L	ALE PEACH	5907771340685	0.77	10.00	588
CHYLICZKI PERRY 2021 BUT. 0,75 L	CHYL PER 750	5905279058170	1.10	10.00	589
ST. FEUILLIEN BLONDE BUT. 0,75 L	STF BLO 750	5412138107554	1.10	10.00	590
PINTA T-shirt biaіy duїe logo XL	PINTA Kos DL bia XL	5904165102478	0.00	10.00	591
FUNKY FLUID GELATO: BERRIES & CREAM PUSZKA 0,5 L	FF_GEL_BER_CRE_500	5903999510107	0.54	10.00	592
BЈONIE KUR ZAPIAЈ PUSZKA 0,5 L	BЈO KUR P	5908258856903	0.54	10.00	593
ZA MIASTEM PEЈNIA SZCZКЊCIA BUT. 0,5 L	ZAM_PEЈ_SZCZ_BUT_500	5904905630124	0.77	10.00	594
TRZECH KUMPLI CALIFIA PUSZKA 0,5 L	TR CAL P	5904252699058	0.54	10.00	595
DZIKI WSCHУD CZAJ APACZA BUT. 0,5 L	DZIKI CZA	5906874369326	0.77	10.00	596
PIWNE PODZIEMIE KOSIARZ UMYSЈУW BOURBON OAK CHIPS X VANILLA BUT. 0,33 L	POD_KOS_BO_CHI_VAN_BUT_330	5904305482613	0.50	10.00	597
DE MOLEN OP & TOP BUT. 0,33 L	KAT06269	8717624421020	0.50	10.00	598
ARTEZAN LATARNIA MORSKA BUT. 0,5 L	ART_LAT_MOR_BUT_500	5904708750807	0.77	10.00	599
PINTA Hazy Discovery Sofia keg 30 l	PI_HD_SOF_KEG_30	5123456780020	0.00	10.00	600
FUNKY FLUID TRIPLE GELATO: VERDE PUSZKA 0,5 L	FF_TRI_GEL_VERD_PUSZ_500	5903999514525	0.54	10.00	601
STAROPOLSKIE BESTBIR TRUSKAWKA BUT. 0,5 L	STAR BES TRU	5903021501097	0.77	10.00	602
WIDAWA TROPICAL STORM BUT. 0,5 L	WID TRO 500	5907710904039	0.77	10.00	603
STAROPOLSKIE NIEMDЈE PSZENICZNE BUT. 0,5 L	STAR NIE PSZ	5903021503343	0.77	10.00	604
FLOREFFE POKAL  0,25 L	381	5123456791092	0.00	10.00	605
ST. BERNARDUS WIT PUSZKA 0,33 L	STB WIT P	5411911003359	0.35	10.00	606
NEPOMUCEN FRUITLAND PUSZKA 0,5 L	NE_FRU_PUSZ_500	5905191386900	0.54	10.00	607
FORTUNA WIЊNIOWA BUT. 0,5 L	MIЈ FOR WIЊ	5902709615200	0.77	10.00	608
LINDEMANS GUEUZE BUT. 0,25 L	LIND GUE 250	5411223101002	0.35	10.00	609
INNE BECZKI NEIPARADISE PUSZKA 0,5 L	INNE NEI	5903661281427	0.54	10.00	610
SCHNEIDER LOVE BEER 11,5° BUT. 0,5 L	Schn Lov	4003669016692	0.77	10.00	611
SCHNEIDER WEISSE SZKLANKA WEIZEN 0,5 L	SCHN SZKL	5123456791260	0.00	10.00	612
KEG BELGIA A5	KAT03714	5123456792003	0.00	10.00	613
CHYLICZKI CYDR ALWA BUT. 0,75 L	CH_CYD_ALW_BUT_750	5905279058262	1.10	10.00	614
PINTA Koszulka szara M	PINTA Kos sza M	5904165101266	0.00	10.00	615
MALTGARDEN I'M YOUR BARISTA / PANAMA GEISHA FINCA DEBORAH NIRVANA PUSZKA 0,5 L	MALT BAR PAN GEI FIN	5904050721234	0.54	10.00	616
MOON LARK REEF. HAZY IPA PUSZKA 0,5 L	ML REE	5905255346048	0.54	10.00	617
WIDAWA CHRZҐSTAWSKI LAGER BUT. 0,5 L	WID CHR LAG	5907710904206	0.77	10.00	618
TRYBUNAЈ PILS BUT. 0,5 L	TRY_PIL_BUT_500	5905689308124	0.77	10.00	619
DUBUISSON RASTA TROLLS BUT. 0,33 L	DUB BUS RAST 330	5411551171074	0.50	10.00	620
TRZECH KUMPLI PILS BUT. 0,33 L	TR_PIL_BUT_330	5904252699744	0.50	10.00	621
MALTGARDEN FUNKY GARDEN VOL. 8  PUSZKA 0,5 L	MALT FUN VOL.8	5904050721128	0.54	10.00	622
PRAIRIE BOMB! DECONSTRUCTED: VANILLA BUT. 0,355 L	PRAI DEC VAN	680132989055	0.00	10.00	623
MARYENSZTADT BEZGLUTENOWY OATMEAL STOUT BUT. 0,5 L	MAR BEZ OEA STO	5903678022549	0.77	10.00	624
SCHLENKERLA RAUCHBIER EICHE VINTAGE 2018 19,9° BUT. 0,5 L	SCH EIC VIN 2018	\N	0.77	10.00	625
MAGIC ROAD BOCK LORD HALLELUJAH PUSZKA 0,44 L	MR_BOC_LOR_PUSZ_440	5905204130216	0.48	10.00	626
RECRAFT JUICE SOUR SERIES – BLACK FRUITS PUSZKA 0,5 L	REC_JUI_BLA_PUSZ_500	5904730663793	0.54	10.00	627
PIWNE PODZIEMIE KRAUTROCK BUT. 0,5 L	POD_KRA_BUT_500	5904305482767	0.77	10.00	628
ALEBROWAR SINGLE HOP NECTARON HAZY IPA BUT. 0,5 L	ALE_SH_NEC_BUT_500	5907771342979	0.77	10.00	629
ARTEZAN UЊMIECH BOMBELKA BANAN-BRZOSKWINIA-TRUSKAWKA PUSZKA 0,5 L	ART_UЊM-BAN-BRZ-TRU_PUSZ_500	5904708750272	0.54	10.00	630
CHIMAY TRIPLE BUT. 0,75 L	CHIM TRI 750	5410908000135	1.10	10.00	631
NEPOMUCEN HEAT PUSZKA 0,5 L	NE HEA	5904041706684	0.54	10.00	632
SAMUEL SMITH ORGANIC CHOCOLATE STOUT BUT. 0,355 L	SS OCS	5010149201171	0.00	10.00	633
PINTA Party Starter Session IPA 12,0° keg 30 l	PI_PAR_STA_SES_KEG_30	5123456780016	0.00	10.00	634
MIЈOSЈAW BEZALKOHOLOWE IPA PUSZKA 0,5 L	MIЈ BEZ IPA P	5902838990575	0.54	10.00	635
MAGIC ROAD COLOURS: JUST PINK PUSZKA 0,5 L	MR_COL_JUS_PIN_PUSZ_500	5905204131008	0.54	10.00	636
ARTEZAN JASNE ROZUMIEM BUT. 0,5 L	ART_JAS_BUT_500	5904708750593	0.77	10.00	637
ALEBROWAR SINGLE HOP AMORA PRETA BUT. 0,5 L	ALE_SH_AMO_BUT_500	5907771343235	0.77	10.00	638
LUBROW TARNICA 1346 PUSZKA 0,33 L	LUB_TAR_PUSZ_330	5903686842931	0.35	10.00	639
Ca' del Brado / PINTA Barrel Brewing Copernicana 8,5° but. 0,375 l	PBB Cop	\N	0.00	10.00	640
LA TRAPPE BLONDE BUT. 0,33 L	TRAP BLO 330	8711406032602	0.50	10.00	641
PINTA Otwieracz magnes Beskidy	PINTA Otw mag Bes	5903990622588	0.00	10.00	642
LUPULUS ORGANICUS BUT. 0,75 L	LUP ORG 750	5425025126002	1.10	10.00	643
FUNKY FLUID KALIMERA PUSZKA 0,5 L	FF_KAL_PUSZ_500	5903999514631	0.54	10.00	644
ST. FEUILLIEN TRIPEL BUT. 0,33 L	STF TRI 330 ml	5412138403311	0.50	10.00	645
P?HJALA ORANGE GOSE PUSZ. 0,33 L PROMOCJA (do 12.10.23)	KAT06427_PROM	\N	0.00	10.00	646
RODENBACH CLASSIC BUT. 0,25 L	RODEN CLA 250	54125001	0.35	10.00	647
BROKREACJA THE ALCHEMIST BUT. 0,5 L	BRO ALC 0,5	5905669783033	0.77	10.00	648
ZAKЈADOWY BRAMA WJAZDOWA BUT. 0,5 L	ZAKЈ BRA	5906395388066	0.77	10.00	649
LOCO CANNABIS BUT. 0,33 L	BM LOC CAN	5907694918442	0.50	10.00	650
GRODZISKIE APA BUT. 0,5 L	MIЈ GRO APA	5905279533233	0.77	10.00	651
DELIRIUM TREMENS KEG 30 L	DEL TRE K 30	5123456789027	32.00	10.00	652
MOERSLEUTEL MUSCOVADO MAPLE MAGICIAN PUSZKA 0,44 L	OMB Moe Mus	8719992492763	0.48	10.00	653
MC CHOUFFE BUT. 0,75 L	MC CHOUF 750	5410769200095	1.10	10.00	654
JUDAS POKAL 0,33 L	1030	5123456791083	0.00	10.00	655
MAGIC ROAD HOT OR NOT? PUSZKA 0,44 L	MR_HOT_OR_PUSZ_440	5905204130896	0.48	10.00	656
FUNKY FLUID FOGGY PUSZKA 0,5 L	FF_FOG_PUSZ_500	5907772092408	0.54	10.00	657
MIKKELLER PUMA BOKSERKA SPORTOWA NIEBIESKA  (XL)	MIK PUM N XL	5123456791122	0.00	10.00	658
CA' DEL BRADO CUVЙE DE PESGA - PEACH SOUR ALE BUT. 0,375 L	CDB_CUV_PES_BUT_375	\N	0.50	10.00	659
TIMMERMANS FRAMBOISE BUT. 0,25 L	TIMM FRA 250	5411516010707	0.35	10.00	660
LUBROW FOREIGN EXTRA STOUT – NITRO CLASSIC ALES PUSZKA 0,33 L	LUB_FOR_PUSZ_330	5903686842795	0.35	10.00	661
CIESZYN ANGIELSKI LORD BUT. 0,33 L	CIE ANG LOR	5907612240198	0.50	10.00	662
3 FONTEINEN KRYSZTAЈOWY KIELISZEK ZENNE 0,645 L	KAT06720	5123456791154	0.00	10.00	663
PINTA Upgrade Your September 12,0° keg 30 l	PI_UPG_KEG_30	5123456780044	0.00	10.00	664
LUBROW AZEDO FRUTADO PUSZKA 0,33 L	LUB_AZE_PUSZ_330	5903686842191	0.35	10.00	665
STAROPOLSKIE BESTBIR PACIFIC BRZOSKWINIA BUT. 0,5 L	STAR BES PAC BRZ	5905669086677	0.77	10.00	666
RACIBORSKIE PYRSK JABЈKO-POMARAСCZA-IMBIR BUT. 0,33 L	RAC_PY_JAB_POM_IMB_BUT_330	5905249834070	0.50	10.00	667
SANTE ADAIRIUS FOUR LEGS GOOD BUT. 0,75 L	SANT FOU	5123456790148	1.10	10.00	668
LIMBURGSE WITTE MATA BAROWA	LIMB WIT MAT BAR	5123456791349	0.00	10.00	669
INNE BECZKI ZISSOU APA BUT. 0,5 L	INNE ZIS	5905669683012	0.77	10.00	670
ALEBROWAR CRAZY MIKE ICE PROJECT BUT. 0,25 L + KIELISZEK	ALE_CRA_ICE_BUT_250	5907771341378	0.00	10.00	671
LA TRAPPE ZESTAW (4x BUT. 0,33L QUADRUPEL/ISID'OR/TRIPEL/DUBBEL + SZKЈO)	TRAP_ZEST_4X330	8711406009413	0.00	10.00	672
PRAIRIE PRISON RODEO BUT. 0,355 L	PRAI PRI	683318988415	0.00	10.00	673
ЈAСCUT PODCHMIELONY WOJOWNIK BUT. 0,5 L	LAN_POD_WOJ_BUT_500	5906395997985	0.77	10.00	674
WIDAWA FRUIT BOMB BUT. 0,5 L	WID FRU 500	5907710904060	0.77	10.00	675
FUNKY FLUID HONK PUSZKA 0,5 L	FF_HON_PUSZ_500	5903999514020	0.54	10.00	676
VIGO Kombucha BIO Acerola Imbir but. 0,33 l	VIG_KOM_BIO_ACE_IMB_BUT_330	5902768514308	0.00	10.00	677
DE MOLEN BLACHA REKLAMOWA	KAT06609	5123456791209	0.00	10.00	678
MIKKELLER SPONTAN DOUBLE CASSIS BUT. 0,375 L	MIK SPON DOU CAS 375	5704255118736	0.50	10.00	679
BACCHUS TABLICA REKLAMOWA	BACCH TAB REK	5123456791362	0.00	10.00	680
KAZIMIERZ GRUPA WZAJEMNEJ ADORACJI BUT. 0,5 L	KAZ_GRU_BUT_500	5906660570707	0.77	10.00	681
REVOLTA LEMON & EARL GREY AIPA BUT. 0,5 L	REV_LEM_EAR_BUT_500	5900470058004	0.77	10.00	682
DZIK CYDR SZKLANKA SHAKER 0,5 L	DZIK_CYD_SZKL_500	5123456791447	0.00	10.00	683
CORONADO STUPID STOUT BUT. 0,65 L	CORO STU	896311000019	0.00	10.00	684
FUNKY FLUID CHERRY PUSZKA 0,5 L	FF_CHE_PUSZ_500	5903999514068	0.54	10.00	685
NEPOMUCEN MILO BUT. 0,5 L	NE MIL	5905279959286	0.77	10.00	686
PIWOTEKA BARON OSTRКЇYСSKI  BUT. 0,5 L	PIW_BAR_OSTR_BUT_500	5905669428088	0.77	10.00	687
DUGGES TROPIC SHAKE PUSZKA 0,33 L	DUGG_TRO_SHA_PUSZ_330	7350038226624	0.35	10.00	688
TILQUIN OUDE GEWURZT A L'ANCIENNE BUT. 0,75 L	TIL OUD GEW	5425029530812	1.10	10.00	689
PINTA A ja pale ale 12,0° keg 30 l	PI Aja keg 30	5123456789653	0.00	10.00	690
MIO MIO LEMON BUT. 0,5 L	MIO_MIO_LEMO_BUT_500	4002846038915	0.77	10.00	691
MINISTER LUCKY GHOST BUT. 0,5 L	MIN_LUC_GH_BUT_500	5903351660068	0.77	10.00	692
KING MULE BUT. 0,33 L	KING MUL 330	5413699206519	0.50	10.00	693
SKRZYNKA NA PIWO CZECHY ( B )	SKRZ_CZ_BOZ	\N	0.00	10.00	694
ALEBROWAR BAЈTYCKI DZIAD WEIZEN BUT. 0,5 L	ALE BAЈ WEI	5907771342269	0.77	10.00	695
GOЊCISZEWO KOMTUR BUT. 0,5 L	GO_KOM_BUT_500	5903364108281	0.77	10.00	696
LIMBURGSE WITTE POKAL 0,33 L	LIMB WIT POK 330	5123456789853	0.00	10.00	697
KAZIMIERZ DOBRE TO TO WYSZЈO #2 BUT. 0,5 L PROMOCJA (do 19.10.23)	KAZ DOB #2_PROM	\N	0.00	10.00	698
VERHAEGHE DUCHESSE DE BOURGOGNE BUT. 0,25 L	VER DUCH 250	5411364151119	0.35	10.00	699
GOЊCISZEWO DRWAL AUSTRALIAN BUT. 0,5	GO_DRW_AUS_BUT_500	5903364108465	0.00	10.00	700
MAES SZKLANKA 0,33 L	255	5123456791036	0.00	10.00	701
P?HJALA MUST KULD BUT. 0,33 L	POH MUS	4742976010107	0.50	10.00	702
MOON LARK / PINTA STAY HERE #3 14,0° KEG 30 L	PI_STA_#3_KEG_30	\N	32.00	10.00	703
SOWIE PORTER BAЈTYCKI 22 BUT. 0,5 L	SOW_POR_22_BUT_500	5907222560334	0.77	10.00	704
PRZETWУRNIA CHMIELU TWIST #3 WIЊNIA PUSZKA 0,5 L	PCH_TWI#3_PUSZ_500	5905476980533	0.54	10.00	705
TRZECH KUMPLI PORTER BAЈTYCKI KEG 30 L	TR POR K	5123456789501	32.00	10.00	706
PRIMБTOR LEЋБK 11° KEG 30 L	PRI LEZ K	5123456789916	32.00	10.00	707
PETRUS TRIPEL BUT. 0,75 L	PET TRI 750	875213000099	1.10	10.00	708
DZIKI WSCHУD ZЈOTE KALESONY PUSZKA 0,5 L	DZIKI_ZЈO_KAL_PUSZ_500	5906874369951	0.54	10.00	709
ALEBROWAR HERR AXOLOTL WITH APRICOT BUT. 0,5 L	ALE_HER_APR_BUT_500	5907771343365	0.77	10.00	710
LINDEMANS ZIGZAG KORKOCIҐG W PUDEЈKU	KAT07003	5123456791128	0.00	10.00	711
HOLBA PREMIUM 12° BZW.  BUT. 0,5 L	HOL_PRE_BZW_BUT_500	8593875610112	0.77	10.00	712
PIWNE PODZIEMIE CHMIELOKRATA NELSON SAUVIN PUSZKA 0,5 L	POD_CHM_NEL_PUSZ_500	5904305482149	0.54	10.00	713
BROWAR JANA WEIZEN MANGO BUT. 0,5 L	BRO_JA_WEI_MAN_BUT_500	5902429981012	0.77	10.00	714
BЈONIE ZASIALI GУRALE BUT. 0,5 L	BЈO ZAS	5908258856095	0.77	10.00	715
ST. FEUILLIEN SAISON SZKLANKA 0,33 L	STF SAI SZKL	5123456791029	0.00	10.00	716
CIESZYN SOUR BARLEY WINE BARREL AGED BUT. 0,33 L	CIE SOU BAR BA	5905279156579	0.50	10.00	717
MAGIC ROAD PRETTY CHERRY, CRANBERRY, BLACKBERRY & ALMONDS PUSZKA 0,5 L	MR_PRE-CHE-CRA-BLA-ALM_PUSZ_500	5905204130810	0.54	10.00	718
DZIKI WSCHУD POMA RANCZO BUT. 0,5 L	DZIKI POM	5906874369579	0.77	10.00	719
ZA MIASTEM DOBRZE JEST BUT. 0,5 L	ZAM DOB JES	5906874605417	0.77	10.00	720
DE LA SENNE JAMBE DE BOIS T-SHIRT M	DE LA SEN JAM DE BOI TSH M	5123456791364	0.00	10.00	721
NEPOMUCEN HIGHWAY BUT. 0,5 L	NE HIG	5907709756083	0.77	10.00	722
FUNKY FLUID HIGH FIVE! PUSZKA 0,5 L	FF_HIG_PUSZ_4500	5903999514464	0.54	10.00	723
ED RED KONSERWA STEK RZEЏNIKA W SOSIE PIEPRZOWYM	ED STE	5903940086545	0.00	10.00	724
DUVEL CZAPKA Z DZASKIEM SZARA	DUV_CZAP_SZA	5123456791453	0.00	10.00	725
DELIRIUM RED KEG 30 L	DEL RED KG 30 L	\N	32.00	10.00	726
ALEBROWAR HOP SASA BUT. 0,5 L	ALE_HOP_SAS_BUT_500	5907771343730	0.77	10.00	727
TARNOBRZEG SANTAROSA BUT. 0,5 L	TAR_SAN_BUT_500	5907713309732	0.77	10.00	728
PIWNE PODZIEMIE AMERICAN CLASSIC #1 PUSZKA 0,5 L	POD_AME_#1_PUSZ_500	5904305482774	0.54	10.00	729
SOWIE BEZALKOHOLOWE APA BUT. 0,5 L	SOW_BEZALKO_BUT_500	5907222560143	0.77	10.00	730
DUVEL 6.66 BUT. 0,33 L	DUV 6.66 330	5411681408002	0.50	10.00	731
LINDEMANS NEON	KAT05478	5123456791136	0.00	10.00	732
MARYENSZTADT BARREL AGED PROJECT – COCONUT RIS RUM BARREL AGED PUSZKA 0,44 L	MAR_BAR_COC_RIS_PUSZ_440	5903424615728	0.48	10.00	733
DUGGES SEBASTIAN PUSZKA 0,5 L	DUGG_SEB_PUSZ_500	7350038227232	0.54	10.00	734
MAGIC ROAD ULTIMATE COCONUT PRETTY LIMITED EDITION BUT. 0,33 L	MR_ULT_LIM_BUT_330	5905204130452	0.50	10.00	735
SCHNEIDER TAP06 AVENTINUS 18,5° BUT. 0,5 L	Schn TAP6	4003669018207	0.77	10.00	736
INNE BECZKI CHERRY ELEPHANT BUT. 0,5 L	INNE CHE	5905669683258	0.77	10.00	737
CINEY BRUIN BUT. 0,25 L	CIN BRU 250	54055315	0.35	10.00	738
SMYKAN CYDR GROCHУWKA BUT. 0,75 L	SMYK GRO	5905669332033	1.10	10.00	739
AMBER PSZENICZNIAK BUT. 0,5 L	AMB_PSZ_BUT_500	5906591001332	0.77	10.00	740
ED RED MIELONKA NAJDROЇSZA	ED_MIEL_NAJ	5904083584134	0.00	10.00	741
DELIRIUM RED BUT. 0,75 L	DEL RED 750	5412186003495	1.10	10.00	742
ZA MIASTEM SMAK WAKACJI BUT. 0,5 L	ZAM_SMA_WK_BUT_500	5904905630148	0.77	10.00	743
PIWNE PODZIEMIE JUICILICIOUS BUT. 0,5 L	PODZ JUI	5907222444108	0.77	10.00	744
JURAJSKIE KWAЊNY MNISZEK BUT. 0,5 L	JUR MNI	5905331026178	0.77	10.00	745
CHIMAY RED BUT. 1,5 L	CHIM RED 1,5	5410908500048	0.00	10.00	746
SCHLENKERLA SZKLANKA URBOCK 0,5 L	Sch szk Urb 0,5	5123456791329	0.00	10.00	747
JURAJSKIE POMARAСCZA BEZALKOHOLOWE BUT. 0,5 L	JUR POM BEZ	5905331026987	0.77	10.00	748
FUNKY FLUID FUSION: MAGIC ROAD PUSZKA 0,5 L	FF_FUS_MAG_PUSZ_500	5903999513924	0.54	10.00	749
FLYING MONKEYS GINGER BELLE BARREL AGED BUT. 0,473 L	FM GIN	870766000640	0.00	10.00	750
DEER BEAR TOY BOY PUSZKA 0,5 L	DEER TOY	5903678460563	0.54	10.00	751
RODENBACH CARACTERE ROUGE BUT. 0,75 L	RODEN CAR ROU 750	5410583802482	1.10	10.00	752
PINTA Psst... It's Your Weekend IPA - Cold IPA 15,0° keg 20 l	PI_PSST_YOU_COLD_KEG_20	5123456780029	0.00	10.00	753
MALTGARDEN GATE NO 1/2021 BUT. 0,5 L	MALT GAT 1	5904050721388	0.77	10.00	754
PRZETWУRNIA CHMIELU PLANTACJA #3 PUSZKA 0,5 L	PCH_PLA_#3_PUSZ_500	5905476980717	0.54	10.00	755
LHG TORBA	LHG TOR	5123456791357	0.00	10.00	756
ARTEZAN TOO YOUNG TO BE HEROD BUT. 0,5 L	ARTEZ TOO	5904730574006	0.77	10.00	757
ZAKЈADOWY KINO KOSMOS BUT. 0,5 L	ZAKЈ KIN KOS	5907753170286	0.77	10.00	758
PINTA Pierwsza Pomoc 10,5° keg 30 l	PI Pie keg 30	5123456789765	0.00	10.00	759
MIЈOSЈAW SOSNOWE APA BUT. 0,5 L	MIЈ SOS	5901687910765	0.77	10.00	760
SCHLENKERLA RAUCHBIER WEICHSEL ROTBIER BUT. 0,5 L	SCH_WEI_ROT_BUT_500	4037458000197	0.77	10.00	761
JURAJSKIE POMARAСCZA BUT. 0,5 L	JUR POM	5905331025362	0.77	10.00	762
PINTA T-shirt czarny duїe logo S	PINTA Kos DL cza S	5904165102393	0.00	10.00	763
PINTA Otwieracz barmaсski	PINTA Otw bar	5123456791386	0.00	10.00	764
ARTEZAN DODO BUT. 0,5 L - PROMOCJA	ARTEZ_DOD_BUT_500	\N	0.00	10.00	765
ARTEZAN CHATEAU 2021 BUT. 0,375 L	ARTEZ CHA	5904730574846	0.50	10.00	766
MATE MOC KATUAVA BUT. 0,33 L	MIO_MAT_MOC_KATU_BUT_330	5902768762891	0.50	10.00	767
PINTA RISFACTOR Cocoa Nibs and Coconut 30,0° but. 0,33 l	PI RIS Coc Coc	5904165102263	0.00	10.00	768
MALHEUR 10% BUT. 0,33 L	MAL 10% 330	5413970200014	0.50	10.00	769
ICE BREAKER CARPOOL KARAOKE KEG 30 L PROMOCJA (do 09.09.23)	ICE BRE CAR KAR KEG 30_PROM	\N	0.00	10.00	770
TRZECH KUMPLI NESTA BUT. 0,5 L	TR_NES_BUT_500	5904252699027	0.77	10.00	771
THE BRUERY GYPSY TART BUT. 0,75 L	BRU GYP	705105537955	1.10	10.00	772
ARTEZAN CINNAMON ROLLS BUT. 0,5 L	ART_CIN_BUT_500	5904708750838	0.77	10.00	773
TIMMERMANS PECHE BUT. 0,25 L	TIMM PECH 250	5411516010905	0.35	10.00	774
MIKKELLER PUMA BOKSERKA SPORTOWA CZARNA (XXL)	MIK PUM XXL	5123456791120	0.00	10.00	775
STU MOSTУW WRCLW PSZENICZNY BUT. 0,5 L	STU WRC PSZ	5907614680497	0.77	10.00	776
JAN OLBRACHT ZERO STRESU BEZALKOHOLOWE APA BUT. 0,5 L	JO ZER BEZ	5902627011481	0.77	10.00	777
PINTA Barrel Brewing Curiosity but. 0,375 l	PBB Cur	5904335577457	0.00	10.00	778
TRZECH KUMPLI GOEDEMORGEN KEG 30 L	TR GOE K	5123456789476	32.00	10.00	779
MOON LARK SHELTER. GERMAN PILS PUSZKA 0,5 L	ML SHE	5905255346185	0.54	10.00	780
P?HJALA MUST KULD PUSZKA 0,33 L	POH_MUS_KUL_BUT_330	4742976013764	0.35	10.00	781
ALEBROWAR ICED SWEET AS SONYA BUT. 0,25 L	ALE ICE SWE SON	5907771341910	0.35	10.00	782
PINTA Pils Time 12,0° but. 0,5 l	PI_PIL_TIM_BUT_500	5904165104182	0.00	10.00	783
RODENBACH GRAND CRU BUT. 0,75 L	RODEN GRA 750	5410583800181	1.10	10.00	784
DEER BEAR YAM YAM PUSZKA 0,5 L	DE_YAM_PUSZ_500	5905204172148	0.54	10.00	785
SAMUEL SMITH TADDY PORTER BUT. 0,355 L	SS TAP	5010149200808	0.00	10.00	786
WRКЇEL CARDINAL BUT. 0,5 L	WRE CAR	5904730465120	0.77	10.00	787
ALMANAC SOUR IPA BUT. 0,375 L	ALMAN IPA	748252022707	0.50	10.00	788
STARA SZKOЈA STARA STODOЈA BUT. 0,5 L	STA STO	5906874548172	0.77	10.00	789
SARABANDA LIQUID FORMS PUSZKA 0,5 L PROMOCJA (do 05.10.23)	SARA LIQ_PROM	\N	0.00	10.00	790
STU MOSTУW CHERRY ME PUSZKA 0,33 L	STU CHE	5907614682453	0.35	10.00	791
MIKKELLER RUNNING CLUB SPODNIE CZARNE ( M )	MIK SPOD M	5123456791115	0.00	10.00	792
FUNKY FLUID FUNKY FRUIT: PEACH WEIZEN BUT. 0,5 L	FF_FUN_FRU_PEA_BUT_500	5906395560318	0.77	10.00	793
SVIJANY RYTIR 12% BUTELKA 0,5 L	SVI_RYT_BUT_500	8594030010075	0.00	10.00	794
P?HJALA ЦЦ KEG 20L	POH OO 20L	5123456789915	0.00	10.00	795
LEFFE BRUNE BUT. 0,75 L	LEF BRU 750	5410228145226	1.10	10.00	796
INNE BECZKI WAKE & BAKE BUT. 0,5 L	INNE WAK	5903661281069	0.77	10.00	797
NEPOMUCEN NACHMIELONA CHMIEL+WODA BUT. 0,5 L	NE NACH CHM	5905279959316	0.77	10.00	798
GRYFUS PORTOWIEC BUT. 0,5 L	GRY_POR_BUT_500	5904905850072	0.77	10.00	799
CANTILLON GUEUZE-LAMBIC BIO 2022 BUT. 0,75L	KAT05712	5123456788010	0.00	10.00	800
GRODZISKIE BEZALKOHOLOWE MANGO ALE BUT. 0,5 L	MIЈ GRO BEZ MAN	5905279533554	0.77	10.00	801
MINISTER PILZNER BUT. 0,5 L	MIN_PIL_BUT_500	5903351660105	0.77	10.00	802
ALEBROWAR EL FRUTO BUT. 0,5 L	ALE ELF	5907222039106	0.77	10.00	803
ZA MIASTEM CHWILA SPOKOJU BUT. 0,5 L	ZAM_CHW_SPOK_BUT_500	5904905630155	0.77	10.00	804
ST. BERNARDUS EXTRA 4 KEG 20 L	STB EXT KEG 20	\N	21.50	10.00	805
SCHLENKERLA RAUCHBIER URBOCK VINTAGE 2017 17,5° BUT. 0,5 L	SCH URB VIN 2017	5123456790101	0.77	10.00	806
RACIBORSKIE CIEMNE BUT. 0,5 L	RAC CIE	5907506252207	0.77	10.00	807
JURAJSKIE SЈODKIE CYTRYNY BUT. 0,5 L	JUR_SЈO_CYT_BUT_500	5905331026994	0.77	10.00	808
P?HJALA ELECTRIC BABA TONKA BUT. 0,33 L	POH ELE	4742976015157	0.50	10.00	809
MOCZYBRODA SUMMERTIME MADNESS BUT. 0,5 L	MO_SUM_MAD_BUT_500	5904673800996	0.77	10.00	810
GWAREK ZERO MATES LIQUID RED BUT. 0,5 L	GW_ZER_MAT_RED_BUT_500	5903938751745	0.77	10.00	811
PINTA MASTERBAR Vanilla & Coconut 30,0° keg 10 l	PI_MAS_VAN_COC_KEG_10	\N	0.00	10.00	812
PIWNE PODZIEMIE TROPICALIA KEG 30 L	PODZ TRO K	5123456789400	32.00	10.00	813
KOMES PORTER MALINOWY BUT. 0,5 L	MIЈ KOM POR MAL	5901687910833	0.77	10.00	814
PINTA Kwas Jota 10,5° keg 20 l	PI Jot keg 20	5123456789728	0.00	10.00	815
LERVIG HIPSTER FOR CHRISTMAS 2020 PUSZKA 0,33 L	OMB Ler Hip	7072712006406	0.35	10.00	816
JURAJSKIE MOJITO BUT. 0,5 L	JUR MOJ	5905331026642	0.77	10.00	817
SCHLENKERLA HELLES LAGERBIER 11,0° BUT. 0,5 L	Sch Hel	4037458000111	0.77	10.00	818
MIKKELLER RUNNING CLUB SPODNIE CZARNE (S)	MIK SPOD S	5123456791117	0.00	10.00	819
PINTA T-shirt biaіy duїe logo L	PINTA Kos DL bia L	5904165102461	0.00	10.00	820
PINTA Barrel Brewing - After Hours - Tropical Wild Ale 12,0° keg 10 L	PBB_TRO_WIL_KEG_10	5123456780018	0.00	10.00	821
PINTA Double Delivery 18,0° keg 30 l	PI_DOU_DEL_KEG_30	5123456780045	0.00	10.00	822
MARYENSZTADT KLASYCZNIE BAWARSKA PSZENICA BUT. 0,5 L	MAR KLA BAW	5905669542579	0.77	10.00	823
LERVIG KONRADS STOUT PUSZKA 0,33 L	OMB Ler Kon	7072712000763	0.35	10.00	824
LITOVEL ИERNY CITRON 4% BZW.  BUT. 0,5 L	LIT_CER_CIT_BZW_BUT_500	8593875518418	0.77	10.00	825
TRZECH KUMPLI TASSIE KEG 30 L	TR TAS K	\N	32.00	10.00	826
MARYENSZTADT THE ROOTS#4 DOUBLE WEST COAST IPA PUSZKA 0,5 L	MAR THE ROO#4	5903678022402	0.54	10.00	827
WIDAWA CZARNY KUR BUT. 0,5 L	WID KUR	5907710904015	0.77	10.00	828
DZIKI WSCHУD NESSO PUSZKA 0,5 L	DZIKI NES	5906874369500	0.54	10.00	829
PINTA T-shirt czarny duїe logo XL	PINTA Kos DL cza XL	5904165102423	0.00	10.00	830
DE MOLEN HEEN & WEER BUT. 0,33 L	DE_MOLEN_HEE_WEE_BUT_330	8717624421242	0.50	10.00	831
ROMY SZKLANKA 0,25 L	KAT01424	5123456791030	0.00	10.00	832
P?HJALA TUME LAAGER PUSZKA 0,44 L	POH TUM LAA	4742976015362	0.48	10.00	833
SVIJANY KNIZE 13% BUTELKA 0,5 L	SVI_KNI_BUT_500	8594030010051	0.00	10.00	834
DE LA SENNE BLUZA L	DE LA SEN BLU L	5123456791363	0.00	10.00	835
SAISON 1858 SZKLANKA 0,25 L	E2AB-2216E	5123456791028	0.00	10.00	836
FUNKY FLUID TRINITY SIMCOE PILS PUSZKA 0,5 L	FF_SIM_PIL_PUSZ_500	5903999514150	0.54	10.00	837
MIKKELLER SPONTAN HIBISCUS BUT. 0,375 L	MIK SPON HIB 375	5704255115605	0.50	10.00	838
DU BOCQ BLANCHE DE NAMUR BUT. 0,33 L	DU BOC BLA DE NAM 330	5411633330054	0.50	10.00	839
PIWOTEKA LAS ЈAGIEWNICKI BUT. 0,5 L	PIW_LAS_BUT_500	5905669428569	0.77	10.00	840
SCHNEIDER BLACHA REKLAMOWA	SCH BLA REK	5123456791339	0.00	10.00	841
JUPILER NA BUT. 0,25 L	JUP 250	5410228231325	0.35	10.00	842
DUBUISSON BUSH AMBER CARACTERE BUT. 0,75 L	DUB BUS AMB 750	5411551260723	1.10	10.00	843
BALADIN XYAUYU KIOKE BUT. 0,5 L	Bal Xya Kio	8032942297325	0.77	10.00	844
PINTA Kwas Xy 12,0° keg 30 l	PI Xy keg 30	5123456789811	0.00	10.00	845
DE MOLEN DAG & DAUW BUT. 0,33 L	DE MOLEN DAG	8717624423215	0.50	10.00	846
CANTILLON ROSЙ DE GAMBRINUS KEG 20 L	KAT04135	5123456789010	21.50	10.00	847
PINTA Hazy Discovery Sofia can 0,5 l	PI_HD_SOF_CAN_500	5904165105073	0.00	10.00	848
CUVEE DES TROLLS BUT. 0,25 L	CUVE TROL 250	5411551141091	0.35	10.00	849
MATE - MATE KONOPIA HEMP BUT. 0,5 L	MIO_MAT_MAT_KON_HEMP_BUT_500	4260310559056	0.77	10.00	850
FILOU BUT. 0,33 L	FILOU	5411081006211	0.50	10.00	851
CANTILLON KRIEK-LAMBIC BIO 2022 BUT. 0,375 L	CANT KRI LAM BIO 2022 375	5411024000054	0.50	10.00	852
VAL-DIEU BRUNE BUT. 0,75 L	VAL BRU 750	5413977000068	1.10	10.00	853
BROKREACJA RICKSHAW BUT. 0,5 L	BR_RIC_BUT_500	5904422197940	0.77	10.00	854
P?HJALA BELLE BULLE BUT. 0,33 L	KAT06631	4742976014228	0.50	10.00	855
MARYENSZTADT SMOOTHIE BEER: MANGO-ORANGE-BANANA-MARSHMALLOW PUSZKA 0,44 L	MAR SMO MAN	5903424615117	0.48	10.00	856
AYINGER ALTBAIRISCH DUNKEL BUT. 0,5 L	AYI ALT DUN	4104170020700	0.77	10.00	857
3 FONTEINEN FROMBOZENLAMBIK OOGST 2019/20 BUT. 0,375 L	3 FON FRA LAM OOG 375	5425007818611	0.50	10.00	858
BIRBANT FLEX PUSZKA 0,5 L	BI_FLE_PUSZ_500	5904041703843	0.54	10.00	859
LINDEMANS FRAMBOISE BUT. 0,25 L	LIND FRA 250	5411223100487	0.35	10.00	860
SARABANDA PLEASUREDOME PUSZKA 0,5 L	SA_PLE_PUSZ_500	5904501978255	0.54	10.00	861
P?HJALA ORANGE GOSE PUSZ. 0,33 L	KAT06427	4742976013610	0.00	10.00	862
PINTA Hazy Discovery Minas Gerais 16,5° can 0,5 l	PI_HD_MIN_GER_CAN_500	5904165104649	0.00	10.00	863
SZRENIAWA BELGIAN BLOND BUT. 0,5 L	SZR_BEL_BLO_BUT_500	5907632926270	0.77	10.00	864
PINTA Mata barowa	PINTA Mat bar	5903990622434	0.00	10.00	865
PIWNE PODZIEMIE PHANTASTIC DAY PUSZKA 0,5 L	POD_PHA_DAY_PUSZ_500	5904305482842	0.54	10.00	866
PINTA Koszulka biaіa XL	PINTA Kos bia XL	5904165100443	0.00	10.00	867
BACCHUS GRAAL SZKLANKA 0,25 L	BACCH GRA SZKL	5123456791335	0.00	10.00	868
DUVEL BUT. 0,33 L	DUV 330	5411681014005	0.50	10.00	869
TRZECH KUMPLI CITRUS SESSION JUICY IPA - OUR NEW IPA KEG 30 L	TR_CIT_SES_OUR_NEW_KEG_30	\N	32.00	10.00	870
RECRAFT POLISH HAZY IPA AMORA PRETA & KSIҐЇКCY PUSZKA 0,5 L	REC_POL_HAZ_PRE_PUSZ_500	5904730663779	0.54	10.00	871
BROWARNY ROYALS PUSZKA 0,5 L	BROW_ROY_PUSZ_500	5905450141127	0.54	10.00	872
SZRENIAWA BI?RE DE GARDE BUT. 0,33 L	SZ BIE	5903857178296	0.50	10.00	873
Paleta transportowa zw	Pal tra zw	\N	0.00	10.00	874
ZAKЈADOWY NAPУJ FIRMOWY BUT. 0,5 L	ZA_NAP_FIR_BUT_500	5907753172020	0.77	10.00	875
BROWAR JANA PILS BUT. 0,5 L	BRO_JA_PILS_BUT_500	5902429980251	0.77	10.00	876
SCHNEIDER TAP03 ALKOHOLFREE BUT. 0,5 L	Schn TAP3	4003669016906	0.77	10.00	877
PRZETWУRNIA CHMIELU OWOC PUSZKA 0,5 L	PCH_OWO_PUSZ_500	5905476980588	0.54	10.00	878
PIWNE PODZIEMIE KOSIARZ UMYSЈУW BUT. 0,33 L	POD_KOS_BUT_330	5904305482606	0.50	10.00	879
CHIMAY KIELICH W PUDEЈKU 0,18 L	KAT06687	5123456791186	0.00	10.00	880
MOON LARK MIRAGE 2.0. SESSION HAZY IPA PUSZKA 0,5 L	ML_MIR_PUSZ_500	5905255346345	0.54	10.00	881
HOEGAARDEN SZKLANKA  0,25 L	141	5123456791046	0.00	10.00	882
LINDEMANS GINGER GUEUZE BUT. 0,75 L	LIND GIN GUE 750	5411223100036	1.10	10.00	883
GOЊCISZEWO TRAGARZ BUT. 0,5 L	GO_TRAG_BUT_500	5903364108052	0.77	10.00	884
O'HARA'S SESSION IPA BUT. 0,5 L	Oha Ses IPA	5391500602111	0.77	10.00	885
GRYFUS RUSAЈKA BUT. 0,5 L	GRY RUS	5907222685181	0.77	10.00	886
CHYLICZKI CYDR Z ODMIANY CHOPIN KEG 30 L	CHYL CHO K	5123456789027	32.00	10.00	887
BOON KRIEK BUT. 0,75 L	BOON KRI 750	5412783053190	1.10	10.00	888
STU MOSTУW CHOCOLATE STOUT NITRO BUT. 0,5 L	STU CHO STO NIT	5907614680275	0.77	10.00	889
STU MOSTУW WRCLW BEZALKOHOLOWY IPA BUT. 0,5 L	STU WRC BEZ	5907614681890	0.77	10.00	890
PRZETWУRNIA CHMIELU DROBINKA #4 PUSZKA 0,5 L	PCH_DRO_#4_PUSZ_500	5905476980571	0.54	10.00	891
DUGGES JUICY FRUITY PUSZKA 0,5 L	DUGG_JUI_FRU_PUSZ_500	7350038227607	0.54	10.00	892
ROCKMILL BE WILD #1 0 BUT. 0,75 L	ROCK_BE_WI_#1_0_BUT_750	5906874027509	1.10	10.00	893
RECRAFT JUICY SOUR SERIES – LICZI X ANANAS X BANAN X WINOGRONA PUSZKA 0,5 L	REC_JUI-LIC-ANA-BAN_PUSZ_500	5900779755963	0.54	10.00	894
PINTA Koszulka szara L	PINTA Kos sza L	5904165101273	0.00	10.00	895
DUGGES 9+9 SOUR PUSZKA 0,5 L	DUGG_9+9_SOU_PUSZ_500	7350038227706	0.54	10.00	896
MIKKELLER BAGHAVEN: REFSAESOEN ABRIKOS BUT. 0,75 L	MIK REFA	732003233542	1.10	10.00	897
BIRBANT MORPHIC PUSZKA 0,5 L	BI_MOR_PUSZ_500	5904041703614	0.54	10.00	898
SPECIATION SALTATION BUT. 0,375 L	OMB Spe Sal	5123456790109	0.50	10.00	899
O'HARA'S SZKLANKA SHAKER 0,5 L	Oha Szkl Sha 5	5123456791388	0.00	10.00	900
DUGGES PARADISI PUSZKA 0,33 L	DUGG_PAR_PUSZ_330	7350038227171	0.35	10.00	901
RACIBORSKIE KLASYCZNE ZW BUT. 0,5 L	RAZ KLA BUT ZW	5907506252276	0.77	10.00	902
FORTUNA KWAЊNA PIGWA BUT. 0,5 L	MIЈ FOR KWA	5902838990452	0.77	10.00	903
STAROPOLSKIE KULTOWE BEZ GLUTENU MALINOWE BUT. 0,5 L	STAR KUL BEZ MAL	5903021500618	0.77	10.00	904
MIKKELLER CHERRY FREDERIKSDAL DOUBLEBOCK 2019 BUT. 0,375 L	MIK CH FR 2019 375	5704255119238	0.50	10.00	905
SCHNEIDER WEISSE KUFEL CERAMIKA WYSOKI 0,5 L	SCHNE KUF CER POD 0,5	5123456791325	0.00	10.00	906
ALEBROWAR BRAMBLE RUMBLE BUT. 0,5 L	ALE BRU	5907771340692	0.77	10.00	907
HOEGAARDEN BLANCHE KEG 20 L	HOEG BLA K 20	5123456789020	21.50	10.00	908
LEFFE BLONDE BUT. 0,75 L	LEF BLO 750	5410228102762	1.10	10.00	909
PINTA T-shirt Atak Chmielu S	PINTA Kos Ata S	5903990622694	0.00	10.00	910
LINDEMANS BEARDY HIPSTER T-SHIRT (XXL)	KAT06616	5123456791144	0.00	10.00	911
KEG GULDEN DRAK 20 L	KEG_GD	\N	0.00	10.00	912
SMYKAN CYDR STARY SAD BUT. 0,33 L	SMYK STA	5905669332101	0.50	10.00	913
LUBROW SOURHEAD MONKEY PUSZKA 0,33 L	LUB_SOU_PUSZ_330	5903686842948	0.35	10.00	914
HOPUS POKAL 0,33 L	KAT01009	5123456791084	0.00	10.00	915
LA CHOUFFE BLONDE BUT. 0,33 L	LA CHO BLO 330	5410769100081	0.50	10.00	916
IMBIOROWICZ MIУD PITNY TRУJNIAK MIУD MALINA BUT. 0,375 L	IMB Miу Mal 375	5905669820394	0.50	10.00	917
KORMORAN KRZEPKIE BUT. 0,5 L	KORM KRZ	5902528573354	0.77	10.00	918
BRUNEHAUT KIELISZEK 0,25 L	378	5123456791165	0.00	10.00	919
ZAKЈADOWY PILS BUT. 0,5 L	ZAKЈ PIL	5907753172228	0.77	10.00	920
PINTA / Sibeeria Cold's Cool 13,0° can 0,5 l	PI_COLD_COOL_CAN	8596301014331	0.00	10.00	921
NEPOMUCEN FREE ODRA PANY PUSZKA 0,5 L	NE FRE ODR	5904555992795	0.54	10.00	922
ZA MIASTEM WARTO STRZELIЖ BUT. 0,5 L	ZAM WAR	5906874605455	0.77	10.00	923
RACIBORSKIE KLASYCZNE PUSZKA 0,5 L	RAC KLA P	5907506252719	0.54	10.00	924
LINDEMANS PECHERESSE BUT. 0,75 L	LIND PEC 750	5411223100876	1.10	10.00	925
CANTILLON LAMBIC KEG 20L	CANT LAMB K 20	5123456789018	0.00	10.00	926
ZA MIASTEM DZIEС DOBRY Z POMARAСCZҐ BUT. 0,5 L	ZAM_DZI_DOB_POM_BUT_500	5904905630179	0.77	10.00	927
STAROPOLSKIE BESTBIR ЇURAWINA BUT. 0,5 L	STAR BES ЇUR	5903021503268	0.77	10.00	928
GULDEN DRAAK KEG 5 L	GUL_DRA_KEG_5	\N	0.00	10.00	929
DEER BEAR FLORAL PUSZKA 0,5 L	DE_FLOR_PUSZ_500	5905204172179	0.54	10.00	930
BROWAR JANA BEZGLUTENOWE JASNE PEЈNE BUT. 0,5 L	BRO_JA_BEZGL_BUT_500	5902429980961	0.77	10.00	931
DUGGES MANGO SHAKE PUSZKA 0,33 L	DUGG_MAN_SHA_PUSZ_330	7350038227492	0.35	10.00	932
DELIRIUM RED BUT. 0,33 L	DEL RED 330	5412186002436	0.50	10.00	933
BUSH KIELICH 0,33 L	420	5123456791190	0.00	10.00	934
IMBIOROWICZ MIУD PITNY TRУJNIAK MEADNIGHT BUT. 0,5 L	IMB Med 500	5905669820646	0.77	10.00	935
DEER BEAR LET'S COOK - GUAVA PUSZKA 0,5 L	DE_LET_GUA_PUSZ_500	5905204172193	0.54	10.00	936
RECRAFT MC FARMER BUT. 0,5 L	REC MC FAR	5904730663052	0.77	10.00	937
JUPILER T-SHIRT (L)	KAT05458	5123456791191	0.00	10.00	938
CANTILLON GUEUZE LAMBIC-BIO 2022 BUT. 0,375 L	CANT GUE 2022 375	5411024000047	0.50	10.00	939
BIRRA MANIA WIT BIANCA BUT. 0,33 L	BM WIT	5907694918435	0.50	10.00	940
PINTA Beskidy APA 12,0° but. 0,5 l	PI Bes APA	5908252864188	0.00	10.00	941
STAROPOLSKIE BESTBIR CYTRYNA BUT. 0,5 L	STAR BES CYT	5903111989996	0.77	10.00	942
MIKKELLER BLACK BUT. 0,375 L	MIK BL 375	818534018534	0.50	10.00	943
ROCKMILL 4TH ANNIVERSARY BUT. 0,5L	ROCK_4TH_ANN_BUT_500	5908291862282	0.00	10.00	944
MONVIN KARAFKA 0,5 L / 1,0 L	MON_KAR_1000	5123456791450	0.00	10.00	945
HOUBLON CHOUFFE BUT. 0,75 L	HOUB CHOUF 750	5410769300115	1.10	10.00	946
MALTGARDEN GATE NO 1/2023 PUSZKA 0,33 L	MA_GAT_1_2023_PUSZ_330	5904050721999	0.35	10.00	947
LA TRAPPE TAP HANDLE	TRAP TAP HAN	5123456791361	0.00	10.00	948
MARYENSZTADT NEW BLACK - CHOCOLATE HAZELNUT OAT STOUT BUT. 0,5 L PROMOCJA (do 29.09.23)	MAR NEW BLA CHO HAZ_PROM	\N	0.00	10.00	949
MAGIC ROAD WILD ALE AGED IN WINE BARRELS BUT 0,75 L	MR_WIL_ALE_BUT_500	\N	0.00	10.00	950
WRКЇEL BUTTERFLY BUT. 0,5 L	WRE BUT	5904730465137	0.77	10.00	951
RADUGA LAST SUMMER BUT. 0,5 L	RADU LAS	5902448150178	0.77	10.00	952
BOSTEELS TRIPEL KARMELIET BUT. 0,75 L	BOST TRI 750	5410693100553	1.10	10.00	953
PETRUS ROOD BRUIN BUT. 0,33 L	PET ROO BRU 330	875213000068	0.50	10.00	954
PINTA Hazy Morning 12,0° keg 20 l	PI Haz Mor keg 20	5123456789712	0.00	10.00	955
KOMES ZESTAW KONESERA 4 PIWA 0,5 L + POKAL	MIЈ KOM ZES KON 4 + POK	5901687910857	0.00	10.00	956
LINDEMANS POKAL SENSORIK 0,5 L	LIND POK SEN 500	5123456791003	0.00	10.00	957
P?HJALA ЦЦ XO BUT. 0,33 L	POH OO XO	4742976010794	0.50	10.00	958
PINTA Cold Delivery 14,0° can 0,5 l	PI_COL_DEL_CAN_500	5904165104939	0.00	10.00	959
KENT FALLS SHADOW PYRAMIDS BUT. 0,5 L	KENT SHA	5123456790145	0.77	10.00	960
LUBROW CRYO APA EL DORADO PUSZKA 0,33 L PROMOCJA (do 14.10.23)	LUB CRY_PROM	\N	0.00	10.00	961
CANTILLON SANG BLEU 2022 BUT. 0,75 L	KAT07435	5123456790019	1.10	10.00	962
INNE BECZKI EL ALMANTE PUSZKA 0,5 L	IN_EL_ALMA_PUSZ_500	5903661281540	0.54	10.00	963
3 FONTEINEN FRAMBOOS OOGST 2019 BUT. 0,375 L	3 FON FRA OOG 375	5425007818338	0.50	10.00	964
KOMES RUSSIAN IMPERIAL STOUT BUT. 0,5 L	MIЈ KOM RIS	5901687910840	0.77	10.00	965
BACCHUS FRAMBOZENBIER BUT. 0,375 L	BACCH FRA	5411081004316	0.50	10.00	966
HEMP & BREW CBD PALE ALE BUT. 0,5 L	HB_CBD_PAL_BUT_500	5903661867751	0.77	10.00	967
NEPOMUCEN FOR.REST BUT. 0,5 L	NE FOR.RES	5907709756243	0.77	10.00	968
DUGGES SUPERIOR PUSZKA 0,33 L	DUGG_SUPE_PUSZ_330	7350038226044	0.35	10.00	969
MARYENSZTADT SUMMERTIME HOPPY HEFEWEIZEN BUT. 0,5 L	MAR_SOU_HOP_HEFF_BUT_500	5903424615094	0.77	10.00	970
PINTA Barrel Brewing Scarlet but. 0,375 l	PBB_SCA_BUT_375	5904335577549	0.00	10.00	971
JURAJSKIE KWAЊNA AЊKA BUT. 0,5 L	JUR KWA	5905331025058	0.77	10.00	972
KORMORAN TERRA DONUM BRAGGOT BUT. 0,375 L	KORM TER BRA	5902528000447	0.50	10.00	973
PINTA Oto mata IPA 14,0° but. 0,5 l	PI Oto	5908252864300	0.00	10.00	974
CHYLICZKI CYDR CZARNY SAD BUT. 0,5 L	CHYL CZA 500	5905279058194	0.77	10.00	975
BIRBANT YUMMY BUT. 0,5 L	BI YUM	5903240620852	0.77	10.00	976
RECRAFT CITRUS INDIA PALE ALE PUSZKA 0,5 L	REC_CIT_IPA_PUSZ_500	5904730663809	0.54	10.00	977
BOSTEELS TRIPEL KARMELIET BUT. 0,33 L	BOST TRI 330	54050082	0.50	10.00	978
PINTA MASTERBAR Cocoa Nibs & Orange Peel 30,0° keg 10 l	PI_MAS_COC_ORA_KEG_10	\N	0.00	10.00	979
LOCO BEER TROPICAL NON ALCOHOL BUT. 0,33 L	BM LOC TRO	5907694918374	0.50	10.00	980
TRZECH KUMPLI TAURA BUT. 0,5 L	TR TAU	5905669479493	0.77	10.00	981
SCHLENKERLA KUFEL CERAMICZNY RAUCHBIER 0,5 L	SCH KUF RAU	5123456791242	0.00	10.00	982
ST. BERNARDUS WATOU TRIPEL BUT. 0,33 L	STB WAT TRI 330	54079045	0.50	10.00	983
INNE BECZKI IPARALIZATOR PUSZKA 0,5 L	IN_IPARA_PUSZ_500	5903661281779	0.54	10.00	984
ZA MIASTEM BЈOGI NASTRУJ BUT. 0,5 L	ZAM_BЈO_NAS_BUT_500	5904905630131	0.77	10.00	985
NEPOMUCEN TOUCAN BUT. 0,5 L	NE TOU	5905279959675	0.77	10.00	986
PINTA Hazy Delivery 15,0° but. 0,5 l	PI_HAZ_DEL_BUT_500	5904165103741	0.00	10.00	987
IMBIOROWICZ MIУD PITNY TRУJNIAK 966 BUT. 0,75 L	IMB 966 750	5905669820073	1.10	10.00	988
RECRAFT PURISTA BUT. 0,33 L	REC PUR	5900779755079	0.50	10.00	989
PINTA Every Body August 10,5° keg 30 l	PI_EVE_BO_AUG_KEG_30	5123456780033	0.00	10.00	990
KORMORAN ЊWIEЇE BUT. 0,5 L	KORM ЊWIEЇE	5902528001093	0.77	10.00	991
LINDEMANS BEARDY HIPSTER T-SHIRT (S)	KAT06615	5123456791146	0.00	10.00	992
KASTEEL TRIPEL KEG 20 L	KAST TRI K 20 L	5123456789884	21.50	10.00	993
SCHLENKERLA RAUCHBIER EICHE VINTAGE 2017 19,9° BUT. 0,5 L	SCH EIC VIN 2017	\N	0.77	10.00	994
P?HJALA LIQUID PINATA BUT. 0,33 L	POH LIQ	4742976014884	0.50	10.00	995
WRКЇEL PINK PANTHER BUT. 0,5 L	WRE PIN	5904181970440	0.77	10.00	996
ROCKMILL HERMANOS POLACOS PUSZKA 0,5 L	ROCK_HER_POL_PUSZ_500	5908291862695	0.54	10.00	997
TRZECH KUMPLI RAUCHDOPPELBOCK BUT. 0,5 L	TR RAU	5905669479738	0.77	10.00	998
GRYBУW PILSVAR MIУD-MALINA BUT. 0,5 L	GR MIУ MAL	5902516000978	0.77	10.00	999
CZTERY ЊCIANY KAMPER PUSZKA 0,5 L	4SC KAM P	5906874341674	0.54	10.00	1000
BROKREACJA LUDZIE TRZYMAJCIE KAPELUSZE WILD TURKEY BOURBON B.A. BUT. 0,33 L	BRO LUD BA	5904422197001	0.50	10.00	1001
LINDEMANS TACA	KAT05473	5123456791129	0.00	10.00	1002
ST. GUMMARUS DUBBEL BUT. 0,33 L	STG DUB 330	5413699011168	0.50	10.00	1003
PRZETWУRNIA CHMIELU TWIST #2 PUSZKA 0,5 L	PCH_TWI#2_PUSZ_500	5905476980335	0.54	10.00	1004
GRYFUS STERNIK BUT. 0,5 L	GRY STE	5907222685198	0.77	10.00	1005
KORMORAN ZЈOTY EXPORT LAGER BUT. 0,5 L PROMOCJA (do 17.10.23)	KORM ZЈO_PROM	\N	0.00	10.00	1006
MOCZYBRODA FULL TIME HEAVEN PUSZKA 0,5 L	MO_FUL_PUSZ_500	5904673800767	0.54	10.00	1007
MAGIC ROAD WILD PRETTY #11 DOUBLE BARREL AGED PUSZKA 0,33 L	MR_WIL_PRE_DOU_PUSZ_330	5905204130636	0.35	10.00	1008
MALTGARDEN TOPPING REVOLUTION PUSZKA 0,5 L	MA_TOP_REV_PUSZ_500	5904050721982	0.54	10.00	1009
KINGPIN MELT PUSZKA 0,5 L	KIN_MEL_PUSZ_500	5904730290036	0.54	10.00	1010
KEG FORTUNA 30 L	KEG FOR	5123456792017	0.00	10.00	1011
STELLA ARTOIS NEON REKLAMOWY	KAT05480	5123456791056	0.00	10.00	1012
PINTA I'm so Horny! 18,0° but. 0,5 l	PI_HOR_BUT_500	5904165103864	0.00	10.00	1013
INNE BECZKI DEEZ NUTS PUSZKA 0,5 L	IN_DEE_NUT_PUSZ_500	5903661281557	0.54	10.00	1014
MOCZYBRODA LOVE WITH THE COCO BUT. 0,33 L	MOCZY LOV COC	5903351761710	0.50	10.00	1015
PINTA Collab PL: Cztery Њciany 15,0° keg 20 l	PI_COLL_CZT_KEG_20	5123456780040	0.00	10.00	1016
KASTEEL RUBUS FRAMBOISE 0,33 L	KAST_RUB_FRA_BUT_330	5411081009854	0.00	10.00	1017
KASTEEL POKAL 0,5 L	KAST POK 500	5123456791311	0.00	10.00	1018
RODENBACH RED TRIPEL BUT. 0,75 L PROMOCJA (do 29.09.23)	RODEN RED TRI 750_PROM	\N	0.00	10.00	1019
CROOKED STAVE L`BRETT D`BLUEBERRY 2016 BUT. 0,75L	OMB Cro L Bre Blu	854512003932	0.00	10.00	1020
ЈAСCUT DIMI3RI BUT. 0,33 L	LAN DIM	5906395997732	0.50	10.00	1021
PINTA Szklanka Weizen 2021 0,5 l	PINTA Szk Wei	5904165100696	0.00	10.00	1022
PINTA Szklanka Your Beer Your Glass 0,5 l	PINTA_SZK_YOU_BEE_500	\N	0.00	10.00	1023
KAZIMIERZ BABCIA RУZIA BUT. 0,5 L	KAZ BAB	5906660570523	0.77	10.00	1024
O'HARA'S IRISH STOUT BUT. 0,5 L	Oha Iri Sto	5391500600032	0.77	10.00	1025
PINTA July Jungle Tour 12,0° keg 30 l	PI_JUL_JUN_TOU_KEG_30	5123456780032	0.00	10.00	1026
ALEBROWAR MANGO MAN BUT. 0,5 L	ALE MAN MAN	5907771341064	0.77	10.00	1027
SMYKAN CYDR KRONSELKA/ANTONУWKA KEG 30 L	SMY_KRON_ANT_KEG_30	\N	32.00	10.00	1028
DZIKI WSCHУD HASTIIN PUSZKA 0,5 L	DZ_HAS_PUSZ_500	5906874369524	0.54	10.00	1029
DZIKI WSCHУD WILD WILD EAST - PINEAPPLE TART WILD ALE BUT. 0,375 L	DZ_WIL_WIL_EAS_PIN_TAR_WIL_BUT_375	5906874369920	0.50	10.00	1030
RACIBORSKIE PORTER BUT. 0,5 L	RAC POR	5907506252115	0.77	10.00	1031
RACIBORSKIE MIODOWE BUT. 0,5 L	RAC MIO	5907506252573	0.77	10.00	1032
ED RED CHILI CON CARNE Z BRҐZ. RYЇEM - WIEPRZOWINA	ED_CHI_WEGE	5904083584165	0.00	10.00	1033
ED RED KONSERWA KACZE ЇOЈҐDKI W SOSIE ESTRAGONOWYM	ED KAC	5903940086552	0.00	10.00	1034
LINDEMANS CASSIS MEDALION RYBIE OKO	LIND_CAS_MED	\N	0.00	10.00	1035
STU MOSTУW WRCLW GRODZISKI BUT. 0,5 L	STU_WRC_GRO_BUT_500	5907614683016	0.77	10.00	1036
SZRENIAWA PEATED BROWN ALE BUT. 0,33 L	SZ PEA	5903857178395	0.50	10.00	1037
HARPAGAN JEONG BUT. 0,5 L	HAR_JEO_BUT_500	5905316580053	0.77	10.00	1038
RADUGA EAST OF EDEN PUSZKA 0,5 L	RADU EAS	5902176771768	0.54	10.00	1039
O'HARA'S IRISH RED BUT. 0,5 L	Oha Iri Red	5391500600025	0.77	10.00	1040
TRZECH KUMPLI PIECE OF CAKE PUSZKA 0,5 L PROMOCJA (do 14.10.23)	TR_PIE_PUSZ_500_PROM	\N	0.00	10.00	1041
BRUNEHAUT BLANCHE BIO GLUTEN FREE BUT. 0,75 L	BRUN BLA GF 750	5411065200895	1.10	10.00	1042
ST. BERNARDUS WIT BUT. 0,33 L	STB WIT 330	54079052	0.50	10.00	1043
ЈAСCUT IDZIE ZIMA BUT. 0,5 L	LAN ZIM	5906395997107	0.77	10.00	1044
BRUGSE ZOT BLONDE BUT. 0,33 L	BRUG ZOT BLO 330	5425017240013	0.50	10.00	1045
IGNACУW CYDR BRETTUS BUT. 0,75 L	IGNAC BRE	5902768323047	1.10	10.00	1046
LOCO BEER LEMON GRASS NON ALCOHOL BUT. 0,33 L	BM LOC LEM	5907694918367	0.50	10.00	1047
STRUISE / PIPEWORKS XENOPHON'S WINE BUT. 0,33 L	STRU XEN WIN 330	5425017200062	0.50	10.00	1048
PINTA Koszulka HC czarna XL	PINTA Kosz HC czar XL	5904165103017	0.00	10.00	1049
DE STRUISE DARK HORSE SOUR ALE BUT. 0,75 L	DE STRU DAR HORS 750	5425017002758	1.10	10.00	1050
BIRBANT WEIZEN KLASYCZNY BUT. 0,5 L	BI WEI KLA	5903240620517	0.77	10.00	1051
PINTA Koszulka miкtowa S	PINTA Kos mie S	5904165101303	0.00	10.00	1052
OUD BEERSEL TRADITIONAL OUDE GEUZE/KRIEK SZKLANKA 0,25 L	KAT02305	5123456791103	0.00	10.00	1053
DZIKI WSCHУD TYTANOWA CZACHA BUT. 0,5 L	DZIKI TYT CZA	5906874369630	0.77	10.00	1054
KAZIMIERZ ЇYTKO BUT. 0,5 L	KAZ ЇYT	5906660570059	0.77	10.00	1055
FUNKY FLUID GELATO: TARTA DE QUESO PUSZKA 0,5 L	FF_GEL_TAR_QUE_PUSZ_500	5903999514662	0.54	10.00	1056
ZAKЈADOWY PIERWSZA ZMIANA BUT. 0,5 L	ZAKЈ PIE	5906395388004	0.77	10.00	1057
BOON KRIEK BUT. 0,375 L	BOON KRI 375	5412783053848	0.50	10.00	1058
CHIMAY GOLD KEG 20 L	CHI GOL KEG	5410908000166	21.50	10.00	1059
LA CHOUFFE POKAL 0,33 L	488	5123456791079	0.00	10.00	1060
BROWAR GУRNICZO-HUTNICZY IMPERIAL BALTIC PORTER BARREL AGED BUT. 0,33 L	BGH_IMP_POR_BA_BUT_330	5907796630105	0.50	10.00	1061
MARYENSZTADT SOURTIME CALAMANSI I LIMONKA BUT. 0,5 L L	MAR_SOU_CAL_BUT_500	5905669542043	0.00	10.00	1062
DUBUISSON BUSH BLONDE TRIPLE BUT. 0,75 L	DUB BUS BLO 750	5411551270722	1.10	10.00	1063
SCHNEIDER WEISSE SZKLANKA 0,3 L	SCHNE SZKL 0,3	5123456791258	0.00	10.00	1064
3 FONTEINEN KRYSZTAЈOWY KIELISZEK 0,645 L	KAT06396	5123456791153	0.00	10.00	1065
DUGGES BIG BLACK VIOLET PUSZKA 0,5 L	DUGG_BIG_BLA_VIO_PUSZ_500	7350038226402	0.54	10.00	1066
CHYLICZKI CYDR STARY SAD 2022 BUT. 0,33 L	CHY_STA_2022_BUT_330	5905279058033	0.50	10.00	1067
SOWIE PILS BUT. 0,5 L	SOW_PIL_BUT_500	5907222560075	0.77	10.00	1068
PINTA Bluza czarna S	PINTA Blu cza S	5904165100511	0.00	10.00	1069
ZA MIASTEM DЈUGI WEEKEND BUT. 0,5 L	ZAM DLU	5906874605004	0.77	10.00	1070
PIWNE PODZIEMIE PHANTASMIC REALITY PUSZKA 0,5 L	POD_PHA_REA_PUSZ_500	5904305482859	0.54	10.00	1071
MOCZYBRODA RETRO PISTACHIO PUSZKA 0,5 L	MO_RET_PUSZ_500	5904673800415	0.54	10.00	1072
CZTERY ЊCIANY POLANA BUT. 0,5 L	4SC_POL_BUT_500	5905108498139	0.77	10.00	1073
PINTA Beskidy APA 12,0° keg 30 l	PI Bes APA keg 30	5123456789670	0.00	10.00	1074
UNTITLED ART. DBL CHOC BROWNIE PUSZKA 0,354 L PROMOCJA (do 03.10.23)	KAT07253_PROM	\N	0.00	10.00	1075
CIESZYN LAGER BUT. 0,5 L	CIE LAG	5905279156005	0.77	10.00	1076
AMBER KOЏLAK BUT. 0,5 L	AMB_KOZ_BUT_500	5906591000540	0.77	10.00	1077
FUNKY FLUID CLASSY PUSZKA 0,5 L	FF_CALSS_PUSZ_500	5903999514785	0.54	10.00	1078
WIDAWA LE POLONAISE C’T’UNE JOKE’21 MARSALA BA BUT. 0,75 L	WID LEP MAR	5907710904084	1.10	10.00	1079
DUVEL BRELOK DO KLUCZY / OTWIERACZ	KAT06709	5123456791204	0.00	10.00	1080
VITAMINE SEA DUE SOUTH PUSZKA 0,473 L	OMB Due	5123456790112	0.53	10.00	1081
PINTA Upgrade Your September 12,0° can 0,5 l	PI_UPG_CAN_500	5904165105158	0.00	10.00	1082
FILOU THUR POKAL 0,25 L	FILOU THU POK 250	5123456791343	0.00	10.00	1083
MALTGARDEN DEAD PHONE CALLING BUT. 0,5 L	MALT DEA	5907710943977	0.77	10.00	1084
SVIJANY KUFEL SZKLANY 0,5 L	SVI_KUF_SZKL_500	\N	0.00	10.00	1085
TRZECH KUMPLI WEIZEN BUT. 0,5 L	TR WEI	5905669479394	0.77	10.00	1086
MIKKELLER NELSON SAUVIN ORANGE & PASSIONFRIUT BUT. 0,75 L	MIK NEL ORAN 750	818534024733	1.10	10.00	1087
3 FONTEINEN KRYSZTAЈOWA SZKLANKA 0,2 L	KAT06718	5123456791157	0.00	10.00	1088
PINTA Barrel Brewing Liberty 2023 but. 0,33 l	PBB_LIB_2023_BUT_330	5904335577075	0.00	10.00	1089
LAMORAL POKAL 0,33 L	KAT00389	5123456791076	0.00	10.00	1090
KINGPIN RECKLESS PUSZKA 0,5 L	KIN_REC_PUSZ_500	5904730290227	0.54	10.00	1091
KASTEEL RКCZNIK BAROWY	KAST RКC BAR	\N	0.00	10.00	1092
PRAIRIE STANDARD BUT. 0,355 L	PRAI STA	894776000063	0.00	10.00	1093
MIKKELLER SPONTAN CASSIS BUT. 0,375 L	MIK SPON CAS 375	818534013119	0.50	10.00	1094
DE LA SENNE POKAL 0,33 L	KAT05147	5123456791098	0.00	10.00	1095
LITOVEL PЉENIИNЭ LEЋБK 11° KEG 30 L	LIT PSE LEZ K	5123456789886	32.00	10.00	1096
DUVEL TRIPLE HOP CITRA BUT. 0,33 L	DUV TRI CIT 330 ml	5411681401164	0.50	10.00	1097
MOON LARK OUTDOOR. HAZY DIPA PUSZKA 0,5 L	ML_OUT_PUSZ_500	5905255346475	0.54	10.00	1098
ROCKMILL BE WILD #2 0 BUT. 0,75 L	ROCK_BE_WI_#2_0_BUT_750	5906874027547	1.10	10.00	1099
TOOL PAID IN DIAMONDS - CABERNET BUT. 0,375 L	KAT06749	5711474010048	0.50	10.00	1100
TARNOBRZEG SZKLANKA NONIC 0,5 L	TAR_SZKL_NON_500	5123456791455	0.00	10.00	1101
GOЊCISZEWO GУROЈAZ BUT. 0,5 L	GO_GУRO_BUT_500	5903364108984	0.77	10.00	1102
PINTA Double Delivery 18,0° but. 0,5 l	PI_DOU_DEL_BUT_500	5904165104953	0.00	10.00	1103
MAGIC ROAD HAPPY BIRTHDAY PRZYSTANEK BEMOWO PUSZKA 0,5 L	MR_HAP_BIR_PUSZ_500	5905204130995	0.54	10.00	1104
MALTGARDEN NEWS DAILY PUSZKA 0,5 L	MALT NEW	5904050721869	0.54	10.00	1105
PINTA Bluza czarna M	PINTA Blu cza M	5904165100528	0.00	10.00	1106
MALTGARDEN BEAUTY IS POWER PUSZKA 0,5 L	MA_BEA_POW_PUSZ_500	5904050721951	0.54	10.00	1107
STAROPOLSKIE PSZENNE BUT. 0,5 L	STAR PSZ	5905669086806	0.77	10.00	1108
PIWNE PODZIEMIE COSMIC HIGHWAY BUT. 0,5 L	POD_COS_BUT_500	5904305482828	0.77	10.00	1109
MARYENSZTADT UP TO ME BUT. 0,5 L	MAR_UP_TO_BUT_500	5903424615490	0.77	10.00	1110
BIRBANT BINGE DRINKING PUSZKA 0,5 L PROMOCJA (do 10.10.23)	BI BIN DR_PROM	\N	0.00	10.00	1111
RECRAFT JUICY SOUR SERIES – CHERRY X BLUEBERRY PUSZKA 0,5 L	REC_JUI_CHE_PUSZ_500	5900779755871	0.54	10.00	1112
FUNKY FLUID COCONUT ZINGY PUSZKA 0,5 L	FF_COC_ZIN_PUSZ_500	5903999514778	0.54	10.00	1113
IMBIOROWICZ MIУD PITNY TRУJNIAK AIRONIA BUT. 0,375 L	IMB Air 375	5905669820264	0.50	10.00	1114
KAZIMIERZ SPICHLERZ EUROPY BUT. 0,5 L	KAZ SPI	5906660570158	0.77	10.00	1115
BIRBANT LAGER PUSZKA 0,5 L	BI LAG	5904041703430	0.54	10.00	1116
KORMORAN IMPERIUM PRUNUM BUT. 0,375 L	KORM PRU	5902528342387	0.50	10.00	1117
MOCZYBRODA INTO THE VOID PUSZKA 0,5 L	MO_INT_PUSZ_500	5904673800804	0.54	10.00	1118
KORMORAN 1 NA 100 LITE RYE APA BUT. 0,5 L	KORM 1_100	5902528052347	0.77	10.00	1119
ALEBROWAR SON OF THE SON BUT. 0,5 L	ALE_SON_BUT_500	\N	0.77	10.00	1120
PIRAAT RED BUT. 0,33 L	PIR RED 330	5411663000781	0.50	10.00	1121
HOEGAARDEN BLANCHE BUT. 0,33 L	HOEG BLA	5410228141785	0.50	10.00	1122
GRYFUS FLORA BUT. 0,5 L	GRY_FLO_BUT_500	5904905850171	0.77	10.00	1123
PINTA MASTERBAR Vanilla & Coconut 30,0° but. 0,33 l	PI_MAS_VAN_COC_BUT_330	5904165103642	0.00	10.00	1124
MALTGARDEN FOLLOW THE RECIPE BUT. 0,5 L	MALT FOL	5904050721500	0.77	10.00	1125
LIEFMANS FRUITESSE BUT. 0,25 L	LIEF FRU 250	5411686700118	0.35	10.00	1126
STAROPOLSKIE ZЈOTY POTRУJNIE GRYCZANE BUT. 0,5 L	STAR UL POT GRY	5905669086264	0.77	10.00	1127
JAN OLBRACHT KORD JACK WHISKEY BARREL AGED BUT. 0,37 L	JO_KOR_JAC_BUT_370	5902627012822	0.00	10.00	1128
LUBROW PORTERITO PUSZKA 0,33 L	LUB_POR_PUSZ_330	5903686842856	0.35	10.00	1129
GRIMBERGEN FENIKS POKAL 0,33 L	GRI POK FEN 330	5123456791090	0.00	10.00	1130
CIESZYN SZKLANKA SHAKER 0,5 L	CIE SZK SHA	5123456789849	0.00	10.00	1131
MARYENSZTADT BARREL AGED RIS HEAVEN HILL BOURBON WHITE & DARK CHOCOLATE & COCONUT PUSZKA 0,44 L	MAR BA RIS HEA	5903678022082	0.48	10.00	1132
STAROPOLSKIE BESTBIR DZIKA RУЇA BUT. 0,5 L	STAR BES DZIK	5905669086110	0.77	10.00	1133
KAZIMIERZ ORANGE BUT. 0,5 L	KAZ ORA	5906660570011	0.77	10.00	1134
DZIKI WSCHУD TETON PUSZKA 0,5 L	DZIKI TET	5906874369029	0.54	10.00	1135
TRZECH KUMPLI MISTY KEG 30 L	TR MIS K	5123456789486	32.00	10.00	1136
CHERRY CHOUFFE BUT. 0,33 L	CHER CHOUF 330	5410769800097	0.50	10.00	1137
CHYLICZKI CYDR STARY SAD EDYCJA LIMITOWANA BUT. 0,75 L	CHYL STA EDY LIM 750	5905279058279	1.10	10.00	1138
PODGУRZ 652 M N.P.M. BUT. 0,5 L	POD_652_BUT_500	5906874055007	0.77	10.00	1139
SCHNEEEULE WEISSE ROSE BUT. 0,75 L	SCHN WEI ROS	\N	1.10	10.00	1140
MONSTERS JUICY #3  PUSZKA 0,5 L	MO_JUI_#3_PUSZ_500	5905476980595	0.54	10.00	1141
BOON KRIEK KIELISZEK  0,2 L	KAT03831	5123456791169	0.00	10.00	1142
THE BRUERY JARDINIER BUT. 0,75 L	BRU JAR	705105538457	1.10	10.00	1143
JURAJSKIE MOTOCYKLOWE BUT. 0,5 L	JUR MOT	5905331026369	0.77	10.00	1144
TRZECH KUMPLI PILS BUT. 0,5 L	TR PIL	5905669479233	0.77	10.00	1145
TRZECH KUMPLI GOSE MANGO MARAKUJA BUT. 0,5 L	TR GOS MAN	5905669479752	0.77	10.00	1146
ST. LOUIS PREMIUM GUEUZE BUT. 0,25 L	ST LOU GUE	5411081000233	0.35	10.00	1147
PINTA A'la Grodzisz 7,8° but. 0,5 l	PI_ALA_GRO_BUT_500	5904165104311	0.00	10.00	1148
LINDEMANS KOSZULA MКSKA (XL)	KAT02956	5123456791158	0.00	10.00	1149
LINDEMANS FRAMBOISE TAP HANDLE	LIND FRA TAP HAN	5123456791359	0.00	10.00	1150
JURAJSKIE WIЊNIA W CZEKOLADZIE BUT. 0,5 L	JUR WIS	5905331026017	0.77	10.00	1151
FUNKY FLUID FULL CLIP BUT. 0,5 L	FF_FUL_CLI_PUSZ_500	5903999514327	0.77	10.00	1152
LUBROW INFUSED NO. 2 PUSZKA 0,33 L	LUB_INF_NO2_PUSZ_330	5903686842863	0.35	10.00	1153
ZAKЈADOWY Z FARTEM MORDECZKO KEG 30 L	ZA_Z_FART_KEG_30	\N	32.00	10.00	1154
JURAJSKIE SЈODKI DRWAL BUT. 0,5 L	JUR SЈO DRW	5905331026956	0.77	10.00	1155
MARYENSZTADT BARLEY WINE LAPHROIG B.A. BUT. 0,33 L	MAR BAR LAP	5905669542937	0.50	10.00	1156
SCHNEEEULE OTTO BUT. 0,75 L	SCHN OTT	\N	1.10	10.00	1157
CZTERY ЊCIANY REWIR PUSZKA 0,5 L	4SC_REW_PUSZ_500	5905108498849	0.54	10.00	1158
SCHNEIDER KUBEK PLASTIKOWY 0,5 L	SCHN KUB PLA 0,5	5123456791326	0.00	10.00	1159
NEPOMUCEN BERLINER INSIDE – MEET OUR PLACES | EPISODE 01: CHMIELARNIA PUSZKA 0,5 L	NE BER INS	5904041706875	0.54	10.00	1160
WRКЇEL SAIL-ON BUT. 0,5 L	WRE SAIL-ON	5904730465199	0.77	10.00	1161
ANDERSON VALLEY SZKLANKA SHAKER 0,5 L	And Val Szk Sha 5	5123456791394	0.00	10.00	1162
RACIBORSKIE AMERICAN IPA ZW BUT. 0,5 L	RAC_AMER_ZW_BUT_500	5907506252047	0.77	10.00	1163
ZA MIASTEM SPOKУJ DUCHA BUT. 0,5 L	ZAM_SPO_DU_BUT_500	\N	0.77	10.00	1164
PINTA Beskidy Pils 12,0° but. 0,5 l	PI Bes Pil	5904730438926	0.00	10.00	1165
NEPOMUCEN PRECIOUS PUSZKA 0,5 L	NE PRE	5905191386030	0.54	10.00	1166
MIKKELLER SPONTAN BLACKBERRY BUT. 0,375 L	MIK SPON BLAC 375	818534015687	0.50	10.00	1167
GOЊCISZEWO RYCERZ BUT. 0,5 L	GO_RYC_BUT_500	5903364108014	0.77	10.00	1168
CHIMAY BLUE BARRIQUE BUT. 0,75 L	CHIM BLE BAR 750	5410908002344	1.10	10.00	1169
PINTA Dobry Wieczуr 13,0° can 0,5 l PROMOCJA (do 20.11.23)	PI Dob can_PROM	\N	0.00	10.00	1170
TRYBUNAЈ PORTER BAЈTYCKI BUT. 0,5 L	TRY_POR_BAЈ_BUT_500	5905689309978	0.77	10.00	1171
GOЊCISZEWO SURFER BUT. 0,5 L	GO_SURF_BUT_500	5903364108045	0.77	10.00	1172
STU MOSTУW WILD #19 DOUBLE PEACH MIX FERMENTATION SAISON BUT. 0,375 L	STU_WIL_#19_BUT_375	5907614682958	0.50	10.00	1173
WESTMALLE DUBBEL KEG 20 L	KAT00930	5412343001418	21.50	10.00	1174
PIRAAT RED BUT. 0,33 L PROMOCJA (do 07.10.23)	PIR RED 330_PROM	\N	0.00	10.00	1175
CHIMAY BLUE BUT. 0,75 L	CHIM BLU 750	5410908000074	1.10	10.00	1176
ABBAYE OUBLI?E BUT. 0,75 L	ABB_OUB_BUT_750	5425006246354	1.10	10.00	1177
ED RED STROGANOV Z PКCZAKIEM - WIEPRZOWINA	ED_STRO_WIEPRZ	5904083584158	0.00	10.00	1178
PINTA Otwieracz magnes Dobry Wieczуr	PINTA Otw mag Dob	5904165101662	0.00	10.00	1179
DE MOLEN POKAL 0,330 L	KAT06284	5123456791096	0.00	10.00	1180
ST. BERNARDUS PATER 6 BUT. 0,33 L	STB PAT 330	54079007	0.50	10.00	1181
PINTA Risfactor 30,0° keg 20 l	PI Ris Cla keg 20	5123456789782	0.00	10.00	1182
LINDEMANS / MIKKELLER SPONTANBASIL BUT. 0,75 L	LIND SPO 750	5411223010571	1.10	10.00	1183
DUGGES TROPIC THUNDER PUSZKA 0,33 L	DUGG_TRO_THU_PUSZ_330	7350038224903	0.35	10.00	1184
VIGO Kombucha Jagody Acai but. 0,33 l	VIG_YOK_KOM_JAG_BUT_330	5902768514896	0.00	10.00	1185
CANTILLON SAINT LAMVINUS KEG 20 L	KAT04569	5123456789014	21.50	10.00	1186
ROCKMILL SOURLAND #1 PUSZKA 0,5 L	ROCK_SOU_#1_PUSZ_500	5908291862725	0.54	10.00	1187
LA TRAPPE KIELICH 0,25 L	547	5123456791184	0.00	10.00	1188
KASTEEL DONKER BUT. 0,33 L	KAST DON 330	5411081000523	0.50	10.00	1189
TRYBUNAЈ ZERO BUT. 0,5 L	TRY_ZER_BUT_500	5905689311377	0.77	10.00	1190
CZTERY ЊCIANY PALMA PUSZKA 0,5 L	4SC PAL	5906874341933	0.54	10.00	1191
BOON FRAMBOISE KIELISZEK 0,15 L	KAT03833	5123456791170	0.00	10.00	1192
MARYENSZTADT OAT CHOCOLATE RIS HEAVEN HILL KENTUCKY STRAIGHT BURBON WHISKEY & COGNAC B.A. BUT. 0,33 L	MAR OAT CHO RIS HEA	5903424615780	0.50	10.00	1193
JAN OLBRACHT ZESTAW KORD BUT. 0,33 L + POKAL	JO ZES KOR	5902627010873	0.00	10.00	1194
PINTA Otwieracz magnes Modern Drinking	PINTA Otw mag Mod	5904165101655	0.00	10.00	1195
PINTA Jak w dym 18,0° keg 30 l	PI Jak keg 30	5123456789727	0.00	10.00	1196
MIKKELLER PUMA BOKSERKA SPORTOWA CZARNA (L)	MIK PUM L	5123456791121	0.00	10.00	1197
KASTEEL BRIGAND BUT. 0,33 L	KAST BRI	5411081000332	0.50	10.00	1198
PRZETWУRNIA CHMIELU MUS PUSZKA 0,5 L	PCH_MUS_PUSZ_500	5905476980540	0.54	10.00	1199
ALEBROWAR IMPERIAL HERR AXOLOTL BLACK CURRANT BUT. 0,5 L PROMOCJA (do 20.10.23)	ALE IMP HER BLA CUR_PROM	\N	0.00	10.00	1200
YOKO Matcha BIO but. 0,33 l	VIG_YOK_MATCH_BUT_330	5902768514988	0.00	10.00	1201
DZIKI WSCHУD SAMOTNY JEЏDZIEC BUT. 0,5 L	DZIKI SAM	5906874369876	0.77	10.00	1202
STAROPOLSKIE BESTBIR WIЊNIA BUT. 0,5 L	STAR BES WIЊ	5903021503244	0.77	10.00	1203
PINTA A ja Pale Ale 12,0° but. 0,5 l	PI Aja	5904730438582	0.00	10.00	1204
LUBROW DOBRE TAKIE TROPIKALNE! PUSZKA 0,33 L	LUB _DOB_PUSZ_330	5903686842917	0.35	10.00	1205
NEPOMUCEN ATO IPA PUSZKA 0,5 L	NE_ATO_PUSZ_500	5905701060030	0.54	10.00	1206
SMYKAN CYDR ANTONI WISIENKA BUT. 0,5 L	SMYK ANT	5905669332187	0.77	10.00	1207
ED RED POTRAWKA Z PIECZARKAMI Z KASZҐ GR - KURCZAK	ED_POTR_PIECZ	5904083584141	0.00	10.00	1208
RECRAFT POLSKA PSZENICA BUT. 0,5 L	REC POL	5904730663113	0.77	10.00	1209
TRZECH KUMPLI IDIOTA BUT. 0,33 L	TR IDI	5905669479387	0.50	10.00	1210
FUNKY FLUID GELATO: ROSSO PUSZKA 0,5 L	FF_GEL_ROSSO_PUSZ_500	5903999514365	0.54	10.00	1211
DU BOCQ BLANCHE DE NAMUR ZESTAW (3 X BUT. 0,33 L + SZKЈO)	DU BOC ZEST 3X330 + SZK	5411633333017	0.00	10.00	1212
GWAREK PINK PUCKER PUSZKA 0,5 L	GW_PIN_PUSZ_500	5903938751684	0.54	10.00	1213
DZIKI WSCHУD TКPA DZIDA BUT. 0,5 L	DZIKI TКP	5906874369159	0.77	10.00	1214
PINTA RISFACTOR Cinnamon and Cocoa Nibs 30,0° but. 0,33 l	PI RIS CIN COC	5904165103383	0.00	10.00	1215
NEPOMUCEN JOURNEY TO TO THE VALLEY VOL.2 BUT. 0,5 L	NE_JOU_VOL2_BUT_500	5905701060252	0.77	10.00	1216
STAROPOLSKIE THE ART OF HOPPING HARMONIE SINGLE HOP PILS BUT. 0,5 L	STAR_HARM_BUT_500	5903021505514	0.77	10.00	1217
KORMORAN ASTUS MALUM BUT. 0,375 L	KORM AST 2019	5902528000348	0.50	10.00	1218
MARYENSZTADT WILD & FUNKY CHERRY FLANDERS RED ALE BUT. 0,75 L	MAR WIL FUN CHE	5903678022860	1.10	10.00	1219
DELIRIUM ARGENTUM BUT. 0,33 L	DEL ARG 330	5412186003594	0.50	10.00	1220
DUBUISSON BUSH BLONDE TRIPLE BUT. 0,33 L	DUB BUS BLO 330	5411551310817	0.50	10.00	1221
MARYENSZTADT FREEKY ORANGE ALE BUT 0,5 L	MAR FRE ORA ALE	5903424615292	0.00	10.00	1222
GRIMBERGEN TRIPLE BUT. 0,33 L	GRI TRI 330	5410263011661	0.50	10.00	1223
ED RED KONSERWA KURCZAK Z GRZYBAMI Z LASU	ED KUR	5904083584011	0.00	10.00	1224
STAROPOLSKIE THE ART OF HOPPING STYRIAN GOLDING SINGLE HOP IPA BUT. 0,5 L	STAR_STYR_GOL_BUT_500	5903021504951	0.77	10.00	1225
PINTA Atak Chmielu 15,0° but. 0,5 l	PI Ata	5904730438605	0.00	10.00	1226
ALEBROWAR HERR AXOLOTL WITH GRAPEFRUIT BUT. 0,5 L	ALE_HER_GRAP_BUT_500	5907771343457	0.77	10.00	1227
MALTGARDEN GATE NO 7/2022 PUSZKA 0,33 L	MALT GAT 7	5904050721937	0.35	10.00	1228
PINTA RISFACTOR Cinnamon and Cocoa Nibs 30,0° keg 20 l	PI RIS Cin Coc keg 20	5123456789908	0.00	10.00	1229
BIRBANT LOWKEY PUSZKA 0,5 L	BI_LOW_PUSZ_500	5904041703737	0.54	10.00	1230
ZIEMIA OBIECANA TRIPLE LE SZEF PUSZKA 0,5 L	ZO_TRI_LE_SZE_PUSZ_500	5905186484734	0.54	10.00	1231
P?HJALA VARSKE PUSZKA 0,33 L	POH_VAR_PUSZ_330	4742976014655	0.35	10.00	1232
SCHNEIDER TAP01 HELLE WEISSE 11,3° KEG 20 L	Schn TAP1 keg 20	2100006E2AD9B	21.50	10.00	1233
PRZETWУRNIA CHMIELU PRZECIER PUSZKA 0,5 L PROMOCJA (DO 24.10.23)	PCH_PRZ_PUSZ_500_PROM	\N	0.00	10.00	1234
PINTA Hazy Discovery Timisoara can 0,5 l	PI_HD_TIM_CAN_500	5904165105097	0.00	10.00	1235
PRZETWУRNIA CHMIELU SZYSZKA #1 GALAXY-SABRO PUSZKA 0,5 L	PCH_SZY#1_PUSZ_500	5907675597888	0.54	10.00	1236
RADUGA IS THIS JUST FANTASY? PUSZKA 0,5 L	RAD_IS_JUS_PUSZ_500	5902176772000	0.54	10.00	1237
ALEBROWAR LOVELY VIOLA BUT. 0,5 L	ALE_LOV_VIO_BUT_500	5907771340050	0.77	10.00	1238
BROKREACJA SAVAGE 003 BUT. 0,5 L	BRO SAV 3	5904422197056	0.77	10.00	1239
LUBROW BLEND NO. 2 PUSZKA 0,33 L	LUB_BLE_NO2_PUSZ_330	5903686842870	0.35	10.00	1240
MINISTER SALTY TRIP BUT. 0,5 L	MIN_SAL_TRI_BUT_500	5903351660129	0.77	10.00	1241
STRUISE BLACK DAMNATION X - DOUBLE WOOD BUT. 0,33 L	STRU BD X DOU	5425017666103	0.50	10.00	1242
CZTERY ЊCIANY ROSA PUSZKA 0,5 L	4SC_ROS_PUSZ_500	5906874341988	0.54	10.00	1243
STAROPOLSKIE MIODNE BUT. 0,5 L	STAR MIO	5903111989835	0.77	10.00	1244
MAGIC ROAD PERFECT LUNCH PUSZKA 0,44 L	MR_PER_LUN_PUSZ_440	5905204130988	0.48	10.00	1245
LITOVEL MIODOWY BUT. 0,5 L	LIT_MIOD_BUT_500	8593875516711	0.77	10.00	1246
MIO MIO MATE BUT. 0,5 L	MIO_MIO_MAT_BUT_500	4002846034528	0.77	10.00	1247
PINTA Szklanka Atlantik 0,3 l	PINTA Szk Atl	5904165100955	0.00	10.00	1248
INNE BECZKI JUNGLE IPA BUT. 0,5 L	INNE JUN	5905669683005	0.77	10.00	1249
ED RED KONSERWA LECZO Z KIEЈBASҐ Z RUSIBORZA	ED_LECZ	5904083584110	0.00	10.00	1250
FUNKY FLUID MATE PUSZKA 0,5 L	FF_MAT_PUSZ_500	5907772092026	0.54	10.00	1251
SCHNEEEULE IRMGARD KEG 20 L	SCHN IRM KEG 20	\N	21.50	10.00	1252
ARTEZAN LOST IN THE WOODS BUT. 0,5 L	ART_LOS_BUT_500	5904708750777	0.77	10.00	1253
SCHNEEEULE WILDER BILLY SALAT CONTROL W. FUERST WIACEK BUT. 0,75 L	SCHN WIL BIL CON	\N	1.10	10.00	1254
MONVIN BIANCO FRIZZANTE KEG 20 L	MON_FRIZ_KEG_20	8013651024099	21.50	10.00	1255
CANTILLON SAINT-LAMVINUS 2021 BUT.  0,75 L	CAN SAI LAM	5123456790018	0.00	10.00	1256
ALEBROWAR KWAS CHLEBOWY BUT. 0,33 L	ALE_KWA_BUT_330	5907771340012	0.50	10.00	1257
BROKREACJA THE DANCER BUT. 0,5 L	BRO DAN	5905669783279	0.77	10.00	1258
STARA SZKOЈA KOLENDRA BUT. 0,5 L	STA KOL	5906874548059	0.77	10.00	1259
BROKREACJA ERMINE FLAIR PUSZKA 0,5 L	BR_ERM_PUSZ_500	5904422197803	0.54	10.00	1260
O'HARA'S / FIRESTONE WALKER FIБIN HONEY ALE BUT. 0,375 L	Oha Fia	602755011531	0.50	10.00	1261
STU MOSTУW WILD #11 BIERE DE GARDE BUT. 0,375 L	STU WILD#11	5907614680282	0.50	10.00	1262
FUNKY FLUID MOODY PUSZKA 0,5 L	FF_MOO_PUSZ_500	5903999514174	0.54	10.00	1263
BOON OUDE GUEUZE BUT. 0,375 L	BOON OUG 375	5412783052841	0.50	10.00	1264
RODENBACH ROSSO TAP HANDLE	RODEN TAP HAN	5123456791378	0.00	10.00	1265
3 FONTEINEN OUDE KRIEK  2019/20 BUT. 1,5 L	3 FON OUD KRI 1,5	5425007818598	0.00	10.00	1266
ZA MIASTEM SЈODKIE LENISTWO Z KAKAOWCEM BUT. 0,5 L	ZAM SЈO LEN	5906874605240	0.77	10.00	1267
FUNKY FLUID SASSY PUSZKA 0,5 L	FF_SAS_PUSZ_500	5903999513696	0.54	10.00	1268
PIWOJAD SUSKA BUT. 0,5 L	PJAD SUS	5906395053001	0.77	10.00	1269
PIWNE PODZIEMIE DR. HAZY #1 PUSZKA 0,5 L	POD_DR_HAZ_#1_PUSZ_500	5904305482835	0.54	10.00	1270
TRZECH KUMPLI BOCK KEG 30 L	TR BOC K	5123456789462	32.00	10.00	1271
CUVEE DES TROLLS KEG 30 L	CUVE TROL K 30 L	5123456789002	32.00	10.00	1272
TRZECH KUMPLI OATY BUT. 0,5 L	TR OAT	5905669479646	0.77	10.00	1273
PINTA Beskidy Prawdziwe Ciemne 15,0° but. 0,5 l	PI Bes Pra Cie	5904730438995	0.00	10.00	1274
STAROPOLSKIE KULTOWE BEZ GLUTENU PSZENICZNE BUT. 0,5 L	STAR KUL BEZ PSZ	5903021504401	0.77	10.00	1275
ST. FEUILLIEN CUVЙE DE NOEL BUT. 0,33 L	STF NOE 330	5412138303314	0.50	10.00	1276
ЈAСCUT MITYNG BUT. 0,5 L	LAN MIT	5906395997091	0.77	10.00	1277
KASTEEL RUBUS FRAMBOISE KEG 20 L	KAST_RUB_FRA_KEG_20	\N	21.50	10.00	1278
PINTA Kartonik a4	PINTA Kar a4	5123456791292	0.00	10.00	1279
AMBER JOHANNES BUT. 0,5 L	AMB_JOH_BUT_500	5906591001233	0.77	10.00	1280
PINTA Beskidy Pils 12,0° keg 20 l	PI Bes Pil keg 20	5123456789671	0.00	10.00	1281
JACKIE O'S OFF THE BEATEN PATH 3 BUT. 0,5 L	JAC BEA 3	855647004719	0.77	10.00	1282
SOFIA ELECTRIC / PINTA FORTUNE TAMER PUSZKA 0,33 L	PI FOR CAN	3800501676431	0.35	10.00	1283
MIKKELLER OREGON FRUIT SERIES: SPONTANPLUM BUT. 0,375 L	MIK OR PLUM 375	5704255117302	0.50	10.00	1284
STRUISE BLACK DAMNATION VIII - S.H.I.T. BUT. 0,33 L	STRU BD VIII SHI	5425017666080	0.50	10.00	1285
LINDEMANS KRIEK BUT. 0,355 L	LIND KRI 355	5411223101033	0.00	10.00	1286
LINDEMANS FRAMBOISE KEG 25 L	LIND_FRA_KEG_25	\N	28.00	10.00	1287
ST. GUMMARUS TRIPEL BUT. 0,33 L	STG TRI 330	5413699011106	0.50	10.00	1288
CA' DEL BRADO U BACCAROSSA - ITALIAN GRAPE ALE BUT. 0,375 L	CDB_U_BACCAROS_BUT_375	5123456790120	0.50	10.00	1289
LOCO ENERGY LEMON BUT. 0,33 L	BM LOC ENE	5907694918381	0.50	10.00	1290
TRZECH KUMPLI W STYLU GRODZISKIE PUSZKA 0,5 L	TR GRO P	5904252699195	0.54	10.00	1291
SCHNEIDER WEISSE SZKLANKA  ALKOHOFREI 0,5 L	SCHNE SZKL ALK 0,5	5123456791257	0.00	10.00	1292
SCHLENKERLA RAUCHBIER KRAUSEN 11,5° BUT. 0,5 L	SCH KRA	4037458000173	0.77	10.00	1293
SCHNEIDER WEISSE AVENTINUS SZKLANKA 0,3 L	SCHNE SZK AVE 3	5123456791253	0.00	10.00	1294
MATE MOC SABOR CITRUS BUT. 0,33 L	MIO_MAT_MOC_SAB_CIT_BUT_330	5902768762471	0.50	10.00	1295
INNE BECZKI PILZNER BUT. 0,5 L	INNE PIL	5905669683043	0.77	10.00	1296
KINGPIN BURLESCA BUT. 0,33 L	KING BUR	5904730290180	0.50	10.00	1297
MIЈOSЈAW CYDR MIЈOSЈAWSKI PУЈWYTRAWNY BUT. 0,5 L	MIЈ CYD PУЈ	5901687910505	0.77	10.00	1298
STONE ENCORE VERTICAL EPIC 020202 2016 BUT. 0,65 L	KAT02157	636251908323	0.00	10.00	1299
DE MOLEN HAMER & SIKKEL BUT. 0,33 L	KAT06270	8717624421228	0.50	10.00	1300
DE KONINCK TRIPLE D`ANVERS BUT. 0,33 L	219	54107090	0.50	10.00	1301
LINDEMANS GUEUZE CUVEE RENE BUT. 0,375 L	LIND GUE CUV 375	5411223100999	0.50	10.00	1302
GRYBУW PILSVAR STAROSҐDECKIE BUT. 0,5 L	GR STA	5902516000688	0.77	10.00	1303
ZAKЈADOWY WUJEK Z AMERYKI BUT. 0,5 L	ZAKЈ WUJ AME	5906395388400	0.77	10.00	1304
ST. BERNARDUS CHRISTMAS ALE BUT. 0,33 L	STB CHR 330	5411911001768	0.50	10.00	1305
INNE BECZKI SUMMERTIME BUT. 0,5 L	INNE SUM	5901122234654	0.77	10.00	1306
FUNKY FLUID FREE GELATO: BERRIES & CREAM PUSZKA 0,5 L	FF FRE GEL BER CRE	5907772092620	0.54	10.00	1307
NEPOMUCEN CULTO KWAS PUSZKA 0,5 L	NE_CUL_PUSZ_500	5905701060153	0.54	10.00	1308
LINDEMANS BLACHA	KAT05472	5123456791142	0.00	10.00	1309
BIG CHOUFFE BUT. 1,5 L	BIG CHOUF 1,5	5410769100999	0.00	10.00	1310
ЈAСCUT PODBIPIКTA PORTER IMPERIALNY BOURBON B.A. BUT. 0,33 L	LAN POR BBA	5906395997633	0.50	10.00	1311
BOON OUDE KRIEK BUT. 0,75 L	BOON OUK 750	5412783053879	1.10	10.00	1312
MARYENSZTADT SOURTIME AGREST BUT. 0,5 L	MAR SOU AGR	5905669542456	0.77	10.00	1313
BROKREACJA THE DEALER BUT. 0,5 L	BRO DEA	5905669783255	0.77	10.00	1314
RODENBACH GRAND CRU BUT. 0,33 L	RODEN GRA 330	54125032	0.50	10.00	1315
ЈAСCUT POSPOLITE RUSZENIE BUT. 0,5 L	LAN POS	5906395997015	0.77	10.00	1316
TRZECH KUMPLI UNPLUGGED CITRUS APA 0,0% BUT. 0,5 L	TR_UNP_CIT_APA_BUT_500	5904252699799	0.77	10.00	1317
MOCZYBRODA BERRYLICIOUS DELIGHT PUSZKA 0,5 L	MO_BER_PUSZ_500	5904673801085	0.54	10.00	1318
CZTERY ЊCIANY KAMPER BUT. 0,5 L	4SC KAM	5906874341117	0.77	10.00	1319
BROKREACJA POTION #24 BUT. 0,33 L	BR_POT_#24_BUT_330	5904422197780	0.50	10.00	1320
LINDEMANS TABLICA PODЊWIETLANA Z PODSTAWKҐ NA BUTELKI	LIND TAB PODЊ	5123456791370	0.00	10.00	1321
PINTA Kwas Xy 12,0° keg 20 l	PI Xy keg 20	5123456789810	0.00	10.00	1322
MONGOZO BANANA BUT. 0,33 L	MON BAN 330	8715608000025	0.50	10.00	1323
MAGIC ROAD NA STO DWA SZKLANEK PUSZKA 0,5 L	MR_NA_STO_PUSZ_500	5905204130711	0.54	10.00	1324
NEPOMUCEN PIJЇE BUT. 0,5 L	NE PIJ	5905279959972	0.77	10.00	1325
IMBIOROWICZ MIУD PITNY DWУJNIAK MALINOWY BUT. 0,375 L	IMB Dwу Mal 375	5905669820615	0.50	10.00	1326
MOCZYBRODA POCO LOCO BUT.0,5 L	MOCZY POC	5903351761581	0.00	10.00	1327
PINTA Cold Delivery 14,0° keg 30 l	PI_COL_DEL_KEG_30	5123456780036	0.00	10.00	1328
LUPULUS HOPERA BUT. 0,33 L	LUP HOP 330	5425025122011	0.50	10.00	1329
PINTA Party'23 Collab 12,0° can 0,5 l	PI_PAR_23_COL_CAN_500	5904165105011	0.00	10.00	1330
NEPOMUCEN FRUTOLLO PUSZKA 0,5 L	NE FRU	5907709756939	0.54	10.00	1331
ST. FEUILLIEN QUADRUPLE BUT. 0,33 L	STF QUA 330	5412138402604	0.50	10.00	1332
PINTA Hazy Morning 12,0° keg 30 l	PI Haz Mor keg 30	5123456789713	0.00	10.00	1333
AMBER CHMIELOWY BUT. 0,5 L	AMB_CHM_BUT_500	5906591001479	0.77	10.00	1334
OSKAR BLUES CAN-O-BLISS RESINOUS PUSZKA 0,35 L	KAT06505	819942001811	0.00	10.00	1335
KEG PIRAAT 20 L	KEG_PIR	\N	0.00	10.00	1336
PINTA A ja pale ale 12,0° keg 20 l	PI Aja keg 20	5123456789652	0.00	10.00	1337
FUNKY FLUID ASHES & DIAMONDS RAISINS / FIGS / DATES BUT. 0,33 L	FF ASH RAI FIG	5903999511876	0.50	10.00	1338
STAROPOLSKIE MY WAY DOGBERRY-CHERRY WHEAT BUT. 0,5 L	STAR_MY_WAY_DOG_CHE_WHE_BUT_500	5903021505781	0.77	10.00	1339
SOWIE GRAPER BUT. 0,5 L PROMOCJA (do 04.10.23)	SOW_GRA_BUT_500_PROM	\N	0.00	10.00	1340
PIWOJAD TRIPLE MUFFIN BUT. 0,33 L	PJAD TRI MUF	5906395053346	0.50	10.00	1341
ROCKMILL FRIEND OR FOE? ARMAGNAC BA BUT. 0,33 L	ROCK_FR_OR_FO_ARM_BUT_330	5908291862497	0.50	10.00	1342
BIRBANT CLONY PUSZKA 0,5 L	BI_CLO_PUSZ_500	5904041703652	0.54	10.00	1343
ZAKЈADOWY SEZON CZWARTY BUT. 0,5 L	ZA_SEZ_CZW_BUT_500	5907753172136	0.77	10.00	1344
BIRBANT WEIZEN MANGO BUT. 0,5 L	BI WEI MAN	5903240620524	0.77	10.00	1345
PRAIRIE BOMB! DECONSTRUCTED: COFFEE BUT. 0,355 L	PRAI DEC COF	680132989055	0.00	10.00	1346
KEG SCHLENKERLA 30 L	KEG SCHLEN	5123456792019	0.00	10.00	1347
RACIBORSKIE BEZALKOHOLOWE BUT. 0,5 L	RAC BEZ	5907506252504	0.77	10.00	1348
INNE BECZKI FRESH PRINCE BUT. 0,5 L	IN_FRE_PRI_BUT_500	5905669683319	0.77	10.00	1349
MOCZYBRODA FOGGY SUMMIT PUSZKA 0,5 L	MO_FOG_PUSZ_500	5904673800880	0.54	10.00	1350
LEFFE BLONDE BUT. 0,33 L	LEF BLO 330	5410228142089	0.50	10.00	1351
KASTEEL MATA BAROWA (5X KASTEEL)	KAST MAT BAR (5X KAST)	5123456791346	0.00	10.00	1352
JURAJSKIE SZATAСSKA OBELGA BUT. 0,5 L	JUR SZA	5905331025485	0.77	10.00	1353
SCHLENKERLA RAUCHBIER URBOCK 17,5° PARTY-FASS 5 L PROMOCJA (do 31.08.23)	SCH URB PAR-FAS 5_PROM	\N	0.00	10.00	1354
ST. MARTIN BRUNE 8% BUT. 0,33 L	STM BRU 8 330	5411065403326	0.50	10.00	1355
BIRBANT FRIDAY PUSZKA 0,5 L	BI_FRI_PUSZ_500	5904041703676	0.54	10.00	1356
GRODZISKIE BIAЈE BUT. 0,5 L	MIЈ_GRO_BIA_BUT_500	5905279533677	0.77	10.00	1357
ALEBROWAR FREE WAY BUT. 0,5 L	ALE FRE WAY	5907222039526	0.77	10.00	1358
BOON GUEUZE MARIAGE PARFAIT BUT. 0,375 L	BOON GMP 375	5412783052865	0.50	10.00	1359
ZA MIASTEM LETNIA PRZYGODA BUT. 0,5 L	ZAM LET	5906874605103	0.77	10.00	1360
BOON / MIKKELLER OUDE GEUZE BUT. 0,75 L	BOON MIK OUD GUE 750	5412783552709	1.10	10.00	1361
LINDEMANS WIKLINOWY KOSZYK NA LAMBIKI	KAT06836	5123456791005	0.00	10.00	1362
ST. FEUILLIEN SAISON BUT. 0,33 L	STF SAI 330	5412138333311	0.50	10.00	1363
BIRBANT PILS KLASYCZNY BUT. 0,5 L	BI PIL KLA	5903240620418	0.77	10.00	1364
WESTBROOK RHUBARB REMIX BUT. 0,75 L	KAT02738	856467003616	1.10	10.00	1365
PINTA Їytorillo 14,0° keg 20 l PROMOCJA (do 29.09.23)	PI Їyt keg 20_PROM	5123456780019	0.00	10.00	1366
SCHNEIDER TAP07 ORIGINAL KEG 20 L	Schn TAP7 keg 20	2100006B234B9	21.50	10.00	1367
BIRBANT HAWKINS HOPS PUSZKA 0,5 L	BI HAW HOP	5904041703515	0.54	10.00	1368
ARTEZAN BEZ KROPKI TO NIE WITAM BUT. 0,5 L	ART_BEZ_KRO_BUT_500	5904708750784	0.77	10.00	1369
ALEBROWAR ICE PASTRY MASTER BUT. 0,25 L	ALE ICE PAS MAS	5907771341088	0.35	10.00	1370
ZAKЈADOWY WNIOSEK URLOPOWY BUT. 0,5 L	ZA_WNI_URL_BUT_500	5906395388219	0.77	10.00	1371
FORTUNA CZARNE BUT. 0,5 L	MIЈ FOR CZA	5902709615064	0.77	10.00	1372
SOWIE MIODOWE BUT. 0,5 L	SOW_MIO_BUT_500	5907222560181	0.77	10.00	1373
BROWAR JANA PSZENICZNE BUT. 0,5 L	BRO_JA_PSZE_BUT_500	5902429980015	0.77	10.00	1374
STONE SPROCKETBIER BUT. 0,65 L	KAT01808	636251899003	0.00	10.00	1375
PINTA Koszulka їуіta XXL	PINTA Kos їуі XXL	5904165100504	0.00	10.00	1376
NEPOMUCEN THE DARKNESS BUT. 0,5 L	NE_THE_DAR_BUT_500	5905191386061	0.77	10.00	1377
DUBUISSON PECHE MEL BUSH BUT. 0,33 L	DUB PECH BUS 330	5411551130392	0.50	10.00	1378
BOON LAMBIEK 2 YEAR OLD KEG 20 L	BOON LAM 2Y K 20L	\N	21.50	10.00	1379
ST. BERNARDUS CHRISTMAS ALE BUT. 0,75 L	STB CHR ALE 750	5411911004004	1.10	10.00	1380
RADUGA LEON BUT. 0,5 L	RADU LEO	5902176770099	0.77	10.00	1381
NEPOMUCEN BE CAREFUL BUT. 0,5 L	NE BE CAR	5907709756052	0.77	10.00	1382
BROKREACJA MEET THE BARREL #1 - PURE OAK BUT. 0,33 L	BRO MEE #1	5907610243979	0.50	10.00	1383
MAGIC ROAD PRETTY PINEAPPLE, MANGO, PINK GUAVA & PEANUT BUTTER PUSZKA 0,5 L	MR_PRE-PIN-MAN-PIN_PUSZ_500	5905204130902	0.54	10.00	1384
MOCZYBRODA HOPPY HOPAROO PUSZKA 0,5 L	MO_HO_HOP_PUSZ_500	5904673800910	0.54	10.00	1385
NEPOMUCEN CASTLE PARTY PUSZKA 0,5 L	NE_CAS_PUSZ_500	5905701060122	0.54	10.00	1386
DRY & BITTER CZAPKA ZIMOWA BORDOWA	DRY BIT CZA ZIM BOR	5123456791381	0.00	10.00	1387
VAL-DIEU BLONDE BUT. 0,75 L	VAL BLO 750	5413977000266	1.10	10.00	1388
ZAKЈADOWY PROSTY WYBУR BUT. 0,5 L	ZA_PROS_BUT_500	5907753172402	0.77	10.00	1389
STAROPOLSKIE PORTER 180 BUT. 0,5 L	STAR POR 180	5905669086691	0.77	10.00	1390
BOON OUDE GUEUZE VAT 110 BUT. 0,375 L	BOON OUG VAT 110 375	5412783001108	0.50	10.00	1391
DU BOCQ BLANCHE DE NAMUR SZKLANKA 0,33 L	DU BOC BLA DE NAM SZKL 330	5123456791051	0.00	10.00	1392
BAVARIA MALT BUT. 0,33 L	BAV MAL 330	8714800003384	0.50	10.00	1393
KOMES POCZWУRNY BUT. 0,5 L	MIЈ KOM POC	5901687910208	0.77	10.00	1394
VIGO Kombucha BIO Ogуrek Kolendra but. 0,33 l	VIG_KOM_BIO_OG_KOL_BUT_330	5902768514322	0.00	10.00	1395
LINDEMANS PECHERESSE BUT. 0,25 L	LIND PEC 250	5411223100838	0.35	10.00	1396
BROKREACJA TEST DRIVE IPA BUT. 0,5 L	BR_TES_IPA_BUT_500	5905910086005	0.77	10.00	1397
BROKREACJA POTION #23 BUT. 0,33 L	BRO POT#23	5904422197674	0.50	10.00	1398
LINDEMANS PECHERESSE KEG 20 L	LIND PEC K 20 L	5123456789032	21.50	10.00	1399
SCHLENKERLA RAUCHBIER MДRZEN UNGEFILTERET 13,5° BUT. 0,5 L	Sch Mar Ung	4037458021109	0.77	10.00	1400
LA TRAPPE BOCKBIER BUT. 0,75 L	TRAP BOCK 750	8711406136638	1.10	10.00	1401
KAZIMIERZ ALEDЏWIEDЏ BUT. 0,5 L	KAZ ALE DЏW	5906660570028	0.77	10.00	1402
WIDAWA NZ PILS BUT. 0,5 L	WID_NZ_PIL_BUT_500	5907710904220	0.77	10.00	1403
ALEBROWAR CHILLED TO THE BONE BUT. 0,5 L	ALE_CHI_BUT_500	5907771342993	0.77	10.00	1404
BROKREACJA BATTLE MASTER 2023 BUT. 0,33 L	BR_BAT_2023_BUT_330	5905910086012	0.50	10.00	1405
O'HARA'S IRISH RED NITRO K-KEG 30 L	Oha Iri Red Nit k-keg 30	5391500601343	32.00	10.00	1406
GWAREK ZERO INON VOL.2 PUSZKA 0,5 L	GW_ZER_INO_VOL2_PUSZ_500	5903938751721	0.54	10.00	1407
PINTA Koszulka szara XXL	PINTA Kos sza XXL	5904165101297	0.00	10.00	1408
KAZIMIERZ MANGOЈ BUT. 0,5 L	KAZ MAN	5906660570103	0.77	10.00	1409
DUGGES POPSICLE PUSZKA 0,33 L	DUGG_POPS_PUSZ_330	7350038226167	0.35	10.00	1410
KORMORAN JASNY BUT. 0,5 L	KORM JAS	5902528462337	0.77	10.00	1411
ST. FEUILLIEN BLONDE BUT. 0,33 L	STF BLO 330	5412138103310	0.50	10.00	1412
LIMBURGSE WITTE KEG 20 L	LIMB WIT K 20	24242424	21.50	10.00	1413
BOON FRAMBOISE BUT. 0,375 L	BOON FRA 375	5412783055842	0.50	10.00	1414
MIKKELLER SAKIEWKA	MIK SAK	5123456791111	0.00	10.00	1415
NEPOMUCEN SZOSA PUSZKA 0,5 L	NE SZO P	5904041706288	0.54	10.00	1416
WESTMALLE TRIPEL BUT. 0,75 L	WESTMA TRI 750	5412343001227	1.10	10.00	1417
RECRAFT WHITEOUT PUSZKA 0,5 L	REC WHI	5900779755543	0.54	10.00	1418
CANTILLON GUEUZE-LAMBIC KEG 20L	KAT04137	5123456789011	0.00	10.00	1419
NEPOMUCEN BUDDIES PUSZKA 0,5 L	NE BUD	5904555992511	0.54	10.00	1420
TRZECH KUMPLI NESTA PUSZKA 0,5 L	TR_NES_PUSZ_500	5904252699652	0.54	10.00	1421
MONVIN KRAFKA 0,25 L / 0,5 L	MON_KAR_500	5123456791448	0.00	10.00	1422
FUNKY FLUID MY CUP OF TEA PUSZKA 0,5 L	FF_MY_CUP_PUSZ_500	5903999514570	0.54	10.00	1423
KOMES IMPERIAL IPA BUT. 0,5 L	MIЈ KOM IMP IPA	5902838990636	0.77	10.00	1424
KASTEEL ROUGE MATA BAROWA	KAST ROU MAT BAR	5123456791347	0.00	10.00	1425
ZA MIASTEM ЊWIКTY SPOKУJ BUT. 0,5 L	ZAM SWI	5906874605066	0.77	10.00	1426
BIRBANT FOMO PUSZKA 0,5 L	BI_FOM_PUSZ_500	5904041703751	0.54	10.00	1427
MOCZYBRODA CITRUS BLAST PUSZKA 0,5 L	MO_CIT_BLA_PUSZ_500	5904673801115	0.54	10.00	1428
ARTEZAN STUDIUM PRZYPADKU BUT. 0,5 L	ART_STU_PRZ_BUT_500	5904708750524	0.77	10.00	1429
PRIMБTOR PREMIUM LAGER 12° KEG 30 L	PRI PRE K	5123456789917	32.00	10.00	1430
O'HARA'S LEANN FOLLAIN K-KEG 30 L	Oha Lea Fol k-keg 30	5123456791279	32.00	10.00	1431
KORMORAN 1 NA 100 PIGWOWIEC + MIУD BUT. 0,5 L	KORM 1_100 P+M	5902528523311	0.77	10.00	1432
DUGGES DAYDREAM PUSZKA 0,33 L	DUGG_DAY_PUSZ_330	7350038228390	0.35	10.00	1433
TRZECH KUMPLI IGROK BUT. 0,33 L	TR IGR	5905669479684	0.50	10.00	1434
CIESZYN SZKLANKA 0,5 L	CIE SZKL	5123456789850	0.00	10.00	1435
LINDEMANS TAROT D'OR KEG 20 L	LIND_TAR_D'OR_KEG_20	\N	21.50	10.00	1436
JAN OLBRACHT LEGENDY POLSKIE: STRZYGA BA BUT. 0,33 L	JO LP STR BA	5902627012228	0.50	10.00	1437
DZIK CYDR GRUSZKA KEG 30 L	DZIK CYD GRU KEG	5906395413072	32.00	10.00	1438
RADUGA MANGOTRIX BUT. 0,5 L	RAD_MAN_BUT_500	5902176770853	0.77	10.00	1439
ANDERSON JEAN GINIE LAPHROAIG BA BUT. 0,33 L	AND JG LAPH 330	4744175010988	0.50	10.00	1440
RADUGA GAME#4 BUT. 0,5 L	RADU GAM#4	5902176770877	0.77	10.00	1441
DUGGES LUXURY PUSZKA 0,5 L	DUGG_LUX_PUSZ_500	7350038226839	0.54	10.00	1442
ARTEZAN VOLARE BUT. 0,5 L	ART_VOL_BUT_500	5904708750654	0.77	10.00	1443
GULDEN DRAAK POKAL 0,33 L	501	5123456791088	0.00	10.00	1444
LINDEMANS KIELISZEK 3-IN-1 0,25 L	113	5123456791171	0.00	10.00	1445
CANTILLON KRIEK-LAMBIC  KEG 20L	CANT KRI LAM K 20	5123456789013	0.00	10.00	1446
NEPOMUCEN NACHMIELONA CHMIEL+SOSNA+JABЈKO+POMARAСCZA BUT. 0,5 L	NE NACH SOS JAB POM	5905279959996	0.77	10.00	1447
KORMORAN PORTER WARMIСSKI BUT. 0,5 L	KORM POR 500	5902528420016	0.77	10.00	1448
PIWNE PODZIEMIE NOWOCZESNY PILS BUT. 0,5 L	POD_NOW_BUT_500	5906874079409	0.77	10.00	1449
MOCZYBRODA CZAS SURFERУW BUT. 0,5 L	MOCZY CZA	5903351761086	0.77	10.00	1450
MIKKELLER TAP HANDLE	MIK TAP HAN	5123456791331	0.00	10.00	1451
LERVIG MATA BAROWA	LER MAT BAR	5123456791367	0.00	10.00	1452
LUBROW WEST COAST HIGHWAY PUSZKA 0,33 L	LUB_WES_PUSZ_330	5903686842627	0.35	10.00	1453
KRAJAN IRLANDZKIE ZIELONE BUT. 0,5 L	KRA IRL ZIE	5907804436071	0.77	10.00	1454
NEPOMUCEN FOREST IPA BUT. 0,5 L	NE FOR	5905279959521	0.77	10.00	1455
LUBROW ECLARON PILS PUSZKA 0,33 L	LUB_ECL_PUSZ_330	5903686842887	0.35	10.00	1456
ARTEZAN LOW HANGING FRUIT BUT. 0,5 L	ART_LOW_BUT_500	5904708750753	0.77	10.00	1457
STAROPOLSKIE KULTOWE PROZDROWOTNE 0,0% BUT. 0,5 L	STAR KUL PRO	5903021505118	0.77	10.00	1458
ALEBROWAR HOODED BLACK BARLEY BUT. 0,33 L	ALE_HOO_BUT_330	5907771343495	0.50	10.00	1459
BAVIK SUPER WIT PUSZKA 0,33 L	BAV SUP WIT 330	875213001720	0.35	10.00	1460
STRUISE BLACK DAMNATION II - MOCHA BOMB BUT. 0,33 L	STRU BD II MOCH	5425017666028	0.50	10.00	1461
MARYENSZTADT PROJEKT 30 #5 BUT 0,33 L	MAR PRO30 #5	5903678022525	0.00	10.00	1462
RACIBORSKIE PSZENICZNE ZW BUT. 0,5 L	RAC_PSZ_ZW_BUT_500	5907506252450	0.77	10.00	1463
WRКЇEL MALTIC STORM HEAVEN HILL BUT. 0,5 L	WR_MAL_HEA_BA_BUT_500	5904181970297	0.77	10.00	1464
FILOMELOS PERRY ZAGRUSZKA BUT. 0,75 L	FIL_PER_ZAG_BUT_750	5900168509085	1.10	10.00	1465
PINTA MASTERBAR Cocoa Nibs & Orange Peel 30,0° but. 0,33 l	PI_MAS_COC_ORA_BUT_330	5904165104021	0.00	10.00	1466
NEPOMUCEN COMMON GULL PUSZKA 0,5 L	NE_COM_PUSZ_500	5905191386771	0.54	10.00	1467
ZAKЈADOWY Z FARTEM MORDECZKO BUT. 0,5 L	ZA_Z _FAR_BUT_500	5907753172273	0.77	10.00	1468
KINGPIN MANDARIN BUT. 0,5 L	KING MAN	5904730290074	0.77	10.00	1469
TROUBADOUR MAGMA BUT. 0,33 L	TRO MAG 330	5425006700139	0.50	10.00	1470
TRZECH KUMPLI WONDER HAZE PUSZKA 0,5 L	TR WON	5904252699539	0.54	10.00	1471
LINDEMANS APPLE BUT. 0,355 L	LIND APP 355	5411223101095	0.00	10.00	1472
ALEBROWAR BAЈTYCKI DZIAD PILS BUT. 0,5 L	ALE BAЈ PIL	5907771342276	0.77	10.00	1473
TRZECH KUMPLI TRIPADELIC KEG 30 L	TR TRI K	5123456789514	32.00	10.00	1474
MAGIC ROAD CHERRY GIVEAWAY PUSZKA 0,5 L PROMOCJA (do 30.09.23)	MAG CHE_PROM	\N	0.00	10.00	1475
ST. BERNARDUS PRIOR 8 BUT. 0,75 L	STB PRI 750	5411911001362	1.10	10.00	1476
PIWNE PODZIEMIE PERMANENT VACATION PUSZKA 0,5 L	POD_PER_PUSZ_500	5904305482811	0.54	10.00	1477
LINDEMANS MATA BAROWA 57/13	LIN MAT BAR	5123456791137	0.00	10.00	1478
KEG CZECHY (B) 30 L	KEG CZ BOZ	\N	0.00	10.00	1479
FILOMELOS PERRY HULAJ GRUSZKA BUT. 0,75 L	FIL_PER_GRU_BUT_750	5900168509078	1.10	10.00	1480
SCHNEIDER TACA	SCHN TACA	5123456791352	0.00	10.00	1481
KAPITTEL BLONDE BUT. 0,33 L	KAP BLO 330	5412896000432	0.50	10.00	1482
DUGGES BIG LITTLE FIVE PUSZKA 0,5 L	DUGG_BIG_LIT_PUSZ_500	7350038226143	0.54	10.00	1483
NEPOMUCEN CITRUS TIRAMISU PUSZKA 0,5 L	NE_CIT_TIR_PUSZ_500	5905701060313	0.54	10.00	1484
DUVEL NEON	KAT06411	5123456791201	0.00	10.00	1485
P?HJALA OCEAN ROAD PUSZKA 0,33 L	POH_OCE_ROA_PUSZ_330	4742976016093	0.35	10.00	1486
SCHNEEEULE MARIANNA BUT. 0,75 L	SCHN MARI	\N	1.10	10.00	1487
BIRBANT MELLO JELL-OH PUSZKA 0,5 L PROMOCJA (do 11.10.23)	BI MELLO_PROM	\N	0.00	10.00	1488
TRZECH KUMPLI PAN IPANI DOUBLE PUSZKA 0,5 L	TR PAN DOU P	5904252699256	0.54	10.00	1489
KAZIMIERZ PILSIWKO BUT. 0,5 L	KAZ PIL	5906660570219	0.77	10.00	1490
DZIKI WSCHУD ISKA PUSZKA 0,5 L	DZIKI_ISKA_PUSZ_500	\N	0.54	10.00	1491
PINTA Otwieracz magnes Kwas XY	PINTA Otw mag Kwa	5904165101600	0.00	10.00	1492
GRODZISKIE SESSION ALE BUT. 0,5 L	MIЈ GRO SES	5905279533523	0.77	10.00	1493
BLANCHE DE BRUXELLES SZKLANKA 0,33 L	BLA DE BRUX SZKL 330	5123456791053	0.00	10.00	1494
LINDEMANS FARO BUT. 0,355 L	LIND FAR 355	5411223101057	0.00	10.00	1495
SVIJANY WAFLOWNICA	SVI_WAFLO	\N	0.00	10.00	1496
NEPOMUCEN SIMPLY & EASY PUSZKA 0,5 L	NE SIM	5905191386108	0.54	10.00	1497
PINTA Atak Chmielu 15,0° keg 20 l	PI Ata keg 20	5123456789661	0.00	10.00	1498
LINDEMANS BEARDY HIPSTER T-SHIRT (M)	KAT05455	5123456791147	0.00	10.00	1499
TRZECH KUMPLI W STYLU GRODZISKIE KEG 20 L	TR GRO K	5123456789517	21.50	10.00	1500
PRAIRIE CHRISTMAS BOMB! BUT. 0,355 L	PRAI CHR BOM	683318988354	0.00	10.00	1501
WRКЇEL MALTIC STORM BOWMORE BUT. 0,5 L	WR_MAL_BOW_BA_BUT_500	5904181970280	0.77	10.00	1502
GRISETTE POKAL 0,25 L	4338-7253A	5123456791089	0.00	10.00	1503
AYINGER CELEBRATOR BUT. 0,33 L	AYI CEL	4104170022025	0.50	10.00	1504
HOUBLON CHOUFFE BUT. 0,33 L	HOUB CHOUF 330	5410769300085	0.50	10.00	1505
PINTA T-shirt zielony duїe logo M	PINTA Kos DL zie M	5904165102553	0.00	10.00	1506
FUNKY FLUID TRIPLE GELATO: RASPBERRY & RED GRAPE COCONUT BAR PUSZKA 0,5 L	FF_TRI_GEL-RAS-RED-COC_PUSZ_500	5903999513733	0.54	10.00	1507
PIWOTEKA PARУWKOWYM SKRYTOЇERCOM BUT. 0,5 L	PIW_PAR_SKR_BUT_500	5905669428118	0.77	10.00	1508
LUBROW WC IPA PUSZKA 0,33 L	LUB_WC_IPA_PUSZ_330	5900779755123	0.35	10.00	1509
VERHAEGHE CHERRY DUCHESSE DE BOURGOGNE BUT. 0,33 L	VER DUCH CHE 330	5411364151911	0.50	10.00	1510
ED RED TIKKA MASALA Z BRҐZ. RYЇEM - KURCZAK	ED_TIKK_MAS	5904083584172	0.00	10.00	1511
AMBER PO GODZINACH - STOUT BUT. 0,5 L	AMB_STO_BUT_500	5906591001981	0.77	10.00	1512
PINTA Koszulka їуіta L	PINTA Kos їуі L	5904165100481	0.00	10.00	1513
LINDEMANS T-SHIRT DAMSKI SZARY (S)	LIND_TSH_DAM_SZA_S	\N	0.00	10.00	1514
TRZECH KUMPLI W STYLU GRODZISKIE Z GRILOWANYMI CYTRYNAMI PUSZKA 0,5 L	TR GRO CYT	5904252699218	0.54	10.00	1515
FUNKY FLUID GUMMY: PINK PUSZKA 0,5 L PROMOCJA (do 06.10.23)	FF GUM PIN_PROM	\N	0.00	10.00	1516
CANTILLON ROSE DE GAMBRINUS 2022 BUT. 0,75 L	CANT ROS 2022 750	5123456790143	1.10	10.00	1517
SAISON DUPONT BIOLOGIGUE BUT. 0,75 L	SAIS DUP BIO 750	5410702000812	1.10	10.00	1518
PINTA BARREL BREWING INFLAME 12,0° BUT. 0,375 L	PBB_INFL_BUT_375	5904335577617	0.50	10.00	1519
SAISON DUPONT SZKLANKA 0,33 L	1035	5123456791027	0.00	10.00	1520
P?HJALA SATURNUS PUSZKA 0,44 L	POH_SAT_PUSZ_440	4742976015911	0.48	10.00	1521
BROWAR JANA ZESTAW 2 x BUT. 0,5 L	BRO_JA_ZEST_500	\N	0.77	10.00	1522
BALADIN XYAUYU BARREL 2017 BUT. 0,5 L	Bal Xya Bar	8032942290548	0.77	10.00	1523
VAL-DIEU TRIPLE BUT. 0,33 L	VAL TRI 330	5413977000037	0.50	10.00	1524
RACIBORSKIE PYRSK CYTRYNA-KONOPIA BUT. 0,33 L	RAC_PY_CYT_KON_BUT_330	5905249834094	0.50	10.00	1525
PINTA T-shirt szary duїe logo L	PINTA Kos DL sza L	5904165102515	0.00	10.00	1526
BROKREACJA THE BARBER BUT. 0,5 L	BRO BAR	5905669783644	0.77	10.00	1527
BOSTEELS PAUWEL KWAK BUT. 0,75 L	BOST KWAK 750 L	5410228285182	1.10	10.00	1528
TRZECH KUMPLI TRIPADELIC BUT. 0,5 L	TR TRI	5905669479127	0.77	10.00	1529
STU MOSTУW ART+70 PUSZKA 0,44 L	STU_ART70_PUSZ_440	5907614683221	0.48	10.00	1530
HOEGAARDEN GRAND CRU BUT. 0,33 L	HOEG GRA 330	5410228141921	0.50	10.00	1531
MAGIC ROAD SUNRISE PUSZKA 0,5 L PROMOCJA (do 15.10.23)	MR_SUN_PUSZ_500_PROM	\N	0.00	10.00	1532
MIЈOSЈAW & MAKЈOWICZ ARCY IPA BUT. 0,5 L	MIЈ_ARC_IPA_BUT_500	5902838991343	0.77	10.00	1533
PINTA Barrel Brewing Moss but. 0,33 l	PBB_MOS_BUT_330	5904335577563	0.00	10.00	1534
PINTA Barrel Brewing Pokal Teku 0,1 l	PBB Pok Tek 0,1	5904335577051	0.00	10.00	1535
BOON GEUZE SZKLANKA 0,375 L	KAT03830	5123456791049	0.00	10.00	1536
REVOLTA NON ALCOHOLIC LEMON EARL GREY AIPA BUT. 0,5 L	REV_NON_LEM_EAR_BUT_500	5900470056000	0.77	10.00	1537
ZA MIASTEM PEЈEN LUZ BUT. 0,5 L	ZAM PEЈ LUZ	5906874605141	0.77	10.00	1538
ST. FEUILLIEN GRAND CRU BUT. 0,75 L	STF GRA CRU 750	5412138617510	1.10	10.00	1539
KAZIMIERZ ILE TO MA IBU? BUT. 0,5 L	KAZ ILE	5906660570271	0.77	10.00	1540
VERHAEGHE CHOCOLATE CHERRY DUCHESSE DE BOURGOGNE BUT. 0,33 L	VER DUCH CHO CHE 330	5411364151928	0.50	10.00	1541
LUBROW BERLIBERRY PUSZKA 0,33 L	LUB_BER_PUSZ_330	5903686842894	0.35	10.00	1542
BROKREACJA PIRATE BAY BUT. 0,5 L	BR_PIR_BUT_500	5904422197810	0.77	10.00	1543
LA TRAPPE WITTE BUT. 0,33 L	TRAP WIT 33	8711406985489	0.50	10.00	1544
BOON FARO BUT. 0,25 L	BOON FAR 250	5412783054012	0.35	10.00	1545
PRAIRIE BOMB! DECONSTRUCTED: CHILLI BUT. 0,355 L	PRAI DEC CHI	680132989055	0.00	10.00	1546
FILOMELOS CYDR SPOKOJNY JABЈKOWY BUT. 0,75 L	FIL_CYD_SPO_BUT_750	5900168509023	1.10	10.00	1547
TRZECH KUMPLI BOCK BUT. 0,5 L	TR BOC	5905669479509	0.77	10.00	1548
ST. BERNARDUS PRIOR 8 KEG 20 L	STB PRI K 20	5123456789439	21.50	10.00	1549
MARYENSZTADT THE ROOTS#10 PUSZKA 0,5 L PROMOCJA (do 19.10.23)	MAR THE ROO#10_PROM	\N	0.00	10.00	1550
DEER BEAR SCOUT PUSZKA 0,5 L	DE_SCO_PUSZ_500	5905204172155	0.54	10.00	1551
P?HJALA SUN CITY PUSZKA 0,44 L	POH_SUN_PUSZ_440	4742976015133	0.48	10.00	1552
SCHLENKERLA RAUCHBIER MДRZEN 13,5° PARTY-FASS 5 L	SCH MAR PAR-FAS	4037458100200	0.00	10.00	1553
Dalons / PINTA Indian Baltic Porter 20,0° but. 0,33 l	DAL_PIN_IND-BUT_330	3770012486549	0.00	10.00	1554
DE LA SENNE SAISON BUT. 0,33 L	DE LA SEN SAIS 330	5425029020832	0.50	10.00	1555
TRZECH KUMPLI BREW NOTE BUT. 0,5 L	TR BRE	5905669479363	0.77	10.00	1556
LA TRAPPE WITTE TRAPPIST BUT. 0,75 L	KAT06264	8711406103876	1.10	10.00	1557
RADUGA TRAPEZE BUT. 0,5 L	RADU TRA	5907431705359	0.77	10.00	1558
PIWNE PODZIEMIE ICE TEA BERLINER PUSZKA 0,5 L	POD_ICE_PUSZ_500	5904305482378	0.54	10.00	1559
WRКЇEL ZERO BUT. 0,5 L	WRE ZER B	5904181970105	0.77	10.00	1560
WIDAWA SIMCOE PILS BUT. 0,5 L	WID SIM 500	5907710904220	0.77	10.00	1561
STAROPOLSKIE BESTBIR PIERNIK ZE ЊLIWKҐ BUT. 0,5 L	STAR_BES_PIER_SLI_BUT_500	5903021500243	0.77	10.00	1562
MAGIC ROAD WILD PRETTY #10 RIOJA BARREL AGED PUSZKA 0,33 L	MR_WIL_PRE_RIO_PUSZ_330	5905204130629	0.35	10.00	1563
BOON SCHAARBEEKSE KRIEK BUT. 0,375 L	BOON SCH	5412783153258	0.50	10.00	1564
DEER BEAR LET'S COOK APRICOT-LIME PUSZKA 0,5 L	DE_LET-APR-LIM_PUSZ_500	5906395303069	0.54	10.00	1565
BOON KRIEK KIELISZEK 0,3 L	KAT03832	5123456791168	0.00	10.00	1566
LINDEMANS FLAGA	KAT05485	5123456791139	0.00	10.00	1567
KINGPIN MARQUIS BUT. 0,33 L	KING MAR	5904730290555	0.50	10.00	1568
MARYENSZTADT SMOOTHIE BEER SWEET MANGO-COCONUT-ORANGE-VANILLA-WHITE CHOCOLATE PUSZKA 0,5 L	MAR_SMO_BEE_MAN-COC-ORA_PUSZ_500	5903424615537	0.54	10.00	1569
JAN OLBRACHT LEGENDY POLSKIE: CZART BA BUT. 0,33 L	JO LP CZA BA	5902627012242	0.50	10.00	1570
MAGIC ROAD ONE HUNDRED TOGETHER PUSZKA 0,5 L	MR_ONE_HUN_PUSZ_500	5905204131084	0.54	10.00	1571
PINTA typ niepoHOPny 12,0° but. 0,5 l PROMOCJA (do 27.10.23)	PI_TYP_BUT_500_PROM	\N	0.00	10.00	1572
LEFFE BRUNE BUT. 0,33 L	LEF BRU 330	5410228146162	0.50	10.00	1573
KEG BELGIA A3	KAT01419ref	5123456792002	0.00	10.00	1574
KAZIMIERZ SZKLANKOWY KIWOGREST BUT. 0,5 L	KAZ_SZK_BUT_500	5906660570462	0.77	10.00	1575
DZIKI WSCHУD SZALONY KOС BUT. 0,5 L	DZIKI SZA	5906874369296	0.77	10.00	1576
REVOLTA EARL GREY AIPA BUT. 0,5 L	REV_EAR_BUT_500	5900470050008	0.77	10.00	1577
MOCZYBRODA NEKTAR BOGУW BUT. 0,5 L	MOCZY NEK	5903351761208	0.77	10.00	1578
LUBROW TRDELNIK PUSZKA 0,33 L	LUB_TRD_PUSZ_330	5903686842726	0.35	10.00	1579
MALTGARDEN MUSEUM OF CLASSIC BEERS (HALLERTAUER PILS) BUT. 0,5 L	MALT MUS HAL	5905669632546	0.77	10.00	1580
ARTEZAN S’MORES BUT. 0,5 L	ART_SMO_BUT_500	5904708750821	0.77	10.00	1581
IMBIOROWICZ MIУD PITNY TRУJNIAK ЇҐDЈO Z KAWҐ BUT. 0,5 L	IMB Їad kaw 500	5905669820462	0.77	10.00	1582
ZA MIASTEM WЈASNE SPRAWY BUT. 0,5 L	ZAM WLA	5906874605035	0.77	10.00	1583
GOЊCISZEWO BABA JAGA BUT. 0,5 L	GO_BAB_BUT_500	5903364108885	0.77	10.00	1584
BROKREACJA ALL BEERS MATTER - OLD ALE BUT. 0,5 L	BR_ALL_OLD_BUT_500	5904422197988	0.77	10.00	1585
DELIRIUM NOЛL BUT. 0,75 L	DEL NOE 750	5412186000975	1.10	10.00	1586
VEDETT WHITE BUT. 0,33 L	VED WHI 330	5411681400310	0.50	10.00	1587
CHYLICZKI CYDR IMBIROWY SAD BUT. 0,33 L	CHY_IMB_SAD_BUT_330	5905279058323	0.50	10.00	1588
WESTMALLE DUBBEL BUT. 0,33 L	WESTMA DUB 330	5412343152332	0.50	10.00	1589
MALTGARDEN THE MIDDLE OF SILENCE 2022 ICE EDITION BUT. 0,25 L	MALT THE MID ICE 2022	5904050721517	0.35	10.00	1590
BIRBANT DELUSION PUSZKA 0,5 L	BI_DEL_PUSZ_500	5904041703720	0.54	10.00	1591
PINTA Kwas Gamma 13,0° but. 0,5 l	PI Gam but	5903990622052	0.00	10.00	1592
DUVEL BUT. 0,75 L	DUV 750	5411681402635	1.10	10.00	1593
ZAKЈADOWY Z CAЈYM SZACUNKIEM BUT. 0,5 L	ZA_Z_CAЈ_BUT_500	5907753172341	0.77	10.00	1594
STU MOSTУW ALL INCLUSIVE PUSZKA 0,44 L	STU_ALL_IN_PUSZ_440	5907614683184	0.48	10.00	1595
KASTEEL TRIPEL BUT. 0,33 L	KAST TRI 330	5411081000677	0.50	10.00	1596
BALADIN XYAUYU FUME 2016 BUT. 0,5 L	Bal Xya Fum	8032942290586	0.77	10.00	1597
LERVIG ORIGINAL SIN PUSZKA 0,33 L	OMB Ler Ori	7072712006505	0.35	10.00	1598
GWAREK ZERO MATES LIQUID YELLOW BUT. 0,5 L	GW_ZER_MAT_YEL_BUT_500	5903938751738	0.77	10.00	1599
ACHEL BRUIN 8% BUT. 0,33 L	ACH BRU 330	5425007658880	0.50	10.00	1600
BOON OUDE GUEUZE BUT. 0,75 L	BOON OUG 750	5412783052193	1.10	10.00	1601
ST. BERNARDUS CHRISTMAS ALE KEG 20 L	STB CHR K	5123456789438	21.50	10.00	1602
DELIRIUM NOCTURNUM BUT. 0,75 L	DEL NOC 750	5412186000722	1.10	10.00	1603
PINTA Psst... It's Your Weekend IPA - West Coast IPA 15,0° but. 0,5 l	PI_PSST_YOU_WEST_BUT_500	5904165104717	0.00	10.00	1604
ZAKЈADOWY POZAMIATANE BUT. 0,5 L	ZA_POZ_BUT_500	5907753172310	0.77	10.00	1605
MOCZYBRODA MOTHER OF DRAGONS GUANABANANA EDITION BUT. 0,5 L	MOCZY MOT GUA	5903351761444	0.77	10.00	1606
STELLA ARTOIS SZKLANKA 0,25 L	KAT05699	5123456791026	0.00	10.00	1607
NOOK EBONO BUT. 0,33 L	NOOK EBO	5903240848409	0.50	10.00	1608
LINDEMANS KRIEK BUT. 0,25 L	LIND KRI 250	5411223100463	0.35	10.00	1609
WESTMALLE EXTRA BUT. 0,33 L	WESTMA EXT 330	5412343000749	0.50	10.00	1610
RECRAFT HAZY APA BUT. 0,5 L	REC_HAZ_APA_BUT_500	5900779755888	0.77	10.00	1611
TRZECH KUMPLI PAN IPANI DOUBLE BUT. 0,5 L	TR PAN DOU	5905669479257	0.77	10.00	1612
RACIBORSKIE SUMMER ALE CANNABIS EDITION BUT. 0,5 L	RAC_SUM_CAN_BUT_500	5905249834063	0.77	10.00	1613
FLORIS APPLE BUT. 0,33 L	FLO APP 330	5412186001095	0.50	10.00	1614
MIЈOSЈAW MARCOWE BUT. 0,5 L	MIЈ MAR	5902709615286	0.77	10.00	1615
PRZETWУRNIA CHMIELU ЈUSKA PUSZKA 0,5 L	PCH_ЈUS_PUSZ_500	5905476980557	0.54	10.00	1616
CZTERY ЊCIANY MURAWA PUSZKA 0,5 L	4SC MUR	5905108498221	0.54	10.00	1617
CIGAR CITY FAIR EXCHANGE PUSZKA 0,355 L	CIGAR FAI	850005189756	0.00	10.00	1618
DZIKI WSCHУD CHMIELOBRANIE Z KOFEINҐ BUT. 0,5 L	DZIKI CHM KOF	5900779755819	0.77	10.00	1619
SCHNEIDER TAP01 HELLE WEISSE 11,3° BUT. 0,5 L	Schn TAP1	4003669016807	0.77	10.00	1620
ЈAСCUT ANGLOSAS BUT. 0,5 L	LAN ANG	5906395997251	0.77	10.00	1621
KORMORAN 6-PAK ЊWIEЇE BUT. 0,375 L PROMOCJA (do 10.10.23)	KOR_6PAK_SWI_BUT_375_PROM	\N	0.00	10.00	1622
MOCZYBRODA LSD (LIGHT SOUR DELICIOUS) BUT. 0,5 L	MOCZY LSD	5903351761307	0.77	10.00	1623
BROKREACJA SEA BREEZE PUSZKA 0,5 L	BR_SEA_PUSZ_500	5904422197902	0.54	10.00	1624
PINTA T-shirt biaіy duїe logo M	PINTA Kos DL bia M	5904165102454	0.00	10.00	1625
CINEY BLOND BUT.0,25 L	CIN BLO 250	54055308	0.00	10.00	1626
PINTA Їytorillo 14,0° keg 30 l	PI Їyt keg 30	5123456780024	0.00	10.00	1627
PETRUS RED KIELICH 0,25 L	KAT06921	5123456791177	0.00	10.00	1628
CHYLICZKI CYDR SWEET OAK 2019 BUT. 0,5 L	CHYL SWE OAK 2019 500	5123456790090	0.77	10.00	1629
WRКЇEL ZERO Z MANGO BUT. 0,5 L	WRE_ZER_MAN_BUT_500	5904181970525	0.77	10.00	1630
SAISON DUPONT BIOLOGIQUE BUT. 0,33 L	SAIS DUP BIOL 330	5410702000836	0.50	10.00	1631
PINTA Otwieracz magnes Ala Grodziskie	PINTA Otw mag Ala	5904165101679	0.00	10.00	1632
FUNKY FLUID GELATO: GIALLO PUSZKA 0,5 L	FF_GEL_GIA_PUSZ_500	5903999514792	0.54	10.00	1633
MARYENSZTADT KLASYCZNIE GOSE BUT 0,5 L	MAR_KLA_GOS_BUT_500	5903678022112	0.00	10.00	1634
BOSTEELS PAUWEL KWAK BUT. 0,33 L	BOST KWA 330	54050051	0.50	10.00	1635
STAROPOLSKIE BESTBIR PACIFIC MANGO I ANANAS BUT. 0,5 L	STAR BES PAC MAN ANA	5905669086653	0.77	10.00	1636
PODGУRZ MAЈY ALE WARIAT BUT. 0,5 L	POD_MAЈ_BUT_500	5906874055540	0.77	10.00	1637
3 FONTEINEN HOMMAGE BIO FRAMBOOS 2018/2019 BUT. 0,375 L	3 FON HOM BIO FRA 18/19 375	5425007818314	0.50	10.00	1638
ST. BERNARDUS DUЇA FLAGA	STB DUЇ FLA	5123456791384	0.00	10.00	1639
LES INTENABLES MANU MILITARI BIERE PUSZ. 0,33 L	LES INT MAN MIL BIE	3770017907445	0.00	10.00	1640
PINTA Barrel Brewing Scarlet but. 0,75 l	PBB_SCA_BUT_750	5904335577556	0.00	10.00	1641
CHYLICZKI CYDR SZARA & ZЈOTA RENETA BUT. 0,33 L	CHY_SZA|_ZЈO_BUT_330	5905279058316	0.50	10.00	1642
BIRBANT PORTER BAЈTYCKI KLASYCZNY BUT. 0,5 L	BI POR KLA	5903240620470	0.77	10.00	1643
L'INSTANT WORLD OF HOPS PUSZ. 0,44 L	LIN WOR OF HOP	3770011969425	0.00	10.00	1644
STAROPOLSKIE CHMIELNE BUT. 0,5 L	STAR CHM	5903111989873	0.77	10.00	1645
RODENBACH VINTAGE 2021 BUT. 0,75 L	RODEN_VIN_2021_750	5410583804196	1.10	10.00	1646
IGNACУW CYDR AMARUS BUT. 0,5 L	IGNAC_AMAR_BUT_500	\N	0.77	10.00	1647
3 FONTEINEN HOMMAGE 2019/20 BUT. 0,375 L	3 FON HOM 19/20 375	5425007818192	0.50	10.00	1648
REVOLTA  ALKOHOLFREE 0% TONIC & LEMON EARL GREY AIPA BUT. 0,5 L	REV_ALK_TON_LEM_BUT_500	5900470095009	0.77	10.00	1649
MOCZYBRODA REBEL RAIDER BUT. 0,5 L	MO_REB_BUT_500	5904673800903	0.77	10.00	1650
STONE CRIME BUT. 0,5 L	KAT03012	636251870415	0.77	10.00	1651
ZA MIASTEM DZIEС WOLNY BUT. 0,5 L	ZAM DZI	5906874605028	0.77	10.00	1652
CA' DEL BRADO NESSUN DORMA - SOUR ALE BUT. 0,375 L	CDB_NES_DOR_BUT_375	\N	0.50	10.00	1653
P?HJALA BALTIC PORTER DAY BA 2022 BUT. 0,33 L	POH BAL POR DAY BA	4742976015829	0.50	10.00	1654
BROKREACJA ALL BEERS MATTER - ENGLISH IPA BUT. 0,5 L	BR_ALL_ENG_BUT_500	5904422197971	0.77	10.00	1655
HOLBA ЉERБK 11° KEG 30 L	HOL SER K	\N	32.00	10.00	1656
P?HJALA CHВTEAU NOIR BUT. 0,33 L	POH CHA	4742976014778	0.50	10.00	1657
CHYLICZKI CYDR SZARA & ZЈOTA RENETA 2021 BUT. 0,75 L	CHYL SZA ZЈO 750	5905279058057	1.10	10.00	1658
DUGGES HEAT PUSZKA 0,33 L	DUGG_HEA_PUSZ_330	7350038225887	0.35	10.00	1659
LINDEMANS FARO SZKLANKA 0,25 L	140	5123456791040	0.00	10.00	1660
ARTEZAN AND THE PLANETS ARE GOING CRAZY BUT. 0,5 L	ART_AND_BUT_500	5904708750791	0.77	10.00	1661
ENAME POKAL 0,33 L	821	5123456791093	0.00	10.00	1662
ED RED KONSERWA ЇEBERKA W SOSIE BBQ Z CHILI	ED ЇEB	5903940086514	0.00	10.00	1663
ROCKMILL BE WILD #3 0 BUT. 0,75 L	ROCK_BE_WI_#3_0_BUT_750	5906874027516	1.10	10.00	1664
CZTERY ЊCIANY TROPIK DOUBLE PUSZKA 0,5 L	4SC_TRO_DOUB_PUSZ_500	5906874341780	0.54	10.00	1665
PINTA Psst... It's Your Weekend IPA - Hazy IPA 15,0° but. 0,5 l	PI_PSST_YOU_HAZ_BUT_500	5904165104694	0.00	10.00	1666
LITOVEL ИERNY CITRON 4% BUT. 0,5 L	LIT_CER_CIT_BUT_500	8593875518418	0.77	10.00	1667
TRZECH KUMPLI HOPPY WEIZEN BUT. 0,5 L	TR_HOP_WEI_BUT_500	5904252699546	0.77	10.00	1668
TRZECH KUMPLI OATY BUT. 0,33 L	TR_OAT_BUT_330	5904252699751	0.50	10.00	1669
P?HJALA OHTU PUSZKA 0,33 L	KAT06432	4742976013726	0.35	10.00	1670
LINDEMANS OTWIERACZ	KAT05476	5123456791135	0.00	10.00	1671
BROKREACJA POTION #21 BUT. 0,33 L	BRO POT#21	5904422197445	0.50	10.00	1672
STAROPOLSKIE BESTBIR MALINA I PIGWA BUT. 0,5 L	STAR BES MAL PIG	5903111989989	0.77	10.00	1673
P?HJALA ЦЦ BUT. 0,33 L	POH OO	4742976010015	0.50	10.00	1674
CHIMAY BLUE BUT. 0,33 L	CHIM BLU 330	5410908000036	0.50	10.00	1675
SCHLENKERLA SZKLANKA WEIZEN 0,5 L	Sch szk Wei 0,5	5123456789848	0.00	10.00	1676
TRZECH KUMPLI AMERICAN BEAUTY KEG 30 L	TR AME K	5123456789457	32.00	10.00	1677
NEPOMUCEN LIKE A FOREST PUSZKA 0,5 L	NE LIK P	5907709756540	0.54	10.00	1678
NEPOMUCEN NACHMIELONA CHMIEL+WODA PUSZKA 0,5 L	NE_NACH_CHM-WOD_PUSZ_500	5905191386689	0.54	10.00	1679
P?HJALA - WEIHENSTEPHAN ZEIT BUT. 0,33 L	POH_WEI_ZEI_BUT_330	4742976016079	0.50	10.00	1680
NEPOMUCEN NACHMIELONA CHMIEL+JABЈKO+CYTRYNA PUSZKA 0,5 L	NE_NACH_JAB-CYT_PUSZ_500	5905191386696	0.54	10.00	1681
PETRUS TRADITION ZESTAW (3X 0,33 L + SZKЈO)	PET TRA ZES 3X330 + SZ	5411831002500	0.00	10.00	1682
BOON OUDE GUEUZE VAT 92 BUT. 0,375 L	BOON OUG VAT 92 375 ml	5412783000927	0.50	10.00	1683
RECRAFT BLACK CURRIS BUT. 0,33 L	REC BLA CUR	5900779755086	0.50	10.00	1684
STU MOSTУW AMERICAN UNCLE PUSZKA 0,44 L PROMOCJA (do 10.10.23)	STU_AME_UNC_PUSZ_440_PROM	\N	0.00	10.00	1685
BOURGOGNE DES FLANDRES BRUNE BUT. 0,33 L	BOUR FLAN BRU 330	5411516000517	0.50	10.00	1686
ZA MIASTEM 5TH ELEMENT ALCOHOL FREE APA BUT. 0,5 L	ZAM_5TH_FRE_APA_BUT_500	5904905630193	0.77	10.00	1687
P?HJALA HELGE PUSZKA 0,33 L	KAT06632	4742976013535	0.35	10.00	1688
OUD BEERSEL OUDE GUEUZE VANDERVELDEN 140 YEARS BUT. 0,375 L	OUD OUG VAN 140 375	5425018071234	0.50	10.00	1689
GOЊCISZEWO SZEWC BUT. 0,5 L	GO_SZEW_BUT_500	5903364108991	0.77	10.00	1690
CHIMAY GOLD BUT. 0,33 L	CHIM GOL 330	5410908000128	0.50	10.00	1691
ALEBROWAR SINGLE HOP EL DORADO BUT. 0,5 L	ALE_SH_EL_DOR_BUT_500	5907771343242	0.77	10.00	1692
BROWARNY EVIL BOY PUSZKA 0,5 L	BROW_EVI_PUSZ_500	5905450141134	0.54	10.00	1693
ZAKЈADOWY BUMELANT BUT. 0,5 L PROMOCJA (do 04.10.23)	ZA_BUM_BUT_500_PROM	\N	0.00	10.00	1694
ALEBROWAR LADY BLANCHE BUT. 0,5 L	ALE LAD	5907222039137	0.77	10.00	1695
NEPOMUCEN ACIDO BUT. 0,5 L	NE ACI	5905279959637	0.77	10.00	1696
MARYENSZTADT OAT WINE BLENDED SINGLE MALT WHISKY BUT. 0,33 L	MAR OAT BLE SIN WHI	5905669542920	0.50	10.00	1697
MALTGARDEN A TASTE OF MADNESS BUT. 0,5 L	MALT A TAS	5904050721876	0.77	10.00	1698
KAZIMIERZ DOBRE TO TO WYSZЈO #2 BUT. 0,5 L	KAZ DOB #2	5906660570509	0.77	10.00	1699
ST. BERNARDUS PRIOR 8 BUT. 0,33 L	STB PRI 330	54079014	0.50	10.00	1700
P?HJALA PRENZLAUER PUSZKA 0,33 L	KAT07115	4742976013498	0.35	10.00	1701
CIESZYN PORTER BAЈTYCKI BARREL AGED BUT. 0,33 L	CIE POR BA	5905279156531	0.50	10.00	1702
TRZECH KUMPLI WКDZONY PORTER BAЈTYCKI BUT. 0,5 L	TR_WED_POR_BUT_500	5904252699638	0.77	10.00	1703
CIESZYN PILSNER KEG 30 L	CIE_PIL_KEG_30	\N	32.00	10.00	1704
ALEBROWAR HERR AXOLOTL WITH APPLE & LIME BUT. 0,5 L	ALE_HER_APP-LIM_BUT_500	5907771340074	0.77	10.00	1705
STONE SNIFTER STONE 0,33 L	KAT01826	5123456791058	0.00	10.00	1706
PIWNE PODZIEMIE APRICOT GOSE KEG 30 L	POD_APR_KEG_30	\N	32.00	10.00	1707
PINTA Koszulka czarna XL	PINTA Kos cza XL	5904165100399	0.00	10.00	1708
MARYENSZTADT SOURTIME BERLINER WEISSE TRUSKAWKA BUT. 0,5 L	MAR_SOU_BER_TRU_BUT_500	5903424615254	0.77	10.00	1709
GEKKO BEERS SLINGSHOT PUSZ. 0,44 L PROMOCJA (do 05.10.23)	GEK BEE SLIN_PROM	\N	0.00	10.00	1710
DZIKI WSCHУD WILD WILD EAST - PEATED DARK WILD ALE BUT. 0,375 L	DZ_WIL_WIL_EAS_PEA_DAR_WIL_BUT_375	5906874369906	0.50	10.00	1711
BROWAR JANA APA BUT. 0,5 L	BRO_JA_APA_BUT_500	5902429980022	0.77	10.00	1712
HARPAGAN BAROTRAUMA TOBACCO BUT. 0,33 L	HAR_BAR_BUT_330	5905316580046	0.50	10.00	1713
ARTEZAN MERA IPA BUT. 0,5 L	ARTEZ MER	5904730574013	0.77	10.00	1714
STAROPOLSKIE KULTOWE PILS BUT. 0,5 L	SAR KUL PIL	5905669086455	0.77	10.00	1715
PALATUM ETERNAL ECLIPSE COCOA EDDITON PUSZKA 0,5 L	PAL_ETE_ECL_COC_PUSZ_500	5905159520179	0.54	10.00	1716
WIDAWA LE POLONAIS C'T'UNE JOKE 2022 BARREL AGED BUT. 0,75 L	WID_LE_POL_2022_BUT_750	5907710904602	1.10	10.00	1717
FUNKY FLUID VOYAGE, VOYAGE PUSZKA 0,5 L	FF_VOY_PUSZ_500	5903999514204	0.54	10.00	1718
NOOK FIGARBO BUT. 0,33 L	NOOK FIG	5903240848386	0.50	10.00	1719
KEG SVIJANY 30 L	KEG SVI	\N	0.00	10.00	1720
DZIKI WSCHУD WILD WILD EAST - XMAS WILD ALE BUT. 0,375 L	DZ_WIL_WIL_EAS_XMAS_WIL_BUT_375	5906874369913	0.50	10.00	1721
CANTILLON GRAND CRU BRUOCSELLA LAMBIC BIO 2022 BUT. 0,75 L	CANT GRA CRU BRU 2022	\N	1.10	10.00	1722
PINTA Collab PL: Cztery Њciany 15,0° keg 30 l	PI_COLL_CZT_KEG_30	5123456780041	0.00	10.00	1723
PINTA Mini Maxi IPA but. 0,5 l	PI Min IPA	5904730438001	0.00	10.00	1724
PINTA BARREL BREWING DISCLOSED 12,0° BUT. 0,375 L	PBB_DIS_BUT_375	5904335577501	0.50	10.00	1725
MOCZYBRODA PEARFECTLY GREEN PUSZKA 0,5 L	MO_PEA_PUSZ_500	5904673801061	0.54	10.00	1726
BROWARNY BIRIBOMBA PUSZKA 0,5 L	BROW_BIRI_PUSZ_500	5905450141035	0.54	10.00	1727
KAZIMIERZ NEVER ENDING STORY BUT. 0,5 L	KAZ_NEV_BUT_500	5906660570752	0.77	10.00	1728
INNE BECZKI ESTEBAN BUT. 0,5 L	INNE EST	5905669683289	0.77	10.00	1729
JURAJSKIE APA BUT. 0,5 L	JUR APA	5905331025089	0.77	10.00	1730
DE MOLEN VUUR & VLAM BUT. 0,33 L	KAT06267	8717624421037	0.50	10.00	1731
CUVEE DES TROLLS TRIPLE BUT. 0,75 L	CUVE TROL TRIP 750	5411551210513	1.10	10.00	1732
CANTILLON KRIEK-LAMBIC BIO 2022 BUT. 0,75 L	CANT KRI LAM BIO 2022 750	5411024000023	1.10	10.00	1733
TOOL KAFFE OG ROG BUT. 0,33 L	KAT02011	5711474002180	0.50	10.00	1734
LINDEMANS KRIEK MEDALION RYBIE OKO	LIND_KRI_MED	\N	0.00	10.00	1735
CZTERY ЊCIANY BENEFIS PUSZKA 0,5 L	4SC_BEN_PUSZ_500	5905108498832	0.54	10.00	1736
BROKREACJA PARIS SYNDROME 2 BOURBON BARREL AGED BUT. 0,33 L	BRO PAR SYN 2 BA	5907610243757	0.50	10.00	1737
STAROPOLSKIE THE ART OF HOPPING TRISKEL SINGLE HOP IPA BUT. 0,5 L	STAR_TRISK_BUT_500	5903021505132	0.77	10.00	1738
MARYENSZTADT BARREL AGED ICE BRETT PORTER DOUBLE BA - BIAЈA CZEKOLADA I PRAЇONY ORZECH PUSZKA 0,44 L	MAR BA ICE BRE BIA CZE PRA	5903678022075	0.48	10.00	1739
AMAGER / DБDIVA VIEWPOINT COCO BUT. 0,33 L	AMAG VIE COC	5704603303012	0.50	10.00	1740
MONGOZO POKAL 0,25 L	KAT01010	5123456791071	0.00	10.00	1741
TRZECH KUMPLI TASSIE BUT. 0,5 L	TR TAS	5905669479974	0.77	10.00	1742
PETRUS KIELICH 0,33 L	344	5123456791178	0.00	10.00	1743
TRZECH KUMPLI CALIFIA KEG 30 L	TR CAL K	5123456789465	32.00	10.00	1744
ST. BERNARDUS WATAU KIELICH  0,33 L	KAT00215	5123456791174	0.00	10.00	1745
LEFFE TRIPLE BUT. 0,33 L	LEF TRI 330	5410228145912	0.50	10.00	1746
BOON GEUZE SZKLANKA  0,25 L	KAT03829	5123456791050	0.00	10.00	1747
NEPOMUCEN FREE FAM DESIRE PUSZKA 0,5 L	NE_FRE_FAM_PUSZ_500	5905701060160	0.54	10.00	1748
TRZECH KUMPLI WONDER HAZE KEG 30 L	TR WON K	5123456789640	32.00	10.00	1749
90 BPM GRODOUDOUBLE IPA KEG 30 L	90 BPM GRO IPA KEG 30	\N	32.00	10.00	1750
WRКЇEL BUFFALO TRACE BARREL AGED BUT. 0,33 L	WRE BUF BA	5904730465069	0.50	10.00	1751
MOON LARK ARCHES 3.0. WEST COAST DIPA PUSZKA 0,5 L	ML_ARC_3.0_PUSZ_500	5905255346482	0.54	10.00	1752
TRZECH KUMPLI BREW NOTE PUSZKA 0,5 L	TR BRE P	5904252699706	0.54	10.00	1753
STAROPOLSKIE KULTOWE BEZ GLUTENU MIODOWE BUT. 0,5 L	STAR KUL BEZ MIO	5903021500625	0.77	10.00	1754
ALEBROWAR HERR AXOLOTL WITH LOTUS & ENIGMA BUT. 0,5 L	ALE_HER_LOT_BUT_500	5907771343723	0.77	10.00	1755
LINDEMANS PECHERESSE BUT. 0,355 L	LIND PEC 355	5411223101071	0.00	10.00	1756
RODENBACH FRUITAGE BUT. 0,25 L	RODEN FRU 250	54125063	0.35	10.00	1757
LEFFE RUBY KEG 6 L	329	5410228200147	0.00	10.00	1758
SMYKAN CYDR KWAЊNY ZDZICHU BUT. 0,5 L	SMYK KWA	5905669332170	0.77	10.00	1759
FUNKY FLUID THUNDER BOLT PUSZKA 0,5 L	FF_THUND_PUSZ_500	5903999514761	0.54	10.00	1760
UNTITLE ART. ROCKY ROAD STOUT PUSZKA 0,473 L	OMB UA Roc	854141006731	0.53	10.00	1761
BIRBANT GUILTY PLEASURE PUSZKA 0,5 L PROMOCJA (do 07.10.23)	BI GUI_PROM	\N	0.00	10.00	1762
KORMORAN IRISH BEER BUT. 0,5 L	KORM IRI	5902528300004	0.77	10.00	1763
CA' DEL BRADO ANNIVERSARIO 2021 BUT. 0,375 L	CDB ANN 2021	5123456790123	0.50	10.00	1764
STAROPOLSKIE THE ART OF HOPPING AFRICAN SOUL SINGLE HOP IPA BUT. 0,5 L	STAR_AFR_SOU_BUT_500	5903021504913	0.77	10.00	1765
PINTA Barrel Brewing Enology 2023 but. 0,375 l	PBB_ENO_2023_BUT_375	5904335577365	0.00	10.00	1766
ZAKЈADOWY SOKOWIRУWKA ARONIA & PORZECZKA BUT. 0,5 L PROMOCJA (do 28.10.23)	ZA_SOK_AR0-POR_BUT_500_PROM	\N	0.00	10.00	1767
PIWOTEKA GORZKI ЊNIEG BUT. 0,5 L	PIW_GOR_SNI_BUT_500	5905669428170	0.77	10.00	1768
STAROPOLSKIE PRL PIWO PEЈNE 0,5 L	STAR PRL PEЈ	5905669086240	0.00	10.00	1769
PINTA Bluza bordowa M	PINTA Blu bor M	5904165100573	0.00	10.00	1770
FLOREFFE TRIPLE BUT. 0,33 L	FLO TRI 330	5411276200516	0.50	10.00	1771
CYRILOVY BRAMBURKY CZOSNKOWE - CHIPSY 100 G	CYR_BRAM_CZOS_100	8594021041071	0.00	10.00	1772
PINTA Pierwsza Pomoc 10,5° but. 0,5 l	PI Pie	5904730438575	0.00	10.00	1773
BROKREACJA THE FIGHTER BUT. 0,5 L	BRO FIG 0,5	5905669783248	0.77	10.00	1774
TRZECH KUMPLI LAGER WIEDEСSKI KEG 30 L	TR_LAG_WIE_KEG_30	\N	32.00	10.00	1775
NEPOMUCEN WASSILY PUSZKA 0,5 L	NE WAS	5904555992139	0.54	10.00	1776
KORMORAN COPERNIKUS TUBA BUT. 0,5 L	KOR_COP_TUB_BUT_500	5902528208584	0.77	10.00	1777
INNE BECZKI ZERO TO HERO BUT. 0,5 L	INNE ZER	5901122234203	0.77	10.00	1778
MONVIN APERITIVO SPRITZ KEG 20 L	MON_SPRI_KEG_20	8013324024449	21.50	10.00	1779
ROCHEFORT TRAPPISTES 8* BUT. 0,33 L	ROCH 8 330	5412858000081	0.50	10.00	1780
STAROPOLSKIE THE ART OF HOPPING WARRIOR SINGLE HOP WEST COAST IPA BUT. 0,5 L	STAR_WARR_BUT_500	5903021505743	0.77	10.00	1781
FUNKY FLUID STRAWBERRY PUSZKA 0,5 L	FF_STRAW_PUSZ_500	5903999514587	0.54	10.00	1782
LINDEMANS KRIEK BUT. 0,75 L	LIND KRI 750	5411223100920	1.10	10.00	1783
BUTELKA ZWR FORTUNA 0,5 L	BUT FOR	\N	0.00	10.00	1784
SARABANDA SOURVENTURE PUSZKA 0,5 L	SA_SOU_PUSZ_500	5904501978231	0.54	10.00	1785
ZIEMIA OBIECANA BANIALUKI PUSZKA 0,5 L	ZO_BAN_PUSZ_500	5905186484666	0.54	10.00	1786
NEPOMUCEN HOPOLLO PUSZKA 0,5 L	NE HOP	5907709756946	0.54	10.00	1787
WIEZE TRIPEL BUT. 0,33 L	KAT07133	5425036510012	0.50	10.00	1788
MOCZYBRODA BRAIN SMASHER BUT 0,5 L	MOCZY BRA	5903351761741	0.00	10.00	1789
BROKREACJA SAVAGE 004 BUT. 0,5 L	BRO SAV 004	5907610243924	0.77	10.00	1790
MARYENSZTADT SOURTIME PASTRY SOUR GRANAT I POMARAСCZA BUT 0,5 L	MAR_SOU_GRA-POM_BUT_500	5903678022099	0.00	10.00	1791
3 FONTEINEN FRAMBOOS OOGST 2019 BUT. 0,75 L	3 FON FRA OOG 19 750	5425007818116	1.10	10.00	1792
JURAJSKIE VERMONT IPA BUT. 0,5 L	JUR VER	5905331026963	0.77	10.00	1793
STONE ENJOY AFTER 7.4.16 BUT. 0,75 L	KAT01562	636251772108	1.10	10.00	1794
FUNKY FLUID FREE GELATO: MANGO STICKY RICE PUSZKA 0,5 L	FF_FRE_GEL_MAN_STI_PUSZ_500	5903999514884	0.54	10.00	1795
PIRAAT POKAL 0,33 L	KAT00631	5123456791068	0.00	10.00	1796
MOINETTE BONS VOEUX BUT. 0,75 L	MOI BON VOE 750	5410702000010	1.10	10.00	1797
STONE XOCOVEZA EXTRA ANEJO 2015 BUT. 0,5 L	KAT02664	636251740619	0.77	10.00	1798
KORMORAN 6-PAK ЊLIWKA W PIWIE  BUT. 0,375 L PROMOCJA (do 11.10.23)	KOR_6PAK_SLI_BUT_375_PROM	\N	0.00	10.00	1799
3 FONTEINEN HOMMAGE BUT. 0,75 L	3 FON HOM 750	5425007818123	1.10	10.00	1800
TILQUIN OUDE PINOT NOIR A L'ANCIENNE BUT. 0,75 L	TIL NOI 750	5425029530232	1.10	10.00	1801
RADUGA MARTIAN BUT. 0,33 L	RADU MAR	5902176770037	0.50	10.00	1802
MOCZYBRODA NEW WAVE #12 BUT. 0,33 L	MOCZY NEW#12	5903351761727	0.50	10.00	1803
DZIKI WSCHУD WOLNY DUCH BUT. 0,5 L	DZIKI WOL	5906874369340	0.77	10.00	1804
GRYBУW PILSVAR SVEJKOVE BUT. 0,5 L	GR SVE	5902516000831	0.77	10.00	1805
O’SO THE CONTINENTAL BUT. 0,75 L	OSO THE	892370002810	1.10	10.00	1806
PINTA Їytorillo 14,0° but. 0,5 l	PI Їyt	5904165103543	0.00	10.00	1807
MORT SUBITE OUDE KRIEK BUT. 0,375 L	MS OUD KRI 375	5411656052223	0.50	10.00	1808
MARYENSZTADT YES WE CAN VOL. 4 – MICRO HAZY IPA PUSZKA 0,5 L	MAR_YES_WE_VOL4_MIC_PUSZ_500	5903678022679	0.54	10.00	1809
VAL-DIEU GRAND CRU BUT. 0,75 L	VAL GRA CRU 750	5413977000273	1.10	10.00	1810
PINTA Otwieracz magnes Atak Chmielu	PINTA Otw mag Ata	5904165101594	0.00	10.00	1811
BROKREACJA RED SUN PUSZKA 0,5 L	BR_RED_SUN_PUSZ_500	5904422197872	0.54	10.00	1812
PINTA Bawarka 13,0° but. 0,5 l	PI Baw	5908252864003	0.00	10.00	1813
RACIBORSKIE RADLER GREJPFRUT BEZALKOHOLOWE BUT. 0,5 L	RAC RAD GRE BEZ	5907506252528	0.77	10.00	1814
MARYENSZTADT MYSTERIOUS IPA BUT. 0,5 L	MAR MYS	5905669542470	0.77	10.00	1815
NEPOMUCEN APPETIZING PUSZKA 0,5 L	NE_APP_PUSZ_500	5905701060290	0.54	10.00	1816
LOCO BEER NARANJA IPA PUSZKA 0,5 L	BM_LOC_NAR_PUSZ_500	5907694918480	0.54	10.00	1817
ALEBROWAR KING OF HOP BUT. 0,5 L	ALE KIN	5907222039182	0.77	10.00	1818
RECRAFT JUICY SOUR SERIES – GRAVIOLA X LIMONKA PUSZKA 0,5 L	REC_JUI_GRA_PUSZ_500	5900779755932	0.54	10.00	1819
NEPOMUCEN THE HEDGEHOG PUSZKA 0,5 L	NE_THE_HEDG_PUSZ_500	5905701060337	0.54	10.00	1820
KAZIMIERZ ELA UNDER MY UMBRELLA BUT. 0,5 L PROMOCJA	KAZ ELA_PROM	\N	0.00	10.00	1821
CIESZYN NOSZAK BUT. 0,5 L	CIE NOS	5905279156852	0.77	10.00	1822
CANTILLON SANG BLEU KEG 20L	KAT07437	5123456789021	0.00	10.00	1823
MALTGARDEN DREAMS GONE SOUTH BUT. 0,5 L	MALT DRE	5907710943854	0.77	10.00	1824
MONVIN ROSE FRIZZANTE KEG 20 L	MON_ROS_KEG_20	8013651024792	21.50	10.00	1825
DZIKI WSCHУD WILD WILD EAST CRANBERRY WILD ALE BUT. 0,375 L	DZIKI WIL CRA	5906874369623	0.50	10.00	1826
CHYLICZKI CYDR SZARA & ZЈOTA RENETA KEG 30 L	CHYL SZA ZЈO K	5123456789034	32.00	10.00	1827
ARTEZAN INNY TYP CZЈOWIEKA BUT. 0,5 L	ART_INN_BUT_500	5904708750456	0.77	10.00	1828
SCHLENKERLA RAUCHBIER EICHE VINTAGE 2015 19,9° BUT. 0,5 L	SCH EIC VIN 2015	5123456790103	0.77	10.00	1829
MARYENSZTADT HOPPY LEMO - GRANAT & CHMIEL BUT. 0,33 L	MAR_HOP_LEM_GRA_BUT_330	5903678022044	0.50	10.00	1830
TRZECH KUMPLI BLACKCYL PUSZKA 0,5 L	TR BLA P	5904252699423	0.54	10.00	1831
LINDEMANS GOYCK BUT. 0,75 L	LIND GOY 750	5430001057010	1.10	10.00	1832
BROKREACJA WHERE IS LEITMOTIV? KIWI-MATCHA BUT. 0,5 L	BR_WHE_LEI_KIW_MAT_BUT_500	5904422197919	0.77	10.00	1833
PRIMБTOR WEIZEN BUT. 0,5 L	PRI WEI	8594006931663	0.77	10.00	1834
TRZECH KUMPLI OATY PUSZKA 0,5 L	TR OAT P	5904252699188	0.54	10.00	1835
RACIBORSKIE PSZENICZNE BUT. 0,5 L	RAC_PSZ_BUT_500	5907506252450	0.77	10.00	1836
PIWNE PODZIEMIE CHMIELOKRATA HBC 586 PUSZKA 0,5 L	POD_CHM_HBC_586_PUSZ_500	5904305482088	0.54	10.00	1837
DELIRIUM NOCTURNUM BUT. 0,33 L	DEL NOC 330	5412186000715	0.50	10.00	1838
PIWNE PODZIEMIE APRICOT GOSE PUSZKA 0,5 L	POD_APR_PUSZ_500	5904305482804	0.54	10.00	1839
PIWOTEKA DOBRE BO ЈУDZKIE BUT. 0,5 L	PIW_DOB_ЈУD_BUT_500	5905669428224	0.77	10.00	1840
DUGGES COLA PUSZKA 0,33 L	DUGG_COL_PUSZ_330	7350038224774	0.35	10.00	1841
DU BOCQ BLANCHE DE NAMUR BUT. 0,75 L	DU BOC BLA DE NAM  750	5411633750050	1.10	10.00	1842
KAZIMIERZ MUSZKIETEROWIE BUT. 0,5 L	KAZ MUS	5906660570585	0.77	10.00	1843
AMBER BEZALKOHOLOWE IPA BUT. 0,5 L	AMB_BEZ_IPA_BUT_500	5906591002520	0.77	10.00	1844
ZA MIASTEM LENIWE CHWILE BUT. 0,5 L	ZAM LEN	5906874605189	0.77	10.00	1845
PINTA RISFACTOR Cocoa Nibs and Coconut 30,0° keg 10 l	PI RIS Coc Coc keg 10	5123456780052	0.00	10.00	1846
SMYKAN CYDR STARY SAD KEG 30 L	SMYK STA K	5123456791305	32.00	10.00	1847
ALEBROWAR IMPERIAL HERR AXOLOTL CHERRY BUT. 0,5 L PROMOCJA (do 19.10.23)	ALE IMP HER CHE_PROM	\N	0.00	10.00	1848
MAREDSOUS 10% TRIPLE BUT. 0,33 L	MARE TRI 330	5411681038001	0.50	10.00	1849
NEPOMUCEN MICRO LINES PUSZKA 0,5 L	NE_MIC_LIN_PUSZ_500	5905701060009	0.54	10.00	1850
AMBER MARANGO BUT. 0,5 L	AMB_MAR_BUT_500	5906591002995	0.77	10.00	1851
LINDEMANS MAЈA TABLICA	KAT06835	5123456791127	0.00	10.00	1852
PINTA Szklanka Mini Maxi IPA 0,5 l	PINTA Szk Min	5904165102164	0.00	10.00	1853
BIRBANT ACADIA PUSZKA 0,5 L	BI_ACA_PUSZ_500	5904041703850	0.54	10.00	1854
LINDEMANS TAROT D'OR MEDALION RYBIE OKO	LIND_TAR_D'OR_MED	\N	0.00	10.00	1855
FUNKY FLUID CLOUDY PUSZKA 0,5 L	FF CLO P	5907772092316	0.54	10.00	1856
RECRAFT OCEANIA PILS PUSZKA 0,5 L	REC_OCE_PUSZ_500	5900779755895	0.54	10.00	1857
DUGGES MANGO MANGO MANGO PUSZKA 0,33 L	DUGG_MAN_MAN_PUSZ_330	7350038224897	0.35	10.00	1858
CHYLICZKI CYDR LODOWY KEG 15 L	CHYL LOD K 15	5123456789031	0.00	10.00	1859
MIKKELLER SPONTAN APRICOT BUT. 0,375 L	MIK SPON APRI 375	818534015748	0.50	10.00	1860
FUNKY FLUID GELATO: BANANA CREPES SUZETTE PUSZKA 0,5 L	FF_GEL_BAN_CRE_PUSZ_500	5903999514655	0.54	10.00	1861
DEER BEAR LET'S COOK SOUR APA BUT. 0,5 L PROMOCJA (do 05.10.23)	DEER LET SOU_PROM	\N	0.00	10.00	1862
PINTA Barrel Brewing Courage but. 0,33 l	PBB Cou	5904335577464	0.00	10.00	1863
RACIBORSKIE AMERICAN WHEAT LAGER ZW  BUT. 0,5 L	RAC_AMER_WHI_BUT_500	\N	0.77	10.00	1864
KINGPIN ZIPPY PUSZKA 0,5 L	KIN_ZIP_PUSZ_500	5904730290258	0.54	10.00	1865
TRZECH KUMPLI MISTY BUT. 0,5 L	TR MIS	5905669479189	0.77	10.00	1866
LINDEMANS FRAMBOISE MEDALION RYBIE OKO	LIND_FRA_MED	\N	0.00	10.00	1867
CIESZYN BARLEY WINE Z WIЊNIAMI B.A. BUT. 0,33 L	CIE BAR WIЊ	5907612240723	0.50	10.00	1868
RECRAFT WIELKA SZYCHA BUT. 0,5 L	REC WIE	5904730663014	0.77	10.00	1869
ARTEZAN JARDIN DU CHВTEAU PECHE BUT. 0,375 L	ART_JAD_PEC_BUT_375	5904708750616	0.50	10.00	1870
MARYENSZTADT FREEKY HAZY IPA GLUTEN & ALCOHOL FREE BUT. 0,5 L	MAR FRE HAZY IPA	5903424615285	0.77	10.00	1871
ROCKMILL FRIEND OR FOE? RUM BA BUT. 0,33 L	ROCK_FR_OR_FO_RUM_BUT_330	5908291862480	0.50	10.00	1872
3 FONTEINEN HOMMAGE BIO 2018/19 BUT. 0,75 L	3 FON HOM BIO 18/19 750	5425007818154	1.10	10.00	1873
JURAJSKIE SZKLANKA SHAKER 0,5 L	Jur Szk Sha 5	5123456791393	0.00	10.00	1874
SMYKAN CYDR SMYKAN 2021 BUT. 0,75 L	SMYK SMY 2021	5905669332002	1.10	10.00	1875
MAGIC ROAD BORN TO BE JUICY LIMITED EDITION BUT. 0,33 L	MR_BOR_LIM_BUT_330	5905204130445	0.50	10.00	1876
PIWNE PODZIEMIE WELWETOWE PODZIEMIE KEG 30 L	PODZ WEL K 30	5123456789401	32.00	10.00	1877
MOON LARK PRIME. WEST COAST IPA PUSZKA 0,5 L	ML PRI	5905255346000	0.54	10.00	1878
VIGO Kombucha BIO Mango Marakuja but. 0,33 l	VIG_KOM_BIO_MAN_MAR_BUT_330	5902768514186	0.00	10.00	1879
INNE BECZKI TUTTI FRUTTI BUT. 0,5 L	IN_TUT_BUT_500	5905669683296	0.77	10.00	1880
KEG BROWAR ZAMKOWY CIESZYN 30 L	KEG BZC	5123456792016	0.00	10.00	1881
MIЈOSЈAW CHMIELOWY LAGER BZW BUT. 0,5 L	MIЈ_CHM_LAG_BZW_BUT_500	\N	0.77	10.00	1882
MIKKELLER SPONTAN CHERRY W. FREDERIKSDAL BUT. 0,375 L	MIK SPON CHER 375	818534011566	0.50	10.00	1883
MAGIC ROAD FREE PRETTY KIWI, PEAR, PEACH & SWEET ROLL PUSZKA 0,5 L	MR_FRE_PRE-KIW-PEA-PEA_PUSZ_500	5905204130926	0.54	10.00	1884
MARYENSZTADT BARREL AGED RIS HEAVEN HILL BOURBON BROWNIE PUSZKA 0,44 L	MAR BA RIS BRO	5903424615018	0.48	10.00	1885
CZTERY ЊCIANY ILUZJA PUSZKA 0,5 L	4SC_ILU_PUSZ_500	5905108498870	0.54	10.00	1886
NEPOMUCEN FLY ME TO BEMOWO PUSZKA 0,5 L	NE_FLY_BEM_PUSZ_500	5905701060238	0.54	10.00	1887
STU MOSTУW ART+69 MODERN SILLY SOUR MANGO-LIME-ORANGE PUSZKA 0,44 L	STU_ART69_PUSZ_440	5907614683078	0.48	10.00	1888
BOON OUDE GUEUZE VAT 91 BUT. 0,375 L	BOON OUG VAT 91 375	5412783000910	0.50	10.00	1889
P?HJALA BANGER BUT. 0,33 l	POH_BAN_BUT_330	4742976015874	0.00	10.00	1890
MONGOZO KOKOS POKAL	491	5123456791070	0.00	10.00	1891
GRYFUS SZKLANKA 0,5 L	GRY SZKL 5	5123456791395	0.00	10.00	1892
TRZECH KUMPLI WКDZONY PORTER BAЈTYCKI KEG 20 L	TR_WED_POR_KEG_20	5123456789924	21.50	10.00	1893
STU MOSTУW BON VOYAGE PUSZKA 0,44 L	STU_BON_VOY_PUSZ_440	5907614683191	0.48	10.00	1894
BRUNEHAUT TRIPLE BIO GLUTEN FREE BUT. 0,75 L	BRUN TRI GF 750	5411065201311	1.10	10.00	1895
CIESZYN HIGHLANDER BUT. 0,33 L	CIE HIG	5905279156296	0.50	10.00	1896
BROKREACJA COACHMAN'S CALL BUT. 0,5 L	BRO_COA_CAL_BUT_500	5904422197827	0.77	10.00	1897
JAN OLBRACHT LEGENDY POLSKIE: LESZY BUT. 0,33 L	JO LP LES	5902627012211	0.50	10.00	1898
ROCKMILL COFFEECAT PUSZKA 0,5 L	ROCK_COFF_PUSZ_500	5908291862459	0.54	10.00	1899
FORTUNA MIRABELKA BUT. 0,5 L	MIЈ FOR MIR	5901687910291	0.77	10.00	1900
CHYLICZKI CYDR STARY SAD KEG 30 L	CHYL STA SAD K	5123456789033	32.00	10.00	1901
PALETA FORTUNA EPAL 1200X800	Palet Fort	\N	0.00	10.00	1902
LUBROW PRAUSTBANDE'23 PUSZKA 0,33 L	LUB_PRA_PUSZ_330	5903686842504	0.35	10.00	1903
WRКЇEL CELTIC SURPRISE PART TWO BUT. 0,5 L	WRE CEL 2	5904181970341	0.77	10.00	1904
ZAKЈADOWY ALE TO TY DZWONISZ BUT. 0,5 L	ZA_ALE_TO_BUT_500	5907753172280	0.77	10.00	1905
PINTA Koszulka miкtowa M	PINTA Kos mie M	5904165101310	0.00	10.00	1906
MARYENSZTADT SOURTIME PASTRY SOUR RED CURRANT & CHERRY BUT. 0,5 L PROMOCJA (do 05.10.23)	MAR SOU PAS RED CUR_PROM	\N	0.00	10.00	1907
PETRUS AGED PALE TAP HANDLE	PET AGE PAL TAP HAN	5123456791373	0.00	10.00	1908
MARYENSZTADT FREEKY MANGO ALE BUT 0,5 L	MAR FRE MAN ALE	5903424615148	0.00	10.00	1909
JAN OLBRACHT ЊMIETANKA BUT. 0,5 L	JO ЊMI	5904730284035	0.77	10.00	1910
JURAJSKIE POMARAСCZA KEG 30 L	JUR POM K	5123456789259	32.00	10.00	1911
WRКЇEL VIVA ESPANA ONE PUSZKA 0,5 L PROMOCJA (do 20.10.23)	WRE VIV ONE_PROM	\N	0.00	10.00	1912
LA TRAPPE BLONDE BUT. 0,75 L	TRAP BLO 750	8711406121580	1.10	10.00	1913
INNE BECZKI SWEATER WHEATER PUSZKA 0,5 L	IN_SWE_WHE_PUSZ_500	5903661281786	0.54	10.00	1914
P?HJALA MUST KULD PAPER MILL PUSZKA 0,33 L	POH_MUS_KUL_PAP_BUT_330	4742976015621	0.35	10.00	1915
CIESZYN DOUBLE IPA BUT. 0,5 L	CIE DOU IPA	5905279156067	0.77	10.00	1916
STAROPOLSKIE BESTBIR GRUSZKA I MELISA BUT. 0,5 L	STAR BES GRU MEL	5905669086141	0.77	10.00	1917
BACCHUS KRIEK BUT. 0,375 L	BACCH KRI	5411081004309	0.50	10.00	1918
PINTA Koszulka szara XL	PINTA Kos sza XL	5904165101280	0.00	10.00	1919
KEG BELGIA A6	KAT01500ref	5123456792004	0.00	10.00	1920
FUNKY FLUID EVERYDAY BUT. 0,5 L	FF EVE	5906395560240	0.77	10.00	1921
ALEBROWAR HOPPY ELEVEN BUT. 0,5 L	ALE_HOP_ELE_BUT_500	5907771340067	0.77	10.00	1922
TRZECH KUMPLI PIECE OF CAKE BUT. 0,5 L PROMOCJA (do 14.10.23)	TR_PIE_BUT_500_PROM	\N	0.00	10.00	1923
PINTA Bluza czarna XL	PINTA Blu cza XL	5904165100542	0.00	10.00	1924
NEPOMUCEN ODRA PANY PUSZKA 0,5 L	NE ODR	5904555992788	0.54	10.00	1925
NEPOMUCEN LOST BUT FOUND PUSZKA 0,5 L	NE_LOS_BUT_FOU_PUSZ_500	5905701060320	0.54	10.00	1926
BRUSSELS BEER PROJECT PINARD DE BUT. 0,75 L	BRUS PIN 750	5123456788001	1.10	10.00	1927
BIRRA MANIA SEXY ARANCIA APA BUT. 0,33 L	BM SEX	5907694918428	0.50	10.00	1928
PINTA Pils Time 12,0° keg 30 l	PI_PIL_TIM_KEG_30	\N	0.00	10.00	1929
DUVEL OTWIERACZ D	KAT06072	5123456791199	0.00	10.00	1930
ALEBROWAR ICED SORRY GRIGORY BUT. 0,25 L	ALE ICE SOR	5907771341927	0.35	10.00	1931
MARYENSZTADT SOURTIME MIRABELKA I LIMONKA BUT. 0,5 L	MAR_SOU_MIR_LIM_BUT_500	5903424615322	0.77	10.00	1932
PINTA Koszulka HC czarna L	PINTA Kosz HC czar L	5904165102980	0.00	10.00	1933
MOON LARK RAISE. HELLES LAGER PUSZKA 0,5 L	ML_RAI_PUSZ_500	5905255346208	0.54	10.00	1934
CORSENDONK ZESTAW  (2 X BUT. 0,33 L + SZKЈO)	COR ZEST 2X330 SZK	5411491001899	0.00	10.00	1935
BROKREACJA HERMIT PUSZKA 0,5 L	BR_HER_PUSZ_500	5904422197865	0.54	10.00	1936
BOSTEELS TRIPEL KARMELIET POKAL 0,33 L	7D50-1626F	5123456791063	0.00	10.00	1937
BIRBANT HOPSBANT FRESH IPA BUT. 0,5 L	BI HOP	5903240620166	0.77	10.00	1938
DE MOLEN FRUIT & KRUID BUT. 0,33 L	DE_MOLEN_FRU_KRU_BUT_330	8717624420412	0.50	10.00	1939
LUBROW LAGERFEUER PUSZKA 0,33 L	LUB_LAG_PUSZ_330	5903686842757	0.35	10.00	1940
FUNKY FLUID LAGER BUT. 0,5 L	FF_LAG_BUT_500	5903999514426	0.77	10.00	1941
DU BOCQ BLANCHE DE NAMUR ROSEE KEG 20 L	DU_BOC _BLA_DE _NAM _ROS_K_20	\N	21.50	10.00	1942
VITAMINE SEA CURRENCY CHECK PUSZKA 0,473 L	OMB Vit Cur	5123456790113	0.53	10.00	1943
ED RED KONSERWA CHILI CON CARNE	ED CHI	5904083584035	0.00	10.00	1944
3 FONTEINEN INTENSE ROOD A83 2018/19 BUT. 0,375 L	3 FON INT ROO 18/19 375	5425007810943	0.50	10.00	1945
ICE BREAKER BOOMBOX KEG 30 L	ICE BRE BOOM KEG 30	\N	32.00	10.00	1946
RECRAFT JUICY SOUR SERIES – MANGO LASSI PUSZKA 0,5 L	REC_JUI_MAN_PUSZ_500	5900779755901	0.54	10.00	1947
MALTGARDEN SLEEPING IN ORCHARD BUT. 0,5 L	MALT SLE	5907710943878	0.77	10.00	1948
FUNKY FLUID TRIPLE GELATO: BIANCO PUSZKA 0,5 L	FF_TRI_GEL_BIA_PUSZ_500	5903999513832	0.54	10.00	1949
STAROPOLSKIE PORTER CHERRY BUT. 0,5 L	STAR POR CHE	5903021503275	0.77	10.00	1950
DZIKI WSCHУD TJMMNW BUT. 0,5 L PROMOCJA (do 01.10.23)	DZIKI TJM_PROM	\N	0.00	10.00	1951
SMYKAN CYDR GROCHУWKA KEG 30 L	SMYK GRO K	5123456791299	32.00	10.00	1952
NEPOMUCEN NEPO FINEST – GOLDEN HIND BUT. 0,375 L	NE_NEPO_FIN_GOL_BUT_375	5905191386610	0.50	10.00	1953
LA TRAPPE QUADRUPEL BUT. 0,75 L	TRAP QUA 750	8711406135723	1.10	10.00	1954
PODGУRZ 652 M N.P.M. BOURBON B.A. BUT. 0,5 L	PODG 652 BBA	5906874055007	0.77	10.00	1955
PINTA Koszulka biaіa XXL	PINTA Kos bia XXL	5904165100450	0.00	10.00	1956
DEER BEAR DEER BEARD BUT. 0,5 L	DEER DEE	5906395303335	0.77	10.00	1957
KAZIMIERZ MUSTAFA BUT. 0,5 L	KAZ_MUS_BUT_500	5906660570493	0.77	10.00	1958
SCHNEEEULE AUTOBAHN COLLABO BRUSSELS BEER PROJECT BUT. 0,75 L	SCHN AUT	\N	1.10	10.00	1959
RODENBACH SZKLANKA 0,33 L	310	5123456791032	0.00	10.00	1960
MAREDSOUS 6% BLONDE BUT 0,33 L	MARE BLO 330	5411681035000	0.00	10.00	1961
MALTGARDEN GATE NO 1/2022 BUT. 0,5 L	MALT GAT 1_2022	5904050721609	0.77	10.00	1962
RACIBORSKIE BEZALKOHOLOWE ZW BUT. 0,5 L	RAC_BEZ_ZW_BUT_500	5907506252504	0.77	10.00	1963
TARNOBRZEG WHEATART BUT. 0,5 L	TAR_WHE_BUT_500	5904533544046	0.77	10.00	1964
RADUGA GAME#2 BUT. 0,5 L	RADU GAM#2	5902176770075	0.77	10.00	1965
BROKREACJA SNOW GUENON BUT. 0,5 L	BR_SNO_GUE_BUT_500	5904422197773	0.77	10.00	1966
WIDAWA 10TH ANNIVERSARY IMPERIAL BALTIC PORTER BA BUT. 0,33 L	WID 10TH	5907710904541	0.50	10.00	1967
SCHLENKERLA RAUCHBIER MДRZEN 13,5° BUT. 0,5 L	SCH MAR	4037458000012	0.77	10.00	1968
NEPOMUCEN TROPICAL FEET PUSZKA 0,5 L	NE_TRO_FEE_PUSZ_500	5905701060085	0.54	10.00	1969
MAGIC ROAD SAWA SAWA PUSZKA 0,5 L	MR_SAW_PUSZ_500	5905204131107	0.54	10.00	1970
TRZECH KUMPLI HAZY RYE MICRO IPA - OUR NEW IPA PUSZKA 0,5 L	TR_HAZ_RYE_OUR_NEW_PUSZ_500	5904252699836	0.54	10.00	1971
BROKREACJA THE LUMBERJACK BUT. 0,5 L	BRO LUM	5905669783026	0.77	10.00	1972
TRZECH KUMPLI AMERICAN BEAUTY BUT. 0,5 L	TR AME	5905669479349	0.77	10.00	1973
ST. BERNARDUS ZESTAW (4X 0,33 L + SZKЈO)	STB ZES 4X330 + SZKЈ	5411911003540	0.00	10.00	1974
DUVEL BRELOK DO KLUCZY D (CZERWONY)	KAT06154	5123456791203	0.00	10.00	1975
CORSENDONK AGNUS BUT. 0,75 L	COR AGN 750	5411491011164	1.10	10.00	1976
NIECZAJNA RUSSIAN IMPERIAL STOUT BUT. 0,5 L	NIE_RUS_BUT_500	5903796782233	0.77	10.00	1977
LUBROW CHMIELEWSKI PUSZKA 0,33 L	LUB_CHM_PUSZ_330	5903686842696	0.35	10.00	1978
PINTA Bluza czarna XXL	PINTA Blu cza XXL	5904165100559	0.00	10.00	1979
PIWNE PODZIEMIE EXOTICA PUSZKA  0,5 L	PODZ EXO	5904305482095	0.00	10.00	1980
GRODZISKIE PIWO Z GRODZISKA BUT. 0,5 L	MIЈ GRO PIW GRO	5905279533264	0.77	10.00	1981
TRZECH KUMPLI LAGER WIEDEСSKI BUT. 0,5 L	TR_LAG_WIE_BUT_500	5904252699683	0.77	10.00	1982
BROKREACJA THE NURSE BUT. 0,5 L	BRO NUR	5905669783095	0.77	10.00	1983
SZRENIAWA LETNIE PSZENICZNE BUT. 0,5 L	SZR_LET_PSZ_BUT_500	5903857178340	0.77	10.00	1984
LIMBURGSE WITTE LEMON KEG 20 L	LIMB WIT LEM K 20	\N	21.50	10.00	1985
LEFFE BLONDE KEG 20 L	LEF BLO K 20	5123456789017	21.50	10.00	1986
MARYENSZTADT KLASYCZNIE IPA BUT. 0,5 L	MAR KLA IPA	5903678022891	0.77	10.00	1987
PINTA Atak Chmielu 15,0° keg 30 l	PI Ata keg 30	5123456789662	0.00	10.00	1988
SPECIATION SANGRIA INCIPIENT PUSZKA 0,473 L	OMB Spe San	5123456790110	0.53	10.00	1989
ST. BERNARDUS EXTRA 4 BUT. 0,33 L	STB EXT 330	5411911001782	0.50	10.00	1990
TRZECH KUMPLI PAN IPANI KEG 30 L	TR PAN K	5123456789495	32.00	10.00	1991
JURAJSKIE PORTER BAЈTYCKI BUT. 0,33 L	JUR POR	5905331025416	0.50	10.00	1992
FUNKY FLUID FUSION: PRZETWУRNIA CHMIELU PUSZKA 0,5 L	FF_FUS_PRZ_PUSZ_500	5903999514860	0.54	10.00	1993
WESTVLETEREN 12 XII BUT. 0,33 L	WESTVLET 12	5123456790130	0.50	10.00	1994
LUBROW POLSKA GUROM 2.0 PUSZKA 0,33 L	LUB_POL_GUR_2.0_PUSZ_330	5903686842825	0.35	10.00	1995
STU MOSTУW WILD #18 MIXED FERMENTATION PIQUETTE SAISON BUT. 0,375 L	STU_WIL_#18_BUT_375	5907614682842	0.50	10.00	1996
ZA MIASTEM PIҐTEK WIECZУR BUT. 0,5 L	ZAM_PIҐ_WIE_BUT_500	5904905630100	0.77	10.00	1997
FLYING DOG SZKLANKA 1/2 PINT	Fly Dog Szkl	5123456791390	0.00	10.00	1998
ROCKMILL GALACTIC BROTHERHOOD: Z INNEJ BECZKI BUT. 0,5 L	ROCK_GAL_BRO_Z_IN_BECZ_BUT_500	5908291862060	0.77	10.00	1999
LINDEMANS TUMBLER 0,25 L	770	5123456791131	0.00	10.00	2000
BOON KIELISZEK TULP 0,25 L	KAT06097	5123456791166	0.00	10.00	2001
LINDEMANS APPLE BUT. 0,25 L	LIND APP 250	5411223100579	0.35	10.00	2002
MARYENSZTADT YES WE CAN VOL. 5 PUSZKA 0,5 L	MAR_YES_WE_VOL5_PUSZ_500	5903424615919	0.54	10.00	2003
TRZECH KUMPLI MVPILS BUT. 0,5 L	TR MVP	5905669479448	0.77	10.00	2004
PINTA Party Starter NZ Pale Ale 12,0° keg 30 l	PI_PAR_STA_NZ_PAL_KEG_30	\N	0.00	10.00	2005
PIWOTEKA POMALUTKU I DO SKUTKU BUT. 0,5 L	PIW_POM_SKU_BUT_500	5905669428125	0.77	10.00	2006
LA CHOUFFE BLANCHE BUT. 0,33 L	LA CHO BLA 330	5410769800820	0.50	10.00	2007
MIЈOSЈAW BEZALKOHOLOWE IPA BUT. 0,5 L	MIЈ BEZ IPA	5902838990469	0.77	10.00	2008
KOMES WYMRAЇANY PORTER BAЈTYCKI JACK DANIEL'S BA BUT. 0,33 L	KOM_WYM_POR_BA_BUT_330	5902838991428	0.50	10.00	2009
CHIMAY 150 / SPЙCIALE CENT CINQUANTE BUT. 0,33 L	CHIM 150 CINQ 330	5410908100118	0.50	10.00	2010
BROKREACJA FOWL QUEEN PUSZKA 0,5 L	BR_FOW_BUT_500	5904422197797	0.54	10.00	2011
PRAIRIE BOMB! DECONSTRUCTED: CACAO NIBS BUT. 0,355 L	PREI DEC CAC	680132989055	0.00	10.00	2012
WRКЇEL BOWMORE BARREL AGED BUT. 0,33 L	WRE BOW BA	5904730465038	0.50	10.00	2013
KOMES WYMRAЇANY BARLEY WINE OLD FORESTER BA BUT. 0,33 L	KOM WYM OLD BA	5902838991411	0.50	10.00	2014
ED RED KONSERWA SZAKSZUKA Z TOFU	ED SZA	5904083584042	0.00	10.00	2015
DEER BEAR SZKLANKA SHAKER 0,5 L	DEE_BEA_SZKL_SHA	5123456791452	0.00	10.00	2016
ALEBROWAR SINGLE HOP STYRIAN CARDINAL HAZY APA BUT. 0,5 L	ALE_SH_STY_CAR_BUT_500	5907771343402	0.77	10.00	2017
3 FONTEINEN OUDE KRIEK VAT BUT. 0,375 L	3 FON OUD KRI VAT 375	5425007810813	0.50	10.00	2018
STONE SZKLANKA 0,33 L	KAT01827	5123456791025	0.00	10.00	2019
MAGIC ROAD CHOCOLATE BAR VOL. 2 HEAVEN HILL & WILD TURKEY DBA PUSZKA 0,33 L	MR_CHO_BAR_2_HEA_DBA_PUSZ_330	5905204130339	0.35	10.00	2020
GRYBУW PILSVAR EXCLUSIVE BUT. 0,5 L	GR EXC	5902516000329	0.77	10.00	2021
TRZECH KUMPLI RUSTY KEG 30 L	TR RUS K	5123456789506	32.00	10.00	2022
HOFSTETTNER GRANITBOCK WILDBRETT BUT. 0,75 L	HOFS GRA WIL	5123456790128	1.10	10.00	2023
KING MULE TAP HANDLE	KING MUL TAP HAN	5123456791351	0.00	10.00	2024
CHYLICZKI GRAFF NO. 2 BUT. 0,5 L	CHYL GRA 2	5905279058255	0.77	10.00	2025
PINTA Psst... It's Your Weekend IPA - Cold IPA 15,0° but. 0,5 l	PI_PSST_YOU_COLD_BUT_500	5904165104687	0.00	10.00	2026
BIRBANT KOLO% PUSZKA 0,5 L	BI_KOL_PUSZ_500	5904041703713	0.54	10.00	2027
GRIMBERGEN FENIKS POKAL 0,25 L	GRI POK FEN 250	5123456791091	0.00	10.00	2028
BROWAR JANA BEZALKOHOLOWE BUT. 0,5 L	BRO_JA_BEZ_ALCO_BUT_500	5902429980930	0.77	10.00	2029
PINTA Beskidy Pszeniczne 13,0° but. 0,5 l	PI Bes Psz	5904730438933	0.00	10.00	2030
MAGIC ROAD FREE PRETTY MANGO, PASSIONFRUIT & WHITE CHOCOLATE PUSZKA 0,5 L	MR_FRE_PRE-MAN-PAS_PUSZ_500	5905204130933	0.54	10.00	2031
LINDEMANS KUBEK 0,33 L	KAT06780	5123456791151	0.00	10.00	2032
MOCZYBRODA FRANKIE SAY RELAX PUSZKA 0,5 L	MO_FRA_PUSZ_500	5904673800798	0.54	10.00	2033
SVIJANY SZKLANKA 0,5 L	SVI_SZKL_500	\N	0.00	10.00	2034
TRZECH KUMPLI GOSE MANGO MARAKUJA KEG 30 L	TR GOS MAN K	5123456789477	32.00	10.00	2035
PODGУRZ IMPERIALNY 652 M N.P.M. BOURBON BA BUT. 0,5 L	PODG IMP 652 BBA	5906874055373	0.77	10.00	2036
PINTA Oto mata IPA 14,0° keg 30 l	PI Oto keg 30	5123456789755	0.00	10.00	2037
ZA MIASTEM DZIEС DOBRY BUT. 0,5 L	ZAM DZI DOB	5906874605288	0.77	10.00	2038
PIWNE PODZIEMIE WELWETOWE PODZIEMIE PUSZKA 0,5 L	PODZ WEL	5904305482798	0.54	10.00	2039
MIKKELLER OREGON FRUIT SERIES: SPONTANBLUEBERRY BUT. 0,75 L	MIK OR BLUE 750	5704255115551	1.10	10.00	2040
KEG CZECHY (D) 30 L	KEG CZ DAR	\N	0.00	10.00	2041
DE CAM TROSBESSEN BUT. 0,75 L	DE CAM TRO	5425021680133	1.10	10.00	2042
ZA MIASTEM 5TH ELEMENT AMERICAN PALE ALE BUT. 0,5 L	ZAM_5TH_APA_BUT_500	5904905630186	0.77	10.00	2043
MOCZYBRODA POPART #12 DOPPEL RAUCHBOCK BUT. 0,5 L	MO_POP_#12_500	5901087374594	0.77	10.00	2044
DUGGES ASTEROID PUSZKA 0,5 L	DUGG_ASTE_PUSZ_500	7350038227355	0.54	10.00	2045
ROCHEFORT TRAPPISTES 6* BUT. 0,33 L	ROCH 6 330	5412858000067	0.50	10.00	2046
LUPULUS BLONDE TRIPLE BUT. 0,33 L	LUP BLO TRI 330	5425025122035	0.50	10.00	2047
MARYENSZTADT HEY OH BUT. 0,5 L	MAR HEY	5905669542340	0.77	10.00	2048
GRYBУW PILSVAR PORTER BUT. 0,5 L	GR_PORT_BUT_500	5902516000435	0.77	10.00	2049
SCHLENKERLA SZKLANKA 0,25 L	SCH SZK 0,25	5123456791247	0.00	10.00	2050
KASTEEL BRIGAND KIELICH 0,33 L	KAST BRI KIEL 330	5123456791344	0.00	10.00	2051
WRКЇEL MANGOVE BUT. 0,5 L	WRE MAN	5904730465304	0.77	10.00	2052
RADUGA GAME#3 BUT. 0,5 L	RADU GAM#3	5902176770860	0.77	10.00	2053
CHYLICZKI CYDR ROSE 2021 BUT. 0,75 L	CHYL ROS 750	5905279058187	1.10	10.00	2054
RADUGA CITRUS CITRUS BUTELKA 0,5 L	RADU CIT CIT	5902176771706	0.00	10.00	2055
ZIEMIA OBIECANA AYE! PUSZKA 0,5 L	ZO_AYE_PUSZ_500	5905186484642	0.54	10.00	2056
AUGUSTIJN BRUNE BUT. 0,33 L	AUG BRU 330	5411663007001	0.50	10.00	2057
LINDEMANS CASSIS BUT. 0,25 L	LIND CAS 250	5411223100555	0.35	10.00	2058
NEPOMUCEN MORE HOPS & MORE FOREST PUSZKA 0,5 L	NE_MOR_HOP_MOR_FOR_PUSZ_500	5905191386498	0.54	10.00	2059
STAROPOLSKIE NIEMDЈE KLASYCZNE BUT. 0,5 L	STAR NIE KLA	5903021503336	0.77	10.00	2060
RODENBACH KEG 20 L PROMOCJA (do 17.09.23)	ROD K 20_PROM	\N	0.00	10.00	2061
NEPOMUCEN AROUND BUT. 0,5 L	NE ARO	5904555992610	0.77	10.00	2062
MALTGARDEN TRUNK FULL OF FRUITS BUT. 0,5 L	MALT TRU	5904050721838	0.77	10.00	2063
PINTA T-shirt biaіy duїe logo S	PINTA Kos DL bia S	5904165102447	0.00	10.00	2064
P?HJALA PIME ЦЦ BUT. 0,33 L	POH PIM OO	4742976010183	0.50	10.00	2065
MARYENSZTADT RIGHT NOW BUT. 0,5 L	MAR_RIG_NOW_BUT_500	5905669542173	0.77	10.00	2066
PINTA Koszulka HC czarna 3XL	PINTA Kosz HC czar 3XL	5904165102973	0.00	10.00	2067
P?HJALA CHERRY GARDEN PUSZKA 0,33 L	POH CHG	4742976015447	0.35	10.00	2068
MORT SUBITE GUEUZE BUT. 0,375 L	MS GUE	5411656052001	0.50	10.00	2069
AUGUSTIJN GRAND CRU BUT. 0,33 L	AUG GRA CRU 330	5411663002204	0.50	10.00	2070
PINTA Szklanka Pinta Party 2022	PINTA Szk PP 2022	5123456791324	0.00	10.00	2071
PINTA Szklanka Omer 2021 0,3 l	PINTA Szk Ome	5904165100689	0.00	10.00	2072
FUNKY FLUID GELATO: ARANCIA PUSZKA 0,5 L	FF_GEL_ARA_PUSZ_500	5903999514402	0.54	10.00	2073
PRZETWУRNIA CHMIELU PRECEL PUSZKA 0,5 L	PCH_PRE_PUSZ_500	5905476980526	0.54	10.00	2074
STAROPOLSKIE THE ART OF HOPPING EL DORADO SIGLE HOP HAZY IPA BUT. 0,5 L	STAR_EL_DOR_BUT_500	5903021505491	0.77	10.00	2075
RADUGA GOOD MATERIAL BUT. 0,5 L	RAD_GOO_MAT_BUT_500	5902176771485	0.77	10.00	2076
KAZIMIERZ MR. SHERMAN BUT. 0,5 L	KAZ MR SHE	5906660570349	0.77	10.00	2077
TANKBUSTERS ATTACK OF FRUITINESS PUSZKA 0,5 L	TB_ATT_PUSZ_500	5905316580114	0.54	10.00	2078
HARPAGAN AMRITA PUSZKA 0,5 L	HAR_AMR_PUSZ_500	5905450141059	0.54	10.00	2079
DUVEL POKAL 666 0,33 L	KAT06150	5123456791094	0.00	10.00	2080
GOЊCISZEWO LETNIK BUT. 0,5 L	GO_LET_BUT_500	5903364108977	0.77	10.00	2081
WRКЇEL MIЊ WOJTEK BRAGGOT BUT. 0,5 L	WRE MIS BRA	5904181970419	0.77	10.00	2082
FUNKY FLUID FIVE FINGER DISCOUNT PUSZKA 0,5 L	FF_FIV_FIN_DIS_PUSZ_500	5903999512934	0.54	10.00	2083
TRZECH KUMPLI PILS PUSZKA 0,5 L	TR PIL P	5904252699072	0.54	10.00	2084
ALEBROWAR HERR AXOLOTL WITH SABRO & HBC472 HOPS BUT. 0,5 L	ALE_HER_SAB_HBC_HOP_BUT_500	5907771343464	0.77	10.00	2085
TRZECH KUMPLI BLACKCYL KEG 30 L	TR BLA K	5123456789460	32.00	10.00	2086
MOON LARK TUNE UP. KELLERBIER PUSZKA 0,5 L	ML_TUN_PUSZ_500	5905255346444	0.54	10.00	2087
STAROPOLSKIE COFFEE FRIENDS  BUT. 0,5 L	STAR_COFF_FRI_BUT_500	5903021506085	0.77	10.00	2088
RACIBORSKIE SZKLANKA 0,5 L	RAC_SZKL_500	\N	0.00	10.00	2089
PINTA Double Delivery 18,0° can 0,5 l	PI_DOU_DEL_CAN_500	5904165104977	0.00	10.00	2090
LINDEMANS CASSIS BUT. 0,355 L	LIND CAS 355	5411223101088	0.00	10.00	2091
CA`DEL BRADO CUVEE DE ZRISA - CHERRY SOUR ALE BUT. 0,375 L	CDB_CUV_ZRI_BUT_375	5123456790123	0.50	10.00	2092
THE BRUERY 11 PIPERS PIPING BUT. 0,75 L	BRU 11 PIP	718122104338	1.10	10.00	2093
STU MOSTУW TROPICAL GOSE BUT. 0,5 L	STU TRO GOS	5907614681982	0.77	10.00	2094
WIDAWA LATO CZEKA BUT. 0,5 L	WID LAT 500	5907710904053	0.77	10.00	2095
DUGGES BIG BLACK APPLE PUSZKA 0,5 L	DUGG_BIG_BLA_APP_PUSZ_500	7350038226372	0.54	10.00	2096
BIRBANT HERO% PUSZKA 0,5 L	BI HER	5903240620944	0.54	10.00	2097
GRIMBERGEN DOUBLE BUT. 0,33 L	GRI DOU 330	5410263010664	0.50	10.00	2098
OUD BEERSEL GEUZE VANDERVELDEN 137 BUT. 0,375 L	OUD GUE VAN 137 375	5425018070640	0.50	10.00	2099
PASSENDALE POKAL 0,25 L	357	5123456791069	0.00	10.00	2100
FUNKY FLUID GELATO: PASSION FRUIT MANGO PEACH PUSZKA 0,5 L	FF GEL MAN PEA	5907772092552	0.54	10.00	2101
STAROPOLSKIE KULTOWE BEZ GLUTENU PROZDROWOTNE 0,0 % BUT. 0,5 L	STAR_KUL_PRO_BEZ_BUT_500	5903021505521	0.77	10.00	2102
KORMORAN KRZEPKIE BUT. 0,5 L PROMOCJA (do 10.19.23)	KORM KRZ_PROM	\N	0.00	10.00	2103
GRYFUS GRYFITA BUT. 0,5 L	GRY GRY	5907222685167	0.77	10.00	2104
LA CHOUFFE BLONDE BUT. 0,75 L	LA CHO BLO 750	5410769100098	1.10	10.00	2105
PETRUS MATA BAROWA	PET MAT BAR	5123456791375	0.00	10.00	2106
GEKKO BEERS INTO THE THICK OF IT PUSZ. 0,44 L	GEK BEE INT THE THI OF IT	3770011188178	0.00	10.00	2107
VITAMINE SEA BABY WAVES PUSZKA 0,473 L	OMB Vit Bab	5123456790115	0.53	10.00	2108
LA TRAPPE ZESTAW (2X BUT. 0,75 L BLOND/QUADRUPEL)	TRAP_ZEST_BLO_QUA_2X750	8711406567685	0.00	10.00	2109
TRZECH KUMPLI BLACKCYL BUT. 0,5 L	TR BLA	5905669479240	0.77	10.00	2110
SCHLENKERLA KUFEL SZKLANY 0,4 L	SCHLEN KUF SZK 0,4	5123456791244	0.00	10.00	2111
OMNIPOLLO SZKLANKA 0,3 L	KAT03322	5123456791109	0.00	10.00	2112
STU MOSTУW WILD #12 BIERE DE SOIF PEACHES AND CHERRIES BUT. 0,375 L	STU WILD#12	5907614680350	0.50	10.00	2113
SOFIA ELECTRIC CATCH SOME RAYS K-KEG 20 L PROMOCJA (do 22.09.23)	Sof Ele Cat k-keg 20_PROM	\N	0.00	10.00	2114
DZIKI WSCHУD NUNPA PUSZKA 0,5 L	DZIKI NUN	5906874369395	0.54	10.00	2115
ED RED KONSERWA KACZKA KONFITOWANA Z JABЈKIEM	ED KAC KON	5903940086521	0.00	10.00	2116
CHYLICZKI CYDR ANTONУWKA KEG 30 L	CHYL ANT K	5123456789026	32.00	10.00	2117
SCHNEEEULE BESTE FREUNDE BUT. 0,75 L	SCHN BES FRE	\N	1.10	10.00	2118
FUNKY FLUID THOMAS - GELATO: SCHWARZWДLDER KIRSCHTORTE PUSZKA 0,5 L	FF THO	5903999513610	0.54	10.00	2119
DUGGES ELECTRO PUSZKA 0,33 L	DUGG_ELEC_PUSZ_330	7350038226297	0.35	10.00	2120
FILOMELOS CYDR RУЇANIECKI BUT. 0,33 L	FIL_CYD_RУЇ_BUT_330	5900168509030	0.50	10.00	2121
NEPOMUCEN KIND OF MAGIC PUSZKA 0,5 L	NE_KIN_OF_MAG_PUSZ_500	5905191386573	0.54	10.00	2122
RADUGA GOOD DAY! PUSZKA 0,5 L	RAD_GOO_PUSZ_500	5902176772031	0.54	10.00	2123
STU MOSTУW RODZINA - VILD BUT. 0,375 L	STU ROD VIL	7390305201299	0.50	10.00	2124
SCHNEIDER BAYRISCH HELL BLACHA REKLAMOWA	SCHN BLA REK	5123456791333	0.00	10.00	2125
DZIKI WSCHУD SAA PUSZKA 0,5 L	DZ_SAA_PUSZ_500	5906874369586	0.54	10.00	2126
BALADIN XYAUYU KENTUCKY 2017 BUT. 0,5 L	BAL XYA KEN	8032942290609	0.77	10.00	2127
MOERSLEUTEL 6Y SJAAK PUSZKA 0,44 L	OMB Moe Sja	8720615260539	0.48	10.00	2128
BIRBANT IMPERIAL CITRA IPA BUT. 0,5 L	BI IMP CIT	5903240620142	0.77	10.00	2129
STAROPOLSKIE PORTER IRISH COFFEE BUT. 0,5 L	STAR POR IRI COF	5903021503299	0.77	10.00	2130
ЈAСCUT PSZEPAN BUT. 0,5 L	LAN PSZ	5906395997220	0.77	10.00	2131
STONE TAP HANDLE	STN TAP HAN	5123456791011	0.00	10.00	2132
TRZECH KUMPLI UNPLUGGED CITRUS APA 0,0% PUSZKA 0,5 L	TR_UNP_CIT_APA_PUSZ_500	5904252699805	0.54	10.00	2133
LINDEMANS FRAMBOISE BUT. 0,355 L	LIND FRA 355	5411223101064	0.00	10.00	2134
MAGIC ROAD KIWI? KIWI! PUSZKA 0,5 L	MR_KIW_PUSZ_500	5905204130940	0.54	10.00	2135
RACIBORSKIE MIODOWE ZW BUT. 0,5 L	RAC MIO BUT ZW	5907506252085	0.77	10.00	2136
LUBROW LIGHTHOUSE IPA PUSZKA 0,33 L	LUB_LIG_PUSZ_330	5903686842900	0.35	10.00	2137
PRAIRIE FUNKY GOLD MOSAIC BUT. 0,5 L	PRAI MOS	894776000995	0.77	10.00	2138
VAL-DIEU CUVEE 800 BUT. 0,33 L	VAL CUV 330	5413977000945	0.50	10.00	2139
THE BRUERY 10 LORDS-A-LEAPING BUT. 0,75 L	BRU 10L	718122104338	1.10	10.00	2140
BROWARNY UNHOLY PUSZKA 0,5 L	BROWA_UNH_PUSZ_500	5905450141080	0.54	10.00	2141
SCHNEIDER TAP07 ORIGINAL 12,8° BUT. 0,5 L	Schn TAP7	4003669016203	0.77	10.00	2142
NEPOMUCEN THE SPIRAL PUSZKA 0,5 L	NE_THE_SPI_PUSZ_500	5905701060276	0.54	10.00	2143
NEPOMUCEN OLE BUT. 0,5 L	NE OLE	5905279959910	0.77	10.00	2144
HOLBA PREMIUM 12° KEG 30 L	HOL PRE K	\N	32.00	10.00	2145
ARTEZAN IT'S A FEATURE 2 BUT. 0,33 L	ARTEZ ITS 2	5904708750388	0.50	10.00	2146
TRZECH KUMPLI RAUCHDOPPELBOCK KEG 20 L	TR RAU K	5123456789504	21.50	10.00	2147
LINDEMANS PECHERESSE MEDALION RYBIE OKO	LIND_PEC_MED	\N	0.00	10.00	2148
ALEBROWAR HERR AXOLOTL WITH GOLDENBERRY BUT. 0,5 L	ALE_HER_GOL_BUT_500	5907771343716	0.77	10.00	2149
LINDEMANS TAROT NOIR KEG 20 L	LIND_TAR_NOIR_KEG_20	\N	21.50	10.00	2150
DZIKI WSCHУD ORЈA CIEС BUT. 0,5 L	DZIKI ORЈ	5906874369418	0.77	10.00	2151
STRUISE / HOPY PEOPLE CLASH OF THE TITANS RESERVA BUT. 0,33 L	STRU CLA TIT RES 330	5425017181330	0.50	10.00	2152
O'HARA'S WHITE HAZE BUT. 0,5 L	Oha Whi Haz	5391500601954	0.77	10.00	2153
TRZECH KUMPLI AMERICAN BEAUTY PUSZKA 0,5 L	TR AME P	5904252699478	0.54	10.00	2154
PINTA Hazy Delivery 15,0° keg 20 l	PI_HAZ_DEL_KEG_20	5123456780022	0.00	10.00	2155
MARYENSZTADT SOURTIME MANGO IIPA BUT. 0,5 L	MAR SOU MAN	5905669542722	0.77	10.00	2156
KASTEEL ROUGE KEG 20 L	KAST ROU K 20 L	\N	21.50	10.00	2157
NEPOMUCEN TAKE IT! PUSZKA 0,5 L	NE_TAK_PUSZ_500	5905701060115	0.54	10.00	2158
DZIKI WSCHУD TYTANOWE JAJO BUT. 0,5 L	DZIKI TYT	5906874369302	0.77	10.00	2159
KINGPIN PLUSH PUSZKA 0,5 L	KIN_PLU_PUSZ_500	5904730290418	0.54	10.00	2160
ZA MIASTEM DOBRA NOC BUT. 0,5 L	ZAM DOB	5906874605059	0.77	10.00	2161
PINTA IIPPAA 18,0° keg 20 l	PI IIP keg 20	5123456789722	0.00	10.00	2162
INNE BECZKI FREE IPA BUT. 0,5 L	INNE FRE IPA	5901122234432	0.77	10.00	2163
BROKREACJA TUK TUK BUT. 0,5 L	BR_TUK_BUT_500	5904422197834	0.77	10.00	2164
PIWNE PODZIEMIE CHMIELOKRATA CASHMERE KEG 30 L	POD_CHM_CAS_KEG_30	\N	32.00	10.00	2165
THE BREWING PROJEKT THINGS OF THAT PUSZKA 0, 473 L	KAT06241	810059390799	0.00	10.00	2166
KAZIMIERZ ALDONA BUT. 0,5 L	KAZ ALD	5906660570042	0.77	10.00	2167
CIESZYN PSZENICZNE BUT. 0,5 L	CIE PSZ	5905279156043	0.77	10.00	2168
CHYLICZKI CYDR ALWA KEG 30 L	CH_CYD_ALW_KEG_30	\N	32.00	10.00	2169
90 BPM MINITEL ROSE KEG 30 L	90 BPM MIN ROS KEG 30	\N	32.00	10.00	2170
KAZIMIERZ DOBRE TO TO WYSZЈO #1 BUT. 0,5 L	KAZ DOB #1	5906660570363	0.77	10.00	2171
GULDEN DRAAK QUADRUPLE BUT. 0,75 L	GUL DRA QUA 750 ml	5411663002853	1.10	10.00	2172
ZA MIASTEM RZEЊKI PORANEK BUT. 0,5 L	ZAM RZE	5904905630025	0.77	10.00	2173
CROOKED STAVE ORIGINS BUT. 0,75 L	CROO ORI	854512003185	1.10	10.00	2174
SKRZYNKA SVIJANY A-20	SKRZ_SVIJANY	\N	0.00	10.00	2175
P?HJALA ЦЦ XO KEG 20 L	KAT02040	5123456789008	21.50	10.00	2176
OMNIPOLLO PLUCKIN’ FEATHERS  BUT. 0,33 L	KAT06413	7350064995075	0.50	10.00	2177
TOOL POLYRADIANT BUT. 0,75 L	KAT06748	5711474008915	1.10	10.00	2178
NEPOMUCEN ENDLESS LINES PUSZKA 0,5 L	NE_END_PUSZ_500	5905191386948	0.54	10.00	2179
MOCZYBRODA FLAN PARISIEN PUSZKA 0,5 L	MO_FLA_PUSZ_500	5904673801078	0.54	10.00	2180
MIO MIO COLA BUT. 0,5 L	MIO_MIO_COLA_BUT_500	4002846034368	0.77	10.00	2181
KRAJAN IRLANDZKIE CIEMNE BUT. 0,5 L	KRA IRL CIE	5907582579410	0.77	10.00	2182
TANKBUSTERS ALONE IN SPACE PUSZKA 0,5 L	TB ALO	5904365781053	0.54	10.00	2183
WRКЇEL MEXICO TRIP: PART TWO BUT. 0,5 L	WRE_MEX_TWO_BUT_500	5904181970471	0.77	10.00	2184
MOCZYBRODA POPART #05 CHOCOLATE PASTRY IMPERIAL STOUT BUT. 0,5 L	MOCZY POP#5	5904673800415	0.77	10.00	2185
GRODZISKIE WHITE IPA BUT. 0,5 L	MIЈ GRO WHI IPA	5905279533240	0.77	10.00	2186
PINTA Szklanka Apfelwein 0,5 l	PINTA Szk Apf	5904165100665	0.00	10.00	2187
BACCHUS THUR POKAL 0,5 L	BACCH THU POK 500	5123456791336	0.00	10.00	2188
LINDEMANS FARO KEG 20 L	LIND FAR K 20	5123456789030	21.50	10.00	2189
BROKREACJA SAVAGE 001 BUT. 0,5 L	BRO SAV 001	5907610243528	0.77	10.00	2190
PINTA Pils Time 12,0° can 0,5 l	PI_PIL_TIM_CAN_500	5904165104281	0.00	10.00	2191
FUNKY FLUID GELATO: POMEGRANATE & PLUM MOCHA PUSZKA 0,5 L	FF_GEL_POM-PLU-MOC_PUSZ_500	5903999514082	0.54	10.00	2192
DELIRIUM ARGENTUM BUT. 0,75 L	DEL ARG 750	5412186003600	1.10	10.00	2193
LITOVEL MORAVAN 11° KEG 30 L	LIT MOR K	\N	32.00	10.00	2194
MALTGARDEN GATE NO 2_2022 PUSZKA 0,33 L	MALT GAT 2_2022	5904050721616	0.35	10.00	2195
LINDEMANS SUMMERBERRY TAP HANDLE	LIND SUM TAP HAN	5123456791012	0.00	10.00	2196
ЈAСCUT MOPS 'N' HOPS BUT. 0,5 L	LAN_MOP_BUT_500	5906395997992	0.77	10.00	2197
WRКЇEL CHERRY NO.1 BUT. 0,5 L	WRE CHE 1	5904730465977	0.77	10.00	2198
PETRUS BORDEAUX TAP HANDLE	PET BOR TAP HAN	5123456791374	0.00	10.00	2199
MARYENSZTADT IMPERIAL BALTIC PORTER HEAVEN HILL KENTUCKY STRAIGHT BURBON WHISKEY B.A. BUT. 0,33 L	MAR IMP BAL HEA	5903424615742	0.50	10.00	2200
GWAREK OWSIANE WZGУRZA PUSZKA 0,5 L	GWAR OWS P	5903938751127	0.54	10.00	2201
FUNKY FLUID USUAL PUSZKA 0,5 L	FF USU P	5907772092798	0.54	10.00	2202
PINTA Czarna Dziura 13,0° but. 0,5 l PROMOCJA (do 05.11.23)	PI Cza_PROM	\N	0.00	10.00	2203
CHIMAY TRIPLE KEG 20 L	CHIM TRI KEG 20	5123456789004	21.50	10.00	2204
DEER BEAR COLD CAT PUSZKA 0,5 L	DE_COL_CAT_PUSZ_500	5905204172186	0.54	10.00	2205
TARNOBRZEG JASNE PEЈNE BUT. 0,5 L	TAR_JS_PE_BUT_500	5903661867713	0.77	10.00	2206
SCHLENKERLA SZKLANKA 0,5 L	Sch szk 0,5	5123456791248	0.00	10.00	2207
PINTA Koszulka їуіta S	PINTA Kos їуі S	5904165100467	0.00	10.00	2208
MIKKELLER SPONTAN PEACH BUT. 0,375 L	MIK SPON PEAC 375	5704255117982	0.50	10.00	2209
PINTA Otwieracz magnes Pierwsza Pomoc	PINTA Otw mag Pie	5904165101617	0.00	10.00	2210
PINTA IIPPAA 18,0° keg 30 l	PI IIP keg 30	5123456789723	0.00	10.00	2211
ZAKЈADOWY WUJEK ZE SЈOWENII BUT. 0,5 L	ZA_WUJ_SЈO_BUT_500	5907753172013	0.77	10.00	2212
REVOLTA ORANGE & YERBA MATE AIPA  BUT. 0,5 L	REV_ORA_YER_BUT_500	5900470071003	0.77	10.00	2213
MAGIC ROAD PERFECT BREAKFAST JACK DANIELS BA PUSZKA 0,33 L	MR_PER_BRE_JAC_BA_PUSZ_330	5905204130308	0.35	10.00	2214
MIЈOSЈAW PERRY MIЈOSЈAWSKI BUT. 0,5 L	MIЈ PER	5901687910512	0.77	10.00	2215
KORMORAN BARLOW SORBUS  BUT. 0,375 L	KORM BARL	5902528000409	0.50	10.00	2216
HOEGAARDEN SZKLANKA 0,33 L	KAT01831	5123456791045	0.00	10.00	2217
3 FONTEINEN INTENSE RED OUDE KRIEK BUT. 0,75 L	3 FON INT RED 750	5425007810981	1.10	10.00	2218
ZULI MELARYA CHMIEL BUT. 0,33 L	ZU_MELA_CHM_BUT_330	5904933314218	0.50	10.00	2219
KORMORAN COPERNIKUS BUT. 0,5 L	KOR_COP_BUT_500	5902528000157	0.77	10.00	2220
PINTA I'm so Horny! 18,0° keg 30 l	PI_HOR_KEG_30	5123456780034	0.00	10.00	2221
ARTEZAN TEN COLLAB BUT. 0,5 L	ART_TEN_COL_BUT_500	5904708750739	0.77	10.00	2222
LINDEMANS SZKLANKA SPONTANBASIL 0,25 L	LIND SZKL SPON 250	5123456791038	0.00	10.00	2223
ARTEZAN JARDIN DU CHВTEAU CASSIS BUT. 0,375 L	ART_JAR_CAS_BUT_375	5904708750630	0.50	10.00	2224
MARYENSZTADT CHOCOLATE RYE RIS JACK DANIELS B.A. BUT. 0,33 L	MAR CHO RIS JAC	5905669542944	0.50	10.00	2225
KAZIMIERZ KWASIMIERZ BUT. 0,5 L	KAZ KWA	5906660570141	0.77	10.00	2226
LINDEMANS BEARDY HIPSTER T-SHIRT (L)	KAT06614	5123456791148	0.00	10.00	2227
BROKREACJA MEET THE BARREL #5 – RYE GIN BUT. 0,33 L	BRO MEE #5	5904422197407	0.50	10.00	2228
SCHLENKERLA TABLICA REKLAMOWA	SCH TAB REK	5123456791340	0.00	10.00	2229
STAROPOLSKIE BESTBIR KOKOS BUT. 0,5 L	STAR BES KOK	5905669086073	0.77	10.00	2230
SMYKAN CYDR CHMIELONY SAD BUT. 0,75 L	SMYK CHM	5905669332156	1.10	10.00	2231
BIRBANT SAGA BUT. 0,5 L	BI_SAG_BUT_500	5904041703669	0.77	10.00	2232
MC CHOUFFE BUT. 0,33 L	MC CHOUF 330	5410769200088	0.50	10.00	2233
VEDETT KIELISZEK  0,33 L	352	5123456791161	0.00	10.00	2234
P?HJALA ЦЦ BUT. 0,33 L PROMOCJA (do 28.10.23)	POH OO_PROM	\N	0.00	10.00	2235
DUGGES RAINBOW PUSZKA 0,33 L	DUGG_RAINB_PUSZ_330	7350038226778	0.35	10.00	2236
MARYENSZTADT BARREL AGED ICE RYE RIS TIRAMISU RIOJA BA PUSZKA 0,44 L	MAR BA ICE RIS TIR	5905669542531	0.48	10.00	2237
PINTA Bluza bordowa XL	PINTA Blu bor XL	5904165100597	0.00	10.00	2238
KAZIMIERZ LATAJҐCY JELEС BUT. 0,5 L	KAZ LAT	5906660570240	0.77	10.00	2239
HOPPIN' FROG LIQUOR BARREL AGED TURBO SHANDY – BOURBON BUT. 0,65 L	HOPP TUR SHA BOU	804551312052	0.00	10.00	2240
BOON OUDE KRIEK BUT. 0,375 L	BOON OUK 375	5412783053862	0.50	10.00	2241
INNE BECZKI MANGO JERRY BUT. 0,5 L	INNE MAN	5903661280987	0.77	10.00	2242
TRZECH KUMPLI PAN IPANI DOUBLE KEG 20 L	TR_PAN_DOU_KEG_20	\N	21.50	10.00	2243
NEPOMUCEN LOVELAS TRIPLE FOREST IPA PUSZKA 0,5 L	NE LOV P	5907709756700	0.54	10.00	2244
HOEGAARDEN ROSEE 0% BUT. 0,25 L	HOEG ROS 0% 250	5410228205876	0.35	10.00	2245
INNE BECZKI HOLY MONUNTAIN PUSZKA 0,5 L	INNE HOL	5903661281410	0.54	10.00	2246
ARTEZAN KOSZYK NA 8 LITER BUT. 0,5 L	ART_KOS_BUT_500	5904708750685	0.77	10.00	2247
TRZECH KUMPLI IMPERIAL BERLINER WEISSE  BUT. 0,5 L	TR IMP BER	5905669479769	0.77	10.00	2248
DZIK CYDR JABЈKO KEG 30 L	DZIK CYD JAB KEG	5906395413065	32.00	10.00	2249
OUD BEERSEL OUDE GUEUZE BARREL SELECTION OUDE PIJPEN BUT. 0,375 L	OUD GUE BAR PIJ 375	5425018070459	0.50	10.00	2250
KOMES PORTER BOURBON OAK BUT. 0,5 L	MIЈ KOM POR BOU 500	5902838991244	0.77	10.00	2251
MOERSLEUTEL 6Y TOM PUSZKA 0,44 L	OMB Moe Tom	8720615260508	0.48	10.00	2252
DZIKI WSCHУD AYANI PUSZKA 0,5 L	DZ_AYA_PUSZ_500	5906874369944	0.54	10.00	2253
RACIBORSKIE PYRSK JABЈKO-GRANAT BUT. 0,33 L	RAC_PY_JAB_GRA_BUT_330	5905249834100	0.50	10.00	2254
PINTA T-shirt zielony duїe logo S	PINTA Kos DL zie S	5904165102546	0.00	10.00	2255
MOON LARK CASUAL. WEST COAST PALE ALE PUSZKA 0,5 L	ML_CAS_PUSZ_500	5905255346468	0.54	10.00	2256
KORMORAN RADLER GORZKA POMARAСCZA BUT. 0,5 L	KORM RAD GOR POM	5902528119828	0.77	10.00	2257
GRYBУW PILSVAR KONOPNIAK BUT. 0,5 L	GR_KONOP_BUT_500	5902516011400	0.77	10.00	2258
CHIMAY RED BUT. 0,33 L	CHIM RED 330	5410908000012	0.50	10.00	2259
SOWIE INDUKTOR BUT. 0,5 L	SOW_IND_BUT_500	5907222560846	0.77	10.00	2260
BROKREACJA PARIS SYNDROME 1 BOURBON BARREL AGED BUT. 0,33 L	BRO PAR SYN 1 BA	5907610243740	0.50	10.00	2261
KORMORAN ZЈOTY EXPORT LAGER BUT. 0,5 L	KORM ZЈO	5902528000065	0.77	10.00	2262
STU MOSTУW ART+65 SOUR IPA PUSZKA 0,44 L	STU_ART65_PUSZ_440	5907614682965	0.48	10.00	2263
BROWAR JANA RZEЊKIE BUT. 0,5 L	BRO_JA_RZEЊ_BUT_500	5902429980947	0.77	10.00	2264
PIWOTEKA CYTRYNOWYM SKRYTOPIJCOM BUT. 0,5 L	PIW_CYT_SKR_BUT_500	5905669428132	0.77	10.00	2265
TRZECH KUMPLI PILS KEG 30 L	TR PIL K	5123456789499	32.00	10.00	2266
BUTELKA ZWR CZECHY ( B) 0,5 L	BUT_CZ_BOZ	\N	0.00	10.00	2267
BROKREACJA SAVAGE 005 BUT. 0,5 L	BRO SAV 005	5904422197537	0.77	10.00	2268
HOPPIN' FROG / SIREN 5-ALARM CHILI BEER: AMERICAN STYLE BUT. 0,65 L	HOPP 5-AL	665760945901	0.00	10.00	2269
GRYBУW PILSVAR PSZENICZNE BUT. 0,5 L	GR PSZ	5902516000589	0.77	10.00	2270
GRYFUS BASZTA BUT. 0,5 L	GRY BAS	5907222685204	0.77	10.00	2271
CHIMAY TRIPLE BUT. 0,33 L	CHIM TRI 330	5410908000029	0.50	10.00	2272
NEPOMUCEN FRUTTATO PUSZKA 0,5 L PROMOCJA (do 06.10.23)	NE FRUTT_PROM	\N	0.00	10.00	2273
MALTGARDEN WE GOT THE FIRE BUT. 0,5 L	MALT WE GOT	5904050721623	0.77	10.00	2274
PETRUS RED TAP HANDLE	PET RED TAP HAN	5123456791377	0.00	10.00	2275
MARYENSZTADT NEW WAVE PILS BUT. 0,5 L	NEW_WEV_PIL_BUT_500	5905669542968	0.77	10.00	2276
BOON KRIEK KEG 20 L	BOON_KRI_KEG_20	\N	21.50	10.00	2277
DZIKI WSCHУD SЈOСCE PRERII BUT. 0,5 L	DZIKI SЈO	5906874369258	0.77	10.00	2278
LINDEMANS FRAMBOISE BUT. 0,75 L	LIND FRA 750	5411223005249	1.10	10.00	2279
MARYENSZTADT SOURTIME STRAWBERRY & RHUBARB GOSE BUT. 0,5 L	MAR SOU STR RHU	5903424615193	0.77	10.00	2280
PINTA MASTERBAR Vanilla & Coconut 30,0° keg 20 l	PI_MAS_VAN_COC_KEG_20	\N	0.00	10.00	2281
MALTGARDEN HELLO LAGER PUSZKA 0,5 L	MA_HEL_PUSZ_500	5907710943007	0.54	10.00	2282
MOON LARK CHEERFUL. ESTRA SPECIAL BITTER PUSZKA 0,5 L	ML_CHER_PUSZ_500	5905255346505	0.54	10.00	2283
ED RED KONSERWA RAGU ALLA BOLOGNESE	ED RAG	5903940086590	0.00	10.00	2284
STARA SZKOЈA WERBENA BUT. 0,5 L	STA WER	5906874548219	0.77	10.00	2285
KASTEEL CUVEE DE CHATEAU KEG 20 L	KAST CUV K 20 L	5123456789883	21.50	10.00	2286
DUCHESSE DE BOURGOGNE BUT. 0,75 L	DUCH BOURG 750	5411364151300	1.10	10.00	2287
ST. BERNARDUS PODKЈADKI	STB PODKЈ	\N	0.00	10.00	2288
MAGIC ROAD SUMMER BANGER PUSZKA 0,5 L	MR_SUM_BAN_PUSZ_500	5905204131053	0.54	10.00	2289
MOINETTE BLONDE BUT. 0,33 L	MOI BLO 330	5410702000133	0.50	10.00	2290
AUGUSTIJN BLOND BUT. 0,33 L	AUG BLO 330	5411663002181	0.50	10.00	2291
LINDEMANS TAROT NOIR BUT. 0,25 L	LIND_TAR_NOIR_BUT_250	5411223005300	0.35	10.00	2292
BRUSSELS BEER PROJECT TEKU 0,33 L	KAT06967	5123456791009	0.00	10.00	2293
SATAN BLACK BUT. 0,33 L	SAT BLA 330	5412107000794	0.50	10.00	2294
ST. BERNARDUS TRIPEL BUT. 0,75 L	STB TRI 750	5411911001492	1.10	10.00	2295
PINTA Modern Drinking 15,0° keg 20 l	PI Mod keg 20	5123456789741	0.00	10.00	2296
LINDEMANS TAROT POKAL 0,33 L	LIND_TAR_POK_330	\N	0.00	10.00	2297
PINTA Pierwsza Pomoc 10,5° keg 20 l	PI Pie keg 20	5123456789764	0.00	10.00	2298
STRUISE BLACK DAMNATION IX - BEGGARS' ART BUT. 0,33 L	STRU BD IX BEG	5425017666097	0.50	10.00	2299
SOWIE AMPER BUT. 0,5 L	SOW_AMP_BUT_500	5907222560136	0.77	10.00	2300
FUNKY FLUID BEEP PUSZKA 0,5 L	FF_BEE_PUSZ_500	5903999514167	0.54	10.00	2301
LIMBURGSE WITTE FLAGA	LIMB WIT FLA	5123456791358	0.00	10.00	2302
ST. LOUIS PREMIUM KRIEK BUT. 0,25 L	ST LOU PRE KRI	5411081002220	0.35	10.00	2303
BROKREACJA ALMOST GRIZZLY BUT. 0,5 L	BR_ALM_GRI_BUT_500	5904422197841	0.77	10.00	2304
TRZECH KUMPLI CALIFIA BUT. 0,5 L	TR CAL	5905669479264	0.77	10.00	2305
ST. LOUIS PREMIUM FRAMBOISE BUT. 0,25 L	ST LOU PRE FRAM	5411081000264	0.35	10.00	2306
CIESZYN RYE WINE BUT. 0,33 L	CIE RYE	5907612240235	0.50	10.00	2307
RODENBACH GRAND CRU EVOLVED BUT. 0,75 L	RODEN_GRA_EVO_BUT_750	5410583804103	1.10	10.00	2308
MARYENSZTADT SOURTIME MANGO-POMARAСCZA-MARAKUJA BUT. 0,5 L	MAR_SOU_MAN_POM_MAR_BUT_500	5905669542005	0.77	10.00	2309
LITOVEL ИERNY CITRON NON-ALCO BUT. 0,5 L	LIT_CER_CIT_NALC_BUT_500	8593875518210	0.77	10.00	2310
BRUGSE ZOT BLONDE BUT. 0,75 L	BRUG ZOT BLO 750	5425017240044	1.10	10.00	2311
TARNOBRZEG URODZINOWE FEAT POPARZENI KAWҐ TRZY BUT. 0,5 L	TAR_URO_POPARZ_BUT_500	5904533544077	0.77	10.00	2312
RODENBACH VINTAGE 2019 BUT. 0,75 L	RODEN VIN 2019 750	5410583803090	1.10	10.00	2313
DZIKI WSCHУD WILD WILD EAST - BLACK WILD ALE BUT. 0,375 L	DZ_WIL_WIL_EAS_BLA_WIL_BUT_375	5906874369890	0.50	10.00	2314
STU MOSTУW WILD #17 MIXED FERMENTATION SAISON WITH ZAPIAIN BUT. 0,375 L	STU_WIL_#17_BUT_375	5907614682835	0.50	10.00	2315
JACKIE O'S / CASITA CERVECERНA CARROTS & STICKS BUT. 0,375 L	JAC CAR	855647004917	0.50	10.00	2316
BIRBANT TIAMAT PUSZKA 0,33 L	BI TIA	5904041703270	0.35	10.00	2317
WRКЇEL MALTIC STORM ISLAY SA BUT. 0,5 L	WR_MAL_ISL_BA_BUT_500	5904181970273	0.77	10.00	2318
HARDYWOOD CUVEE GOLD BUT. 0,75 L	HARD CUV	856718003068	1.10	10.00	2319
DUGGES HYBRID 02 BUT. 0,33 L	DUGG_HYB_02_BUT_330	7350038223722	0.50	10.00	2320
MALTGARDEN SUMMER MOVIE PUSZKA 0,5 L	MA_SUM_PUSZ_500	5907710943267	0.54	10.00	2321
LA TRAPPE QUADRUPEL BUT. 0,33 L	TRAP QUA 330	8711406022207	0.50	10.00	2322
SCHNEEEULE YASMIN KEG 20 L	SCHN YAS KEG 20	\N	21.50	10.00	2323
DUGGES MANGO MANGO MINI PUSZKA 0,33 L	DUGG_MAN_MIN_PUSZ_330	7350038226525	0.35	10.00	2324
SATAN RED BUT. 0,33 L	SAT RED 330	5412107000398	0.50	10.00	2325
LINDEMANS DZBANEK (PIASKOWY) 1 L	KAT06809	5123456791140	0.00	10.00	2326
STU MOSTУW NON ALCOHOLIC BERLINER WEISSE PECH & APRICOT BUT. 0,5 L	STU_NON_BER_BUT_500	5907614682798	0.77	10.00	2327
BOON OUDE GUEUZE VAT 109 BUT. 0,375 L	BOON OUG VAT 109 375	5412783052933	0.50	10.00	2328
KASTEEL ROUGE PODKЈADKI	KAST ROU PODKЈ	5123456791338	0.00	10.00	2329
STONE T-SHIRT CZARNY (XXL)	KAT05459	5123456791054	0.00	10.00	2330
KORMORAN REWOLUCJE WARMIСSKIE BUT. 0,5 L	KORM REW	5902528999994	0.77	10.00	2331
DEER BEAR KAME HAME KEG 30 L	DEER KAM K 30	5123456789116	32.00	10.00	2332
FUNKY FLUID FREE TROPIC PUSZKA 0,33 L	FF_FREE_TRO_PUSZ_330	5903999514754	0.35	10.00	2333
L'INSTANT MOONSPELL KEG 20 L	LIN MOON KEG 20	\N	21.50	10.00	2334
DZIKI WSCHУD WILD WILD EAST CHERRY WILD ALE BUT. 0,375 L	DZIKI WIL CHE	5906874369609	0.50	10.00	2335
MALTGARDEN WHERE ARE MY GOGGLES? PUSZKA 0,5 L	MALT WHE	5907710943304	0.54	10.00	2336
ALEBROWAR PAPA TWINS BUT. 0,5 L	ALE_PAP_TWI_BUT_500	5907771343426	0.77	10.00	2337
LERVIG RACKHOUSE OFF THE RACK PARAGON 2020 BUT. 0,75 L	Ler Rac Off	7072712008639	1.10	10.00	2338
JURAJSKIE ЊWIҐTECZNE BUT. 0,5 L	JUR ЊWI	5095331025247	0.77	10.00	2339
LINDEMANS POTYKACZ	KAT05479	5123456791133	0.00	10.00	2340
STU MOSTУW KILWATER IMPERIAL BALTIC PORTER BBA (PLUMS, FIGS & DATES) BUT. 0,33 L	STU_KIL_BUT_330	5907614682729	0.50	10.00	2341
MAGIC ROAD EVERGLOW PUSZKA 0,5 L	MR_EVE_PUSZ_500	5905204130834	0.54	10.00	2342
PIWNE PODZIEMIE JUICILICIOUS KEG 30 L	PODZ JUI K	5123456789399	32.00	10.00	2343
DZIK CYDR MARAKUJA 0% BUT. 0,5 L	DZIK_CYD_MAR_BUT_500	5906395413515	0.77	10.00	2344
TRZECH KUMPLI W STYLU GRODZISKIE BUT. 0,5 L	TR GRO	5905669479400	0.77	10.00	2345
SATAN GOLD BUT. 0,33 L	SAT GOL 330	5412107000466	0.50	10.00	2346
GRIMBERGEN DESKA DEGUSTACYJNA	GRI DES DEG	5123456791350	0.00	10.00	2347
PINTA Selection: IPA 3-pak + szkіo + podkіadki	PI_SEL_IPA	5904165104076	0.00	10.00	2348
MINISTER PARADAJZ BUT. 0,5 L	MIN_PARA_BUT_500	5903351660006	0.77	10.00	2349
MALTGARDEN GATE NO 5/2021 BUT. 0,5 L	MALT GAT 5	5904050721562	0.77	10.00	2350
PIWNE PODZIEMIE KRAKEN OF DOOM BUT. 0,33 L	POD_KRA_DOO_BUT_330	5904305482583	0.50	10.00	2351
TOOL UTOPIAN TONES BUT. 0,75 L	KAT06752	5711474009349	1.10	10.00	2352
SMYKAN CYDR LODOWY GROCHУWKA BUT. 0,375 L	SMYK LOD GRO	5905669332163	0.50	10.00	2353
PRZETWУRNIA CHMIELU TWIST #4 MARAKUJA PUSZKA 0,5 L	PCH_TWI#4_PUSZ_500	5905476980649	0.54	10.00	2354
GWAREK ONYX PUSZKA 0,5 L	GWAR ONY	5903938751523	0.54	10.00	2355
LINDEMANS BLACHA OUD GUEUZE	KAT06124	5123456791141	0.00	10.00	2356
INNE BECZKI HAZY HAKA BUT. 0,5 L	INNE HAZ	5903661281106	0.77	10.00	2357
MORT SUBITE OUDE GUEUZE BUT. 0,375 L	MS OUD GUE 375	5411656052193	0.50	10.00	2358
JURAJSKIE Z OSTROPESTEM BUT. 0,5 L	JUR OST	5905331025294	0.77	10.00	2359
STU MOSTУW WRCLW SCHOPS BUT. 0,5 L	STU WRC SCH	5907614680480	0.77	10.00	2360
TRZECH KUMPLI UNPLUGGED IPA BUT. 0,5 L	TR UNP IPA	5905669479806	0.77	10.00	2361
LINDEMANS KRIEK TAP HANDLE	LIND KRI TAP HAN	5123456791014	0.00	10.00	2362
FLORIS FRAMBOISE BUT. 0,33 L	FLO FRA 330	5412186001217	0.50	10.00	2363
MARYENSZTADT ICE IMPERIAL BALTIC PORTER BURBON BARREL AGED PUSZKA 0,44 L	MAR ICE IMP	5905669542883	0.48	10.00	2364
CORSENDONK PATER DOUBLE BUT. 0,33 L	COR PAT DOU 330	54069015	0.50	10.00	2365
AMAGER COBRAS FUMANTES BUT. 0,33 L	AMAG COB FUMENTES	5704603303043	0.50	10.00	2366
JACKIE O'S POCKETS OF SUNLIGHT BUT. 0,5 L	JAC POC	855647004832	0.77	10.00	2367
TRZECH KUMPLI CITRUS SESSION JUICY IPA - OUR NEW IPA PUSZKA 0,5 L	TR_CIT_SES_OUR_NEW_PUSZ_500	5904252699782	0.54	10.00	2368
ENAME TRIPLE BUT. 0,33 L	ENA TRI 330	5412583240363	0.50	10.00	2369
CA' DEL BRADO CUVЙE DE KIWI - KIWI SOUR ALE BUT. 0,375 L	CDB_CUV_KIW_BUT_375	\N	0.50	10.00	2370
MIKKELLER T-SHIRT S	MIK TSH S	5123456791372	0.00	10.00	2371
SMYKAN CYDR WYSPOWA ANTONУWKA BUT. 0,75 L	SMY_WYS_ANT_BUT_750	5905669332248	1.10	10.00	2372
TOOL OMNIPRESENT BUT. 0,375 L	KAT06746	5711474009363	0.50	10.00	2373
PIWNE PODZIEMIE JASNE! CHEЈMLOVE! BUT. 0,5 L	POD_JAS_CHE_BUT_500	5904305482743	0.77	10.00	2374
KARL STRAUSS WRECK ALLEY IMPERIAL STOUT BUT. 0,65 L	KARL WRE	796535001161	0.00	10.00	2375
NEPOMUCEN NEPO FINEST – ROYAL FORTUNE BUT. 0,375 L	NE_NEPO_FIN_ROY_BUT_375	5905191386603	0.50	10.00	2376
NEPOMUCEN MICHAEL PUSZKA 0,5 L PROMOCJA (do 11.10.23)	NE MIC_PROM	\N	0.00	10.00	2377
FUNKY FLUID GELATO: YELLOW FLUFF PUSZKA 0,5 L	FF_GEL_YEL_PUSZ_500	5903999514389	0.54	10.00	2378
TRZECH KUMPLI IMPERIAL BERLINER WEISSE 30 L	TR IMP BER K	5123456789481	0.00	10.00	2379
LA TRAPPE ISID`OR BUT. 0,75 L	TRAP IS 750	8711406136775	1.10	10.00	2380
SCHLENKERLA RAUCHBIER FASTENBIER VINTAGE 2019 BUT. 0,5 L	SCH_FAS_VIN_2019_BUT_500	4037458000166	0.77	10.00	2381
MALTGARDEN CUSTOM SNEAKERS PUSZKA 0,5 L	MA_CUS_SNE_PUSZ_500	5907710943014	0.54	10.00	2382
GRYBУW PILSVAR ZERO BUT. 0,5 L	GR ZER	5902516001074	0.77	10.00	2383
CYRILOVY BRAMBURKY SOLONE - CHIPSY 100 G	CYR_BRAM_SOL_100	8594021041064	0.00	10.00	2384
BIRBANT THE LAST DROP PUSZKA 0,5 L	BI_THE_LAS_PUSZ_500	5904041703805	0.54	10.00	2385
STAROPOLSKIE BESTBIR PIECZONE JABЈKO BUT. 0,5 L	STAR BES PIE JAB	5905669086127	0.77	10.00	2386
LA TRAPPE ZESTAW (3x BUT. 0,33L BLOND/DUBBEL/TRIPLE + SZKЈO)	TRAP_ZEST_3X330	8711406566718	0.00	10.00	2387
BROKREACJA POTION #22 BUT. 0,33 L	BRO POT#22	5904422197582	0.50	10.00	2388
STAROPOLSKIE BESTBIR CZEKOLADA Z POMARAСCZҐ BUT. 0,5 L	STAR_BES_CZEK_POM_BUT_500	5903021500236	0.77	10.00	2389
ST. BERNARDUS TABLICA REKLAMOWA	STB TAB REK	5123456791382	0.00	10.00	2390
TRZECH KUMPLI FULL MOSAIC KEG 30 L	TR_FUL_MOS_KEG_30	\N	32.00	10.00	2391
PETRUS BORDEAUX KEG 30 L	PET BOR KEG 30	\N	32.00	10.00	2392
TRZECH KUMPLI WEIZEN KEG 30 L	TR WEI K	5123456789520	32.00	10.00	2393
CZTERY ЊCIANY REWIR BUT. 0,5 L	4SC_REW_BUT_500	5905108498856	0.77	10.00	2394
DZIKI WSCHУD TAСCZҐCY Z CHMIELAMI BUT. 0,5 L	DZIKI TAС	5906874369135	0.77	10.00	2395
PINTA RISFACTOR Cocoa Nibs and Roasted Peanuts 30,0° keg 10 l	PI_RIS_COC_ROA_KEG_10	5123456780017	0.00	10.00	2396
PINTA T-shirt szary duїe logo XL	PINTA Kos DL sza XL	5904165102522	0.00	10.00	2397
PINTA Koszulka czarna M	PINTA Kos cza M	5904165100375	0.00	10.00	2398
MAGIC ROAD CITRUS GIVEAWAY PUSZKA 0,5 L	MR_CIT_GIV_PUSZ_500	5905204130698	0.54	10.00	2399
KEG PERFECTDRAFT 6L	KAT01516ref	5123456792000	0.00	10.00	2400
NEPOMUCEN BIRDLAND PUSZKA 0,5 L	NE_BIR_PUSZ_500	5905701060047	0.54	10.00	2401
PINTA Koszulka їуіta M	PINTA Kos їуі M	5904165100474	0.00	10.00	2402
MOCZYBRODA WIT ME BABY BUT. 0,5 L	MOCZY WIT	5903351761369	0.77	10.00	2403
CHYLICZKI GRAFF NO. 2 KEG 30 L	CHY_GRA_NO2_KEG_30	\N	32.00	10.00	2404
ARTEZAN CZARNA WOЈGA BUT. 0,5 L	ARTEZ CZA	5904730574020	0.77	10.00	2405
PINTA Psst... It's Your Weekend IPA - Hazy IPA 15,0° keg 30 l	PI_PSST_YOU_HAZ_KEG_30	5123456780047	0.00	10.00	2406
TRZECH KUMPLI PAN IPANI BUT. 0,33 L	TR_PAN_BUT_330	5904252699737	0.50	10.00	2407
PINTA Jak w dym 18,0° keg 20 l PROMOCJA	PI Jak keg 20_PROM	5123456780027	0.00	10.00	2408
RADUGA METROPOLIS BUT. 0,5 L	RADU MET	5907431705083	0.77	10.00	2409
VITAMINE SEA GREETINGS FROM WEYMOUTH PUSZKA 0,473 L	OMB Vit Gre	5123456790116	0.53	10.00	2410
CANTILLON NATH BUT. 0,75 L	CAN NAT	\N	1.10	10.00	2411
FUNKY FLUID SPLASH: PINK PUSZKA 0,5 L PROMOCJA (do 27.09.23)	FF SPL PIN_PROM	\N	0.00	10.00	2412
SCHLENKERLA SZKLANKA NOSTALGY 0,5 L	Sch szk Nos 0,5	5123456791328	0.00	10.00	2413
90 BPM BIERE NOIRE PIVO PUSZ. 0,33 L	90 BPM BIE NOI PIV	683489591551	0.00	10.00	2414
PINTA Koszulka HC czarna M	PINTA Kosz HC czar M	5904165102997	0.00	10.00	2415
PIWNE PODRУЇE PORTERRA NOVA BUT. 0,5 L	PIW_POR_NOV_BUT_500	5907222560020	0.77	10.00	2416
PINTA BARREL BREWING PERCEPTION 30,0° BUT. 0,33 L	PBB_PER_BUT_330	5904335577471	0.50	10.00	2417
MIKKELLER CHERRY FREDERIKSDAL TRIPELBOCK 2019 BUT. 0,375 L	MIK CH FR TR 2019 375	5704255119221	0.50	10.00	2418
LIMBURGSE WITTE TAP HANDLE	LIMB WIT TAP HAN	5123456791368	0.00	10.00	2419
RECRAFT POLISH HAZY IPA AMORA PRETA & 3/20 PUSZKA 0,5 L	REC_POL_HAZ_3/20_PUSZ_500	5904730663786	0.54	10.00	2420
MAGIC ROAD (EVERGREEN PRETTY)3 PUSZKA 0,5 L	MR_EVE_PRE3_PUSZ_500	5905204130773	0.54	10.00	2421
ROCKMILL GALACTIC BROTHERHOOD: HOPPINESS BUT. 0,5 L	ROCK_GAL_BRO_HOPP_BUT_500	5908291862022	0.77	10.00	2422
MOCZYBRODA PULP FUSION BUT. 0,5 L	MOCZY PUL	5904673800279	0.77	10.00	2423
KAZIMIERZ DESET Z DESETI  BUT. 0,5 L	KAZ_DES_BUT_500	5906660570769	0.77	10.00	2424
KAZIMIERZ ZERRO% BUT. 0,5 L	KAZ ZER	5906660570479	0.77	10.00	2425
ED RED KONSERWA BOEUF STROGANOV	ED BOE STR	5903940086538	0.00	10.00	2426
PINTA / Sibeeria Cold's Cool 13,0° keykeg 20 l	PI_COLD_COOL_KKEG_20	\N	0.00	10.00	2427
NEPOMUCEN NACHMIELONA CHMIEL+SOSNA+JABЈKO+POMARAСCZA PUSZKA 0,5 L	NE_NACH_SOS-JAB-POM_PUSZ_500	5905191386702	0.54	10.00	2428
FUNKY FLUID HALLERTAUER PILS PUSZKA 0,5 L	FF_HAL_PUSZ_500	5903999514198	0.54	10.00	2429
KINGPIN LUNATIC BUT. 0,5 L PROMOCJA (do 13.10.23)	KING LUN_PROM	\N	0.00	10.00	2430
PRAIRIE ALE BUT. 0,5 L	PRAI ALE	894776000179	0.77	10.00	2431
DEER BEAR COLD CAT KEG 30 L	DE_COL_CAT_KEG_30	\N	32.00	10.00	2432
ST. FEUILLIEN BRUNE BUT. 0,33 L	STF BRU 330	5412138203317	0.50	10.00	2433
MIЈOSЈAW & MAKЈOWICZ ARCY APA BUT. 0,5 L	MIЈ_ARC_APA_BUT_500	5902838991435	0.77	10.00	2434
DUGGES DOUBLE RAINBOW PUSZKA 0,5 L	DUGG_DOU_RAIN_PUSZ_500	7350038227959	0.54	10.00	2435
ALEBROWAR HERR AXOLOTL WITH WHITE GUAVA BUT. 0,5 L	ALE_HER_WHI_GUA_BUT_500	5907222039786	0.77	10.00	2436
GRODZISKIE PIWOBRANIOWE 2023 BUT. 0,5 L	MIЈ_GRO_PIW_2023_BUT_500	5905279533714	0.77	10.00	2437
BROKREACJA GONE WITH THE PILS BUT. 0,5 L	BR_GON_BUT_500	5904422197995	0.77	10.00	2438
PRAIRIE VOUS FRANCAIS BUT. 0,75 L	PRAI VOU	683318988255	1.10	10.00	2439
NEPOMUCEN MEET OUR FRIENDS | EPISODE 12: MOON LARK PUSZKA 0,5 L	NE_MEE_MOO_PUSZ_500	5905701060092	0.54	10.00	2440
MARYENSZTADT OAT CHOCOLATE RIS HEAVEN HILL KENTUCKY STRAIGHT BURBON WHISKEY & COGNAC B.A. BUT. 0,33 L PROMO	MAR OAT CHO RIS HEA PROMO	\N	0.00	10.00	2441
FLOREFFE TRIPLE BUT. 0,75 L	FLO TRI 750	5411276200929	1.10	10.00	2442
PIWOTEKA CZAISZ BAZК: EARL GREY BUT. 0,5 L	PIW_CZA_EAR_BUT_500	5905669428095	0.77	10.00	2443
LINDEMANS GUEUZE TAP HANDLE	LIND GUE TAP HAN	5123456791015	0.00	10.00	2444
LINDEMANS POKAL SENSORIK  0,25 L	LIND POK SEN 250	5123456791229	0.00	10.00	2445
HANSSENS FRAMBOISE BUT. 0,375 L	HANS FRA 375	5430000304085	0.50	10.00	2446
ED RED KONSERWA INDYK W SOSIE SEROWO-ZIOЈOWYM	ED IND	5904083584066	0.00	10.00	2447
IGNACУW CYDR POM BUT. 0,375 L	IGNAC POM	\N	0.50	10.00	2448
LINDEMANS PODSTAWKA NA PODKЈADKI	LIN PODS	5123456791327	0.00	10.00	2449
MARYENSZTADT KLASYCZNIE DRY STOUT BUT. 0,5 L	MAR KLA DRY	5903678022952	0.77	10.00	2450
CIESZYN PORTER BAЈTYCKI BUT. 0,5 L	CIE POR	5905279156104	0.77	10.00	2451
JAN OLBRACHT POMARAСCZARNIA BUT. 0,5 L	JO POM	5904730284660	0.77	10.00	2452
TRZECH KUMPLI PAN IPANI BUT. 0,5 L	TR PAN	5905669479196	0.77	10.00	2453
SMYKAN CYDR RENETY 2022 BUT. 0,75 L	SMYK REN	5905669332224	1.10	10.00	2454
SCHLENKERLA POKAL EICHE 0,4 L	Sch pok Eic 0,4	5123456791246	0.00	10.00	2455
LITOVEL PREMIUM 12° KEG 30 L	LIT PRE K	\N	32.00	10.00	2456
ZA MIASTEM POGODA DUCHA BUT. 0,5 L	ZAM POG	5906874605073	0.77	10.00	2457
SCHNEEEULE JOHNS TAGE BUT. 0,75 L	SCHN JOH TAG	\N	1.10	10.00	2458
IMBIOROWICZ MIУD PITNY TRУJNIAK ЇҐDЈO Z BECZKI BA BUT. 0,5 L	IMB Їad bec 500	5905669820424	0.77	10.00	2459
MONSTERS FRUIT MACHINE #8 PUSZKA 0,5 L	MO_FRU_MAC_#8_PUSZ_500	5905476980663	0.54	10.00	2460
INNE BECZKI MIAMI BUT. 0,5 L	INNE MIA	5905669683180	0.77	10.00	2461
MOCZYBRODA BITTER SYMPHONY PUSZKA 0,5 L	MO_BIT_PUSZ_500	5904673800873	0.54	10.00	2462
MAGIC ROAD WICKED PUSZKA 0,5 L	MR_WICV_PUSZ_500	5905204130841	0.54	10.00	2463
TARNOBRZEG AWATAR BUT. 0,5 L	TAR_AVA_BUT_500	5907713309725	0.77	10.00	2464
MOON LARK FREAK ME. NEW ZEALAND PILS 12,0° PUSZKA 0,5 L	ML_FRE_PUSZ_500	5905255346420	0.54	10.00	2465
STU MOSTУW WILD #20 CHERRY MIX FERMENTATION ALE BUT. 0,375 L	STU_WIL_#20_BUT_375	5907614682934	0.50	10.00	2466
MIKKELLER SPONTAN CARROT BUT. 0,375 L	MIK SPON CARR 375	5704255117975	0.50	10.00	2467
ZAKЈADOWY WRУBEL W GARЊCI BUT. 0,5 L	ZA_WRУ_BUT_500	5907753172327	0.77	10.00	2468
TRZECH KUMPLI RAGNAR BUT. 0,33 L	TR RAG	5905669479356	0.50	10.00	2469
ZULI STURNUS TRУJNIAK WIЊNIOWY BUT. 0,7 L	ZU_STURN_BUT_700	5904933314263	0.00	10.00	2470
STAROPOLSKIE BESTBIR LETNIA ЊLIWKA BUT. 0,5 L	STAR BES LET ЊLI	5903111989972	0.77	10.00	2471
ZA MIASTEM SPOTKANIE PRZYJACIУЈ BUT. 0,5 L	ZAM SPO	5906874605462	0.77	10.00	2472
AMBER BARLEY DESSERT BUT. 0,5 L	AMB_BAR_DES_BUT_500	5906591002421	0.77	10.00	2473
LIMBURGSE WITTE POKAL 0,25 L	LIMB WIT POK 250	5123456791074	0.00	10.00	2474
PINTA Kwas Xy 12,0° but. 0,5 l	PI Xy	5908252864355	0.00	10.00	2475
HANSSENS OUDBEITJE BUT. 0,375 L	HANS OUD 375	5430000304078	0.50	10.00	2476
CANTILLON CUVEE SAINT-GILLOISE 2021 BUT. 0,75 L	KAT06332	5123456790012	1.10	10.00	2477
AFFLIGEM TRIPLE  BUT. 0,33 L	AFF TRI 330	5410263925753	0.50	10.00	2478
VAL-DIEU CUVEE 800 BUT. 0,75 L	VAL CUV 750	5413977000952	1.10	10.00	2479
O'HARA'S LEANN FOLLAIN BUT. 0,5 L	Oha Lea	5391500600551	0.77	10.00	2480
GOЊCISZEWO SOЈTYS BUT. 0,5 L	GO_SOЈ_BUT_500	5903364108557	0.77	10.00	2481
MALTGARDEN GATE NO 3/2023 PUSZKA 0,33 L	MA_GAT_3_2023_PUSZ_330	5907710943168	0.35	10.00	2482
NEPOMUCEN BRUSCO PUSZKA 0,5 L	NE_BRU_PUSZ_500	5905701060139	0.54	10.00	2483
BЈONIE CUDA WIANKI BUT. 0,5 L	BЈO CUD	5908258856088	0.77	10.00	2484
WIDAWA SHARK BUT. 0,5 L	WID SHA 500	5907710904046	0.77	10.00	2485
MALTGARDEN PERFECT FOR EVERYDAY PUSZKA 0,5 L	MA_PER_EVE_PUSZ_500	5904050721975	0.54	10.00	2486
O'HARA'S FREEBIRD IPA BUT. 0,5 L	Oha Fre Whi IPA	5391500601169	0.77	10.00	2487
FILOMELOS CYDR WYTRAWNY BUT. 0,75 L	FIL_CYD_WYT_BUT_750	5900168509016	1.10	10.00	2488
CZTERY ЊCIANY LUSTRO PUSZKA 0,5 L	4SC_LUS_PUSZ_500	5905108498801	0.54	10.00	2489
KASTEEL ROUGE BUT. 0,33 L	KAST ROU	5411081003654	0.50	10.00	2490
ANDERSON JEAN GINIE GIN BA BUT. 0,33 L	AND JG GIN 330	4744175010582	0.50	10.00	2491
P?HJALA STRUDEL STOUT KEG 20 L	POH STR STO 20L	\N	21.50	10.00	2492
SKRZYNKA A-20 BROWAR FORTUNA	SKRZ FOR	\N	0.00	10.00	2493
VIGO Kombucha Original but. 0,33 l	VIG_KOM_ORIG_BUT_330	5902768514803	0.00	10.00	2494
MOCZYBRODA BITTER BURST PUSZKA 0,5 L	MO_BIT_BUR_PUSZ_500	5904673801122	0.54	10.00	2495
SCHNEIDER WEISSE SZKLANKA 0,5 L	SCHNE SZKL 0,5	5123456791259	0.00	10.00	2496
PINTA Otwieracz magnes Logo	PINTA Otw mag Log	5904165101648	0.00	10.00	2497
PINTA BARREL BREWING SEED 12,0° BUT. 0,750 L	PBB_SEE_BUT_750	5904335577648	0.00	10.00	2498
TARNOBRZEG SUPERSTAR VOL.3 BUT. 0,5 L	TAR_SUP_VOL3_BUT_500	5904533544121	0.77	10.00	2499
TRZECH KUMPLI QUADRUPEL BUT. 0,33 L	TR QUA	5905669479677	0.50	10.00	2500
FLORIS CHOCOLAT BUT. 0,33 L	FLO CHOC 330	5412186000401	0.50	10.00	2501
ED RED KONSERWA KARKУWKA Z PIWEM PIERWSZA POMOC	ED BOC	5904083584127	0.00	10.00	2502
TRZECH KUMPLI MVPILS KEG 30 L	TR MVP K	5123456789487	32.00	10.00	2503
REVOLTA ROOIBOS PEAR MELON AIPA BUT. 0,5 L	REV_ROO_BUT_500	5900470079009	0.77	10.00	2504
GRYBУW PILSVAR GRYBУW BUT. 0,5 L	GR GRY	5902516000268	0.77	10.00	2505
P?HJALA - STILLWATER RANNAK PUSZKA 0,33 L	POH_STI_RAN_PUSZ_330	4742976016215	0.35	10.00	2506
PIWNE PODZIEMIE CHMIELOKRATA CASHMERE PUSZKA 0,5 L	POD_CHM_CAS_PUSZ_500	5904305482781	0.54	10.00	2507
PINTA Kubek plastikowy Eco 0,5 l	PI Kub pla	5904165103123	0.00	10.00	2508
MIЈOSЈAW CYDR MIЈOSЈAWSKI PУЈSЈODKI BUT. 0,5 L	MIЈ CYD	5901687910307	0.77	10.00	2509
KAZIMIERZ CZAS NA FAIRANT BUT. 0,5 L	KAZ CZA	5906660570554	0.77	10.00	2510
DUVEL ЊWIATЈO ROWEROWE	DUV ЊWI ROW	\N	0.00	10.00	2511
P?HJALA MUDCAKE BДNGER BUT. 0,33 L	POH MUD BAN	4742976015584	0.50	10.00	2512
DEER BEAR FLORAL KEG 30 L	DE_FLOR_KEG_30	\N	32.00	10.00	2513
SCHLENKERLA SPIEL - GRA PLANSZOWA	SCH GRA PLA	5123456791314	0.00	10.00	2514
PINTA Modern Drinking 15,0° but. 0,5 l	PI Mod	5904730438599	0.00	10.00	2515
WIDAWA HOP INCIDENT 02 BUT. 0,5 L	WID_HOP_02_BUT_500	5907710904619	0.77	10.00	2516
KINGPIN GORDITO PUSZKA 0,5 L	KING GOR	5904730290937	0.54	10.00	2517
STAROPOLSKIE PORTER RUM BUT. 0,5 L	STAR POR RUM	5903021503282	0.77	10.00	2518
ALEBROWAR CHILLIN' PICO - PINACOLADA BUT. 0,5 L	ALE_CHILL_PIC_BUT_500	5907771343396	0.77	10.00	2519
TRZECH KUMPLI PINK BOOTS 2023 PUSZKA 0,5 L	TR_PIN_2023_PUSZ_500	5904252699713	0.54	10.00	2520
MINISTER NICE RICE BUT. 0,5 L	MIN_NIC_RIC_BUT_500	5903351660273	0.77	10.00	2521
DU BOCQ BLANCHE DE NAMUR T-SHIRT	DU BOC BLA DE NAM T-SH	5123456791022	0.00	10.00	2522
WRКЇEL MILK ME BUT. 0,5 L	WRE MIL ME	5904730465366	0.77	10.00	2523
STONE STYGIAN DESCENT 2016 BUT. 0,5 L	KAT03016	636251740718	0.77	10.00	2524
PINTA Party'23 Collab 12,0° keg 30 l	PI_PAR_23_COL_KEG_30	5123456780023	0.00	10.00	2525
KASTEEL CUVEE DU CHATEAU BUT. 0,33 L	KAST CUV	5411081004811	0.50	10.00	2526
DUCKPOND DARKWING PUSZKA 0,33 L	OMB Duc Dar	7350015140219	0.35	10.00	2527
MAGIC ROAD WE KEEP OUR PROMISES PUSZKA 0,5 L	MR_WE_KEE_PUSZ_500	5905204130148	0.54	10.00	2528
MARYENSZTADT FREEKY APA BEZALKOHOLOWE BUT. 0,5 L	MAR FRE APA	5903424615568	0.77	10.00	2529
SCHLENKERLA RAUCHBIER HANSLA 3,4° BUT. 0,5 L	SCH HAN	4037458000180	0.77	10.00	2530
AMBER IPA PUSZKA 0,5 L	ALE_IPA_PUSZ_500	5906591002971	0.54	10.00	2531
STAROPOLSKIE ZЈOTY UL 3 MIODY BUT. 0,5 L	STAR UL 3 MIO	5905669086288	0.77	10.00	2532
PINTA Barrel Brewing Memory but. 0,33 l	PBB Mem	5904335577419	0.00	10.00	2533
HARPAGAN PUNKY MONKEY PUSZKA 0,5 L PROMOCJA (do 28.10.23)	HARP PUN_PROM	\N	0.00	10.00	2534
DE MOLEN WATER & VUUR BUT. 0,33 L	DE_MOLEN_WAT_VUU_BUT_330	8717624422409	0.50	10.00	2535
MARYENSZTADT KLASYCZNIE POLSKI LAGER BUT. 0,5 L	MAR KLA POL LAG	5905669542395	0.77	10.00	2536
MOCZYBRODA BREWTOPIA PUSZKA 0,5 L	MO_BRE_PUSZ_500	5904673800828	0.54	10.00	2537
FLOREFFE PRIMA MELIOR BUT. 0,33 L	FLO PRI 330	5411276300513	0.50	10.00	2538
PINTA Kwas Jota 10,5° keg 30 l	PI Jot keg 30	5123456789729	0.00	10.00	2539
JURAJSKIE PORZECZKA BUT. 0,5 L	JUR PORZ	5905331026895	0.77	10.00	2540
MALTGARDEN GATE NO 4/2021 BUT. 0,5 L	MALT GAT 4	5904050721555	0.77	10.00	2541
FUNKY FLUID SANDY BUT. 0,5 L	FF SAN	5907772092170	0.77	10.00	2542
LA TRAPPE TRIPEL BUT. 0,75 L	TRAP TRI 750	8711406137192	1.10	10.00	2543
TOOL JULE MALT IMPERIAL MILK STOUT BUT. 0,375 L	KAT00399	5711474000698	0.50	10.00	2544
NEPOMUCEN PELICAN BUT. 0,5 L	NE PEL	5905279959750	0.77	10.00	2545
ZIEMIA OBIECANA TRIPLE BAJLANDO PUSZKA 0,5 L	ZO_TRI_BAJ_PUSZ_500	5905186484314	0.54	10.00	2546
PINTA Double Delivery 18,0° keg 20 l	PI_DOU_DEL_KEG_20	5123456780021	0.00	10.00	2547
ZA MIASTEM DOBRY NASTRУJ BUT. 0,5 L	ZAM_DOB_NAST_BUT_500	5904905630162	0.77	10.00	2548
P?HJALA COSY NIGHTS KEG 20 L	POH CON 20L	5123456789914	21.50	10.00	2549
SARABANDA SCRUB THE BARREL PUSZKA 0,5 L	SA_SCU_PUSZ_500	5904501978262	0.54	10.00	2550
LINDEMANS KRIEK KEG 25 L	LIND KRI K 25	5123456789024	28.00	10.00	2551
FUNKY FLUID COPACABANA PUSZKA 0,5 L	FF_COP_PUSZ_500	5903999514372	0.54	10.00	2552
O'HARA'S IRISH STOUT NITRO K-KEG 30 L	Oha Iri Sto Nit k-keg 30	5391500601336	32.00	10.00	2553
BROKREACJA EDWARD BUT. 0,5 L	BR_EDW_BUT_500	5904422197957	0.77	10.00	2554
P?HJALA PRENZLAUER BERG PUSZKA 0,33 L	KAT06431	4742976013689	0.35	10.00	2555
FUNKY FLUID NECTARINE SOUR PUSZKA 0,5 L	FF_NEC_SOU_PUSZ_500	5903999514143	0.54	10.00	2556
MOCZYBRODA VELVET NIGHTFALL BUT. 0,5 L	MO_VEL_BUT_500	\N	0.77	10.00	2557
CHYLICZKI PERRY LODOWA GRUSZKA 2021 BUT. 0,5 L	CH_PER_LOD_GRU_2021_BUT_500	5905279058286	0.77	10.00	2558
TRZECH KUMPLI GOEDEMORGEN BUT. 0,5 L	TR GOE	5905669479318	0.77	10.00	2559
MIKKELLER PUMA BOKSERKA SPORTOWA NIEBIESKA (L)	MIK PUM N L	5123456791123	0.00	10.00	2560
DUGGES FIRE PUSZKA 0,33 L	DUGG_FIR_PUSZ_330	7350038225900	0.35	10.00	2561
SCHLENKERLA RAUCHBIER FASTENBIER VINTAGE 2018 BUT. 0,5 L	SCH_FAS_VIN_2018	4037458000166	0.77	10.00	2562
INNE BECZKI SPILL THE TEA BUT. 0,5 L	IN_SPI_THE_BUT_500	5901122234173	0.77	10.00	2563
ARTEZAN TRENDING UP BUT. 0,5 L	ART_TRE_BUT_500	5904708750722	0.77	10.00	2564
TANKBUSTERS BROTHERS IN ARMS PUSZKA 0,5 L	TB_BRO_ARM_PUSZ_500	5904365781497	0.54	10.00	2565
NEPOMUCEN CHARLOTTE BUT. 0,5 L	NE CHA	5905279959699	0.77	10.00	2566
CYRILOVY BRAMBURKY MUSZTARDOWE - CHIPSY 100 G	CYR_BRAM_MUSZ_100	8594021041088	0.00	10.00	2567
ARTEZAN SPOILER ALERT BUT. 0,5 L	ART_SPO_ALE_BUT_500	5904708750661	0.77	10.00	2568
FUNKY FLUID BLACK CURRANT SOUR BUT. 0,5 L	FF BLA	5906395560349	0.77	10.00	2569
PETRUS NITRO CHERRY CHOCO KEG 30 L	PET NIT CHER CHO K 30	5123456789019	32.00	10.00	2570
VAL-DIEU TRIPLE BUT. 0,75 L	VAL TRI 750	5413977000051	1.10	10.00	2571
FUNKY FLUID LEVIATHAN 2022 PUSZKA 0,33 L	FF LEV 2022	5903999510435	0.35	10.00	2572
STONE / DOGFISH HEAD SAISON DU BUFF BUT. 0,5 L	KAT03013	636251870255	0.77	10.00	2573
LA TRAPPE ISID`OR BUT. 0,33 L	TRAP IS 330	8711406031681	0.50	10.00	2574
MIKKELLER SPONTAN SEA BUCKTHORN BUT. 0,375 L	MIK SPON SEA BU 375	818534013126	0.50	10.00	2575
MOON LARK MIRAGE 3.0. HAZY SESSION IPA PUSZKA 0,5 L	ML_MIR_3.0_PUSZ_500	5905255346451	0.54	10.00	2576
KRAJAN IRLANDZKIE CZERWONE BUT. 0,5 L	KRA_IRL_CZER_BUT_500	5907804436248	0.77	10.00	2577
PINTA Barrel Brewing Enology 2023 but. 0,75 l	PBB_ENO_2023_BUT_750	5904335577570	0.00	10.00	2578
SCHNEIDER TAP02 KRISTALL 11,2° BUT. 0,5 L	Schn TAP2	4003669016500	0.77	10.00	2579
WRКЇEL PILS BUT. 0,5 L	WRE PIL	5904730465731	0.77	10.00	2580
TRYBUNAЈ EXPORT BUT. 0,5 L	TRY_EXP_BUT_500	5905689304263	0.77	10.00	2581
IMBIOROWICZ MIУD PITNY DWУJNIAK PANIEСSKI KAMIONKA 0,70 L	IMB Dwу Paс kam	5905669820639	0.00	10.00	2582
WESTVLETEREN 8 EXTRA BUT. 0,33 L	WESTVLET 8	5123456790132	0.50	10.00	2583
DUBUISSON BUSH DE NOЛL BUT. 0,33 L	DUB BUS NOE 330	5411551320809	0.50	10.00	2584
IMBIOROWICZ MIУD PITNY TRУJNIAK AIRONIA BUT. 0,75 L	IMB Air 750	5905669820257	1.10	10.00	2585
ICE BREAKER SILVAS PROFUNDAS COLLAB. BREWING BEARS KEG 30 L	ICE BRE SIL PRO KEG 30	\N	32.00	10.00	2586
ZULI MELARYA IMBIR BUT. 0,33 L	ZU_MELA_IMB_BUT_330	5904933314201	0.50	10.00	2587
P?HJALA VIRMASILED O ALKOHOLIVABA IPA PUSZKA 0,33 L	POH_VIR_O_ALK_PUSZ_330	4742976013658	0.35	10.00	2588
LINDEMANS FARO BUT. 0,75 L	LIND FAR 750	5411223020204	1.10	10.00	2589
STU MOSTУW IMPERIAL PASTRY STOUT COCOA NIBS, COOKIES AND WHITE CHOCOLATE PUSZKA 0,44 L	STU IMP PAS STO COC	5907614681722	0.48	10.00	2590
CHIMAY KIELICH 0,33 L	160	5123456791189	0.00	10.00	2591
KORMORAN WIЊNIA W PIWIE BUT. 0,5 L	KORM WIЊ	5902528410000	0.77	10.00	2592
NEPOMUCEN SZOSA BUT. 0,5 L	NE SZO	5907709756106	0.77	10.00	2593
MARYENSZTADT BEZGLUTENOWY JASNY LAGER BUT. 0,5 L	MAR BEZ JAS LAG	5903678022020	0.77	10.00	2594
ST. FEUILLIEN FIVE BUT. 0,33 L	STF FIV 330	5412138763316	0.50	10.00	2595
AYINGER POKAL 0,3 L	AYI POK  0,3	5123456791213	0.00	10.00	2596
P?HJALA GIMME DANGER BUT. 0,33 L	POH GIM	4742976012293	0.50	10.00	2597
DUGGES BOURBON SAFFRON BUT. 0,33 L	DUGG_BOU_SAFF_BUT_330	7350038226501	0.50	10.00	2598
DRAKES DRAKONIC BUT. 0,65 L	DRAK DRA	854957002071	0.00	10.00	2599
PINTA PARTY STARTER PAK 6 x 0,5 L PUSZKA	PI_PAR_STA_PAK	5904165103673	0.00	10.00	2600
SOWIE MARCOWE BUT. 0,5 L	SOW_MARC_BUT_500	5907222560068	0.77	10.00	2601
ZAKЈADOWY ЈATWO POSZЈO BUT. 0,5 L	ZAKЈ ЈAT POS	5907753171351	0.77	10.00	2602
THE BRUERY 6 GEESE A LAYING 0,75 L	BRU 6 GEE	718122104338	0.00	10.00	2603
ARTEZAN PEANUT BUTTER CHOCOLATE BUT. 0,5 L	ART_PEA_BUT_BUT_500	5904708750845	0.77	10.00	2604
BIRBANT HYPNOS PUSZKA 0,5 L	BI_HYP_PUSZ_500	5904041703638	0.54	10.00	2605
ST. FEUILLIEN GREEN FLESH POKAL 0,33 L	STF GRE FLE POK	5123456791066	0.00	10.00	2606
LINDEMANS T-SHIRT MКSKI SZARY (S)	LIND_TSH_MКS_SZA_S	\N	0.00	10.00	2607
BACCHUS BUT. 0,375 L	BACCH	5411081004736	0.50	10.00	2608
DUGGES TWISTER PUSZKA 0,33 L	DUGG_TWI_PUSZ_330	7350038224996	0.35	10.00	2609
LINDEMANS CASSIS K-KEG 20 L	LIND CAS K-KEG 20	\N	21.50	10.00	2610
NEPOMUCEN FULL OPEN CRAFT PUSZKA 0,5 L	NE_FUL_OPE_PUSZ_500	5905701060269	0.54	10.00	2611
KORMORAN MIODNE BUT. 0,5 L	KORM MIO	5902528431210	0.77	10.00	2612
VITAMINE SEA CLOWNING AROUND PUSZKA 0,473 L	OMB Vit Clo	5123456790118	0.53	10.00	2613
PINTA RISFACTOR Cocoa Nibs and Coconut 30,0° keg 20 l	PI RIS Coc Coc keg 20	5123456789783	0.00	10.00	2614
STRUISE PANNEPOT 2020 BUT. 0,33 L	STRU PAN 2020	5425017810049	0.50	10.00	2615
BIAЈY ARIZONA DREAM BUT. 0,5 L	BIA ARI	5903246576290	0.77	10.00	2616
LINDEMANS ZESTAW (1X BUT. 0,375 L + 3X BUT. 0,355 L + SZKЈO)	LIND ZES 1X375 + 3X 0,355  L+ SZ	5411223002064	0.00	10.00	2617
RACIBORSKIE PYRSK JABЈKO-PIGWOWIEC BUT. 0,33 L	RAC_PY_JAB_PIG_BUT_330	5905249834087	0.50	10.00	2618
SZRENIAWA PERLAGE BUT. 0,5 L	SZR_PERL_BUT_500	5903857178425	0.77	10.00	2619
CHYLICZKI GRAFF NO. 1 BUT. 0,5 L	CHYL GRA 1	5905279058231	0.77	10.00	2620
STU MOSTУW PUMPKIN SPICE SOUR BUT. 0,5 L	STU_PUM_SPI_BUT_500	5907614683306	0.77	10.00	2621
SCHNEIDER WEISSE POKAL SOMMELIER 0,2 L	SCHNE POK	5123456791256	0.00	10.00	2622
ALEBROWAR SINGLE HOP KOHATU BUT. 0,5 L	ALE_SH_KOH_BUT_500	5907771343259	0.77	10.00	2623
STU MOSTУW DRUNKEN SAILOR PUSZKA 0,33 L	STU DRU	5907614682491	0.35	10.00	2624
INNE BECZKI OLDSCHOOLOWIEC BUT. 0,5 L	IN_OLDSCH_BUT_500	5903661281618	0.77	10.00	2625
CIESZYN PILSNER BUT. 0,5 L	CIE_PIL_BUT_500	5907612240860	0.77	10.00	2626
TIMMERMANS FARO BUT. 0,375 L	TIMM FAR 375	5411516001491	0.50	10.00	2627
FUNKY FLUID FUSION: MOON LARK PUSZKA 0,5 L	FF_FUS_MON_PUSZ_500	5903999514181	0.54	10.00	2628
ST. BERNARDUS TRIPEL BUT. 0,33 L	STB TRI 330	54079038	0.50	10.00	2629
FUNKY FLUID GELATO: ROSA PUSZKA 0,5 L	FF_GEL_ROS_PUSZ_500	5903999514419	0.54	10.00	2630
DUGGES CINNA PUSZKA 0,33 L	DUGG_CIN_PUSZ_330	7350038225924	0.35	10.00	2631
ASLIN BC TRANS AM TRAV PUSZKA 0,473 L	ASL BC TRANS 473	725272730744	0.53	10.00	2632
GOЊCISZEWO CZAROWNICA BUT. 0,5 L	GO_CZAR_BUT_500	5903364108854	0.77	10.00	2633
ALEBROWAR SWEET 'N' HEAT BUT. 0,5 L	ALE_SWE_BUT_500	5907771343785	0.77	10.00	2634
PINTA T-shirt biaіy duїe logo XXL	PINTA Kos DL bia XXL	5904165102485	0.00	10.00	2635
GWAREK A HUNDRED PERCENT OF...MOSAIC PUSZKA 0,5 L	GW_AHU_MOS_PUSZ_500	5903938751714	0.54	10.00	2636
LINDEMANS FARO MEDALION RYBIE OKO	LIND_FAR_MED	\N	0.00	10.00	2637
TRZECH KUMPLI PINK BOOTS 2023 KEG 20 L	TE_PIN_2023_KEG_20	\N	21.50	10.00	2638
VAL-DIEU GRAND BUT. 0,33 L	VAL GRA 330	5413977000723	0.50	10.00	2639
ST. BERNARDUS ABT 12 BUT. 0,33 L	STB 12 330	54079021	0.50	10.00	2640
PIWNE PODZIEMIE EXOTICA KEG 30 L	POD_EXO_KEG_30	\N	32.00	10.00	2641
DELIRIUM TREMENS BUT. 0,75 L	DEL TREM 750	5412186000043	1.10	10.00	2642
PRAIRIE / TRVE EDITION SOUR RED FARMHOUSE ALE BUT. 0,5 L	PRAI TRV	683318988224	0.77	10.00	2643
KEG INBEV 20L	KEG INBEV	5123456792007	0.00	10.00	2644
LIMBURGSE WITTE CZAPKA Z DASZKIEM	LIMB WIT CZA DAS	5123456791348	0.00	10.00	2645
PINTA Bright Side can 0,5 L	PIN_BR_SI_CAN_500	5903314870787	0.54	5.45	2647
PINTA Bright Side can 0,5 L	PIN_BR_SI_CAN_500	5903314870787	0.54	5.45	2654
\.


--
-- TOC entry 4912 (class 0 OID 27991)
-- Dependencies: 236
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount) FROM stdin;
7	3 FON HOM BIO FRA 18/19 375	3 FONTEINEN HOMMAGE BIO FRAMBOOS 2018/2019 BUT. 0,375 L	5425007818314	53	szt	0.50	RA-01-01	2024-12-09	0	53
8	3 FON HOM 750	3 FONTEINEN HOMMAGE BUT. 0,75 L	5425007818123	6	szt	1.10	AT-26-00	2024-12-09	0	6
9	3 FON INT RED 750	3 FONTEINEN INTENSE RED OUDE KRIEK BUT. 0,75 L	5425007810981	8	szt	1.10	AT-26-00	2024-12-09	0	8
10	3 FON INT ROO 18/19 375	3 FONTEINEN INTENSE ROOD A83 2018/19 BUT. 0,375 L	5425007810943	1	szt	0.50	AT-26-00	2024-12-09	0	1
11	KAT06718	3 FONTEINEN KRYSZTAŁOWA SZKLANKA 0,2 L	5123456791157	10	szt	0.00	AT-26-00	2024-12-09	0	10
12	KAT06397	3 FONTEINEN KRYSZTAŁOWY KIELISZEK 0,33 L	5123456791155	2	szt	0.00	AT-26-00	2024-12-09	0	2
13	KAT06396	3 FONTEINEN KRYSZTAŁOWY KIELISZEK 0,645 L	5123456791153	1	szt	0.00	AT-26-00	2024-12-09	0	1
14	KAT06720	3 FONTEINEN KRYSZTAŁOWY KIELISZEK ZENNE 0,645 L	5123456791154	6	szt	0.00	AT-26-00	2024-12-09	0	6
15	3 FON ARM 2016/17 0,375	3 FONTEINEN OUDE GEUZE CUVEE ARMAND & GASTON 2016/17 BUT. 0,375 L	5425007813012	39	szt	0.50	RA-02-01	2024-12-09	0	39
16	3 FON OUD KRI 1,5	3 FONTEINEN OUDE KRIEK  2019/20 BUT. 1,5 L	5425007818598	3	szt	0.00	AT-26-00	2024-12-09	0	3
17	3 FON OUD KRI VAT 375	3 FONTEINEN OUDE KRIEK VAT BUT. 0,375 L	5425007810813	5	szt	0.50	AT-26-00	2024-12-09	0	5
18	90 BPM BIE NOI PIV	90 BPM BIERE NOIRE PIVO PUSZ. 0,33 L	683489591551	2	szt	0.00	AT-26-00	2024-12-09	0	2
19	90 BPM GRO IPA KEG 30	90 BPM GRODOUDOUBLE IPA KEG 30 L	\N	1	szt	32.00	AT-26-00	2024-12-09	0	1
20	90 BPM LAU GAN KEG 30	90 BPM L'AUTRE GANDALF KEG 30 L	\N	1	szt	32.00	AT-26-00	2024-12-09	0	1
21	90 BPM MIN ROS KEG 30	90 BPM MINITEL ROSE KEG 30 L	\N	1	szt	32.00	AT-26-00	2024-12-09	0	1
22	ABB_OUB_BUT_750	ABBAYE OUBLI?E BUT. 0,75 L	5425006246354	4	szt	1.10	AT-26-00	2024-12-09	0	4
23	ACH BRU 330	ACHEL BRUIN 8% BUT. 0,33 L	5425007658880	39	szt	0.50	RA-02-01	2024-12-09	0	39
24	AFF TRI 330	AFFLIGEM TRIPLE  BUT. 0,33 L	5410263925753	5	szt	0.50	AT-26-00	2024-12-09	0	5
25	ALCO 20	ALCORYTHM® TACA 20 SZT.	2590745162104	92	szt	0.00	RA-02-01	2024-12-09	0	92
26	ALE BAŁ PIL	ALEBROWAR BAŁTYCKI DZIAD PILS BUT. 0,5 L	5907771342276	80	szt	0.77	RA-02-01	2024-12-09	0	80
27	ALE BAŁ STO	ALEBROWAR BAŁTYCKI DZIAD STOUT BUT. 0,5 L	5907771342283	44	szt	0.77	RA-02-01	2024-12-09	0	44
28	ALE BAŁ WEI	ALEBROWAR BAŁTYCKI DZIAD WEIZEN BUT. 0,5 L	5907771342269	48	szt	0.77	RA-03-01	2024-12-09	0	48
29	ALE BAN	ALEBROWAR BANA MAMA BUT. 0,5 L	5907771342320	4	szt	0.77	AT-26-00	2024-12-09	0	4
30	ALE BEL	ALEBROWAR BE LIKE MITCH BUT. 0,5 L	5903364108496	86	szt	0.77	RA-03-01	2024-12-09	0	86
31	ALE BRU	ALEBROWAR BRAMBLE RUMBLE BUT. 0,5 L	5907771340692	115	szt	0.77	RA-01-00	2024-12-09	0	115
32	ALE_CHI_BUT_500	ALEBROWAR CHILLED TO THE BONE BUT. 0,5 L	5907771342993	306	szt	0.77	RA-01-00	2024-12-09	0	306
33	ALE_CHILL_PIC_BUT_500	ALEBROWAR CHILLIN' PICO - PINACOLADA BUT. 0,5 L	5907771343396	25	szt	0.77	RA-03-01	2024-12-09	0	25
34	ALE CRA	ALEBROWAR CRAZY MIKE BUT. 0,5 L	5903364108359	330	szt	0.77	RA-02-00	2024-12-09	0	330
35	ALE_CRA_ICE_BUT_250	ALEBROWAR CRAZY MIKE ICE PROJECT BUT. 0,25 L + KIELISZEK	5907771341378	3	szt	0.00	AT-26-00	2024-12-09	0	3
37	ALE FRE WAY	ALEBROWAR FREE WAY BUT. 0,5 L	5907222039526	138	szt	0.77	RA-03-00	2024-12-09	0	138
38	ALE_HER_APP-LIM_BUT_500	ALEBROWAR HERR AXOLOTL WITH APPLE & LIME BUT. 0,5 L	5907771340074	49	szt	0.77	RA-03-01	2024-12-09	0	49
39	ALE_HER_APR_BUT_500	ALEBROWAR HERR AXOLOTL WITH APRICOT BUT. 0,5 L	5907771343365	30	szt	0.77	RA-03-01	2024-12-09	0	30
40	ALE_HER_GOL_BUT_500	ALEBROWAR HERR AXOLOTL WITH GOLDENBERRY BUT. 0,5 L	5907771343716	135	szt	0.77	RA-03-00	2024-12-09	0	135
41	ALE_HER_GRAP_BUT_500	ALEBROWAR HERR AXOLOTL WITH GRAPEFRUIT BUT. 0,5 L	5907771343457	395	szt	0.77	RA-04-00	2024-12-09	0	395
42	ALE_HER_LOT_BUT_500	ALEBROWAR HERR AXOLOTL WITH LOTUS & ENIGMA BUT. 0,5 L	5907771343723	55	szt	0.77	RA-03-01	2024-12-09	0	55
44	ALE_HER_WHI_GUA_BUT_500	ALEBROWAR HERR AXOLOTL WITH WHITE GUAVA BUT. 0,5 L	5907222039786	11	szt	0.77	RA-04-01	2024-12-09	0	11
45	ALE_HOO_BUT_330	ALEBROWAR HOODED BLACK BARLEY BUT. 0,33 L	5907771343495	45	szt	0.50	RA-04-01	2024-12-09	0	45
46	ALE_HOP_SAS_BUT_500	ALEBROWAR HOP SASA BUT. 0,5 L	5907771343730	100	szt	0.77	RA-04-01	2024-12-09	0	100
47	ALE_HOP_ELE_BUT_500	ALEBROWAR HOPPY ELEVEN BUT. 0,5 L	5907771340067	85	szt	0.77	RA-05-01	2024-12-09	0	85
48	ALE ICE NAK	ALEBROWAR ICE NAKED MUMMY BUT. 0,25 L	5907771341385	3	szt	0.35	AT-26-00	2024-12-09	0	3
49	ALE ICE PAS MAS	ALEBROWAR ICE PASTRY MASTER BUT. 0,25 L	5907771341088	12	szt	0.35	RA-04-01	2024-12-09	0	12
50	ALE_ICE_SWE_BUT_250	ALEBROWAR ICE SWEET COW WITH COCOA NIBS BUT. 0,25 L	5907771343327	49	szt	0.35	RA-04-01	2024-12-09	0	49
51	ALE ICE SOR	ALEBROWAR ICED SORRY GRIGORY BUT. 0,25 L	5907771341927	7	szt	0.35	AT-26-00	2024-12-09	0	7
52	ALE ICE SWE SON	ALEBROWAR ICED SWEET AS SONYA BUT. 0,25 L	5907771341910	11	szt	0.35	RA-05-01	2024-12-09	0	11
53	ALE IMP HER BLA CUR_PROM	ALEBROWAR IMPERIAL HERR AXOLOTL BLACK CURRANT BUT. 0,5 L PROMOCJA (do 20.10.23)	\N	113	szt	0.00	RA-01-00	2024-12-09	0	113
54	ALE IMP HER CHE_PROM	ALEBROWAR IMPERIAL HERR AXOLOTL CHERRY BUT. 0,5 L PROMOCJA (do 19.10.23)	\N	88	szt	0.00	RA-05-01	2024-12-09	0	88
55	ALE KIN	ALEBROWAR KING OF HOP BUT. 0,5 L	5907222039182	80	szt	0.77	RA-05-01	2024-12-09	0	80
56	ALE_KWA_BUT_330	ALEBROWAR KWAS CHLEBOWY BUT. 0,33 L	5907771340012	11	szt	0.50	RA-05-01	2024-12-09	0	11
57	ALE_KWA_JAS_BUT_500	ALEBROWAR KWAS CHLEBOWY JASNY BUT. 0,5 L	5907771340036	7	szt	0.77	AT-26-01	2024-12-09	0	7
58	ALE LAD	ALEBROWAR LADY BLANCHE BUT. 0,5 L	5907222039137	450	szt	0.77	RA-05-00	2024-12-09	0	450
59	ALE_LOV_VIO_BUT_500	ALEBROWAR LOVELY VIOLA BUT. 0,5 L	5907771340050	62	szt	0.77	RA-06-01	2024-12-09	0	62
36	ALE ELF	ALEBROWAR EL FRUTO BUT. 0,5 L	5907222039106	100	szt	0.77	RA-02-00	2024-12-09	0	160
43	ALE_HER_SAB_HBC_HOP_BUT_500	ALEBROWAR HERR AXOLOTL WITH SABRO & HBC472 HOPS BUT. 0,5 L	5907771343464	70	szt	0.77	RA-04-01	2024-12-09	0	58
61	ALE_MIN_OF_CHAN_BUT_500	ALEBROWAR MINT OF CHANGE - MOHITO BUT. 0,5 L	5907771343389	91	szt	0.77	RA-06-01	2024-12-09	0	91
353	KAT06687	CHIMAY KIELICH W PUDEŁKU 0,18 L	5123456791186	9	szt	0.00	AT-26-04	2024-12-09	0	9
62	ALE_OCE_EMP_BUT_500	ALEBROWAR OCEAN EMPEROR BUT. 0,5 L	5907771342634	80	szt	0.77	RA-06-01	2024-12-09	0	80
63	ALE_PAP_TWI_BUT_500	ALEBROWAR PAPA TWINS BUT. 0,5 L	5907771343426	120	szt	0.77	RA-03-00	2024-12-09	0	120
64	ALE PEACH	ALEBROWAR PEACHOLINA BUT. 0,5 L	5907771340685	87	szt	0.77	RA-07-01	2024-12-09	0	87
65	ALE ROW	ALEBROWAR ROWING JACK BUT. 0,5 L	5907222039083	375	szt	0.77	RA-06-00	2024-12-09	0	375
66	ALE_SH_AMO_BUT_500	ALEBROWAR SINGLE HOP AMORA PRETA BUT. 0,5 L	5907771343235	278	szt	0.77	RA-07-00	2024-12-09	0	278
67	ALE_SH_EL_DOR_BUT_500	ALEBROWAR SINGLE HOP EL DORADO BUT. 0,5 L	5907771343242	291	szt	0.77	RA-08-00	2024-12-09	0	291
68	ALE_SH_KOH_BUT_500	ALEBROWAR SINGLE HOP KOHATU BUT. 0,5 L	5907771343259	23	szt	0.77	RA-05-01	2024-12-09	0	23
69	ALE_SH_NEC_BUT_500	ALEBROWAR SINGLE HOP NECTARON HAZY IPA BUT. 0,5 L	5907771342979	10	szt	0.77	AT-26-01	2024-12-09	0	10
70	ALE_SH_STY_CAR_BUT_500	ALEBROWAR SINGLE HOP STYRIAN CARDINAL HAZY APA BUT. 0,5 L	5907771343402	59	szt	0.77	RA-06-01	2024-12-09	0	59
71	ALE_SH_VER_BUT_500	ALEBROWAR SINGLE HOP VERMELHO HAZY APA BUT. 0,5 L	5907771343419	39	szt	0.77	RA-07-01	2024-12-09	0	39
72	ALE_SON_BUT_500	ALEBROWAR SON OF THE SON BUT. 0,5 L	\N	92	szt	0.77	RA-07-01	2024-12-09	0	92
73	ALE_SWE_BUT_500	ALEBROWAR SWEET 'N' HEAT BUT. 0,5 L	5907771343785	145	szt	0.77	RA-04-00	2024-12-09	0	145
74	ALE_VAN_PAS_BUT_500	ALEBROWAR VANILLA PASSION BUT. 0,5 L	5907771343792	140	szt	0.77	RA-06-00	2024-12-09	0	140
75	ALMAN IPA	ALMANAC SOUR IPA BUT. 0,375 L	748252022707	12	szt	0.50	RA-07-01	2024-12-09	0	12
76	AMAG VIE	AMAGER / DÁDIVA VIEWPOINT BUT. 0,33 L	5704603303005	13	szt	0.50	RA-07-01	2024-12-09	0	13
77	AMAG VIE COC	AMAGER / DÁDIVA VIEWPOINT COCO BUT. 0,33 L	5704603303012	24	szt	0.50	RA-07-01	2024-12-09	0	24
78	AMAG COB FUMENTES	AMAGER COBRAS FUMANTES BUT. 0,33 L	5704603303043	2	szt	0.50	AT-26-00	2024-12-09	0	2
79	AMB_BAR_DES_BUT_500	AMBER BARLEY DESSERT BUT. 0,5 L	5906591002421	56	szt	0.77	RA-08-01	2024-12-09	0	56
80	AMB_BEZ_IPA_BUT_500	AMBER BEZALKOHOLOWE IPA BUT. 0,5 L	5906591002520	65	szt	0.77	RA-08-01	2024-12-09	0	65
81	AMB_CHM_BUT_500	AMBER CHMIELOWY BUT. 0,5 L	5906591001479	37	szt	0.77	RA-08-01	2024-12-09	0	37
82	AMB_GRA_BUT_500	AMBER GRAND BUT. 0,5 L	5906591000816	43	szt	0.77	RA-08-01	2024-12-09	0	43
83	ALE_IPA_PUSZ_500	AMBER IPA PUSZKA 0,5 L	5906591002971	57	szt	0.54	RA-08-01	2024-12-09	0	57
84	AMB_JOH_BUT_500	AMBER JOHANNES BUT. 0,5 L	5906591001233	160	szt	0.77	RA-07-00	2024-12-09	0	160
85	AMB_KOZ_BUT_500	AMBER KOŹLAK BUT. 0,5 L	5906591000540	186	szt	0.77	RA-08-00	2024-12-09	0	186
86	AMB_MAR_BUT_500	AMBER MARANGO BUT. 0,5 L	5906591002995	20	szt	0.77	RA-08-01	2024-12-09	0	20
87	AMB_NAT_BUT_500	AMBER NATURALNY BUT. 0,5 L	5906591002834	50	szt	0.77	RA-09-01	2024-12-09	0	50
88	AMB_STO_BUT_500	AMBER PO GODZINACH - STOUT BUT. 0,5 L	5906591001981	55	szt	0.77	RA-09-01	2024-12-09	0	55
89	AMB_PSZ_BUT_500	AMBER PSZENICZNIAK BUT. 0,5 L	5906591001332	29	szt	0.77	RA-09-01	2024-12-09	0	29
90	AMB_ZŁO_LWY_BUT_500	AMBER ZŁOTE LWY BUT. 0,5 L	5906591000724	104	szt	0.77	RA-09-00	2024-12-09	0	104
91	Anc Szkl 1/2	ANCHOR SZKLANKA 1/2 PINT	5123456791391	6	szt	0.00	AT-26-01	2024-12-09	0	6
92	AND JG GIN 330	ANDERSON JEAN GINIE GIN BA BUT. 0,33 L	4744175010582	16	szt	0.50	RA-09-01	2024-12-09	0	16
93	AND JG LAPH 330	ANDERSON JEAN GINIE LAPHROAIG BA BUT. 0,33 L	4744175010988	36	szt	0.50	RA-09-01	2024-12-09	0	36
94	AND JG TEQU 330	ANDERSON JEAN GINIE TEQUILA BA BUT. 0,33 L	4744175010995	32	szt	0.50	RA-09-01	2024-12-09	0	32
95	And Val Szk Sha 5	ANDERSON VALLEY SZKLANKA SHAKER 0,5 L	5123456791394	8	szt	0.00	AT-26-01	2024-12-09	0	8
96	ART_11_BUT_500	ARTEZAN 11 BUT. 0,5 L	5904708750746	111	szt	0.77	RA-09-00	2024-12-09	0	111
97	ARTEZ A PILS	ARTEZAN A PILS BUT. 0,5 L	5904730574624	21	szt	0.77	RA-10-01	2024-12-09	0	21
98	ART_AND_BUT_500	ARTEZAN AND THE PLANETS ARE GOING CRAZY BUT. 0,5 L	5904708750791	65	szt	0.77	RA-10-01	2024-12-09	0	65
99	ART_BEZ_KRO_BUT_500	ARTEZAN BEZ KROPKI TO NIE WITAM BUT. 0,5 L	5904708750784	49	szt	0.77	RA-10-01	2024-12-09	0	49
100	ARTEZ CHA	ARTEZAN CHATEAU 2021 BUT. 0,375 L	5904730574846	55	szt	0.50	RA-10-01	2024-12-09	0	55
101	ART_CIN_BUT_500	ARTEZAN CINNAMON ROLLS BUT. 0,5 L	5904708750838	22	szt	0.77	RA-10-01	2024-12-09	0	22
102	ARTEZ CZA	ARTEZAN CZARNA WOŁGA BUT. 0,5 L	5904730574020	11	szt	0.77	RA-10-01	2024-12-09	0	11
103	ARTEZ_DOD_BUT_500	ARTEZAN DODO BUT. 0,5 L - PROMOCJA	\N	425	szt	0.00	RA-10-00	2024-12-09	0	425
104	ART_INN_BUT_500	ARTEZAN INNY TYP CZŁOWIEKA BUT. 0,5 L	5904708750456	8	szt	0.77	AT-26-01	2024-12-09	0	8
105	ARTEZ ITS 2	ARTEZAN IT'S A FEATURE 2 BUT. 0,33 L	5904708750388	11	szt	0.50	RA-11-01	2024-12-09	0	11
106	ART_JAR_CAS_BUT_375	ARTEZAN JARDIN DU CHÂTEAU CASSIS BUT. 0,375 L	5904708750630	94	szt	0.50	RA-11-01	2024-12-09	0	94
107	ART_JAR_DRU_BUT_375	ARTEZAN JARDIN DU CHÂTEAU DRUIF BUT. 0,375 L	5904708750609	105	szt	0.50	RA-09-00	2024-12-09	0	105
108	ART_JAR_FRA_BUT_375	ARTEZAN JARDIN DU CHÂTEAU FRAISE BUT. 0,375 L	5904708750623	106	szt	0.50	RA-09-00	2024-12-09	0	106
109	ART_JAD_PEC_BUT_375	ARTEZAN JARDIN DU CHÂTEAU PECHE BUT. 0,375 L	5904708750616	100	szt	0.50	RA-11-01	2024-12-09	0	100
110	ART_JAS_BUT_500	ARTEZAN JASNE ROZUMIEM BUT. 0,5 L	5904708750593	7	szt	0.77	AT-26-01	2024-12-09	0	7
111	ART_KOS_BUT_500	ARTEZAN KOSZYK NA 8 LITER BUT. 0,5 L	5904708750685	44	szt	0.77	RA-11-01	2024-12-09	0	44
112	ART_LAT_MOR_BUT_500	ARTEZAN LATARNIA MORSKA BUT. 0,5 L	5904708750807	85	szt	0.77	RA-12-01	2024-12-09	0	85
113	ART_LOS_BUT_500	ARTEZAN LOST IN THE WOODS BUT. 0,5 L	5904708750777	35	szt	0.77	RA-11-01	2024-12-09	0	35
114	ART_LOW_BUT_500	ARTEZAN LOW HANGING FRUIT BUT. 0,5 L	5904708750753	48	szt	0.77	RA-12-01	2024-12-09	0	48
116	ARTEZ NO!	ARTEZAN NO WORRIES! BUT. 0,5 L	5904730574310	59	szt	0.77	RA-12-01	2024-12-09	0	59
117	ARTEZ PAC	ARTEZAN PACIFIC BUT. 0,5 L	5904730574051	19	szt	0.77	RA-12-01	2024-12-09	0	19
118	ART_PAK_POW_BUT_500	ARTEZAN PAKIET POWITALNY BUT. 0,5 L	5904708750760	56	szt	0.77	RA-12-01	2024-12-09	0	56
354	KAT06696	CHIMAY KIELICH W PUDEŁKU 0,33 L	5123456791185	12	szt	0.00	RB-14-01	2024-12-09	0	12
119	ART_PEA_BUT_BUT_500	ARTEZAN PEANUT BUTTER CHOCOLATE BUT. 0,5 L	5904708750845	40	szt	0.77	RA-13-01	2024-12-09	0	40
120	ART_SMO_BUT_500	ARTEZAN S’MORES BUT. 0,5 L	5904708750821	40	szt	0.77	RA-13-01	2024-12-09	0	40
121	ARTEZ_SAM_2023_SOC_VAN_BUT_500	ARTEZAN SAMIEC ALFA 2023 SOCIAL VANILLA BUT. 0,5 L	5904708750678	23	szt	0.77	RA-12-01	2024-12-09	0	23
122	ART_SO_EAS_BUT_500	ARTEZAN SO EASY BUT. 0,5 L	5904708750814	32	szt	0.77	RA-13-01	2024-12-09	0	32
123	ART_SPO_ALE_BUT_500	ARTEZAN SPOILER ALERT BUT. 0,5 L	5904708750661	35	szt	0.77	RA-13-01	2024-12-09	0	35
124	ART_STU_PRZ_BUT_500	ARTEZAN STUDIUM PRZYPADKU BUT. 0,5 L	5904708750524	8	szt	0.77	AT-26-01	2024-12-09	0	8
125	ART_TEN_COL_BUT_500	ARTEZAN TEN COLLAB BUT. 0,5 L	5904708750739	60	szt	0.77	RA-13-01	2024-12-09	0	60
126	ARTEZ TOO	ARTEZAN TOO YOUNG TO BE HEROD BUT. 0,5 L	5904730574006	9	szt	0.77	AT-26-01	2024-12-09	0	9
127	ART_TRE_BUT_500	ARTEZAN TRENDING UP BUT. 0,5 L	5904708750722	93	szt	0.77	RA-13-01	2024-12-09	0	93
128	ART_UŚM-BAN-BRZ-TRU_PUSZ_500	ARTEZAN UŚMIECH BOMBELKA BANAN-BRZOSKWINIA-TRUSKAWKA PUSZKA 0,5 L	5904708750272	280	szt	0.54	RA-11-00	2024-12-09	0	280
129	ART_VOL_BUT_500	ARTEZAN VOLARE BUT. 0,5 L	5904708750654	8	szt	0.77	AT-26-01	2024-12-09	0	8
130	ARTEZ WIT	ARTEZAN WITAM BUT. 0,5 L	5904730574211	29	szt	0.77	RA-14-01	2024-12-09	0	29
131	ART_ZIE_BUT_500	ARTEZAN ZIELONE ŚWIATŁO BUT. 0,5 L	5904708750449	5	szt	0.77	AT-26-01	2024-12-09	0	5
132	ASL BC TRANS 473	ASLIN BC TRANS AM TRAV PUSZKA 0,473 L	725272730744	6	szt	0.53	AT-26-02	2024-12-09	0	6
133	AUG BLO 330	AUGUSTIJN BLOND BUT. 0,33 L	5411663002181	42	szt	0.50	RA-14-01	2024-12-09	0	42
134	AUG BRU 330	AUGUSTIJN BRUNE BUT. 0,33 L	5411663007001	60	szt	0.50	RA-14-01	2024-12-09	0	60
135	AUG GRA CRU 330	AUGUSTIJN GRAND CRU BUT. 0,33 L	5411663002204	12	szt	0.50	RA-11-01	2024-12-09	0	12
136	AYI ALT DUN	AYINGER ALTBAIRISCH DUNKEL BUT. 0,5 L	4104170020700	143	szt	0.77	RA-12-00	2024-12-09	0	143
137	AYI CEL	AYINGER CELEBRATOR BUT. 0,33 L	4104170022025	12	szt	0.50	RA-14-01	2024-12-09	0	12
138	AYI JAH	AYINGER JAHRHUNDERT BIER BUT. 0,5 L	4104170022209	88	szt	0.77	RA-14-01	2024-12-09	0	88
139	AYI POK  0,3	AYINGER POKAL 0,3 L	5123456791213	16	szt	0.00	RA-14-01	2024-12-09	0	16
140	BACCH	BACCHUS BUT. 0,375 L	5411081004736	68	szt	0.50	RA-15-01	2024-12-09	0	68
141	BACCH FRA	BACCHUS FRAMBOZENBIER BUT. 0,375 L	5411081004316	4	szt	0.50	AT-26-01	2024-12-09	0	4
142	BACCH GRA SZKL	BACCHUS GRAAL SZKLANKA 0,25 L	5123456791335	12	szt	0.00	RA-15-01	2024-12-09	0	12
143	BACCH KRI	BACCHUS KRIEK BUT. 0,375 L	5411081004309	13	szt	0.50	RA-15-01	2024-12-09	0	13
144	BACCH POD	BACCHUS PODKŁADKI	5123456791341	6	szt	0.00	AT-26-02	2024-12-09	0	6
145	BACCH TAB REK	BACCHUS TABLICA REKLAMOWA	5123456791362	1	szt	0.00	AT-26-00	2024-12-09	0	1
146	BACCH THU POK 500	BACCHUS THUR POKAL 0,5 L	5123456791336	7	szt	0.00	AT-26-02	2024-12-09	0	7
147	Bal Xya Bar	BALADIN XYAUYU BARREL 2017 BUT. 0,5 L	8032942290548	52	szt	0.77	RA-15-01	2024-12-09	0	52
148	Bal Xya Fum	BALADIN XYAUYU FUME 2016 BUT. 0,5 L	8032942290586	59	szt	0.77	RA-15-01	2024-12-09	0	59
149	BAL XYA KEN	BALADIN XYAUYU KENTUCKY 2017 BUT. 0,5 L	8032942290609	51	szt	0.77	RA-15-01	2024-12-09	0	51
150	Bal Xya Kio	BALADIN XYAUYU KIOKE BUT. 0,5 L	8032942297325	39	szt	0.77	RA-16-01	2024-12-09	0	39
151	BAL XYA ORO	BALADIN XYAUYU ORO 2018 BUT. 0,5 L	8032942291293	37	szt	0.77	RA-16-01	2024-12-09	0	37
152	BAV MAL 330	BAVARIA MALT BUT. 0,33 L	8714800003384	1	szt	0.50	AT-26-00	2024-12-09	0	1
153	BAV SUP WIT 330	BAVIK SUPER WIT PUSZKA 0,33 L	875213001720	21	szt	0.35	RA-16-01	2024-12-09	0	21
154	BIA ARI	BIAŁY ARIZONA DREAM BUT. 0,5 L	5903246576290	1	szt	0.77	AT-26-00	2024-12-09	0	1
155	BIG CHOUF 1,5	BIG CHOUFFE BUT. 1,5 L	5410769100999	2	szt	0.00	AT-26-02	2024-12-09	0	2
156	BI_ACA_PUSZ_500	BIRBANT ACADIA PUSZKA 0,5 L	5904041703850	436	szt	0.54	RA-13-00	2024-12-09	0	436
157	BI BIN DR_PROM	BIRBANT BINGE DRINKING PUSZKA 0,5 L PROMOCJA (do 10.10.23)	\N	9	szt	0.00	AT-26-02	2024-12-09	0	9
158	BI_CAT_PUSZ_500	BIRBANT CATALITYC PUSZKA 0,5 L	5904041703607	25	szt	0.54	RA-16-01	2024-12-09	0	25
159	BI_CLO_PUSZ_500	BIRBANT CLONY PUSZKA 0,5 L	5904041703652	20	szt	0.54	RA-16-01	2024-12-09	0	20
160	BI_DEL_PUSZ_500	BIRBANT DELUSION PUSZKA 0,5 L	5904041703720	37	szt	0.54	RA-16-01	2024-12-09	0	37
161	BI DRO	BIRBANT DRONIC PUSZKA 0,5 L	5904041703621	29	szt	0.54	RA-17-01	2024-12-09	0	29
162	BI_FLE_PUSZ_500	BIRBANT FLEX PUSZKA 0,5 L	5904041703843	419	szt	0.54	RA-14-00	2024-12-09	0	419
163	BI_FOM_PUSZ_500	BIRBANT FOMO PUSZKA 0,5 L	5904041703751	31	szt	0.54	RA-17-01	2024-12-09	0	31
164	BI_FRI_PUSZ_500	BIRBANT FRIDAY PUSZKA 0,5 L	5904041703676	12	szt	0.54	RA-17-01	2024-12-09	0	12
165	BI GUI_PROM	BIRBANT GUILTY PLEASURE PUSZKA 0,5 L PROMOCJA (do 07.10.23)	\N	202	szt	0.00	RA-12-00	2024-12-09	0	202
166	BI HAW HOP	BIRBANT HAWKINS HOPS PUSZKA 0,5 L	5904041703515	37	szt	0.54	RA-17-01	2024-12-09	0	37
167	BI HER	BIRBANT HERO% PUSZKA 0,5 L	5903240620944	349	szt	0.54	RA-15-00	2024-12-09	0	349
168	BI HOP	BIRBANT HOPSBANT FRESH IPA BUT. 0,5 L	5903240620166	64	szt	0.77	RA-17-01	2024-12-09	0	64
169	BI_HYP_PUSZ_500	BIRBANT HYPNOS PUSZKA 0,5 L	5904041703638	1	szt	0.54	AT-26-02	2024-12-09	0	1
170	BI IMP CIT	BIRBANT IMPERIAL CITRA IPA BUT. 0,5 L	5903240620142	935	szt	0.77	RA-01-02	2024-12-09	0	935
171	BI_KIZ_PUSZ_500	BIRBANT KIZZY PUSZKA 0,5 L	5904041703836	423	szt	0.54	RA-16-00	2024-12-09	0	423
172	BI_KOL_PUSZ_500	BIRBANT KOLO% PUSZKA 0,5 L	5904041703713	41	szt	0.54	RA-17-01	2024-12-09	0	41
173	BI LAG	BIRBANT LAGER PUSZKA 0,5 L	5904041703430	159	szt	0.54	RA-12-00	2024-12-09	0	159
174	BI_LOW_PUSZ_500	BIRBANT LOWKEY PUSZKA 0,5 L	5904041703737	41	szt	0.54	RA-18-01	2024-12-09	0	41
175	BI MELLO_PROM	BIRBANT MELLO JELL-OH PUSZKA 0,5 L PROMOCJA (do 11.10.23)	\N	285	szt	0.00	RA-17-00	2024-12-09	0	285
176	BI_MOR_PUSZ_500	BIRBANT MORPHIC PUSZKA 0,5 L	5904041703614	25	szt	0.54	RA-18-01	2024-12-09	0	25
177	BI MUE	BIRBANT MUERTE PUSZKA 0,33 L	5904041703348	18	szt	0.35	RA-18-01	2024-12-09	0	18
178	BI PIL KLA	BIRBANT PILS KLASYCZNY BUT. 0,5 L	5903240620418	16	szt	0.77	RA-18-01	2024-12-09	0	16
179	BI POR KLA	BIRBANT PORTER BAŁTYCKI KLASYCZNY BUT. 0,5 L	5903240620470	63	szt	0.77	RA-18-01	2024-12-09	0	63
180	BI_RAT_PUSZ_500	BIRBANT RATIO PUSZKA 0,5 L	5904041703829	378	szt	0.54	RA-18-00	2024-12-09	0	378
181	BI RED	BIRBANT RED AIPA BUT. 0,5 L	5903240620371	45	szt	0.77	RA-18-01	2024-12-09	0	45
182	BI_SAG_BUT_500	BIRBANT SAGA BUT. 0,5 L	5904041703669	90	szt	0.77	RA-19-01	2024-12-09	0	90
183	BI_SKU_PUSZ_500	BIRBANT SKULLY PUSZKA 0,5 L	5904041703874	23	szt	0.54	RA-19-01	2024-12-09	0	23
184	BI_THE_LAS_PUSZ_500	BIRBANT THE LAST DROP PUSZKA 0,5 L	5904041703805	28	szt	0.54	RA-19-01	2024-12-09	0	28
185	BI TIA	BIRBANT TIAMAT PUSZKA 0,33 L	5904041703270	4	szt	0.35	AT-26-02	2024-12-09	0	4
186	BI WEI KLA	BIRBANT WEIZEN KLASYCZNY BUT. 0,5 L	5903240620517	162	szt	0.77	RA-15-00	2024-12-09	0	162
187	BI WEI MAN	BIRBANT WEIZEN MANGO BUT. 0,5 L	5903240620524	420	szt	0.77	RA-19-00	2024-12-09	0	420
188	BI YUM	BIRBANT YUMMY BUT. 0,5 L	5903240620852	145	szt	0.77	RA-17-00	2024-12-09	0	145
189	BM SEX	BIRRA MANIA SEXY ARANCIA APA BUT. 0,33 L	5907694918428	52	szt	0.50	RA-19-01	2024-12-09	0	52
190	BM SIC	BIRRA MANIA SICILIAN IPA BUT. 0,33 L	5907694918411	3	szt	0.50	AT-26-02	2024-12-09	0	3
191	BM WIT	BIRRA MANIA WIT BIANCA BUT. 0,33 L	5907694918435	4	szt	0.50	AT-26-02	2024-12-09	0	4
192	BLA DE BRUX SZKL 330	BLANCHE DE BRUXELLES SZKLANKA 0,33 L	5123456791053	27	szt	0.00	RA-19-01	2024-12-09	0	27
193	BŁO CUD	BŁONIE CUDA WIANKI BUT. 0,5 L	5908258856088	405	szt	0.77	RB-01-00	2024-12-09	0	405
194	BŁO HUL DUS P	BŁONIE HULAJ DUSZA PUSZKA 0,5 L	5908258856941	3428	szt	0.54	AT-09	2024-12-09	0	3428
195	BŁO KAL	BŁONIE KALINA MALINA BUT. 0,5 L	5908258856125	315	szt	0.77	RB-02-00	2024-12-09	0	315
196	BŁO KUR	BŁONIE KUR ZAPIAŁ BUT. 0,5 L	5908258856101	510	szt	0.77	RA-01-03	2024-12-09	0	510
197	BŁO KUR P	BŁONIE KUR ZAPIAŁ PUSZKA 0,5 L	5908258856903	435	szt	0.54	RB-06-04	2024-12-09	0	435
198	BŁO ZAS	BŁONIE ZASIALI GÓRALE BUT. 0,5 L	5908258856095	655	szt	0.77	RA-01-03	2024-12-09	0	655
199	BOON MIK OUD GUE 750	BOON / MIKKELLER OUDE GEUZE BUT. 0,75 L	5412783552709	24	szt	1.10	RA-19-01	2024-12-09	0	24
200	BOON FAR 250	BOON FARO BUT. 0,25 L	5412783054012	64	szt	0.35	RB-01-01	2024-12-09	0	64
201	BOON FRA 375	BOON FRAMBOISE BUT. 0,375 L	5412783055842	96	szt	0.50	RB-01-01	2024-12-09	0	96
202	KAT03833	BOON FRAMBOISE KIELISZEK 0,15 L	5123456791170	3	szt	0.00	AT-26-02	2024-12-09	0	3
203	BOON GEU SEL K 20L	BOON GEUZE SELECTION KEG 20 L	\N	2	szt	21.50	AT-26-02	2024-12-09	0	2
204	KAT03829	BOON GEUZE SZKLANKA  0,25 L	5123456791050	21	szt	0.00	RB-01-01	2024-12-09	0	21
205	KAT03830	BOON GEUZE SZKLANKA 0,375 L	5123456791049	66	szt	0.00	RB-01-01	2024-12-09	0	66
206	BOON GMP 375	BOON GUEUZE MARIAGE PARFAIT BUT. 0,375 L	5412783052865	186	szt	0.50	RB-02-00	2024-12-09	0	186
207	BOON GMP 750	BOON GUEUZE MARIAGE PARFAIT BUT. 0,75 L	5412783052872	81	szt	1.10	RB-02-01	2024-12-09	0	81
208	KAT06097	BOON KIELISZEK TULP 0,25 L	5123456791166	37	szt	0.00	RB-01-01	2024-12-09	0	37
209	BOON KRI 375	BOON KRIEK BUT. 0,375 L	5412783053848	160	szt	0.50	RA-18-00	2024-12-09	0	160
210	BOON KRI 750	BOON KRIEK BUT. 0,75 L	5412783053190	97	szt	1.10	RB-02-01	2024-12-09	0	97
211	BOON_KRI_KEG_20	BOON KRIEK KEG 20 L	\N	6	szt	21.50	AT-26-02	2024-12-09	0	6
212	KAT03831	BOON KRIEK KIELISZEK  0,2 L	5123456791169	35	szt	0.00	RB-02-01	2024-12-09	0	35
213	KAT03832	BOON KRIEK KIELISZEK 0,3 L	5123456791168	1	szt	0.00	AT-26-02	2024-12-09	0	1
214	KAT06098	BOON KRIEK KIELISZEK 0,5 L	5123456791167	48	szt	0.00	RB-02-01	2024-12-09	0	48
215	BOON KMP 375	BOON KRIEK MARIAGE PARFAIT BUT. 0,375 L	5412783053886	171	szt	0.50	RB-03-00	2024-12-09	0	171
216	BOON LAM 2Y K 20L	BOON LAMBIEK 2 YEAR OLD KEG 20 L	\N	4	szt	21.50	AT-26-02	2024-12-09	0	4
217	BOON BLA LAB N*8	BOON OUDE GUEUZE BLACK LABEL N*8 BUT. 0,75 L	5412783152787	54	szt	1.10	RB-03-01	2024-12-09	0	54
218	BOON OUG 375	BOON OUDE GUEUZE BUT. 0,375 L	5412783052841	173	szt	0.50	RB-03-00	2024-12-09	0	173
219	BOON OUG 750	BOON OUDE GUEUZE BUT. 0,75 L	5412783052193	114	szt	1.10	RA-09-00	2024-12-09	0	114
220	BOON OUG VAT 109 375	BOON OUDE GUEUZE VAT 109 BUT. 0,375 L	5412783052933	70	szt	0.50	RB-03-01	2024-12-09	0	70
221	BOON OUG VAT 110 375	BOON OUDE GUEUZE VAT 110 BUT. 0,375 L	5412783001108	9	szt	0.50	AT-26-02	2024-12-09	0	9
222	BOON OUG VAT 91 375	BOON OUDE GUEUZE VAT 91 BUT. 0,375 L	5412783000910	28	szt	0.50	RB-02-01	2024-12-09	0	28
223	BOON OUG VAT 92 375 ml	BOON OUDE GUEUZE VAT 92 BUT. 0,375 L	5412783000927	21	szt	0.50	RB-03-01	2024-12-09	0	21
224	BOON OUG VAT DISC 375	BOON OUDE GUEUZE VAT DISCOVERY BOX (4 X 0,375 L)	5412783182944	199	szt	0.00	RB-04-00	2024-12-09	0	199
225	BOON OUK 375	BOON OUDE KRIEK BUT. 0,375 L	5412783053862	53	szt	0.50	RB-03-01	2024-12-09	0	53
226	BOON OUK 750	BOON OUDE KRIEK BUT. 0,75 L	5412783053879	11	szt	1.10	RB-01-01	2024-12-09	0	11
227	BOON SCH	BOON SCHAARBEEKSE KRIEK BUT. 0,375 L	5412783153258	76	szt	0.50	RB-03-01	2024-12-09	0	76
228	BOST KWA 330	BOSTEELS PAUWEL KWAK BUT. 0,33 L	54050051	452	szt	0.50	RB-05-00	2024-12-09	0	452
229	BOST KWAK 750 L	BOSTEELS PAUWEL KWAK BUT. 0,75 L	5410228285182	23	szt	1.10	RB-03-01	2024-12-09	0	23
230	360	BOSTEELS PAUWEL KWAK POKAL 0,33 L	5123456791081	20	szt	0.00	RB-04-01	2024-12-09	0	20
231	BOST TRI 330	BOSTEELS TRIPEL KARMELIET BUT. 0,33 L	54050082	755	szt	0.50	RA-01-04	2024-12-09	0	755
232	BOST TRI 750	BOSTEELS TRIPEL KARMELIET BUT. 0,75 L	5410693100553	36	szt	1.10	RB-04-01	2024-12-09	0	36
233	7D50-1626F	BOSTEELS TRIPEL KARMELIET POKAL 0,33 L	5123456791063	77	szt	0.00	RB-04-01	2024-12-09	0	77
234	BOST TRI ZEST 4X330 SZK	BOSTEELS TRIPEL KARMELIET ZESTAW 4X BUT. 0,33 L + SZKŁO	5410693100492	6	szt	0.00	AT-26-02	2024-12-09	0	6
235	BOUR FLAN BRU 330	BOURGOGNE DES FLANDRES BRUNE BUT. 0,33 L	5411516000517	46	szt	0.50	RB-04-01	2024-12-09	0	46
236	BR_ALL_ENG_BUT_500	BROKREACJA ALL BEERS MATTER - ENGLISH IPA BUT. 0,5 L	5904422197971	9	szt	0.77	AT-26-03	2024-12-09	0	9
237	BR_ALL_ENG_KEG_30	BROKREACJA ALL BEERS MATTER - ENGLISH IPA KEG 30 L	\N	1	szt	32.00	AT-26-02	2024-12-09	0	1
238	BR_ALL_OLD_BUT_500	BROKREACJA ALL BEERS MATTER - OLD ALE BUT. 0,5 L	5904422197988	35	szt	0.77	RB-04-01	2024-12-09	0	35
239	BR_ALM_GRI_BUT_500	BROKREACJA ALMOST GRIZZLY BUT. 0,5 L	5904422197841	48	szt	0.77	RB-04-01	2024-12-09	0	48
2615	ZAKŁ BRA	ZAKŁADOWY BRAMA WJAZDOWA BUT. 0,5 L	5906395388066	100	szt	0.77	RL-13-01	2024-12-09	0	100
240	BR_BAT_2023_BUT_330	BROKREACJA BATTLE MASTER 2023 BUT. 0,33 L	5905910086012	133	szt	0.50	RB-01-00	2024-12-09	0	133
241	BRO_COA_CAL_BUT_500	BROKREACJA COACHMAN'S CALL BUT. 0,5 L	5904422197827	76	szt	0.77	RB-05-01	2024-12-09	0	76
242	BR_EDW_BUT_500	BROKREACJA EDWARD BUT. 0,5 L	5904422197957	69	szt	0.77	RB-05-01	2024-12-09	0	69
243	BR_ERM_PUSZ_500	BROKREACJA ERMINE FLAIR PUSZKA 0,5 L	5904422197803	359	szt	0.54	RB-06-00	2024-12-09	0	359
244	BR_FOW_BUT_500	BROKREACJA FOWL QUEEN PUSZKA 0,5 L	5904422197797	279	szt	0.54	RB-04-00	2024-12-09	0	279
245	BR_GON_BUT_500	BROKREACJA GONE WITH THE PILS BUT. 0,5 L	5904422197995	78	szt	0.77	RB-05-01	2024-12-09	0	78
246	BR_HER_PUSZ_500	BROKREACJA HERMIT PUSZKA 0,5 L	5904422197865	186	szt	0.54	RB-03-00	2024-12-09	0	186
247	BRO LUD BA	BROKREACJA LUDZIE TRZYMAJCIE KAPELUSZE WILD TURKEY BOURBON B.A. BUT. 0,33 L	5904422197001	11	szt	0.50	RB-02-01	2024-12-09	0	11
248	BRO MEE #1	BROKREACJA MEET THE BARREL #1 - PURE OAK BUT. 0,33 L	5907610243979	2	szt	0.50	AT-26-02	2024-12-09	0	2
249	BRO MEE #5	BROKREACJA MEET THE BARREL #5 – RYE GIN BUT. 0,33 L	5904422197407	21	szt	0.50	RB-05-01	2024-12-09	0	21
250	BR_ORG_BUT_500	BROKREACJA ORIGAMI PANDA BUT. 0,5 L	5904422197933	43	szt	0.77	RB-05-01	2024-12-09	0	43
251	BRO PAR SYN 1 BA	BROKREACJA PARIS SYNDROME 1 BOURBON BARREL AGED BUT. 0,33 L	5907610243740	57	szt	0.50	RB-06-01	2024-12-09	0	57
252	BRO PAR SYN 2 BA	BROKREACJA PARIS SYNDROME 2 BOURBON BARREL AGED BUT. 0,33 L	5907610243757	74	szt	0.50	RB-06-01	2024-12-09	0	74
253	BR_PIR_BUT_500	BROKREACJA PIRATE BAY BUT. 0,5 L	5904422197810	8	szt	0.77	AT-26-03	2024-12-09	0	8
254	BRO POT#21	BROKREACJA POTION #21 BUT. 0,33 L	5904422197445	127	szt	0.50	RB-06-00	2024-12-09	0	127
255	BRO POT#22	BROKREACJA POTION #22 BUT. 0,33 L	5904422197582	39	szt	0.50	RB-06-01	2024-12-09	0	39
256	BRO POT#23	BROKREACJA POTION #23 BUT. 0,33 L	5904422197674	36	szt	0.50	RB-06-01	2024-12-09	0	36
257	BR_POT_#24_BUT_330	BROKREACJA POTION #24 BUT. 0,33 L	5904422197780	48	szt	0.50	RB-06-01	2024-12-09	0	48
258	BR_POT_#25_BUT_330	BROKREACJA POTION #25 BUT. 0,33 L	5904422197896	31	szt	0.50	RB-06-01	2024-12-09	0	31
259	BR_RED_SUN_PUSZ_500	BROKREACJA RED SUN PUSZKA 0,5 L	5904422197872	1	szt	0.54	AT-26-02	2024-12-09	0	1
260	BR_RIC_BUT_500	BROKREACJA RICKSHAW BUT. 0,5 L	5904422197940	7	szt	0.77	AT-26-03	2024-12-09	0	7
261	BRO SAV 001	BROKREACJA SAVAGE 001 BUT. 0,5 L	5907610243528	91	szt	0.77	RB-07-01	2024-12-09	0	91
262	BRO SAV 3	BROKREACJA SAVAGE 003 BUT. 0,5 L	5904422197056	27	szt	0.77	RB-07-01	2024-12-09	0	27
263	BRO SAV 004	BROKREACJA SAVAGE 004 BUT. 0,5 L	5907610243924	44	szt	0.77	RB-07-01	2024-12-09	0	44
264	BRO SAV 005	BROKREACJA SAVAGE 005 BUT. 0,5 L	5904422197537	44	szt	0.77	RB-07-01	2024-12-09	0	44
265	BR_SEA_PUSZ_500	BROKREACJA SEA BREEZE PUSZKA 0,5 L	5904422197902	256	szt	0.54	RB-07-00	2024-12-09	0	256
266	BR_SNO_GUE_BUT_500	BROKREACJA SNOW GUENON BUT. 0,5 L	5904422197773	30	szt	0.77	RB-07-01	2024-12-09	0	30
267	BR_TES_IPA_BUT_500	BROKREACJA TEST DRIVE IPA BUT. 0,5 L	5905910086005	175	szt	0.77	RB-07-00	2024-12-09	0	175
268	BRO ALC 0,5	BROKREACJA THE ALCHEMIST BUT. 0,5 L	5905669783033	158	szt	0.77	RB-08-00	2024-12-09	0	158
269	BRO BAR	BROKREACJA THE BARBER BUT. 0,5 L	5905669783644	63	szt	0.77	RB-07-01	2024-12-09	0	63
270	BR_BAR_BUT_500	BROKREACJA THE BARTENDER BUT. 0,5 L	5904422197735	55	szt	0.77	RB-08-01	2024-12-09	0	55
271	BRO DAN	BROKREACJA THE DANCER BUT. 0,5 L	5905669783279	40	szt	0.77	RB-08-01	2024-12-09	0	40
272	BRO DEA	BROKREACJA THE DEALER BUT. 0,5 L	5905669783255	57	szt	0.77	RB-08-01	2024-12-09	0	57
273	BRO FAR	BROKREACJA THE FARMER BUT. 0,5 L	5905669783040	127	szt	0.77	RB-08-00	2024-12-09	0	127
274	BRO FIG 0,5	BROKREACJA THE FIGHTER BUT. 0,5 L	5905669783248	55	szt	0.77	RB-08-01	2024-12-09	0	55
275	BRO LUM	BROKREACJA THE LUMBERJACK BUT. 0,5 L	5905669783026	84	szt	0.77	RB-08-01	2024-12-09	0	84
276	BRO NUR	BROKREACJA THE NURSE BUT. 0,5 L	5905669783095	117	szt	0.77	RA-14-00	2024-12-09	0	117
277	BR_TIM_PUSZ_500	BROKREACJA TIMBER PUSZKA 0,5 L	5904422197889	32	szt	0.54	RB-09-01	2024-12-09	0	32
278	BR_TUK_BUT_500	BROKREACJA TUK TUK BUT. 0,5 L	5904422197834	19	szt	0.77	RB-09-01	2024-12-09	0	19
279	BR_WHE_LEI_GUA-ANA_BUT_500	BROKREACJA WHERE IS LEITMOTIV? GUAVA-ANANAS BUT. 0,5 L	5904422197926	335	szt	0.77	RB-09-00	2024-12-09	0	335
280	BR_WHE_LEI_KIW_MAT_BUT_500	BROKREACJA WHERE IS LEITMOTIV? KIWI-MATCHA BUT. 0,5 L	5904422197919	23	szt	0.77	RB-09-01	2024-12-09	0	23
281	BGH_IMP_POR_BA_BUT_330	BROWAR GÓRNICZO-HUTNICZY IMPERIAL BALTIC PORTER BARREL AGED BUT. 0,33 L	5907796630105	54	szt	0.50	RB-09-01	2024-12-09	0	54
282	BRO_JA_APA_BUT_500	BROWAR JANA APA BUT. 0,5 L	5902429980022	371	szt	0.77	RB-10-00	2024-12-09	0	371
283	BRO_JA_BEZ_ALCO_BUT_500	BROWAR JANA BEZALKOHOLOWE BUT. 0,5 L	5902429980930	193	szt	0.77	RB-08-00	2024-12-09	0	193
284	BRO_JA_BEZGL_BUT_500	BROWAR JANA BEZGLUTENOWE JASNE PEŁNE BUT. 0,5 L	5902429980961	20	szt	0.77	RB-09-01	2024-12-09	0	20
2570	WRE PIN	WRĘŻEL PINK PANTHER BUT. 0,5 L	5904181970440	15	szt	0.77	RL-08-01	2024-12-09	0	15
285	BRO_JA_COLD_IPA_BUT_500	BROWAR JANA COLD IPA BUT. 0,5 L	5902429981548	225	szt	0.77	RB-11-00	2024-12-09	0	225
286	BRO_JA_IPA_BUT_500	BROWAR JANA IPA BUT. 0,5 L	5902429980145	265	szt	0.77	RB-11-00	2024-12-09	0	265
287	BRO_JA_JAS_PEŁ_BUT_500	BROWAR JANA JASNE PEŁNE BUT. 0,5 L	5902429980008	233	szt	0.77	RB-12-00	2024-12-09	0	233
288	BRO_JA_PILS_BUT_500	BROWAR JANA PILS BUT. 0,5 L	5902429980251	152	szt	0.77	RB-09-00	2024-12-09	0	152
289	BRO_JA_PSZE_BUT_500	BROWAR JANA PSZENICZNE BUT. 0,5 L	5902429980015	180	szt	0.77	RB-12-00	2024-12-09	0	180
290	BRO_JA_RZEŚ_BUT_500	BROWAR JANA RZEŚKIE BUT. 0,5 L	5902429980947	116	szt	0.77	RA-16-00	2024-12-09	0	116
291	BRO_JA_SZKL_500	BROWAR JANA SZKLANKA 0,5 L	\N	17	szt	0.00	RB-09-01	2024-12-09	0	17
292	BRO_JA_WEI_MAN_BUT_500	BROWAR JANA WEIZEN MANGO BUT. 0,5 L	5902429981012	224	szt	0.77	RB-13-00	2024-12-09	0	224
293	BRO_JA_WEI_MAR_BUT_500	BROWAR JANA WEIZEN MARAKUJA BUT. 0,5 L	5902429981449	54	szt	0.77	RB-10-01	2024-12-09	0	54
294	BRO_JA_ZEST_500	BROWAR JANA ZESTAW 2 x BUT. 0,5 L	\N	19	szt	0.77	RB-10-01	2024-12-09	0	19
295	BROW_BIRI_PUSZ_500	BROWARNY BIRIBOMBA PUSZKA 0,5 L	5905450141035	100	szt	0.54	RB-10-01	2024-12-09	0	100
296	BROW_EVI_PUSZ_500	BROWARNY EVIL BOY PUSZKA 0,5 L	5905450141134	105	szt	0.54	RA-10-00	2024-12-09	0	105
297	BROW_PYRA_PUSZ_500	BROWARNY PYRAMIDS PUSZKA 0,5 L	5905450141073	24	szt	0.54	RB-10-01	2024-12-09	0	24
298	BROW_ROY_PUSZ_500	BROWARNY ROYALS PUSZKA 0,5 L	5905450141127	72	szt	0.54	RB-10-01	2024-12-09	0	72
299	BROWA_UNH_PUSZ_500	BROWARNY UNHOLY PUSZKA 0,5 L	5905450141080	100	szt	0.54	RB-11-01	2024-12-09	0	100
300	BROW_YAN_PUSZ_440	BROWARNY YANGA PUSZKA 0,44 L	5905450141141	100	szt	0.48	RB-11-01	2024-12-09	0	100
301	BRUG ZOT BLO 330	BRUGSE ZOT BLONDE BUT. 0,33 L	5425017240013	2	szt	0.50	AT-26-02	2024-12-09	0	2
302	BRUG ZOT BLO 750	BRUGSE ZOT BLONDE BUT. 0,75 L	5425017240044	23	szt	1.10	RB-10-01	2024-12-09	0	23
303	BRUN BLA GF 750	BRUNEHAUT BLANCHE BIO GLUTEN FREE BUT. 0,75 L	5411065200895	20	szt	1.10	RB-11-01	2024-12-09	0	20
304	378	BRUNEHAUT KIELISZEK 0,25 L	5123456791165	12	szt	0.00	RB-05-01	2024-12-09	0	12
305	BRUN TRI GF 750	BRUNEHAUT TRIPLE BIO GLUTEN FREE BUT. 0,75 L	5411065201311	34	szt	1.10	RB-11-01	2024-12-09	0	34
306	BRUS PIN 750	BRUSSELS BEER PROJECT PINARD DE BUT. 0,75 L	5123456788001	25	szt	1.10	RB-11-01	2024-12-09	0	25
307	KAT06967	BRUSSELS BEER PROJECT TEKU 0,33 L	5123456791009	41	szt	0.00	RB-12-01	2024-12-09	0	41
308	BUR AOK MID LI 473	BURLEY OAK MID LIFE RIGHTEOUS PUSZKA 0,473 L	\N	2	szt	0.53	AT-26-03	2024-12-09	0	2
310	BUT_CZ_BOZ	BUTELKA ZWR CZECHY ( B) 0,5 L	\N	381	szt	0.00	RB-14-00	2024-12-09	0	381
311	BUT FOR	BUTELKA ZWR FORTUNA 0,5 L	\N	777	szt	0.00	RB-08-03	2024-12-09	0	777
312	BUT SVI	BUTELKA ZWR SVIJANY 0,5 L	\N	505	szt	0.00	RA-02-02	2024-12-09	0	505
313	BUT ZWR RAC	BUTELKA ZWROTNA RACIBÓRZ 0,5 L	\N	1967	szt	0.00	AT-10	2024-12-09	0	1967
314	PBB Cop	Ca' del Brado / PINTA Barrel Brewing Copernicana 8,5° but. 0,375 l	\N	8	szt	0.00	AT-26-03	2024-12-09	0	8
315	CDB ANN 2020	CA' DEL BRADO ANNIVERSARIO 2020 BUT. 0,375 L	5123456790119	7	szt	0.50	AT-26-03	2024-12-09	0	7
316	CDB ANN 2021	CA' DEL BRADO ANNIVERSARIO 2021 BUT. 0,375 L	5123456790123	2	szt	0.50	AT-26-03	2024-12-09	0	2
317	CDB_CUV_KIW_BUT_375	CA' DEL BRADO CUVÉE DE KIWI - KIWI SOUR ALE BUT. 0,375 L	\N	7	szt	0.50	AT-26-03	2024-12-09	0	7
318	CDB_CUV_PES_BUT_375	CA' DEL BRADO CUVÉE DE PESGA - PEACH SOUR ALE BUT. 0,375 L	\N	2	szt	0.50	AT-26-03	2024-12-09	0	2
319	CDB_NES_DOR_BUT_375	CA' DEL BRADO NESSUN DORMA - SOUR ALE BUT. 0,375 L	\N	17	szt	0.50	RB-11-01	2024-12-09	0	17
320	CDB_PIA_VEL_LAM_BUT_375	CA' DEL BRADO PIE VELOCE BRUX CASCADE - BRETT ALE BUT. 0,375 L	\N	4	szt	0.50	AT-26-03	2024-12-09	0	4
321	CDB_U_BACCABIA_BUT_375	CA' DEL BRADO U BACCABIANCA - ITALIAN GRAPE ALE BUT. 0,375 L	\N	6	szt	0.50	AT-26-03	2024-12-09	0	6
322	CDB_U_BACCAROS_BUT_375	CA' DEL BRADO U BACCAROSSA - ITALIAN GRAPE ALE BUT. 0,375 L	5123456790120	10	szt	0.50	AT-26-03	2024-12-09	0	10
323	CDB_ZEN_BUT_375	CA' DEL BRADO ZENA - WILD GOSE BUT. 0,375 L	\N	3	szt	0.50	AT-26-03	2024-12-09	0	3
324	CDB_CUV_ZRI_BUT_375	CA`DEL BRADO CUVEE DE ZRISA - CHERRY SOUR ALE BUT. 0,375 L	5123456790123	2	szt	0.50	AT-26-03	2024-12-09	0	2
325	KAT06332	CANTILLON CUVEE SAINT-GILLOISE 2021 BUT. 0,75 L	5123456790012	26	szt	1.10	RB-12-01	2024-12-09	0	26
326	CANT GRA CRU BRU 2022	CANTILLON GRAND CRU BRUOCSELLA LAMBIC BIO 2022 BUT. 0,75 L	\N	31	szt	1.10	RB-12-01	2024-12-09	0	31
327	CANT GUE 2022 375	CANTILLON GUEUZE LAMBIC-BIO 2022 BUT. 0,375 L	5411024000047	41	szt	0.50	RB-12-01	2024-12-09	0	41
328	KAT05712	CANTILLON GUEUZE-LAMBIC BIO 2022 BUT. 0,75L	5123456788010	39	szt	0.00	RB-12-01	2024-12-09	0	39
329	KAT04137	CANTILLON GUEUZE-LAMBIC KEG 20L	5123456789011	8	szt	0.00	AT-26-04	2024-12-09	0	8
330	CANT KRI LAM K 20	CANTILLON KRIEK-LAMBIC  KEG 20L	5123456789013	2	szt	0.00	AT-26-04	2024-12-09	0	2
331	CANT KRI LAM BIO 2022 375	CANTILLON KRIEK-LAMBIC BIO 2022 BUT. 0,375 L	5411024000054	80	szt	0.50	RB-12-01	2024-12-09	0	80
332	CANT KRI LAM BIO 2022 750	CANTILLON KRIEK-LAMBIC BIO 2022 BUT. 0,75 L	5411024000023	40	szt	1.10	RB-13-01	2024-12-09	0	40
333	CANT LAMB K 20	CANTILLON LAMBIC KEG 20L	5123456789018	1	szt	0.00	AT-26-02	2024-12-09	0	1
334	CAN NAT	CANTILLON NATH BUT. 0,75 L	\N	31	szt	1.10	RB-13-01	2024-12-09	0	31
335	CANT ROS 2022 375 ml	CANTILLON ROSE DE GAMBRINUS 2022 BUT. 0,375 L	5123456790017	59	szt	0.50	RB-13-01	2024-12-09	0	59
336	CANT ROS 2022 750	CANTILLON ROSE DE GAMBRINUS 2022 BUT. 0,75 L	5123456790143	22	szt	1.10	RB-13-01	2024-12-09	0	22
337	KAT04135	CANTILLON ROSÉ DE GAMBRINUS KEG 20 L	5123456789010	1	szt	21.50	AT-26-04	2024-12-09	0	1
338	KAT04569	CANTILLON SAINT LAMVINUS KEG 20 L	5123456789014	2	szt	21.50	AT-26-04	2024-12-09	0	2
339	CAN SAI LAM	CANTILLON SAINT-LAMVINUS 2021 BUT.  0,75 L	5123456790018	83	szt	0.00	RB-13-01	2024-12-09	0	83
340	KAT07435	CANTILLON SANG BLEU 2022 BUT. 0,75 L	5123456790019	127	szt	1.10	RB-10-00	2024-12-09	0	127
341	KAT07437	CANTILLON SANG BLEU KEG 20L	5123456789021	2	szt	0.00	AT-26-04	2024-12-09	0	2
342	CHER CHOUF 330	CHERRY CHOUFFE BUT. 0,33 L	5410769800097	4	szt	0.50	AT-26-04	2024-12-09	0	4
343	CHIM 150 CINQ 330	CHIMAY 150 / SPÉCIALE CENT CINQUANTE BUT. 0,33 L	5410908100118	117	szt	0.50	RA-19-00	2024-12-09	0	117
344	CHIM 150 CINQ 750	CHIMAY 150 / SPÉCIALE CENT CINQUANTE BUT. 0,75 L	5410908100149	89	szt	1.10	RB-14-01	2024-12-09	0	89
345	CHIM BLE BAR 375	CHIMAY BLUE BARRIQUE BUT. 0,375 L	5410908002337	11	szt	0.50	RB-13-01	2024-12-09	0	11
346	CHIM BLE BAR 750	CHIMAY BLUE BARRIQUE BUT. 0,75 L	5410908002344	79	szt	1.10	RB-14-01	2024-12-09	0	79
347	CHIM BLU 330	CHIMAY BLUE BUT. 0,33 L	5410908000036	369	szt	0.50	RB-15-00	2024-12-09	0	369
348	CHIM BLU 750	CHIMAY BLUE BUT. 0,75 L	5410908000074	232	szt	1.10	RB-13-00	2024-12-09	0	232
349	CHIM GOL 330	CHIMAY GOLD BUT. 0,33 L	5410908000128	196	szt	0.50	RB-16-00	2024-12-09	0	196
350	CHIM GOL 750	CHIMAY GOLD BUT. 0,75 L	5410908000425	156	szt	1.10	RB-14-00	2024-12-09	0	156
351	CHI GOL KEG	CHIMAY GOLD KEG 20 L	5410908000166	2	szt	21.50	AT-26-04	2024-12-09	0	2
352	160	CHIMAY KIELICH 0,33 L	5123456791189	478	szt	0.00	RB-17-00	2024-12-09	0	478
357	CHIM RED 1,5	CHIMAY RED BUT. 1,5 L	5410908500048	2	szt	0.00	AT-26-04	2024-12-09	0	2
358	CHIM RED KEG 20	CHIMAY RED KEG 20 L	5410908002016	3	szt	21.50	AT-26-04	2024-12-09	0	3
359	CHIM TRI 330	CHIMAY TRIPLE BUT. 0,33 L	5410908000029	157	szt	0.50	RB-15-00	2024-12-09	0	157
360	CHIM TRI 750	CHIMAY TRIPLE BUT. 0,75 L	5410908000135	73	szt	1.10	RB-15-01	2024-12-09	0	73
361	CHIM TRI KEG 20	CHIMAY TRIPLE KEG 20 L	5123456789004	1	szt	21.50	AT-26-04	2024-12-09	0	1
362	CH_CYD_ALW_BUT_750	CHYLICZKI CYDR ALWA BUT. 0,75 L	5905279058262	59	szt	1.10	RB-15-01	2024-12-09	0	59
363	CH_CYD_ALW_KEG_30	CHYLICZKI CYDR ALWA KEG 30 L	\N	2	szt	32.00	AT-26-04	2024-12-09	0	2
364	CHYL ANT 500	CHYLICZKI CYDR ANTONÓWKA BUT. 0,5 L	5905279058101	147	szt	0.77	RB-16-00	2024-12-09	0	147
365	CHYL ANT K	CHYLICZKI CYDR ANTONÓWKA KEG 30 L	5123456789026	2	szt	32.00	AT-26-04	2024-12-09	0	2
366	CHYL CHOP 750	CHYLICZKI CYDR CHOPIN BUT. 0,75 L	5905279058200	69	szt	1.10	RB-15-01	2024-12-09	0	69
367	CHYL CZA 500	CHYLICZKI CYDR CZARNY SAD BUT. 0,5 L	5905279058194	134	szt	0.77	RB-16-00	2024-12-09	0	134
368	CHY_IMB_SAD_BUT_330	CHYLICZKI CYDR IMBIROWY SAD BUT. 0,33 L	5905279058323	105	szt	0.50	RA-17-00	2024-12-09	0	105
369	CHYL JAP SAD 500	CHYLICZKI CYDR JAPOŃSKI SAD BUT. 0,5 L	5905279058224	139	szt	0.77	RB-18-00	2024-12-09	0	139
370	CHYL JAP SAD K	CHYLICZKI CYDR JAPOŃSKI SAD KEG 30 L	5123456789029	6	szt	32.00	AT-26-04	2024-12-09	0	6
371	CHYL LOD 375	CHYLICZKI CYDR LODOWY BUT. 0,375 L	5905279058040	37	szt	0.50	RB-14-01	2024-12-09	0	37
372	CHYL LOD K 15	CHYLICZKI CYDR LODOWY KEG 15 L	5123456789031	1	szt	0.00	AT-26-04	2024-12-09	0	1
373	CHYL ROS 750	CHYLICZKI CYDR ROSE 2021 BUT. 0,75 L	5905279058187	37	szt	1.10	RB-16-01	2024-12-09	0	37
374	CHY_STA_2022_BUT_330	CHYLICZKI CYDR STARY SAD 2022 BUT. 0,33 L	5905279058033	49	szt	0.50	RB-16-01	2024-12-09	0	49
375	CHYL STA EDY LIM 750	CHYLICZKI CYDR STARY SAD EDYCJA LIMITOWANA BUT. 0,75 L	5905279058279	25	szt	1.10	RB-16-01	2024-12-09	0	25
376	CHYL STA SAD K	CHYLICZKI CYDR STARY SAD KEG 30 L	5123456789033	4	szt	32.00	AT-26-04	2024-12-09	0	4
377	CHYL SWE OAK 500	CHYLICZKI CYDR SWEET OAK 2018 BUT. 0,5 L	5905279058217	85	szt	0.77	RB-16-01	2024-12-09	0	85
378	CHYL SWE OAK 2019 500	CHYLICZKI CYDR SWEET OAK 2019 BUT. 0,5 L	5123456790090	64	szt	0.77	RB-16-01	2024-12-09	0	64
379	CHYL SZA ZŁO 750	CHYLICZKI CYDR SZARA & ZŁOTA RENETA 2021 BUT. 0,75 L	5905279058057	35	szt	1.10	RB-16-01	2024-12-09	0	35
380	CHY_SZA|_ZŁO_BUT_330	CHYLICZKI CYDR SZARA & ZŁOTA RENETA BUT. 0,33 L	5905279058316	116	szt	0.50	RB-12-00	2024-12-09	0	116
381	CHYL SZA ZŁO K	CHYLICZKI CYDR SZARA & ZŁOTA RENETA KEG 30 L	5123456789034	2	szt	32.00	AT-26-04	2024-12-09	0	2
382	CHYL CHO K	CHYLICZKI CYDR Z ODMIANY CHOPIN KEG 30 L	5123456789027	4	szt	32.00	AT-26-04	2024-12-09	0	4
383	CHYL GRA 1	CHYLICZKI GRAFF NO. 1 BUT. 0,5 L	5905279058231	4	szt	0.77	AT-26-04	2024-12-09	0	4
384	CHYL GRA 2	CHYLICZKI GRAFF NO. 2 BUT. 0,5 L	5905279058255	108	szt	0.77	RB-07-00	2024-12-09	0	108
385	CHY_GRA_NO2_KEG_30	CHYLICZKI GRAFF NO. 2 KEG 30 L	\N	1	szt	32.00	AT-26-04	2024-12-09	0	1
386	CHYL PER 750	CHYLICZKI PERRY 2021 BUT. 0,75 L	5905279058170	25	szt	1.10	RB-17-01	2024-12-09	0	25
387	CH_PER_LOD_GRU_2021_BUT_500	CHYLICZKI PERRY LODOWA GRUSZKA 2021 BUT. 0,5 L	5905279058286	45	szt	0.77	RB-17-01	2024-12-09	0	45
388	CID_INN_PÓŁW_BUT_330	CIDER INN GŁĘBSZY SMAK PÓŁWYTRAWNY 4,5%  BUT.0,33 L	5900468000077	16	szt	0.00	RB-14-01	2024-12-09	0	16
389	CID_INN_WYTR_BUT_330	CIDER INN GŁĘBSZY SMAK WYTRAWNY 4,4 %  BUT. 0,33 L	5900468000138	15	szt	0.50	RB-17-01	2024-12-09	0	15
390	CIE ANG LOR	CIESZYN ANGIELSKI LORD BUT. 0,33 L	5907612240198	33	szt	0.50	RB-17-01	2024-12-09	0	33
391	CIE BAR WIŚ	CIESZYN BARLEY WINE Z WIŚNIAMI B.A. BUT. 0,33 L	5907612240723	21	szt	0.50	RB-17-01	2024-12-09	0	21
392	CIE BEZ LAG	CIESZYN BEZALKOHOLOWY LAGER BUT. 0,5 L	5905279156814	95	szt	0.77	RB-17-01	2024-12-09	0	95
393	CIE DOU IPA	CIESZYN DOUBLE IPA BUT. 0,5 L	5905279156067	290	szt	0.77	RB-18-00	2024-12-09	0	290
394	CIE HIG	CIESZYN HIGHLANDER BUT. 0,33 L	5905279156296	6	szt	0.50	AT-26-04	2024-12-09	0	6
395	CIE_KART_A4	CIESZYN KARTONIK A4	5123456791385	20	szt	0.00	RB-18-01	2024-12-09	0	20
396	CIE LAG	CIESZYN LAGER BUT. 0,5 L	5905279156005	233	szt	0.77	RB-19-00	2024-12-09	0	233
397	CIE NOS	CIESZYN NOSZAK BUT. 0,5 L	5905279156852	9	szt	0.77	AT-26-04	2024-12-09	0	9
398	CIE NOS K	CIESZYN NOSZAK KEG 30 L	5123456789079	4	szt	32.00	AT-27-00	2024-12-09	0	4
399	CIE_PIL_BUT_500	CIESZYN PILSNER BUT. 0,5 L	5907612240860	325	szt	0.77	RC-01-00	2024-12-09	0	325
400	CIE_PIL_KEG_30	CIESZYN PILSNER KEG 30 L	\N	17	szt	32.00	RB-18-01	2024-12-09	0	17
401	CIE POK 0,3	CIESZYN POKAL 0,3 L	5123456791332	2	szt	0.00	AT-26-04	2024-12-09	0	2
402	CIE POR BA	CIESZYN PORTER BAŁTYCKI BARREL AGED BUT. 0,33 L	5905279156531	43	szt	0.50	RB-18-01	2024-12-09	0	43
403	CIE POR	CIESZYN PORTER BAŁTYCKI BUT. 0,5 L	5905279156104	213	szt	0.77	RB-19-00	2024-12-09	0	213
404	CIE PSZ	CIESZYN PSZENICZNE BUT. 0,5 L	5905279156043	203	szt	0.77	RC-01-00	2024-12-09	0	203
405	CIE RAU GB	CIESZYN RAUCHBOCK - GRAND CHAMPION 2022 BUT. 0,33 L	5907612240822	2	szt	0.50	AT-27-00	2024-12-09	0	2
406	CIE RYE	CIESZYN RYE WINE BUT. 0,33 L	5907612240235	58	szt	0.50	RB-18-01	2024-12-09	0	58
407	CIE SOU BAR BA	CIESZYN SOUR BARLEY WINE BARREL AGED BUT. 0,33 L	5905279156579	27	szt	0.50	RB-18-01	2024-12-09	0	27
408	CIE SZKL	CIESZYN SZKLANKA 0,5 L	5123456789850	139	szt	0.00	RC-02-00	2024-12-09	0	139
409	CIE SZK SHA	CIESZYN SZKLANKA SHAKER 0,5 L	5123456789849	91	szt	0.00	RB-18-01	2024-12-09	0	91
410	CIE SZK WEI 0,5	CIESZYN SZKLANKA WEIZEN 0,5 L	5123456789851	18	szt	0.00	RB-19-01	2024-12-09	0	18
411	CIE WHE WIN	CIESZYN WHEAT WINE BUT. 0,33 L	5907612240341	44	szt	0.50	RB-19-01	2024-12-09	0	44
412	CIE WIL	CIESZYN WILD ALE B.A. BUT. 0,33 L	5907612240747	37	szt	0.50	RB-19-01	2024-12-09	0	37
413	CIGAR FAI	CIGAR CITY FAIR EXCHANGE PUSZKA 0,355 L	850005189756	6	szt	0.00	AT-27-00	2024-12-09	0	6
414	CIN BLO 250	CINEY BLOND BUT.0,25 L	54055308	68	szt	0.00	RB-19-01	2024-12-09	0	68
415	CIN BRU 250	CINEY BRUIN BUT. 0,25 L	54055315	13	szt	0.35	RB-19-01	2024-12-09	0	13
416	CORO STU	CORONADO STUPID STOUT BUT. 0,65 L	896311000019	5	szt	0.00	AT-27-00	2024-12-09	0	5
417	COR AGN 750	CORSENDONK AGNUS BUT. 0,75 L	5411491011164	20	szt	1.10	RB-19-01	2024-12-09	0	20
418	COR AGN TRI 330	CORSENDONK AGNUS TRIPLE BUT. 0,33 L	54069022	87	szt	0.50	RC-01-01	2024-12-09	0	87
419	COR PAT 750	CORSENDONK PATER BUT. 0,75 L	5411491011157	102	szt	1.10	RA-07-00	2024-12-09	0	102
420	COR PAT DOU 330	CORSENDONK PATER DOUBLE BUT. 0,33 L	54069015	49	szt	0.50	RC-01-01	2024-12-09	0	49
421	COR ZEST 2X330 SZK	CORSENDONK ZESTAW  (2 X BUT. 0,33 L + SZKŁO)	5411491001899	1	szt	0.00	AT-26-04	2024-12-09	0	1
422	OMB Cro L Bre Blu	CROOKED STAVE L`BRETT D`BLUEBERRY 2016 BUT. 0,75L	854512003932	3	szt	0.00	AT-27-00	2024-12-09	0	3
423	CROO ORI	CROOKED STAVE ORIGINS BUT. 0,75 L	854512003185	11	szt	1.10	RC-01-01	2024-12-09	0	11
424	CUVE TROL 250	CUVEE DES TROLLS BUT. 0,25 L	5411551141091	62	szt	0.35	RC-01-01	2024-12-09	0	62
425	CUVE TROL K 30 L	CUVEE DES TROLLS KEG 30 L	5123456789002	2	szt	32.00	AT-27-00	2024-12-09	0	2
426	CUVE TROL K 5 L	CUVEE DES TROLLS KEG 5 L	5411551010205	3	szt	0.00	AT-27-00	2024-12-09	0	3
427	CUVE TROL TRIP 750	CUVEE DES TROLLS TRIPLE BUT. 0,75 L	5411551210513	3	szt	1.10	AT-27-00	2024-12-09	0	3
428	CYR_BRAM_CZOS_100	CYRILOVY BRAMBURKY CZOSNKOWE - CHIPSY 100 G	8594021041071	130	szt	0.00	RC-02-00	2024-12-09	0	130
429	CYR_BRAM_MUSZ_100	CYRILOVY BRAMBURKY MUSZTARDOWE - CHIPSY 100 G	8594021041088	177	szt	0.00	RC-02-00	2024-12-09	0	177
430	CYR_BRAM_SOL_100	CYRILOVY BRAMBURKY SOLONE - CHIPSY 100 G	8594021041064	150	szt	0.00	RC-03-00	2024-12-09	0	150
431	4SC_BEN_PUSZ_500	CZTERY ŚCIANY BENEFIS PUSZKA 0,5 L	5905108498832	5	szt	0.54	AT-27-00	2024-12-09	0	5
432	4SC_ILU_PUSZ_500	CZTERY ŚCIANY ILUZJA PUSZKA 0,5 L	5905108498870	134	szt	0.54	RC-03-00	2024-12-09	0	134
433	4SC KAM	CZTERY ŚCIANY KAMPER BUT. 0,5 L	5906874341117	120	szt	0.77	RC-03-00	2024-12-09	0	120
434	4SC KAM P	CZTERY ŚCIANY KAMPER PUSZKA 0,5 L	5906874341674	175	szt	0.54	RC-04-00	2024-12-09	0	175
435	4SC_LUS_PUSZ_500	CZTERY ŚCIANY LUSTRO PUSZKA 0,5 L	5905108498801	5	szt	0.54	AT-27-00	2024-12-09	0	5
436	4SC MUR	CZTERY ŚCIANY MURAWA PUSZKA 0,5 L	5905108498221	1	szt	0.54	AT-27-00	2024-12-09	0	1
437	4SC PAL	CZTERY ŚCIANY PALMA PUSZKA 0,5 L	5906874341933	35	szt	0.54	RC-01-01	2024-12-09	0	35
438	4SC_POL_BUT_500	CZTERY ŚCIANY POLANA BUT. 0,5 L	5905108498139	34	szt	0.77	RC-01-01	2024-12-09	0	34
439	4SC_REW_BUT_500	CZTERY ŚCIANY REWIR BUT. 0,5 L	5905108498856	110	szt	0.77	RB-18-00	2024-12-09	0	110
440	4SC_REW_PUSZ_500	CZTERY ŚCIANY REWIR PUSZKA 0,5 L	5905108498849	12	szt	0.54	RC-02-01	2024-12-09	0	12
441	4SC_ROS_PUSZ_500	CZTERY ŚCIANY ROSA PUSZKA 0,5 L	5906874341988	44	szt	0.54	RC-02-01	2024-12-09	0	44
442	4SC_TRO_DOUB_PUSZ_500	CZTERY ŚCIANY TROPIK DOUBLE PUSZKA 0,5 L	5906874341780	12	szt	0.54	RC-02-01	2024-12-09	0	12
443	DAL_PIN_IND-BUT_330	Dalons / PINTA Indian Baltic Porter 20,0° but. 0,33 l	3770012486549	14	szt	0.00	RC-02-01	2024-12-09	0	14
444	DE CAM TRO	DE CAM TROSBESSEN BUT. 0,75 L	5425021680133	2	szt	1.10	AT-27-00	2024-12-09	0	2
445	219	DE KONINCK TRIPLE D`ANVERS BUT. 0,33 L	54107090	19	szt	0.50	RC-02-01	2024-12-09	0	19
446	DE LA SEN BLU L	DE LA SENNE BLUZA L	5123456791363	1	szt	0.00	AT-27-00	2024-12-09	0	1
447	DE LA SEN JAM DE BOI TSH M	DE LA SENNE JAMBE DE BOIS T-SHIRT M	5123456791364	1	szt	0.00	AT-27-00	2024-12-09	0	1
448	KAT05147	DE LA SENNE POKAL 0,33 L	5123456791098	98	szt	0.00	RC-02-01	2024-12-09	0	98
449	DE LA SEN SAIS 330	DE LA SENNE SAISON BUT. 0,33 L	5425029020832	70	szt	0.50	RC-03-01	2024-12-09	0	70
450	KAT06609	DE MOLEN BLACHA REKLAMOWA	5123456791209	3	szt	0.00	AT-27-00	2024-12-09	0	3
451	DE MOLEN DAG	DE MOLEN DAG & DAUW BUT. 0,33 L	8717624423215	92	szt	0.50	RC-03-01	2024-12-09	0	92
452	DE_MOLEN_FRU_KRU_BUT_330	DE MOLEN FRUIT & KRUID BUT. 0,33 L	8717624420412	108	szt	0.50	RC-03-00	2024-12-09	0	108
453	KAT06270	DE MOLEN HAMER & SIKKEL BUT. 0,33 L	8717624421228	73	szt	0.50	RC-03-01	2024-12-09	0	73
454	DE_MOLEN_HEE_WEE_BUT_330	DE MOLEN HEEN & WEER BUT. 0,33 L	8717624421242	70	szt	0.50	RC-04-01	2024-12-09	0	70
455	KAT06269	DE MOLEN OP & TOP BUT. 0,33 L	8717624421020	74	szt	0.50	RC-04-01	2024-12-09	0	74
456	KAT06284	DE MOLEN POKAL 0,330 L	5123456791096	3	szt	0.00	AT-27-00	2024-12-09	0	3
457	KAT06267	DE MOLEN VUUR & VLAM BUT. 0,33 L	8717624421037	82	szt	0.50	RC-04-01	2024-12-09	0	82
458	DE_MOLEN_WAT_VUU_BUT_330	DE MOLEN WATER & VUUR BUT. 0,33 L	8717624422409	88	szt	0.50	RC-05-01	2024-12-09	0	88
459	DE STRU DAR HORS 750	DE STRUISE DARK HORSE SOUR ALE BUT. 0,75 L	5425017002758	20	szt	1.10	RC-03-01	2024-12-09	0	20
460	DE_COL_CAT_KEG_30	DEER BEAR COLD CAT KEG 30 L	\N	1	szt	32.00	AT-27-00	2024-12-09	0	1
461	DE_COL_CAT_PUSZ_500	DEER BEAR COLD CAT PUSZKA 0,5 L	5905204172186	63	szt	0.54	RC-04-01	2024-12-09	0	63
462	DEER DEE	DEER BEAR DEER BEARD BUT. 0,5 L	5906395303335	23	szt	0.77	RC-03-01	2024-12-09	0	23
463	DE_FLOR_KEG_30	DEER BEAR FLORAL KEG 30 L	\N	1	szt	32.00	AT-27-00	2024-12-09	0	1
464	DE_FLOR_PUSZ_500	DEER BEAR FLORAL PUSZKA 0,5 L	5905204172179	43	szt	0.54	RC-05-01	2024-12-09	0	43
465	DEER KAM K 30	DEER BEAR KAME HAME KEG 30 L	5123456789116	2	szt	32.00	AT-27-00	2024-12-09	0	2
466	DE_KOMP_2_PUSZ_500	DEER BEAR KOMPOT #2 PUSZKA 0,5 L	5905204172162	59	szt	0.54	RC-05-01	2024-12-09	0	59
467	DE_LET_GUA_PUSZ_500	DEER BEAR LET'S COOK - GUAVA PUSZKA 0,5 L	5905204172193	230	szt	0.54	RC-04-00	2024-12-09	0	230
468	DE_LET-APR-LIM_PUSZ_500	DEER BEAR LET'S COOK APRICOT-LIME PUSZKA 0,5 L	5906395303069	82	szt	0.54	RC-05-01	2024-12-09	0	82
469	DEER LET SOU_PROM	DEER BEAR LET'S COOK SOUR APA BUT. 0,5 L PROMOCJA (do 05.10.23)	\N	9	szt	0.00	AT-27-00	2024-12-09	0	9
470	DEER RAM SHO	DEER BEAR RAMEN SHOP BUT. 0,5 L	5903678460013	15	szt	0.77	RC-03-01	2024-12-09	0	15
471	DE_SCO_PUSZ_500	DEER BEAR SCOUT PUSZKA 0,5 L	5905204172155	47	szt	0.54	RC-06-01	2024-12-09	0	47
472	DEE_BEA_SZKL_SHA	DEER BEAR SZKLANKA SHAKER 0,5 L	5123456791452	7	szt	0.00	AT-27-00	2024-12-09	0	7
473	DEER TOY	DEER BEAR TOY BOY PUSZKA 0,5 L	5903678460563	230	szt	0.54	RC-05-00	2024-12-09	0	230
474	DE_YAM_PUSZ_500	DEER BEAR YAM YAM PUSZKA 0,5 L	5905204172148	35	szt	0.54	RC-06-01	2024-12-09	0	35
475	DEL ARG 330	DELIRIUM ARGENTUM BUT. 0,33 L	5412186003594	189	szt	0.50	RC-05-00	2024-12-09	0	189
476	DEL ARG 750	DELIRIUM ARGENTUM BUT. 0,75 L	5412186003600	10	szt	1.10	AT-27-00	2024-12-09	0	10
477	DEL NOC 330	DELIRIUM NOCTURNUM BUT. 0,33 L	5412186000715	248	szt	0.50	RC-06-00	2024-12-09	0	248
478	DEL NOC 750	DELIRIUM NOCTURNUM BUT. 0,75 L	5412186000722	40	szt	1.10	RC-06-01	2024-12-09	0	40
479	DEL NOE 750	DELIRIUM NOËL BUT. 0,75 L	5412186000975	31	szt	1.10	RC-06-01	2024-12-09	0	31
480	DEL RED 330	DELIRIUM RED BUT. 0,33 L	5412186002436	39	szt	0.50	RC-06-01	2024-12-09	0	39
481	DEL RED 750	DELIRIUM RED BUT. 0,75 L	5412186003495	17	szt	1.10	RC-05-01	2024-12-09	0	17
482	DEL RED KG 30 L	DELIRIUM RED KEG 30 L	\N	1	szt	32.00	AT-27-00	2024-12-09	0	1
483	DEL TREM 750	DELIRIUM TREMENS BUT. 0,75 L	5412186000043	88	szt	1.10	RC-06-01	2024-12-09	0	88
484	DEL TRE K 30	DELIRIUM TREMENS KEG 30 L	5123456789027	1	szt	32.00	AT-27-01	2024-12-09	0	1
485	DRAK DRA	DRAKES DRAKONIC BUT. 0,65 L	854957002071	3	szt	0.00	AT-27-01	2024-12-09	0	3
486	DRY BIT CZA ZIM BOR	DRY & BITTER CZAPKA ZIMOWA BORDOWA	5123456791381	1	szt	0.00	AT-27-01	2024-12-09	0	1
487	DRY BIT CZA ZIM ZIE	DRY & BITTER CZAPKA ZIMOWA ZIELONA	5123456791356	2	szt	0.00	AT-27-01	2024-12-09	0	2
488	DRY BIT BLA REK	DRY& BITTER BLACHA REKLAMOWA	5123456791365	1	szt	0.00	AT-27-01	2024-12-09	0	1
489	DU BOC BLA DE NAM 330	DU BOCQ BLANCHE DE NAMUR BUT. 0,33 L	5411633330054	73	szt	0.50	RC-07-01	2024-12-09	0	73
490	DU BOC BLA DE NAM  750	DU BOCQ BLANCHE DE NAMUR BUT. 0,75 L	5411633750050	39	szt	1.10	RC-07-01	2024-12-09	0	39
491	DU_BOC _BLA_DE _NAM _ROS_K_20	DU BOCQ BLANCHE DE NAMUR ROSEE KEG 20 L	\N	1	szt	21.50	AT-27-01	2024-12-09	0	1
492	DU BOC BLA DE NAM SZKL 250	DU BOCQ BLANCHE DE NAMUR SZKLANKA 0,25 L NOWA	5123456791052	13	szt	0.00	RC-07-01	2024-12-09	0	13
493	DU BOC BLA DE NAM SZKL 330	DU BOCQ BLANCHE DE NAMUR SZKLANKA 0,33 L	5123456791051	88	szt	0.00	RC-07-01	2024-12-09	0	88
494	DU BOC BLA DE NAM T-SH	DU BOCQ BLANCHE DE NAMUR T-SHIRT	5123456791022	1	szt	0.00	AT-27-01	2024-12-09	0	1
495	DU BOC ZEST 3X330 + SZK	DU BOCQ BLANCHE DE NAMUR ZESTAW (3 X BUT. 0,33 L + SZKŁO)	5411633333017	4	szt	0.00	AT-27-01	2024-12-09	0	4
496	DUB BUS AMB 750	DUBUISSON BUSH AMBER CARACTERE BUT. 0,75 L	5411551260723	31	szt	1.10	RC-07-01	2024-12-09	0	31
497	DUB BUS BLO 330	DUBUISSON BUSH BLONDE TRIPLE BUT. 0,33 L	5411551310817	54	szt	0.50	RC-07-01	2024-12-09	0	54
498	DUB BUS BLO 750	DUBUISSON BUSH BLONDE TRIPLE BUT. 0,75 L	5411551270722	28	szt	1.10	RC-08-01	2024-12-09	0	28
499	DUB BUS NOE 330	DUBUISSON BUSH DE NOËL BUT. 0,33 L	5411551320809	44	szt	0.50	RC-08-01	2024-12-09	0	44
500	DUB BUS PRES 750	DUBUISSON BUSH PRESTIGE BUT. 0,75 L	5411551677880	18	szt	1.10	RC-08-01	2024-12-09	0	18
501	DUB BUS ZEST 2X330 + 2X330 + SZ	DUBUISSON BUSH ZESTAW (2 X CARACTERE BUT. 0,33 L + 2 X TRIPLE BUT. 0,33 L +SZKŁO)	5411551120515	1	szt	0.00	AT-27-01	2024-12-09	0	1
502	DUB PECH BUS 330	DUBUISSON PECHE MEL BUSH BUT. 0,33 L	5411551130392	3	szt	0.50	AT-27-01	2024-12-09	0	3
503	DUB BUS RAST 330	DUBUISSON RASTA TROLLS BUT. 0,33 L	5411551171074	36	szt	0.50	RC-08-01	2024-12-09	0	36
504	DUCH BOURG 750	DUCHESSE DE BOURGOGNE BUT. 0,75 L	5411364151300	17	szt	1.10	RC-08-01	2024-12-09	0	17
505	OMB Duc Dar	DUCKPOND DARKWING PUSZKA 0,33 L	7350015140219	1	szt	0.35	AT-27-01	2024-12-09	0	1
506	DUGG_9+9_SOU_PUSZ_500	DUGGES 9+9 SOUR PUSZKA 0,5 L	7350038227706	20	szt	0.54	RC-08-01	2024-12-09	0	20
507	DUGG_ASTE_PUSZ_500	DUGGES ASTEROID PUSZKA 0,5 L	7350038227355	8	szt	0.54	AT-27-01	2024-12-09	0	8
508	DUGG_BIG_BLA_APP_PUSZ_500	DUGGES BIG BLACK APPLE PUSZKA 0,5 L	7350038226372	15	szt	0.54	RC-09-01	2024-12-09	0	15
509	DUGG_BIG_BLA_VIO_PUSZ_500	DUGGES BIG BLACK VIOLET PUSZKA 0,5 L	7350038226402	20	szt	0.54	RC-09-01	2024-12-09	0	20
510	DUGG_BIG_LIT_PUSZ_500	DUGGES BIG LITTLE FIVE PUSZKA 0,5 L	7350038226143	23	szt	0.54	RC-09-01	2024-12-09	0	23
511	DUGG_BLA_CUR_ORG_PUSZ_330	DUGGES BLACK CURRANT ORGANIC PUSZKA 0,33 L	7350038223562	64	szt	0.35	RC-09-01	2024-12-09	0	64
512	DUGG_BLOO_PUSZ_330	DUGGES BLOOM PUSZKA 0,33 L	7350038225948	19	szt	0.35	RC-09-01	2024-12-09	0	19
513	DUGG_BOU_SAFF_BUT_330	DUGGES BOURBON SAFFRON BUT. 0,33 L	7350038226501	6	szt	0.50	AT-27-01	2024-12-09	0	6
514	DUGG_CIN_PUSZ_330	DUGGES CINNA PUSZKA 0,33 L	7350038225924	22	szt	0.35	RC-09-01	2024-12-09	0	22
515	DUGG_COL_PUSZ_330	DUGGES COLA PUSZKA 0,33 L	7350038224774	38	szt	0.35	RC-10-01	2024-12-09	0	38
516	DUGG_DAY_PUSZ_330	DUGGES DAYDREAM PUSZKA 0,33 L	7350038228390	19	szt	0.35	RC-10-01	2024-12-09	0	19
355	CHIM RED 330	CHIMAY RED BUT. 0,33 L	5410908000012	63	szt	0.50	RB-14-01	2024-12-09	0	63
517	DUGG_DOU_RAIN_PUSZ_500	DUGGES DOUBLE RAINBOW PUSZKA 0,5 L	7350038227959	9	szt	0.54	AT-27-01	2024-12-09	0	9
518	DUGG_ELEC_PUSZ_330	DUGGES ELECTRO PUSZKA 0,33 L	7350038226297	4	szt	0.35	AT-27-01	2024-12-09	0	4
519	DUGG_FIR_PUSZ_330	DUGGES FIRE PUSZKA 0,33 L	7350038225900	13	szt	0.35	RC-10-01	2024-12-09	0	13
520	DUGG_HEA_PUSZ_330	DUGGES HEAT PUSZKA 0,33 L	7350038225887	23	szt	0.35	RC-10-01	2024-12-09	0	23
521	DUGG_HYB_02_BUT_330	DUGGES HYBRID 02 BUT. 0,33 L	7350038223722	47	szt	0.50	RC-10-01	2024-12-09	0	47
522	DUGG_JUI_FRU_PUSZ_500	DUGGES JUICY FRUITY PUSZKA 0,5 L	7350038227607	37	szt	0.54	RC-10-01	2024-12-09	0	37
523	DUGG_LUX_PUSZ_500	DUGGES LUXURY PUSZKA 0,5 L	7350038226839	1	szt	0.54	AT-27-01	2024-12-09	0	1
524	DUGG_MAN_MAN_PUSZ_330	DUGGES MANGO MANGO MANGO PUSZKA 0,33 L	7350038224897	24	szt	0.35	RC-11-01	2024-12-09	0	24
525	DUGG_MAN_MIN_PUSZ_330	DUGGES MANGO MANGO MINI PUSZKA 0,33 L	7350038226525	48	szt	0.35	RC-11-01	2024-12-09	0	48
526	DUGG_MAN_SHA_PUSZ_330	DUGGES MANGO SHAKE PUSZKA 0,33 L	7350038227492	19	szt	0.35	RC-11-01	2024-12-09	0	19
527	DUGG_PAR_PUSZ_330	DUGGES PARADISI PUSZKA 0,33 L	7350038227171	13	szt	0.35	RC-11-01	2024-12-09	0	13
528	DUGG_POPS_PUSZ_330	DUGGES POPSICLE PUSZKA 0,33 L	7350038226167	13	szt	0.35	RC-11-01	2024-12-09	0	13
529	DUGG_RAINB_PUSZ_330	DUGGES RAINBOW PUSZKA 0,33 L	7350038226778	22	szt	0.35	RC-11-01	2024-12-09	0	22
530	DUGG_SEB_PUSZ_500	DUGGES SEBASTIAN PUSZKA 0,5 L	7350038227232	21	szt	0.54	RC-12-01	2024-12-09	0	21
531	DUGG_SUPE_PUSZ_330	DUGGES SUPERIOR PUSZKA 0,33 L	7350038226044	7	szt	0.35	AT-27-01	2024-12-09	0	7
532	DUGG_TRO_SHA_PUSZ_330	DUGGES TROPIC SHAKE PUSZKA 0,33 L	7350038226624	2	szt	0.35	AT-27-01	2024-12-09	0	2
533	DUGG_TRO_THU_PUSZ_330	DUGGES TROPIC THUNDER PUSZKA 0,33 L	7350038224903	35	szt	0.35	RC-12-01	2024-12-09	0	35
534	DUGG_TWI_PUSZ_330	DUGGES TWISTER PUSZKA 0,33 L	7350038224996	23	szt	0.35	RC-12-01	2024-12-09	0	23
535	DUV 6.66 330	DUVEL 6.66 BUT. 0,33 L	5411681408002	712	szt	0.50	RA-02-03	2024-12-09	0	712
536	DUV POD	DUVEL 6.66 PODKŁADKI	5123456789852	400	szt	0.00	RB-07-02	2024-12-09	0	400
537	KAT06709	DUVEL BRELOK DO KLUCZY / OTWIERACZ	5123456791204	2	szt	0.00	AT-27-01	2024-12-09	0	2
538	KAT06154	DUVEL BRELOK DO KLUCZY D (CZERWONY)	5123456791203	1	szt	0.00	AT-27-01	2024-12-09	0	1
539	DUV 330	DUVEL BUT. 0,33 L	5411681014005	255	szt	0.50	RB-07-04	2024-12-09	0	255
540	DUV 750	DUVEL BUT. 0,75 L	5411681402635	369	szt	1.10	RC-07-00	2024-12-09	0	369
541	DUV_CZAP_SZA	DUVEL CZAPKA Z DZASKIEM SZARA	5123456791453	5	szt	0.00	AT-27-01	2024-12-09	0	5
542	KAT06153	DUVEL MATA BAROWA	5123456791202	4	szt	0.00	AT-27-01	2024-12-09	0	4
543	KAT06411	DUVEL NEON	5123456791201	1	szt	0.00	AT-27-01	2024-12-09	0	1
544	KAT06151	DUVEL OTWIERACZ	5123456791200	3	szt	0.00	AT-27-01	2024-12-09	0	3
545	KAT06072	DUVEL OTWIERACZ D	5123456791199	18	szt	0.00	RC-12-01	2024-12-09	0	18
546	294	DUVEL POKAL 0,33 L	5123456791095	151	szt	0.00	RC-06-00	2024-12-09	0	151
547	DUV_POK_3	DUVEL POKAL 3 L	5123456791454	3	szt	0.00	AT-27-01	2024-12-09	0	3
548	KAT06150	DUVEL POKAL 666 0,33 L	5123456791094	47	szt	0.00	RC-12-01	2024-12-09	0	47
549	DUV ŚWI ROW	DUVEL ŚWIATŁO ROWEROWE	\N	5	szt	0.00	AT-27-02	2024-12-09	0	5
550	DUV TRI CAS 330	DUVEL TRIPLE HOP CASHMERE BUT. 0,33 L	5411681406039	224	szt	0.50	RC-08-00	2024-12-09	0	224
551	DUV TRI CIT 330 ml	DUVEL TRIPLE HOP CITRA BUT. 0,33 L	5411681401164	552	szt	0.50	RA-02-02	2024-12-09	0	552
552	DW FLA FA BA_PROM	DWIE WIEŻE FLANDERS FA + BA BUT. 0,33 L PROMOCJA (do 30.09.23)	\N	11	szt	0.00	RC-04-01	2024-12-09	0	11
553	DZIK CYD GRU KEG	DZIK CYDR GRUSZKA KEG 30 L	5906395413072	19	szt	32.00	RC-12-01	2024-12-09	0	19
554	DZIK CYD JAB KEG	DZIK CYDR JABŁKO KEG 30 L	5906395413065	19	szt	32.00	RC-13-01	2024-12-09	0	19
555	DZIK_CYD_MAR_BUT_500	DZIK CYDR MARAKUJA 0% BUT. 0,5 L	5906395413515	874	szt	0.77	RA-02-04	2024-12-09	0	874
556	DZIK_CYD_PÓŁ_BUT_500	DZIK CYDR PÓŁSŁODKI BUT. 0,5 L	5906395413485	455	szt	0.77	RC-09-00	2024-12-09	0	455
557	DZIK_CYD_SZKL_500	DZIK CYDR SZKLANKA SHAKER 0,5 L	5123456791447	13	szt	0.00	RC-13-01	2024-12-09	0	13
558	DZIK_CYD_TRAW_BUT_330	DZIK CYDR TRAWA CYTRYNOWA 0% BUT. 0,33 L	\N	480	szt	0.50	RC-10-00	2024-12-09	0	480
559	DZIK_CYD_WYTR_BUT_500	DZIK CYDR WYTRAWNY BUT. 0,5 L	5906395413492	356	szt	0.77	RC-11-00	2024-12-09	0	356
560	DZ_AYA_PUSZ_500	DZIKI WSCHÓD AYANI PUSZKA 0,5 L	5906874369944	25	szt	0.54	RC-13-01	2024-12-09	0	25
561	DZIKI BUS ZBO	DZIKI WSCHÓD BUSZUJĄCY W ZBOŻU BUT. 0,5 L	5906874369265	140	szt	0.77	RC-06-00	2024-12-09	0	140
562	DZIKI CHM KOF	DZIKI WSCHÓD CHMIELOBRANIE Z KOFEINĄ BUT. 0,5 L	5900779755819	9	szt	0.77	AT-27-02	2024-12-09	0	9
563	DZIKI CZA	DZIKI WSCHÓD CZAJ APACZA BUT. 0,5 L	5906874369326	55	szt	0.77	RC-13-01	2024-12-09	0	55
564	DZIKI DZI	DZIKI WSCHÓD DZIEWCZYNA SZAMANA BUT. 0,5 L	5906874369197	131	szt	0.77	RC-04-00	2024-12-09	0	131
565	DZIKI_FRE_BUT_500	DZIKI WSCHÓD FREEROKEZ BUT. 0,5 L	5906874369685	75	szt	0.77	RC-13-01	2024-12-09	0	75
566	DZ_HAS_PUSZ_500	DZIKI WSCHÓD HASTIIN PUSZKA 0,5 L	5906874369524	55	szt	0.54	RC-13-01	2024-12-09	0	55
567	DZIKI_ISKA_PUSZ_500	DZIKI WSCHÓD ISKA PUSZKA 0,5 L	\N	30	szt	0.54	RC-14-01	2024-12-09	0	30
568	DZIKI_KIRR_PUSZ_500	DZIKI WSCHÓD KIRRAI PUSZKA 0,5 L	5906874369081	28	szt	0.54	RC-14-01	2024-12-09	0	28
569	DZIKI MEN_PROM	DZIKI WSCHÓD MENOTSE PUSZKA 0,5 L PROMOCJA (do 25.10.23)	\N	49	szt	0.00	RC-14-01	2024-12-09	0	49
570	DZIKI NES	DZIKI WSCHÓD NESSO PUSZKA 0,5 L	5906874369500	50	szt	0.54	RC-14-01	2024-12-09	0	50
571	DZIKI NOL	DZIKI WSCHÓD NOLAN PUSZKA 0,5 L	5906874369067	20	szt	0.54	RC-14-01	2024-12-09	0	20
572	DZIKI NUN	DZIKI WSCHÓD NUNPA PUSZKA 0,5 L	5906874369395	14	szt	0.54	RC-14-01	2024-12-09	0	14
573	DZIKI ORŁ	DZIKI WSCHÓD ORŁA CIEŃ BUT. 0,5 L	5906874369418	60	szt	0.77	RC-15-01	2024-12-09	0	60
613	821	ENAME POKAL 0,33 L	5123456791093	24	szt	0.00	RC-19-01	2024-12-09	0	24
574	DZIKI POM	DZIKI WSCHÓD POMA RANCZO BUT. 0,5 L	5906874369579	95	szt	0.77	RC-15-01	2024-12-09	0	95
575	DZ_SAA_PUSZ_500	DZIKI WSCHÓD SAA PUSZKA 0,5 L	5906874369586	33	szt	0.54	RC-15-01	2024-12-09	0	33
576	DZIKI SAM	DZIKI WSCHÓD SAMOTNY JEŹDZIEC BUT. 0,5 L	5906874369876	83	szt	0.77	RC-15-01	2024-12-09	0	83
577	DZIKI SŁO	DZIKI WSCHÓD SŁOŃCE PRERII BUT. 0,5 L	5906874369258	81	szt	0.77	RC-16-01	2024-12-09	0	81
578	DZIKI SZA	DZIKI WSCHÓD SZALONY KOŃ BUT. 0,5 L	5906874369296	40	szt	0.77	RC-16-01	2024-12-09	0	40
579	DZIKI TAŃ	DZIKI WSCHÓD TAŃCZĄCY Z CHMIELAMI BUT. 0,5 L	5906874369135	100	szt	0.77	RC-16-01	2024-12-09	0	100
580	DZIKI_TAREE_PUSZ_500	DZIKI WSCHÓD TAREE'UUX PUSZKA 0,5 L	5906874369210	31	szt	0.54	RC-16-01	2024-12-09	0	31
581	DZIKI TET	DZIKI WSCHÓD TETON PUSZKA 0,5 L	5906874369029	40	szt	0.54	RC-16-01	2024-12-09	0	40
582	DZIKI TĘP	DZIKI WSCHÓD TĘPA DZIDA BUT. 0,5 L	5906874369159	197	szt	0.77	RC-08-00	2024-12-09	0	197
583	DZIKI TJM_PROM	DZIKI WSCHÓD TJMMNW BUT. 0,5 L PROMOCJA (do 01.10.23)	\N	11	szt	0.00	RC-05-01	2024-12-09	0	11
584	DZIKI TYT CZA	DZIKI WSCHÓD TYTANOWA CZACHA BUT. 0,5 L	5906874369630	20	szt	0.77	RC-15-01	2024-12-09	0	20
585	DZIKI TYT	DZIKI WSCHÓD TYTANOWE JAJO BUT. 0,5 L	5906874369302	60	szt	0.77	RC-17-01	2024-12-09	0	60
586	DZ_WIL_WIL_EAS_BLA_WIL_BUT_375	DZIKI WSCHÓD WILD WILD EAST - BLACK WILD ALE BUT. 0,375 L	5906874369890	28	szt	0.50	RC-17-01	2024-12-09	0	28
587	DZ_WIL_WIL_EAS_PEA_DAR_WIL_BUT_375	DZIKI WSCHÓD WILD WILD EAST - PEATED DARK WILD ALE BUT. 0,375 L	5906874369906	27	szt	0.50	RC-17-01	2024-12-09	0	27
588	DZ_WIL_WIL_EAS_PIN_TAR_WIL_BUT_375	DZIKI WSCHÓD WILD WILD EAST - PINEAPPLE TART WILD ALE BUT. 0,375 L	5906874369920	28	szt	0.50	RC-17-01	2024-12-09	0	28
589	DZ_WIL_WIL_EAS_XMAS_WIL_BUT_375	DZIKI WSCHÓD WILD WILD EAST - XMAS WILD ALE BUT. 0,375 L	5906874369913	31	szt	0.50	RC-17-01	2024-12-09	0	31
590	DZIKI WIL CHE	DZIKI WSCHÓD WILD WILD EAST CHERRY WILD ALE BUT. 0,375 L	5906874369609	21	szt	0.50	RC-17-01	2024-12-09	0	21
591	DZIKI WIL CRA	DZIKI WSCHÓD WILD WILD EAST CRANBERRY WILD ALE BUT. 0,375 L	5906874369623	19	szt	0.50	RC-18-01	2024-12-09	0	19
592	DZIKI WOL	DZIKI WSCHÓD WOLNY DUCH BUT. 0,5 L	5906874369340	28	szt	0.77	RC-18-01	2024-12-09	0	28
593	DZIKI_ZŁO_KAL_PUSZ_500	DZIKI WSCHÓD ZŁOTE KALESONY PUSZKA 0,5 L	5906874369951	52	szt	0.54	RC-18-01	2024-12-09	0	52
594	ED_CHI_WEGE	ED RED CHILI CON CARNE Z BRĄZ. RYŻEM - WIEPRZOWINA	5904083584165	10	szt	0.00	AT-27-02	2024-12-09	0	10
595	ED BOE STR	ED RED KONSERWA BOEUF STROGANOV	5903940086538	10	szt	0.00	AT-27-02	2024-12-09	0	10
596	ED CHI	ED RED KONSERWA CHILI CON CARNE	5904083584035	10	szt	0.00	AT-27-02	2024-12-09	0	10
597	ED CHI SIN	ED RED KONSERWA CHILI SIN CARNE	5904083584059	10	szt	0.00	AT-27-02	2024-12-09	0	10
598	ED IND	ED RED KONSERWA INDYK W SOSIE SEROWO-ZIOŁOWYM	5904083584066	15	szt	0.00	RC-18-01	2024-12-09	0	15
599	ED KAC	ED RED KONSERWA KACZE ŻOŁĄDKI W SOSIE ESTRAGONOWYM	5903940086552	10	szt	0.00	AT-27-02	2024-12-09	0	10
600	ED KAC KON	ED RED KONSERWA KACZKA KONFITOWANA Z JABŁKIEM	5903940086521	19	szt	0.00	RC-18-01	2024-12-09	0	19
601	ED BOC	ED RED KONSERWA KARKÓWKA Z PIWEM PIERWSZA POMOC	5904083584127	20	szt	0.00	RC-18-01	2024-12-09	0	20
602	ED KUR	ED RED KONSERWA KURCZAK Z GRZYBAMI Z LASU	5904083584011	10	szt	0.00	AT-27-02	2024-12-09	0	10
603	ED_LECZ	ED RED KONSERWA LECZO Z KIEŁBASĄ Z RUSIBORZA	5904083584110	10	szt	0.00	AT-27-03	2024-12-09	0	10
604	ED MAS	ED RED KONSERWA MASSAMAN CURRY Z KURCZAKIEM	59040835841037	10	szt	0.00	AT-27-03	2024-12-09	0	10
605	ED RAG	ED RED KONSERWA RAGU ALLA BOLOGNESE	5903940086590	12	szt	0.00	RC-19-01	2024-12-09	0	12
606	ED STE	ED RED KONSERWA STEK RZEŹNIKA W SOSIE PIEPRZOWYM	5903940086545	10	szt	0.00	AT-27-03	2024-12-09	0	10
607	ED SZA	ED RED KONSERWA SZAKSZUKA Z TOFU	5904083584042	10	szt	0.00	AT-27-03	2024-12-09	0	10
608	ED ŻEB	ED RED KONSERWA ŻEBERKA W SOSIE BBQ Z CHILI	5903940086514	10	szt	0.00	AT-27-03	2024-12-09	0	10
609	ED_MIEL_NAJ	ED RED MIELONKA NAJDROŻSZA	5904083584134	10	szt	0.00	AT-27-03	2024-12-09	0	10
610	ED_POTR_PIECZ	ED RED POTRAWKA Z PIECZARKAMI Z KASZĄ GR - KURCZAK	5904083584141	10	szt	0.00	AT-27-03	2024-12-09	0	10
611	ED_STRO_WIEPRZ	ED RED STROGANOV Z PĘCZAKIEM - WIEPRZOWINA	5904083584158	10	szt	0.00	AT-27-03	2024-12-09	0	10
612	ED_TIKK_MAS	ED RED TIKKA MASALA Z BRĄZ. RYŻEM - KURCZAK	5904083584172	10	szt	0.00	AT-27-04	2024-12-09	0	10
614	ENA TRI 330	ENAME TRIPLE BUT. 0,33 L	5412583240363	13	szt	0.50	RC-19-01	2024-12-09	0	13
615	FIL_CYD_ANG_BUT_750	FILOMELOS CYDR ANGELA BUT. 0,75 L	5900168509122	23	szt	1.10	RC-19-01	2024-12-09	0	23
616	FIL_CYD_PÓŁ_BUT_750	FILOMELOS CYDR PÓŁ WYTRAWNY BUT. 0,75 L	5900168509092	26	szt	1.10	RC-19-01	2024-12-09	0	26
617	FIL_CYD_RÓŻ_BUT_330	FILOMELOS CYDR RÓŻANIECKI BUT. 0,33 L	5900168509030	125	szt	0.50	RC-07-00	2024-12-09	0	125
618	FIL_CYD_SPO_BUT_750	FILOMELOS CYDR SPOKOJNY JABŁKOWY BUT. 0,75 L	5900168509023	28	szt	1.10	RC-19-01	2024-12-09	0	28
619	FIL_CYD_WYT_BUT_750	FILOMELOS CYDR WYTRAWNY BUT. 0,75 L	5900168509016	39	szt	1.10	RD-01-01	2024-12-09	0	39
620	FIL_PER_GRU_BUT_330	FILOMELOS PERRY HULAJ GRUSZKA BUT. 0,33 L	5900168509108	155	szt	0.50	RC-11-00	2024-12-09	0	155
621	FIL_PER_GRU_BUT_750	FILOMELOS PERRY HULAJ GRUSZKA BUT. 0,75 L	5900168509078	36	szt	1.10	RD-01-01	2024-12-09	0	36
622	FIL_PER_ZAG_BUT_750	FILOMELOS PERRY ZAGRUSZKA BUT. 0,75 L	5900168509085	5	szt	1.10	AT-27-02	2024-12-09	0	5
624	FILOU THU POK 250	FILOU THUR POKAL 0,25 L	5123456791343	6	szt	0.00	AT-27-04	2024-12-09	0	6
625	KAT07061_PROM	FISCHER BLONDE BUT. 0,65 L PROMOCJA (do 30.09.23)	\N	35	szt	0.00	RD-01-01	2024-12-09	0	35
626	381	FLOREFFE POKAL  0,25 L	5123456791092	6	szt	0.00	AT-27-04	2024-12-09	0	6
627	FLO PRI 330	FLOREFFE PRIMA MELIOR BUT. 0,33 L	5411276300513	23	szt	0.50	RD-01-01	2024-12-09	0	23
628	FLO TRI 330	FLOREFFE TRIPLE BUT. 0,33 L	5411276200516	32	szt	0.50	RD-01-01	2024-12-09	0	32
60	ALE MAN MAN	ALEBROWAR MANGO MAN BUT. 0,5 L	5907771341064	100	szt	0.77	RA-03-00	2024-12-09	0	115
629	FLO TRI 750	FLOREFFE TRIPLE BUT. 0,75 L	5411276200929	19	szt	1.10	RD-02-01	2024-12-09	0	19
630	FLO APP 330	FLORIS APPLE BUT. 0,33 L	5412186001095	21	szt	0.50	RD-02-01	2024-12-09	0	21
631	FLO CHOC 330	FLORIS CHOCOLAT BUT. 0,33 L	5412186000401	11	szt	0.50	RD-02-01	2024-12-09	0	11
632	FLO FRA 330	FLORIS FRAMBOISE BUT. 0,33 L	5412186001217	34	szt	0.50	RD-02-01	2024-12-09	0	34
633	Fly Dog Szkl	FLYING DOG SZKLANKA 1/2 PINT	5123456791390	76	szt	0.00	RD-02-01	2024-12-09	0	76
634	FM GIN	FLYING MONKEYS GINGER BELLE BARREL AGED BUT. 0,473 L	870766000640	25	szt	0.00	RD-02-01	2024-12-09	0	25
635	KAT07037	FLYING MONKEYS SZKLANKA  0,25 L	5123456791047	1	szt	0.00	AT-27-02	2024-12-09	0	1
636	MIŁ FOR BEZ CZA	FORTUNA BEZALKOHOLOWE CZARNE BUT. 0,5 L	5902838990667	95	szt	0.77	RD-03-01	2024-12-09	0	95
637	MIŁ FOR CZA	FORTUNA CZARNE BUT. 0,5 L	5902709615064	40	szt	0.77	RD-03-01	2024-12-09	0	40
638	MIŁ FOR CZA WHI	FORTUNA CZARNE WHISKY WOOD BUT. 0,5 L	5902838990544	100	szt	0.77	RD-03-01	2024-12-09	0	100
639	MIŁ FOR KWA	FORTUNA KWAŚNA PIGWA BUT. 0,5 L	5902838990452	160	szt	0.77	RC-12-00	2024-12-09	0	160
640	MIŁ FOR MIO	FORTUNA MIODOWE BUT. 0,5 L	5902709615187	140	szt	0.77	RC-12-00	2024-12-09	0	140
641	MIŁ_FOR_MIR_BEZ_BUT_500	FORTUNA MIRABELKA BEZALKOHOLOWE BUT. 0,5 L	5902838990988	56	szt	0.77	RD-03-01	2024-12-09	0	56
642	MIŁ FOR MIR	FORTUNA MIRABELKA BUT. 0,5 L	5901687910291	109	szt	0.77	RC-05-00	2024-12-09	0	109
643	MIŁ FOR ŚLI	FORTUNA ŚLIWKOWA BUT. 0,5 L	5901687910161	119	szt	0.77	RC-08-00	2024-12-09	0	119
644	MIŁ FOR WIŚ	FORTUNA WIŚNIOWA BUT. 0,5 L	5902709615200	106	szt	0.77	RC-12-00	2024-12-09	0	106
645	FF ASH COC COF	FUNKY FLUID ASHES & DIAMONDS COCONUT / COFFEE BUT. 0,33 L	5903999511852	89	szt	0.50	RD-04-01	2024-12-09	0	89
646	FF ASH RAI FIG	FUNKY FLUID ASHES & DIAMONDS RAISINS / FIGS / DATES BUT. 0,33 L	5903999511876	23	szt	0.50	RD-04-01	2024-12-09	0	23
647	FF_BEE_PUSZ_500	FUNKY FLUID BEEP PUSZKA 0,5 L	5903999514167	399	szt	0.54	RC-13-00	2024-12-09	0	399
648	FF BLA	FUNKY FLUID BLACK CURRANT SOUR BUT. 0,5 L	5906395560349	544	szt	0.77	RA-03-02	2024-12-09	0	544
649	FF_BUONAS_PUSZ_500	FUNKY FLUID BUONASERA PUSZKA 0,5 L	5903999514648	117	szt	0.54	RC-12-00	2024-12-09	0	117
650	FF_CHE_PUSZ_500	FUNKY FLUID CHERRY PUSZKA 0,5 L	5903999514068	1189	szt	0.54	RA-03-03	2024-12-09	0	1189
651	FF_CALSS_PUSZ_500	FUNKY FLUID CLASSY PUSZKA 0,5 L	5903999514785	200	szt	0.54	RC-14-00	2024-12-09	0	200
653	FF_COC_ZIN_PUSZ_500	FUNKY FLUID COCONUT ZINGY PUSZKA 0,5 L	5903999514778	223	szt	0.54	RC-14-00	2024-12-09	0	223
654	FF_COP_PUSZ_500	FUNKY FLUID COPACABANA PUSZKA 0,5 L	5903999514372	150	szt	0.54	RC-15-00	2024-12-09	0	150
655	FF CRA	FUNKY FLUID CRAZY HAZY BUT. 0,5 L	5907772092187	189	szt	0.77	RC-15-00	2024-12-09	0	189
656	FF EVE	FUNKY FLUID EVERYDAY BUT. 0,5 L	5906395560240	294	szt	0.77	RC-16-00	2024-12-09	0	294
657	FF_FIV_FIN_DIS_PUSZ_500	FUNKY FLUID FIVE FINGER DISCOUNT PUSZKA 0,5 L	5903999512934	31	szt	0.54	RD-04-01	2024-12-09	0	31
658	FF_FOG_PUSZ_500	FUNKY FLUID FOGGY PUSZKA 0,5 L	5907772092408	637	szt	0.54	RA-03-02	2024-12-09	0	637
659	FF FRE GEL BER CRE	FUNKY FLUID FREE GELATO: BERRIES & CREAM PUSZKA 0,5 L	5907772092620	267	szt	0.54	RC-17-00	2024-12-09	0	267
660	FF_FRE_GEL_MAN_STI_PUSZ_500	FUNKY FLUID FREE GELATO: MANGO STICKY RICE PUSZKA 0,5 L	5903999514884	80	szt	0.54	RD-04-01	2024-12-09	0	80
661	FF FRE GEL PIN	FUNKY FLUID FREE GELATO: PINA COLADA PUSZKA 0,5 L	5903999512545	137	szt	0.54	RC-13-00	2024-12-09	0	137
662	FF_FREE_TRO_PUSZ_330	FUNKY FLUID FREE TROPIC PUSZKA 0,33 L	5903999514754	88	szt	0.35	RD-05-01	2024-12-09	0	88
663	FF_FUL_CLI_PUSZ_500	FUNKY FLUID FULL CLIP BUT. 0,5 L	5903999514327	12	szt	0.77	RD-04-01	2024-12-09	0	12
664	FF_FUN_FRU_PEA_BUT_500	FUNKY FLUID FUNKY FRUIT: PEACH WEIZEN BUT. 0,5 L	5906395560318	493	szt	0.77	RC-18-00	2024-12-09	0	493
665	FF_FUS_MAG_PUSZ_500	FUNKY FLUID FUSION: MAGIC ROAD PUSZKA 0,5 L	5903999513924	5	szt	0.54	AT-27-04	2024-12-09	0	5
666	FF_FUS_MON_PUSZ_500	FUNKY FLUID FUSION: MOON LARK PUSZKA 0,5 L	5903999514181	442	szt	0.54	RC-19-00	2024-12-09	0	442
667	FF_FUS_PRZ_PUSZ_500	FUNKY FLUID FUSION: PRZETWÓRNIA CHMIELU PUSZKA 0,5 L	5903999514860	111	szt	0.54	RC-14-00	2024-12-09	0	111
668	FF_FUS_TAN_PUSZ_500	FUNKY FLUID FUSION: TANKBUSTERS PUSZKA 0,5 L	5903999514358	37	szt	0.54	RD-04-01	2024-12-09	0	37
669	FF_GEL_ARA_PUSZ_500	FUNKY FLUID GELATO: ARANCIA PUSZKA 0,5 L	5903999514402	72	szt	0.54	RD-05-01	2024-12-09	0	72
670	FF_GEL_BAN_CRE_PUSZ_500	FUNKY FLUID GELATO: BANANA CREPES SUZETTE PUSZKA 0,5 L	5903999514655	72	szt	0.54	RD-05-01	2024-12-09	0	72
671	FF_GEL_BER_CRE_500	FUNKY FLUID GELATO: BERRIES & CREAM PUSZKA 0,5 L	5903999510107	145	szt	0.54	RC-15-00	2024-12-09	0	145
672	FF_GEL_BLU_CHEE_PUSZ_500	FUNKY FLUID GELATO: BLUEBERRY CHEESECAKE PUSZKA 0,5 L	5903999514501	139	szt	0.54	RC-16-00	2024-12-09	0	139
673	FF_GEL_BUB_PUSZ_500	FUNKY FLUID GELATO: BUBLANINA PUSZKA 0,5 L	5903999514037	332	szt	0.54	RD-01-00	2024-12-09	0	332
674	FF_GEL_GIA_PUSZ_500	FUNKY FLUID GELATO: GIALLO PUSZKA 0,5 L	5903999514792	332	szt	0.54	RD-02-00	2024-12-09	0	332
675	FF GEL MAN PEA	FUNKY FLUID GELATO: PASSION FRUIT MANGO PEACH PUSZKA 0,5 L	5907772092552	1443	szt	0.54	AT-10	2024-12-09	0	1443
676	FF_GEL_POM-PLU-MOC_PUSZ_500	FUNKY FLUID GELATO: POMEGRANATE & PLUM MOCHA PUSZKA 0,5 L	5903999514082	67	szt	0.54	RD-05-01	2024-12-09	0	67
677	FF_GEL_ROS_PUSZ_500	FUNKY FLUID GELATO: ROSA PUSZKA 0,5 L	5903999514419	128	szt	0.54	RC-17-00	2024-12-09	0	128
678	FF_GEL_ROSSO_PUSZ_500	FUNKY FLUID GELATO: ROSSO PUSZKA 0,5 L	5903999514365	25	szt	0.54	RD-06-01	2024-12-09	0	25
679	FF_GEL_TAR_QUE_PUSZ_500	FUNKY FLUID GELATO: TARTA DE QUESO PUSZKA 0,5 L	5903999514662	36	szt	0.54	RD-06-01	2024-12-09	0	36
680	FF_GEL_YEL_PUSZ_500	FUNKY FLUID GELATO: YELLOW FLUFF PUSZKA 0,5 L	5903999514389	16	szt	0.54	RD-06-01	2024-12-09	0	16
681	FF GUM PIN_PROM	FUNKY FLUID GUMMY: PINK PUSZKA 0,5 L PROMOCJA (do 06.10.23)	\N	284	szt	0.00	RD-03-00	2024-12-09	0	284
682	FF_HAL_PUSZ_500	FUNKY FLUID HALLERTAUER PILS PUSZKA 0,5 L	5903999514198	140	szt	0.54	RC-17-00	2024-12-09	0	140
683	FF_HIG_PUSZ_4500	FUNKY FLUID HIGH FIVE! PUSZKA 0,5 L	5903999514464	180	szt	0.54	RD-01-00	2024-12-09	0	180
684	FF HIT	FUNKY FLUID HITS FROM THE BONG BUT. 0,5 L	5903999510459	2	szt	0.77	AT-27-04	2024-12-09	0	2
685	FF_HON_PUSZ_500	FUNKY FLUID HONK PUSZKA 0,5 L	5903999514020	16	szt	0.54	RD-06-01	2024-12-09	0	16
686	FF JAM P	FUNKY FLUID JAM SESSION PUSZKA 0,5 L	5907772092279	1456	szt	0.54	AT-11	2024-12-09	0	1456
687	FF_KAL_PUSZ_500	FUNKY FLUID KALIMERA PUSZKA 0,5 L	5903999514631	95	szt	0.54	RD-06-01	2024-12-09	0	95
688	FF_LAG_BUT_500	FUNKY FLUID LAGER BUT. 0,5 L	5903999514426	26	szt	0.77	RD-06-01	2024-12-09	0	26
689	FF_LEC_BUT_500	FUNKY FLUID LECKER BUT. 0,5 L	5903999514310	56	szt	0.77	RD-07-01	2024-12-09	0	56
690	FF LEV 2022	FUNKY FLUID LEVIATHAN 2022 PUSZKA 0,33 L	5903999510435	51	szt	0.35	RD-07-01	2024-12-09	0	51
691	FF_MAN_PUSZ_500	FUNKY FLUID MANIAC PUSZKA 0,5 L	5907772092866	90	szt	0.54	RD-07-01	2024-12-09	0	90
692	FF_MAT_PUSZ_500	FUNKY FLUID MATE PUSZKA 0,5 L	5907772092026	139	szt	0.54	RD-02-00	2024-12-09	0	139
693	FF_MOD_POL_PUSZ_500	FUNKY FLUID MODERN POLISH IPA PUSZKA 0,5 L	5903999510510	43	szt	0.54	RD-07-01	2024-12-09	0	43
694	FF_MOO_PUSZ_500	FUNKY FLUID MOODY PUSZKA 0,5 L	5903999514174	362	szt	0.54	RD-04-00	2024-12-09	0	362
695	FF_MY_CUP_PUSZ_500	FUNKY FLUID MY CUP OF TEA PUSZKA 0,5 L	5903999514570	364	szt	0.54	RD-05-00	2024-12-09	0	364
696	FF_NEC_SOU_PUSZ_500	FUNKY FLUID NECTARINE SOUR PUSZKA 0,5 L	5903999514143	108	szt	0.54	RD-03-00	2024-12-09	0	108
697	FF PIL	FUNKY FLUID PILS PLEASE BUT. 0,5 L	5906395560257	302	szt	0.77	RD-06-00	2024-12-09	0	302
698	FF POI HAZ IPA	FUNKY FLUID POINT FIVE HAZY IPA PUSZKA 0,5 L	5907772092958	137	szt	0.54	RD-03-00	2024-12-09	0	137
699	FF SAN	FUNKY FLUID SANDY BUT. 0,5 L	5907772092170	62	szt	0.77	RD-08-01	2024-12-09	0	62
700	FF_SAS_PUSZ_500	FUNKY FLUID SASSY PUSZKA 0,5 L	5903999513696	5	szt	0.54	AT-27-04	2024-12-09	0	5
701	FF_SPI_PUSZ_500	FUNKY FLUID SPIFFY PUSZKA 0,5 L	5903999514488	252	szt	0.54	RD-07-00	2024-12-09	0	252
702	FF SPL PIN	FUNKY FLUID SPLASH: PINK PUSZKA 0,5 L	5903999513276	267	szt	0.54	RD-07-00	2024-12-09	0	267
703	FF SPL PIN_PROM	FUNKY FLUID SPLASH: PINK PUSZKA 0,5 L PROMOCJA (do 27.09.23)	\N	49	szt	0.00	RD-07-01	2024-12-09	0	49
704	FF_SPL_WHI_PUSZ_500	FUNKY FLUID SPLASH: WHITE PUSZKA 0,5 L	5903999512491	21	szt	0.54	RD-08-01	2024-12-09	0	21
705	FF_STRAW_PUSZ_500	FUNKY FLUID STRAWBERRY PUSZKA 0,5 L	5903999514587	47	szt	0.54	RD-08-01	2024-12-09	0	47
706	FF SUS	FUNKY FLUID SUSKA SECHLOŃSKA PUSZKA 0,44 L	8720615260690	3	szt	0.48	AT-27-04	2024-12-09	0	3
707	FF THO	FUNKY FLUID THOMAS - GELATO: SCHWARZWÄLDER KIRSCHTORTE PUSZKA 0,5 L	5903999513610	34	szt	0.54	RD-08-01	2024-12-09	0	34
708	FF_THRI_PUSZ_500	FUNKY FLUID THRILLED BLACK IPA PUSZKA 0,5 L	5903999514228	486	szt	0.54	RD-08-00	2024-12-09	0	486
709	FF_THUND_PUSZ_500	FUNKY FLUID THUNDER BOLT PUSZKA 0,5 L	5903999514761	101	szt	0.54	RA-13-00	2024-12-09	0	101
710	FF_SIM_PIL_PUSZ_500	FUNKY FLUID TRINITY SIMCOE PILS PUSZKA 0,5 L	5903999514150	476	szt	0.54	RD-09-00	2024-12-09	0	476
711	FF TRI GEL BER	FUNKY FLUID TRIPLE GELATO: BERRIES & CREAM PUSZKA 0,5 L	5903999510893	39	szt	0.54	RD-08-01	2024-12-09	0	39
712	FF_TRI_GEL_BIA_PUSZ_500	FUNKY FLUID TRIPLE GELATO: BIANCO PUSZKA 0,5 L	5903999513832	10	szt	0.54	AT-27-04	2024-12-09	0	10
713	FF_TRI_GEL-RAS-RED-COC_PUSZ_500	FUNKY FLUID TRIPLE GELATO: RASPBERRY & RED GRAPE COCONUT BAR PUSZKA 0,5 L	5903999513733	51	szt	0.54	RD-08-01	2024-12-09	0	51
714	FF_TRI_GEL_VERD_PUSZ_500	FUNKY FLUID TRIPLE GELATO: VERDE PUSZKA 0,5 L	5903999514525	77	szt	0.54	RD-09-01	2024-12-09	0	77
715	FF USU P	FUNKY FLUID USUAL PUSZKA 0,5 L	5907772092798	1124	szt	0.54	RA-04-02	2024-12-09	0	1124
716	FF_VOY_PUSZ_500	FUNKY FLUID VOYAGE, VOYAGE PUSZKA 0,5 L	5903999514204	84	szt	0.54	RD-09-01	2024-12-09	0	84
717	FF_WAT_PUSZ_500	FUNKY FLUID WATCH YA SELF PUSZKA 0,5 L	5903999514556	51	szt	0.54	RD-09-01	2024-12-09	0	51
718	FF_YUZ_PUSZ_	FUNKY FLUID YUZUALLY PUSZKA 0,5 L	5903999513764	271	szt	0.54	RD-10-00	2024-12-09	0	271
719	GAU BLA REK	GAULOISE BLACHA REKLAMOWA	5123456791366	1	szt	0.00	AT-27-04	2024-12-09	0	1
720	GAU BLO 330	GAULOISE BLONDE BUT. 0,33 L	5411633331013	10	szt	0.50	AT-27-04	2024-12-09	0	10
721	GEK BEE INT THE THI OF IT	GEKKO BEERS INTO THE THICK OF IT PUSZ. 0,44 L	3770011188178	2	szt	0.00	AT-27-04	2024-12-09	0	2
722	GEK BEE SLIN_PROM	GEKKO BEERS SLINGSHOT PUSZ. 0,44 L PROMOCJA (do 05.10.23)	\N	2	szt	0.00	AT-27-04	2024-12-09	0	2
723	GOL SZK	GOLEM SZKŁO FIRMOWE 0,3 L	5123456791225	22	szt	0.00	RD-09-01	2024-12-09	0	22
724	GO_BAB_BUT_500	GOŚCISZEWO BABA JAGA BUT. 0,5 L	5903364108885	30	szt	0.77	RD-09-01	2024-12-09	0	30
725	GO_CZAR_BUT_500	GOŚCISZEWO CZAROWNICA BUT. 0,5 L	5903364108854	22	szt	0.77	RD-09-01	2024-12-09	0	22
726	GO_DRW_AUS_BUT_500	GOŚCISZEWO DRWAL AUSTRALIAN BUT. 0,5	5903364108465	95	szt	0.00	RD-10-01	2024-12-09	0	95
727	GO_GÓRO_BUT_500	GOŚCISZEWO GÓROŁAZ BUT. 0,5 L	5903364108984	47	szt	0.77	RD-10-01	2024-12-09	0	47
728	GO_KOM_BUT_500	GOŚCISZEWO KOMTUR BUT. 0,5 L	5903364108281	26	szt	0.77	RD-10-01	2024-12-09	0	26
729	GO_LET_BUT_500	GOŚCISZEWO LETNIK BUT. 0,5 L	5903364108977	107	szt	0.77	RC-16-00	2024-12-09	0	107
730	GO_RYC_BUT_500	GOŚCISZEWO RYCERZ BUT. 0,5 L	5903364108014	25	szt	0.77	RD-10-01	2024-12-09	0	25
731	GO_SĄSI_BUT_500	GOŚCISZEWO SĄSIAD BUT. 0,5 L	5903364108007	82	szt	0.77	RD-10-01	2024-12-09	0	82
732	GO_SOŁ_BUT_500	GOŚCISZEWO SOŁTYS BUT. 0,5 L	5903364108557	69	szt	0.77	RD-11-01	2024-12-09	0	69
733	GO_SURF_BUT_500	GOŚCISZEWO SURFER BUT. 0,5 L	5903364108045	35	szt	0.77	RD-11-01	2024-12-09	0	35
734	GO_SZEW_BUT_500	GOŚCISZEWO SZEWC BUT. 0,5 L	5903364108991	40	szt	0.77	RD-11-01	2024-12-09	0	40
735	GO_TRAG_BUT_500	GOŚCISZEWO TRAGARZ BUT. 0,5 L	5903364108052	34	szt	0.77	RD-11-01	2024-12-09	0	34
736	GRI BLO 330	GRIMBERGEN BLONDE BUT. 0,33 L	5410263015669	154	szt	0.50	RD-04-00	2024-12-09	0	154
737	GRI DES DEG	GRIMBERGEN DESKA DEGUSTACYJNA	5123456791350	4	szt	0.00	AT-27-04	2024-12-09	0	4
738	GRI DOU 330	GRIMBERGEN DOUBLE BUT. 0,33 L	5410263010664	162	szt	0.50	RD-05-00	2024-12-09	0	162
799	HOEG K 6 L	HOEGAARDEN KEG 6 L	5410228187615	1	szt	0.00	AT-28-00	2024-12-09	0	1
739	GRI POK FEN 250	GRIMBERGEN FENIKS POKAL 0,25 L	5123456791091	9	szt	0.00	AT-27-04	2024-12-09	0	9
740	GRI POK FEN 330	GRIMBERGEN FENIKS POKAL 0,33 L	5123456791090	39	szt	0.00	RD-11-01	2024-12-09	0	39
741	GRI TRI 330	GRIMBERGEN TRIPLE BUT. 0,33 L	5410263011661	82	szt	0.50	RD-11-01	2024-12-09	0	82
742	4338-7253A	GRISETTE POKAL 0,25 L	5123456791089	2	szt	0.00	AT-27-04	2024-12-09	0	2
743	MIŁ GRO APA	GRODZISKIE APA BUT. 0,5 L	5905279533233	70	szt	0.77	RD-12-01	2024-12-09	0	70
744	MIŁ GRO BEZ MAN	GRODZISKIE BEZALKOHOLOWE MANGO ALE BUT. 0,5 L	5905279533554	435	szt	0.77	RD-11-00	2024-12-09	0	435
745	MIŁ_GRO_BIA_BUT_500	GRODZISKIE BIAŁE BUT. 0,5 L	5905279533677	162	szt	0.77	RD-06-00	2024-12-09	0	162
746	MIŁ GRO PIW GRO	GRODZISKIE PIWO Z GRODZISKA BUT. 0,5 L	5905279533264	74	szt	0.77	RD-12-01	2024-12-09	0	74
747	MIŁ_GRO_PIW_2023_BUT_500	GRODZISKIE PIWOBRANIOWE 2023 BUT. 0,5 L	5905279533714	99	szt	0.77	RD-12-01	2024-12-09	0	99
748	MIŁ GRO SES	GRODZISKIE SESSION ALE BUT. 0,5 L	5905279533523	45	szt	0.77	RD-12-01	2024-12-09	0	45
749	MIŁ GRO WHI IPA	GRODZISKIE WHITE IPA BUT. 0,5 L	5905279533240	75	szt	0.77	RD-13-01	2024-12-09	0	75
750	GR EXC	GRYBÓW PILSVAR EXCLUSIVE BUT. 0,5 L	5902516000329	31	szt	0.77	RD-13-01	2024-12-09	0	31
751	GR GÓR	GRYBÓW PILSVAR GÓRALSKIE BUT. 0,5 L	5902516000411	273	szt	0.77	RD-12-00	2024-12-09	0	273
752	GR GRY	GRYBÓW PILSVAR GRYBÓW BUT. 0,5 L	5902516000268	27	szt	0.77	RD-13-01	2024-12-09	0	27
753	GR_KONOP_BUT_500	GRYBÓW PILSVAR KONOPNIAK BUT. 0,5 L	5902516011400	145	szt	0.77	RD-10-00	2024-12-09	0	145
754	GR MIO	GRYBÓW PILSVAR MIODOWY BUT. 0,5 L	5902516000985	15	szt	0.77	RD-10-01	2024-12-09	0	15
755	GR MIÓ MAL	GRYBÓW PILSVAR MIÓD-MALINA BUT. 0,5 L	5902516000978	180	szt	0.77	RD-12-00	2024-12-09	0	180
756	GR_PORT_BUT_500	GRYBÓW PILSVAR PORTER BUT. 0,5 L	5902516000435	14	szt	0.77	RD-13-01	2024-12-09	0	14
757	GR PSZ	GRYBÓW PILSVAR PSZENICZNE BUT. 0,5 L	5902516000589	95	szt	0.77	RD-13-01	2024-12-09	0	95
758	GR STA	GRYBÓW PILSVAR STAROSĄDECKIE BUT. 0,5 L	5902516000688	76	szt	0.77	RD-14-01	2024-12-09	0	76
759	GR SVE	GRYBÓW PILSVAR SVEJKOVE BUT. 0,5 L	5902516000831	80	szt	0.77	RD-14-01	2024-12-09	0	80
760	GR ZER	GRYBÓW PILSVAR ZERO BUT. 0,5 L	5902516001074	105	szt	0.77	RD-10-00	2024-12-09	0	105
761	GRY_AHO_2.0_BUT_500	GRYFUS AHOJ 2.0 BUT. 0,5 L	5904905850140	80	szt	0.77	RD-14-01	2024-12-09	0	80
762	GRY BAS	GRYFUS BASZTA BUT. 0,5 L	5907222685204	90	szt	0.77	RD-15-01	2024-12-09	0	90
763	GRY_FLO_BUT_500	GRYFUS FLORA BUT. 0,5 L	5904905850171	55	szt	0.77	RD-13-01	2024-12-09	0	55
764	GRY_GRI_PUSZ_500	GRYFUS GRINGO AT SUNRISE PUSZKA 0,5 L	5900779755833	95	szt	0.54	RD-15-01	2024-12-09	0	95
765	GRY GRY	GRYFUS GRYFITA BUT. 0,5 L	5907222685167	80	szt	0.77	RD-15-01	2024-12-09	0	80
766	GRY_POR_BUT_500	GRYFUS PORTOWIEC BUT. 0,5 L	5904905850072	115	szt	0.77	RD-13-00	2024-12-09	0	115
767	GRY RUS	GRYFUS RUSAŁKA BUT. 0,5 L	5907222685181	70	szt	0.77	RD-16-01	2024-12-09	0	70
768	GRY SED	GRYFUS SEDINA BUT. 0,5 L	5907222685174	45	szt	0.77	RD-14-01	2024-12-09	0	45
769	GRY STE	GRYFUS STERNIK BUT. 0,5 L	5907222685198	90	szt	0.77	RD-16-01	2024-12-09	0	90
770	GRY SZKL 5	GRYFUS SZKLANKA 0,5 L	5123456791395	118	szt	0.00	RD-13-00	2024-12-09	0	118
771	GUL DRA 330	GULDEN DRAAK BUT. 0,33 L	5411663002716	1664	szt	0.50	AT-11	2024-12-09	0	1664
772	GUL DRA CUV PRE MAD	GULDEN DRAAK CUVEE PRESTIGE MADEIRA BUT. 0,75 L	5411663708908	21	szt	1.10	RD-15-01	2024-12-09	0	21
773	GUL_DRA_KEG_5	GULDEN DRAAK KEG 5 L	\N	5	szt	0.00	AT-28-00	2024-12-09	0	5
774	501	GULDEN DRAAK POKAL 0,33 L	5123456791088	2	szt	0.00	AT-27-04	2024-12-09	0	2
775	GUL DRA QUA 750 ml	GULDEN DRAAK QUADRUPLE BUT. 0,75 L	5411663002853	5	szt	1.10	AT-28-00	2024-12-09	0	5
776	351	GUMMARUS POKAL 0,33 L	5123456791085	66	szt	0.00	RD-16-01	2024-12-09	0	66
777	GW_AHU_MOS_PUSZ_500	GWAREK A HUNDRED PERCENT OF...MOSAIC PUSZKA 0,5 L	5903938751714	40	szt	0.54	RD-16-01	2024-12-09	0	40
778	GWAR ONY	GWAREK ONYX PUSZKA 0,5 L	5903938751523	165	szt	0.54	RD-13-00	2024-12-09	0	165
779	GW_ORC_PUSZ_500	GWAREK ORCHARD BLEND PUSZKA 0,5 L	5903938751707	123	szt	0.54	RD-13-00	2024-12-09	0	123
780	GWAR OWS P	GWAREK OWSIANE WZGÓRZA PUSZKA 0,5 L	5903938751127	21	szt	0.54	RD-16-01	2024-12-09	0	21
781	GW_PIN_PUSZ_500	GWAREK PINK PUCKER PUSZKA 0,5 L	5903938751684	54	szt	0.54	RD-17-01	2024-12-09	0	54
782	GW_ZER_INO_VOL2_PUSZ_500	GWAREK ZERO INON VOL.2 PUSZKA 0,5 L	5903938751721	55	szt	0.54	RD-17-01	2024-12-09	0	55
783	GW_ZER_MAT_RED_BUT_500	GWAREK ZERO MATES LIQUID RED BUT. 0,5 L	5903938751745	100	szt	0.77	RD-17-01	2024-12-09	0	100
784	GW_ZER_MAT_YEL_BUT_500	GWAREK ZERO MATES LIQUID YELLOW BUT. 0,5 L	5903938751738	90	szt	0.77	RD-17-01	2024-12-09	0	90
785	HANS FRA 375	HANSSENS FRAMBOISE BUT. 0,375 L	5430000304085	24	szt	0.50	RD-18-01	2024-12-09	0	24
786	HANS OUD 375	HANSSENS OUDBEITJE BUT. 0,375 L	5430000304078	7	szt	0.50	AT-28-00	2024-12-09	0	7
787	HANS GUE 750	HANSSENS OUDE GUEUZE BUT. 0,75 L	5430000304016	11	szt	1.10	RD-07-01	2024-12-09	0	11
788	HANS KRI 375	HANSSENS OUDE KRIEK BUT. 0,375 L	5430000304047	32	szt	0.50	RD-18-01	2024-12-09	0	32
789	HARD CUV	HARDYWOOD CUVEE GOLD BUT. 0,75 L	856718003068	1	szt	1.10	AT-27-04	2024-12-09	0	1
790	HAR_AMR_PUSZ_500	HARPAGAN AMRITA PUSZKA 0,5 L	5905450141059	47	szt	0.54	RD-18-01	2024-12-09	0	47
791	HAR_BAR_BUT_330	HARPAGAN BAROTRAUMA TOBACCO BUT. 0,33 L	5905316580046	49	szt	0.50	RD-18-01	2024-12-09	0	49
792	HAR_JEO_BUT_500	HARPAGAN JEONG BUT. 0,5 L	5905316580053	3	szt	0.77	AT-28-00	2024-12-09	0	3
793	HARP PUN_PROM	HARPAGAN PUNKY MONKEY PUSZKA 0,5 L PROMOCJA (do 28.10.23)	\N	19	szt	0.00	RD-14-01	2024-12-09	0	19
794	HB_CBD_PAL_BUT_500	HEMP & BREW CBD PALE ALE BUT. 0,5 L	5903661867751	25	szt	0.77	RD-18-01	2024-12-09	0	25
795	HERK NOCT 330	HERKENRODE NOCTIS BUT. 0,33 L	5413699101234	1	szt	0.50	AT-28-00	2024-12-09	0	1
796	HOEG BLA	HOEGAARDEN BLANCHE BUT. 0,33 L	5410228141785	199	szt	0.50	RD-14-00	2024-12-09	0	199
797	HOEG BLA K 20	HOEGAARDEN BLANCHE KEG 20 L	5123456789020	2	szt	21.50	AT-28-00	2024-12-09	0	2
798	HOEG GRA 330	HOEGAARDEN GRAND CRU BUT. 0,33 L	5410228141921	54	szt	0.50	RD-18-01	2024-12-09	0	54
800	HOEG ROS 0% 250	HOEGAARDEN ROSEE 0% BUT. 0,25 L	5410228205876	13	szt	0.35	RD-15-01	2024-12-09	0	13
801	141	HOEGAARDEN SZKLANKA  0,25 L	5123456791046	6	szt	0.00	AT-28-00	2024-12-09	0	6
802	KAT01831	HOEGAARDEN SZKLANKA 0,33 L	5123456791045	60	szt	0.00	RD-19-01	2024-12-09	0	60
803	HOFS GRA ICE	HOFSTETTNER GRANITBOCK ICE BUT. 0,33 L	9007293384030	14	szt	0.50	RD-19-01	2024-12-09	0	14
804	HOFS GRA WIL	HOFSTETTNER GRANITBOCK WILDBRETT BUT. 0,75 L	5123456790128	7	szt	1.10	AT-28-00	2024-12-09	0	7
805	HOL_PRE_BZW_BUT_500	HOLBA PREMIUM 12° BZW.  BUT. 0,5 L	8593875610112	298	szt	0.77	RD-14-00	2024-12-09	0	298
806	HOL PRE K	HOLBA PREMIUM 12° KEG 30 L	\N	5	szt	32.00	AT-28-00	2024-12-09	0	5
807	HOL SER K	HOLBA ŠERÁK 11° KEG 30 L	\N	3	szt	32.00	AT-28-00	2024-12-09	0	3
808	HOPP 5-AL	HOPPIN' FROG / SIREN 5-ALARM CHILI BEER: AMERICAN STYLE BUT. 0,65 L	665760945901	2	szt	0.00	AT-28-00	2024-12-09	0	2
809	HOPP SSS	HOPPIN' FROG / TO OL SS STOUT BUT. 0,65 L	665760945994	20	szt	0.00	RD-19-01	2024-12-09	0	20
810	HOPP TUR SHA BOU	HOPPIN' FROG LIQUOR BARREL AGED TURBO SHANDY – BOURBON BUT. 0,65 L	804551312052	1	szt	0.00	AT-28-00	2024-12-09	0	1
811	KAT01009	HOPUS POKAL 0,33 L	5123456791084	1	szt	0.00	AT-28-00	2024-12-09	0	1
812	HOUB CHOUF 330	HOUBLON CHOUFFE BUT. 0,33 L	5410769300085	237	szt	0.50	RD-15-00	2024-12-09	0	237
813	HOUB CHOUF 750	HOUBLON CHOUFFE BUT. 0,75 L	5410769300115	101	szt	1.10	RD-11-00	2024-12-09	0	101
814	ICE BRE BOOM KEG 30	ICE BREAKER BOOMBOX KEG 30 L	\N	1	szt	32.00	AT-28-00	2024-12-09	0	1
815	ICE BRE CAR KAR KEG 30_PROM	ICE BREAKER CARPOOL KARAOKE KEG 30 L PROMOCJA (do 09.09.23)	\N	1	szt	0.00	AT-28-00	2024-12-09	0	1
816	ICE BRE SIL PRO KEG 30	ICE BREAKER SILVAS PROFUNDAS COLLAB. BREWING BEARS KEG 30 L	\N	1	szt	32.00	AT-28-00	2024-12-09	0	1
817	IGNAC_AMAR_BUT_500	IGNACÓW CYDR AMARUS BUT. 0,5 L	\N	122	szt	0.77	RD-15-00	2024-12-09	0	122
818	IGNAC BRE	IGNACÓW CYDR BRETTUS BUT. 0,75 L	5902768323047	34	szt	1.10	RD-19-01	2024-12-09	0	34
819	IGNAC POM	IGNACÓW CYDR POM BUT. 0,375 L	\N	58	szt	0.50	RD-19-01	2024-12-09	0	58
820	IGNAC SIC	IGNACÓW CYDR SICERO BUT. 0,5 L	5902768323030	129	szt	0.77	RD-15-00	2024-12-09	0	129
821	TRY_IGU_BUT_475	IGUANA Metabolizm BIO but. 0,475 L	5905689311117	294	szt	0.00	RD-16-00	2024-12-09	0	294
822	IMB Dwó Mal 375	IMBIOROWICZ MIÓD PITNY DWÓJNIAK MALINOWY BUT. 0,375 L	5905669820615	34	szt	0.50	RD-19-01	2024-12-09	0	34
823	IMB Dwó Pań kam	IMBIOROWICZ MIÓD PITNY DWÓJNIAK PANIEŃSKI KAMIONKA 0,70 L	5905669820639	9	szt	0.00	AT-28-00	2024-12-09	0	9
824	IMB 966 750	IMBIOROWICZ MIÓD PITNY TRÓJNIAK 966 BUT. 0,75 L	5905669820073	6	szt	1.10	AT-28-00	2024-12-09	0	6
825	IMB Air 375	IMBIOROWICZ MIÓD PITNY TRÓJNIAK AIRONIA BUT. 0,375 L	5905669820264	11	szt	0.50	RD-12-01	2024-12-09	0	11
826	IMB Air 750	IMBIOROWICZ MIÓD PITNY TRÓJNIAK AIRONIA BUT. 0,75 L	5905669820257	5	szt	1.10	AT-28-00	2024-12-09	0	5
827	IMB Med 500	IMBIOROWICZ MIÓD PITNY TRÓJNIAK MEADNIGHT BUT. 0,5 L	5905669820646	66	szt	0.77	RE-01-01	2024-12-09	0	66
828	IMB Mió Mal 375	IMBIOROWICZ MIÓD PITNY TRÓJNIAK MIÓD MALINA BUT. 0,375 L	5905669820394	1	szt	0.50	AT-28-00	2024-12-09	0	1
829	IMB Żad bec 500	IMBIOROWICZ MIÓD PITNY TRÓJNIAK ŻĄDŁO Z BECZKI BA BUT. 0,5 L	5905669820424	26	szt	0.77	RE-01-01	2024-12-09	0	26
830	IMB Żad kaw 500	IMBIOROWICZ MIÓD PITNY TRÓJNIAK ŻĄDŁO Z KAWĄ BUT. 0,5 L	5905669820462	7	szt	0.77	AT-28-00	2024-12-09	0	7
831	IN_BLA_SAN_BUT_500	INNE BECZKI BLACK SANDS BUT. 0,5 L	5901122234807	94	szt	0.77	RE-01-01	2024-12-09	0	94
832	INNE CHE	INNE BECZKI CHERRY ELEPHANT BUT. 0,5 L	5905669683258	822	szt	0.77	RA-04-03	2024-12-09	0	822
833	IN_DEE_NUT_PUSZ_500	INNE BECZKI DEEZ NUTS PUSZKA 0,5 L	5903661281557	30	szt	0.54	RE-01-01	2024-12-09	0	30
834	IN_EL_ALMA_PUSZ_500	INNE BECZKI EL ALMANTE PUSZKA 0,5 L	5903661281540	95	szt	0.54	RE-02-01	2024-12-09	0	95
835	INNE EST	INNE BECZKI ESTEBAN BUT. 0,5 L	5905669683289	654	szt	0.77	RA-04-04	2024-12-09	0	654
836	INNE FRE IPA	INNE BECZKI FREE IPA BUT. 0,5 L	5901122234432	450	szt	0.77	RD-17-00	2024-12-09	0	450
837	IN_FRE_PRI_BUT_500	INNE BECZKI FRESH PRINCE BUT. 0,5 L	5905669683319	668	szt	0.77	RA-05-02	2024-12-09	0	668
838	INNE HAZ	INNE BECZKI HAZY HAKA BUT. 0,5 L	5903661281106	310	szt	0.77	RD-18-00	2024-12-09	0	310
839	INNE HOL	INNE BECZKI HOLY MONUNTAIN PUSZKA 0,5 L	5903661281410	95	szt	0.54	RE-02-01	2024-12-09	0	95
840	IN_IPARA_PUSZ_500	INNE BECZKI IPARALIZATOR PUSZKA 0,5 L	5903661281779	144	szt	0.54	RD-16-00	2024-12-09	0	144
841	INNE JUN	INNE BECZKI JUNGLE IPA BUT. 0,5 L	5905669683005	239	szt	0.77	RD-19-00	2024-12-09	0	239
842	INNE MAN	INNE BECZKI MANGO JERRY BUT. 0,5 L	5903661280987	466	szt	0.77	RE-01-00	2024-12-09	0	466
843	INNE MIA	INNE BECZKI MIAMI BUT. 0,5 L	5905669683180	1029	szt	0.77	RA-05-03	2024-12-09	0	1029
844	INNE NEI	INNE BECZKI NEIPARADISE PUSZKA 0,5 L	5903661281427	7	szt	0.54	AT-28-01	2024-12-09	0	7
845	IN_OLDSCH_BUT_500	INNE BECZKI OLDSCHOOLOWIEC BUT. 0,5 L	5903661281618	490	szt	0.77	RE-02-00	2024-12-09	0	490
846	INNE PIL	INNE BECZKI PILZNER BUT. 0,5 L	5905669683043	403	szt	0.77	RE-03-00	2024-12-09	0	403
847	INNE SOU	INNE BECZKI SOURZILLA PUSZKA 0,5 L	5903661281434	610	szt	0.54	RA-05-04	2024-12-09	0	610
848	IN_SPI_THE_BUT_500	INNE BECZKI SPILL THE TEA BUT. 0,5 L	5901122234173	156	szt	0.77	RD-18-00	2024-12-09	0	156
849	INNE SUM	INNE BECZKI SUMMERTIME BUT. 0,5 L	5901122234654	283	szt	0.77	RD-19-00	2024-12-09	0	283
850	IN_SWE_WHE_PUSZ_500	INNE BECZKI SWEATER WHEATER PUSZKA 0,5 L	5903661281786	29	szt	0.54	RE-01-01	2024-12-09	0	29
851	INNE TOP	INNE BECZKI TOPAZ BUT. 0,5 L	5903661280963	475	szt	0.77	RE-04-00	2024-12-09	0	475
852	IN_TUT_BUT_500	INNE BECZKI TUTTI FRUTTI BUT. 0,5 L	5905669683296	460	szt	0.77	RE-05-00	2024-12-09	0	460
853	INNE WAK	INNE BECZKI WAKE & BAKE BUT. 0,5 L	5903661281069	480	szt	0.77	RE-06-00	2024-12-09	0	480
854	INNE ZER	INNE BECZKI ZERO TO HERO BUT. 0,5 L	5901122234203	710	szt	0.77	RA-06-02	2024-12-09	0	710
855	INNE ZIS	INNE BECZKI ZISSOU APA BUT. 0,5 L	5905669683012	245	szt	0.77	RE-07-00	2024-12-09	0	245
856	JAC CAR	JACKIE O'S / CASITA CERVECERÍA CARROTS & STICKS BUT. 0,375 L	855647004917	3	szt	0.50	AT-28-01	2024-12-09	0	3
857	JAC BEA 3	JACKIE O'S OFF THE BEATEN PATH 3 BUT. 0,5 L	855647004719	8	szt	0.77	AT-28-01	2024-12-09	0	8
858	JAC POC	JACKIE O'S POCKETS OF SUNLIGHT BUT. 0,5 L	855647004832	8	szt	0.77	AT-28-01	2024-12-09	0	8
859	JO CÓR	JAN OLBRACHT CÓRA KORYNTU BUT. 0,5 L	\N	5	szt	0.77	AT-28-01	2024-12-09	0	5
860	JO_KOR_JAC_BUT_370	JAN OLBRACHT KORD JACK WHISKEY BARREL AGED BUT. 0,37 L	5902627012822	70	szt	0.00	RE-02-01	2024-12-09	0	70
861	JO LP CZA BA	JAN OLBRACHT LEGENDY POLSKIE: CZART BA BUT. 0,33 L	5902627012242	11	szt	0.50	RD-16-01	2024-12-09	0	11
862	JO LP CZA	JAN OLBRACHT LEGENDY POLSKIE: CZART BUT. 0,33 L	5902627012235	41	szt	0.50	RE-01-01	2024-12-09	0	41
863	JO LP LES	JAN OLBRACHT LEGENDY POLSKIE: LESZY BUT. 0,33 L	5902627012211	32	szt	0.50	RE-02-01	2024-12-09	0	32
864	JO LP STR BA	JAN OLBRACHT LEGENDY POLSKIE: STRZYGA BA BUT. 0,33 L	5902627012228	3	szt	0.50	AT-28-01	2024-12-09	0	3
865	JO POM	JAN OLBRACHT POMARAŃCZARNIA BUT. 0,5 L	5904730284660	169	szt	0.77	RE-07-00	2024-12-09	0	169
866	JO ŚMI	JAN OLBRACHT ŚMIETANKA BUT. 0,5 L	5904730284035	110	szt	0.77	RE-03-00	2024-12-09	0	110
867	JO ZER BEZ	JAN OLBRACHT ZERO STRESU BEZALKOHOLOWE APA BUT. 0,5 L	5902627011481	438	szt	0.77	RE-08-00	2024-12-09	0	438
868	JO ZES KOR	JAN OLBRACHT ZESTAW KORD BUT. 0,33 L + POKAL	5902627010873	13	szt	0.00	RE-03-01	2024-12-09	0	13
869	1030	JUDAS POKAL 0,33 L	5123456791083	4	szt	0.00	AT-28-01	2024-12-09	0	4
870	JUP K 6 L	JUPILER KEG 6 L	5410228177494	1	szt	0.00	AT-28-01	2024-12-09	0	1
871	JUP 250	JUPILER NA BUT. 0,25 L	5410228231325	19	szt	0.35	RE-03-01	2024-12-09	0	19
872	JUP 250_PROM	JUPILER NA BUT. 0,25 L PROMOCJA (do 25.09.23)	\N	9	szt	0.00	AT-28-01	2024-12-09	0	9
873	KAT05458	JUPILER T-SHIRT (L)	5123456791191	1	szt	0.00	AT-28-01	2024-12-09	0	1
874	JUR MEK	JURAJSKIE ALE MEKSYK BUT. 0,5 L	5905331026376	150	szt	0.77	RE-09-00	2024-12-09	0	150
875	JUR ALE	JURAJSKIE ALE SZOPKA BUT. 0,5 L	5905331026062	23	szt	0.77	RE-03-01	2024-12-09	0	23
876	JUR AME	JURAJSKIE AMERYKAŃSKA PSZENICA BUT. 0,5 L	5905331025355	81	szt	0.77	RE-03-01	2024-12-09	0	81
877	JUR APA	JURAJSKIE APA BUT. 0,5 L	5905331025089	70	szt	0.77	RE-03-01	2024-12-09	0	70
878	JUR JAB	JURAJSKIE JABŁKO-MIĘTA BUT. 0,5 L	5905331025997	140	szt	0.77	RE-09-00	2024-12-09	0	140
879	JUR PRU	JURAJSKIE KWAS PRUSKI BUT. 0,5 L	5905331025607	374	szt	0.77	RE-10-00	2024-12-09	0	374
880	JUR KWA	JURAJSKIE KWAŚNA AŚKA BUT. 0,5 L	5905331025058	160	szt	0.77	RE-09-00	2024-12-09	0	160
881	JUR MNI	JURAJSKIE KWAŚNY MNISZEK BUT. 0,5 L	5905331026178	130	szt	0.77	RE-10-00	2024-12-09	0	130
882	JUR MOJ	JURAJSKIE MOJITO BUT. 0,5 L	5905331026642	245	szt	0.77	RE-11-00	2024-12-09	0	245
883	JUR MOT	JURAJSKIE MOTOCYKLOWE BUT. 0,5 L	5905331026369	293	szt	0.77	RE-11-00	2024-12-09	0	293
884	JUR POM BEZ	JURAJSKIE POMARAŃCZA BEZALKOHOLOWE BUT. 0,5 L	5905331026987	472	szt	0.77	RE-12-00	2024-12-09	0	472
885	JUR POM	JURAJSKIE POMARAŃCZA BUT. 0,5 L	5905331025362	966	szt	0.77	RA-06-03	2024-12-09	0	966
886	JUR POM K	JURAJSKIE POMARAŃCZA KEG 30 L	5123456789259	5	szt	32.00	AT-28-01	2024-12-09	0	5
887	JUR POR	JURAJSKIE PORTER BAŁTYCKI BUT. 0,33 L	5905331025416	132	szt	0.50	RE-13-00	2024-12-09	0	132
888	JUR PORZ	JURAJSKIE PORZECZKA BUT. 0,5 L	5905331026895	59	szt	0.77	RE-03-01	2024-12-09	0	59
889	JUR RÓŻ	JURAJSKIE RÓŻOWA PANTERA BUT. 0,5 L	5905331026048	187	szt	0.77	RE-13-00	2024-12-09	0	187
890	JUR SŁO DRW	JURAJSKIE SŁODKI DRWAL BUT. 0,5 L	5905331026956	62	szt	0.77	RE-04-01	2024-12-09	0	62
891	JUR_SŁO_CYT_BUT_500	JURAJSKIE SŁODKIE CYTRYNY BUT. 0,5 L	5905331026994	210	szt	0.77	RE-13-00	2024-12-09	0	210
892	JUR SZA	JURAJSKIE SZATAŃSKA OBELGA BUT. 0,5 L	5905331025485	181	szt	0.77	RE-14-00	2024-12-09	0	181
893	Jur Szk Sha 5	JURAJSKIE SZKLANKA SHAKER 0,5 L	5123456791393	147	szt	0.00	RE-14-00	2024-12-09	0	147
894	JUR ŚWI	JURAJSKIE ŚWIĄTECZNE BUT. 0,5 L	5095331025247	2	szt	0.77	AT-28-01	2024-12-09	0	2
895	JUR VER	JURAJSKIE VERMONT IPA BUT. 0,5 L	5905331026963	45	szt	0.77	RE-04-01	2024-12-09	0	45
896	JUR WIS	JURAJSKIE WIŚNIA W CZEKOLADZIE BUT. 0,5 L	5905331026017	89	szt	0.77	RE-04-01	2024-12-09	0	89
897	JUR OST	JURAJSKIE Z OSTROPESTEM BUT. 0,5 L	5905331025294	55	szt	0.77	RE-04-01	2024-12-09	0	55
898	KAP BLO 330	KAPITTEL BLONDE BUT. 0,33 L	5412896000432	8	szt	0.50	AT-28-01	2024-12-09	0	8
899	KARL WRE	KARL STRAUSS WRECK ALLEY IMPERIAL STOUT BUT. 0,65 L	796535001161	9	szt	0.00	AT-28-01	2024-12-09	0	9
900	KAST BAR	KASTEEL BARISTA CHOCOLATE QUAD BUT. 0,33 L	5411081005696	7	szt	0.50	AT-28-01	2024-12-09	0	7
901	KAST BAR CHO K 20 L	KASTEEL BARISTA CHOCOLATE QUAD KEG 20 L	5123456789882	2	szt	21.50	AT-28-02	2024-12-09	0	2
902	KAST BRI	KASTEEL BRIGAND BUT. 0,33 L	5411081000332	84	szt	0.50	RE-05-01	2024-12-09	0	84
903	KAST BRI KIEL 330	KASTEEL BRIGAND KIELICH 0,33 L	5123456791344	6	szt	0.00	AT-28-02	2024-12-09	0	6
904	KAST CUV K 20 L	KASTEEL CUVEE DE CHATEAU KEG 20 L	5123456789883	3	szt	21.50	AT-28-02	2024-12-09	0	3
905	KAST CUV	KASTEEL CUVEE DU CHATEAU BUT. 0,33 L	5411081004811	2	szt	0.50	AT-28-02	2024-12-09	0	2
906	KAST DON 330	KASTEEL DONKER BUT. 0,33 L	5411081000523	41	szt	0.50	RE-04-01	2024-12-09	0	41
907	KAST DON TRI PODKŁ	KASTEEL DONKER/ TRIPEL PODKŁADKI	5123456791337	12	szt	0.00	RE-05-01	2024-12-09	0	12
908	KAST MAT BAR (5X KAST)	KASTEEL MATA BAROWA (5X KASTEEL)	5123456791346	8	szt	0.00	AT-28-02	2024-12-09	0	8
909	KAST POK 330	KASTEEL POKAL 0,33 L	5123456791082	96	szt	0.00	RE-05-01	2024-12-09	0	96
910	KAST POK 500	KASTEEL POKAL 0,5 L	5123456791311	52	szt	0.00	RE-05-01	2024-12-09	0	52
911	KAST RĘC BAR	KASTEEL RĘCZNIK BAROWY	\N	5	szt	0.00	AT-28-02	2024-12-09	0	5
912	KAST ROU	KASTEEL ROUGE BUT. 0,33 L	5411081003654	185	szt	0.50	RE-14-00	2024-12-09	0	185
913	KAST ROU K 20 L	KASTEEL ROUGE KEG 20 L	\N	3	szt	21.50	AT-28-02	2024-12-09	0	3
914	KAST ROU MAT BAR	KASTEEL ROUGE MATA BAROWA	5123456791347	5	szt	0.00	AT-28-02	2024-12-09	0	5
915	KAST ROU PODKŁ	KASTEEL ROUGE PODKŁADKI	5123456791338	12	szt	0.00	RE-05-01	2024-12-09	0	12
916	KAST ROU P	KASTEEL ROUGE PUSZKA 0,5 L	5411081006112	28	szt	0.54	RE-05-01	2024-12-09	0	28
917	KAST ROU TAB REK	KASTEEL ROUGE TABLICA REKLAMOWA	5123456791353	3	szt	0.00	AT-28-02	2024-12-09	0	3
918	KAST_RUB_FRA_BUT_330	KASTEEL RUBUS FRAMBOISE 0,33 L	5411081009854	124	szt	0.00	RE-07-00	2024-12-09	0	124
919	KAST_RUB_FRA_KEG_20	KASTEEL RUBUS FRAMBOISE KEG 20 L	\N	3	szt	21.50	AT-28-02	2024-12-09	0	3
920	KAST TRI	KASTEEL TRIGNAC BUT. 0,75 L	5411081005344	12	szt	1.10	RE-06-01	2024-12-09	0	12
921	KAST TRI 330	KASTEEL TRIPEL BUT. 0,33 L	5411081000677	140	szt	0.50	RE-15-00	2024-12-09	0	140
922	KAST TRI K 20 L	KASTEEL TRIPEL KEG 20 L	5123456789884	2	szt	21.50	AT-28-02	2024-12-09	0	2
923	KAST XTRA	KASTEEL XTRA BUT. 0,33 L	5411081009007	35	szt	0.50	RE-06-01	2024-12-09	0	35
924	KAZ ALD	KAZIMIERZ ALDONA BUT. 0,5 L	5906660570042	94	szt	0.77	RE-06-01	2024-12-09	0	94
925	KAZ ALE DŹW	KAZIMIERZ ALEDŹWIEDŹ BUT. 0,5 L	5906660570028	5	szt	0.77	AT-28-02	2024-12-09	0	5
926	KAZ BAB	KAZIMIERZ BABCIA RÓZIA BUT. 0,5 L	5906660570523	15	szt	0.77	RE-06-01	2024-12-09	0	15
927	KAZ CZA	KAZIMIERZ CZAS NA FAIRANT BUT. 0,5 L	5906660570554	132	szt	0.77	RE-15-00	2024-12-09	0	132
928	KAZ_DES_BUT_500	KAZIMIERZ DESET Z DESETI  BUT. 0,5 L	5906660570769	45	szt	0.77	RE-06-01	2024-12-09	0	45
929	KAZ DOB #1	KAZIMIERZ DOBRE TO TO WYSZŁO #1 BUT. 0,5 L	5906660570363	208	szt	0.77	RE-15-00	2024-12-09	0	208
930	KAZ DOB #2	KAZIMIERZ DOBRE TO TO WYSZŁO #2 BUT. 0,5 L	5906660570509	140	szt	0.77	RE-16-00	2024-12-09	0	140
931	KAZ DOB #2_PROM	KAZIMIERZ DOBRE TO TO WYSZŁO #2 BUT. 0,5 L PROMOCJA (do 19.10.23)	\N	4	szt	0.00	AT-28-02	2024-12-09	0	4
932	KAZ ELA_PROM	KAZIMIERZ ELA UNDER MY UMBRELLA BUT. 0,5 L PROMOCJA	\N	41	szt	0.00	RE-06-01	2024-12-09	0	41
933	KAZ_GRU_BUT_500	KAZIMIERZ GRUPA WZAJEMNEJ ADORACJI BUT. 0,5 L	5906660570707	10	szt	0.77	AT-28-02	2024-12-09	0	10
934	KAZ ILE	KAZIMIERZ ILE TO MA IBU? BUT. 0,5 L	5906660570271	103	szt	0.77	RE-16-00	2024-12-09	0	103
935	KAZ KWA	KAZIMIERZ KWASIMIERZ BUT. 0,5 L	5906660570141	113	szt	0.77	RE-16-00	2024-12-09	0	113
936	KAZ LAT BA	KAZIMIERZ LATAJĄCY JELEŃ BARREL AGED BUT. 0,33 L	5906660570332	40	szt	0.50	RE-07-01	2024-12-09	0	40
937	KAZ LAT	KAZIMIERZ LATAJĄCY JELEŃ BUT. 0,5 L	5906660570240	60	szt	0.77	RE-07-01	2024-12-09	0	60
938	KAZ MAG	KAZIMIERZ MAGOG BUT. 0,33 L	5906660570639	43	szt	0.50	RE-07-01	2024-12-09	0	43
939	KAZ MAN	KAZIMIERZ MANGOŁ BUT. 0,5 L	5906660570103	155	szt	0.77	RE-16-00	2024-12-09	0	155
940	KAZ MR SHE	KAZIMIERZ MR. SHERMAN BUT. 0,5 L	5906660570349	109	szt	0.77	RE-17-00	2024-12-09	0	109
941	KAZ_MUS_BUT_500	KAZIMIERZ MUSTAFA BUT. 0,5 L	5906660570493	111	szt	0.77	RE-17-00	2024-12-09	0	111
942	KAZ MUS	KAZIMIERZ MUSZKIETEROWIE BUT. 0,5 L	5906660570585	20	szt	0.77	RE-07-01	2024-12-09	0	20
943	KAZ_NEV_BUT_500	KAZIMIERZ NEVER ENDING STORY BUT. 0,5 L	5906660570752	15	szt	0.77	RE-07-01	2024-12-09	0	15
944	KAZ NOR PIW	KAZIMIERZ NORMALNE PIWO BUT. 0,5 L	5906660570448	51	szt	0.77	RE-07-01	2024-12-09	0	51
945	KAZ ORA	KAZIMIERZ ORANGE BUT. 0,5 L	5906660570011	60	szt	0.77	RE-08-01	2024-12-09	0	60
946	KAZ PIL	KAZIMIERZ PILSIWKO BUT. 0,5 L	5906660570219	88	szt	0.77	RE-08-01	2024-12-09	0	88
947	KAZ SPI	KAZIMIERZ SPICHLERZ EUROPY BUT. 0,5 L	5906660570158	74	szt	0.77	RE-08-01	2024-12-09	0	74
948	KAZ_SZK_BUT_500	KAZIMIERZ SZKLANKOWY KIWOGREST BUT. 0,5 L	5906660570462	4	szt	0.77	AT-28-02	2024-12-09	0	4
949	KAZ ZER	KAZIMIERZ ZERRO% BUT. 0,5 L	5906660570479	140	szt	0.77	RE-17-00	2024-12-09	0	140
950	KAZ ŻYT	KAZIMIERZ ŻYTKO BUT. 0,5 L	5906660570059	181	szt	0.77	RE-18-00	2024-12-09	0	181
951	KEG AYI	KEG AYINGER / HOSL 30 L	5123456792012	38	szt	0.00	RE-08-01	2024-12-09	0	38
953	KAT03714	KEG BELGIA A5	5123456792003	48	szt	0.00	RE-09-01	2024-12-09	0	48
954	KAT01500ref	KEG BELGIA A6	5123456792004	14	szt	0.00	RE-08-01	2024-12-09	0	14
955	KEG BZC	KEG BROWAR ZAMKOWY CIESZYN 30 L	5123456792016	75	szt	0.00	RE-09-01	2024-12-09	0	75
956	KEG CZ BOZ	KEG CZECHY (B) 30 L	\N	10	szt	0.00	AT-28-02	2024-12-09	0	10
957	KEG CZ DAR	KEG CZECHY (D) 30 L	\N	43	szt	0.00	RE-09-01	2024-12-09	0	43
958	KEG_DU_BO	KEG DU BOCQ 20L	\N	7	szt	0.00	AT-28-03	2024-12-09	0	7
959	KEG FOR	KEG FORTUNA 30 L	5123456792017	34	szt	0.00	RE-09-01	2024-12-09	0	34
960	KEG_GD	KEG GULDEN DRAK 20 L	\N	2	szt	0.00	AT-28-02	2024-12-09	0	2
961	KEG INBEV	KEG INBEV 20L	5123456792007	80	szt	0.00	RE-09-01	2024-12-09	0	80
962	KEG LIND	KEG LINDEMANS 20/25 L	5123456792018	167	szt	0.00	RE-17-00	2024-12-09	0	167
963	KAT01516ref	KEG PERFECTDRAFT 6L	5123456792000	169	szt	0.00	RE-18-00	2024-12-09	0	169
964	KEG_PIR	KEG PIRAAT 20 L	\N	4	szt	0.00	AT-28-03	2024-12-09	0	4
965	KEG SCHLEN	KEG SCHLENKERLA 30 L	5123456792019	10	szt	0.00	AT-28-03	2024-12-09	0	10
966	KEG SCH	KEG SCHNEIDER 20 L	5123456792020	25	szt	0.00	RE-10-01	2024-12-09	0	25
967	KEG SVI	KEG SVIJANY 30 L	\N	6	szt	0.00	AT-28-03	2024-12-09	0	6
968	KENT SHA	KENT FALLS SHADOW PYRAMIDS BUT. 0,5 L	5123456790145	1	szt	0.77	AT-28-02	2024-12-09	0	1
969	KING MUL 330	KING MULE BUT. 0,33 L	5413699206519	48	szt	0.50	RE-10-01	2024-12-09	0	48
970	KING MUL TAP HAN	KING MULE TAP HANDLE	5123456791351	4	szt	0.00	AT-28-03	2024-12-09	0	4
971	KING ATA	KINGPIN ATAVISTIC PUSZKA 0,5 L	5904730290821	420	szt	0.54	RE-19-00	2024-12-09	0	420
972	KING BUR	KINGPIN BURLESCA BUT. 0,33 L	5904730290180	43	szt	0.50	RE-10-01	2024-12-09	0	43
973	KING FID	KINGPIN FIDELITY PUSZKA 0,5 L	5904730290777	75	szt	0.54	RE-10-01	2024-12-09	0	75
1065	LHG TOR	LHG TORBA	5123456791357	2	szt	0.00	AT-28-04	2024-12-09	0	2
974	KIN_FRE_PUSZ_500	KINGPIN FREE RIDE PUSZKA 0,5 L	5904730290272	218	szt	0.54	RF-01-00	2024-12-09	0	218
975	KING GOR	KINGPIN GORDITO PUSZKA 0,5 L	5904730290937	86	szt	0.54	RE-10-01	2024-12-09	0	86
976	KING LUN_PROM	KINGPIN LUNATIC BUT. 0,5 L PROMOCJA (do 13.10.23)	\N	76	szt	0.00	RE-11-01	2024-12-09	0	76
977	KING MAN	KINGPIN MANDARIN BUT. 0,5 L	5904730290074	190	szt	0.77	RE-18-00	2024-12-09	0	190
978	KING MAR	KINGPIN MARQUIS BUT. 0,33 L	5904730290555	16	szt	0.50	RE-09-01	2024-12-09	0	16
979	KIN_MEL_PUSZ_500	KINGPIN MELT PUSZKA 0,5 L	5904730290036	91	szt	0.54	RE-11-01	2024-12-09	0	91
980	KING PIL	KINGPIN PILS BUT 0,5 L	5904730290692	38	szt	0.00	RE-11-01	2024-12-09	0	38
981	KIN_PLU_PUSZ_500	KINGPIN PLUSH PUSZKA 0,5 L	5904730290418	8	szt	0.54	AT-28-03	2024-12-09	0	8
982	KING POR	KINGPIN PORTER BAŁTYCKI BUT. 0,5 L	5904730290791	310	szt	0.77	RF-01-00	2024-12-09	0	310
983	KIN_REC_PUSZ_500	KINGPIN RECKLESS PUSZKA 0,5 L	5904730290227	388	szt	0.54	RF-02-00	2024-12-09	0	388
984	KING WEI	KINGPIN WEIZEN BUT. 0,5 L	5904730290746	35	szt	0.77	RE-11-01	2024-12-09	0	35
985	KIN_ZIP_PUSZ_500	KINGPIN ZIPPY PUSZKA 0,5 L	5904730290258	355	szt	0.54	RF-03-00	2024-12-09	0	355
986	MIŁ KOM BAR	KOMES BARLEY WINE BUT. 0,5 L	5902838990285	40	szt	0.77	RE-11-01	2024-12-09	0	40
987	MIŁ KOM IMP IPA	KOMES IMPERIAL IPA BUT. 0,5 L	5902838990636	44	szt	0.77	RE-12-01	2024-12-09	0	44
988	MIŁ KOM POC	KOMES POCZWÓRNY BUT. 0,5 L	5901687910208	15	szt	0.77	RE-10-01	2024-12-09	0	15
989	MIŁ KOM POR PŁA DĘB	KOMES PORTER BAŁTYCKI PŁATKI DĘBOWE BUT. 0,5 L	5901687910826	113	szt	0.77	RE-19-00	2024-12-09	0	113
990	MIŁ KOM POR BOU 500	KOMES PORTER BOURBON OAK BUT. 0,5 L	5902838991244	14	szt	0.77	RE-11-01	2024-12-09	0	14
991	MIŁ KOM POR MAL	KOMES PORTER MALINOWY BUT. 0,5 L	5901687910833	45	szt	0.77	RE-12-01	2024-12-09	0	45
993	KOM WYM OLD BA	KOMES WYMRAŻANY BARLEY WINE OLD FORESTER BA BUT. 0,33 L	5902838991411	38	szt	0.50	RE-12-01	2024-12-09	0	38
994	KOM_WYM_POR_BA_BUT_330	KOMES WYMRAŻANY PORTER BAŁTYCKI JACK DANIEL'S BA BUT. 0,33 L	5902838991428	36	szt	0.50	RE-12-01	2024-12-09	0	36
995	KOM_WYM_POR_MAL_BUT_330	KOMES WYMRAŻANY PORTER MALINOWY WHISKEY BA BUT. 0,33 L	5902838991541	42	szt	0.50	RE-12-01	2024-12-09	0	42
996	MIŁ KOM ZES KON 4 + POK	KOMES ZESTAW KONESERA 4 PIWA 0,5 L + POKAL	5901687910857	34	szt	0.00	RE-12-01	2024-12-09	0	34
997	KORM 1_100	KORMORAN 1 NA 100 LITE RYE APA BUT. 0,5 L	5902528052347	449	szt	0.77	RF-04-00	2024-12-09	0	449
998	KORM 1_100 P+M	KORMORAN 1 NA 100 PIGWOWIEC + MIÓD BUT. 0,5 L	5902528523311	153	szt	0.77	RF-03-00	2024-12-09	0	153
999	KOR_6PAK_SLI_BUT_375_PROM	KORMORAN 6-PAK ŚLIWKA W PIWIE  BUT. 0,375 L PROMOCJA (do 11.10.23)	\N	38	szt	0.00	RE-13-01	2024-12-09	0	38
1000	KOR_6PAK_SWI_BUT_375_PROM	KORMORAN 6-PAK ŚWIEŻE BUT. 0,375 L PROMOCJA (do 10.10.23)	\N	31	szt	0.00	RE-13-01	2024-12-09	0	31
1001	KORM AST 2019	KORMORAN ASTUS MALUM BUT. 0,375 L	5902528000348	37	szt	0.50	RE-13-01	2024-12-09	0	37
1002	KORM BARL	KORMORAN BARLOW SORBUS  BUT. 0,375 L	5902528000409	40	szt	0.50	RE-13-01	2024-12-09	0	40
1003	KORM BEZ	KORMORAN BEZGLUTENOWE BUT. 0,5 L	5902528442230	313	szt	0.77	RF-05-00	2024-12-09	0	313
1004	KOR_COP_BUT_500	KORMORAN COPERNIKUS BUT. 0,5 L	5902528000157	16	szt	0.77	RE-13-01	2024-12-09	0	16
1005	KOR_COP_TUB_BUT_500	KORMORAN COPERNIKUS TUBA BUT. 0,5 L	5902528208584	20	szt	0.77	RE-13-01	2024-12-09	0	20
1006	KORM COR LUP	KORMORAN CORNUS LUPUS BUT. 0,375 L	5902528000553	29	szt	0.50	RE-14-01	2024-12-09	0	29
1007	KORM PRU	KORMORAN IMPERIUM PRUNUM BUT. 0,375 L	5902528342387	27	szt	0.50	RE-14-01	2024-12-09	0	27
1008	KORM IRI	KORMORAN IRISH BEER BUT. 0,5 L	5902528300004	25	szt	0.77	RE-14-01	2024-12-09	0	25
1009	KORM JAS	KORMORAN JASNY BUT. 0,5 L	5902528462337	1	szt	0.77	AT-28-02	2024-12-09	0	1
1010	KORM KRZ	KORMORAN KRZEPKIE BUT. 0,5 L	5902528573354	42	szt	0.77	RE-14-01	2024-12-09	0	42
1011	KORM KRZ_PROM	KORMORAN KRZEPKIE BUT. 0,5 L PROMOCJA (do 10.19.23)	\N	1	szt	0.00	AT-28-02	2024-12-09	0	1
1012	KORM MIO	KORMORAN MIODNE BUT. 0,5 L	5902528431210	57	szt	0.77	RE-14-01	2024-12-09	0	57
1013	KORM POR 500	KORMORAN PORTER WARMIŃSKI BUT. 0,5 L	5902528420016	34	szt	0.77	RE-14-01	2024-12-09	0	34
1014	KORM RAD GOR POM	KORMORAN RADLER GORZKA POMARAŃCZA BUT. 0,5 L	5902528119828	97	szt	0.77	RE-15-01	2024-12-09	0	97
1015	KORM REW	KORMORAN REWOLUCJE WARMIŃSKIE BUT. 0,5 L	5902528999994	25	szt	0.77	RE-15-01	2024-12-09	0	25
1016	KORM ŚWIEŻE	KORMORAN ŚWIEŻE BUT. 0,5 L	5902528001093	182	szt	0.77	RF-05-00	2024-12-09	0	182
1017	KORM TER BRA	KORMORAN TERRA DONUM BRAGGOT BUT. 0,375 L	5902528000447	27	szt	0.50	RE-15-01	2024-12-09	0	27
1018	KORM WIŚ	KORMORAN WIŚNIA W PIWIE BUT. 0,5 L	5902528410000	40	szt	0.77	RE-15-01	2024-12-09	0	40
1019	KORM ZŁO	KORMORAN ZŁOTY EXPORT LAGER BUT. 0,5 L	5902528000065	34	szt	0.77	RE-15-01	2024-12-09	0	34
1020	KORM ZŁO_PROM	KORMORAN ZŁOTY EXPORT LAGER BUT. 0,5 L PROMOCJA (do 17.10.23)	\N	1	szt	0.00	AT-28-03	2024-12-09	0	1
1021	KRA IRL CIE	KRAJAN IRLANDZKIE CIEMNE BUT. 0,5 L	5907582579410	504	szt	0.77	RA-04-04	2024-12-09	0	504
1022	KRA_IRL_CZER_BUT_500	KRAJAN IRLANDZKIE CZERWONE BUT. 0,5 L	5907804436248	100	szt	0.77	RE-16-01	2024-12-09	0	100
1023	KRA IRL JAS	KRAJAN IRLANDZKIE JASNE BUT. 0,5 L	5907582579434	195	szt	0.77	RF-06-00	2024-12-09	0	195
1024	KRA IRL ZIE	KRAJAN IRLANDZKIE ZIELONE BUT. 0,5 L	5907804436071	595	szt	0.77	RA-06-04	2024-12-09	0	595
1025	KWA PIT BLO 330	KWAREMONT PITTING BLOND BUT. 0,33 L	5411831000957	9	szt	0.50	AT-28-03	2024-12-09	0	9
1026	LA CHO BLA 330	LA CHOUFFE BLANCHE BUT. 0,33 L	5410769800820	310	szt	0.50	RF-06-00	2024-12-09	0	310
1027	LA CHO BLO 330	LA CHOUFFE BLONDE BUT. 0,33 L	5410769100081	1168	szt	0.50	RA-07-02	2024-12-09	0	1168
1028	LA CHO BLO 750	LA CHOUFFE BLONDE BUT. 0,75 L	5410769100098	205	szt	1.10	RF-07-00	2024-12-09	0	205
1029	488	LA CHOUFFE POKAL 0,33 L	5123456791079	79	szt	0.00	RE-16-01	2024-12-09	0	79
1030	LA COR BLO	LA CORNE BLONDE BUT. 0,33 L	5425026610005	31	szt	0.50	RE-15-01	2024-12-09	0	31
1031	TRAP BLO 330	LA TRAPPE BLONDE BUT. 0,33 L	8711406032602	272	szt	0.50	RF-07-00	2024-12-09	0	272
1032	TRAP BLO 750	LA TRAPPE BLONDE BUT. 0,75 L	8711406121580	126	szt	1.10	RF-02-00	2024-12-09	0	126
1033	TRAP BOCK 750	LA TRAPPE BOCKBIER BUT. 0,75 L	8711406136638	18	szt	1.10	RE-16-01	2024-12-09	0	18
1034	TRAP DUB 330	LA TRAPPE DUBBEL BUT 0,33 L	8711406000564	1400	szt	0.00	AT-12	2024-12-09	0	1400
1035	TRAP DUB 750	LA TRAPPE DUBBEL BUT. 0,75 L	8711406129777	85	szt	1.10	RE-16-01	2024-12-09	0	85
1036	TRAP FLA	LA TRAPPE FLAGA	5123456791149	1	szt	0.00	AT-28-03	2024-12-09	0	1
1037	TRAP IS 330	LA TRAPPE ISID`OR BUT. 0,33 L	8711406031681	153	szt	0.50	RF-08-00	2024-12-09	0	153
1038	TRAP IS 750	LA TRAPPE ISID`OR BUT. 0,75 L	8711406136775	176	szt	1.10	RF-08-00	2024-12-09	0	176
1039	547	LA TRAPPE KIELICH 0,25 L	5123456791184	106	szt	0.00	RF-08-00	2024-12-09	0	106
1040	TRAP QUA 330	LA TRAPPE QUADRUPEL BUT. 0,33 L	8711406022207	211	szt	0.50	RF-09-00	2024-12-09	0	211
1041	TRAP QUA 750	LA TRAPPE QUADRUPEL BUT. 0,75 L	8711406135723	104	szt	1.10	RF-08-00	2024-12-09	0	104
1042	TRAP TAP HAN	LA TRAPPE TAP HANDLE	5123456791361	2	szt	0.00	AT-28-03	2024-12-09	0	2
1043	TRAP TRI 750	LA TRAPPE TRIPEL BUT. 0,75 L	8711406137192	57	szt	1.10	RE-17-01	2024-12-09	0	57
1044	TRAP WIT 33	LA TRAPPE WITTE BUT. 0,33 L	8711406985489	251	szt	0.50	RF-09-00	2024-12-09	0	251
1045	KAT06264	LA TRAPPE WITTE TRAPPIST BUT. 0,75 L	8711406103876	251	szt	1.10	RF-10-00	2024-12-09	0	251
1046	TRAP_ZEST_BLO_QUA_2X750	LA TRAPPE ZESTAW (2X BUT. 0,75 L BLOND/QUADRUPEL)	8711406567685	42	szt	0.00	RE-17-01	2024-12-09	0	42
1047	TRAP_ZEST_3X330	LA TRAPPE ZESTAW (3x BUT. 0,33L BLOND/DUBBEL/TRIPLE + SZKŁO)	8711406566718	21	szt	0.00	RE-17-01	2024-12-09	0	21
1048	TRAP_ZEST_4X330	LA TRAPPE ZESTAW (4x BUT. 0,33L QUADRUPEL/ISID'OR/TRIPEL/DUBBEL + SZKŁO)	8711406009413	36	szt	0.00	RE-17-01	2024-12-09	0	36
1049	TRAP ZEST 6X330	LA TRAPPE ZESTAW (6X BUT. 0,33L WITTE/BLOND/DUBBEL/ISID`OR/TRIPEL/QUADRUPEL)	8711406344248	55	szt	0.00	RE-17-01	2024-12-09	0	55
1050	KAT00389	LAMORAL POKAL 0,33 L	5123456791076	1	szt	0.00	AT-28-03	2024-12-09	0	1
1051	LEE DOG	LEELANAU / EVIL TWIN / JOLLY PUMPKIN THE DOGMATIST BUT. 0,375 L	5123456790146	5	szt	0.50	AT-28-03	2024-12-09	0	5
1052	LEF BLO 330	LEFFE BLONDE BUT. 0,33 L	5410228142089	178	szt	0.50	RF-10-00	2024-12-09	0	178
1053	LEF BLO 750	LEFFE BLONDE BUT. 0,75 L	5410228102762	244	szt	1.10	RF-11-00	2024-12-09	0	244
1054	LEF BLO K 20	LEFFE BLONDE KEG 20 L	5123456789017	1	szt	21.50	AT-28-03	2024-12-09	0	1
1055	LEF BRU 330	LEFFE BRUNE BUT. 0,33 L	5410228146162	484	szt	0.50	RF-12-00	2024-12-09	0	484
1056	LEF BRU 750	LEFFE BRUNE BUT. 0,75 L	5410228145226	49	szt	1.10	RE-17-01	2024-12-09	0	49
1057	329	LEFFE RUBY KEG 6 L	5410228200147	1	szt	0.00	AT-28-03	2024-12-09	0	1
1058	LEF TRI 330	LEFFE TRIPLE BUT. 0,33 L	5410228145912	132	szt	0.50	RF-11-00	2024-12-09	0	132
1059	OMB Ler Hip	LERVIG HIPSTER FOR CHRISTMAS 2020 PUSZKA 0,33 L	7072712006406	7	szt	0.35	AT-28-03	2024-12-09	0	7
1060	OMB Ler Kon	LERVIG KONRADS STOUT PUSZKA 0,33 L	7072712000763	3	szt	0.35	AT-28-03	2024-12-09	0	3
1061	LER MAT BAR	LERVIG MATA BAROWA	5123456791367	1	szt	0.00	AT-28-04	2024-12-09	0	1
1062	OMB Ler Ori	LERVIG ORIGINAL SIN PUSZKA 0,33 L	7072712006505	22	szt	0.35	RE-18-01	2024-12-09	0	22
1063	Ler Rac Off	LERVIG RACKHOUSE OFF THE RACK PARAGON 2020 BUT. 0,75 L	7072712008639	1	szt	1.10	AT-28-04	2024-12-09	0	1
1064	LES INT MAN MIL BIE	LES INTENABLES MANU MILITARI BIERE PUSZ. 0,33 L	3770017907445	5	szt	0.00	AT-28-04	2024-12-09	0	5
1066	LIEF FRU 250	LIEFMANS FRUITESSE BUT. 0,25 L	5411686700118	2	szt	0.35	AT-28-04	2024-12-09	0	2
1067	LIMB WIT CZA DAS	LIMBURGSE WITTE CZAPKA Z DASZKIEM	5123456791348	5	szt	0.00	AT-28-04	2024-12-09	0	5
1068	LIMB WIT FLA	LIMBURGSE WITTE FLAGA	5123456791358	2	szt	0.00	AT-28-04	2024-12-09	0	2
1069	LIMB WIT K 20	LIMBURGSE WITTE KEG 20 L	24242424	27	szt	21.50	RE-18-01	2024-12-09	0	27
1070	LIMB WIT LEM K 20	LIMBURGSE WITTE LEMON KEG 20 L	\N	1	szt	21.50	AT-28-04	2024-12-09	0	1
1071	LIMB WIT MAT BAR	LIMBURGSE WITTE MATA BAROWA	5123456791349	5	szt	0.00	AT-28-04	2024-12-09	0	5
1072	LIMB WIT PEA APP 330	LIMBURGSE WITTE PEAR APPLE BUT. 0,33 L	5413699165151	13	szt	0.50	RE-16-01	2024-12-09	0	13
1073	LIMB WIT POK 250	LIMBURGSE WITTE POKAL 0,25 L	5123456791074	47	szt	0.00	RE-18-01	2024-12-09	0	47
1074	LIMB WIT POK 330	LIMBURGSE WITTE POKAL 0,33 L	5123456789853	74	szt	0.00	RE-18-01	2024-12-09	0	74
1075	LIMB WIT POK 500	LIMBURGSE WITTE POKAL 0,5 L	5123456791073	6	szt	0.00	AT-28-04	2024-12-09	0	6
1076	LIMB WIT TAP HAN	LIMBURGSE WITTE TAP HANDLE	5123456791368	1	szt	0.00	AT-28-04	2024-12-09	0	1
1077	LIND SPO 750	LINDEMANS / MIKKELLER SPONTANBASIL BUT. 0,75 L	5411223010571	99	szt	1.10	RE-18-01	2024-12-09	0	99
1078	LIND APP 250	LINDEMANS APPLE BUT. 0,25 L	5411223100579	407	szt	0.35	RF-13-00	2024-12-09	0	407
1079	LIND APP 355	LINDEMANS APPLE BUT. 0,355 L	5411223101095	456	szt	0.00	RF-14-00	2024-12-09	0	456
1080	LIND APP K 20 L	LINDEMANS APPLE KEG 20 L	5123456789028	7	szt	21.50	AT-28-04	2024-12-09	0	7
1081	LIND TAP HAN APP	LINDEMANS APPLE TAP HANDLE	5123456791354	4	szt	0.00	AT-28-04	2024-12-09	0	4
1082	KAT06614	LINDEMANS BEARDY HIPSTER T-SHIRT (L)	5123456791148	1	szt	0.00	AT-28-04	2024-12-09	0	1
1083	KAT05455	LINDEMANS BEARDY HIPSTER T-SHIRT (M)	5123456791147	1	szt	0.00	AT-28-04	2024-12-09	0	1
1084	KAT06615	LINDEMANS BEARDY HIPSTER T-SHIRT (S)	5123456791146	2	szt	0.00	AT-28-04	2024-12-09	0	2
1085	KAT06616	LINDEMANS BEARDY HIPSTER T-SHIRT (XXL)	5123456791144	2	szt	0.00	AT-28-04	2024-12-09	0	2
1086	KAT05472	LINDEMANS BLACHA	5123456791142	20	szt	0.00	RE-18-01	2024-12-09	0	20
1087	KAT06124	LINDEMANS BLACHA OUD GUEUZE	5123456791141	8	szt	0.00	AT-28-04	2024-12-09	0	8
1088	LIND CAS 250	LINDEMANS CASSIS BUT. 0,25 L	5411223100555	1317	szt	0.35	AT-12	2024-12-09	0	1317
1089	LIND CAS 355	LINDEMANS CASSIS BUT. 0,355 L	5411223101088	248	szt	0.00	RF-15-00	2024-12-09	0	248
1090	LIND CAS K-KEG 20	LINDEMANS CASSIS K-KEG 20 L	\N	12	szt	21.50	RE-19-01	2024-12-09	0	12
1091	LIND_CAS_MED	LINDEMANS CASSIS MEDALION RYBIE OKO	\N	1	szt	0.00	AT-28-04	2024-12-09	0	1
1092	LIND TAP HAN CAS	LINDEMANS CASSIS TAP HANDLE	5123456791017	3	szt	0.00	AT-28-04	2024-12-09	0	3
1093	KAT06809	LINDEMANS DZBANEK (PIASKOWY) 1 L	5123456791140	7	szt	0.00	AT-28-04	2024-12-09	0	7
1094	LIND FAR 250	LINDEMANS FARO BUT. 0,25 L	5411223101019	17	szt	0.35	RE-19-01	2024-12-09	0	17
1095	LIND FAR 355	LINDEMANS FARO BUT. 0,355 L	5411223101057	128	szt	0.00	RF-11-00	2024-12-09	0	128
1096	LIND FAR 750	LINDEMANS FARO BUT. 0,75 L	5411223020204	66	szt	1.10	RE-19-01	2024-12-09	0	66
1097	LIND FAR K 20	LINDEMANS FARO KEG 20 L	5123456789030	3	szt	21.50	AT-28-04	2024-12-09	0	3
1098	LIND_FAR_MED	LINDEMANS FARO MEDALION RYBIE OKO	\N	1	szt	0.00	AT-28-04	2024-12-09	0	1
1099	140	LINDEMANS FARO SZKLANKA 0,25 L	5123456791040	36	szt	0.00	RE-19-01	2024-12-09	0	36
1100	LIND FAR TAP HAN	LINDEMANS FARO TAP HANDLE	5123456791016	2	szt	0.00	AT-28-04	2024-12-09	0	2
1101	KAT05485	LINDEMANS FLAGA	5123456791139	8	szt	0.00	AT-29-00	2024-12-09	0	8
1102	LIND FRA 250	LINDEMANS FRAMBOISE BUT. 0,25 L	5411223100487	2683	szt	0.35	AT-13	2024-12-09	0	2683
1103	LIND FRA 355	LINDEMANS FRAMBOISE BUT. 0,355 L	5411223101064	209	szt	0.00	RF-15-00	2024-12-09	0	209
1104	LIND FRA 750	LINDEMANS FRAMBOISE BUT. 0,75 L	5411223005249	79	szt	1.10	RE-19-01	2024-12-09	0	79
1105	LIND_FRA_KEG_25	LINDEMANS FRAMBOISE KEG 25 L	\N	4	szt	28.00	AT-28-04	2024-12-09	0	4
1106	LIND_FRA_MED	LINDEMANS FRAMBOISE MEDALION RYBIE OKO	\N	1	szt	0.00	AT-29-00	2024-12-09	0	1
1107	LIND FRA TAP HAN	LINDEMANS FRAMBOISE TAP HANDLE	5123456791359	3	szt	0.00	AT-29-00	2024-12-09	0	3
1108	LIND GIN GUE 750	LINDEMANS GINGER GUEUZE BUT. 0,75 L	5411223100036	126	szt	1.10	RF-13-00	2024-12-09	0	126
1109	LIND GOY 750	LINDEMANS GOYCK BUT. 0,75 L	5430001057010	40	szt	1.10	RE-19-01	2024-12-09	0	40
1110	LIND GUE 250	LINDEMANS GUEUZE BUT. 0,25 L	5411223101002	129	szt	0.35	RF-16-00	2024-12-09	0	129
1111	LIND GUE CUV 375	LINDEMANS GUEUZE CUVEE RENE BUT. 0,375 L	5411223100999	101	szt	0.50	RD-16-00	2024-12-09	0	101
1112	LIND GUE CUV 750	LINDEMANS GUEUZE CUVEE RENE BUT. 0,75 L	5411223020709	39	szt	1.10	RF-01-01	2024-12-09	0	39
1113	226	LINDEMANS GUEUZE SZKLANKA 0,25 L	5123456791039	150	szt	0.00	RF-16-00	2024-12-09	0	150
1114	LIND GUE TAP HAN	LINDEMANS GUEUZE TAP HANDLE	5123456791015	1	szt	0.00	AT-29-00	2024-12-09	0	1
1115	113	LINDEMANS KIELISZEK 3-IN-1 0,25 L	5123456791171	38	szt	0.00	RF-01-01	2024-12-09	0	38
1116	KAT02956	LINDEMANS KOSZULA MĘSKA (XL)	5123456791158	1	szt	0.00	AT-29-00	2024-12-09	0	1
1117	LIND KRI 250	LINDEMANS KRIEK BUT. 0,25 L	5411223100463	3429	szt	0.35	AT-14	2024-12-09	0	3429
1118	LIND KRI 355	LINDEMANS KRIEK BUT. 0,355 L	5411223101033	687	szt	0.00	RA-07-03	2024-12-09	0	687
1119	LIND KRI 750	LINDEMANS KRIEK BUT. 0,75 L	5411223100920	476	szt	1.10	RF-17-00	2024-12-09	0	476
1120	LIND KRIE CUV 750	LINDEMANS KRIEK CUVEE RENE BUT. 0,75 L	5411223020778	107	szt	1.10	RF-10-00	2024-12-09	0	107
1121	LIND KRI K 25	LINDEMANS KRIEK KEG 25 L	5123456789024	52	szt	28.00	RF-01-01	2024-12-09	0	52
1122	LIND_KRI_MED	LINDEMANS KRIEK MEDALION RYBIE OKO	\N	1	szt	0.00	AT-29-00	2024-12-09	0	1
1123	LIND KRI TAP HAN	LINDEMANS KRIEK TAP HANDLE	5123456791014	4	szt	0.00	AT-29-00	2024-12-09	0	4
1124	KAT06780	LINDEMANS KUBEK 0,33 L	5123456791151	48	szt	0.00	RF-01-01	2024-12-09	0	48
1125	KAT06125	LINDEMANS LEŻAK PLAŻOWY	5123456791138	6	szt	0.00	AT-29-00	2024-12-09	0	6
1126	KAT06835	LINDEMANS MAŁA TABLICA	5123456791127	7	szt	0.00	AT-29-00	2024-12-09	0	7
1127	LIN MAT BAR	LINDEMANS MATA BAROWA 57/13	5123456791137	3	szt	0.00	AT-29-00	2024-12-09	0	3
1128	KAT03218	LINDEMANS METALOWE PUDEŁKO PREZENTOWE	5123456791126	3	szt	0.00	AT-29-00	2024-12-09	0	3
1129	KAT05478	LINDEMANS NEON	5123456791136	5	szt	0.00	AT-29-00	2024-12-09	0	5
1130	KAT05476	LINDEMANS OTWIERACZ	5123456791135	9	szt	0.00	AT-29-00	2024-12-09	0	9
1131	LIND PEC 250	LINDEMANS PECHERESSE BUT. 0,25 L	5411223100838	300	szt	0.35	RF-18-00	2024-12-09	0	300
1132	LIND PEC 355	LINDEMANS PECHERESSE BUT. 0,355 L	5411223101071	151	szt	0.00	RF-16-00	2024-12-09	0	151
1133	LIND PEC 750	LINDEMANS PECHERESSE BUT. 0,75 L	5411223100876	212	szt	1.10	RF-18-00	2024-12-09	0	212
1134	LIND PEC K 20 L	LINDEMANS PECHERESSE KEG 20 L	5123456789032	8	szt	21.50	AT-29-00	2024-12-09	0	8
1135	LIND_PEC_MED	LINDEMANS PECHERESSE MEDALION RYBIE OKO	\N	1	szt	0.00	AT-29-00	2024-12-09	0	1
1136	LIND PEC TAP HAN	LINDEMANS PECHERESSE TAP HANDLE	5123456791013	3	szt	0.00	AT-29-00	2024-12-09	0	3
1137	LIN PODS	LINDEMANS PODSTAWKA NA PODKŁADKI	5123456791327	35	szt	0.00	RF-01-01	2024-12-09	0	35
1138	LIND POK SEN 250	LINDEMANS POKAL SENSORIK  0,25 L	5123456791229	73	szt	0.00	RF-01-01	2024-12-09	0	73
1139	LIND POK SEN 500	LINDEMANS POKAL SENSORIK 0,5 L	5123456791003	149	szt	0.00	RF-19-00	2024-12-09	0	149
1140	LIND POK SEN 200 ANN 250	LINDEMANS POKAL SENSORIK 200 ANNIVERSARY 0,25 L	5123456791132	112	szt	0.00	RF-19-00	2024-12-09	0	112
1141	KAT05479	LINDEMANS POTYKACZ	5123456791133	6	szt	0.00	AT-29-00	2024-12-09	0	6
1142	LIND SUM TAP HAN	LINDEMANS SUMMERBERRY TAP HANDLE	5123456791012	2	szt	0.00	AT-29-00	2024-12-09	0	2
1143	LIND SZKL SPON 250	LINDEMANS SZKLANKA SPONTANBASIL 0,25 L	5123456791038	24	szt	0.00	RF-02-01	2024-12-09	0	24
1144	LIND TAB PODŚ	LINDEMANS TABLICA PODŚWIETLANA Z PODSTAWKĄ NA BUTELKI	5123456791370	2	szt	0.00	AT-29-00	2024-12-09	0	2
1145	KAT05473	LINDEMANS TACA	5123456791129	47	szt	0.00	RF-02-01	2024-12-09	0	47
1146	KAT06623	LINDEMANS TAP HANDLE (DREWNO) 28 CM	5123456791019	16	szt	0.00	RF-02-01	2024-12-09	0	16
1147	LIND_TAR_BLA	LINDEMANS TAROT BLACHA	\N	1	szt	0.00	AT-29-00	2024-12-09	0	1
1148	LIND_TAR_D'OR_BUT_250	LINDEMANS TAROT D'OR BUT. 0,25 L	5411223005317	2405	szt	0.35	AT-15	2024-12-09	0	2405
1149	LIND_TAR_D'OR_KEG_20	LINDEMANS TAROT D'OR KEG 20 L	\N	9	szt	21.50	AT-29-01	2024-12-09	0	9
1150	LIND_TAR_D'OR_MED	LINDEMANS TAROT D'OR MEDALION RYBIE OKO	\N	1	szt	0.00	AT-29-00	2024-12-09	0	1
1151	LIND_TAR_NOIR_BUT_250	LINDEMANS TAROT NOIR BUT. 0,25 L	5411223005300	2428	szt	0.35	AT-16	2024-12-09	0	2428
1152	LIND_TAR_NOIR_KEG_20	LINDEMANS TAROT NOIR KEG 20 L	\N	16	szt	21.50	RF-02-01	2024-12-09	0	16
1153	LIND_TAR_NOIR_MED	LINDEMANS TAROT NOIR MEDALION RYBIE OKO	\N	1	szt	0.00	AT-29-00	2024-12-09	0	1
1154	LIND_TAR_POK_330	LINDEMANS TAROT POKAL 0,33 L	\N	21	szt	0.00	RF-02-01	2024-12-09	0	21
1155	LIND_TSH_DAM_SZA_S	LINDEMANS T-SHIRT DAMSKI SZARY (S)	\N	2	szt	0.00	AT-29-00	2024-12-09	0	2
1156	LIND_TSH_MĘS_SZA_L	LINDEMANS T-SHIRT MĘSKI SZARY (L)	\N	1	szt	0.00	AT-29-00	2024-12-09	0	1
1157	LIND_TSH_MĘS_SZA_M	LINDEMANS T-SHIRT MĘSKI SZARY (M)	\N	1	szt	0.00	AT-29-01	2024-12-09	0	1
1158	LIND_TSH_MĘS_SZA_S	LINDEMANS T-SHIRT MĘSKI SZARY (S)	\N	2	szt	0.00	AT-29-01	2024-12-09	0	2
1159	770	LINDEMANS TUMBLER 0,25 L	5123456791131	23	szt	0.00	RF-02-01	2024-12-09	0	23
1160	KAT06836	LINDEMANS WIKLINOWY KOSZYK NA LAMBIKI	5123456791005	7	szt	0.00	AT-29-01	2024-12-09	0	7
1161	LIND ZES 1X375 + 3X 0,355  L+ SZ	LINDEMANS ZESTAW (1X BUT. 0,375 L + 3X BUT. 0,355 L + SZKŁO)	5411223002064	2	szt	0.00	AT-29-01	2024-12-09	0	2
1162	KAT07003	LINDEMANS ZIGZAG KORKOCIĄG W PUDEŁKU	5123456791128	6	szt	0.00	AT-29-01	2024-12-09	0	6
1163	LIN MOON KEG 20	L'INSTANT MOONSPELL KEG 20 L	\N	1	szt	21.50	AT-29-01	2024-12-09	0	1
1164	LIN WOR OF HOP	L'INSTANT WORLD OF HOPS PUSZ. 0,44 L	3770011969425	9	szt	0.00	AT-29-01	2024-12-09	0	9
1165	LIT_CER_CIT_BUT_500	LITOVEL ČERNY CITRON 4% BUT. 0,5 L	8593875518418	142	szt	0.77	RF-19-00	2024-12-09	0	142
1166	LIT_CER_CIT_BZW_BUT_500	LITOVEL ČERNY CITRON 4% BZW.  BUT. 0,5 L	8593875518418	135	szt	0.77	RF-19-00	2024-12-09	0	135
1167	LIT_CER_CITR_KEG_30	LITOVEL ČERNY CITRON 4% KEG 30 L	\N	2	szt	32.00	AT-29-01	2024-12-09	0	2
1168	LIT_CER_CIT_NALC_BUT_500	LITOVEL ČERNY CITRON NON-ALCO BUT. 0,5 L	8593875518210	18	szt	0.77	RF-03-01	2024-12-09	0	18
1169	LIT_MIOD_BUT_500	LITOVEL MIODOWY BUT. 0,5 L	8593875516711	265	szt	0.77	RG-01-00	2024-12-09	0	265
1170	LIT MOR K	LITOVEL MORAVAN 11° KEG 30 L	\N	4	szt	32.00	AT-29-01	2024-12-09	0	4
1171	LIT_PRE_BZW_BUT_500	LITOVEL PREMIUM 12° BZW. BUT. 0,5 L	8593875510115	339	szt	0.77	RG-02-00	2024-12-09	0	339
1172	LIT PRE K	LITOVEL PREMIUM 12° KEG 30 L	\N	1	szt	32.00	AT-29-01	2024-12-09	0	1
1173	LIT PSE LEZ K	LITOVEL PŠENIČNÝ LEŽÁK 11° KEG 30 L	5123456789886	3	szt	32.00	AT-29-01	2024-12-09	0	3
1174	BM LOC LEM	LOCO BEER LEMON GRASS NON ALCOHOL BUT. 0,33 L	5907694918367	27	szt	0.50	RF-03-01	2024-12-09	0	27
1175	BM_LOC_NAR_PUSZ_500	LOCO BEER NARANJA IPA PUSZKA 0,5 L	5907694918480	109	szt	0.54	RF-16-00	2024-12-09	0	109
1176	BM LOC TRO	LOCO BEER TROPICAL NON ALCOHOL BUT. 0,33 L	5907694918374	71	szt	0.50	RF-03-01	2024-12-09	0	71
1177	BM LOC CAN	LOCO CANNABIS BUT. 0,33 L	5907694918442	80	szt	0.50	RF-03-01	2024-12-09	0	80
1178	BM LOC ENE	LOCO ENERGY LEMON BUT. 0,33 L	5907694918381	2	szt	0.50	AT-29-01	2024-12-09	0	2
1179	LUB_AZE_PUSZ_330	LUBROW AZEDO FRUTADO PUSZKA 0,33 L	5903686842191	12	szt	0.35	RF-03-01	2024-12-09	0	12
1180	LUB_BER_PUSZ_330	LUBROW BERLIBERRY PUSZKA 0,33 L	5903686842894	107	szt	0.35	RG-01-00	2024-12-09	0	107
1181	LUB_BLE_NO2_PUSZ_330	LUBROW BLEND NO. 2 PUSZKA 0,33 L	5903686842870	103	szt	0.35	RG-01-00	2024-12-09	0	103
1182	LUB_CHM_PUSZ_330	LUBROW CHMIELEWSKI PUSZKA 0,33 L	5903686842696	40	szt	0.35	RF-03-01	2024-12-09	0	40
1183	LUB CRY_PROM	LUBROW CRYO APA EL DORADO PUSZKA 0,33 L PROMOCJA (do 14.10.23)	\N	25	szt	0.00	RF-04-01	2024-12-09	0	25
1184	LUB _DOB_PUSZ_330	LUBROW DOBRE TAKIE TROPIKALNE! PUSZKA 0,33 L	5903686842917	22	szt	0.35	RF-04-01	2024-12-09	0	22
1185	LUB_ECL_PUSZ_330	LUBROW ECLARON PILS PUSZKA 0,33 L	5903686842887	46	szt	0.35	RF-04-01	2024-12-09	0	46
1186	LUB_FOR_PUSZ_330	LUBROW FOREIGN EXTRA STOUT – NITRO CLASSIC ALES PUSZKA 0,33 L	5903686842795	55	szt	0.35	RF-04-01	2024-12-09	0	55
1187	LUB_GRU_PUSZ_330	LUBROW GRUBY BAMBER PUSZKA 0,33 L	5903686842924	82	szt	0.35	RF-04-01	2024-12-09	0	82
1188	LUB_INF_NO1_PUSZ_330	LUBROW INFUSED NO. 1 PUSZKA 0,33 L	5903686842832	33	szt	0.35	RF-04-01	2024-12-09	0	33
1189	LUB_INF_NO2_PUSZ_330	LUBROW INFUSED NO. 2 PUSZKA 0,33 L	5903686842863	65	szt	0.35	RF-05-01	2024-12-09	0	65
1190	LUB_LAG_PUSZ_330	LUBROW LAGERFEUER PUSZKA 0,33 L	5903686842757	36	szt	0.35	RF-05-01	2024-12-09	0	36
1191	LUB_LIG_PUSZ_330	LUBROW LIGHTHOUSE IPA PUSZKA 0,33 L	5903686842900	57	szt	0.35	RF-05-01	2024-12-09	0	57
1192	LUB_POL_GUR_2.0_PUSZ_330	LUBROW POLSKA GUROM 2.0 PUSZKA 0,33 L	5903686842825	20	szt	0.35	RF-05-01	2024-12-09	0	20
1193	LUB_POR_PUSZ_330	LUBROW PORTERITO PUSZKA 0,33 L	5903686842856	31	szt	0.35	RF-05-01	2024-12-09	0	31
1194	LUB_PRA_PUSZ_330	LUBROW PRAUSTBANDE'23 PUSZKA 0,33 L	5903686842504	65	szt	0.35	RF-05-01	2024-12-09	0	65
1195	LUB_SŁO_PUSZ_330	LUBROW SŁODOWY PUSZKA 0,33 L	5903686842702	62	szt	0.35	RF-06-01	2024-12-09	0	62
1196	LUB_SOU_PUSZ_330	LUBROW SOURHEAD MONKEY PUSZKA 0,33 L	5903686842948	74	szt	0.35	RF-06-01	2024-12-09	0	74
1197	LUB_TAR_PUSZ_330	LUBROW TARNICA 1346 PUSZKA 0,33 L	5903686842931	34	szt	0.35	RF-06-01	2024-12-09	0	34
1198	LUB_TRD_PUSZ_330	LUBROW TRDELNIK PUSZKA 0,33 L	5903686842726	24	szt	0.35	RF-06-01	2024-12-09	0	24
1199	LUB_WC_IPA_PUSZ_330	LUBROW WC IPA PUSZKA 0,33 L	5900779755123	59	szt	0.35	RF-06-01	2024-12-09	0	59
1200	LUB_WES_PUSZ_330	LUBROW WEST COAST HIGHWAY PUSZKA 0,33 L	5903686842627	130	szt	0.35	RG-02-00	2024-12-09	0	130
1201	LUB_ZOM_PUSZ_330	LUBROW ZOMBIE SABRO IPA PUSZKA 0,33 L	5903686842849	48	szt	0.35	RF-07-01	2024-12-09	0	48
1202	LUP BLO TRI 330	LUPULUS BLONDE TRIPLE BUT. 0,33 L	5425025122035	18	szt	0.50	RF-06-01	2024-12-09	0	18
1203	LUP HOP 330	LUPULUS HOPERA BUT. 0,33 L	5425025122011	30	szt	0.50	RF-07-01	2024-12-09	0	30
1204	LUP ORG 330	LUPULUS ORGANICUS BUT. 0,33 L	5425025122073	12	szt	0.50	RF-07-01	2024-12-09	0	12
1205	LUP ORG 750	LUPULUS ORGANICUS BUT. 0,75 L	5425025126002	33	szt	1.10	RF-07-01	2024-12-09	0	33
1206	LAN ACI	ŁAŃCUT ACIDUM FRUCTUS BUT. 0,5 L	5906395997886	1	szt	0.77	AT-29-01	2024-12-09	0	1
1207	LAN ANG	ŁAŃCUT ANGLOSAS BUT. 0,5 L	5906395997251	107	szt	0.77	RG-03-00	2024-12-09	0	107
1208	LAN POL	ŁAŃCUT CZARNA POLEWKA BUT. 0,5 L	5906395997008	50	szt	0.77	RF-07-01	2024-12-09	0	50
1209	LAN DIM	ŁAŃCUT DIMI3RI BUT. 0,33 L	5906395997732	53	szt	0.50	RF-07-01	2024-12-09	0	53
1210	LAN_DZI_BUT_500	ŁAŃCUT DZIKI RYE BUT. 0,5 L	5906395997954	92	szt	0.77	RF-08-01	2024-12-09	0	92
1211	LAN ZIM	ŁAŃCUT IDZIE ZIMA BUT. 0,5 L	5906395997107	13	szt	0.77	RF-08-01	2024-12-09	0	13
1212	LAN_LEM_BUT_500	ŁAŃCUT LEMUR PARADISE BUT. 0,5 L	5906395997961	103	szt	0.77	RG-03-00	2024-12-09	0	103
1213	LAN MIT	ŁAŃCUT MITYNG BUT. 0,5 L	5906395997091	204	szt	0.77	RG-03-00	2024-12-09	0	204
1214	LAN_MOP_BUT_500	ŁAŃCUT MOPS 'N' HOPS BUT. 0,5 L	5906395997992	131	szt	0.77	RG-04-00	2024-12-09	0	131
1215	LAN POR BBA	ŁAŃCUT PODBIPIĘTA PORTER IMPERIALNY BOURBON B.A. BUT. 0,33 L	5906395997633	32	szt	0.50	RF-08-01	2024-12-09	0	32
1216	LAN_POD_WOJ_BUT_500	ŁAŃCUT PODCHMIELONY WOJOWNIK BUT. 0,5 L	5906395997985	44	szt	0.77	RF-08-01	2024-12-09	0	44
1217	LAN_POP_BUT_500	ŁAŃCUT POPROSZĘ O DOLEWKĘ BUT. 0,5 L	5906395997978	223	szt	0.77	RG-04-00	2024-12-09	0	223
1218	LAN POS	ŁAŃCUT POSPOLITE RUSZENIE BUT. 0,5 L	5906395997015	330	szt	0.77	RG-05-00	2024-12-09	0	330
1219	LAN PSZ	ŁAŃCUT PSZEPAN BUT. 0,5 L	5906395997220	365	szt	0.77	RG-06-00	2024-12-09	0	365
1220	LAN RAJ	ŁAŃCUT RAJSKY PLYN BUT. 0,5 L	5906395997473	93	szt	0.77	RF-08-01	2024-12-09	0	93
1221	LAN ZAP	ŁAŃCUT ZAPOMNIANY DIABEŁ BUT. 0,33 L	5906395997879	73	szt	0.50	RF-09-01	2024-12-09	0	73
1222	MB_PAT_CHE_BUT_500_PROM	MADAME BARREL PATI CZECK BUT. 0,5 L PROMOCJA (do 30.09.23)	\N	5	szt	0.00	AT-29-01	2024-12-09	0	5
1224	MR_EVE_PRE3_PUSZ_500	MAGIC ROAD (EVERGREEN PRETTY)3 PUSZKA 0,5 L	5905204130773	4	szt	0.54	AT-29-01	2024-12-09	0	4
1225	MR_BEY_TIM_PUSZ_500	MAGIC ROAD BEYOND TIME PUSZKA 0,5 L	5905204131244	107	szt	0.54	RG-03-00	2024-12-09	0	107
1226	MR_BOC_LOR_PUSZ_440	MAGIC ROAD BOCK LORD HALLELUJAH PUSZKA 0,44 L	5905204130216	40	szt	0.48	RF-09-01	2024-12-09	0	40
1227	MR_BOR_LIM_BUT_330	MAGIC ROAD BORN TO BE JUICY LIMITED EDITION BUT. 0,33 L	5905204130445	32	szt	0.50	RF-09-01	2024-12-09	0	32
1228	MAG CHE_PROM	MAGIC ROAD CHERRY GIVEAWAY PUSZKA 0,5 L PROMOCJA (do 30.09.23)	\N	66	szt	0.00	RF-09-01	2024-12-09	0	66
1229	MR_CHO_BAR_2_HEA_DBA_PUSZ_330	MAGIC ROAD CHOCOLATE BAR VOL. 2 HEAVEN HILL & WILD TURKEY DBA PUSZKA 0,33 L	5905204130339	8	szt	0.35	AT-29-01	2024-12-09	0	8
1230	MR_CIT_GIV_PUSZ_500	MAGIC ROAD CITRUS GIVEAWAY PUSZKA 0,5 L	5905204130698	3	szt	0.54	AT-29-01	2024-12-09	0	3
1231	MR_COL_JUS_PIN_PUSZ_500	MAGIC ROAD COLOURS: JUST PINK PUSZKA 0,5 L	5905204131008	208	szt	0.54	RG-05-00	2024-12-09	0	208
1232	MR_DES_PUSZ_500	MAGIC ROAD DESTINATION NOWHERE PUSZKA 0,5 L	5905204131091	15	szt	0.54	RF-08-01	2024-12-09	0	15
1233	MR_EVE_PUSZ_500	MAGIC ROAD EVERGLOW PUSZKA 0,5 L	5905204130834	25	szt	0.54	RF-09-01	2024-12-09	0	25
1234	MR_FRE_PRE-KIW-PEA-PEA_PUSZ_500	MAGIC ROAD FREE PRETTY KIWI, PEAR, PEACH & SWEET ROLL PUSZKA 0,5 L	5905204130926	30	szt	0.54	RF-09-01	2024-12-09	0	30
1235	MR_FRE_PRE-MAN-PAS_PUSZ_500	MAGIC ROAD FREE PRETTY MANGO, PASSIONFRUIT & WHITE CHOCOLATE PUSZKA 0,5 L	5905204130933	5	szt	0.54	AT-29-01	2024-12-09	0	5
1236	MR_HAP_BIR_PUSZ_500	MAGIC ROAD HAPPY BIRTHDAY PRZYSTANEK BEMOWO PUSZKA 0,5 L	5905204130995	31	szt	0.54	RF-10-01	2024-12-09	0	31
1237	MR_HOT_OR_PUSZ_440	MAGIC ROAD HOT OR NOT? PUSZKA 0,44 L	5905204130896	64	szt	0.48	RF-10-01	2024-12-09	0	64
1238	MR_KIW_PUSZ_500	MAGIC ROAD KIWI? KIWI! PUSZKA 0,5 L	5905204130940	18	szt	0.54	RF-10-01	2024-12-09	0	18
1239	MR_NA_STO_PUSZ_500	MAGIC ROAD NA STO DWA SZKLANEK PUSZKA 0,5 L	5905204130711	77	szt	0.54	RF-10-01	2024-12-09	0	77
1240	MR_ONE_HUN_PUSZ_500	MAGIC ROAD ONE HUNDRED TOGETHER PUSZKA 0,5 L	5905204131084	40	szt	0.54	RF-10-01	2024-12-09	0	40
1241	MR_PER_BRE_JAC_BA_PUSZ_330	MAGIC ROAD PERFECT BREAKFAST JACK DANIELS BA PUSZKA 0,33 L	5905204130308	4	szt	0.35	AT-29-02	2024-12-09	0	4
1242	MR_PER_LUN_PUSZ_440	MAGIC ROAD PERFECT LUNCH PUSZKA 0,44 L	5905204130988	59	szt	0.48	RF-10-01	2024-12-09	0	59
1243	MR_PRE-CHE-CRA-BLA-ALM_PUSZ_500	MAGIC ROAD PRETTY CHERRY, CRANBERRY, BLACKBERRY & ALMONDS PUSZKA 0,5 L	5905204130810	6	szt	0.54	AT-29-02	2024-12-09	0	6
1244	MR_PRE-PIN-MAN-PIN_PUSZ_500	MAGIC ROAD PRETTY PINEAPPLE, MANGO, PINK GUAVA & PEANUT BUTTER PUSZKA 0,5 L	5905204130902	28	szt	0.54	RF-11-01	2024-12-09	0	28
1245	MR_PRE-STR-CHE-BLA_PUSZ_500	MAGIC ROAD PRETTY STRAWBERRY, CHERRY, BLACKCURRANT & MAPLE SYRUP PUSZKA 0,5 L	5905204130919	11	szt	0.54	RF-11-01	2024-12-09	0	11
1246	MR_SAW_PUSZ_500	MAGIC ROAD SAWA SAWA PUSZKA 0,5 L	5905204131107	12	szt	0.54	RF-11-01	2024-12-09	0	12
1247	MR_SEA_SAI_BUT_500_PROM	MAGIC ROAD SEASON FOR SAISON BUT. 0,5 L PROMOCJA (do 15.10.23)	\N	19	szt	0.00	RF-11-01	2024-12-09	0	19
1248	MR_SUM_BAN_PUSZ_500	MAGIC ROAD SUMMER BANGER PUSZKA 0,5 L	5905204131053	74	szt	0.54	RF-11-01	2024-12-09	0	74
1249	MR_SUN_PUSZ_500_PROM	MAGIC ROAD SUNRISE PUSZKA 0,5 L PROMOCJA (do 15.10.23)	\N	25	szt	0.00	RF-11-01	2024-12-09	0	25
1250	MR_ULT_LIM_BUT_330	MAGIC ROAD ULTIMATE COCONUT PRETTY LIMITED EDITION BUT. 0,33 L	5905204130452	23	szt	0.50	RF-12-01	2024-12-09	0	23
1251	MR_WE_KEE_PUSZ_500	MAGIC ROAD WE KEEP OUR PROMISES PUSZKA 0,5 L	5905204130148	21	szt	0.54	RF-12-01	2024-12-09	0	21
1252	MR_WICV_PUSZ_500	MAGIC ROAD WICKED PUSZKA 0,5 L	5905204130841	8	szt	0.54	AT-29-02	2024-12-09	0	8
1253	MR_WIL_ALE_BUT_500	MAGIC ROAD WILD ALE AGED IN WINE BARRELS BUT 0,75 L	\N	5	szt	0.00	AT-29-02	2024-12-09	0	5
1254	MR_WIL_PRE_RIO_PUSZ_330	MAGIC ROAD WILD PRETTY #10 RIOJA BARREL AGED PUSZKA 0,33 L	5905204130629	96	szt	0.35	RF-12-01	2024-12-09	0	96
1255	MR_WIL_PRE_DOU_PUSZ_330	MAGIC ROAD WILD PRETTY #11 DOUBLE BARREL AGED PUSZKA 0,33 L	5905204130636	108	szt	0.35	RG-04-00	2024-12-09	0	108
1256	MR_WON_TOU_PUSZ_500	MAGIC ROAD WON’T YOU TELL ME YOUR NAME? PUSZKA 0,5 L	5905204130605	19	szt	0.54	RF-12-01	2024-12-09	0	19
1257	MAL 10% 330	MALHEUR 10% BUT. 0,33 L	5413970200014	96	szt	0.50	RF-12-01	2024-12-09	0	96
1258	MALH 12% 330	MALHEUR 12% BUT. 0,33 L	5413970140396	90	szt	0.50	RF-13-01	2024-12-09	0	90
1259	MALT A TAS	MALTGARDEN A TASTE OF MADNESS BUT. 0,5 L	5904050721876	53	szt	0.77	RF-13-01	2024-12-09	0	53
1260	MA_BEA_POW_PUSZ_500	MALTGARDEN BEAUTY IS POWER PUSZKA 0,5 L	5904050721951	35	szt	0.54	RF-12-01	2024-12-09	0	35
1261	MALT BOA	MALTGARDEN BOAT TO INDIA BUT. 0,5 L	5907710943472	37	szt	0.77	RF-13-01	2024-12-09	0	37
1262	MA_CUS_SNE_PUSZ_500	MALTGARDEN CUSTOM SNEAKERS PUSZKA 0,5 L	5907710943014	11	szt	0.54	RF-13-01	2024-12-09	0	11
1263	MALT DEA	MALTGARDEN DEAD PHONE CALLING BUT. 0,5 L	5907710943977	50	szt	0.77	RF-13-01	2024-12-09	0	50
1264	MALT DRE	MALTGARDEN DREAMS GONE SOUTH BUT. 0,5 L	5907710943854	5	szt	0.77	AT-29-02	2024-12-09	0	5
1265	MA_END_PAR_PUSZ_500	MALTGARDEN ENDLESS PARTY PUSZKA 0,5 L	5904050721968	33	szt	0.54	RF-13-01	2024-12-09	0	33
1266	MALT FOL	MALTGARDEN FOLLOW THE RECIPE BUT. 0,5 L	5904050721500	3	szt	0.77	AT-29-02	2024-12-09	0	3
1267	MALT FUN VOL.8	MALTGARDEN FUNKY GARDEN VOL. 8  PUSZKA 0,5 L	5904050721128	84	szt	0.54	RF-14-01	2024-12-09	0	84
1268	MALT GAT 1	MALTGARDEN GATE NO 1/2021 BUT. 0,5 L	5904050721388	20	szt	0.77	RF-14-01	2024-12-09	0	20
1269	MALT GAT 1_2022	MALTGARDEN GATE NO 1/2022 BUT. 0,5 L	5904050721609	15	szt	0.77	RF-14-01	2024-12-09	0	15
1270	MA_GAT_1_2023_PUSZ_330	MALTGARDEN GATE NO 1/2023 PUSZKA 0,33 L	5904050721999	16	szt	0.35	RF-14-01	2024-12-09	0	16
1271	MALT GAT 2_2022	MALTGARDEN GATE NO 2_2022 PUSZKA 0,33 L	5904050721616	97	szt	0.35	RF-14-01	2024-12-09	0	97
1272	MALT GAT 3	MALTGARDEN GATE NO 3/2021 BUT. 0,5 L	5904050721401	15	szt	0.77	RF-14-01	2024-12-09	0	15
1273	MA_GAT_3_2023_PUSZ_330	MALTGARDEN GATE NO 3/2023 PUSZKA 0,33 L	5907710943168	12	szt	0.35	RF-15-01	2024-12-09	0	12
1274	MALT GAT 4	MALTGARDEN GATE NO 4/2021 BUT. 0,5 L	5904050721555	37	szt	0.77	RF-15-01	2024-12-09	0	37
1275	MALT GAT 5	MALTGARDEN GATE NO 5/2021 BUT. 0,5 L	5904050721562	44	szt	0.77	RF-15-01	2024-12-09	0	44
1276	MALT GAT 7	MALTGARDEN GATE NO 7/2022 PUSZKA 0,33 L	5904050721937	24	szt	0.35	RF-15-01	2024-12-09	0	24
1277	MALT GAT 8	MALTGARDEN GATE NO 8/2022 PUSZKA 0,33 L	5904050721944	24	szt	0.35	RF-15-01	2024-12-09	0	24
1278	MA_HEL_PUSZ_500	MALTGARDEN HELLO LAGER PUSZKA 0,5 L	5907710943007	40	szt	0.54	RF-15-01	2024-12-09	0	40
1279	MA_HOW_TO_PUSZ_500	MALTGARDEN HOW TO SPELL FUN PUSZKA 0,5 L	5907710943830	99	szt	0.54	RF-16-01	2024-12-09	0	99
1280	MALT BAR PAN GEI FIN	MALTGARDEN I'M YOUR BARISTA / PANAMA GEISHA FINCA DEBORAH NIRVANA PUSZKA 0,5 L	5904050721234	206	szt	0.54	RG-07-00	2024-12-09	0	206
1281	MALT MUS HAL	MALTGARDEN MUSEUM OF CLASSIC BEERS (HALLERTAUER PILS) BUT. 0,5 L	5905669632546	73	szt	0.77	RF-16-01	2024-12-09	0	73
1282	MALT NEW	MALTGARDEN NEWS DAILY PUSZKA 0,5 L	5904050721869	8	szt	0.54	AT-29-02	2024-12-09	0	8
1283	MA_PER_EVE_PUSZ_500	MALTGARDEN PERFECT FOR EVERYDAY PUSZKA 0,5 L	5904050721975	18	szt	0.54	RF-16-01	2024-12-09	0	18
1284	MALT PRO	MALTGARDEN PROTON BUT. 0,5 L	590405072103	186	szt	0.77	RG-07-00	2024-12-09	0	186
1285	MALT SLE	MALTGARDEN SLEEPING IN ORCHARD BUT. 0,5 L	5907710943878	14	szt	0.77	RF-16-01	2024-12-09	0	14
1286	MA_SUM_PUSZ_500	MALTGARDEN SUMMER MOVIE PUSZKA 0,5 L	5907710943267	52	szt	0.54	RF-16-01	2024-12-09	0	52
1287	MALT THE MID ICE 2022	MALTGARDEN THE MIDDLE OF SILENCE 2022 ICE EDITION BUT. 0,25 L	5904050721517	174	szt	0.35	RG-06-00	2024-12-09	0	174
1288	MA_TOP_REV_PUSZ_500	MALTGARDEN TOPPING REVOLUTION PUSZKA 0,5 L	5904050721982	26	szt	0.54	RF-16-01	2024-12-09	0	26
1289	MALT TRU	MALTGARDEN TRUNK FULL OF FRUITS BUT. 0,5 L	5904050721838	12	szt	0.77	RF-17-01	2024-12-09	0	12
1290	MALT WE GOT	MALTGARDEN WE GOT THE FIRE BUT. 0,5 L	5904050721623	28	szt	0.77	RF-17-01	2024-12-09	0	28
1291	MALT WHE	MALTGARDEN WHERE ARE MY GOGGLES? PUSZKA 0,5 L	5907710943304	213	szt	0.54	RG-08-00	2024-12-09	0	213
1292	MALT WIN	MALTGARDEN WINDOW BLINDS DOWN BUT. 0,5 L	5907710943298	408	szt	0.77	RG-09-00	2024-12-09	0	408
1293	MARE TRI 330	MAREDSOUS 10% TRIPLE BUT. 0,33 L	5411681038001	70	szt	0.50	RF-17-01	2024-12-09	0	70
1294	MARE BLO 330	MAREDSOUS 6% BLONDE BUT 0,33 L	5411681035000	27	szt	0.00	RF-17-01	2024-12-09	0	27
1295	MARE BRU 330	MAREDSOUS 8% BRUNE BUT. 0,33 L	5411681037004	42	szt	0.50	RF-17-01	2024-12-09	0	42
1296	MAR BAR LAP	MARYENSZTADT BARLEY WINE LAPHROIG B.A. BUT. 0,33 L	5905669542937	27	szt	0.50	RF-17-01	2024-12-09	0	27
1297	MAR BA ICE BRE BIA CZE PRA	MARYENSZTADT BARREL AGED ICE BRETT PORTER DOUBLE BA - BIAŁA CZEKOLADA I PRAŻONY ORZECH PUSZKA 0,44 L	5903678022075	21	szt	0.48	RF-18-01	2024-12-09	0	21
1298	MAR BA ICE BRE SUS SLI CYN	MARYENSZTADT BARREL AGED ICE BRETT PORTER DOUBLE BA - SUSZONA ŚLIWKA I CYNAMON PUSZKA 0,44 L	5903424615131	205	szt	0.48	RG-08-00	2024-12-09	0	205
1299	MAR BA ICE RIS TIR	MARYENSZTADT BARREL AGED ICE RYE RIS TIRAMISU RIOJA BA PUSZKA 0,44 L	5905669542531	12	szt	0.48	RF-18-01	2024-12-09	0	12
1300	MAR_BAR_COC_RIS_PUSZ_440	MARYENSZTADT BARREL AGED PROJECT – COCONUT RIS RUM BARREL AGED PUSZKA 0,44 L	5903424615728	37	szt	0.48	RF-18-01	2024-12-09	0	37
1301	MAR BA RIS BRO	MARYENSZTADT BARREL AGED RIS HEAVEN HILL BOURBON BROWNIE PUSZKA 0,44 L	5903424615018	10	szt	0.48	AT-29-02	2024-12-09	0	10
1302	MAR BA RIS HEA	MARYENSZTADT BARREL AGED RIS HEAVEN HILL BOURBON WHITE & DARK CHOCOLATE & COCONUT PUSZKA 0,44 L	5903678022082	18	szt	0.48	RF-18-01	2024-12-09	0	18
1303	MAR BEZ JAS LAG	MARYENSZTADT BEZGLUTENOWY JASNY LAGER BUT. 0,5 L	5903678022020	111	szt	0.77	RG-07-00	2024-12-09	0	111
1304	MAR BEZ OEA STO	MARYENSZTADT BEZGLUTENOWY OATMEAL STOUT BUT. 0,5 L	5903678022549	129	szt	0.77	RG-09-00	2024-12-09	0	129
1305	MAR BEZ SES APA	MARYENSZTADT BEZGLUTENOWY SESYJNE APA BUT. 0,5 L	5903678022037	45	szt	0.77	RF-18-01	2024-12-09	0	45
1306	MAR BY THE	MARYENSZTADT BY THE WAY BUT 0,5 L	5903678022372	50	szt	0.00	RF-18-01	2024-12-09	0	50
1307	MAR CHO RIS JAC	MARYENSZTADT CHOCOLATE RYE RIS JACK DANIELS B.A. BUT. 0,33 L	5905669542944	27	szt	0.50	RF-19-01	2024-12-09	0	27
1308	MAR FRE APA	MARYENSZTADT FREEKY APA BEZALKOHOLOWE BUT. 0,5 L	5903424615568	87	szt	0.77	RF-19-01	2024-12-09	0	87
1309	MAR FRE HAZY IPA	MARYENSZTADT FREEKY HAZY IPA GLUTEN & ALCOHOL FREE BUT. 0,5 L	5903424615285	101	szt	0.77	RE-08-00	2024-12-09	0	101
1310	MAR FRE MAN ALE	MARYENSZTADT FREEKY MANGO ALE BUT 0,5 L	5903424615148	119	szt	0.00	RG-08-00	2024-12-09	0	119
1311	MAR FRE ORA ALE	MARYENSZTADT FREEKY ORANGE ALE BUT 0,5 L	5903424615292	122	szt	0.00	RG-10-00	2024-12-09	0	122
1312	MAR GWI	MARYENSZTADT GWIAZDA PÓŁNOCY BUT. 0,33 L	5905669542708	31	szt	0.50	RF-19-01	2024-12-09	0	31
1313	MAR HEY	MARYENSZTADT HEY OH BUT. 0,5 L	5905669542340	193	szt	0.77	RG-10-00	2024-12-09	0	193
1314	MAR_HOP_LEM_GRA_BUT_330	MARYENSZTADT HOPPY LEMO - GRANAT & CHMIEL BUT. 0,33 L	5903678022044	129	szt	0.50	RG-10-00	2024-12-09	0	129
1315	MAR_HOP_LEM_MAN_BUT_330	MARYENSZTADT HOPPY LEMO - MANGO & CHMIEL BUT. 0,33 L	5903424615674	155	szt	0.50	RG-11-00	2024-12-09	0	155
1316	MAR ICE IMP	MARYENSZTADT ICE IMPERIAL BALTIC PORTER BURBON BARREL AGED PUSZKA 0,44 L	5905669542883	25	szt	0.48	RF-19-01	2024-12-09	0	25
1317	MAR IMP BAL HEA	MARYENSZTADT IMPERIAL BALTIC PORTER HEAVEN HILL KENTUCKY STRAIGHT BURBON WHISKEY B.A. BUT. 0,33 L	5903424615742	30	szt	0.50	RF-19-01	2024-12-09	0	30
1318	MAR KLA APA	MARYENSZTADT KLASYCZNIE APA BUT. 0,5 L	5905669542821	38	szt	0.77	RF-19-01	2024-12-09	0	38
1319	MAR KLA BAW	MARYENSZTADT KLASYCZNIE BAWARSKA PSZENICA BUT. 0,5 L	5905669542579	60	szt	0.77	RG-01-01	2024-12-09	0	60
1320	MAR_KLA_CZ_DES_BUT_500	MARYENSZTADT KLASYCZNIE CZESKA DESITKA BUT. 0,5 L	5905669542586	28	szt	0.77	RG-01-01	2024-12-09	0	28
1321	MAR KLA DRY	MARYENSZTADT KLASYCZNIE DRY STOUT BUT. 0,5 L	5903678022952	40	szt	0.77	RG-01-01	2024-12-09	0	40
1322	MAR KLA GER	MARYENSZTADT KLASYCZNIE GERMAN PILS BUT. 0,5 L	5903678022181	20	szt	0.77	RG-01-01	2024-12-09	0	20
1323	MAR_KLA_GOS_BUT_500	MARYENSZTADT KLASYCZNIE GOSE BUT 0,5 L	5903678022112	48	szt	0.00	RG-01-01	2024-12-09	0	48
1324	MAR KLA IPA	MARYENSZTADT KLASYCZNIE IPA BUT. 0,5 L	5903678022891	40	szt	0.77	RG-01-01	2024-12-09	0	40
1325	MAR KLA KOŹ	MARYENSZTADT KLASYCZNIE KOŹLAK BUT. 0,5 L	5903424615001	28	szt	0.77	RG-02-01	2024-12-09	0	28
1326	MAR KLA POL LAG	MARYENSZTADT KLASYCZNIE POLSKI LAGER BUT. 0,5 L	5905669542395	62	szt	0.77	RG-02-01	2024-12-09	0	62
1327	MAR MYS	MARYENSZTADT MYSTERIOUS IPA BUT. 0,5 L	5905669542470	45	szt	0.77	RG-02-01	2024-12-09	0	45
1328	MAR NEW BLA CHO HAZ_PROM	MARYENSZTADT NEW BLACK - CHOCOLATE HAZELNUT OAT STOUT BUT. 0,5 L PROMOCJA (do 29.09.23)	\N	5	szt	0.00	AT-29-02	2024-12-09	0	5
1329	MAR NEW PRA WIŚ	MARYENSZTADT NEW BLACK - OAT STOUT CZEKOLADOWA PRALINA Z WIŚNIĄ BUT. 0,5 L	5903424615933	15	szt	0.77	RG-02-01	2024-12-09	0	15
1330	NEW_WEV_PIL_BUT_500	MARYENSZTADT NEW WAVE PILS BUT. 0,5 L	5905669542968	84	szt	0.77	RG-02-01	2024-12-09	0	84
1331	MAR OAT CHO RIS HEA	MARYENSZTADT OAT CHOCOLATE RIS HEAVEN HILL KENTUCKY STRAIGHT BURBON WHISKEY & COGNAC B.A. BUT. 0,33 L	5903424615780	12	szt	0.50	RG-02-01	2024-12-09	0	12
1332	MAR OAT CHO RIS HEA PROMO	MARYENSZTADT OAT CHOCOLATE RIS HEAVEN HILL KENTUCKY STRAIGHT BURBON WHISKEY & COGNAC B.A. BUT. 0,33 L PROMO	\N	13	szt	0.00	RG-03-01	2024-12-09	0	13
1333	MAR OAT BLE SIN WHI	MARYENSZTADT OAT WINE BLENDED SINGLE MALT WHISKY BUT. 0,33 L	5905669542920	14	szt	0.50	RG-03-01	2024-12-09	0	14
1334	MAR PRO30 #5	MARYENSZTADT PROJEKT 30 #5 BUT 0,33 L	5903678022525	21	szt	0.00	RG-03-01	2024-12-09	0	21
1335	MAR_RIG_NOW_BUT_500	MARYENSZTADT RIGHT NOW BUT. 0,5 L	5905669542173	44	szt	0.77	RG-03-01	2024-12-09	0	44
1336	MAR_SMO_BEE_MAN-COC-ORA_PUSZ_500	MARYENSZTADT SMOOTHIE BEER SWEET MANGO-COCONUT-ORANGE-VANILLA-WHITE CHOCOLATE PUSZKA 0,5 L	5903424615537	57	szt	0.54	RG-03-01	2024-12-09	0	57
1337	MAR SMO MAN	MARYENSZTADT SMOOTHIE BEER: MANGO-ORANGE-BANANA-MARSHMALLOW PUSZKA 0,44 L	5903424615117	25	szt	0.48	RG-03-01	2024-12-09	0	25
1338	MAR SOU AGR	MARYENSZTADT SOURTIME AGREST BUT. 0,5 L	5905669542456	253	szt	0.77	RG-11-00	2024-12-09	0	253
1339	MAR_SOU_BER_TRU_BUT_500	MARYENSZTADT SOURTIME BERLINER WEISSE TRUSKAWKA BUT. 0,5 L	5903424615254	134	szt	0.77	RG-12-00	2024-12-09	0	134
1340	MAR_SOU_CAL_BUT_500	MARYENSZTADT SOURTIME CALAMANSI I LIMONKA BUT. 0,5 L L	5905669542043	110	szt	0.00	RG-11-00	2024-12-09	0	110
1341	MAR_SOU_CZA_POR_BUT_500	MARYENSZTADT SOURTIME CZARNA PORZECZKA BUT. 0,5 L	5905669542326	91	szt	0.77	RG-04-01	2024-12-09	0	91
1342	MAR SOU MAN	MARYENSZTADT SOURTIME MANGO IIPA BUT. 0,5 L	5905669542722	353	szt	0.77	RG-12-00	2024-12-09	0	353
1343	MAR_SOU_MAN_POM_MAR_BUT_500	MARYENSZTADT SOURTIME MANGO-POMARAŃCZA-MARAKUJA BUT. 0,5 L	5905669542005	57	szt	0.77	RG-04-01	2024-12-09	0	57
1344	MAR_SOU_MIR_LIM_BUT_500	MARYENSZTADT SOURTIME MIRABELKA I LIMONKA BUT. 0,5 L	5903424615322	75	szt	0.77	RG-04-01	2024-12-09	0	75
1345	MAR_SOU_GRA-POM_BUT_500	MARYENSZTADT SOURTIME PASTRY SOUR GRANAT I POMARAŃCZA BUT 0,5 L	5903678022099	147	szt	0.00	RG-13-00	2024-12-09	0	147
1346	MAR SOU MAN PEA	MARYENSZTADT SOURTIME PASTRY SOUR IPA MANGO & PEACH BUT. 0,5 L	5903424615964	10	szt	0.77	AT-29-02	2024-12-09	0	10
1517	NE HIG	NEPOMUCEN HIGHWAY BUT. 0,5 L	5907709756083	458	szt	0.77	RH-13-00	2024-12-09	0	458
1347	MAR SOU PAS RED CUR_PROM	MARYENSZTADT SOURTIME PASTRY SOUR RED CURRANT & CHERRY BUT. 0,5 L PROMOCJA (do 05.10.23)	\N	25	szt	0.00	RG-04-01	2024-12-09	0	25
1348	MAR SOU STR RHU	MARYENSZTADT SOURTIME STRAWBERRY & RHUBARB GOSE BUT. 0,5 L	5903424615193	120	szt	0.77	RG-13-00	2024-12-09	0	120
1349	MAR_SOU_HOP_HEFF_BUT_500	MARYENSZTADT SUMMERTIME HOPPY HEFEWEIZEN BUT. 0,5 L	5903424615094	57	szt	0.77	RG-05-01	2024-12-09	0	57
1350	MAR THE ROO#10_PROM	MARYENSZTADT THE ROOTS#10 PUSZKA 0,5 L PROMOCJA (do 19.10.23)	\N	5	szt	0.00	AT-29-02	2024-12-09	0	5
1351	MAR THE ROO#4	MARYENSZTADT THE ROOTS#4 DOUBLE WEST COAST IPA PUSZKA 0,5 L	5903678022402	40	szt	0.54	RG-04-01	2024-12-09	0	40
1352	MAR THE ROO#5	MARYENSZTADT THE ROOTS#5 PUSZKA 0,5 L	5905669542074	16	szt	0.54	RG-05-01	2024-12-09	0	16
1353	MAR_UP_TO_BUT_500	MARYENSZTADT UP TO ME BUT. 0,5 L	5903424615490	77	szt	0.77	RG-05-01	2024-12-09	0	77
1354	MAR WHE WIN COG	MARYENSZTADT WHEAT WINE COGNAC B.A. BUT. 0,33 L	5905669542890	29	szt	0.50	RG-05-01	2024-12-09	0	29
1355	MAR WIL FUN CHE	MARYENSZTADT WILD & FUNKY CHERRY FLANDERS RED ALE BUT. 0,75 L	5903678022860	8	szt	1.10	AT-29-02	2024-12-09	0	8
1356	MAR WIL FUN QUA	MARYENSZTADT WILD & FUNKY WILD QUADRUPEL RIOJA BARREL AGED PUSZKA 0,44 L	5903678022518	20	szt	0.48	RG-05-01	2024-12-09	0	20
1357	MAR_YES_WE_VOL4_MIC_PUSZ_500	MARYENSZTADT YES WE CAN VOL. 4 – MICRO HAZY IPA PUSZKA 0,5 L	5903678022679	27	szt	0.54	RG-05-01	2024-12-09	0	27
1358	MAR_YES_WE_VOL5_PUSZ_500	MARYENSZTADT YES WE CAN VOL. 5 PUSZKA 0,5 L	5903424615919	46	szt	0.54	RG-06-01	2024-12-09	0	46
1359	MIO_MAT_MAT_BUT_500	MATE - MATE BUT. 0,5 L	4260310557410	18	szt	0.77	RG-06-01	2024-12-09	0	18
1460	491	MONGOZO KOKOS POKAL	5123456791070	1	szt	0.00	AT-29-03	2024-12-09	0	1
1360	MIO_MAT_MAT_KON_HEMP_BUT_500	MATE - MATE KONOPIA HEMP BUT. 0,5 L	4260310559056	18	szt	0.77	RG-06-01	2024-12-09	0	18
1361	MIO_MAT_MOC_KATU_BUT_330	MATE MOC KATUAVA BUT. 0,33 L	5902768762891	163	szt	0.50	RG-13-00	2024-12-09	0	163
1362	MIO_MAT_MOC_SAB_CIT_BUT_330	MATE MOC SABOR CITRUS BUT. 0,33 L	5902768762471	225	szt	0.50	RG-14-00	2024-12-09	0	225
1363	MC CHOUF 330	MC CHOUFFE BUT. 0,33 L	5410769200088	143	szt	0.50	RG-14-00	2024-12-09	0	143
1364	MC CHOUF 750	MC CHOUFFE BUT. 0,75 L	5410769200095	216	szt	1.10	RG-15-00	2024-12-09	0	216
1365	MIK REFA	MIKKELLER BAGHAVEN: REFSAESOEN ABRIKOS BUT. 0,75 L	732003233542	13	szt	1.10	RG-06-01	2024-12-09	0	13
1366	MIK BL 375	MIKKELLER BLACK BUT. 0,375 L	818534018534	155	szt	0.50	RG-14-00	2024-12-09	0	155
1367	MIK CH FR 2019 375	MIKKELLER CHERRY FREDERIKSDAL DOUBLEBOCK 2019 BUT. 0,375 L	5704255119238	17	szt	0.50	RG-06-01	2024-12-09	0	17
1368	MIK CH FR TR 2019 375	MIKKELLER CHERRY FREDERIKSDAL TRIPELBOCK 2019 BUT. 0,375 L	5704255119221	21	szt	0.50	RG-06-01	2024-12-09	0	21
1369	MIK NEL ORAN 750	MIKKELLER NELSON SAUVIN ORANGE & PASSIONFRIUT BUT. 0,75 L	818534024733	4	szt	1.10	AT-29-03	2024-12-09	0	4
1370	MIK OR BLUE 750	MIKKELLER OREGON FRUIT SERIES: SPONTANBLUEBERRY BUT. 0,75 L	5704255115551	13	szt	1.10	RG-07-01	2024-12-09	0	13
1371	MIK OR PLUM 375	MIKKELLER OREGON FRUIT SERIES: SPONTANPLUM BUT. 0,375 L	5704255117302	13	szt	0.50	RG-07-01	2024-12-09	0	13
1372	MIK PUM L	MIKKELLER PUMA BOKSERKA SPORTOWA CZARNA (L)	5123456791121	1	szt	0.00	AT-29-01	2024-12-09	0	1
1373	MIK PUM XL	MIKKELLER PUMA BOKSERKA SPORTOWA CZARNA (XL)	5123456791119	4	szt	0.00	AT-29-03	2024-12-09	0	4
1374	MIK PUM XXL	MIKKELLER PUMA BOKSERKA SPORTOWA CZARNA (XXL)	5123456791120	1	szt	0.00	AT-29-02	2024-12-09	0	1
1375	MIK PUM N XL	MIKKELLER PUMA BOKSERKA SPORTOWA NIEBIESKA  (XL)	5123456791122	2	szt	0.00	AT-29-02	2024-12-09	0	2
1376	MIK PUM N L	MIKKELLER PUMA BOKSERKA SPORTOWA NIEBIESKA (L)	5123456791123	6	szt	0.00	AT-29-03	2024-12-09	0	6
1377	MIK SPOD M	MIKKELLER RUNNING CLUB SPODNIE CZARNE ( M )	5123456791115	1	szt	0.00	AT-29-03	2024-12-09	0	1
1378	MIK SPOD L	MIKKELLER RUNNING CLUB SPODNIE CZARNE (L)	5123456791116	2	szt	0.00	AT-29-03	2024-12-09	0	2
1379	MIK SPOD S	MIKKELLER RUNNING CLUB SPODNIE CZARNE (S)	5123456791117	2	szt	0.00	AT-29-03	2024-12-09	0	2
1380	MIK SPOD XXL	MIKKELLER RUNNING CLUB SPODNIE CZARNE (XXL)	5123456791118	1	szt	0.00	AT-29-03	2024-12-09	0	1
1381	MIK SAK	MIKKELLER SAKIEWKA	5123456791111	22	szt	0.00	RG-07-01	2024-12-09	0	22
1382	MIK SC 375	MIKKELLER SCOUR SCANDINAVIA SPONTAN SEABUCKTHORN BUT. 0,375 L	5704255118323	14	szt	0.50	RG-07-01	2024-12-09	0	14
1383	MIK SPON APRI 375	MIKKELLER SPONTAN APRICOT BUT. 0,375 L	818534015748	21	szt	0.50	RG-07-01	2024-12-09	0	21
1384	MIK SPON BLAC 375	MIKKELLER SPONTAN BLACKBERRY BUT. 0,375 L	818534015687	12	szt	0.50	RG-04-01	2024-12-09	0	12
1385	MIK SPON CARR 375	MIKKELLER SPONTAN CARROT BUT. 0,375 L	5704255117975	25	szt	0.50	RG-07-01	2024-12-09	0	25
1386	MIK SPON CAS 375	MIKKELLER SPONTAN CASSIS BUT. 0,375 L	818534013119	15	szt	0.50	RG-08-01	2024-12-09	0	15
1387	MIK SPON CHER 375	MIKKELLER SPONTAN CHERRY W. FREDERIKSDAL BUT. 0,375 L	818534011566	20	szt	0.50	RG-08-01	2024-12-09	0	20
1388	MIK SPON DOU CAS 375	MIKKELLER SPONTAN DOUBLE CASSIS BUT. 0,375 L	5704255118736	19	szt	0.50	RG-08-01	2024-12-09	0	19
1389	MIK SPON ELD 375	MIKKELLER SPONTAN ELDERFLOWER BUT. 0,375 L	5704255115612	29	szt	0.50	RG-08-01	2024-12-09	0	29
1390	MIK SPON HIB 375	MIKKELLER SPONTAN HIBISCUS BUT. 0,375 L	5704255115605	30	szt	0.50	RG-08-01	2024-12-09	0	30
1391	MIK SPON LEM 375	MIKKELLER SPONTAN LEMON BUT. 0,375 L	818534020865	21	szt	0.50	RG-08-01	2024-12-09	0	21
1392	MIK SPON PASS 375	MIKKELLER SPONTAN PASSION FRUIT BUT. 0,375 L	818534018732	12	szt	0.50	RG-09-01	2024-12-09	0	12
1393	MIK SPON PEAC 375	MIKKELLER SPONTAN PEACH BUT. 0,375 L	5704255117982	27	szt	0.50	RG-09-01	2024-12-09	0	27
1394	MIK SPON SEA BU 375	MIKKELLER SPONTAN SEA BUCKTHORN BUT. 0,375 L	818534013126	6	szt	0.50	AT-29-03	2024-12-09	0	6
1395	MIK SPON TRI CHE 2020 375	MIKKELLER SPONTAN TRIPPLE CHERRY 2020 BUT. 0,375 L	5704255121095	14	szt	0.50	RG-09-01	2024-12-09	0	14
1396	MIK TAP HAN	MIKKELLER TAP HANDLE	5123456791331	18	szt	0.00	RG-09-01	2024-12-09	0	18
1397	MIK TSH S	MIKKELLER T-SHIRT S	5123456791372	1	szt	0.00	AT-29-03	2024-12-09	0	1
1398	MIŁ_ARC_APA_BUT_500	MIŁOSŁAW & MAKŁOWICZ ARCY APA BUT. 0,5 L	5902838991435	284	szt	0.77	RG-15-00	2024-12-09	0	284
1399	MIŁ_ARC_IPA_BUT_500	MIŁOSŁAW & MAKŁOWICZ ARCY IPA BUT. 0,5 L	5902838991343	475	szt	0.77	RG-16-00	2024-12-09	0	475
1400	MIŁ BEZ IPA	MIŁOSŁAW BEZALKOHOLOWE IPA BUT. 0,5 L	5902838990469	280	szt	0.77	RG-17-00	2024-12-09	0	280
1401	MIŁ BEZ IPA P	MIŁOSŁAW BEZALKOHOLOWE IPA PUSZKA 0,5 L	5902838990575	18	szt	0.54	RG-09-01	2024-12-09	0	18
1402	MIŁ_CHM_LAG_BZW_BUT_500	MIŁOSŁAW CHMIELOWY LAGER BZW BUT. 0,5 L	\N	66	szt	0.77	RG-09-01	2024-12-09	0	66
1403	MIŁ CYD	MIŁOSŁAW CYDR MIŁOSŁAWSKI PÓŁSŁODKI BUT. 0,5 L	5901687910307	143	szt	0.77	RG-17-00	2024-12-09	0	143
1404	MIŁ CYD PÓŁ	MIŁOSŁAW CYDR MIŁOSŁAWSKI PÓŁWYTRAWNY BUT. 0,5 L	5901687910505	120	szt	0.77	RG-18-00	2024-12-09	0	120
1405	MIŁ MAR	MIŁOSŁAW MARCOWE BUT. 0,5 L	5902709615286	10	szt	0.77	AT-29-03	2024-12-09	0	10
1406	MIŁ PER	MIŁOSŁAW PERRY MIŁOSŁAWSKI BUT. 0,5 L	5901687910512	142	szt	0.77	RG-18-00	2024-12-09	0	142
1407	MIŁ PIL	MIŁOSŁAW PILZNER BUT. 0,5 L	5902709615323	27	szt	0.77	RG-10-01	2024-12-09	0	27
1408	MIŁ_PSZ_BEZ_BUT_500	MIŁOSŁAW PSZENICZNE BEZALKOHOLOWE BUT. 0,5 L	5902838991473	95	szt	0.77	RG-10-01	2024-12-09	0	95
1409	MIŁ SOS	MIŁOSŁAW SOSNOWE APA BUT. 0,5 L	5901687910765	105	szt	0.77	RG-13-00	2024-12-09	0	105
1410	MIŁ ZES MAK	MIŁOSŁAW ZESTAW MAKŁOWICZ 4 PIWA 0,5 L + LIMITOWANE SZKŁO	5902838991350	15	szt	0.00	RG-10-01	2024-12-09	0	15
1411	MIN_LUC_GH_BUT_500	MINISTER LUCKY GHOST BUT. 0,5 L	5903351660068	204	szt	0.77	RG-18-00	2024-12-09	0	204
1412	MIN_NIC_RIC_BUT_500	MINISTER NICE RICE BUT. 0,5 L	5903351660273	531	szt	0.77	RA-05-02	2024-12-09	0	531
1413	MIN_PARA_BUT_500	MINISTER PARADAJZ BUT. 0,5 L	5903351660006	276	szt	0.77	RG-19-00	2024-12-09	0	276
1414	MIN_PIL_BUT_500	MINISTER PILZNER BUT. 0,5 L	5903351660105	556	szt	0.77	RA-05-04	2024-12-09	0	556
1415	MIN_SAL_TRI_BUT_500	MINISTER SALTY TRIP BUT. 0,5 L	5903351660129	251	szt	0.77	RG-19-00	2024-12-09	0	251
1416	MIO_MIO_COLA_BUT_500	MIO MIO COLA BUT. 0,5 L	4002846034368	191	szt	0.77	RH-01-00	2024-12-09	0	191
1417	MIO_MIO_GUA_GRA_BUT_500	MIO MIO GUARANA GRANAT BUT. 0,5 L	4002846034788	1	szt	0.77	AT-29-03	2024-12-09	0	1
1418	MIO_MIO_LEMO_BUT_500	MIO MIO LEMON BUT. 0,5 L	4002846038915	123	szt	0.77	RH-01-00	2024-12-09	0	123
1419	MIO_MIO_MAT_BUT_500	MIO MIO MATE BUT. 0,5 L	4002846034528	537	szt	0.77	RA-06-04	2024-12-09	0	537
1420	MIO_MIO_MAT_IMB_BUT_500	MIO MIO MATE IMBIR BUT. 0,5 L	4002846034689	449	szt	0.77	RH-02-00	2024-12-09	0	449
1421	MISS DAR	MISSION DARK SEAS IMPERIAL STOUT BUT. 0,3 L	850411004056	32	szt	0.00	RG-10-01	2024-12-09	0	32
1422	MO_BER_PUSZ_500	MOCZYBRODA BERRYLICIOUS DELIGHT PUSZKA 0,5 L	5904673801085	48	szt	0.54	RG-10-01	2024-12-09	0	48
1423	MO_BIT_BUR_PUSZ_500	MOCZYBRODA BITTER BURST PUSZKA 0,5 L	5904673801122	44	szt	0.54	RG-10-01	2024-12-09	0	44
1424	MO_BIT_PUSZ_500	MOCZYBRODA BITTER SYMPHONY PUSZKA 0,5 L	5904673800873	14	szt	0.54	RG-11-01	2024-12-09	0	14
1425	MOCZY BRA	MOCZYBRODA BRAIN SMASHER BUT 0,5 L	5903351761741	21	szt	0.00	RG-11-01	2024-12-09	0	21
1426	MO_BRE_PUSZ_500	MOCZYBRODA BREWTOPIA PUSZKA 0,5 L	5904673800828	35	szt	0.54	RG-11-01	2024-12-09	0	35
1427	MO_CIT_BLA_PUSZ_500	MOCZYBRODA CITRUS BLAST PUSZKA 0,5 L	5904673801115	55	szt	0.54	RG-11-01	2024-12-09	0	55
1428	MOCZY CZA	MOCZYBRODA CZAS SURFERÓW BUT. 0,5 L	5903351761086	30	szt	0.77	RG-11-01	2024-12-09	0	30
1429	MO_FLA_PUSZ_500	MOCZYBRODA FLAN PARISIEN PUSZKA 0,5 L	5904673801078	49	szt	0.54	RG-11-01	2024-12-09	0	49
1430	MO_FOG_PUSZ_500	MOCZYBRODA FOGGY SUMMIT PUSZKA 0,5 L	5904673800880	11	szt	0.54	RG-12-01	2024-12-09	0	11
1431	MO_FRA_PUSZ_500	MOCZYBRODA FRANKIE SAY RELAX PUSZKA 0,5 L	5904673800798	41	szt	0.54	RG-12-01	2024-12-09	0	41
1432	MO_FUL_PUSZ_500	MOCZYBRODA FULL TIME HEAVEN PUSZKA 0,5 L	5904673800767	20	szt	0.54	RG-12-01	2024-12-09	0	20
1433	MO_HO_HOP_PUSZ_500	MOCZYBRODA HOPPY HOPAROO PUSZKA 0,5 L	5904673800910	25	szt	0.54	RG-12-01	2024-12-09	0	25
1434	MO_INT_PUSZ_500	MOCZYBRODA INTO THE VOID PUSZKA 0,5 L	5904673800804	28	szt	0.54	RG-12-01	2024-12-09	0	28
1435	MOCZY JAC	MOCZYBRODA JACK MANGOW BUT. 0,5 L	5903351761406	262	szt	0.77	RH-03-00	2024-12-09	0	262
1436	MOCZY LOV COC	MOCZYBRODA LOVE WITH THE COCO BUT. 0,33 L	5903351761710	102	szt	0.50	RG-17-00	2024-12-09	0	102
1437	MOCZY LSD	MOCZYBRODA LSD (LIGHT SOUR DELICIOUS) BUT. 0,5 L	5903351761307	196	szt	0.77	RH-01-00	2024-12-09	0	196
1438	MOCZY MOT GUA	MOCZYBRODA MOTHER OF DRAGONS GUANABANANA EDITION BUT. 0,5 L	5903351761444	88	szt	0.77	RG-12-01	2024-12-09	0	88
1439	MOCZY NEK	MOCZYBRODA NEKTAR BOGÓW BUT. 0,5 L	5903351761208	383	szt	0.77	RH-04-00	2024-12-09	0	383
1440	MOCZY NEW#12	MOCZYBRODA NEW WAVE #12 BUT. 0,33 L	5903351761727	6	szt	0.50	AT-29-03	2024-12-09	0	6
1441	MO_PEA_PUSZ_500	MOCZYBRODA PEARFECTLY GREEN PUSZKA 0,5 L	5904673801061	83	szt	0.54	RG-13-01	2024-12-09	0	83
1442	MOCZY POC	MOCZYBRODA POCO LOCO BUT.0,5 L	5903351761581	336	szt	0.00	RH-05-00	2024-12-09	0	336
1443	MOCZY POP#5	MOCZYBRODA POPART #05 CHOCOLATE PASTRY IMPERIAL STOUT BUT. 0,5 L	5904673800415	23	szt	0.77	RG-13-01	2024-12-09	0	23
1444	MO_POP_#12_500	MOCZYBRODA POPART #12 DOPPEL RAUCHBOCK BUT. 0,5 L	5901087374594	44	szt	0.77	RG-13-01	2024-12-09	0	44
1445	MOCZY PUL	MOCZYBRODA PULP FUSION BUT. 0,5 L	5904673800279	54	szt	0.77	RG-13-01	2024-12-09	0	54
1446	MO_REB_BUT_500	MOCZYBRODA REBEL RAIDER BUT. 0,5 L	5904673800903	44	szt	0.77	RG-13-01	2024-12-09	0	44
1447	MO_RET_PUSZ_500	MOCZYBRODA RETRO PISTACHIO PUSZKA 0,5 L	5904673800415	23	szt	0.54	RG-13-01	2024-12-09	0	23
1448	MO_SUM_MAD_BUT_500	MOCZYBRODA SUMMERTIME MADNESS BUT. 0,5 L	5904673800996	44	szt	0.77	RG-14-01	2024-12-09	0	44
1449	MO_VEL_BUT_500	MOCZYBRODA VELVET NIGHTFALL BUT. 0,5 L	\N	11	szt	0.77	RG-14-01	2024-12-09	0	11
1450	MOCZY WIT	MOCZYBRODA WIT ME BABY BUT. 0,5 L	5903351761369	302	szt	0.77	RH-06-00	2024-12-09	0	302
1451	MOCZY ŻAR	MOCZYBRODA ŻAR TROPIKÓW BUT. 0,5 L	5903351761079	75	szt	0.77	RG-14-01	2024-12-09	0	75
1452	OMB Moe Mar	MOERSLEUTEL 6Y MARGREET PUSZKA 0,44 L	8720615260522	1	szt	0.48	AT-29-03	2024-12-09	0	1
1453	OMB Moe Sja	MOERSLEUTEL 6Y SJAAK PUSZKA 0,44 L	8720615260539	1	szt	0.48	AT-29-03	2024-12-09	0	1
1454	OMB Moe Tom	MOERSLEUTEL 6Y TOM PUSZKA 0,44 L	8720615260508	1	szt	0.48	AT-29-03	2024-12-09	0	1
1455	OMB Moe Mus	MOERSLEUTEL MUSCOVADO MAPLE MAGICIAN PUSZKA 0,44 L	8719992492763	1	szt	0.48	AT-29-03	2024-12-09	0	1
1456	MOI BLO 330	MOINETTE BLONDE BUT. 0,33 L	5410702000133	44	szt	0.50	RG-14-01	2024-12-09	0	44
1457	MOI BLO 750	MOINETTE BLONDE BUT. 0,75 L	5410702000119	30	szt	1.10	RG-14-01	2024-12-09	0	30
1458	MOI BON VOE 750	MOINETTE BONS VOEUX BUT. 0,75 L	5410702000010	29	szt	1.10	RG-14-01	2024-12-09	0	29
1459	MON BAN 330	MONGOZO BANANA BUT. 0,33 L	8715608000025	27	szt	0.50	RG-15-01	2024-12-09	0	27
1461	KAT01010	MONGOZO POKAL 0,25 L	5123456791071	15	szt	0.00	RG-15-01	2024-12-09	0	15
1462	MO_FRU_MAC_#8_PUSZ_500	MONSTERS FRUIT MACHINE #8 PUSZKA 0,5 L	5905476980663	85	szt	0.54	RG-15-01	2024-12-09	0	85
1463	MO_JUI_#3_PUSZ_500	MONSTERS JUICY #3  PUSZKA 0,5 L	5905476980595	52	szt	0.54	RG-15-01	2024-12-09	0	52
1464	MON_SPRI_KEG_20	MONVIN APERITIVO SPRITZ KEG 20 L	8013324024449	6	szt	21.50	AT-29-03	2024-12-09	0	6
1465	MON_FRIZ_KEG_20	MONVIN BIANCO FRIZZANTE KEG 20 L	8013651024099	10	szt	21.50	AT-29-03	2024-12-09	0	10
1466	MON_KAR_1000	MONVIN KARAFKA 0,5 L / 1,0 L	5123456791450	12	szt	0.00	RG-15-01	2024-12-09	0	12
1468	MON_KAR_500	MONVIN KRAFKA 0,25 L / 0,5 L	5123456791448	12	szt	0.00	RG-16-01	2024-12-09	0	12
1469	MON_ROS_KEG_20	MONVIN ROSE FRIZZANTE KEG 20 L	8013651024792	5	szt	21.50	AT-29-03	2024-12-09	0	5
1470	PI_STA_#3_PUSZ_500	MOON LARK / PINTA STAY HERE #3 14,0° CAN 0,5 L	5905255346512	483	szt	0.00	RH-07-00	2024-12-09	0	483
1471	PI_STA_#3_KEG_30	MOON LARK / PINTA STAY HERE #3 14,0° KEG 30 L	\N	11	szt	32.00	RG-16-01	2024-12-09	0	11
1472	ML_ARC_3.0_PUSZ_500	MOON LARK ARCHES 3.0. WEST COAST DIPA PUSZKA 0,5 L	5905255346482	74	szt	0.54	RG-16-01	2024-12-09	0	74
1473	ML_CAS_PUSZ_500	MOON LARK CASUAL. WEST COAST PALE ALE PUSZKA 0,5 L	5905255346468	127	szt	0.54	RH-03-00	2024-12-09	0	127
1474	ML_CHER_PUSZ_500	MOON LARK CHEERFUL. ESTRA SPECIAL BITTER PUSZKA 0,5 L	5905255346505	123	szt	0.54	RH-03-00	2024-12-09	0	123
1475	ML_FRE_PUSZ_500	MOON LARK FREAK ME. NEW ZEALAND PILS 12,0° PUSZKA 0,5 L	5905255346420	40	szt	0.54	RG-16-01	2024-12-09	0	40
1476	ML GLO	MOON LARK GLOW. AMERICAN PALE ALE PUSZKA 0,5 L	5905255346024	53	szt	0.54	RG-16-01	2024-12-09	0	53
1477	ML_MIR_PUSZ_500	MOON LARK MIRAGE 2.0. SESSION HAZY IPA PUSZKA 0,5 L	5905255346345	1	szt	0.54	AT-29-03	2024-12-09	0	1
1478	ML_MIR_3.0_PUSZ_500	MOON LARK MIRAGE 3.0. HAZY SESSION IPA PUSZKA 0,5 L	5905255346451	148	szt	0.54	RH-04-00	2024-12-09	0	148
1479	ML_OUT_PUSZ_500	MOON LARK OUTDOOR. HAZY DIPA PUSZKA 0,5 L	5905255346475	116	szt	0.54	RH-05-00	2024-12-09	0	116
1480	ML PRI	MOON LARK PRIME. WEST COAST IPA PUSZKA 0,5 L	5905255346000	63	szt	0.54	RG-16-01	2024-12-09	0	63
1481	ML_RAI_PUSZ_500	MOON LARK RAISE. HELLES LAGER PUSZKA 0,5 L	5905255346208	159	szt	0.54	RH-06-00	2024-12-09	0	159
1482	ML REE	MOON LARK REEF. HAZY IPA PUSZKA 0,5 L	5905255346048	167	szt	0.54	RH-08-00	2024-12-09	0	167
1483	ML SHE	MOON LARK SHELTER. GERMAN PILS PUSZKA 0,5 L	5905255346185	259	szt	0.54	RH-08-00	2024-12-09	0	259
1484	ML_SIL_PUSZ_500	MOON LARK SILK. HEFEWEIZEN PUSZKA 0,5 L	5905255346369	244	szt	0.54	RH-09-00	2024-12-09	0	244
1485	ML_TUN_PUSZ_500	MOON LARK TUNE UP. KELLERBIER PUSZKA 0,5 L	5905255346444	139	szt	0.54	RH-09-00	2024-12-09	0	139
1486	MS GUE	MORT SUBITE GUEUZE BUT. 0,375 L	5411656052001	82	szt	0.50	RG-17-01	2024-12-09	0	82
1487	MS OUD GUE 375	MORT SUBITE OUDE GUEUZE BUT. 0,375 L	5411656052193	34	szt	0.50	RG-17-01	2024-12-09	0	34
1488	MS OUD KRI 375	MORT SUBITE OUDE KRIEK BUT. 0,375 L	5411656052223	76	szt	0.50	RG-17-01	2024-12-09	0	76
1489	NE ACI	NEPOMUCEN ACIDO BUT. 0,5 L	5905279959637	210	szt	0.77	RH-10-00	2024-12-09	0	210
1490	NE_APP_PUSZ_500	NEPOMUCEN APPETIZING PUSZKA 0,5 L	5905701060290	162	szt	0.54	RH-10-00	2024-12-09	0	162
1491	NE ARO	NEPOMUCEN AROUND BUT. 0,5 L	5904555992610	165	szt	0.77	RH-10-00	2024-12-09	0	165
1492	NE_ATO_PUSZ_500	NEPOMUCEN ATO IPA PUSZKA 0,5 L	5905701060030	53	szt	0.54	RG-17-01	2024-12-09	0	53
1493	NE BE CAR	NEPOMUCEN BE CAREFUL BUT. 0,5 L	5907709756052	85	szt	0.77	RG-18-01	2024-12-09	0	85
1494	NE BER INS	NEPOMUCEN BERLINER INSIDE – MEET OUR PLACES | EPISODE 01: CHMIELARNIA PUSZKA 0,5 L	5904041706875	5	szt	0.54	AT-29-03	2024-12-09	0	5
1495	NE_BIR_PUSZ_500	NEPOMUCEN BIRDLAND PUSZKA 0,5 L	5905701060047	57	szt	0.54	RG-18-01	2024-12-09	0	57
1496	NE_BRU_PUSZ_500	NEPOMUCEN BRUSCO PUSZKA 0,5 L	5905701060139	63	szt	0.54	RG-18-01	2024-12-09	0	63
1497	NE BUD	NEPOMUCEN BUDDIES PUSZKA 0,5 L	5904555992511	45	szt	0.54	RG-17-01	2024-12-09	0	45
1498	NE_CAS_PUSZ_500	NEPOMUCEN CASTLE PARTY PUSZKA 0,5 L	5905701060122	40	szt	0.54	RG-18-01	2024-12-09	0	40
1499	NE CHA	NEPOMUCEN CHARLOTTE BUT. 0,5 L	5905279959699	48	szt	0.77	RG-18-01	2024-12-09	0	48
1500	NE_CIT_TIR_PUSZ_500	NEPOMUCEN CITRUS TIRAMISU PUSZKA 0,5 L	5905701060313	158	szt	0.54	RH-11-00	2024-12-09	0	158
1501	NE_COM_PUSZ_500	NEPOMUCEN COMMON GULL PUSZKA 0,5 L	5905191386771	42	szt	0.54	RG-19-01	2024-12-09	0	42
1502	NE_CUL_PUSZ_500	NEPOMUCEN CULTO KWAS PUSZKA 0,5 L	5905701060153	45	szt	0.54	RG-19-01	2024-12-09	0	45
1503	NE_DET_23_PUSZ_330	NEPOMUCEN D-TONACJA 2023 PUSZKA 0,33 L	5905191386566	16	szt	0.35	RG-19-01	2024-12-09	0	16
1504	NE_END_PUSZ_500	NEPOMUCEN ENDLESS LINES PUSZKA 0,5 L	5905191386948	20	szt	0.54	RG-19-01	2024-12-09	0	20
1505	NE_FLY_BEM_PUSZ_500	NEPOMUCEN FLY ME TO BEMOWO PUSZKA 0,5 L	5905701060238	46	szt	0.54	RG-19-01	2024-12-09	0	46
1506	NE FOR.RES	NEPOMUCEN FOR.REST BUT. 0,5 L	5907709756243	204	szt	0.77	RH-11-00	2024-12-09	0	204
1507	NE FOR	NEPOMUCEN FOREST IPA BUT. 0,5 L	5905279959521	502	szt	0.77	RA-07-03	2024-12-09	0	502
1508	NE_FRE_FAM_PUSZ_500	NEPOMUCEN FREE FAM DESIRE PUSZKA 0,5 L	5905701060160	369	szt	0.54	RH-12-00	2024-12-09	0	369
1509	NE FRE ODR	NEPOMUCEN FREE ODRA PANY PUSZKA 0,5 L	5904555992795	83	szt	0.54	RG-19-01	2024-12-09	0	83
1510	NE PAN DA FRE	NEPOMUCEN FREE PAN DA PUSZKA 0,5 L	5907709756434	56	szt	0.54	RH-01-01	2024-12-09	0	56
1511	NE_FRU_PUSZ_500	NEPOMUCEN FRUITLAND PUSZKA 0,5 L	5905191386900	25	szt	0.54	RH-01-01	2024-12-09	0	25
1512	NE FRU	NEPOMUCEN FRUTOLLO PUSZKA 0,5 L	5907709756939	33	szt	0.54	RH-01-01	2024-12-09	0	33
1513	NE FRUTT_PROM	NEPOMUCEN FRUTTATO PUSZKA 0,5 L PROMOCJA (do 06.10.23)	\N	19	szt	0.00	RH-01-01	2024-12-09	0	19
1514	NE_FUL_OPE_PUSZ_500	NEPOMUCEN FULL OPEN CRAFT PUSZKA 0,5 L	5905701060269	92	szt	0.54	RH-01-01	2024-12-09	0	92
1515	NE HEA	NEPOMUCEN HEAT PUSZKA 0,5 L	5904041706684	60	szt	0.54	RH-01-01	2024-12-09	0	60
1516	NE HENRYK	NEPOMUCEN HENRYK PUSZKA 0,5 L	5905191386399	30	szt	0.54	RH-02-01	2024-12-09	0	30
1518	NE HOP	NEPOMUCEN HOPOLLO PUSZKA 0,5 L	5907709756946	100	szt	0.54	RH-02-01	2024-12-09	0	100
1519	NE JOS	NEPOMUCEN JOSE BUT. 0,5 L	5905279959712	178	szt	0.77	RH-11-00	2024-12-09	0	178
1520	NE_JOU_VOL2_BUT_500	NEPOMUCEN JOURNEY TO TO THE VALLEY VOL.2 BUT. 0,5 L	5905701060252	447	szt	0.77	RH-14-00	2024-12-09	0	447
1521	NE_KEE_PUSZ_500	NEPOMUCEN KEEP ON ROLLIN’ PUSZKA 0,5 L	5905701060245	61	szt	0.54	RH-02-01	2024-12-09	0	61
1522	NE_KIN_OF_MAG_PUSZ_500	NEPOMUCEN KIND OF MAGIC PUSZKA 0,5 L	5905191386573	2	szt	0.54	AT-29-03	2024-12-09	0	2
1523	NE LAB	NEPOMUCEN LABIRYTM BUT. 0,5 L	5905279959101	69	szt	0.77	RH-02-01	2024-12-09	0	69
1524	NE LIK P	NEPOMUCEN LIKE A FOREST PUSZKA 0,5 L	5907709756540	243	szt	0.54	RH-15-00	2024-12-09	0	243
1525	NE_LOS_BUT_FOUN_20	NEPOMUCEN LOST BUT FOUND KEG 20L	\N	1	szt	0.00	AT-29-03	2024-12-09	0	1
1526	NE_LOS_BUT_FOU_PUSZ_500	NEPOMUCEN LOST BUT FOUND PUSZKA 0,5 L	5905701060320	223	szt	0.54	RH-15-00	2024-12-09	0	223
1527	NE LOV P	NEPOMUCEN LOVELAS TRIPLE FOREST IPA PUSZKA 0,5 L	5907709756700	136	szt	0.54	RH-09-00	2024-12-09	0	136
1528	NE_MEE_MOO_PUSZ_500	NEPOMUCEN MEET OUR FRIENDS | EPISODE 12: MOON LARK PUSZKA 0,5 L	5905701060092	131	szt	0.54	RH-12-00	2024-12-09	0	131
1529	NE MIC_PROM	NEPOMUCEN MICHAEL PUSZKA 0,5 L PROMOCJA (do 11.10.23)	\N	17	szt	0.00	RH-02-01	2024-12-09	0	17
1530	NE_MIC_LIN_PUSZ_500	NEPOMUCEN MICRO LINES PUSZKA 0,5 L	5905701060009	115	szt	0.54	RH-16-00	2024-12-09	0	115
1531	NE MIL	NEPOMUCEN MILO BUT. 0,5 L	5905279959286	153	szt	0.77	RH-16-00	2024-12-09	0	153
1532	NE_MOR_HOP_MOR_FOR_PUSZ_500	NEPOMUCEN MORE HOPS & MORE FOREST PUSZKA 0,5 L	5905191386498	36	szt	0.54	RH-03-01	2024-12-09	0	36
1533	NE NACH JAB CYT	NEPOMUCEN NACHMIELONA CHMIEL+JABŁKO+CYTRYNA BUT. 0,5 L	5905279959552	99	szt	0.77	RH-03-01	2024-12-09	0	99
1534	NE_NACH_JAB-CYT_PUSZ_500	NEPOMUCEN NACHMIELONA CHMIEL+JABŁKO+CYTRYNA PUSZKA 0,5 L	5905191386696	105	szt	0.54	RH-08-00	2024-12-09	0	105
1535	NE NACH SOS JAB POM	NEPOMUCEN NACHMIELONA CHMIEL+SOSNA+JABŁKO+POMARAŃCZA BUT. 0,5 L	5905279959996	91	szt	0.77	RH-03-01	2024-12-09	0	91
1536	NE_NACH_SOS-JAB-POM_PUSZ_500	NEPOMUCEN NACHMIELONA CHMIEL+SOSNA+JABŁKO+POMARAŃCZA PUSZKA 0,5 L	5905191386702	79	szt	0.54	RH-04-01	2024-12-09	0	79
1537	NE NACH CHM	NEPOMUCEN NACHMIELONA CHMIEL+WODA BUT. 0,5 L	5905279959316	35	szt	0.77	RH-03-01	2024-12-09	0	35
1538	NE_NACH_CHM-WOD_PUSZ_500	NEPOMUCEN NACHMIELONA CHMIEL+WODA PUSZKA 0,5 L	5905191386689	92	szt	0.54	RH-04-01	2024-12-09	0	92
1539	NE_NEPO_FIN_GOL_BUT_375	NEPOMUCEN NEPO FINEST – GOLDEN HIND BUT. 0,375 L	5905191386610	21	szt	0.50	RH-02-01	2024-12-09	0	21
1540	NE_NEPO_FIN_ROY_BUT_375	NEPOMUCEN NEPO FINEST – ROYAL FORTUNE BUT. 0,375 L	5905191386603	6	szt	0.50	AT-29-04	2024-12-09	0	6
1541	NE ODR	NEPOMUCEN ODRA PANY PUSZKA 0,5 L	5904555992788	158	szt	0.54	RH-16-00	2024-12-09	0	158
1542	NE OLE	NEPOMUCEN OLE BUT. 0,5 L	5905279959910	139	szt	0.77	RH-17-00	2024-12-09	0	139
1543	NE PEL	NEPOMUCEN PELICAN BUT. 0,5 L	5905279959750	110	szt	0.77	RH-16-00	2024-12-09	0	110
1544	NE PIJ	NEPOMUCEN PIJŻE BUT. 0,5 L	5905279959972	256	szt	0.77	RH-17-00	2024-12-09	0	256
1545	NE PRE	NEPOMUCEN PRECIOUS PUSZKA 0,5 L	5905191386030	114	szt	0.54	RH-17-00	2024-12-09	0	114
1546	NE_RAJ_PUSZ_500	NEPOMUCEN RAJ PUSZKA 0,5 L	5905701060054	95	szt	0.54	RH-04-01	2024-12-09	0	95
1547	NE RAN	NEPOMUCEN RANGE PALE ALE BUT. 0,5 L	5905279959323	13	szt	0.77	RH-03-01	2024-12-09	0	13
1548	NE_SHO_BUT_500	NEPOMUCEN SHORELINE BUT. 0,5 L	5905191386481	104	szt	0.77	RH-18-00	2024-12-09	0	104
1549	NE SIM	NEPOMUCEN SIMPLY & EASY PUSZKA 0,5 L	5905191386108	5	szt	0.54	AT-29-04	2024-12-09	0	5
1550	NE_SOU_MAD_BLA_PUSZ_500	NEPOMUCEN SOUR MADNESS - BLACK PUSZKA 0,5 L	5905701060016	31	szt	0.54	RH-04-01	2024-12-09	0	31
1551	NE_SPU_PUSZ_500	NEPOMUCEN SPURS PUSZKA 0,5 L	5905701060146	8	szt	0.54	AT-29-04	2024-12-09	0	8
1552	NE_SQU_PUSZ_500	NEPOMUCEN SQUASH PUSZKA 0,5 L	5905191386955	1	szt	0.54	AT-29-03	2024-12-09	0	1
1553	NE SZO	NEPOMUCEN SZOSA BUT. 0,5 L	5907709756106	233	szt	0.77	RH-18-00	2024-12-09	0	233
1554	NE SZO P	NEPOMUCEN SZOSA PUSZKA 0,5 L	5904041706288	128	szt	0.54	RH-18-00	2024-12-09	0	128
1555	NE_TAK_PUSZ_500	NEPOMUCEN TAKE IT! PUSZKA 0,5 L	5905701060115	28	szt	0.54	RH-05-01	2024-12-09	0	28
1556	NE_THE_DAR_BUT_500	NEPOMUCEN THE DARKNESS BUT. 0,5 L	5905191386061	40	szt	0.77	RH-05-01	2024-12-09	0	40
1557	NE_THE_HEDG_PUSZ_500	NEPOMUCEN THE HEDGEHOG PUSZKA 0,5 L	5905701060337	349	szt	0.54	RH-19-00	2024-12-09	0	349
1558	NE_THE_SPI_PUSZ_500	NEPOMUCEN THE SPIRAL PUSZKA 0,5 L	5905701060276	80	szt	0.54	RH-05-01	2024-12-09	0	80
1559	NE TOU	NEPOMUCEN TOUCAN BUT. 0,5 L	5905279959675	189	szt	0.77	RH-19-00	2024-12-09	0	189
1560	NE_TRO_FEE_PUSZ_500	NEPOMUCEN TROPICAL FEET PUSZKA 0,5 L	5905701060085	2	szt	0.54	AT-29-04	2024-12-09	0	2
1561	NE_WALK_KEY_PUSZ_500	NEPOMUCEN WALKING KEYS PUSZKA 0,5 L	5905701060078	153	szt	0.54	RI-01-00	2024-12-09	0	153
1562	NE WAS	NEPOMUCEN WASSILY PUSZKA 0,5 L	5904555992139	57	szt	0.54	RH-05-01	2024-12-09	0	57
1563	OMB Ner Hot	NERDBREWING HOTPATH IMPERIAL CHILI STOUT - 004 ANCHO BUT. 0,33 L	7350080580910	4	szt	0.50	AT-29-04	2024-12-09	0	4
1564	OMB Ner Sus	NERDBREWING SUSPEND MAPLE AND CINNAMON IMP OATMEAL STOUT BUT. 0,33 L	7350080581160	12	szt	0.50	RH-03-01	2024-12-09	0	12
1565	NIE_RUS_BUT_500	NIECZAJNA RUSSIAN IMPERIAL STOUT BUT. 0,5 L	5903796782233	68	szt	0.77	RH-05-01	2024-12-09	0	68
1566	NOOK EBO	NOOK EBONO BUT. 0,33 L	5903240848409	77	szt	0.50	RH-06-01	2024-12-09	0	77
1567	NOOK FIG	NOOK FIGARBO BUT. 0,33 L	5903240848386	21	szt	0.50	RH-05-01	2024-12-09	0	21
1568	NOOK MAH	NOOK MAHAGANO BUT. 0,33 L	5903240848393	10	szt	0.50	AT-29-04	2024-12-09	0	10
1569	OSO THE	O’SO THE CONTINENTAL BUT. 0,75 L	892370002810	7	szt	1.10	AT-29-04	2024-12-09	0	7
1570	Oha Fia	O'HARA'S / FIRESTONE WALKER FIÁIN HONEY ALE BUT. 0,375 L	602755011531	105	szt	0.50	RI-01-00	2024-12-09	0	105
1571	Oha Dou IPA	O'HARA'S DOUBLE IPA BUT. 0,5 L	5391500600834	70	szt	0.77	RH-06-01	2024-12-09	0	70
1572	Oha Fre Whi IPA	O'HARA'S FREEBIRD IPA BUT. 0,5 L	5391500601169	41	szt	0.77	RH-06-01	2024-12-09	0	41
1573	Oha Iri Red	O'HARA'S IRISH RED BUT. 0,5 L	5391500600025	78	szt	0.77	RH-06-01	2024-12-09	0	78
1574	Oha Iri Red Nit k-keg 30	O'HARA'S IRISH RED NITRO K-KEG 30 L	5391500601343	6	szt	32.00	AT-29-04	2024-12-09	0	6
1575	Oha Iri Sto	O'HARA'S IRISH STOUT BUT. 0,5 L	5391500600032	311	szt	0.77	RI-02-00	2024-12-09	0	311
1576	Oha Iri Sto Nit k-keg 30	O'HARA'S IRISH STOUT NITRO K-KEG 30 L	5391500601336	6	szt	32.00	AT-29-04	2024-12-09	0	6
1577	Oha Lea	O'HARA'S LEANN FOLLAIN BUT. 0,5 L	5391500600551	100	szt	0.77	RH-07-01	2024-12-09	0	100
1578	Oha Lea Fol k-keg 30	O'HARA'S LEANN FOLLAIN K-KEG 30 L	5123456791279	3	szt	32.00	AT-29-04	2024-12-09	0	3
1579	Oha Lea can	O'HARA'S LEANN FOLLAIN PUSZKA 0,44 L	5391500602524	330	szt	0.48	RI-03-00	2024-12-09	0	330
1580	Oha Ses IPA	O'HARA'S SESSION IPA BUT. 0,5 L	5391500602111	50	szt	0.77	RH-07-01	2024-12-09	0	50
1581	Oha Szkl Non 5	O'HARA'S SZKLANKA NONIC 0,5 L	5123456791387	33	szt	0.00	RH-06-01	2024-12-09	0	33
1582	Oha Szkl Sha 5	O'HARA'S SZKLANKA SHAKER 0,5 L	5123456791388	54	szt	0.00	RH-07-01	2024-12-09	0	54
1583	Oha Tro IPA	O'HARA'S TROPICAL IPA BUT. 0,5 L	5391500602135	35	szt	0.77	RH-07-01	2024-12-09	0	35
1584	Oha Whi Haz	O'HARA'S WHITE HAZE BUT. 0,5 L	5391500601954	45	szt	0.77	RH-07-01	2024-12-09	0	45
1585	KAT06413	OMNIPOLLO PLUCKIN’ FEATHERS  BUT. 0,33 L	7350064995075	41	szt	0.50	RH-08-01	2024-12-09	0	41
1586	KAT03322	OMNIPOLLO SZKLANKA 0,3 L	5123456791109	8	szt	0.00	AT-29-04	2024-12-09	0	8
1587	KAT05456	ONE MORE BEER T-SHIRT SZARY (XXL)	5123456791108	1	szt	0.00	AT-29-04	2024-12-09	0	1
1588	KAT06505	OSKAR BLUES CAN-O-BLISS RESINOUS PUSZKA 0,35 L	819942001811	1	szt	0.00	AT-29-04	2024-12-09	0	1
1589	OUD BER TRI 375	OUD BEERSEL BERSALIS TRIPEL OAK AGED BUT. 0,375 L	5425018070763	17	szt	0.50	RH-08-01	2024-12-09	0	17
1590	OUD GEU VAN 135 375	OUD BEERSEL GEUZE VANDERVELDEN 135 BUT. 0,375 L	5425018070404	132	szt	0.50	RI-01-00	2024-12-09	0	132
1591	OUD GUE VAN 137 375	OUD BEERSEL GEUZE VANDERVELDEN 137 BUT. 0,375 L	5425018070640	25	szt	0.50	RH-08-01	2024-12-09	0	25
1592	OUD GUE 2016 750	OUD BEERSEL OUDE GUEUZE 2016 BUT. 0,75 L	5425018070121	43	szt	1.10	RH-08-01	2024-12-09	0	43
1593	OUD GUE BAR PIJ 375	OUD BEERSEL OUDE GUEUZE BARREL SELECTION OUDE PIJPEN BUT. 0,375 L	5425018070459	39	szt	0.50	RH-08-01	2024-12-09	0	39
1594	OUD OUG VAN 140 375	OUD BEERSEL OUDE GUEUZE VANDERVELDEN 140 YEARS BUT. 0,375 L	5425018071234	8	szt	0.50	AT-29-04	2024-12-09	0	8
1595	KAT02305	OUD BEERSEL TRADITIONAL OUDE GEUZE/KRIEK SZKLANKA 0,25 L	5123456791103	67	szt	0.00	RH-08-01	2024-12-09	0	67
1596	PAL AQU	PALATUM AQUA IMPERIALE PUSZKA 0,5 L	5905159520100	9	szt	0.54	RA-20-00	2024-12-09	0	9
1597	PAL_ETE_ECL_COC_PUSZ_500	PALATUM ETERNAL ECLIPSE COCOA EDDITON PUSZKA 0,5 L	5905159520179	30	szt	0.54	RH-09-01	2024-12-09	0	30
1599	Pal tra zw	Paleta transportowa zw	\N	3206	szt	0.00	AT-17	2024-12-09	0	3206
1600	PAL GRE 250	PALM GREEN NA BUT. 0,25 L	5410783031019	205	szt	0.35	RI-02-00	2024-12-09	0	205
1601	357	PASSENDALE POKAL 0,25 L	5123456791069	1	szt	0.00	AT-29-04	2024-12-09	0	1
1602	296	PAX PILS SZKLANKA 0,25 L	5123456791033	57	szt	0.00	RH-09-01	2024-12-09	0	57
1603	PET AGE PAL TAP HAN	PETRUS AGED PALE TAP HANDLE	5123456791373	1	szt	0.00	AT-29-04	2024-12-09	0	1
1604	PET BLA REK	PETRUS BLACHA REKLAMOWA	5123456791101	7	szt	0.00	RA-20-00	2024-12-09	0	7
1605	PET BLO 330	PETRUS BLOND BUT. 0,33 L	875213000044	52	szt	0.50	RH-09-01	2024-12-09	0	52
1606	PET BLO 750	PETRUS BLOND BUT. 0,75 L	875213000228	14	szt	1.10	RH-07-01	2024-12-09	0	14
1607	PET BOR KEG 30	PETRUS BORDEAUX KEG 30 L	\N	2	szt	32.00	AT-29-04	2024-12-09	0	2
1608	PET BOR TAP HAN	PETRUS BORDEAUX TAP HANDLE	5123456791374	1	szt	0.00	AT-29-04	2024-12-09	0	1
1609	344	PETRUS KIELICH 0,33 L	5123456791178	204	szt	0.00	RI-03-00	2024-12-09	0	204
1610	PET MAT BAR	PETRUS MATA BAROWA	5123456791375	1	szt	0.00	RA-20-00	2024-12-09	0	1
1611	PET NIT CHER CHO 330	PETRUS NITRO CHERRY CHOCO BUT. 0,33 L	875213001522	295	szt	0.50	RI-04-00	2024-12-09	0	295
1612	PET NIT CHER CHO K 30	PETRUS NITRO CHERRY CHOCO KEG 30 L	5123456789019	1	szt	32.00	RA-20-00	2024-12-09	0	1
1613	PET POL SHI XL	PETRUS POLO SHIRT XL	5123456791360	2	szt	0.00	RA-20-00	2024-12-09	0	2
1614	PET RED CZA DAS	PETRUS RED CZAPKA Z DASZKIEM	5123456791376	1	szt	0.00	RA-20-00	2024-12-09	0	1
1615	KAT06921	PETRUS RED KIELICH 0,25 L	5123456791177	9	szt	0.00	RA-20-00	2024-12-09	0	9
1616	PET RED TAP HAN	PETRUS RED TAP HANDLE	5123456791377	1	szt	0.00	RA-20-00	2024-12-09	0	1
1617	PET ROO BRU 330	PETRUS ROOD BRUIN BUT. 0,33 L	875213000068	44	szt	0.50	RH-09-01	2024-12-09	0	44
1618	PET TRA ZES 3X330 + SZ	PETRUS TRADITION ZESTAW (3X 0,33 L + SZKŁO)	5411831002500	24	szt	0.00	RH-09-01	2024-12-09	0	24
1619	PET TRI 750	PETRUS TRIPEL BUT. 0,75 L	875213000099	9	szt	1.10	RA-20-00	2024-12-09	0	9
1620	PI_COLD_COOL_CAN	PINTA / Sibeeria Cold's Cool 13,0° can 0,5 l	8596301014331	1084	szt	0.00	RA-07-04	2024-12-09	0	1084
1621	PI_COLD_COOL_KKEG_20	PINTA / Sibeeria Cold's Cool 13,0° keykeg 20 l	\N	6	szt	0.00	RA-20-00	2024-12-09	0	6
1622	PI Aja	PINTA A ja Pale Ale 12,0° but. 0,5 l	5904730438582	951	szt	0.00	RA-08-02	2024-12-09	0	951
1623	PI Aja keg 20	PINTA A ja pale ale 12,0° keg 20 l	5123456789652	3	szt	0.00	RA-20-00	2024-12-09	0	3
1624	PI Aja keg 30	PINTA A ja pale ale 12,0° keg 30 l	5123456789653	16	szt	0.00	RH-09-01	2024-12-09	0	16
1625	PI_ALA_GRO_BUT_500	PINTA A'la Grodzisz 7,8° but. 0,5 l	5904165104311	135	szt	0.00	RI-01-00	2024-12-09	0	135
1626	PI Ang	PINTA Angielskie Śniadanie 14,0° but. 0,5 l	5904165100849	1	szt	0.00	RA-20-00	2024-12-09	0	1
1627	PI Ata	PINTA Atak Chmielu 15,0° but. 0,5 l	5904730438605	1778	szt	0.00	AT-18	2024-12-09	0	1778
1628	PI Ata keg 20	PINTA Atak Chmielu 15,0° keg 20 l	5123456789661	6	szt	0.00	RA-20-00	2024-12-09	0	6
1629	PI Ata keg 30	PINTA Atak Chmielu 15,0° keg 30 l	5123456789662	31	szt	0.00	RH-10-01	2024-12-09	0	31
1630	PBB_ROS_WIL_KEG_10	PINTA Barrel Brewing - After Hours - Rose Wild Ale 12,0° keg 10 L	5123456780031	1	szt	0.00	RA-20-00	2024-12-09	0	1
1631	PBB_TRO_WIL_KEG_10	PINTA Barrel Brewing - After Hours - Tropical Wild Ale 12,0° keg 10 L	5123456780018	1	szt	0.00	RA-20-00	2024-12-09	0	1
1632	PBB_AUTH_BUT_375	PINTA BARREL BREWING AUTHORITY 15,0° BUT. 0,375 L	5904335577655	1	szt	0.50	RA-20-00	2024-12-09	0	1
1633	PBB Cou	PINTA Barrel Brewing Courage but. 0,33 l	5904335577464	48	szt	0.00	RH-10-01	2024-12-09	0	48
1634	PBB Cur	PINTA Barrel Brewing Curiosity but. 0,375 l	5904335577457	317	szt	0.00	RI-05-00	2024-12-09	0	317
1635	PBB_DIR_BUT_330	PINTA BARREL BREWING DIRECTION 30,0° BUT. 0,33 L	5904335577495	30	szt	0.50	RH-10-01	2024-12-09	0	30
1636	PBB_DIS_BUT_375	PINTA BARREL BREWING DISCLOSED 12,0° BUT. 0,375 L	5904335577501	20	szt	0.50	RH-10-01	2024-12-09	0	20
1637	PBB_ENO_2023_BUT_375	PINTA Barrel Brewing Enology 2023 but. 0,375 l	5904335577365	27	szt	0.00	RH-10-01	2024-12-09	0	27
1638	PBB_ENO_2023_BUT_750	PINTA Barrel Brewing Enology 2023 but. 0,75 l	5904335577570	9	szt	0.00	RA-20-00	2024-12-09	0	9
1639	PBB Gra	PINTA Barrel Brewing Grandeur but. 0,33 l	5904335577341	21	szt	0.00	RH-10-01	2024-12-09	0	21
1640	PBB_INFL_BUT_375	PINTA BARREL BREWING INFLAME 12,0° BUT. 0,375 L	5904335577617	19	szt	0.50	RH-11-01	2024-12-09	0	19
1641	PBB_INFL_BUT_750	PINTA BARREL BREWING INFLAME 12,0° BUT. 0,750 L	5904335577624	10	szt	0.00	RA-20-01	2024-12-09	0	10
1642	PBB_LIB_2023_BUT_330	PINTA Barrel Brewing Liberty 2023 but. 0,33 l	5904335577075	39	szt	0.00	RH-11-01	2024-12-09	0	39
1643	PBB Mem	PINTA Barrel Brewing Memory but. 0,33 l	5904335577419	297	szt	0.00	RI-06-00	2024-12-09	0	297
1644	PBB_MOS_BUT_330	PINTA Barrel Brewing Moss but. 0,33 l	5904335577563	10	szt	0.00	RA-20-01	2024-12-09	0	10
1645	PBB_PER_BUT_330	PINTA BARREL BREWING PERCEPTION 30,0° BUT. 0,33 L	5904335577471	8	szt	0.50	RA-20-01	2024-12-09	0	8
1646	PBB Pok Tek 0,1	PINTA Barrel Brewing Pokal Teku 0,1 l	5904335577051	5	szt	0.00	RA-20-01	2024-12-09	0	5
1647	PBB_SCA_BUT_375	PINTA Barrel Brewing Scarlet but. 0,375 l	5904335577549	32	szt	0.00	RH-11-01	2024-12-09	0	32
1648	PBB_SCA_BUT_750	PINTA Barrel Brewing Scarlet but. 0,75 l	5904335577556	3	szt	0.00	RA-20-01	2024-12-09	0	3
1649	PBB_SEE_BUT_750	PINTA BARREL BREWING SEED 12,0° BUT. 0,750 L	5904335577648	13	szt	0.00	RH-11-01	2024-12-09	0	13
1650	PBB_TEM_BUT_375	PINTA BARREL BREWING TEMPLE 12,0° BUT. 0,375 L	5904335577525	43	szt	0.50	RH-11-01	2024-12-09	0	43
1651	PI Baw	PINTA Bawarka 13,0° but. 0,5 l	5908252864003	457	szt	0.00	RI-07-00	2024-12-09	0	457
1652	PI Baw W keg 30	PINTA Bawarka 13,0° keg 30 l	5123456789666	1	szt	0.00	RA-20-00	2024-12-09	0	1
1653	PI Bes APA	PINTA Beskidy APA 12,0° but. 0,5 l	5908252864188	1126	szt	0.00	RA-08-03	2024-12-09	0	1126
1654	PI Bes APA keg 20	PINTA Beskidy APA 12,0° keg 20 l	5123456789669	2	szt	0.00	RA-20-01	2024-12-09	0	2
1655	PI Bes APA keg 30	PINTA Beskidy APA 12,0° keg 30 l	5123456789670	5	szt	0.00	RA-20-01	2024-12-09	0	5
1656	PI Bes Pil	PINTA Beskidy Pils 12,0° but. 0,5 l	5904730438926	350	szt	0.00	RB-04-02	2024-12-09	0	350
1657	PI Bes Pil keg 20	PINTA Beskidy Pils 12,0° keg 20 l	5123456789671	1	szt	0.00	RA-20-00	2024-12-09	0	1
1658	PI Bes Pil keg 30	PINTA Beskidy Pils 12,0° keg 30 l	5123456789672	2	szt	0.00	RA-20-01	2024-12-09	0	2
1659	PI_BES_PRA_CIE_BUT_500	PINTA Beskidy Prawdziwe Ciemne 13,0° but. 0,5 l	5904730438995	307	szt	0.00	RB-04-02	2024-12-09	0	307
1660	PI Bes Pra Cie	PINTA Beskidy Prawdziwe Ciemne 15,0° but. 0,5 l	5904730438995	5	szt	0.00	RA-20-01	2024-12-09	0	5
1661	PI Bes Psz	PINTA Beskidy Pszeniczne 13,0° but. 0,5 l	5904730438933	630	szt	0.00	RA-08-04	2024-12-09	0	630
1662	PI Bes Psz keg 30	PINTA Beskidy Pszeniczne 13,0° keg 30 l	5123456789676	14	szt	0.00	RH-11-01	2024-12-09	0	14
1663	PINTA Blu bor M	PINTA Bluza bordowa M	5904165100573	2	szt	0.00	RA-20-01	2024-12-09	0	2
1664	PINTA Blu bor S	PINTA Bluza bordowa S	5904165100566	1	szt	0.00	RA-20-01	2024-12-09	0	1
1665	PINTA Blu bor XL	PINTA Bluza bordowa XL	5904165100597	1	szt	0.00	RA-20-01	2024-12-09	0	1
1666	PINTA Blu cza L	PINTA Bluza czarna L	5904165100535	1	szt	0.00	RA-20-01	2024-12-09	0	1
1667	PINTA Blu cza M	PINTA Bluza czarna M	5904165100528	2	szt	0.00	RA-20-01	2024-12-09	0	2
1668	PINTA Blu cza S	PINTA Bluza czarna S	5904165100511	2	szt	0.00	RA-20-01	2024-12-09	0	2
1669	PINTA Blu cza XL	PINTA Bluza czarna XL	5904165100542	2	szt	0.00	RA-20-01	2024-12-09	0	2
1670	PINTA Blu cza XXL	PINTA Bluza czarna XXL	5904165100559	1	szt	0.00	RA-20-01	2024-12-09	0	1
1671	PI_COL_DEL_CAN_500	PINTA Cold Delivery 14,0° can 0,5 l	5904165104939	72	szt	0.00	RH-12-01	2024-12-09	0	72
1672	PI_COL_DEL_KEG_30	PINTA Cold Delivery 14,0° keg 30 l	5123456780036	2	szt	0.00	RA-20-01	2024-12-09	0	2
1673	PI_MAG_POL_CAN_440	PINTA Collab Dois Corvos - Magnetic Poles 22,0° can 0,44 l	5600701480467	1	szt	0.00	RA-20-01	2024-12-09	0	1
1674	PI_COLL_BRO_CAN_500	PINTA Collab PL: Brokreacja 15,0° can 0,5 l	5904165104564	433	szt	0.00	RI-08-00	2024-12-09	0	433
1675	PI_COLL_CZT_KEG_20	PINTA Collab PL: Cztery Ściany 15,0° keg 20 l	5123456780040	6	szt	0.00	RA-20-01	2024-12-09	0	6
1676	PI_COLL_CZT_KEG_30	PINTA Collab PL: Cztery Ściany 15,0° keg 30 l	5123456780041	1	szt	0.00	RA-20-01	2024-12-09	0	1
1677	PI Cza_PROM	PINTA Czarna Dziura 13,0° but. 0,5 l PROMOCJA (do 05.11.23)	\N	430	szt	0.00	RI-09-00	2024-12-09	0	430
1678	PI Dob can_PROM	PINTA Dobry Wieczór 13,0° can 0,5 l PROMOCJA (do 20.11.23)	\N	571	szt	0.00	RA-09-02	2024-12-09	0	571
1679	PI_DOU_DEL_BUT_500	PINTA Double Delivery 18,0° but. 0,5 l	5904165104953	25	szt	0.00	RH-12-01	2024-12-09	0	25
1680	PI_DOU_DEL_CAN_500	PINTA Double Delivery 18,0° can 0,5 l	5904165104977	72	szt	0.00	RH-12-01	2024-12-09	0	72
1681	PI_DOU_DEL_KEG_20	PINTA Double Delivery 18,0° keg 20 l	5123456780021	1	szt	0.00	RA-20-01	2024-12-09	0	1
1682	PI_DOU_DEL_KEG_30	PINTA Double Delivery 18,0° keg 30 l	5123456780045	12	szt	0.00	RH-12-01	2024-12-09	0	12
1683	PI_EVE_BO_AUG_KEG_30	PINTA Every Body August 10,5° keg 30 l	5123456780033	5	szt	0.00	RA-20-01	2024-12-09	0	5
1684	PI_HAZ_DEL_BUT_500	PINTA Hazy Delivery 15,0° but. 0,5 l	5904165103741	1620	szt	0.00	AT-18	2024-12-09	0	1620
1685	PI_HAZ_DEL_CAN_500	PINTA Hazy Delivery 15,0° can 0,5 l	5904165103840	352	szt	0.00	RB-04-02	2024-12-09	0	352
1686	PI_HAZ_DEL_KEG_20	PINTA Hazy Delivery 15,0° keg 20 l	5123456780022	5	szt	0.00	RA-20-02	2024-12-09	0	5
1687	PI_HAZ_DEL_KEG_30	PINTA Hazy Delivery 15,0° keg 30 l	5123456780042	5	szt	0.00	RA-20-02	2024-12-09	0	5
1688	PI_HD_MIN_GER_CAN_500	PINTA Hazy Discovery Minas Gerais 16,5° can 0,5 l	5904165104649	1	szt	0.00	RA-20-01	2024-12-09	0	1
1689	PI_HD_SOF_CAN_500	PINTA Hazy Discovery Sofia can 0,5 l	5904165105073	630	szt	0.00	RA-09-03	2024-12-09	0	630
1690	PI_HD_SOF_KEG_30	PINTA Hazy Discovery Sofia keg 30 l	5123456780020	3	szt	0.00	RA-20-02	2024-12-09	0	3
1691	PI_HD_TIM_CAN_500	PINTA Hazy Discovery Timisoara can 0,5 l	5904165105097	737	szt	0.00	RA-09-04	2024-12-09	0	737
1692	PI_HD_TIM_KEG_30	PINTA Hazy Discovery Timisoara keg 30 l	5123456780049	3	szt	0.00	RA-20-02	2024-12-09	0	3
1693	PI Haz Mor	PINTA Hazy Morning 12,0° but. 0,5 l	5904730438612	1869	szt	0.00	AT-19	2024-12-09	0	1869
1695	PI Haz Mor keg 30	PINTA Hazy Morning 12,0° keg 30 l	5123456789713	1	szt	0.00	RA-20-01	2024-12-09	0	1
1696	PI_HS_SAB_CAN_500	PINTA Hop Selection - Sabro can 0,5 l	5904165104779	18	szt	0.00	RH-12-01	2024-12-09	0	18
1698	PI IIP	PINTA IIPPAA 18,0° but. 0,5 l	5904730438766	1978	szt	0.00	AT-22	2024-12-09	0	1978
1699	PI IIP keg 20	PINTA IIPPAA 18,0° keg 20 l	5123456789722	2	szt	0.00	RA-20-02	2024-12-09	0	2
1700	PI IIP keg 30	PINTA IIPPAA 18,0° keg 30 l	5123456789723	13	szt	0.00	RH-12-01	2024-12-09	0	13
1701	PI_HOR_BUT_500	PINTA I'm so Horny! 18,0° but. 0,5 l	5904165103864	690	szt	0.00	RA-10-02	2024-12-09	0	690
1702	PI_HOR_KEG_30	PINTA I'm so Horny! 18,0° keg 30 l	5123456780034	2	szt	0.00	RA-20-02	2024-12-09	0	2
1703	PI Jak keg 20_PROM	PINTA Jak w dym 18,0° keg 20 l PROMOCJA	5123456780027	8	szt	0.00	RA-20-02	2024-12-09	0	8
1704	PI Jak keg 30	PINTA Jak w dym 18,0° keg 30 l	5123456789727	2	szt	0.00	RA-20-02	2024-12-09	0	2
1705	PI_JUL_JUN_TOU_KEG_30	PINTA July Jungle Tour 12,0° keg 30 l	5123456780032	1	szt	0.00	RA-20-02	2024-12-09	0	1
1706	PINTA Kar a4	PINTA Kartonik a4	5123456791292	70	szt	0.00	RH-13-01	2024-12-09	0	70
1707	PINTA Kos bia L	PINTA Koszulka biała L	5904165100436	2	szt	0.00	RA-20-02	2024-12-09	0	2
1708	PINTA Kos bia XL	PINTA Koszulka biała XL	5904165100443	2	szt	0.00	RA-20-02	2024-12-09	0	2
1709	PINTA Kos bia XXL	PINTA Koszulka biała XXL	5904165100450	2	szt	0.00	RA-20-02	2024-12-09	0	2
1710	PINTA Kos cza L	PINTA Koszulka czarna L	5904165100382	2	szt	0.00	RA-20-02	2024-12-09	0	2
1711	PINTA Kos cza M	PINTA Koszulka czarna M	5904165100375	1	szt	0.00	RA-20-02	2024-12-09	0	1
1712	PINTA Kos cza XL	PINTA Koszulka czarna XL	5904165100399	2	szt	0.00	RA-20-02	2024-12-09	0	2
1713	PINTA Kosz HC czar 2XL	PINTA Koszulka HC czarna 2XL	5904165102966	3	szt	0.00	RA-20-02	2024-12-09	0	3
1714	PINTA Kosz HC czar 3XL	PINTA Koszulka HC czarna 3XL	5904165102973	2	szt	0.00	RA-20-02	2024-12-09	0	2
1715	PINTA Kosz HC czar L	PINTA Koszulka HC czarna L	5904165102980	3	szt	0.00	RA-20-02	2024-12-09	0	3
1716	PINTA Kosz HC czar M	PINTA Koszulka HC czarna M	5904165102997	2	szt	0.00	RA-20-02	2024-12-09	0	2
1717	PINTA Kosz HC czar S	PINTA Koszulka HC czarna S	5904165103000	2	szt	0.00	RA-20-02	2024-12-09	0	2
1718	PINTA Kosz HC czar XL	PINTA Koszulka HC czarna XL	5904165103017	2	szt	0.00	RA-20-02	2024-12-09	0	2
1719	PINTA Kos mie M	PINTA Koszulka miętowa M	5904165101310	2	szt	0.00	RA-20-02	2024-12-09	0	2
1720	PINTA Kos mie S	PINTA Koszulka miętowa S	5904165101303	2	szt	0.00	RA-20-02	2024-12-09	0	2
1721	PINTA Kos sza L	PINTA Koszulka szara L	5904165101273	2	szt	0.00	RA-20-03	2024-12-09	0	2
1722	PINTA Kos sza M	PINTA Koszulka szara M	5904165101266	2	szt	0.00	RA-20-03	2024-12-09	0	2
1723	PINTA Kos sza S	PINTA Koszulka szara S	5904165101259	2	szt	0.00	RA-20-03	2024-12-09	0	2
1724	PINTA Kos sza XL	PINTA Koszulka szara XL	5904165101280	2	szt	0.00	RA-20-03	2024-12-09	0	2
1725	PINTA Kos sza XXL	PINTA Koszulka szara XXL	5904165101297	2	szt	0.00	RA-20-03	2024-12-09	0	2
1726	PINTA Kos żół L	PINTA Koszulka żółta L	5904165100481	2	szt	0.00	RA-20-03	2024-12-09	0	2
1727	PINTA Kos żół M	PINTA Koszulka żółta M	5904165100474	2	szt	0.00	RA-20-03	2024-12-09	0	2
1728	PINTA Kos żół S	PINTA Koszulka żółta S	5904165100467	1	szt	0.00	RA-20-03	2024-12-09	0	1
1729	PINTA Kos żół XL	PINTA Koszulka żółta XL	5904165100498	2	szt	0.00	RA-20-03	2024-12-09	0	2
1730	PINTA Kos żół XXL	PINTA Koszulka żółta XXL	5904165100504	2	szt	0.00	RA-20-03	2024-12-09	0	2
1731	PI Kub pla	PINTA Kubek plastikowy Eco 0,5 l	5904165103123	72	szt	0.00	RH-13-01	2024-12-09	0	72
1732	PI Gam but	PINTA Kwas Gamma 13,0° but. 0,5 l	5903990622052	1161	szt	0.00	RA-10-03	2024-12-09	0	1161
1733	PI Gam keg 30	PINTA Kwas Gamma 13,0° keg 30 l	5123456789703	14	szt	0.00	RH-13-01	2024-12-09	0	14
1734	PI Jot	PINTA Kwas Jota 10,5° but. 0,5 l	5904165103048	64	szt	0.00	RH-13-01	2024-12-09	0	64
1735	PI Jot keg 20	PINTA Kwas Jota 10,5° keg 20 l	5123456789728	2	szt	0.00	RA-20-03	2024-12-09	0	2
1736	PI Jot keg 30	PINTA Kwas Jota 10,5° keg 30 l	5123456789729	3	szt	0.00	RA-20-03	2024-12-09	0	3
1737	PI Xy	PINTA Kwas Xy 12,0° but. 0,5 l	5908252864355	1550	szt	0.00	AT-19	2024-12-09	0	1550
1738	PI Xy keg 20	PINTA Kwas Xy 12,0° keg 20 l	5123456789810	3	szt	0.00	RA-20-03	2024-12-09	0	3
1739	PI Xy keg 30	PINTA Kwas Xy 12,0° keg 30 l	5123456789811	9	szt	0.00	RA-20-03	2024-12-09	0	9
1740	PI_MAS_COC_ORA_BUT_330	PINTA MASTERBAR Cocoa Nibs & Orange Peel 30,0° but. 0,33 l	5904165104021	45	szt	0.00	RH-13-01	2024-12-09	0	45
1741	PI_MAS_COC_ORA_KEG_10	PINTA MASTERBAR Cocoa Nibs & Orange Peel 30,0° keg 10 l	\N	3	szt	0.00	RA-20-03	2024-12-09	0	3
1742	PI_MAS_VAN_COC_BUT_330	PINTA MASTERBAR Vanilla & Coconut 30,0° but. 0,33 l	5904165103642	39	szt	0.00	RH-14-01	2024-12-09	0	39
1743	PI_MAS_VAN_COC_KEG_10	PINTA MASTERBAR Vanilla & Coconut 30,0° keg 10 l	\N	1	szt	0.00	RA-20-03	2024-12-09	0	1
1744	PI_MAS_VAN_COC_KEG_20	PINTA MASTERBAR Vanilla & Coconut 30,0° keg 20 l	\N	1	szt	0.00	RA-20-03	2024-12-09	0	1
1745	PINTA Mat bar	PINTA Mata barowa	5903990622434	8	szt	0.00	RA-20-03	2024-12-09	0	8
1746	PI Min IPA	PINTA Mini Maxi IPA but. 0,5 l	5904730438001	2216	szt	0.00	AT-23	2024-12-09	0	2216
1747	PI Mod	PINTA Modern Drinking 15,0° but. 0,5 l	5904730438599	1312	szt	0.00	AT-22	2024-12-09	0	1312
1748	PI Mod keg 20	PINTA Modern Drinking 15,0° keg 20 l	5123456789741	4	szt	0.00	RA-20-03	2024-12-09	0	4
1749	PI Mod keg 30	PINTA Modern Drinking 15,0° keg 30 l	5123456789742	10	szt	0.00	RA-20-03	2024-12-09	0	10
1750	PI Oto	PINTA Oto mata IPA 14,0° but. 0,5 l	5908252864300	775	szt	0.00	RA-10-04	2024-12-09	0	775
1751	PI Oto keg 30	PINTA Oto mata IPA 14,0° keg 30 l	5123456789755	10	szt	0.00	RA-20-03	2024-12-09	0	10
1752	PINTA Otw bar	PINTA Otwieracz barmański	5123456791386	1	szt	0.00	RA-20-03	2024-12-09	0	1
1753	PINTA Otw mag Ala	PINTA Otwieracz magnes Ala Grodziskie	5904165101679	10	szt	0.00	RA-20-04	2024-12-09	0	10
1754	PINTA Otw mag Ata	PINTA Otwieracz magnes Atak Chmielu	5904165101594	8	szt	0.00	RA-20-04	2024-12-09	0	8
1755	PINTA Otw mag Bes	PINTA Otwieracz magnes Beskidy	5903990622588	9	szt	0.00	RA-20-04	2024-12-09	0	9
1756	PINTA Otw mag Dob	PINTA Otwieracz magnes Dobry Wieczór	5904165101662	6	szt	0.00	RA-20-03	2024-12-09	0	6
1757	PINTA Otw mag IIP	PINTA Otwieracz magnes IIPPAA	5904165101624	9	szt	0.00	RA-20-04	2024-12-09	0	9
1758	PINTA Otw mag Kwa	PINTA Otwieracz magnes Kwas XY	5904165101600	8	szt	0.00	RA-20-04	2024-12-09	0	8
1759	PINTA Otw mag Log	PINTA Otwieracz magnes Logo	5904165101648	1	szt	0.00	RA-20-04	2024-12-09	0	1
1760	PINTA Otw mag Mod	PINTA Otwieracz magnes Modern Drinking	5904165101655	9	szt	0.00	RA-20-04	2024-12-09	0	9
1761	PINTA Otw mag Pie	PINTA Otwieracz magnes Pierwsza Pomoc	5904165101617	3	szt	0.00	RA-20-04	2024-12-09	0	3
1762	PI_PAR_STA_NZ_PAL_KEG_30	PINTA Party Starter NZ Pale Ale 12,0° keg 30 l	\N	1	szt	0.00	RA-20-04	2024-12-09	0	1
1763	PI_PAR_STA_PAK	PINTA PARTY STARTER PAK 6 x 0,5 L PUSZKA	5904165103673	10	szt	0.00	RA-20-04	2024-12-09	0	10
1764	PI_PAR_STA_SES_KEG_30	PINTA Party Starter Session IPA 12,0° keg 30 l	5123456780016	16	szt	0.00	RH-13-01	2024-12-09	0	16
1765	PI_PAR_23_COL_CAN_500	PINTA Party'23 Collab 12,0° can 0,5 l	5904165105011	595	szt	0.00	RA-09-02	2024-12-09	0	595
1766	PI_PAR_23_COL_KEG_30	PINTA Party'23 Collab 12,0° keg 30 l	5123456780023	6	szt	0.00	RA-20-04	2024-12-09	0	6
1767	PI Pie	PINTA Pierwsza Pomoc 10,5° but. 0,5 l	5904730438575	1102	szt	0.00	RA-11-02	2024-12-09	0	1102
1768	PI Pie keg 20	PINTA Pierwsza Pomoc 10,5° keg 20 l	5123456789764	8	szt	0.00	RA-21-00	2024-12-09	0	8
1769	PI Pie keg 30	PINTA Pierwsza Pomoc 10,5° keg 30 l	5123456789765	42	szt	0.00	RH-14-01	2024-12-09	0	42
1770	PI_PIL_TIM_BUT_500	PINTA Pils Time 12,0° but. 0,5 l	5904165104182	307	szt	0.00	RB-04-02	2024-12-09	0	307
1771	PI_PIL_TIM_CAN_500	PINTA Pils Time 12,0° can 0,5 l	5904165104281	513	szt	0.00	RA-08-04	2024-12-09	0	513
1772	PI_PIL_TIM_KEG_30	PINTA Pils Time 12,0° keg 30 l	\N	2	szt	0.00	RA-20-04	2024-12-09	0	2
1773	PINTA Pod kor ACH 2011	PINTA Podkładka korkowa Atak Chmielu 2011 Vintage	5903990622410	1	szt	0.00	RA-20-04	2024-12-09	0	1
1774	PI POR Cla keg 20	PINTA PORTERMASS Classic 30,0° keg 20 l	5123456789770	1	szt	0.00	RA-20-04	2024-12-09	0	1
1775	PI POR Smo Coc	PINTA PORTERMASS Smoked Plum & Coco Nibs 30,0° but. 0,33 l	5904165103512	1	szt	0.00	RA-20-04	2024-12-09	0	1
1776	PI_PSST_YOU_COLD_BUT_500	PINTA Psst... It's Your Weekend IPA - Cold IPA 15,0° but. 0,5 l	5904165104687	3	szt	0.00	RA-21-00	2024-12-09	0	3
1777	PI_PSST_YOU_COLD_KEG_20	PINTA Psst... It's Your Weekend IPA - Cold IPA 15,0° keg 20 l	5123456780029	1	szt	0.00	RA-20-04	2024-12-09	0	1
1778	PI_PSST_YOU_COLD_KEG_30	PINTA Psst... It's Your Weekend IPA - Cold IPA 15,0° keg 30 l	5123456780030	1	szt	0.00	RA-21-00	2024-12-09	0	1
1779	PI_PSST_YOU_FOGG_BUT_500	PINTA Psst... It's Your Weekend IPA - Foggy IPA 15,0° but. 0,5 l	5904165104700	846	szt	0.00	RA-11-03	2024-12-09	0	846
1780	PI_PSST_YOU_FOGG_KEG_30	PINTA Psst... It's Your Weekend IPA - Foggy IPA 15,0° keg 30 l	5123456780050	1	szt	0.00	RA-21-00	2024-12-09	0	1
1781	PI_PSST_YOU_HAZ_BUT_500	PINTA Psst... It's Your Weekend IPA - Hazy IPA 15,0° but. 0,5 l	5904165104694	967	szt	0.00	RA-11-04	2024-12-09	0	967
1782	PI_PSST_YOU_HAZ_KEG_30	PINTA Psst... It's Your Weekend IPA - Hazy IPA 15,0° keg 30 l	5123456780047	2	szt	0.00	RA-21-00	2024-12-09	0	2
1783	PI_PSST_YOU_WEST_BUT_500	PINTA Psst... It's Your Weekend IPA - West Coast IPA 15,0° but. 0,5 l	5904165104717	46	szt	0.00	RH-14-01	2024-12-09	0	46
1784	PI_PSST_YOU_WEST_KEG_30	PINTA Psst... It's Your Weekend IPA - West Coast IPA 15,0° keg 30 l	5123456780039	2	szt	0.00	RA-21-00	2024-12-09	0	2
1785	PI Ris Cla keg 20	PINTA Risfactor 30,0° keg 20 l	5123456789782	1	szt	0.00	RA-21-00	2024-12-09	0	1
1786	PI RIS CIN COC	PINTA RISFACTOR Cinnamon and Cocoa Nibs 30,0° but. 0,33 l	5904165103383	29	szt	0.00	RH-14-01	2024-12-09	0	29
1787	PI RIS Cin Coc keg 20	PINTA RISFACTOR Cinnamon and Cocoa Nibs 30,0° keg 20 l	5123456789908	1	szt	0.00	RA-21-00	2024-12-09	0	1
1788	PI RIS Coc Coc	PINTA RISFACTOR Cocoa Nibs and Coconut 30,0° but. 0,33 l	5904165102263	43	szt	0.00	RH-14-01	2024-12-09	0	43
1789	PI RIS Coc Coc keg 10	PINTA RISFACTOR Cocoa Nibs and Coconut 30,0° keg 10 l	5123456780052	1	szt	0.00	RA-21-00	2024-12-09	0	1
1790	PI RIS Coc Coc keg 20	PINTA RISFACTOR Cocoa Nibs and Coconut 30,0° keg 20 l	5123456789783	2	szt	0.00	RA-21-00	2024-12-09	0	2
1791	PI_RIS_COC_ROA_BUT_330	PINTA RISFACTOR Cocoa Nibs and Roasted Peanuts 30,0° but. 0,33 l	5904165104267	185	szt	0.00	RI-04-00	2024-12-09	0	185
1792	PI_RIS_COC_ROA_KEG_10	PINTA RISFACTOR Cocoa Nibs and Roasted Peanuts 30,0° keg 10 l	5123456780017	1	szt	0.00	RA-21-00	2024-12-09	0	1
1793	PI_SAN_BUT_500	PINTA Sangriale 15,0° but. 0,5 l	5904165103703	71	szt	0.00	RH-14-01	2024-12-09	0	71
1794	PI_SEL_IPA	PINTA Selection: IPA 3-pak + szkło + podkładki	5904165104076	8	szt	0.00	RA-21-00	2024-12-09	0	8
1795	PINTA Szk Apf	PINTA Szklanka Apfelwein 0,5 l	5904165100665	7	szt	0.00	RA-21-00	2024-12-09	0	7
1796	PINTA Szk Atl	PINTA Szklanka Atlantik 0,3 l	5904165100955	51	szt	0.00	RH-15-01	2024-12-09	0	51
1797	PINTA Szk Min	PINTA Szklanka Mini Maxi IPA 0,5 l	5904165102164	3	szt	0.00	RA-21-00	2024-12-09	0	3
1798	PINTA Szk Ome	PINTA Szklanka Omer 2021 0,3 l	5904165100689	13	szt	0.00	RH-15-01	2024-12-09	0	13
1799	PINTA Szk PP 2022	PINTA Szklanka Pinta Party 2022	5123456791324	53	szt	0.00	RH-15-01	2024-12-09	0	53
1800	PINTA Szk PM 2022	PINTA Szklanka PM 2022 0,5 l	5904165102065	17	szt	0.00	RH-15-01	2024-12-09	0	17
1801	PINTA_SZK_PM_2023	PINTA SZKLANKA PM 2023 0,5 L	\N	394	szt	0.00	RI-10-00	2024-12-09	0	394
1802	PINTA Szk Wei	PINTA Szklanka Weizen 2021 0,5 l	5904165100696	69	szt	0.00	RH-15-01	2024-12-09	0	69
1803	PINTA_SZK_YOU_BEE_500	PINTA Szklanka Your Beer Your Glass 0,5 l	\N	526	szt	0.00	RA-09-03	2024-12-09	0	526
1804	PINTA Kos Ata S	PINTA T-shirt Atak Chmielu S	5903990622694	2	szt	0.00	RA-21-00	2024-12-09	0	2
1805	PINTA Kos DL bia L	PINTA T-shirt biały duże logo L	5904165102461	2	szt	0.00	RA-21-00	2024-12-09	0	2
1806	PINTA Kos DL bia M	PINTA T-shirt biały duże logo M	5904165102454	2	szt	0.00	RA-21-00	2024-12-09	0	2
1807	PINTA Kos DL bia S	PINTA T-shirt biały duże logo S	5904165102447	2	szt	0.00	RA-21-00	2024-12-09	0	2
2571	WRE SAIL-ON	WRĘŻEL SAIL-ON BUT. 0,5 L	5904730465199	5	szt	0.77	RB-21-00	2024-12-09	0	5
1808	PINTA Kos DL bia XL	PINTA T-shirt biały duże logo XL	5904165102478	2	szt	0.00	RA-21-00	2024-12-09	0	2
1809	PINTA Kos DL bia XXL	PINTA T-shirt biały duże logo XXL	5904165102485	1	szt	0.00	RA-21-00	2024-12-09	0	1
1810	PINTA Kos DL cza M	PINTA T-shirt czarny duże logo M	5904165102409	1	szt	0.00	RA-21-00	2024-12-09	0	1
1811	PINTA Kos DL cza S	PINTA T-shirt czarny duże logo S	5904165102393	2	szt	0.00	RA-21-00	2024-12-09	0	2
1812	PINTA Kos DL cza XL	PINTA T-shirt czarny duże logo XL	5904165102423	1	szt	0.00	RA-21-00	2024-12-09	0	1
1813	PINTA Kos DL sza L	PINTA T-shirt szary duże logo L	5904165102515	2	szt	0.00	RA-21-00	2024-12-09	0	2
1814	PINTA Kos DL sza M	PINTA T-shirt szary duże logo M	5904165102508	2	szt	0.00	RA-21-00	2024-12-09	0	2
1815	PINTA Kos DL sza S	PINTA T-shirt szary duże logo S	5904165102492	1	szt	0.00	RA-21-01	2024-12-09	0	1
1816	PINTA Kos DL sza XL	PINTA T-shirt szary duże logo XL	5904165102522	2	szt	0.00	RA-21-01	2024-12-09	0	2
1817	PINTA Kos DL zie L	PINTA T-shirt zielony duże logo L	5904165102560	2	szt	0.00	RA-21-01	2024-12-09	0	2
1818	PINTA Kos DL zie M	PINTA T-shirt zielony duże logo M	5904165102553	2	szt	0.00	RA-21-01	2024-12-09	0	2
1819	PINTA Kos DL zie S	PINTA T-shirt zielony duże logo S	5904165102546	3	szt	0.00	RA-21-01	2024-12-09	0	3
1820	PI_TYP_BUT_500_PROM	PINTA typ niepoHOPny 12,0° but. 0,5 l PROMOCJA (do 27.10.23)	\N	10	szt	0.00	RA-21-01	2024-12-09	0	10
1821	PI_UPG_CAN_500	PINTA Upgrade Your September 12,0° can 0,5 l	5904165105158	18	szt	0.00	RH-15-01	2024-12-09	0	18
1822	PI_UPG_KEG_20	PINTA Upgrade Your September 12,0° keg 20 l	5123456780043	1	szt	0.00	RA-21-01	2024-12-09	0	1
1823	PI_UPG_KEG_30	PINTA Upgrade Your September 12,0° keg 30 l	5123456780044	12	szt	0.00	RH-16-01	2024-12-09	0	12
1824	PI Żyt	PINTA Żytorillo 14,0° but. 0,5 l	5904165103543	968	szt	0.00	RA-12-02	2024-12-09	0	968
1825	PI Żyt keg 20_PROM	PINTA Żytorillo 14,0° keg 20 l PROMOCJA (do 29.09.23)	5123456780019	2	szt	0.00	RA-21-01	2024-12-09	0	2
1826	PI Żyt keg 30	PINTA Żytorillo 14,0° keg 30 l	5123456780024	6	szt	0.00	RA-21-01	2024-12-09	0	6
1827	PIR 330	PIRAAT BUT. 0,33 L	5411663002600	5	szt	0.50	RA-21-01	2024-12-09	0	5
1828	KAT00631	PIRAAT POKAL 0,33 L	5123456791068	2	szt	0.00	RA-21-01	2024-12-09	0	2
1829	PIR RED 330	PIRAAT RED BUT. 0,33 L	5411663000781	118	szt	0.50	RI-05-00	2024-12-09	0	118
1830	PIR RED 330_PROM	PIRAAT RED BUT. 0,33 L PROMOCJA (do 07.10.23)	\N	21	szt	0.00	RH-16-01	2024-12-09	0	21
1831	PIR TRI HOP 330	PIRAAT TRIPLE HOP BUT. 0,33 L	5411663004772	31	szt	0.50	RH-16-01	2024-12-09	0	31
1832	PIW_POR_NOV_BUT_500	PIWNE PODRÓŻE PORTERRA NOVA BUT. 0,5 L	5907222560020	118	szt	0.77	RI-06-00	2024-12-09	0	118
1833	POD_AME_#1_PUSZ_500	PIWNE PODZIEMIE AMERICAN CLASSIC #1 PUSZKA 0,5 L	5904305482774	45	szt	0.54	RH-16-01	2024-12-09	0	45
1834	POD_APR_KEG_30	PIWNE PODZIEMIE APRICOT GOSE KEG 30 L	\N	1	szt	32.00	RA-21-01	2024-12-09	0	1
1835	POD_APR_PUSZ_500	PIWNE PODZIEMIE APRICOT GOSE PUSZKA 0,5 L	5904305482804	59	szt	0.54	RH-16-01	2024-12-09	0	59
1836	POD_CHM_CAS_KEG_30	PIWNE PODZIEMIE CHMIELOKRATA CASHMERE KEG 30 L	\N	1	szt	32.00	RA-21-01	2024-12-09	0	1
1837	POD_CHM_CAS_PUSZ_500	PIWNE PODZIEMIE CHMIELOKRATA CASHMERE PUSZKA 0,5 L	5904305482781	22	szt	0.54	RH-16-01	2024-12-09	0	22
1838	POD_CHM_HBC_586_PUSZ_500	PIWNE PODZIEMIE CHMIELOKRATA HBC 586 PUSZKA 0,5 L	5904305482088	341	szt	0.54	RI-11-00	2024-12-09	0	341
1839	POD_CHM_NEL_PUSZ_500	PIWNE PODZIEMIE CHMIELOKRATA NELSON SAUVIN PUSZKA 0,5 L	5904305482149	22	szt	0.54	RH-17-01	2024-12-09	0	22
1840	POD_COS_BUT_500	PIWNE PODZIEMIE COSMIC HIGHWAY BUT. 0,5 L	5904305482828	111	szt	0.77	RI-06-00	2024-12-09	0	111
1841	POD_DR_HAZ_#1_PUSZ_500	PIWNE PODZIEMIE DR. HAZY #1 PUSZKA 0,5 L	5904305482835	117	szt	0.54	RI-10-00	2024-12-09	0	117
1842	POD_EXO_KEG_30	PIWNE PODZIEMIE EXOTICA KEG 30 L	\N	1	szt	32.00	RA-21-01	2024-12-09	0	1
1843	PODZ EXO	PIWNE PODZIEMIE EXOTICA PUSZKA  0,5 L	5904305482095	354	szt	0.00	RI-12-00	2024-12-09	0	354
1844	POD_GEO_PUSZ_500	PIWNE PODZIEMIE GEORGIA PEACH MOCHI PUSZKA 0,5 L	5904305482736	263	szt	0.54	RI-13-00	2024-12-09	0	263
1845	POD_ICE_PUSZ_500	PIWNE PODZIEMIE ICE TEA BERLINER PUSZKA 0,5 L	5904305482378	280	szt	0.54	RI-14-00	2024-12-09	0	280
1846	POD_JAS_CHE_BUT_500	PIWNE PODZIEMIE JASNE! CHEŁMLOVE! BUT. 0,5 L	5904305482743	383	szt	0.77	RI-15-00	2024-12-09	0	383
1847	PODZ JUI	PIWNE PODZIEMIE JUICILICIOUS BUT. 0,5 L	5907222444108	52	szt	0.77	RH-17-01	2024-12-09	0	52
1848	PODZ JUI K	PIWNE PODZIEMIE JUICILICIOUS KEG 30 L	5123456789399	4	szt	32.00	RA-21-01	2024-12-09	0	4
1849	POD_KOS_BO_CHI_VAN_BUT_330	PIWNE PODZIEMIE KOSIARZ UMYSŁÓW BOURBON OAK CHIPS X VANILLA BUT. 0,33 L	5904305482613	40	szt	0.50	RH-17-01	2024-12-09	0	40
1850	POD_KOS_BUT_330	PIWNE PODZIEMIE KOSIARZ UMYSŁÓW BUT. 0,33 L	5904305482606	30	szt	0.50	RH-17-01	2024-12-09	0	30
1851	POD_KRA_DOO_SPE_BUT_330	PIWNE PODZIEMIE KRAKEN OF DOOM – SPECIAL VERSION BUT. 0,33 L	5904305482590	26	szt	0.50	RH-17-01	2024-12-09	0	26
1852	POD_KRA_DOO_BUT_330	PIWNE PODZIEMIE KRAKEN OF DOOM BUT. 0,33 L	5904305482583	30	szt	0.50	RH-17-01	2024-12-09	0	30
1853	POD_KRA_BUT_500	PIWNE PODZIEMIE KRAUTROCK BUT. 0,5 L	5904305482767	16	szt	0.77	RH-18-01	2024-12-09	0	16
1854	POD_NOW_BUT_500	PIWNE PODZIEMIE NOWOCZESNY PILS BUT. 0,5 L	5906874079409	191	szt	0.77	RI-11-00	2024-12-09	0	191
1855	POD_PER_KEG_30	PIWNE PODZIEMIE PERMANENT VACATION KEG 30 L	\N	1	szt	32.00	RA-21-01	2024-12-09	0	1
1856	POD_PER_PUSZ_500	PIWNE PODZIEMIE PERMANENT VACATION PUSZKA 0,5 L	5904305482811	24	szt	0.54	RH-18-01	2024-12-09	0	24
1857	POD_PHA_REA_KEG_30	PIWNE PODZIEMIE PHANTASMIC REALITY KEG 30 L	\N	1	szt	32.00	RA-21-01	2024-12-09	0	1
1858	POD_PHA_REA_PUSZ_500	PIWNE PODZIEMIE PHANTASMIC REALITY PUSZKA 0,5 L	5904305482859	106	szt	0.54	RI-08-00	2024-12-09	0	106
1859	POD_PHA_DAY_PUSZ_500	PIWNE PODZIEMIE PHANTASTIC DAY PUSZKA 0,5 L	5904305482842	20	szt	0.54	RH-18-01	2024-12-09	0	20
1860	PODZ TRO K	PIWNE PODZIEMIE TROPICALIA KEG 30 L	5123456789400	4	szt	32.00	RA-21-01	2024-12-09	0	4
1861	PODZ WEL K 30	PIWNE PODZIEMIE WELWETOWE PODZIEMIE KEG 30 L	5123456789401	1	szt	32.00	RA-21-01	2024-12-09	0	1
1862	PODZ WEL	PIWNE PODZIEMIE WELWETOWE PODZIEMIE PUSZKA 0,5 L	5904305482798	30	szt	0.54	RH-18-01	2024-12-09	0	30
1863	PJAD SUS	PIWOJAD SUSKA BUT. 0,5 L	5906395053001	1	szt	0.77	RA-21-01	2024-12-09	0	1
1864	PJAD TRI MUF	PIWOJAD TRIPLE MUFFIN BUT. 0,33 L	5906395053346	28	szt	0.50	RH-18-01	2024-12-09	0	28
1865	PIW_BAR_OSTR_BUT_500	PIWOTEKA BARON OSTRĘŻYŃSKI  BUT. 0,5 L	5905669428088	46	szt	0.77	RH-18-01	2024-12-09	0	46
1866	PIW_CYT_SKR_BUT_500	PIWOTEKA CYTRYNOWYM SKRYTOPIJCOM BUT. 0,5 L	5905669428132	13	szt	0.77	RH-19-01	2024-12-09	0	13
1868	PIW_CZA_LAP_BUT_500	PIWOTEKA CZAISZ BAZĘ: LAPSANG SOUCHONG BUT. 0,5 L	5905669428101	41	szt	0.77	RH-19-01	2024-12-09	0	41
1869	PIW_DOB_ŁÓD_BUT_500	PIWOTEKA DOBRE BO ŁÓDZKIE BUT. 0,5 L	5905669428224	63	szt	0.77	RH-19-01	2024-12-09	0	63
1870	PIW_GOR_SNI_BUT_500	PIWOTEKA GORZKI ŚNIEG BUT. 0,5 L	5905669428170	47	szt	0.77	RH-19-01	2024-12-09	0	47
1871	PIW_LAS_BUT_500	PIWOTEKA LAS ŁAGIEWNICKI BUT. 0,5 L	5905669428569	33	szt	0.77	RH-19-01	2024-12-09	0	33
1872	PIW_PAR_SKR_BUT_500	PIWOTEKA PARÓWKOWYM SKRYTOŻERCOM BUT. 0,5 L	5905669428118	12	szt	0.77	RI-01-01	2024-12-09	0	12
1873	PIW_POM_SKU_BUT_500	PIWOTEKA POMALUTKU I DO SKUTKU BUT. 0,5 L	5905669428125	7	szt	0.77	RA-21-01	2024-12-09	0	7
1874	PIW_SZT_ETR_BUT_500	PIWOTEKA SZTUKA ETRUSKA BUT. 0,5 L	5905669428064	69	szt	0.77	RI-01-01	2024-12-09	0	69
1875	PODG 652 BBA	PODGÓRZ 652 M N.P.M. BOURBON B.A. BUT. 0,5 L	5906874055007	49	szt	0.77	RI-01-01	2024-12-09	0	49
1876	POD_652_BUT_500	PODGÓRZ 652 M N.P.M. BUT. 0,5 L	5906874055007	91	szt	0.77	RI-01-01	2024-12-09	0	91
1877	POD_IMP_652_BUT_500	PODGÓRZ IMPERIALNY 652 M N.P.M BUT. 0,5 L	5906874055373	111	szt	0.77	RI-12-00	2024-12-09	0	111
1878	PODG IMP 652 BBA	PODGÓRZ IMPERIALNY 652 M N.P.M. BOURBON BA BUT. 0,5 L	5906874055373	31	szt	0.77	RI-01-01	2024-12-09	0	31
1879	POD_MAŁ_BUT_500	PODGÓRZ MAŁY ALE WARIAT BUT. 0,5 L	5906874055540	62	szt	0.77	RI-02-01	2024-12-09	0	62
1880	POH_LIN_THE_CHE_BUT_330	P?HJALA - LINDHEIM THE CHERRY OF MY EYE  BUT. 0,33 L	4742976016116	36	szt	0.50	RI-01-01	2024-12-09	0	36
1881	KAT07116	P?HJALA - MIKKELLER SEA FOG PUSZKA 0,33 L	4742976015201	15	szt	0.35	RI-02-01	2024-12-09	0	15
1882	POH_STI_RAN_PUSZ_330	P?HJALA - STILLWATER RANNAK PUSZKA 0,33 L	4742976016215	44	szt	0.35	RI-02-01	2024-12-09	0	44
1883	POH_WEI_ZEI_BUT_330	P?HJALA - WEIHENSTEPHAN ZEIT BUT. 0,33 L	4742976016079	26	szt	0.50	RI-02-01	2024-12-09	0	26
1884	POH BAL POR DAY 20L	P?HJALA BALTIC PORTER DAY 2023 KEG 20 L	\N	2	szt	21.50	RA-21-01	2024-12-09	0	2
1885	POH BAL POR DAY BA	P?HJALA BALTIC PORTER DAY BA 2022 BUT. 0,33 L	4742976015829	47	szt	0.50	RI-02-01	2024-12-09	0	47
1886	POH_BAN_BUT_330	P?HJALA BANGER BUT. 0,33 l	4742976015874	13	szt	0.00	RI-02-01	2024-12-09	0	13
1887	KAT06631	P?HJALA BELLE BULLE BUT. 0,33 L	4742976014228	34	szt	0.50	RI-03-01	2024-12-09	0	34
1888	POH CHA	P?HJALA CHÂTEAU NOIR BUT. 0,33 L	4742976014778	18	szt	0.50	RI-03-01	2024-12-09	0	18
1889	POH CHG	P?HJALA CHERRY GARDEN PUSZKA 0,33 L	4742976015447	48	szt	0.35	RI-03-01	2024-12-09	0	48
1890	POH COS NIG	P?HJALA COSY NIGHTS BUT. 0,33 L	4742976015508	49	szt	0.50	RI-03-01	2024-12-09	0	49
1891	POH CON 20L	P?HJALA COSY NIGHTS KEG 20 L	5123456789914	1	szt	21.50	RA-21-01	2024-12-09	0	1
1892	POH DRA	P?HJALA DRAYMAN'S BLEND BUT. 0,33 L	4742976015096	16	szt	0.50	RI-03-01	2024-12-09	0	16
1893	POH ELE	P?HJALA ELECTRIC BABA TONKA BUT. 0,33 L	4742976015157	10	szt	0.50	RA-21-01	2024-12-09	0	10
1894	POH GIM	P?HJALA GIMME DANGER BUT. 0,33 L	4742976012293	83	szt	0.50	RI-03-01	2024-12-09	0	83
1895	KAT06632	P?HJALA HELGE PUSZKA 0,33 L	4742976013535	24	szt	0.35	RI-04-01	2024-12-09	0	24
1896	POH LAA	P?HJALA LAAGER PUSZKA 0,44 L	4742976014082	10	szt	0.48	RA-21-02	2024-12-09	0	10
1897	POH LIQ	P?HJALA LIQUID PINATA BUT. 0,33 L	4742976014884	28	szt	0.50	RI-04-01	2024-12-09	0	28
1898	POH MUD BAN	P?HJALA MUDCAKE BÄNGER BUT. 0,33 L	4742976015584	10	szt	0.50	RA-21-02	2024-12-09	0	10
1899	POH MUS	P?HJALA MUST KULD BUT. 0,33 L	4742976010107	83	szt	0.50	RI-04-01	2024-12-09	0	83
1900	POH_MUS_KUL_CHA_BUT_330	P?HJALA MUST KULD CHAI LATTE PUSZKA 0,33 L	4742976015423	26	szt	0.35	RI-04-01	2024-12-09	0	26
1901	KAT01514	P?HJALA MUST KULD KEG 30 L	5123456789007	1	szt	32.00	RA-21-01	2024-12-09	0	1
1902	POH_MUS_KUL_PAP_BUT_330	P?HJALA MUST KULD PAPER MILL PUSZKA 0,33 L	4742976015621	11	szt	0.35	RI-04-01	2024-12-09	0	11
1903	POH_MUS_KUL_BUT_330	P?HJALA MUST KULD PUSZKA 0,33 L	4742976013764	20	szt	0.35	RI-04-01	2024-12-09	0	20
1904	POH_OCE_ROA_PUSZ_330	P?HJALA OCEAN ROAD PUSZKA 0,33 L	4742976016093	6	szt	0.35	RA-21-02	2024-12-09	0	6
1905	KAT06432	P?HJALA OHTU PUSZKA 0,33 L	4742976013726	19	szt	0.35	RI-05-01	2024-12-09	0	19
1906	POH OO	P?HJALA ÖÖ BUT. 0,33 L	4742976010015	94	szt	0.50	RI-05-01	2024-12-09	0	94
1907	POH OO_PROM	P?HJALA ÖÖ BUT. 0,33 L PROMOCJA (do 28.10.23)	\N	55	szt	0.00	RI-05-01	2024-12-09	0	55
1908	POH OO 20L	P?HJALA ÖÖ KEG 20L	5123456789915	3	szt	0.00	RA-21-02	2024-12-09	0	3
1909	POH OO XO	P?HJALA ÖÖ XO BUT. 0,33 L	4742976010794	21	szt	0.50	RI-05-01	2024-12-09	0	21
1910	KAT02040	P?HJALA ÖÖ XO KEG 20 L	5123456789008	2	szt	21.50	RA-21-02	2024-12-09	0	2
1911	KAT06427	P?HJALA ORANGE GOSE PUSZ. 0,33 L	4742976013610	24	szt	0.00	RI-05-01	2024-12-09	0	24
1912	KAT06427_PROM	P?HJALA ORANGE GOSE PUSZ. 0,33 L PROMOCJA (do 12.10.23)	\N	19	szt	0.00	RI-05-01	2024-12-09	0	19
1913	POH PIM OO	P?HJALA PIME ÖÖ BUT. 0,33 L	4742976010183	60	szt	0.50	RI-06-01	2024-12-09	0	60
1914	KAT06431	P?HJALA PRENZLAUER BERG PUSZKA 0,33 L	4742976013689	22	szt	0.35	RI-06-01	2024-12-09	0	22
1915	KAT07115	P?HJALA PRENZLAUER PUSZKA 0,33 L	4742976013498	49	szt	0.35	RI-06-01	2024-12-09	0	49
1916	POH_SAT_PUSZ_440	P?HJALA SATURNUS PUSZKA 0,44 L	4742976015911	16	szt	0.48	RI-06-01	2024-12-09	0	16
1917	POH STR STO 20L	P?HJALA STRUDEL STOUT KEG 20 L	\N	1	szt	21.50	RA-21-02	2024-12-09	0	1
1918	POH_SUN_PUSZ_440	P?HJALA SUN CITY PUSZKA 0,44 L	4742976015133	41	szt	0.48	RI-06-01	2024-12-09	0	41
1919	POH TUM LAA	P?HJALA TUME LAAGER PUSZKA 0,44 L	4742976015362	23	szt	0.48	RI-06-01	2024-12-09	0	23
1920	POH_VAR_PUSZ_330	P?HJALA VARSKE PUSZKA 0,33 L	4742976014655	47	szt	0.35	RI-07-01	2024-12-09	0	47
1921	POH_VIR_O_ALK_PUSZ_330	P?HJALA VIRMASILED O ALKOHOLIVABA IPA PUSZKA 0,33 L	4742976013658	43	szt	0.35	RI-07-01	2024-12-09	0	43
1922	POH VIR	P?HJALA VIRVATULI BUT. 0,33 L	4742976015607	100	szt	0.50	RI-07-01	2024-12-09	0	100
1923	POKAL DUB	POKAL DUBBEL CIESZYŃSKI 0,4 L	5123456791316	157	szt	0.00	RI-13-00	2024-12-09	0	157
1924	PRAI TRV	PRAIRIE / TRVE EDITION SOUR RED FARMHOUSE ALE BUT. 0,5 L	683318988224	12	szt	0.77	RI-07-01	2024-12-09	0	12
1925	PRAI ALE	PRAIRIE ALE BUT. 0,5 L	894776000179	14	szt	0.77	RI-07-01	2024-12-09	0	14
1926	PRAI APR	PRAIRIE APRICOT FUNK BUT. 0,5 L	683318988408	19	szt	0.77	RI-07-01	2024-12-09	0	19
1927	PRAI BIR BA	PRAIRIE BIRTHDAY BOMB! - BARREL AGED BUT. 0,355 L	680132989260	20	szt	0.00	RI-08-01	2024-12-09	0	20
1928	PREI DEC CAC	PRAIRIE BOMB! DECONSTRUCTED: CACAO NIBS BUT. 0,355 L	680132989055	42	szt	0.00	RI-08-01	2024-12-09	0	42
1929	PRAI DEC CHI	PRAIRIE BOMB! DECONSTRUCTED: CHILLI BUT. 0,355 L	680132989055	49	szt	0.00	RI-08-01	2024-12-09	0	49
1930	PRAI DEC COF	PRAIRIE BOMB! DECONSTRUCTED: COFFEE BUT. 0,355 L	680132989055	43	szt	0.00	RI-08-01	2024-12-09	0	43
1931	PRAI DEC VAN	PRAIRIE BOMB! DECONSTRUCTED: VANILLA BUT. 0,355 L	680132989055	30	szt	0.00	RI-08-01	2024-12-09	0	30
1932	PRAI CHR BOM	PRAIRIE CHRISTMAS BOMB! BUT. 0,355 L	683318988354	2	szt	0.00	RA-21-02	2024-12-09	0	2
1933	PRAI MOS	PRAIRIE FUNKY GOLD MOSAIC BUT. 0,5 L	894776000995	8	szt	0.77	RA-21-02	2024-12-09	0	8
1934	PRAI PAR	PRAIRIE PARADAISE BUT. 0,355 L	683318988323	6	szt	0.00	RA-21-02	2024-12-09	0	6
1935	PRAI PRI	PRAIRIE PRISON RODEO BUT. 0,355 L	683318988415	19	szt	0.00	RI-08-01	2024-12-09	0	19
1936	PRAI STA	PRAIRIE STANDARD BUT. 0,355 L	894776000063	8	szt	0.00	RA-21-02	2024-12-09	0	8
1937	PRAI VOU	PRAIRIE VOUS FRANCAIS BUT. 0,75 L	683318988255	7	szt	1.10	RA-21-02	2024-12-09	0	7
1938	PRI LEZ K	PRIMÁTOR LEŽÁK 11° KEG 30 L	5123456789916	1	szt	32.00	RA-21-02	2024-12-09	0	1
1939	PRI PRE	PRIMÁTOR PREMIUM LAGER 12° BUT. 0,5 L	8594006933391	350	szt	0.77	RI-16-00	2024-12-09	0	350
1940	PRI PRE K	PRIMÁTOR PREMIUM LAGER 12° KEG 30 L	5123456789917	4	szt	32.00	RA-21-02	2024-12-09	0	4
1941	PRI WEI	PRIMÁTOR WEIZEN BUT. 0,5 L	8594006931663	650	szt	0.77	RA-12-03	2024-12-09	0	650
1942	PCH_DRO_#4_PUSZ_500	PRZETWÓRNIA CHMIELU DROBINKA #4 PUSZKA 0,5 L	5905476980571	51	szt	0.54	RI-09-01	2024-12-09	0	51
1943	PCH_ŁUS_PUSZ_500	PRZETWÓRNIA CHMIELU ŁUSKA PUSZKA 0,5 L	5905476980557	72	szt	0.54	RI-09-01	2024-12-09	0	72
1944	PCH_MUS_PUSZ_500	PRZETWÓRNIA CHMIELU MUS PUSZKA 0,5 L	5905476980540	42	szt	0.54	RI-09-01	2024-12-09	0	42
1945	PCH_OWO_PUSZ_500	PRZETWÓRNIA CHMIELU OWOC PUSZKA 0,5 L	5905476980588	125	szt	0.54	RI-14-00	2024-12-09	0	125
1946	PCH_PLA_#3_PUSZ_500	PRZETWÓRNIA CHMIELU PLANTACJA #3 PUSZKA 0,5 L	5905476980717	4	szt	0.54	RA-21-02	2024-12-09	0	4
1947	PCH_POM_PUSZ_500	PRZETWÓRNIA CHMIELU POMPA PUSZKA 0,5 L	5905476980670	10	szt	0.54	RA-21-03	2024-12-09	0	10
1948	PCH_PRE_PUSZ_500	PRZETWÓRNIA CHMIELU PRECEL PUSZKA 0,5 L	5905476980526	37	szt	0.54	RI-09-01	2024-12-09	0	37
1949	PCH_PRZ_PUSZ_500_PROM	PRZETWÓRNIA CHMIELU PRZECIER PUSZKA 0,5 L PROMOCJA (DO 24.10.23)	\N	4	szt	0.00	RA-21-02	2024-12-09	0	4
1950	PCH_SŁO_PUSZ_500	PRZETWÓRNIA CHMIELU SŁOMKA PUSZKA 0,5 L	5905476980311	123	szt	0.54	RI-14-00	2024-12-09	0	123
1951	PCH_SZY#1_PUSZ_500	PRZETWÓRNIA CHMIELU SZYSZKA #1 GALAXY-SABRO PUSZKA 0,5 L	5907675597888	77	szt	0.54	RI-09-01	2024-12-09	0	77
1952	PCH_TWI#2_PUSZ_500	PRZETWÓRNIA CHMIELU TWIST #2 PUSZKA 0,5 L	5905476980335	67	szt	0.54	RI-10-01	2024-12-09	0	67
1953	PCH_TWI#3_PUSZ_500	PRZETWÓRNIA CHMIELU TWIST #3 WIŚNIA PUSZKA 0,5 L	5905476980533	61	szt	0.54	RI-10-01	2024-12-09	0	61
1954	PCH_TWI#4_PUSZ_500	PRZETWÓRNIA CHMIELU TWIST #4 MARAKUJA PUSZKA 0,5 L	5905476980649	85	szt	0.54	RI-10-01	2024-12-09	0	85
1955	RAC_AMER_ZW_BUT_500	RACIBORSKIE AMERICAN IPA ZW BUT. 0,5 L	5907506252047	125	szt	0.77	RI-15-00	2024-12-09	0	125
1956	RAC_AMER_WHI_BUT_500	RACIBORSKIE AMERICAN WHEAT LAGER ZW  BUT. 0,5 L	\N	85	szt	0.77	RI-10-01	2024-12-09	0	85
1957	RAC BEZ	RACIBORSKIE BEZALKOHOLOWE BUT. 0,5 L	5907506252504	20	szt	0.77	RI-09-01	2024-12-09	0	20
1958	RAC_BEZ_ZW_BUT_500	RACIBORSKIE BEZALKOHOLOWE ZW BUT. 0,5 L	5907506252504	155	szt	0.77	RI-16-00	2024-12-09	0	155
1959	RAC CIE	RACIBORSKIE CIEMNE BUT. 0,5 L	5907506252207	228	szt	0.77	RI-17-00	2024-12-09	0	228
1960	RAC KLA	RACIBORSKIE KLASYCZNE BUT. 0,5 L	5907506252726	1319	szt	0.77	AT-23	2024-12-09	0	1319
1961	RAC KLA P	RACIBORSKIE KLASYCZNE PUSZKA 0,5 L	5907506252719	82	szt	0.54	RI-11-01	2024-12-09	0	82
1962	RAZ KLA BUT ZW	RACIBORSKIE KLASYCZNE ZW BUT. 0,5 L	5907506252276	154	szt	0.77	RI-17-00	2024-12-09	0	154
1963	RAC MIO	RACIBORSKIE MIODOWE BUT. 0,5 L	5907506252573	225	szt	0.77	RI-18-00	2024-12-09	0	225
1964	RAC MIO BUT ZW	RACIBORSKIE MIODOWE ZW BUT. 0,5 L	5907506252085	145	szt	0.77	RI-17-00	2024-12-09	0	145
1965	RAC PIL	RACIBORSKIE PILS BUT. 0,5 L	5907506252269	301	szt	0.77	RI-18-00	2024-12-09	0	301
1966	RAC POR	RACIBORSKIE PORTER BUT. 0,5 L	5907506252115	120	szt	0.77	RI-13-00	2024-12-09	0	120
1967	RAC_PSZ_BUT_500	RACIBORSKIE PSZENICZNE BUT. 0,5 L	5907506252450	79	szt	0.77	RI-11-01	2024-12-09	0	79
1968	RAC_PSZ_ZW_BUT_500	RACIBORSKIE PSZENICZNE ZW BUT. 0,5 L	5907506252450	105	szt	0.77	RI-05-00	2024-12-09	0	105
1969	RAC_PY_CYT_KON_BUT_330	RACIBORSKIE PYRSK CYTRYNA-KONOPIA BUT. 0,33 L	5905249834094	57	szt	0.50	RI-11-01	2024-12-09	0	57
1970	RAC_PY_JAB_GRA_BUT_330	RACIBORSKIE PYRSK JABŁKO-GRANAT BUT. 0,33 L	5905249834100	17	szt	0.50	RI-11-01	2024-12-09	0	17
1971	RAC_PY_JAB_PIG_BUT_330	RACIBORSKIE PYRSK JABŁKO-PIGWOWIEC BUT. 0,33 L	5905249834087	82	szt	0.50	RI-12-01	2024-12-09	0	82
1972	RAC_PY_JAB_POM_IMB_BUT_330	RACIBORSKIE PYRSK JABŁKO-POMARAŃCZA-IMBIR BUT. 0,33 L	5905249834070	77	szt	0.50	RI-12-01	2024-12-09	0	77
1973	RAC RAD GRE BEZ	RACIBORSKIE RADLER GREJPFRUT BEZALKOHOLOWE BUT. 0,5 L	5907506252528	89	szt	0.77	RI-12-01	2024-12-09	0	89
1974	RAC_RAD_GRE_BEZ_ZW_BUT_500	RACIBORSKIE RADLER GREJPFRUT BEZALKOHOLOWE ZW BUT. 0,5 L	5907506252528	203	szt	0.77	RI-19-00	2024-12-09	0	203
2095	SCH SZK 0,25	SCHLENKERLA SZKLANKA 0,25 L	5123456791247	27	szt	0.00	RJ-02-01	2024-12-09	0	27
1975	RAC_SUM_ALE_BUT_500	RACIBORSKIE SUMMER ALE BUT. 0,5 L	5907506252542	93	szt	0.77	RI-13-01	2024-12-09	0	93
1976	RAC_SUM_CAN_BUT_500	RACIBORSKIE SUMMER ALE CANNABIS EDITION BUT. 0,5 L	5905249834063	32	szt	0.77	RI-11-01	2024-12-09	0	32
1977	RAC_SZKL_500	RACIBORSKIE SZKLANKA 0,5 L	\N	60	szt	0.00	RI-13-01	2024-12-09	0	60
1978	RAC_ZES_BAR_WIN_IMP_POR_SZK	RACIBORSKIE ZESTAW BARLEY WINE + IMPERIAL PORTER + SZKŁO DEGUSTACYJNE	5905249834025	11	szt	0.00	RI-11-01	2024-12-09	0	11
1979	RADU CIT CIT	RADUGA CITRUS CITRUS BUTELKA 0,5 L	5902176771706	15	szt	0.00	RI-12-01	2024-12-09	0	15
1980	RADU EAS	RADUGA EAST OF EDEN PUSZKA 0,5 L	5902176771768	1	szt	0.54	RA-21-02	2024-12-09	0	1
1981	RADU GAM#2	RADUGA GAME#2 BUT. 0,5 L	5902176770075	119	szt	0.77	RI-19-00	2024-12-09	0	119
1982	RADU GAM#3	RADUGA GAME#3 BUT. 0,5 L	5902176770860	245	szt	0.77	RJ-01-00	2024-12-09	0	245
1983	RADU GAM#4	RADUGA GAME#4 BUT. 0,5 L	5902176770877	525	szt	0.77	RA-12-03	2024-12-09	0	525
1984	RAD_GOO_PUSZ_500	RADUGA GOOD DAY! PUSZKA 0,5 L	5902176772031	64	szt	0.54	RI-13-01	2024-12-09	0	64
1985	RAD_GOO_MAT_BUT_500	RADUGA GOOD MATERIAL BUT. 0,5 L	5902176771485	21	szt	0.77	RI-12-01	2024-12-09	0	21
1986	RAD_IS_JUS_PUSZ_500	RADUGA IS THIS JUST FANTASY? PUSZKA 0,5 L	5902176772000	325	szt	0.54	RJ-02-00	2024-12-09	0	325
1987	RAD_IS_REA_PUSZ_500	RADUGA IS THIS THE REAL LIFE? PUSZKA 0,5 L	5902176772017	334	szt	0.54	RJ-03-00	2024-12-09	0	334
1988	RAD_KIN_FRU_BUT_500	RADUGA KINGDOM OF FRUITS BUT. 0,5 L	5902176772055	92	szt	0.77	RI-14-01	2024-12-09	0	92
1989	RADU LAS	RADUGA LAST SUMMER BUT. 0,5 L	5902448150178	184	szt	0.77	RI-19-00	2024-12-09	0	184
1990	RADU LEO	RADUGA LEON BUT. 0,5 L	5902176770099	45	szt	0.77	RI-13-01	2024-12-09	0	45
1991	RAD_MAN_BUT_500	RADUGA MANGOTRIX BUT. 0,5 L	5902176770853	400	szt	0.77	RJ-04-00	2024-12-09	0	400
1992	RADU MAR	RADUGA MARTIAN BUT. 0,33 L	5902176770037	22	szt	0.50	RI-13-01	2024-12-09	0	22
1993	RADU MET	RADUGA METROPOLIS BUT. 0,5 L	5907431705083	55	szt	0.77	RI-14-01	2024-12-09	0	55
1994	RADU_NOS_PUSZ_500	RADUGA NOSFERATU PUSZKA 0,5 L	5902176772024	199	szt	0.54	RJ-01-00	2024-12-09	0	199
1995	RADU SAM	RADUGA SAMURAI REBELLION BUT. 0,5 L	5907431705236	248	szt	0.77	RJ-05-00	2024-12-09	0	248
1996	RADU TRA	RADUGA TRAPEZE BUT. 0,5 L	5907431705359	87	szt	0.77	RI-14-01	2024-12-09	0	87
1997	RADU UNE_PROM	RADUGA UNEXPECTED GUESTS BUT. 0,5 L PROMOCJA (do 13.09.23)	\N	104	szt	0.00	RI-09-00	2024-12-09	0	104
1998	RAD_WAK_PUSZ_500	RADUGA WAKE ME! PUSZKA 0,5 L	5902176772048	75	szt	0.54	RI-15-01	2024-12-09	0	75
1999	REC_AMS_PUSZ_500	RECRAFT AMSTERDAM PILS PUSZKA 0,5 L	5904730663748	25	szt	0.54	RI-14-01	2024-12-09	0	25
2000	REC BLA CUR	RECRAFT BLACK CURRIS BUT. 0,33 L	5900779755086	847	szt	0.50	RA-12-04	2024-12-09	0	847
2001	REC_CIT_IPA_PUSZ_500	RECRAFT CITRUS INDIA PALE ALE PUSZKA 0,5 L	5904730663809	238	szt	0.54	RJ-05-00	2024-12-09	0	238
2002	REC_HAZ_APA_BUT_500	RECRAFT HAZY APA BUT. 0,5 L	5900779755888	88	szt	0.77	RI-15-01	2024-12-09	0	88
2003	REC_JUI_BLA_PUSZ_500	RECRAFT JUICE SOUR SERIES – BLACK FRUITS PUSZKA 0,5 L	5904730663793	262	szt	0.54	RJ-06-00	2024-12-09	0	262
2004	REC_JUI_CHE_PUSZ_500	RECRAFT JUICY SOUR SERIES – CHERRY X BLUEBERRY PUSZKA 0,5 L	5900779755871	87	szt	0.54	RI-15-01	2024-12-09	0	87
2005	REC_JUI_GRA_PUSZ_500	RECRAFT JUICY SOUR SERIES – GRAVIOLA X LIMONKA PUSZKA 0,5 L	5900779755932	83	szt	0.54	RI-16-01	2024-12-09	0	83
2006	REC_JUI-LIC-ANA-BAN_PUSZ_500	RECRAFT JUICY SOUR SERIES – LICZI X ANANAS X BANAN X WINOGRONA PUSZKA 0,5 L	5900779755963	123	szt	0.54	RJ-02-00	2024-12-09	0	123
2007	REC_JUI_MAN_PUSZ_500	RECRAFT JUICY SOUR SERIES – MANGO LASSI PUSZKA 0,5 L	5900779755901	62	szt	0.54	RI-16-01	2024-12-09	0	62
2008	REC MC FAR	RECRAFT MC FARMER BUT. 0,5 L	5904730663052	196	szt	0.77	RJ-03-00	2024-12-09	0	196
2009	REC_OCE_PUSZ_500	RECRAFT OCEANIA PILS PUSZKA 0,5 L	5900779755895	4	szt	0.54	RA-21-03	2024-12-09	0	4
2010	REC_ORG_PUSZ_500	RECRAFT ORGANIC PILS PUSZKA 0,5 L	5900779755314	112	szt	0.54	RJ-04-00	2024-12-09	0	112
2011	REC_POL_HAZ_3/20_PUSZ_500	RECRAFT POLISH HAZY IPA AMORA PRETA & 3/20 PUSZKA 0,5 L	5904730663786	148	szt	0.54	RJ-06-00	2024-12-09	0	148
2012	REC_POL_HAZ_PRE_PUSZ_500	RECRAFT POLISH HAZY IPA AMORA PRETA & KSIĄŻĘCY PUSZKA 0,5 L	5904730663779	137	szt	0.54	RJ-07-00	2024-12-09	0	137
2013	REC POL	RECRAFT POLSKA PSZENICA BUT. 0,5 L	5904730663113	96	szt	0.77	RI-16-01	2024-12-09	0	96
2014	REC PUR	RECRAFT PURISTA BUT. 0,33 L	5900779755079	859	szt	0.50	RA-13-02	2024-12-09	0	859
2015	REC ŚWI	RECRAFT ŚWIĘTY PATRYK BUT. 0,5 L	5900779755062	191	szt	0.77	RJ-07-00	2024-12-09	0	191
2016	REC WHI	RECRAFT WHITEOUT PUSZKA 0,5 L	5900779755543	26	szt	0.54	RI-14-01	2024-12-09	0	26
2017	REC WIE	RECRAFT WIELKA SZYCHA BUT. 0,5 L	5904730663014	98	szt	0.77	RI-17-01	2024-12-09	0	98
2018	REV_ALK_TON_LEM_BUT_500	REVOLTA  ALKOHOLFREE 0% TONIC & LEMON EARL GREY AIPA BUT. 0,5 L	5900470095009	22	szt	0.77	RI-15-01	2024-12-09	0	22
2019	REV_EAR_BUT_500	REVOLTA EARL GREY AIPA BUT. 0,5 L	5900470050008	96	szt	0.77	RI-17-01	2024-12-09	0	96
2020	REV_LEM_EAR_BUT_500	REVOLTA LEMON & EARL GREY AIPA BUT. 0,5 L	5900470058004	445	szt	0.77	RJ-08-00	2024-12-09	0	445
2021	REV_NON_LEM_EAR_BUT_500	REVOLTA NON ALCOHOLIC LEMON EARL GREY AIPA BUT. 0,5 L	5900470056000	262	szt	0.77	RJ-09-00	2024-12-09	0	262
2022	REV_ORA_YER_BUT_500	REVOLTA ORANGE & YERBA MATE AIPA  BUT. 0,5 L	5900470071003	394	szt	0.77	RJ-10-00	2024-12-09	0	394
2023	REV_ROO_BUT_500	REVOLTA ROOIBOS PEAR MELON AIPA BUT. 0,5 L	5900470079009	100	szt	0.77	RI-17-01	2024-12-09	0	100
2024	ROCH 10 330	ROCHEFORT TRAPPISTES 10* BUT. 0,33 L	5412858000104	254	szt	0.50	RJ-09-00	2024-12-09	0	254
2025	ROCH 6 330	ROCHEFORT TRAPPISTES 6* BUT. 0,33 L	5412858000067	227	szt	0.50	RJ-11-00	2024-12-09	0	227
2026	ROCH 8 330	ROCHEFORT TRAPPISTES 8* BUT. 0,33 L	5412858000081	210	szt	0.50	RJ-07-00	2024-12-09	0	210
2027	ROCK_4TH_ANN_BUT_500	ROCKMILL 4TH ANNIVERSARY BUT. 0,5L	5908291862282	9	szt	0.00	RA-21-03	2024-12-09	0	9
115	ARTEZ MER	ARTEZAN MERA IPA BUT. 0,5 L	5904730574013	100	szt	0.77	RA-11-00	2024-12-09	0	174
2028	ROCK_BE_WI_#1_0_BUT_750	ROCKMILL BE WILD #1 0 BUT. 0,75 L	5906874027509	10	szt	1.10	RA-21-03	2024-12-09	0	10
2029	ROCK_BE_WI_#2_0_BUT_750	ROCKMILL BE WILD #2 0 BUT. 0,75 L	5906874027547	10	szt	1.10	RA-21-03	2024-12-09	0	10
2030	ROCK_BE_WI_#3_0_BUT_750	ROCKMILL BE WILD #3 0 BUT. 0,75 L	5906874027516	5	szt	1.10	RA-21-03	2024-12-09	0	5
2031	ROCK_COFF_PUSZ_500	ROCKMILL COFFEECAT PUSZKA 0,5 L	5908291862459	24	szt	0.54	RI-15-01	2024-12-09	0	24
2032	ROCK_FR_OR_FO_ARM_BUT_330	ROCKMILL FRIEND OR FOE? ARMAGNAC BA BUT. 0,33 L	5908291862497	30	szt	0.50	RI-16-01	2024-12-09	0	30
2033	ROCK_FR_OR_FO_RUM_BUT_330	ROCKMILL FRIEND OR FOE? RUM BA BUT. 0,33 L	5908291862480	14	szt	0.50	RI-12-01	2024-12-09	0	14
2034	ROCK_GAL_BRO_HOPP_BUT_500	ROCKMILL GALACTIC BROTHERHOOD: HOPPINESS BUT. 0,5 L	5908291862022	41	szt	0.77	RI-18-01	2024-12-09	0	41
2035	ROCK_GAL_BRO_Z_IN_BECZ_BUT_500	ROCKMILL GALACTIC BROTHERHOOD: Z INNEJ BECZKI BUT. 0,5 L	5908291862060	35	szt	0.77	RI-18-01	2024-12-09	0	35
2036	ROCK_HER_POL_PUSZ_500	ROCKMILL HERMANOS POLACOS PUSZKA 0,5 L	5908291862695	14	szt	0.54	RI-13-01	2024-12-09	0	14
2037	ROCK_INF_ARM_BA_BUT_500	ROCKMILL INFINITY ARMAGNAC BA BUT. 0,5 L	5908291862305	6	szt	0.77	RA-21-03	2024-12-09	0	6
2038	ROCK_INF_RUM_BA_BUT_500	ROCKMILL INFINITY RUM BA BUT. 0,5 L	5908291862299	1	szt	0.77	RA-21-02	2024-12-09	0	1
2040	ROCK_SOU_#2_PUSZ_500	ROCKMILL SOURLAND #2 PUSZKA 0,5 L	5908291862732	184	szt	0.54	RJ-12-00	2024-12-09	0	184
2041	ROCK_TRO_IMP_SOU_AL_PUSZ_440_PROM	ROCKMILL TROPICAL IMPERIAL SOUR ALE PUSZKA 0,44 L PROMOCJA (do 18.10.23)	\N	68	szt	0.00	RI-18-01	2024-12-09	0	68
2042	RODEN ALEX 330	RODENBACH ALEXANDER BUT. 0,33 L	5410583802574	571	szt	0.50	RA-13-03	2024-12-09	0	571
2043	RODEN ALEX 750	RODENBACH ALEXANDER BUT. 0,75 L	5410583802048	423	szt	1.10	RJ-13-00	2024-12-09	0	423
2044	RODEN CAR ROU 750	RODENBACH CARACTERE ROUGE BUT. 0,75 L	5410583802482	122	szt	1.10	RJ-06-00	2024-12-09	0	122
2045	RODEN CLA 250	RODENBACH CLASSIC BUT. 0,25 L	54125001	593	szt	0.35	RA-13-03	2024-12-09	0	593
2046	RODEN FRU 250	RODENBACH FRUITAGE BUT. 0,25 L	54125063	1309	szt	0.35	AT-24	2024-12-09	0	1309
2047	RODEN GRA 330	RODENBACH GRAND CRU BUT. 0,33 L	54125032	296	szt	0.50	RJ-12-00	2024-12-09	0	296
2048	RODEN GRA 750	RODENBACH GRAND CRU BUT. 0,75 L	5410583800181	204	szt	1.10	RJ-14-00	2024-12-09	0	204
2049	RODEN_GRA_EVO_BUT_750	RODENBACH GRAND CRU EVOLVED BUT. 0,75 L	5410583804103	328	szt	1.10	RJ-14-00	2024-12-09	0	328
2050	ROD K 20_PROM	RODENBACH KEG 20 L PROMOCJA (do 17.09.23)	\N	5	szt	0.00	RA-21-03	2024-12-09	0	5
2051	RODEN RED TRI 750_PROM	RODENBACH RED TRIPEL BUT. 0,75 L PROMOCJA (do 29.09.23)	\N	57	szt	0.00	RI-18-01	2024-12-09	0	57
2052	KAT07038	RODENBACH ROSSO SZKLANKA 0,5 L	5123456791031	8	szt	0.00	RA-21-03	2024-12-09	0	8
2053	RODEN TAP HAN	RODENBACH ROSSO TAP HANDLE	5123456791378	1	szt	0.00	RA-21-02	2024-12-09	0	1
2054	310	RODENBACH SZKLANKA 0,33 L	5123456791032	16	szt	0.00	RI-16-01	2024-12-09	0	16
2055	RODEN VIN 2019 750	RODENBACH VINTAGE 2019 BUT. 0,75 L	5410583803090	10	szt	1.10	RA-21-03	2024-12-09	0	10
2056	RODEN_VIN_2021_750	RODENBACH VINTAGE 2021 BUT. 0,75 L	5410583804196	400	szt	1.10	RJ-15-00	2024-12-09	0	400
2057	KAT01424	ROMY SZKLANKA 0,25 L	5123456791030	3	szt	0.00	RA-21-03	2024-12-09	0	3
2058	E2AB-2216E	SAISON 1858 SZKLANKA 0,25 L	5123456791028	6	szt	0.00	RA-21-04	2024-12-09	0	6
2059	SAIS DUP BIO 750	SAISON DUPONT BIOLOGIGUE BUT. 0,75 L	5410702000812	6	szt	1.10	RA-21-04	2024-12-09	0	6
2060	SAIS DUP BIOL 330	SAISON DUPONT BIOLOGIQUE BUT. 0,33 L	5410702000836	36	szt	0.50	RI-18-01	2024-12-09	0	36
2061	1035	SAISON DUPONT SZKLANKA 0,33 L	5123456791027	4	szt	0.00	RA-21-04	2024-12-09	0	4
2062	SS IMS	SAMUEL SMITH IMPERIAL STOUT BUT. 0,355 L	5010149200846	52	szt	0.00	RI-18-01	2024-12-09	0	52
2063	SS OST	SAMUEL SMITH OATMEAL STOUT BUT. 0,355 L	5010149200822	35	szt	0.00	RI-19-01	2024-12-09	0	35
2064	SS OCS	SAMUEL SMITH ORGANIC CHOCOLATE STOUT BUT. 0,355 L	5010149201171	349	szt	0.00	RJ-16-00	2024-12-09	0	349
2065	SS TAP	SAMUEL SMITH TADDY PORTER BUT. 0,355 L	5010149200808	43	szt	0.00	RI-19-01	2024-12-09	0	43
2066	SANT FOU	SANTE ADAIRIUS FOUR LEGS GOOD BUT. 0,75 L	5123456790148	12	szt	1.10	RI-14-01	2024-12-09	0	12
2067	SARA BAC_PROM	SARABANDA BACK TO THE ROOTS PUSZKA 0,5 L PROMOCJA (do 05.10.23)	\N	68	szt	0.00	RI-19-01	2024-12-09	0	68
2068	SARA LIQ_PROM	SARABANDA LIQUID FORMS PUSZKA 0,5 L PROMOCJA (do 05.10.23)	\N	83	szt	0.00	RI-19-01	2024-12-09	0	83
2069	SA_PLE_PUSZ_500	SARABANDA PLEASUREDOME PUSZKA 0,5 L	5904501978255	121	szt	0.54	RJ-10-00	2024-12-09	0	121
2070	SA_SCU_PUSZ_500	SARABANDA SCRUB THE BARREL PUSZKA 0,5 L	5904501978262	26	szt	0.54	RI-19-01	2024-12-09	0	26
2071	SA_SOU_PUSZ_500	SARABANDA SOURVENTURE PUSZKA 0,5 L	5904501978231	73	szt	0.54	RJ-01-01	2024-12-09	0	73
2072	SAT BLA 330	SATAN BLACK BUT. 0,33 L	5412107000794	48	szt	0.50	RJ-01-01	2024-12-09	0	48
2073	SAT GOL 330	SATAN GOLD BUT. 0,33 L	5412107000466	17	szt	0.50	RI-19-01	2024-12-09	0	17
2074	SAT RED 330	SATAN RED BUT. 0,33 L	5412107000398	11	szt	0.50	RI-16-01	2024-12-09	0	11
2075	Sch Hel	SCHLENKERLA HELLES LAGERBIER 11,0° BUT. 0,5 L	4037458000111	279	szt	0.77	RJ-17-00	2024-12-09	0	279
2076	SCH KUF RAU	SCHLENKERLA KUFEL CERAMICZNY RAUCHBIER 0,5 L	5123456791242	19	szt	0.00	RJ-01-01	2024-12-09	0	19
2077	SCHLEN KUF SZK 0,4	SCHLENKERLA KUFEL SZKLANY 0,4 L	5123456791244	1	szt	0.00	RA-21-02	2024-12-09	0	1
2078	Sch pok Eic 0,4	SCHLENKERLA POKAL EICHE 0,4 L	5123456791246	11	szt	0.00	RJ-01-01	2024-12-09	0	11
2079	SCH EIC VIN 2015	SCHLENKERLA RAUCHBIER EICHE VINTAGE 2015 19,9° BUT. 0,5 L	5123456790103	13	szt	0.77	RJ-01-01	2024-12-09	0	13
2080	SCH EIC VIN 2017	SCHLENKERLA RAUCHBIER EICHE VINTAGE 2017 19,9° BUT. 0,5 L	\N	24	szt	0.77	RJ-01-01	2024-12-09	0	24
2081	SCH EIC VIN 2018	SCHLENKERLA RAUCHBIER EICHE VINTAGE 2018 19,9° BUT. 0,5 L	\N	23	szt	0.77	RJ-02-01	2024-12-09	0	23
2082	SCH_FAS_VIN_2018	SCHLENKERLA RAUCHBIER FASTENBIER VINTAGE 2018 BUT. 0,5 L	4037458000166	7	szt	0.77	RA-21-04	2024-12-09	0	7
2671	ARTEZ MER	ARTEZAN MERA IPA BUT. 0,5 L	5904730574013	74	szt	0.77	RL-03-00	2024-12-09	0	74
2083	SCH_FAS_VIN_2019_BUT_500	SCHLENKERLA RAUCHBIER FASTENBIER VINTAGE 2019 BUT. 0,5 L	4037458000166	15	szt	0.77	RJ-02-01	2024-12-09	0	15
2084	SCH HAN	SCHLENKERLA RAUCHBIER HANSLA 3,4° BUT. 0,5 L	4037458000180	184	szt	0.77	RJ-16-00	2024-12-09	0	184
2085	SCH KRA	SCHLENKERLA RAUCHBIER KRAUSEN 11,5° BUT. 0,5 L	4037458000173	154	szt	0.77	RJ-17-00	2024-12-09	0	154
2086	SCH MAR	SCHLENKERLA RAUCHBIER MÄRZEN 13,5° BUT. 0,5 L	4037458000012	118	szt	0.77	RJ-11-00	2024-12-09	0	118
2087	SCH MAR PAR-FAS	SCHLENKERLA RAUCHBIER MÄRZEN 13,5° PARTY-FASS 5 L	4037458100200	6	szt	0.00	RA-21-04	2024-12-09	0	6
2088	SCH MAR K	SCHLENKERLA RAUCHBIER MÄRZEN KEG 30 L	5123456789425	1	szt	32.00	RA-21-04	2024-12-09	0	1
2089	Sch Mar Ung	SCHLENKERLA RAUCHBIER MÄRZEN UNGEFILTERET 13,5° BUT. 0,5 L	4037458021109	179	szt	0.77	RJ-18-00	2024-12-09	0	179
2090	SCH URB PAR-FAS 5_PROM	SCHLENKERLA RAUCHBIER URBOCK 17,5° PARTY-FASS 5 L PROMOCJA (do 31.08.23)	\N	1	szt	0.00	RA-21-04	2024-12-09	0	1
2091	SCH URB VIN 2017	SCHLENKERLA RAUCHBIER URBOCK VINTAGE 2017 17,5° BUT. 0,5 L	5123456790101	2	szt	0.77	RA-21-04	2024-12-09	0	2
2092	SCH_WEI_ROT_BUT_500	SCHLENKERLA RAUCHBIER WEICHSEL ROTBIER BUT. 0,5 L	4037458000197	64	szt	0.77	RJ-02-01	2024-12-09	0	64
2093	SCH WEI	SCHLENKERLA RAUCHBIER WEIZEN 13,2° BUT. 0,5 L	4037458000159	361	szt	0.77	RJ-18-00	2024-12-09	0	361
2094	SCH GRA PLA	SCHLENKERLA SPIEL - GRA PLANSZOWA	5123456791314	4	szt	0.00	RA-21-04	2024-12-09	0	4
2096	Sch szk 0,5	SCHLENKERLA SZKLANKA 0,5 L	5123456791248	16	szt	0.00	RJ-02-01	2024-12-09	0	16
2097	Sch szk Nos 0,5	SCHLENKERLA SZKLANKA NOSTALGY 0,5 L	5123456791328	39	szt	0.00	RJ-02-01	2024-12-09	0	39
2098	Sch szk Urb 0,5	SCHLENKERLA SZKLANKA URBOCK 0,5 L	5123456791329	26	szt	0.00	RJ-03-01	2024-12-09	0	26
2099	Sch szk Wei 0,5	SCHLENKERLA SZKLANKA WEIZEN 0,5 L	5123456789848	47	szt	0.00	RJ-03-01	2024-12-09	0	47
2100	SCH TAB REK	SCHLENKERLA TABLICA REKLAMOWA	5123456791340	16	szt	0.00	RJ-03-01	2024-12-09	0	16
2101	SCHN AUT	SCHNEEEULE AUTOBAHN COLLABO BRUSSELS BEER PROJECT BUT. 0,75 L	\N	5	szt	1.10	RA-21-04	2024-12-09	0	5
2102	SCHN BES FRE	SCHNEEEULE BESTE FREUNDE BUT. 0,75 L	\N	6	szt	1.10	RA-21-04	2024-12-09	0	6
2103	SCHN BLA BLU	SCHNEEEULE BLAUE BLUMEN BUT. 0,75 L	\N	4	szt	1.10	RA-21-04	2024-12-09	0	4
2104	SCHN IRM KEG 20	SCHNEEEULE IRMGARD KEG 20 L	\N	1	szt	21.50	RA-21-04	2024-12-09	0	1
2105	SCHN JOH TAG	SCHNEEEULE JOHNS TAGE BUT. 0,75 L	\N	5	szt	1.10	RA-21-04	2024-12-09	0	5
2106	SCHN MARI	SCHNEEEULE MARIANNA BUT. 0,75 L	\N	3	szt	1.10	RA-21-04	2024-12-09	0	3
2107	SCHN OTT	SCHNEEEULE OTTO BUT. 0,75 L	\N	6	szt	1.10	RA-21-04	2024-12-09	0	6
2108	SCHN WEI ROS	SCHNEEEULE WEISSE ROSE BUT. 0,75 L	\N	6	szt	1.10	RA-21-04	2024-12-09	0	6
2109	SCHN WIL BIL CON	SCHNEEEULE WILDER BILLY SALAT CONTROL W. FUERST WIACEK BUT. 0,75 L	\N	4	szt	1.10	RA-21-04	2024-12-09	0	4
2110	SCHN YAS KEG 20	SCHNEEEULE YASMIN KEG 20 L	\N	1	szt	21.50	RA-21-04	2024-12-09	0	1
2111	SCHN BLA REK	SCHNEIDER BAYRISCH HELL BLACHA REKLAMOWA	5123456791333	15	szt	0.00	RJ-03-01	2024-12-09	0	15
2112	SCH BLA REK	SCHNEIDER BLACHA REKLAMOWA	5123456791339	9	szt	0.00	RB-20-00	2024-12-09	0	9
2113	SCHN KUB PLA 0,5	SCHNEIDER KUBEK PLASTIKOWY 0,5 L	5123456791326	44	szt	0.00	RJ-03-01	2024-12-09	0	44
2114	Schn Lov	SCHNEIDER LOVE BEER 11,5° BUT. 0,5 L	4003669016692	374	szt	0.77	RJ-19-00	2024-12-09	0	374
2115	SCHN TACA	SCHNEIDER TACA	5123456791352	4	szt	0.00	RB-20-00	2024-12-09	0	4
2116	Schn TAP1	SCHNEIDER TAP01 HELLE WEISSE 11,3° BUT. 0,5 L	4003669016807	834	szt	0.77	RA-13-04	2024-12-09	0	834
2117	Schn TAP1 keg 20	SCHNEIDER TAP01 HELLE WEISSE 11,3° KEG 20 L	2100006E2AD9B	10	szt	21.50	RB-20-00	2024-12-09	0	10
2118	Schn TAP2	SCHNEIDER TAP02 KRISTALL 11,2° BUT. 0,5 L	4003669016500	269	szt	0.77	RK-01-00	2024-12-09	0	269
2119	Schn TAP3	SCHNEIDER TAP03 ALKOHOLFREE BUT. 0,5 L	4003669016906	995	szt	0.77	RA-14-02	2024-12-09	0	995
2120	Schn TAP4	SCHNEIDER TAP04 FESTWEISSE 13,4° BUT. 0,5 L	4003669016609	275	szt	0.77	RK-02-00	2024-12-09	0	275
2121	Schn TAP5 keg 20	SCHNEIDER TAP05 HOPFENWEISSE  18,5° KEG 20 L	2100006E34652	1	szt	21.50	RA-21-04	2024-12-09	0	1
2122	Schn TAP6	SCHNEIDER TAP06 AVENTINUS 18,5° BUT. 0,5 L	4003669018207	464	szt	0.77	RK-03-00	2024-12-09	0	464
2123	Schn TAP7	SCHNEIDER TAP07 ORIGINAL 12,8° BUT. 0,5 L	4003669016203	794	szt	0.77	RA-14-03	2024-12-09	0	794
2124	Schn TAP7 keg 20	SCHNEIDER TAP07 ORIGINAL KEG 20 L	2100006B234B9	13	szt	21.50	RJ-03-01	2024-12-09	0	13
2125	Schn TAP9	SCHNEIDER TAP09 AVENTINUS EISBOCK 25,5° BUT. 0,33 L	4003669018269	408	szt	0.50	RK-04-00	2024-12-09	0	408
2126	Schn TAPX Cuv	SCHNEIDER TAPX CUVEE BARRIQUE 21,5° BUT. 0,75 l	4003669022778	8	szt	0.00	RB-20-00	2024-12-09	0	8
2127	SCHNE SZK AVE 3	SCHNEIDER WEISSE AVENTINUS SZKLANKA 0,3 L	5123456791253	2	szt	0.00	RB-20-00	2024-12-09	0	2
2128	SCH WEI BLA REK	SCHNEIDER WEISSE BLACHA REKLAMOWA	5123456791345	5	szt	0.00	RB-20-00	2024-12-09	0	5
2129	SCHNE KUF CER 0,5	SCHNEIDER WEISSE KUFEL CERAMIKA 0,5 L	5123456791255	131	szt	0.00	RJ-15-00	2024-12-09	0	131
2130	SCHNE KUF CER POD 0,5	SCHNEIDER WEISSE KUFEL CERAMIKA WYSOKI 0,5 L	5123456791325	70	szt	0.00	RJ-04-01	2024-12-09	0	70
2131	SCHNE POK	SCHNEIDER WEISSE POKAL SOMMELIER 0,2 L	5123456791256	7	szt	0.00	RB-20-00	2024-12-09	0	7
2132	SCHNE SZKL ALK 0,5	SCHNEIDER WEISSE SZKLANKA  ALKOHOFREI 0,5 L	5123456791257	27	szt	0.00	RJ-04-01	2024-12-09	0	27
2133	SCHNE SZKL 0,3	SCHNEIDER WEISSE SZKLANKA 0,3 L	5123456791258	24	szt	0.00	RJ-04-01	2024-12-09	0	24
2134	SCHNE SZKL 0,5	SCHNEIDER WEISSE SZKLANKA 0,5 L	5123456791259	32	szt	0.00	RJ-04-01	2024-12-09	0	32
2135	SCHN SZKL	SCHNEIDER WEISSE SZKLANKA WEIZEN 0,5 L	5123456791260	306	szt	0.00	RK-05-00	2024-12-09	0	306
2136	SKRZ FOR	SKRZYNKA A-20 BROWAR FORTUNA	\N	485	szt	0.00	RK-06-00	2024-12-09	0	485
2137	SKRZ_CZ_BOZ	SKRZYNKA NA PIWO CZECHY ( B )	\N	24	szt	0.00	RJ-04-01	2024-12-09	0	24
2138	SKRZ_SVIJANY	SKRZYNKA SVIJANY A-20	\N	26	szt	0.00	RJ-04-01	2024-12-09	0	26
2139	SMYK ANT	SMYKAN CYDR ANTONI WISIENKA BUT. 0,5 L	5905669332187	13	szt	0.77	RJ-05-01	2024-12-09	0	13
2140	SMYK ANT K	SMYKAN CYDR ANTONI WISIENKA KEG 30 L	5123456791293	4	szt	32.00	RB-20-00	2024-12-09	0	4
2141	SMYK CHM	SMYKAN CYDR CHMIELONY SAD BUT. 0,75 L	5905669332156	57	szt	1.10	RJ-05-01	2024-12-09	0	57
2142	SMYK CHM K	SMYKAN CYDR CHMIELONY SAD KEG 30 L	5123456791297	4	szt	32.00	RB-20-00	2024-12-09	0	4
2143	SMYK GRO	SMYKAN CYDR GROCHÓWKA BUT. 0,75 L	5905669332033	11	szt	1.10	RJ-05-01	2024-12-09	0	11
2144	SMYK GRO K	SMYKAN CYDR GROCHÓWKA KEG 30 L	5123456791299	2	szt	32.00	RB-20-00	2024-12-09	0	2
2145	SMY_KRON_ANT_KEG_30	SMYKAN CYDR KRONSELKA/ANTONÓWKA KEG 30 L	\N	3	szt	32.00	RB-20-00	2024-12-09	0	3
2146	SMYK KWA	SMYKAN CYDR KWAŚNY ZDZICHU BUT. 0,5 L	5905669332170	27	szt	0.77	RJ-05-01	2024-12-09	0	27
2147	SMYK KWA K	SMYKAN CYDR KWAŚNY ZDZICHU KEG 30 L	5123456791300	5	szt	32.00	RB-20-00	2024-12-09	0	5
2148	SMYK LOD GRO	SMYKAN CYDR LODOWY GROCHÓWKA BUT. 0,375 L	5905669332163	31	szt	0.50	RJ-05-01	2024-12-09	0	31
2149	SMYK REN	SMYKAN CYDR RENETY 2022 BUT. 0,75 L	5905669332224	14	szt	1.10	RJ-05-01	2024-12-09	0	14
2150	SMY_REN_KEG_30	SMYKAN CYDR RENETY 2022 KEG 30 L	\N	6	szt	32.00	RB-20-00	2024-12-09	0	6
2151	SMYK SMY 2021	SMYKAN CYDR SMYKAN 2021 BUT. 0,75 L	5905669332002	27	szt	1.10	RJ-06-01	2024-12-09	0	27
2152	SMYK STA	SMYKAN CYDR STARY SAD BUT. 0,33 L	5905669332101	67	szt	0.50	RJ-06-01	2024-12-09	0	67
2153	SMYK STA K	SMYKAN CYDR STARY SAD KEG 30 L	5123456791305	2	szt	32.00	RB-20-00	2024-12-09	0	2
2154	SMY_WYS_ANT_BUT_750	SMYKAN CYDR WYSPOWA ANTONÓWKA BUT. 0,75 L	5905669332248	53	szt	1.10	RJ-06-01	2024-12-09	0	53
2155	SMY_SZK_330	SMYKAN SZKLANKA 0,33 L	\N	12	szt	0.00	RJ-06-01	2024-12-09	0	12
2156	PI FOR CAN	SOFIA ELECTRIC / PINTA FORTUNE TAMER PUSZKA 0,33 L	3800501676431	710	szt	0.35	RA-14-04	2024-12-09	0	710
2157	Sof Ele Cat k-keg 20_PROM	SOFIA ELECTRIC CATCH SOME RAYS K-KEG 20 L PROMOCJA (do 22.09.23)	\N	1	szt	0.00	RA-21-04	2024-12-09	0	1
2158	SOW_AMP_BUT_500	SOWIE AMPER BUT. 0,5 L	5907222560136	630	szt	0.77	RA-15-02	2024-12-09	0	630
2159	SOW_BEZALKO_BUT_500	SOWIE BEZALKOHOLOWE APA BUT. 0,5 L	5907222560143	213	szt	0.77	RK-01-00	2024-12-09	0	213
2160	SOW_GRA_BUT_500_PROM	SOWIE GRAPER BUT. 0,5 L PROMOCJA (do 04.10.23)	\N	87	szt	0.00	RJ-06-01	2024-12-09	0	87
2161	SOW_IND_BUT_500	SOWIE INDUKTOR BUT. 0,5 L	5907222560846	213	szt	0.77	RK-02-00	2024-12-09	0	213
2162	SOW_JAS_PEŁ_BUT_500	SOWIE JASNE PEŁNE BUT. 0,5 L	5907222560082	480	szt	0.77	RK-07-00	2024-12-09	0	480
2163	SOW_MARC_BUT_500	SOWIE MARCOWE BUT. 0,5 L	5907222560068	367	szt	0.77	RK-08-00	2024-12-09	0	367
2164	SOW_MIO_BUT_500	SOWIE MIODOWE BUT. 0,5 L	5907222560181	11	szt	0.77	RJ-06-01	2024-12-09	0	11
2165	SOW_PIL_BUT_500	SOWIE PILS BUT. 0,5 L	5907222560075	233	szt	0.77	RK-05-00	2024-12-09	0	233
2166	SOW_POR_22_BUT_500	SOWIE PORTER BAŁTYCKI 22 BUT. 0,5 L	5907222560334	41	szt	0.77	RJ-07-01	2024-12-09	0	41
2167	SOW_PSZEN_BUT_500	SOWIE PSZENICZNE BUT. 0,5 L	5907222560037	102	szt	0.77	RJ-13-00	2024-12-09	0	102
2168	SOW_PSZE_MANG_BUT_500	SOWIE PSZENICZNE MANGO I MARAKUJA BUT. 0,5 L	5907222560228	161	szt	0.77	RJ-19-00	2024-12-09	0	161
2169	OMB Spe Sal	SPECIATION SALTATION BUT. 0,375 L	5123456790109	52	szt	0.50	RJ-07-01	2024-12-09	0	52
2170	OMB Spe San	SPECIATION SANGRIA INCIPIENT PUSZKA 0,473 L	5123456790110	54	szt	0.53	RJ-07-01	2024-12-09	0	54
2171	STB 12 330	ST. BERNARDUS ABT 12 BUT. 0,33 L	54079021	700	szt	0.50	RA-15-03	2024-12-09	0	700
2172	STB 12 750	ST. BERNARDUS ABT 12 BUT. 0,75 L	5411911000310	59	szt	1.10	RJ-07-01	2024-12-09	0	59
2173	STB CHR 330	ST. BERNARDUS CHRISTMAS ALE BUT. 0,33 L	5411911001768	216	szt	0.50	RK-09-00	2024-12-09	0	216
2174	STB CHR ALE 750	ST. BERNARDUS CHRISTMAS ALE BUT. 0,75 L	5411911004004	7	szt	1.10	RB-20-00	2024-12-09	0	7
2175	STB CHR K	ST. BERNARDUS CHRISTMAS ALE KEG 20 L	5123456789438	10	szt	21.50	RB-20-01	2024-12-09	0	10
2176	STB DUŻ FLA	ST. BERNARDUS DUŻA FLAGA	5123456791384	1	szt	0.00	RB-20-00	2024-12-09	0	1
2177	STB EXT 330	ST. BERNARDUS EXTRA 4 BUT. 0,33 L	5411911001782	153	szt	0.50	RK-08-00	2024-12-09	0	153
2178	STB EXT KEG 20	ST. BERNARDUS EXTRA 4 KEG 20 L	\N	2	szt	21.50	RB-20-01	2024-12-09	0	2
2179	STB PAT 330	ST. BERNARDUS PATER 6 BUT. 0,33 L	54079007	78	szt	0.50	RJ-07-01	2024-12-09	0	78
2180	STB PODKŁ	ST. BERNARDUS PODKŁADKI	\N	499	szt	0.00	RK-10-00	2024-12-09	0	499
2181	STB PRI 330	ST. BERNARDUS PRIOR 8 BUT. 0,33 L	54079014	159	szt	0.50	RK-09-00	2024-12-09	0	159
2182	STB PRI 750	ST. BERNARDUS PRIOR 8 BUT. 0,75 L	5411911001362	97	szt	1.10	RJ-08-01	2024-12-09	0	97
2183	STB PRI K 20	ST. BERNARDUS PRIOR 8 KEG 20 L	5123456789439	1	szt	21.50	RB-20-00	2024-12-09	0	1
2184	STB TAB REK	ST. BERNARDUS TABLICA REKLAMOWA	5123456791382	2	szt	0.00	RB-20-01	2024-12-09	0	2
2185	STB TRI 330	ST. BERNARDUS TRIPEL BUT. 0,33 L	54079038	138	szt	0.50	RK-09-00	2024-12-09	0	138
2186	STB TRI 750	ST. BERNARDUS TRIPEL BUT. 0,75 L	5411911001492	59	szt	1.10	RJ-08-01	2024-12-09	0	59
2187	605	ST. BERNARDUS WATAU KIELICH  0,25 L	5123456791175	21	szt	0.00	RJ-08-01	2024-12-09	0	21
2188	KAT00215	ST. BERNARDUS WATAU KIELICH  0,33 L	5123456791174	17	szt	0.00	RJ-08-01	2024-12-09	0	17
2189	KAT06911	ST. BERNARDUS WATAU KIELICH 0,5 L	5123456791173	5	szt	0.00	RB-20-01	2024-12-09	0	5
2190	STB WAT TRI 330	ST. BERNARDUS WATOU TRIPEL BUT. 0,33 L	54079045	40	szt	0.50	RJ-08-01	2024-12-09	0	40
2191	STB WIT 330	ST. BERNARDUS WIT BUT. 0,33 L	54079052	372	szt	0.50	RK-11-00	2024-12-09	0	372
2192	STB WIT 750	ST. BERNARDUS WIT BUT. 0,75 L	5411911001515	75	szt	1.10	RJ-09-01	2024-12-09	0	75
2193	STB WIT P	ST. BERNARDUS WIT PUSZKA 0,33 L	5411911003359	216	szt	0.35	RK-12-00	2024-12-09	0	216
2194	STB ZES 4X330 + SZKŁ	ST. BERNARDUS ZESTAW (4X 0,33 L + SZKŁO)	5411911003540	64	szt	0.00	RJ-08-01	2024-12-09	0	64
2195	STF BLO 330	ST. FEUILLIEN BLONDE BUT. 0,33 L	5412138103310	138	szt	0.50	RK-11-00	2024-12-09	0	138
2196	STF BLO 750	ST. FEUILLIEN BLONDE BUT. 0,75 L	5412138107554	52	szt	1.10	RJ-09-01	2024-12-09	0	52
2197	STF BRU 330	ST. FEUILLIEN BRUNE BUT. 0,33 L	5412138203317	82	szt	0.50	RJ-09-01	2024-12-09	0	82
2198	STF NOE 330	ST. FEUILLIEN CUVÉE DE NOEL BUT. 0,33 L	5412138303314	69	szt	0.50	RJ-09-01	2024-12-09	0	69
2199	STF NOE 750	ST. FEUILLIEN CUVÉE DE NOEL BUT. 0,75 L	5412138307510	36	szt	1.10	RJ-10-01	2024-12-09	0	36
2200	STF FIV 330	ST. FEUILLIEN FIVE BUT. 0,33 L	5412138763316	31	szt	0.50	RJ-10-01	2024-12-09	0	31
2201	STF GRA CRU 330	ST. FEUILLIEN GRAND CRU BUT. 0,33 L	5412138653310	36	szt	0.50	RJ-10-01	2024-12-09	0	36
2202	STF GRA CRU 750	ST. FEUILLIEN GRAND CRU BUT. 0,75 L	5412138617510	12	szt	1.10	RJ-07-01	2024-12-09	0	12
2203	STF GRA CRU 750_PROM	ST. FEUILLIEN GRAND CRU BUT. 0,75 L PROMOCJA (do 04.10.23)	\N	13	szt	0.00	RJ-09-01	2024-12-09	0	13
2204	STF GRE FLE POK	ST. FEUILLIEN GREEN FLESH POKAL 0,33 L	5123456791066	1	szt	0.00	RB-20-01	2024-12-09	0	1
2205	STF KIEL 330	ST. FEUILLIEN KIELICH 0,33 L	5123456791176	51	szt	0.00	RJ-10-01	2024-12-09	0	51
2206	STF QUA 330	ST. FEUILLIEN QUADRUPLE BUT. 0,33 L	5412138402604	61	szt	0.50	RJ-10-01	2024-12-09	0	61
2207	STF SAI 330	ST. FEUILLIEN SAISON BUT. 0,33 L	5412138333311	56	szt	0.50	RJ-10-01	2024-12-09	0	56
2208	STF SAI 750	ST. FEUILLIEN SAISON BUT. 0,75 L	5412138317519	58	szt	1.10	RJ-11-01	2024-12-09	0	58
2209	STF SAI SZKL	ST. FEUILLIEN SAISON SZKLANKA 0,33 L	5123456791029	26	szt	0.00	RJ-11-01	2024-12-09	0	26
2210	STF TRI 330 ml	ST. FEUILLIEN TRIPEL BUT. 0,33 L	5412138403311	85	szt	0.50	RJ-11-01	2024-12-09	0	85
2211	STF TRI 750	ST. FEUILLIEN TRIPLE BUT. 0,75 L	5412138507552	25	szt	1.10	RJ-11-01	2024-12-09	0	25
2212	STG DUB 330	ST. GUMMARUS DUBBEL BUT. 0,33 L	5413699011168	32	szt	0.50	RJ-11-01	2024-12-09	0	32
2213	STG DUB K 20	ST. GUMMARUS DUBBEL KEG 20 L	\N	2	szt	21.50	RB-20-01	2024-12-09	0	2
2214	STG TRI 330	ST. GUMMARUS TRIPEL BUT. 0,33 L	5413699011106	27	szt	0.50	RJ-11-01	2024-12-09	0	27
2215	STH TRI BLO 330	ST. HUBERTUS TRIPLE BLONDE BUT. 0,33 L	5413982600000	15	szt	0.50	RJ-12-01	2024-12-09	0	15
2216	ST LOU PRE FRAM	ST. LOUIS PREMIUM FRAMBOISE BUT. 0,25 L	5411081000264	49	szt	0.35	RJ-12-01	2024-12-09	0	49
2217	ST LOU GUE	ST. LOUIS PREMIUM GUEUZE BUT. 0,25 L	5411081000233	55	szt	0.35	RJ-12-01	2024-12-09	0	55
2218	ST LOU PRE KRI	ST. LOUIS PREMIUM KRIEK BUT. 0,25 L	5411081002220	41	szt	0.35	RJ-12-01	2024-12-09	0	41
2219	ST LOU PRE PEC	ST. LOUIS PREMIUM PECHE BUT. 0,25 L	5411081000363	50	szt	0.35	RJ-12-01	2024-12-09	0	50
2220	STM BLO 7 330	ST. MARTIN BLONDE 7% BUT. 0,33 L	5411065403319	30	szt	0.50	RJ-12-01	2024-12-09	0	30
2221	STM BRU 8 330	ST. MARTIN BRUNE 8% BUT. 0,33 L	5411065403326	28	szt	0.50	RJ-13-01	2024-12-09	0	28
2222	STM TRI 9 330	ST. MARTIN TRIPLE 9% BUT. 0,33 L	5411065210856	21	szt	0.50	RJ-13-01	2024-12-09	0	21
2223	STA KOL	STARA SZKOŁA KOLENDRA BUT. 0,5 L	5906874548059	80	szt	0.77	RJ-13-01	2024-12-09	0	80
2224	STA STO	STARA SZKOŁA STARA STODOŁA BUT. 0,5 L	5906874548172	30	szt	0.77	RJ-13-01	2024-12-09	0	30
2225	STA WER	STARA SZKOŁA WERBENA BUT. 0,5 L	5906874548219	56	szt	0.77	RJ-13-01	2024-12-09	0	56
2226	STAR BES ANA	STAROPOLSKIE BESTBIR ANANAS BUT. 0,5 L	5903021500007	71	szt	0.77	RJ-13-01	2024-12-09	0	71
2227	STAR BES CYT	STAROPOLSKIE BESTBIR CYTRYNA BUT. 0,5 L	5903111989996	51	szt	0.77	RJ-14-01	2024-12-09	0	51
2228	STAR_BES_CZEK_POM_BUT_500	STAROPOLSKIE BESTBIR CZEKOLADA Z POMARAŃCZĄ BUT. 0,5 L	5903021500236	118	szt	0.77	RK-04-00	2024-12-09	0	118
2229	STAR BES DZIK	STAROPOLSKIE BESTBIR DZIKA RÓŻA BUT. 0,5 L	5905669086110	56	szt	0.77	RJ-14-01	2024-12-09	0	56
2230	STAR BES GRU MEL	STAROPOLSKIE BESTBIR GRUSZKA I MELISA BUT. 0,5 L	5905669086141	297	szt	0.77	RK-12-00	2024-12-09	0	297
2231	STAR BES IMB MIO	STAROPOLSKIE BESTBIR IMBIR Z MIODEM BUT. 0,5 L	5905669086134	104	szt	0.77	RJ-17-00	2024-12-09	0	104
2232	STAR_BES_KIWI_BUT_500	STAROPOLSKIE BESTBIR KIWI BUT. 0,5 L	5903021505606	244	szt	0.77	RK-13-00	2024-12-09	0	244
2233	STAR BES KOK	STAROPOLSKIE BESTBIR KOKOS BUT. 0,5 L	5905669086073	106	szt	0.77	RK-13-00	2024-12-09	0	106
2234	STAR BES LET ŚLI	STAROPOLSKIE BESTBIR LETNIA ŚLIWKA BUT. 0,5 L	5903111989972	103	szt	0.77	RK-13-00	2024-12-09	0	103
2235	STAR BES MAL PIG	STAROPOLSKIE BESTBIR MALINA I PIGWA BUT. 0,5 L	5903111989989	197	szt	0.77	RK-14-00	2024-12-09	0	197
2236	STAR BES PAC BRZ	STAROPOLSKIE BESTBIR PACIFIC BRZOSKWINIA BUT. 0,5 L	5905669086677	237	szt	0.77	RK-14-00	2024-12-09	0	237
2237	STAR BES PAC MAN ANA	STAROPOLSKIE BESTBIR PACIFIC MANGO I ANANAS BUT. 0,5 L	5905669086653	44	szt	0.77	RJ-14-01	2024-12-09	0	44
2238	STAR BES PIE JAB	STAROPOLSKIE BESTBIR PIECZONE JABŁKO BUT. 0,5 L	5905669086127	31	szt	0.77	RJ-14-01	2024-12-09	0	31
2239	STAR_BES_PIER_SLI_BUT_500	STAROPOLSKIE BESTBIR PIERNIK ZE ŚLIWKĄ BUT. 0,5 L	5903021500243	30	szt	0.77	RJ-14-01	2024-12-09	0	30
2240	STAR BES TRU	STAROPOLSKIE BESTBIR TRUSKAWKA BUT. 0,5 L	5903021501097	73	szt	0.77	RJ-14-01	2024-12-09	0	73
2241	STAR BES WIŚ	STAROPOLSKIE BESTBIR WIŚNIA BUT. 0,5 L	5903021503244	90	szt	0.77	RJ-15-01	2024-12-09	0	90
2242	STAR BES ŻUR	STAROPOLSKIE BESTBIR ŻURAWINA BUT. 0,5 L	5903021503268	56	szt	0.77	RJ-15-01	2024-12-09	0	56
2243	STAR CHM	STAROPOLSKIE CHMIELNE BUT. 0,5 L	5903111989873	86	szt	0.77	RJ-15-01	2024-12-09	0	86
2244	STAR_COFF_FRI_BUT_500	STAROPOLSKIE COFFEE FRIENDS  BUT. 0,5 L	5903021506085	536	szt	0.77	RA-15-02	2024-12-09	0	536
2245	STAR DWO	STAROPOLSKIE DWORSKIE BUT. 0,5 L	5903111989811	92	szt	0.77	RJ-16-01	2024-12-09	0	92
2246	STAR_GRAP_ALE_BUT_500	STAROPOLSKIE GRAPE ALE BUT. 0,5 L	5903021506276	277	szt	0.77	RK-15-00	2024-12-09	0	277
2247	STAR KUL BEZ	STAROPOLSKIE KULTOWE BEZ GLUTENU BUT. 0,5 L	5905669086943	55	szt	0.77	RJ-15-01	2024-12-09	0	55
2248	STAR KUL BEZ CYT	STAROPOLSKIE KULTOWE BEZ GLUTENU CYTRYNOWE BUT. 0,5 L	5903021504395	100	szt	0.77	RJ-16-01	2024-12-09	0	100
2249	STAR KUL BEZ MAL	STAROPOLSKIE KULTOWE BEZ GLUTENU MALINOWE BUT. 0,5 L	5903021500618	35	szt	0.77	RJ-16-01	2024-12-09	0	35
2250	STAR KUL BEZ MIO	STAROPOLSKIE KULTOWE BEZ GLUTENU MIODOWE BUT. 0,5 L	5903021500625	10	szt	0.77	RB-20-01	2024-12-09	0	10
2251	STAR_KUL_PRO_BEZ_BUT_500	STAROPOLSKIE KULTOWE BEZ GLUTENU PROZDROWOTNE 0,0 % BUT. 0,5 L	5903021505521	58	szt	0.77	RJ-16-01	2024-12-09	0	58
2252	STAR KUL BEZ PSZ	STAROPOLSKIE KULTOWE BEZ GLUTENU PSZENICZNE BUT. 0,5 L	5903021504401	12	szt	0.77	RJ-15-01	2024-12-09	0	12
2253	STAR KUL JAS	STAROPOLSKIE KULTOWE JASNE BUT. 0,5 L	5905669086233	57	szt	0.77	RJ-17-01	2024-12-09	0	57
2254	SAR KUL PIL	STAROPOLSKIE KULTOWE PILS BUT. 0,5 L	5905669086455	58	szt	0.77	RJ-17-01	2024-12-09	0	58
2255	STAR KUL PRO	STAROPOLSKIE KULTOWE PROZDROWOTNE 0,0% BUT. 0,5 L	5903021505118	135	szt	0.77	RK-15-00	2024-12-09	0	135
2256	STAR KUL PRO_PROM	STAROPOLSKIE KULTOWE PROZDROWOTNE 0,0% BUT. 0,5 L PROMOCJA (do 21.10.23)	\N	58	szt	0.00	RJ-17-01	2024-12-09	0	58
2257	STAR MIO	STAROPOLSKIE MIODNE BUT. 0,5 L	5903111989835	13	szt	0.77	RJ-16-01	2024-12-09	0	13
2258	STAR_MY_WAY_DOG_CHE_WHE_BUT_500	STAROPOLSKIE MY WAY DOGBERRY-CHERRY WHEAT BUT. 0,5 L	5903021505781	52	szt	0.77	RJ-17-01	2024-12-09	0	52
2259	STAR_MY_WAY_DOP_WEI_BUT_500	STAROPOLSKIE MY WAY DOPPEL WIZENBOCK BUT. 0,5 L	5903021505774	32	szt	0.77	RJ-17-01	2024-12-09	0	32
2260	STAR_MY_WAY_ DWCIPA_BUT_500	STAROPOLSKIE MY WAY DOUBLE WEST COAST IPA BUT. 0,5 L	5903021505767	32	szt	0.77	RJ-17-01	2024-12-09	0	32
2261	STAR NIE ANA	STAROPOLSKIE NIEMDŁE ANANASOWE BUT. 0,5 L	5903021503350	85	szt	0.77	RJ-18-01	2024-12-09	0	85
2262	STAR NIE KLA	STAROPOLSKIE NIEMDŁE KLASYCZNE BUT. 0,5 L	5903021503336	95	szt	0.77	RJ-18-01	2024-12-09	0	95
2263	STAR NIE PSZ	STAROPOLSKIE NIEMDŁE PSZENICZNE BUT. 0,5 L	5903021503343	105	szt	0.77	RK-14-00	2024-12-09	0	105
2264	STAR POR 180	STAROPOLSKIE PORTER 180 BUT. 0,5 L	5905669086691	143	szt	0.77	RK-16-00	2024-12-09	0	143
2265	STAR POR BAŁ	STAROPOLSKIE PORTER BAŁTYCKI BUT. 0,5 L	5905669086707	34	szt	0.77	RJ-18-01	2024-12-09	0	34
2376	BRU JAR	THE BRUERY JARDINIER BUT. 0,75 L	705105538457	30	szt	1.10	RK-11-01	2024-12-09	0	30
2266	STAR_POR_BAŁ_ŚWID_BUT_500	STAROPOLSKIE PORTER BAŁTYCKI ZE ŚWIDOŚLIWĄ BUT. 0,5 L	5903021506269	149	szt	0.77	RK-16-00	2024-12-09	0	149
2267	STAR POR CHE	STAROPOLSKIE PORTER CHERRY BUT. 0,5 L	5903021503275	69	szt	0.77	RJ-18-01	2024-12-09	0	69
2268	STAR POR IRI COF	STAROPOLSKIE PORTER IRISH COFFEE BUT. 0,5 L	5903021503299	49	szt	0.77	RJ-19-01	2024-12-09	0	49
2269	STAR POR RUM	STAROPOLSKIE PORTER RUM BUT. 0,5 L	5903021503282	34	szt	0.77	RJ-19-01	2024-12-09	0	34
2270	STAR PRL JAS	STAROPOLSKIE PRL PIWO JASNE 0,5 L	5905669086257	54	szt	0.00	RJ-19-01	2024-12-09	0	54
2271	STAR PRL PEŁ	STAROPOLSKIE PRL PIWO PEŁNE 0,5 L	5905669086240	74	szt	0.00	RJ-19-01	2024-12-09	0	74
2272	STAR PSZ	STAROPOLSKIE PSZENNE BUT. 0,5 L	5905669086806	25	szt	0.77	RJ-19-01	2024-12-09	0	25
2273	STAR_AFR_SOU_BUT_500	STAROPOLSKIE THE ART OF HOPPING AFRICAN SOUL SINGLE HOP IPA BUT. 0,5 L	5903021504913	53	szt	0.77	RJ-19-01	2024-12-09	0	53
2274	STAR_EL_DOR_BUT_500	STAROPOLSKIE THE ART OF HOPPING EL DORADO SIGLE HOP HAZY IPA BUT. 0,5 L	5903021505491	83	szt	0.77	RK-01-01	2024-12-09	0	83
2275	STAR_HARM_BUT_500	STAROPOLSKIE THE ART OF HOPPING HARMONIE SINGLE HOP PILS BUT. 0,5 L	5903021505514	91	szt	0.77	RK-01-01	2024-12-09	0	91
2276	STAR_STYR_GOL_BUT_500	STAROPOLSKIE THE ART OF HOPPING STYRIAN GOLDING SINGLE HOP IPA BUT. 0,5 L	5903021504951	70	szt	0.77	RK-01-01	2024-12-09	0	70
2277	STAR_TRISK_BUT_500	STAROPOLSKIE THE ART OF HOPPING TRISKEL SINGLE HOP IPA BUT. 0,5 L	5903021505132	60	szt	0.77	RK-02-01	2024-12-09	0	60
2278	STAR_WAK_ORG_BUT_500	STAROPOLSKIE THE ART OF HOPPING WAKATU ORGANIC SINGLE HOP AMBER ALE BUT. 0,5 L	5903021505712	166	szt	0.77	RK-16-00	2024-12-09	0	166
2279	STAR_WARR_BUT_500	STAROPOLSKIE THE ART OF HOPPING WARRIOR SINGLE HOP WEST COAST IPA BUT. 0,5 L	5903021505743	71	szt	0.77	RK-02-01	2024-12-09	0	71
2280	STAR UL POT GRY	STAROPOLSKIE ZŁOTY POTRÓJNIE GRYCZANE BUT. 0,5 L	5905669086264	35	szt	0.77	RK-01-01	2024-12-09	0	35
2281	STAR UL 3 MIO	STAROPOLSKIE ZŁOTY UL 3 MIODY BUT. 0,5 L	5905669086288	50	szt	0.77	RK-02-01	2024-12-09	0	50
2282	KAT05480	STELLA ARTOIS NEON REKLAMOWY	5123456791056	10	szt	0.00	RB-20-01	2024-12-09	0	10
2283	KAT05068	STELLA ARTOIS POKAL  0,5 L	5123456791064	16	szt	0.00	RJ-18-01	2024-12-09	0	16
2284	KAT05699	STELLA ARTOIS SZKLANKA 0,25 L	5123456791026	4	szt	0.00	RB-20-01	2024-12-09	0	4
2285	KAT03013	STONE / DOGFISH HEAD SAISON DU BUFF BUT. 0,5 L	636251870255	69	szt	0.77	RK-02-01	2024-12-09	0	69
2286	KAT03012	STONE CRIME BUT. 0,5 L	636251870415	13	szt	0.77	RK-01-01	2024-12-09	0	13
2287	KAT02157	STONE ENCORE VERTICAL EPIC 020202 2016 BUT. 0,65 L	636251908323	1	szt	0.00	RB-20-01	2024-12-09	0	1
2288	KAT01562	STONE ENJOY AFTER 7.4.16 BUT. 0,75 L	636251772108	20	szt	1.10	RK-02-01	2024-12-09	0	20
2289	KAT03197	STONE OLD GUARDIAN RED WINE BA 2011 BUT. 0,5 L	636251802089	1	szt	0.77	RB-20-01	2024-12-09	0	1
2290	KAT01826	STONE SNIFTER STONE 0,33 L	5123456791058	311	szt	0.00	RK-17-00	2024-12-09	0	311
2291	KAT01808	STONE SPROCKETBIER BUT. 0,65 L	636251899003	20	szt	0.00	RK-02-01	2024-12-09	0	20
2292	KAT03016	STONE STYGIAN DESCENT 2016 BUT. 0,5 L	636251740718	25	szt	0.77	RK-03-01	2024-12-09	0	25
2293	KAT01827	STONE SZKLANKA 0,33 L	5123456791025	92	szt	0.00	RK-03-01	2024-12-09	0	92
2294	STN TAP HAN	STONE TAP HANDLE	5123456791011	13	szt	0.00	RK-03-01	2024-12-09	0	13
2295	KAT05459	STONE T-SHIRT CZARNY (XXL)	5123456791054	1	szt	0.00	RB-20-01	2024-12-09	0	1
2296	KAT02664	STONE XOCOVEZA EXTRA ANEJO 2015 BUT. 0,5 L	636251740619	38	szt	0.77	RK-03-01	2024-12-09	0	38
2297	KAT06217	STRAFFE HENDRIK TRIPLE BUT. 0,33 L	5425017240457	59	szt	0.50	RK-03-01	2024-12-09	0	59
2298	STRU CLA TIT RES 330	STRUISE / HOPY PEOPLE CLASH OF THE TITANS RESERVA BUT. 0,33 L	5425017181330	18	szt	0.50	RK-03-01	2024-12-09	0	18
2299	STRU XEN WIN 330	STRUISE / PIPEWORKS XENOPHON'S WINE BUT. 0,33 L	5425017200062	7	szt	0.50	RB-20-01	2024-12-09	0	7
2300	STRU BD II MOCH	STRUISE BLACK DAMNATION II - MOCHA BOMB BUT. 0,33 L	5425017666028	2	szt	0.50	RB-20-01	2024-12-09	0	2
2301	STRU BD IX BEG	STRUISE BLACK DAMNATION IX - BEGGARS' ART BUT. 0,33 L	5425017666097	11	szt	0.50	RK-04-01	2024-12-09	0	11
2302	STRU BD VIII SHI	STRUISE BLACK DAMNATION VIII - S.H.I.T. BUT. 0,33 L	5425017666080	18	szt	0.50	RK-04-01	2024-12-09	0	18
2303	STRU BD X DOU	STRUISE BLACK DAMNATION X - DOUBLE WOOD BUT. 0,33 L	5425017666103	14	szt	0.50	RK-04-01	2024-12-09	0	14
2304	STRU PAN 2020	STRUISE PANNEPOT 2020 BUT. 0,33 L	5425017810049	1	szt	0.50	RB-20-01	2024-12-09	0	1
2305	STU 8TH MIX FER	STU MOSTÓW 8TH ANNIVERSARY MIXED FERMENTATION GRAFF  BUT. 0,375 L	5907614682514	8	szt	0.50	RB-20-01	2024-12-09	0	8
2306	STU_ALL_IN_PUSZ_440	STU MOSTÓW ALL INCLUSIVE PUSZKA 0,44 L	5907614683184	12	szt	0.48	RK-04-01	2024-12-09	0	12
2307	STU AME IPA	STU MOSTÓW AMERICAN IPA BUT. 0,5 L	5905279213210	100	szt	0.77	RK-04-01	2024-12-09	0	100
2308	STU_AME_UNC_PUSZ_440_PROM	STU MOSTÓW AMERICAN UNCLE PUSZKA 0,44 L PROMOCJA (do 10.10.23)	\N	1	szt	0.00	RB-20-01	2024-12-09	0	1
2309	STU_ART65_PUSZ_440	STU MOSTÓW ART+65 SOUR IPA PUSZKA 0,44 L	5907614682965	70	szt	0.48	RK-04-01	2024-12-09	0	70
2310	STU_ART66_PUSZ_440	STU MOSTÓW ART+66 DOUBLE NEIPA PUSZKA 0,44 L	5907614682941	41	szt	0.48	RK-05-01	2024-12-09	0	41
2311	STU_ART67_PUSZ_440	STU MOSTÓW ART+67 DDH PALE ALE PUSZKA 0,44 L	5907614682972	61	szt	0.48	RK-05-01	2024-12-09	0	61
2312	STU_ART68_BUT_330	STU MOSTÓW ART+68 PASTRY IMPERIAL STOUT PECAN NUTS-COCONUT BUT. 0,33 L	5907614682989	40	szt	0.50	RK-05-01	2024-12-09	0	40
2313	STU_ART69_PUSZ_440	STU MOSTÓW ART+69 MODERN SILLY SOUR MANGO-LIME-ORANGE PUSZKA 0,44 L	5907614683078	22	szt	0.48	RK-05-01	2024-12-09	0	22
2314	STU_ART70_PUSZ_440	STU MOSTÓW ART+70 PUSZKA 0,44 L	5907614683221	78	szt	0.48	RK-05-01	2024-12-09	0	78
2315	STU_BON_VOY_PUSZ_440	STU MOSTÓW BON VOYAGE PUSZKA 0,44 L	5907614683191	40	szt	0.48	RK-05-01	2024-12-09	0	40
2316	STU CHE	STU MOSTÓW CHERRY ME PUSZKA 0,33 L	5907614682453	81	szt	0.35	RK-06-01	2024-12-09	0	81
2317	STU CHO STO NIT	STU MOSTÓW CHOCOLATE STOUT NITRO BUT. 0,5 L	5907614680275	125	szt	0.77	RK-15-00	2024-12-09	0	125
2318	STU DRU	STU MOSTÓW DRUNKEN SAILOR PUSZKA 0,33 L	5907614682491	42	szt	0.35	RK-06-01	2024-12-09	0	42
2319	STU IMP PAS STO COC	STU MOSTÓW IMPERIAL PASTRY STOUT COCOA NIBS, COOKIES AND WHITE CHOCOLATE PUSZKA 0,44 L	5907614681722	226	szt	0.48	RK-17-00	2024-12-09	0	226
2320	STU IMP STO VAN BOU	STU MOSTÓW IMPERIAL STOUT VANILLA  BOURBON B.A. NITRO BUT. 0,33 L	5907614680879	14	szt	0.50	RK-06-01	2024-12-09	0	14
2321	STU_KIL_BUT_330	STU MOSTÓW KILWATER IMPERIAL BALTIC PORTER BBA (PLUMS, FIGS & DATES) BUT. 0,33 L	5907614682729	14	szt	0.50	RK-06-01	2024-12-09	0	14
2322	STU_LAST_PUSZ_440	STU MOSTÓW LAST MINUTE PUSZKA 0,44 L	5907614683177	53	szt	0.48	RK-06-01	2024-12-09	0	53
2323	STU LAS	STU MOSTÓW LAST RESORT PUSZKA 0,33 L	5907614682507	103	szt	0.35	RK-18-00	2024-12-09	0	103
2324	STU_NON_BER_BUT_500	STU MOSTÓW NON ALCOHOLIC BERLINER WEISSE PECH & APRICOT BUT. 0,5 L	5907614682798	63	szt	0.77	RK-06-01	2024-12-09	0	63
2325	STU PAL	STU MOSTÓW PALE ALE BUT. 0,5 L	5905279213234	44	szt	0.77	RK-07-01	2024-12-09	0	44
2326	STU_PUM_SPI_BUT_500	STU MOSTÓW PUMPKIN SPICE SOUR BUT. 0,5 L	5907614683306	5	szt	0.77	RB-20-01	2024-12-09	0	5
2327	STU ROD VIL	STU MOSTÓW RODZINA - VILD BUT. 0,375 L	7390305201299	5	szt	0.50	RB-20-01	2024-12-09	0	5
2328	STU STR BER (ART8)	STU MOSTÓW STRAWBERRY BERLINER WEISSE BUT. 0,5 L	5905279213388	341	szt	0.77	RK-18-00	2024-12-09	0	341
2329	STU TRO GOS	STU MOSTÓW TROPICAL GOSE BUT. 0,5 L	5907614681982	38	szt	0.77	RK-07-01	2024-12-09	0	38
2330	STU_WAK_UP_CAL_BUT_330	STU MOSTÓW WAKE-UP CALL IMPERIAL BALTIC PORTER BBA (COCONUT & PALO SANTO) BUT. 0,33 L	5907614682712	15	szt	0.50	RK-07-01	2024-12-09	0	15
2331	STU WILD#11	STU MOSTÓW WILD #11 BIERE DE GARDE BUT. 0,375 L	5907614680282	40	szt	0.50	RK-07-01	2024-12-09	0	40
2332	STU WILD#12	STU MOSTÓW WILD #12 BIERE DE SOIF PEACHES AND CHERRIES BUT. 0,375 L	5907614680350	23	szt	0.50	RK-07-01	2024-12-09	0	23
2333	STU_WIL_#17_BUT_375	STU MOSTÓW WILD #17 MIXED FERMENTATION SAISON WITH ZAPIAIN BUT. 0,375 L	5907614682835	38	szt	0.50	RK-07-01	2024-12-09	0	38
2334	STU_WIL_#18_BUT_375	STU MOSTÓW WILD #18 MIXED FERMENTATION PIQUETTE SAISON BUT. 0,375 L	5907614682842	35	szt	0.50	RK-08-01	2024-12-09	0	35
2335	STU_WIL_#19_BUT_375	STU MOSTÓW WILD #19 DOUBLE PEACH MIX FERMENTATION SAISON BUT. 0,375 L	5907614682958	39	szt	0.50	RK-08-01	2024-12-09	0	39
2336	STU_WIL_#20_BUT_375	STU MOSTÓW WILD #20 CHERRY MIX FERMENTATION ALE BUT. 0,375 L	5907614682934	46	szt	0.50	RK-08-01	2024-12-09	0	46
2337	STU WRC BEZ	STU MOSTÓW WRCLW BEZALKOHOLOWY IPA BUT. 0,5 L	5907614681890	33	szt	0.77	RK-08-01	2024-12-09	0	33
2338	STU_WRC_GRO_BUT_500	STU MOSTÓW WRCLW GRODZISKI BUT. 0,5 L	5907614683016	89	szt	0.77	RK-08-01	2024-12-09	0	89
2339	STU WRC LEK	STU MOSTÓW WRCLW LEKKI BUT. 0,5 L	5907614682118	60	szt	0.77	RK-09-01	2024-12-09	0	60
2340	STU WRC PIL	STU MOSTÓW WRCLW PILS BUT. 0,5 L	5907614680473	65	szt	0.77	RK-09-01	2024-12-09	0	65
2341	STU WRC PSZ	STU MOSTÓW WRCLW PSZENICZNY BUT. 0,5 L	5907614680497	25	szt	0.77	RK-08-01	2024-12-09	0	25
2342	STU WRC SCH	STU MOSTÓW WRCLW SCHOPS BUT. 0,5 L	5907614680480	164	szt	0.77	RK-19-00	2024-12-09	0	164
2343	STU_MAD_PUSZ_330	STU MOSTÓW X MOERSLEUTEL MADNESS PUSZKA 0,33 L	5907614682750	8	szt	0.35	RB-20-02	2024-12-09	0	8
2344	SVI_KNI_BUT_500	SVIJANY KNIZE 13% BUTELKA 0,5 L	8594030010051	75	szt	0.00	RK-09-01	2024-12-09	0	75
2345	SVI_KUF_SZKL_500	SVIJANY KUFEL SZKLANY 0,5 L	\N	22	szt	0.00	RK-09-01	2024-12-09	0	22
2346	SVI_MATA_BAR	SVIJANY MATA BAROWA	\N	2	szt	0.00	RB-20-01	2024-12-09	0	2
2347	SVI_RYT_BUT_500	SVIJANY RYTIR 12% BUTELKA 0,5 L	8594030010075	10	szt	0.00	RB-20-02	2024-12-09	0	10
2348	SVI_SZKL_500	SVIJANY SZKLANKA 0,5 L	\N	72	szt	0.00	RK-09-01	2024-12-09	0	72
2349	SVI_TACA	SVIJANY TACA	\N	2	szt	0.00	RB-20-02	2024-12-09	0	2
2350	SVI_WAFLO	SVIJANY WAFLOWNICA	\N	14	szt	0.00	RK-10-01	2024-12-09	0	14
2351	SZR_BEL_BLO_BUT_500	SZRENIAWA BELGIAN BLOND BUT. 0,5 L	5907632926270	210	szt	0.77	RK-19-00	2024-12-09	0	210
2352	SZ BIE	SZRENIAWA BI?RE DE GARDE BUT. 0,33 L	5903857178296	1	szt	0.50	RB-20-02	2024-12-09	0	1
2353	SZR_LET_PSZ_BUT_500	SZRENIAWA LETNIE PSZENICZNE BUT. 0,5 L	5903857178340	1920	szt	0.77	AT-24	2024-12-09	0	1920
2354	SZR_MIO_BUT_500	SZRENIAWA MIODOWE BUT. 0,5 L	5903857178302	2125	szt	0.77	AT-25	2024-12-09	0	2125
2355	SZ PEA	SZRENIAWA PEATED BROWN ALE BUT. 0,33 L	5903857178395	27	szt	0.50	RK-10-01	2024-12-09	0	27
2356	SZR_PERL_BUT_500	SZRENIAWA PERLAGE BUT. 0,5 L	5903857178425	2241	szt	0.77	AT-30	2024-12-09	0	2241
2357	TB ALO	TANKBUSTERS ALONE IN SPACE PUSZKA 0,5 L	5904365781053	1	szt	0.54	RB-20-02	2024-12-09	0	1
2358	TB_ATT_PUSZ_500	TANKBUSTERS ATTACK OF FRUITINESS PUSZKA 0,5 L	5905316580114	6	szt	0.54	RB-20-02	2024-12-09	0	6
2359	TB_BRO_ARM_PUSZ_500	TANKBUSTERS BROTHERS IN ARMS PUSZKA 0,5 L	5904365781497	104	szt	0.54	RK-19-00	2024-12-09	0	104
2360	TB_HEL_HEL_PUSZ_500	TANKBUSTERS HELLO HELLES PUSZKA 0,5 L	5904365781398	35	szt	0.54	RK-10-01	2024-12-09	0	35
2361	TB_THI_MOO_PUSZ_500	TANKBUSTERS THIRD BIRTHDAY AND HOMIES X MOONLARK PUSZKA 0,5 L	5904365781473	85	szt	0.54	RK-10-01	2024-12-09	0	85
2362	TAR_AVA_BUT_500	TARNOBRZEG AWATAR BUT. 0,5 L	5907713309725	153	szt	0.77	RL-01-00	2024-12-09	0	153
2363	TAR_GANG_BUT_500	TARNOBRZEG GANGSTAR BUT. 0,5 L	5903661867768	205	szt	0.77	RL-01-00	2024-12-09	0	205
2364	TAR_JS_PE_BUT_500	TARNOBRZEG JASNE PEŁNE BUT. 0,5 L	5903661867713	215	szt	0.77	RL-02-00	2024-12-09	0	215
2365	TAR_SAN_BUT_500	TARNOBRZEG SANTAROSA BUT. 0,5 L	5907713309732	90	szt	0.77	RK-10-01	2024-12-09	0	90
2366	TAR_SUP_VOL3_BUT_500	TARNOBRZEG SUPERSTAR VOL.3 BUT. 0,5 L	5904533544121	150	szt	0.77	RL-01-00	2024-12-09	0	150
2367	TAR_SZKL_NON_500	TARNOBRZEG SZKLANKA NONIC 0,5 L	5123456791455	12	szt	0.00	RK-10-01	2024-12-09	0	12
2368	TAR_URO_POPARZ_BUT_500	TARNOBRZEG URODZINOWE FEAT POPARZENI KAWĄ TRZY BUT. 0,5 L	5904533544077	105	szt	0.77	RL-02-00	2024-12-09	0	105
2369	TAR_WHE_BUT_500	TARNOBRZEG WHEATART BUT. 0,5 L	5904533544046	290	szt	0.77	RL-03-00	2024-12-09	0	290
2370	KAT06241	THE BREWING PROJEKT THINGS OF THAT PUSZKA 0, 473 L	810059390799	3	szt	0.00	RB-20-02	2024-12-09	0	3
2371	BRU GUA	THE BRUERY / FUNKY BUDDHA !GUAVA LIBRE! BUT. 0,75 L	653341008428	19	szt	1.10	RK-11-01	2024-12-09	0	19
2372	BRU 10L	THE BRUERY 10 LORDS-A-LEAPING BUT. 0,75 L	718122104338	13	szt	1.10	RK-11-01	2024-12-09	0	13
2373	BRU 11 PIP	THE BRUERY 11 PIPERS PIPING BUT. 0,75 L	718122104338	2	szt	1.10	RB-20-02	2024-12-09	0	2
2374	BRU 6 GEE	THE BRUERY 6 GEESE A LAYING 0,75 L	718122104338	11	szt	0.00	RK-11-01	2024-12-09	0	11
2375	BRU GYP	THE BRUERY GYPSY TART BUT. 0,75 L	705105537955	6	szt	1.10	RB-20-02	2024-12-09	0	6
2377	BRU MIN	THE BRUERY SHARE THIS: MINT CHIP BUT. 0,75 L	19962362057	26	szt	1.10	RK-11-01	2024-12-09	0	26
2378	TIL OUD GEW	TILQUIN OUDE GEWURZT A L'ANCIENNE BUT. 0,75 L	5425029530812	1	szt	1.10	RB-20-02	2024-12-09	0	1
2379	TIL MUR 750	TILQUIN OUDE MURE A L’ANCIENNE BUT. 0,75 L	5425029530171	2	szt	1.10	RB-20-02	2024-12-09	0	2
2380	TIL NOI 750	TILQUIN OUDE PINOT NOIR A L'ANCIENNE BUT. 0,75 L	5425029530232	1	szt	1.10	RB-20-02	2024-12-09	0	1
2381	TIMM FAR 375	TIMMERMANS FARO BUT. 0,375 L	5411516001491	21	szt	0.50	RK-11-01	2024-12-09	0	21
2382	TIMM FRA 250	TIMMERMANS FRAMBOISE BUT. 0,25 L	5411516010707	12	szt	0.35	RK-12-01	2024-12-09	0	12
2383	TIMM KRI 250	TIMMERMANS KRIEK BUT. 0,25 L	5411516010110	25	szt	0.35	RK-12-01	2024-12-09	0	25
2384	TIMM OUD GUE 375	TIMMERMANS OUDE GUEUZE BUT. 0,375 L	5411516002306	51	szt	0.50	RK-12-01	2024-12-09	0	51
2385	TIMM OUD KRI 375	TIMMERMANS OUDE KRIEK BUT. 0,375 L	5411516002269	39	szt	0.50	RK-12-01	2024-12-09	0	39
2386	TIMM PECH 250	TIMMERMANS PECHE BUT. 0,25 L	5411516010905	5	szt	0.35	RB-20-02	2024-12-09	0	5
2387	TOOL BLA REK	TOOL BLACHA REKLAMOWA	5123456791380	1	szt	0.00	RB-20-02	2024-12-09	0	1
2388	KAT06759	TOOL GLÖGGLICH RUM, RED WINE & PORT WINE BUT. 0,375 L	5711474008519	11	szt	0.50	RK-12-01	2024-12-09	0	11
2389	KAT00399	TOOL JULE MALT IMPERIAL MILK STOUT BUT. 0,375 L	5711474000698	324	szt	0.50	RL-04-00	2024-12-09	0	324
2390	KAT02011	TOOL KAFFE OG ROG BUT. 0,33 L	5711474002180	85	szt	0.50	RK-12-01	2024-12-09	0	85
2391	KAT06746	TOOL OMNIPRESENT BUT. 0,375 L	5711474009363	8	szt	0.50	RB-20-02	2024-12-09	0	8
2392	KAT06749	TOOL PAID IN DIAMONDS - CABERNET BUT. 0,375 L	5711474010048	2	szt	0.50	RB-20-02	2024-12-09	0	2
2393	KAT06748	TOOL POLYRADIANT BUT. 0,75 L	5711474008915	3	szt	1.10	RB-20-02	2024-12-09	0	3
2394	TOOL TAP HAN	TOOL TAP HANDLE	5123456791006	2	szt	0.00	RB-20-02	2024-12-09	0	2
2395	KAT06747	TOOL THROUGH THE EYES OF MORTALS BUT. 0,75 L	5711474009936	3	szt	1.10	RB-20-02	2024-12-09	0	3
2396	KAT06752	TOOL UTOPIAN TONES BUT. 0,75 L	5711474009349	5	szt	1.10	RB-20-02	2024-12-09	0	5
2397	TRO MAG 330	TROUBADOUR MAGMA BUT. 0,33 L	5425006700139	4	szt	0.50	RB-20-02	2024-12-09	0	4
2398	TRY_EXP_BUT_500	TRYBUNAŁ EXPORT BUT. 0,5 L	5905689304263	265	szt	0.77	RL-05-00	2024-12-09	0	265
2399	TRY_PIL_BUT_500	TRYBUNAŁ PILS BUT. 0,5 L	5905689308124	369	szt	0.77	RL-06-00	2024-12-09	0	369
2400	TRY_POR_BAŁ_BUT_500	TRYBUNAŁ PORTER BAŁTYCKI BUT. 0,5 L	5905689309978	234	szt	0.77	RL-03-00	2024-12-09	0	234
2401	TRY_ZER_BUT_500	TRYBUNAŁ ZERO BUT. 0,5 L	5905689311377	300	szt	0.77	RL-07-00	2024-12-09	0	300
2402	TR AME	TRZECH KUMPLI AMERICAN BEAUTY BUT. 0,5 L	5905669479349	248	szt	0.77	RL-05-00	2024-12-09	0	248
2403	TR AME K	TRZECH KUMPLI AMERICAN BEAUTY KEG 30 L	5123456789457	5	szt	32.00	RB-20-03	2024-12-09	0	5
2404	TR AME P	TRZECH KUMPLI AMERICAN BEAUTY PUSZKA 0,5 L	5904252699478	116	szt	0.54	RL-02-00	2024-12-09	0	116
2405	TR BLA	TRZECH KUMPLI BLACKCYL BUT. 0,5 L	5905669479240	45	szt	0.77	RK-13-01	2024-12-09	0	45
2406	TR BLA K	TRZECH KUMPLI BLACKCYL KEG 30 L	5123456789460	1	szt	32.00	RB-20-02	2024-12-09	0	1
2407	TR BLA P	TRZECH KUMPLI BLACKCYL PUSZKA 0,5 L	5904252699423	100	szt	0.54	RK-13-01	2024-12-09	0	100
2408	TR BOC	TRZECH KUMPLI BOCK BUT. 0,5 L	5905669479509	45	szt	0.77	RK-13-01	2024-12-09	0	45
2409	TR BOC K	TRZECH KUMPLI BOCK KEG 30 L	5123456789462	3	szt	32.00	RB-20-02	2024-12-09	0	3
2410	TR BRE	TRZECH KUMPLI BREW NOTE BUT. 0,5 L	5905669479363	166	szt	0.77	RL-04-00	2024-12-09	0	166
2411	TR BRE P	TRZECH KUMPLI BREW NOTE PUSZKA 0,5 L	5904252699706	101	szt	0.54	RL-02-00	2024-12-09	0	101
2412	TR CAL	TRZECH KUMPLI CALIFIA BUT. 0,5 L	5905669479264	94	szt	0.77	RK-13-01	2024-12-09	0	94
2413	TR CAL K	TRZECH KUMPLI CALIFIA KEG 30 L	5123456789465	5	szt	32.00	RB-20-03	2024-12-09	0	5
2414	TR CAL P	TRZECH KUMPLI CALIFIA PUSZKA 0,5 L	5904252699058	40	szt	0.54	RK-14-01	2024-12-09	0	40
2415	TR_CIT_SES_OUR_NEW_KEG_30	TRZECH KUMPLI CITRUS SESSION JUICY IPA - OUR NEW IPA KEG 30 L	\N	2	szt	32.00	RB-20-03	2024-12-09	0	2
2416	TR_CIT_SES_OUR_NEW_PUSZ_500	TRZECH KUMPLI CITRUS SESSION JUICY IPA - OUR NEW IPA PUSZKA 0,5 L	5904252699782	89	szt	0.54	RK-14-01	2024-12-09	0	89
2417	TR_FUL_MOS_KEG_30	TRZECH KUMPLI FULL MOSAIC KEG 30 L	\N	1	szt	32.00	RB-20-03	2024-12-09	0	1
2418	TR GOE	TRZECH KUMPLI GOEDEMORGEN BUT. 0,5 L	5905669479318	80	szt	0.77	RK-14-01	2024-12-09	0	80
2419	TR GOE K	TRZECH KUMPLI GOEDEMORGEN KEG 30 L	5123456789476	1	szt	32.00	RB-20-03	2024-12-09	0	1
2420	TR GOS MAN	TRZECH KUMPLI GOSE MANGO MARAKUJA BUT. 0,5 L	5905669479752	288	szt	0.77	RL-08-00	2024-12-09	0	288
2421	TR GOS MAN K	TRZECH KUMPLI GOSE MANGO MARAKUJA KEG 30 L	5123456789477	4	szt	32.00	RB-20-03	2024-12-09	0	4
2422	TR_HAZ_RYE_OUR_NEW_PUSZ_500	TRZECH KUMPLI HAZY RYE MICRO IPA - OUR NEW IPA PUSZKA 0,5 L	5904252699836	196	szt	0.54	RL-07-00	2024-12-09	0	196
2423	TR_HOP_WEI_BUT_500	TRZECH KUMPLI HOPPY WEIZEN BUT. 0,5 L	5904252699546	302	szt	0.77	RL-09-00	2024-12-09	0	302
2424	TR_HO_WEI_KEG_30	TRZECH KUMPLI HOPPY WEIZEN KEG 30 L	\N	3	szt	32.00	RB-20-03	2024-12-09	0	3
2425	TR IDI	TRZECH KUMPLI IDIOTA BUT. 0,33 L	5905669479387	60	szt	0.50	RK-14-01	2024-12-09	0	60
2426	TR IDI P	TRZECH KUMPLI IDIOTA PUSZKA 0,33 L	5904252699508	57	szt	0.35	RK-15-01	2024-12-09	0	57
2427	TR IGR	TRZECH KUMPLI IGROK BUT. 0,33 L	5905669479684	44	szt	0.50	RK-15-01	2024-12-09	0	44
2428	TR IMP BER	TRZECH KUMPLI IMPERIAL BERLINER WEISSE  BUT. 0,5 L	5905669479769	154	szt	0.77	RL-06-00	2024-12-09	0	154
2429	TR IMP BER K	TRZECH KUMPLI IMPERIAL BERLINER WEISSE 30 L	5123456789481	3	szt	0.00	RB-20-03	2024-12-09	0	3
2430	TR_IMP_GRAF_GRODZ_PUSZ_500	TRZECH KUMPLI IMPERIAL GRAFF GRODZISKIE PUSZKA 0,5 L	5904252699843	149	szt	0.54	RL-08-00	2024-12-09	0	149
2431	TR KIO	TRZECH KUMPLI KIOKIO BUT. 0,5 L	5905669479745	53	szt	0.77	RK-15-01	2024-12-09	0	53
2432	TR_LAG_WIE_BUT_500	TRZECH KUMPLI LAGER WIEDEŃSKI BUT. 0,5 L	5904252699683	125	szt	0.77	RL-09-00	2024-12-09	0	125
2433	TR_LAG_WIE_KEG_30	TRZECH KUMPLI LAGER WIEDEŃSKI KEG 30 L	\N	1	szt	32.00	RB-20-03	2024-12-09	0	1
2434	TR MIS	TRZECH KUMPLI MISTY BUT. 0,5 L	5905669479189	104	szt	0.77	RL-09-00	2024-12-09	0	104
2435	TR MIS K	TRZECH KUMPLI MISTY KEG 30 L	5123456789486	7	szt	32.00	RB-20-03	2024-12-09	0	7
2436	TR MIS P	TRZECH KUMPLI MISTY PUSZKA 0,5 L	5904252699065	181	szt	0.54	RL-10-00	2024-12-09	0	181
2437	TR MVP	TRZECH KUMPLI MVPILS BUT. 0,5 L	5905669479448	158	szt	0.77	RL-10-00	2024-12-09	0	158
2438	TR MVP K	TRZECH KUMPLI MVPILS KEG 30 L	5123456789487	4	szt	32.00	RB-20-03	2024-12-09	0	4
2439	TR_NES_BUT_500	TRZECH KUMPLI NESTA BUT. 0,5 L	5904252699027	94	szt	0.77	RK-15-01	2024-12-09	0	94
2440	TR_NES_PUSZ_500	TRZECH KUMPLI NESTA PUSZKA 0,5 L	5904252699652	65	szt	0.54	RK-16-01	2024-12-09	0	65
2441	TR_OAT_BUT_330	TRZECH KUMPLI OATY BUT. 0,33 L	5904252699751	97	szt	0.50	RK-16-01	2024-12-09	0	97
2442	TR OAT	TRZECH KUMPLI OATY BUT. 0,5 L	5905669479646	221	szt	0.77	RL-11-00	2024-12-09	0	221
2443	TR OAT P	TRZECH KUMPLI OATY PUSZKA 0,5 L	5904252699188	60	szt	0.54	RK-16-01	2024-12-09	0	60
2444	TR_PAN_BUT_330	TRZECH KUMPLI PAN IPANI BUT. 0,33 L	5904252699737	93	szt	0.50	RK-17-01	2024-12-09	0	93
2445	TR PAN	TRZECH KUMPLI PAN IPANI BUT. 0,5 L	5905669479196	872	szt	0.77	RA-15-04	2024-12-09	0	872
2446	TR PAN DOU	TRZECH KUMPLI PAN IPANI DOUBLE BUT. 0,5 L	5905669479257	367	szt	0.77	RL-12-00	2024-12-09	0	367
2447	TR_PAN_DOU_KEG_20	TRZECH KUMPLI PAN IPANI DOUBLE KEG 20 L	\N	1	szt	21.50	RB-20-03	2024-12-09	0	1
2448	TR PAN DOU P	TRZECH KUMPLI PAN IPANI DOUBLE PUSZKA 0,5 L	5904252699256	166	szt	0.54	RL-10-00	2024-12-09	0	166
2449	TR PAN K	TRZECH KUMPLI PAN IPANI KEG 30 L	5123456789495	13	szt	32.00	RK-13-01	2024-12-09	0	13
2450	TR PAN P	TRZECH KUMPLI PAN IPANI PUSZKA 0,5 L	5904252699041	60	szt	0.54	RK-16-01	2024-12-09	0	60
2451	TR_PIE_BUT_500_PROM	TRZECH KUMPLI PIECE OF CAKE BUT. 0,5 L PROMOCJA (do 14.10.23)	\N	131	szt	0.00	RL-11-00	2024-12-09	0	131
2452	TR_PIE_PUSZ_500_PROM	TRZECH KUMPLI PIECE OF CAKE PUSZKA 0,5 L PROMOCJA (do 14.10.23)	\N	77	szt	0.00	RK-17-01	2024-12-09	0	77
2453	TR_PIL_BUT_330	TRZECH KUMPLI PILS BUT. 0,33 L	5904252699744	60	szt	0.50	RK-17-01	2024-12-09	0	60
2454	TR PIL	TRZECH KUMPLI PILS BUT. 0,5 L	5905669479233	226	szt	0.77	RL-13-00	2024-12-09	0	226
2455	TR PIL K	TRZECH KUMPLI PILS KEG 30 L	5123456789499	4	szt	32.00	RB-20-03	2024-12-09	0	4
2456	TR PIL P	TRZECH KUMPLI PILS PUSZKA 0,5 L	5904252699072	111	szt	0.54	RL-11-00	2024-12-09	0	111
2457	TE_PIN_2023_KEG_20	TRZECH KUMPLI PINK BOOTS 2023 KEG 20 L	\N	1	szt	21.50	RB-20-03	2024-12-09	0	1
2458	TR_PIN_2023_PUSZ_500	TRZECH KUMPLI PINK BOOTS 2023 PUSZKA 0,5 L	5904252699713	75	szt	0.54	RK-18-01	2024-12-09	0	75
2459	TR POR	TRZECH KUMPLI PORTER BAŁTYCKI BUT. 0,5 L	5905669479516	135	szt	0.77	RL-12-00	2024-12-09	0	135
2460	TR POR K	TRZECH KUMPLI PORTER BAŁTYCKI KEG 30 L	5123456789501	1	szt	32.00	RB-20-03	2024-12-09	0	1
2461	TR QUA	TRZECH KUMPLI QUADRUPEL BUT. 0,33 L	5905669479677	43	szt	0.50	RK-15-01	2024-12-09	0	43
2462	TR RAG	TRZECH KUMPLI RAGNAR BUT. 0,33 L	5905669479356	37	szt	0.50	RK-17-01	2024-12-09	0	37
2463	TR RAG P	TRZECH KUMPLI RAGNAR PUSZKA 0,33 L	5904252699577	36	szt	0.35	RK-18-01	2024-12-09	0	36
2464	TR RAU	TRZECH KUMPLI RAUCHDOPPELBOCK BUT. 0,5 L	5905669479738	52	szt	0.77	RK-18-01	2024-12-09	0	52
2465	TR RAU K	TRZECH KUMPLI RAUCHDOPPELBOCK KEG 20 L	5123456789504	1	szt	21.50	RB-20-03	2024-12-09	0	1
2466	TR RUS K	TRZECH KUMPLI RUSTY KEG 30 L	5123456789506	1	szt	32.00	RB-20-03	2024-12-09	0	1
2467	TR SZK NON	TRZECH KUMPLI SZKLANKA NONIC 0,5 L	5123456791265	2	szt	0.00	RB-20-03	2024-12-09	0	2
2468	TR SZK SHA	TRZECH KUMPLI SZKLANKA SHAKER 0,5 L	5123456791266	9	szt	0.00	RB-20-03	2024-12-09	0	9
2469	TR TAS	TRZECH KUMPLI TASSIE BUT. 0,5 L	5905669479974	127	szt	0.77	RL-13-00	2024-12-09	0	127
2470	TR TAS K	TRZECH KUMPLI TASSIE KEG 30 L	\N	3	szt	32.00	RB-20-03	2024-12-09	0	3
2471	TR TAU	TRZECH KUMPLI TAURA BUT. 0,5 L	5905669479493	30	szt	0.77	RK-14-01	2024-12-09	0	30
2472	TR TAU P	TRZECH KUMPLI TAURA PUSZKA 0,5 L	5904252699607	70	szt	0.54	RK-18-01	2024-12-09	0	70
1	3 FON FRA OOG 17 750	3 FONTEINEN FRAMBOOS OOGST 2017 BUT. 0,75 L	5425007818116	2	szt	1.10	AT-26-00	2024-12-09	0	2
2	3 FON FRA OOG 375	3 FONTEINEN FRAMBOOS OOGST 2019 BUT. 0,375 L	5425007818338	16	szt	0.50	RA-01-01	2024-12-09	0	16
3	3 FON FRA OOG 19 750	3 FONTEINEN FRAMBOOS OOGST 2019 BUT. 0,75 L	5425007818116	14	szt	1.10	RA-01-01	2024-12-09	0	14
4	3 FON FRA LAM OOG 375	3 FONTEINEN FROMBOZENLAMBIK OOGST 2019/20 BUT. 0,375 L	5425007818611	23	szt	0.50	RA-01-01	2024-12-09	0	23
5	3 FON HOM 19/20 375	3 FONTEINEN HOMMAGE 2019/20 BUT. 0,375 L	5425007818192	26	szt	0.50	RA-01-01	2024-12-09	0	26
6	3 FON HOM BIO 18/19 750	3 FONTEINEN HOMMAGE BIO 2018/19 BUT. 0,75 L	5425007818154	12	szt	1.10	RA-01-01	2024-12-09	0	12
356	CHIM RED 750	CHIMAY RED BUT. 0,75 L	5410908000043	90	szt	1.10	RB-15-01	2024-12-09	0	90
2473	TR TRI	TRZECH KUMPLI TRIPADELIC BUT. 0,5 L	5905669479127	57	szt	0.77	RK-18-01	2024-12-09	0	57
2474	TR TRI K	TRZECH KUMPLI TRIPADELIC KEG 30 L	5123456789514	2	szt	32.00	RB-20-03	2024-12-09	0	2
2475	TR_UNP_CIT_APA_BUT_500	TRZECH KUMPLI UNPLUGGED CITRUS APA 0,0% BUT. 0,5 L	5904252699799	821	szt	0.77	RA-16-02	2024-12-09	0	821
2476	TR_UNP_CIT_APA_PUSZ_500	TRZECH KUMPLI UNPLUGGED CITRUS APA 0,0% PUSZKA 0,5 L	5904252699805	170	szt	0.54	RL-13-00	2024-12-09	0	170
2477	TR_UNP_IPA_BUT_330	TRZECH KUMPLI UNPLUGGED IPA BUT. 0,33 L	5904252699768	105	szt	0.50	RL-14-00	2024-12-09	0	105
2478	TR UNP IPA	TRZECH KUMPLI UNPLUGGED IPA BUT. 0,5 L	5905669479806	233	szt	0.77	RL-14-00	2024-12-09	0	233
2479	TR UNP IPA P	TRZECH KUMPLI UNPLUGGED IPA PUSZKA 0,5 L	5904252699522	170	szt	0.54	RL-14-00	2024-12-09	0	170
2480	TR UNP NIT STO	TRZECH KUMPLI UNPLUGGED NITRO OATMEAL STOUT BUT. 0,5 L	5905669479844	110	szt	0.77	RL-15-00	2024-12-09	0	110
2481	TR GRO	TRZECH KUMPLI W STYLU GRODZISKIE BUT. 0,5 L	5905669479400	284	szt	0.77	RL-15-00	2024-12-09	0	284
2482	TR GRO K	TRZECH KUMPLI W STYLU GRODZISKIE KEG 20 L	5123456789517	1	szt	21.50	RB-20-03	2024-12-09	0	1
2483	TR GRO P	TRZECH KUMPLI W STYLU GRODZISKIE PUSZKA 0,5 L	5904252699195	175	szt	0.54	RL-16-00	2024-12-09	0	175
2484	TR GRO CYT	TRZECH KUMPLI W STYLU GRODZISKIE Z GRILOWANYMI CYTRYNAMI PUSZKA 0,5 L	5904252699218	217	szt	0.54	RL-16-00	2024-12-09	0	217
2485	TR WEI	TRZECH KUMPLI WEIZEN BUT. 0,5 L	5905669479394	417	szt	0.77	RL-17-00	2024-12-09	0	417
2486	TR WEI K	TRZECH KUMPLI WEIZEN KEG 30 L	5123456789520	2	szt	32.00	RB-20-03	2024-12-09	0	2
2487	TR_WED_POR_BUT_500	TRZECH KUMPLI WĘDZONY PORTER BAŁTYCKI BUT. 0,5 L	5904252699638	169	szt	0.77	RL-18-00	2024-12-09	0	169
2488	TR_WED_POR_KEG_20	TRZECH KUMPLI WĘDZONY PORTER BAŁTYCKI KEG 20 L	5123456789924	1	szt	21.50	RB-20-03	2024-12-09	0	1
2489	TR WHE	TRZECH KUMPLI WHEELER PUSZKA 0,5 L	5904252699294	115	szt	0.54	RL-15-00	2024-12-09	0	115
2490	TR WON K	TRZECH KUMPLI WONDER HAZE KEG 30 L	5123456789640	1	szt	32.00	RB-20-03	2024-12-09	0	1
2491	TR WON	TRZECH KUMPLI WONDER HAZE PUSZKA 0,5 L	5904252699539	526	szt	0.54	RA-16-03	2024-12-09	0	526
2492	OMB UA Roc	UNTITLE ART. ROCKY ROAD STOUT PUSZKA 0,473 L	854141006731	18	szt	0.53	RK-16-01	2024-12-09	0	18
2493	OMB UA Swe	UNTITLE ART. SWEET SOUR TANGERINE PUSZKA 0,473 L	850011756935	35	szt	0.53	RK-19-01	2024-12-09	0	35
2610	ZAM WAR	ZA MIASTEM WARTO STRZELIĆ BUT. 0,5 L	5906874605455	267	szt	0.77	AT-06-00	2024-12-09	0	267
2494	KAT07253_PROM	UNTITLED ART. DBL CHOC BROWNIE PUSZKA 0,354 L PROMOCJA (do 03.10.23)	\N	2	szt	0.00	RB-20-04	2024-12-09	0	2
2495	VAL NOE 330	VAL-DIEU BIERE DE NOËL BUT. 0,33 L	5413977000044	69	szt	0.50	RK-19-01	2024-12-09	0	69
2496	VAL NOE 750	VAL-DIEU BIERE DE NOËL BUT. 0,75 L	5413977000259	38	szt	1.10	RK-19-01	2024-12-09	0	38
2497	VAL BLO 330	VAL-DIEU BLONDE BUT. 0,33 L	5413977000013	63	szt	0.50	RK-19-01	2024-12-09	0	63
2498	VAL BLO 750	VAL-DIEU BLONDE BUT. 0,75 L	5413977000266	16	szt	1.10	RK-17-01	2024-12-09	0	16
2499	VAL BRU 330	VAL-DIEU BRUNE BUT. 0,33 L	5413977000020	71	szt	0.50	RK-19-01	2024-12-09	0	71
2500	VAL BRU 750	VAL-DIEU BRUNE BUT. 0,75 L	5413977000068	45	szt	1.10	RL-01-01	2024-12-09	0	45
2501	VAL CUV 330	VAL-DIEU CUVEE 800 BUT. 0,33 L	5413977000945	72	szt	0.50	RL-01-01	2024-12-09	0	72
2502	VAL CUV 750	VAL-DIEU CUVEE 800 BUT. 0,75 L	5413977000952	20	szt	1.10	RK-19-01	2024-12-09	0	20
2503	VAL GRA 330	VAL-DIEU GRAND BUT. 0,33 L	5413977000723	42	szt	0.50	RL-01-01	2024-12-09	0	42
2504	VAL GRA CRU 750	VAL-DIEU GRAND CRU BUT. 0,75 L	5413977000273	54	szt	1.10	RL-01-01	2024-12-09	0	54
2505	VAL TRI 330	VAL-DIEU TRIPLE BUT. 0,33 L	5413977000037	136	szt	0.50	RL-16-00	2024-12-09	0	136
2506	VAL TRI 750	VAL-DIEU TRIPLE BUT. 0,75 L	5413977000051	63	szt	1.10	RL-01-01	2024-12-09	0	63
2507	OMB VC Fai	VAULT CITY - FAITH IN SOUR PUSZKA 0,44 L	5056412005305	40	szt	0.48	RL-02-01	2024-12-09	0	40
2508	VED EO IPA 330	VEDETT EXTRA ORDINARY IPA BUT. 0,33 L	5411681401775	265	szt	0.50	RL-18-00	2024-12-09	0	265
2509	352	VEDETT KIELISZEK  0,33 L	5123456791161	3	szt	0.00	RB-20-04	2024-12-09	0	3
2510	VED WHI 330	VEDETT WHITE BUT. 0,33 L	5411681400310	24	szt	0.50	RL-01-01	2024-12-09	0	24
2511	VER DUCH CHE 330	VERHAEGHE CHERRY DUCHESSE DE BOURGOGNE BUT. 0,33 L	5411364151911	79	szt	0.50	RL-02-01	2024-12-09	0	79
2512	VER DUCH CHO CHE 330	VERHAEGHE CHOCOLATE CHERRY DUCHESSE DE BOURGOGNE BUT. 0,33 L	5411364151928	98	szt	0.50	RL-02-01	2024-12-09	0	98
2674	TR CAL	TRZECH KUMPLI CALIFIA BUT. 0,5 L	5905669479264	100	szt	0.77	RK-15-01	2026-02-20	0	100
2672	TR MIS	TRZECH KUMPLI MISTY BUT. 0,5 L	5905669479189	300	szt	0.77	RL-14-00	2026-02-20	0	300
2679	TR PIL	TRZECH KUMPLI PILS BUT. 0,5 L	5905669479233	150	szt	0.77	RL-19-00	2026-02-20	0	150
1697	PI_HS_SIM_CAN_500	PINTA Hop Selection - Simcoe can 0,5 l	5904165104786	0	szt	0.00	RA-20-02	2024-12-09	0	-1
1467	MON_KIEL_100	MONVIN KIELISZEK 0,1 L	5123456791449	17	szt	0.00	RG-15-01	2024-12-09	0	4
2690	ALE ELF	ALEBROWAR EL FRUTO BUT. 0,5 L	5907222039106	60	szt	0.77	RL-11-01	2024-12-09	0	60
2682	TR PIL	TRZECH KUMPLI PILS BUT. 0,5 L	5905669479233	100	szt	0.77	RK-19-00	2026-02-20	0	100
2691	TR MIS	TRZECH KUMPLI MISTY BUT. 0,5 L	5905669479189	160	szt	0.77	RK-19-03	2026-02-20	0	160
1867	PIW_CZA_EAR_BUT_500	PIWOTEKA CZAISZ BAZĘ: EARL GREY BUT. 0,5 L	5905669428095	60	szt	0.77	RH-19-01	2024-12-09	7	53
652	FF CLO P	FUNKY FLUID CLOUDY PUSZKA 0,5 L	5907772092316	1042	szt	0.54	RA-03-04	2024-12-09	10	1032
2686	TR CAL	TRZECH KUMPLI CALIFIA BUT. 0,5 L	5905669479264	100	szt	0.77	RK-19-00	2026-02-20	0	100
2687	TR CAL	TRZECH KUMPLI CALIFIA BUT. 0,5 L	5905669479264	50	szt	0.77	RG-19-02	2026-02-20	0	50
2688	TR MIS	TRZECH KUMPLI MISTY BUT. 0,5 L	5905669479189	100	szt	0.77	RG-17-01	2026-02-20	0	100
2689	TR PIL	TRZECH KUMPLI PILS BUT. 0,5 L	5905669479233	160	szt	0.77	RK-18-00	2026-02-20	0	160
309	420	BUSH KIELICH 0,33 L	5123456791190	3	szt	0.00	AT-26-03	2024-12-09	0	3
1694	PI Haz Mor keg 20	PINTA Hazy Morning 12,0° keg 20 l	5123456789712	0	szt	0.00	RA-20-02	2024-12-09	0	-2
992	MIŁ KOM RIS	KOMES RUSSIAN IMPERIAL STOUT BUT. 0,5 L	5901687910840	1	szt	0.77	AT-28-03	2024-12-09	1	-9
2039	ROCK_SOU_#1_PUSZ_500	ROCKMILL SOURLAND #1 PUSZKA 0,5 L	5908291862725	156	szt	0.54	RJ-11-00	2024-12-09	0	145
623	FILOU	FILOU BUT. 0,33 L	5411081006211	57	szt	0.50	RD-01-01	2024-12-09	0	57
952	KAT01419ref	KEG BELGIA A3	5123456792002	25	szt	0.00	RE-08-01	2024-12-09	0	25
1223	255	MAES SZKLANKA 0,33 L	5123456791036	4	szt	0.00	AT-29-01	2024-12-09	0	4
1598	Palet Fort	PALETA FORTUNA EPAL 1200X800	\N	10	szt	0.00	RA-20-00	2024-12-09	0	10
2513	VER DUCH 250	VERHAEGHE DUCHESSE DE BOURGOGNE BUT. 0,25 L	5411364151119	92	szt	0.35	RL-03-01	2024-12-09	0	92
2647	BUT FOR	BUTELKA ZWR FORTUNA 0,5 L	\N	900	szt	0.00	RA-19-03	2024-12-09	0	900
2514	VIG_KOM_BIO_ACE_IMB_BUT_330	VIGO Kombucha BIO Acerola Imbir but. 0,33 l	5902768514308	65	szt	0.00	RL-02-01	2024-12-09	0	65
2515	VIG_KOM_BIO_MAN_MAR_BUT_330	VIGO Kombucha BIO Mango Marakuja but. 0,33 l	5902768514186	107	szt	0.00	RL-17-00	2024-12-09	0	107
2516	VIG_KOM_BIO_OG_KOL_BUT_330	VIGO Kombucha BIO Ogórek Kolendra but. 0,33 l	5902768514322	16	szt	0.00	RK-17-01	2024-12-09	0	16
2517	VIG_KOM_BIO_RÓŻ_BUT_330	VIGO Kombucha BIO Róża but. 0,33 l	5902768514346	9	szt	0.00	RB-20-04	2024-12-09	0	9
2518	VIG_YOK_KOM_JAG_BUT_330	VIGO Kombucha Jagody Acai but. 0,33 l	5902768514896	135	szt	0.00	RL-19-00	2024-12-09	0	135
2519	VIG_KOM_ORIG_BUT_330	VIGO Kombucha Original but. 0,33 l	5902768514803	97	szt	0.00	RL-03-01	2024-12-09	0	97
2520	OMB Vit Bab	VITAMINE SEA BABY WAVES PUSZKA 0,473 L	5123456790115	8	szt	0.53	RB-20-04	2024-12-09	0	8
2521	OMB Vit Bel	VITAMINE SEA BELOW SEA LEVEL PUSZKA 0,473 L	5123456790117	4	szt	0.53	RB-20-04	2024-12-09	0	4
2522	OMB Vit Clo	VITAMINE SEA CLOWNING AROUND PUSZKA 0,473 L	5123456790118	4	szt	0.53	RB-20-04	2024-12-09	0	4
2523	OMB Vit Cur	VITAMINE SEA CURRENCY CHECK PUSZKA 0,473 L	5123456790113	8	szt	0.53	RB-20-04	2024-12-09	0	8
2524	OMB Due	VITAMINE SEA DUE SOUTH PUSZKA 0,473 L	5123456790112	4	szt	0.53	RB-20-04	2024-12-09	0	4
2525	OMB Vit Gre	VITAMINE SEA GREETINGS FROM WEYMOUTH PUSZKA 0,473 L	5123456790116	4	szt	0.53	RB-20-04	2024-12-09	0	4
2526	KAT02738	WESTBROOK RHUBARB REMIX BUT. 0,75 L	856467003616	8	szt	1.10	RB-20-04	2024-12-09	0	8
2527	KAT06766	WESTMALLE BLACHA REKLAMOWA	5123456791207	1	szt	0.00	RB-20-04	2024-12-09	0	1
2528	WESTMA DUB 330	WESTMALLE DUBBEL BUT. 0,33 L	5412343152332	71	szt	0.50	RL-03-01	2024-12-09	0	71
2529	WESTMA DUB 750	WESTMALLE DUBBEL BUT. 0,75 L	5412343001166	97	szt	1.10	RL-04-01	2024-12-09	0	97
2530	KAT00930	WESTMALLE DUBBEL KEG 20 L	5412343001418	3	szt	21.50	RB-20-04	2024-12-09	0	3
2531	WESTMA EXT 330	WESTMALLE EXTRA BUT. 0,33 L	5412343000749	68	szt	0.50	RL-04-01	2024-12-09	0	68
2532	WESTMA TRI 330	WESTMALLE TRIPEL BUT. 0,33 L	5412343201337	8	szt	0.50	RB-20-04	2024-12-09	0	8
2533	WESTMA TRI 750	WESTMALLE TRIPEL BUT. 0,75 L	5412343001227	44	szt	1.10	RL-04-01	2024-12-09	0	44
2534	WESTVLET 12	WESTVLETEREN 12 XII BUT. 0,33 L	5123456790130	47	szt	0.50	RL-04-01	2024-12-09	0	47
2535	WESTVLET 8	WESTVLETEREN 8 EXTRA BUT. 0,33 L	5123456790132	6	szt	0.50	RB-20-04	2024-12-09	0	6
2536	WID 10TH	WIDAWA 10TH ANNIVERSARY IMPERIAL BALTIC PORTER BA BUT. 0,33 L	5907710904541	29	szt	0.50	RL-03-01	2024-12-09	0	29
2537	WID AUG	WIDAWA AUGUSTIAŃSKIE BUT. 0,5 L	5907710904022	20	szt	0.77	RL-04-01	2024-12-09	0	20
2538	WID CHR LAG	WIDAWA CHRZĄSTAWSKI LAGER BUT. 0,5 L	5907710904206	24	szt	0.77	RL-04-01	2024-12-09	0	24
2539	WID KUR	WIDAWA CZARNY KUR BUT. 0,5 L	5907710904015	35	szt	0.77	RL-05-01	2024-12-09	0	35
2540	WID FRU 500	WIDAWA FRUIT BOMB BUT. 0,5 L	5907710904060	8	szt	0.77	RB-20-04	2024-12-09	0	8
2541	WID_HOP_02_BUT_500	WIDAWA HOP INCIDENT 02 BUT. 0,5 L	5907710904619	125	szt	0.77	RL-19-00	2024-12-09	0	125
2542	WID LAT 500	WIDAWA LATO CZEKA BUT. 0,5 L	5907710904053	220	szt	0.77	RL-19-00	2024-12-09	0	220
2543	WID_LE_POL_2022_BUT_750	WIDAWA LE POLONAIS C'T'UNE JOKE 2022 BARREL AGED BUT. 0,75 L	5907710904602	21	szt	1.10	RL-05-01	2024-12-09	0	21
2544	WID LEP CAB	WIDAWA LE POLONAISE C’T’UNE JOKE CABERNET CORTIS B.A. BUT. 0,75 L	5907710904602	40	szt	1.10	RL-05-01	2024-12-09	0	40
2545	WID LEP MAR	WIDAWA LE POLONAISE C’T’UNE JOKE’21 MARSALA BA BUT. 0,75 L	5907710904084	31	szt	1.10	RL-05-01	2024-12-09	0	31
2546	WID_NZ_PIL_BUT_500	WIDAWA NZ PILS BUT. 0,5 L	5907710904220	117	szt	0.77	AT-01-00	2024-12-09	0	117
2547	WID PRE	WIDAWA PREMIUM BUT. 0,5 L	5907710904008	20	szt	0.77	RL-05-01	2024-12-09	0	20
2548	WID SHA 500	WIDAWA SHARK BUT. 0,5 L	5907710904046	203	szt	0.77	AT-01-00	2024-12-09	0	203
2549	WID SIM 500	WIDAWA SIMCOE PILS BUT. 0,5 L	5907710904220	41	szt	0.77	RL-05-01	2024-12-09	0	41
2550	WID TRO 500	WIDAWA TROPICAL STORM BUT. 0,5 L	5907710904039	149	szt	0.77	AT-01-00	2024-12-09	0	149
2551	KAT07133	WIEZE TRIPEL BUT. 0,33 L	5425036510012	27	szt	0.50	RL-06-01	2024-12-09	0	27
2552	WRE BOW BA	WRĘŻEL BOWMORE BARREL AGED BUT. 0,33 L	5904730465038	21	szt	0.50	RL-06-01	2024-12-09	0	21
2553	WRE BUF BA	WRĘŻEL BUFFALO TRACE BARREL AGED BUT. 0,33 L	5904730465069	16	szt	0.50	RL-02-01	2024-12-09	0	16
2554	WRE BUT	WRĘŻEL BUTTERFLY BUT. 0,5 L	5904730465137	20	szt	0.77	RL-06-01	2024-12-09	0	20
2555	WRE CAR	WRĘŻEL CARDINAL BUT. 0,5 L	5904730465120	40	szt	0.77	RL-06-01	2024-12-09	0	40
2556	WRE CEL 2	WRĘŻEL CELTIC SURPRISE PART TWO BUT. 0,5 L	5904181970341	1	szt	0.77	RB-21-00	2024-12-09	0	1
2557	WRE CHE 1	WRĘŻEL CHERRY NO.1 BUT. 0,5 L	5904730465977	20	szt	0.77	RL-06-01	2024-12-09	0	20
2558	WRE CHE WIL BA	WRĘŻEL CHERRY WILD BARREL AGED BUT. 0,33 L	5904730465984	14	szt	0.50	RL-06-01	2024-12-09	0	14
2559	WRE COO	WRĘŻEL COOLIBER BUT. 0,5 L	5904730465939	35	szt	0.77	RL-07-01	2024-12-09	0	35
2560	WRE HEF	WRĘŻEL HEFEWEIZEN PSZENICZNE JASNE BUT. 0,5 L	5904730465045	82	szt	0.77	RL-07-01	2024-12-09	0	82
2561	WR_MAL_BOW_BA_BUT_500	WRĘŻEL MALTIC STORM BOWMORE BUT. 0,5 L	5904181970280	84	szt	0.77	RL-07-01	2024-12-09	0	84
2562	WR_MAL_BUF_BA_BUT_500	WRĘŻEL MALTIC STORM BUFFALO TRACE BUT. 0,5 L	5904181970303	95	szt	0.77	RL-07-01	2024-12-09	0	95
2563	WR_MAL_HEA_BA_BUT_500	WRĘŻEL MALTIC STORM HEAVEN HILL BUT. 0,5 L	5904181970297	84	szt	0.77	RL-08-01	2024-12-09	0	84
2564	WR_MAL_ISL_BA_BUT_500	WRĘŻEL MALTIC STORM ISLAY SA BUT. 0,5 L	5904181970273	69	szt	0.77	RL-08-01	2024-12-09	0	69
2565	WRE MAN	WRĘŻEL MANGOVE BUT. 0,5 L	5904730465304	55	szt	0.77	RL-08-01	2024-12-09	0	55
2566	WRE_MEX_TWO_BUT_500	WRĘŻEL MEXICO TRIP: PART TWO BUT. 0,5 L	5904181970471	15	szt	0.77	RL-08-01	2024-12-09	0	15
2567	WRE MIL ME	WRĘŻEL MILK ME BUT. 0,5 L	5904730465366	38	szt	0.77	RL-08-01	2024-12-09	0	38
2568	WRE MIS BRA	WRĘŻEL MIŚ WOJTEK BRAGGOT BUT. 0,5 L	5904181970419	1	szt	0.77	RB-21-00	2024-12-09	0	1
2569	WRE PIL	WRĘŻEL PILS BUT. 0,5 L	5904730465731	55	szt	0.77	RL-09-01	2024-12-09	0	55
2572	WRE VIV ONE_PROM	WRĘŻEL VIVA ESPANA ONE PUSZKA 0,5 L PROMOCJA (do 20.10.23)	\N	33	szt	0.00	RL-09-01	2024-12-09	0	33
2573	WRE VIV TWO_PROM	WRĘŻEL VIVA ESPANA TWO PUSZKA 0,5 L PROMOCJA (do 20.10.23)	\N	19	szt	0.00	RL-09-01	2024-12-09	0	19
2574	WRE ZER B	WRĘŻEL ZERO BUT. 0,5 L	5904181970105	30	szt	0.77	RL-09-01	2024-12-09	0	30
2575	WRE_ZER_MAN_BUT_500	WRĘŻEL ZERO Z MANGO BUT. 0,5 L	5904181970525	20	szt	0.77	RL-09-01	2024-12-09	0	20
2576	VIG_YOK_MATCH_BUT_330	YOKO Matcha BIO but. 0,33 l	5902768514988	211	szt	0.00	AT-02-00	2024-12-09	0	211
2577	ZAM_5TH_FRE_APA_BUT_500	ZA MIASTEM 5TH ELEMENT ALCOHOL FREE APA BUT. 0,5 L	5904905630193	557	szt	0.77	RA-16-03	2024-12-09	0	557
2578	ZAM_5TH_APA_BUT_500	ZA MIASTEM 5TH ELEMENT AMERICAN PALE ALE BUT. 0,5 L	5904905630186	565	szt	0.77	RA-16-04	2024-12-09	0	565
2579	ZAM_BŁO_NAS_BUT_500	ZA MIASTEM BŁOGI NASTRÓJ BUT. 0,5 L	5904905630131	404	szt	0.77	AT-03-00	2024-12-09	0	404
2580	ZAM_CHWI_OD_BUT_500	ZA MIASTEM CHWILA ODDECHU BUT. 0,5 L	5904905630209	750	szt	0.77	RA-17-02	2024-12-09	0	750
2581	ZAM_CHW_SPOK_BUT_500	ZA MIASTEM CHWILA SPOKOJU BUT. 0,5 L	5904905630155	19	szt	0.77	RL-09-01	2024-12-09	0	19
2582	ZAM CIC	ZA MIASTEM CICHY WIECZÓR BUT. 0,5 L	5906874605011	101	szt	0.77	RL-08-00	2024-12-09	0	101
2583	ZAM DLU	ZA MIASTEM DŁUGI WEEKEND BUT. 0,5 L	5906874605004	349	szt	0.77	AT-04-00	2024-12-09	0	349
2584	ZAM DOB	ZA MIASTEM DOBRA NOC BUT. 0,5 L	5906874605059	40	szt	0.77	RL-10-01	2024-12-09	0	40
2585	ZAM_DOB_NAST_BUT_500	ZA MIASTEM DOBRY NASTRÓJ BUT. 0,5 L	5904905630162	221	szt	0.77	AT-02-00	2024-12-09	0	221
2586	ZAM DOB JES	ZA MIASTEM DOBRZE JEST BUT. 0,5 L	5906874605417	108	szt	0.77	AT-02-00	2024-12-09	0	108
2587	ZAM DZI DOB	ZA MIASTEM DZIEŃ DOBRY BUT. 0,5 L	5906874605288	172	szt	0.77	AT-04-00	2024-12-09	0	172
2588	ZAM_DZI_DOB_POM_BUT_500	ZA MIASTEM DZIEŃ DOBRY Z POMARAŃCZĄ BUT. 0,5 L	5904905630179	35	szt	0.77	RL-10-01	2024-12-09	0	35
2589	ZAM DZI	ZA MIASTEM DZIEŃ WOLNY BUT. 0,5 L	5906874605028	188	szt	0.77	AT-05-00	2024-12-09	0	188
2590	ZAM LEN	ZA MIASTEM LENIWE CHWILE BUT. 0,5 L	5906874605189	95	szt	0.77	RL-10-01	2024-12-09	0	95
2591	ZAM LET	ZA MIASTEM LETNIA PRZYGODA BUT. 0,5 L	5906874605103	99	szt	0.77	RL-10-01	2024-12-09	0	99
2592	ZAM NAW	ZA MIASTEM NA WYPASIE BUT. 0,5 L	5906874605042	906	szt	0.77	RA-17-03	2024-12-09	0	906
2593	ZAM_OWOC_ROZM_BUT_500	ZA MIASTEM OWOCNE ROZMOWY BUT. 0,5 L	5904905630216	134	szt	0.77	AT-03-00	2024-12-09	0	134
2594	ZAM PEŁ LUZ	ZA MIASTEM PEŁEN LUZ BUT. 0,5 L	5906874605141	39	szt	0.77	RL-11-01	2024-12-09	0	39
2595	ZAM_PEŁ_REL_BUT_500	ZA MIASTEM PEŁEN RELAKS BUT. 0,5 L	5904905630223	84	szt	0.77	RL-11-01	2024-12-09	0	84
2596	ZAM_PEŁ_SZCZ_BUT_500	ZA MIASTEM PEŁNIA SZCZĘŚCIA BUT. 0,5 L	5904905630124	65	szt	0.77	RL-11-01	2024-12-09	0	65
2597	ZAM PEŁ ŻYC	ZA MIASTEM PEŁNIA ŻYCIA BUT. 0,5 L	5906874605479	102	szt	0.77	RL-18-00	2024-12-09	0	102
2598	ZAM_PIĄ_WIE_BUT_500	ZA MIASTEM PIĄTEK WIECZÓR BUT. 0,5 L	5904905630100	62	szt	0.77	RL-11-01	2024-12-09	0	62
2600	ZAM RAD	ZA MIASTEM RADOŚĆ ŻYCIA BUT. 0,5 L	5906874605196	797	szt	0.77	RA-17-04	2024-12-09	0	797
2601	ZAM RZE	ZA MIASTEM RZEŚKI PORANEK BUT. 0,5 L	5904905630025	880	szt	0.77	RA-18-02	2024-12-09	0	880
2602	ZAM_SIŁ_WOL_BUT_330	ZA MIASTEM SIŁA WOLI BUT. 0,33 L	5904905630070	61	szt	0.50	RL-12-01	2024-12-09	0	61
2603	ZAM SŁO LEN	ZA MIASTEM SŁODKIE LENISTWO Z KAKAOWCEM BUT. 0,5 L	5906874605240	40	szt	0.77	RL-12-01	2024-12-09	0	40
2604	ZAM SŁO	ZA MIASTEM SŁONECZNY DZIEŃ BUT. 0,5 L	5906874605097	23	szt	0.77	RL-10-01	2024-12-09	0	23
2605	ZAM_SMA_WK_BUT_500	ZA MIASTEM SMAK WAKACJI BUT. 0,5 L	5904905630148	16	szt	0.77	RL-12-01	2024-12-09	0	16
2606	ZAM_SPO_DU_BUT_500	ZA MIASTEM SPOKÓJ DUCHA BUT. 0,5 L	\N	138	szt	0.77	AT-05-00	2024-12-09	0	138
2607	ZAM SPO	ZA MIASTEM SPOTKANIE PRZYJACIÓŁ BUT. 0,5 L	5906874605462	16	szt	0.77	RL-12-01	2024-12-09	0	16
2608	ZAM SWI	ZA MIASTEM ŚWIĘTY SPOKÓJ BUT. 0,5 L	5906874605066	122	szt	0.77	AT-05-00	2024-12-09	0	122
2609	ZAM UŚM	ZA MIASTEM UŚMIECH LOSU BUT. 0,5 L	5906874605424	94	szt	0.77	RL-12-01	2024-12-09	0	94
2611	ZAM_WIE_RAD_BUT_500	ZA MIASTEM WIELKA RADOŚĆ BUT. 0,5 L	5904905630230	862	szt	0.77	RA-18-03	2024-12-09	0	862
2612	ZAM WLA	ZA MIASTEM WŁASNE SPRAWY BUT. 0,5 L	5906874605035	662	szt	0.77	RA-18-04	2024-12-09	0	662
2613	ZA_ALE_TO_BUT_500	ZAKŁADOWY ALE TO TY DZWONISZ BUT. 0,5 L	5907753172280	35	szt	0.77	RL-12-01	2024-12-09	0	35
2614	ZAKŁ BAŁ	ZAKŁADOWY BAŁAGAN BUT. 0,5 L	5907753171597	75	szt	0.77	RL-13-01	2024-12-09	0	75
2616	ZA_BUM_BUT_500_PROM	ZAKŁADOWY BUMELANT BUT. 0,5 L PROMOCJA (do 04.10.23)	\N	44	szt	0.00	RL-13-01	2024-12-09	0	44
2617	ZA_CO_BED_BUT_500	ZAKŁADOWY CO BĘDZIE W LIPCU? BUT. 0,5 L	5907753172358	35	szt	0.77	RL-13-01	2024-12-09	0	35
2618	ZA_GOŁ_BUT_500	ZAKŁADOWY GOŁĄB NA DACHU BUT. 0,5 L	5907753172334	44	szt	0.77	RL-13-01	2024-12-09	0	44
2619	ZAKŁ KIN KOS	ZAKŁADOWY KINO KOSMOS BUT. 0,5 L	5907753170286	43	szt	0.77	RL-14-01	2024-12-09	0	43
2620	ZAKŁ ŁAT POS	ZAKŁADOWY ŁATWO POSZŁO BUT. 0,5 L	5907753171351	49	szt	0.77	RL-14-01	2024-12-09	0	49
2621	ZA_NAP_FIR_BUT_500	ZAKŁADOWY NAPÓJ FIRMOWY BUT. 0,5 L	5907753172020	150	szt	0.77	AT-06-00	2024-12-09	0	150
2622	ZAKŁ PIE	ZAKŁADOWY PIERWSZA ZMIANA BUT. 0,5 L	5906395388004	20	szt	0.77	RL-14-01	2024-12-09	0	20
2623	ZAKŁ PIL	ZAKŁADOWY PILS BUT. 0,5 L	5907753172228	100	szt	0.77	RL-14-01	2024-12-09	0	100
2624	ZA_POZ_BUT_500	ZAKŁADOWY POZAMIATANE BUT. 0,5 L	5907753172310	1	szt	0.77	RB-21-00	2024-12-09	0	1
2625	ZAKŁ PRO	ZAKŁADOWY PRODUKT WZORCOWY BUT. 0,5 L	5906395388028	70	szt	0.77	RL-14-01	2024-12-09	0	70
2626	ZA_PROS_BUT_500	ZAKŁADOWY PROSTY WYBÓR BUT. 0,5 L	5907753172402	37	szt	0.77	RL-15-01	2024-12-09	0	37
2627	ZA_PSZ_BUT_500	ZAKŁADOWY PSZENICA BUT. 0,5 L	5907753172235	102	szt	0.77	AT-06-00	2024-12-09	0	102
2628	ZA_SEZ_CZW_BUT_500	ZAKŁADOWY SEZON CZWARTY BUT. 0,5 L	5907753172136	45	szt	0.77	RL-15-01	2024-12-09	0	45
2599	ZAM POG	ZA MIASTEM POGODA DUCHA BUT. 0,5 L	5906874605073	37	szt	0.77	RL-11-01	2024-12-09	12	13
2629	ZA_SOK_AR0-POR_BUT_500_PROM	ZAKŁADOWY SOKOWIRÓWKA ARONIA & PORZECZKA BUT. 0,5 L PROMOCJA (do 28.10.23)	\N	125	szt	0.00	AT-07-00	2024-12-09	0	125
2630	ZA_WNI_URL_BUT_500	ZAKŁADOWY WNIOSEK URLOPOWY BUT. 0,5 L	5906395388219	74	szt	0.77	RL-15-01	2024-12-09	0	74
2631	ZA_WRÓ_BUT_500	ZAKŁADOWY WRÓBEL W GARŚCI BUT. 0,5 L	5907753172327	75	szt	0.77	RL-15-01	2024-12-09	0	75
2632	ZAKŁ WUJ AME	ZAKŁADOWY WUJEK Z AMERYKI BUT. 0,5 L	5906395388400	200	szt	0.77	AT-07-00	2024-12-09	0	200
2633	ZA_WUJ_SŁO_BUT_500	ZAKŁADOWY WUJEK ZE SŁOWENII BUT. 0,5 L	5907753172013	1	szt	0.77	RB-21-00	2024-12-09	0	1
2634	ZA_Z_CAŁ_BUT_500	ZAKŁADOWY Z CAŁYM SZACUNKIEM BUT. 0,5 L	5907753172341	28	szt	0.77	RL-15-01	2024-12-09	0	28
2635	ZA_Z _FAR_BUT_500	ZAKŁADOWY Z FARTEM MORDECZKO BUT. 0,5 L	5907753172273	82	szt	0.77	RL-16-01	2024-12-09	0	82
2636	ZA_Z_FART_KEG_30	ZAKŁADOWY Z FARTEM MORDECZKO KEG 30 L	\N	1	szt	32.00	RB-21-00	2024-12-09	0	1
2637	ZO_AYE_PUSZ_500	ZIEMIA OBIECANA AYE! PUSZKA 0,5 L	5905186484642	10	szt	0.54	RB-21-00	2024-12-09	0	10
2638	ZO_BAN_PUSZ_500	ZIEMIA OBIECANA BANIALUKI PUSZKA 0,5 L	5905186484666	20	szt	0.54	RL-15-01	2024-12-09	0	20
2639	ZO_DOZ_PUSZ_500	ZIEMIA OBIECANA DOZO! PUSZKA 0,5 L	5905186484710	30	szt	0.54	RL-16-01	2024-12-09	0	30
2640	ZO_TRI_BAJ_PUSZ_500	ZIEMIA OBIECANA TRIPLE BAJLANDO PUSZKA 0,5 L	5905186484314	15	szt	0.54	RL-14-01	2024-12-09	0	15
2641	ZO_TRI_LE_SZE_PUSZ_500	ZIEMIA OBIECANA TRIPLE LE SZEF PUSZKA 0,5 L	5905186484734	69	szt	0.54	RL-16-01	2024-12-09	0	69
2642	ZU_MELA_CHM_BUT_330	ZULI MELARYA CHMIEL BUT. 0,33 L	5904933314218	71	szt	0.50	RL-16-01	2024-12-09	0	71
2643	ZU_MELA_IMB_BUT_330	ZULI MELARYA IMBIR BUT. 0,33 L	5904933314201	92	szt	0.50	RL-17-01	2024-12-09	0	92
2644	ZU_MELA_IMB_QUA_BUT_330	ZULI MELARYA IMBIR QUATRO BUT. 0,33 L	5904933314287	83	szt	0.50	RL-17-01	2024-12-09	0	83
2645	ZU_STURN_BUT_700	ZULI STURNUS TRÓJNIAK WIŚNIOWY BUT. 0,7 L	5904933314263	21	szt	0.00	RL-16-01	2024-12-09	0	21
2646	BŁO KUR P	BŁONIE KUR ZAPIAŁ PUSZKA 0,5 L	5908258856903	900	szt	0.54	RA-19-02	2024-12-09	0	900
2648	DUV POD	DUVEL 6.66 PODKŁADKI	5123456789852	900	szt	0.00	RA-19-04	2024-12-09	0	900
2649	DUV 330	DUVEL BUT. 0,33 L	5411681014005	900	szt	0.50	RB-01-02	2024-12-09	0	900
2650	PI Bes Pil	PINTA Beskidy Pils 12,0° but. 0,5 l	5904730438926	900	szt	0.00	RB-01-03	2024-12-09	0	900
2651	PI_BES_PRA_CIE_BUT_500	PINTA Beskidy Prawdziwe Ciemne 13,0° but. 0,5 l	5904730438995	900	szt	0.00	RB-01-04	2024-12-09	0	900
2652	PI_HAZ_DEL_CAN_500	PINTA Hazy Delivery 15,0° can 0,5 l	5904165103840	900	szt	0.00	RB-02-02	2024-12-09	0	900
2653	PI_PIL_TIM_BUT_500	PINTA Pils Time 12,0° but. 0,5 l	5904165104182	900	szt	0.00	RB-02-03	2024-12-09	0	900
2654	BŁO KUR P	BŁONIE KUR ZAPIAŁ PUSZKA 0,5 L	5908258856903	900	szt	0.54	RB-02-04	2024-12-09	0	900
2655	BUT FOR	BUTELKA ZWR FORTUNA 0,5 L	\N	900	szt	0.00	RB-03-02	2024-12-09	0	900
2656	DUV POD	DUVEL 6.66 PODKŁADKI	5123456789852	900	szt	0.00	RB-03-03	2024-12-09	0	900
2657	DUV 330	DUVEL BUT. 0,33 L	5411681014005	900	szt	0.50	RB-03-04	2024-12-09	0	900
2658	BŁO KUR P	BŁONIE KUR ZAPIAŁ PUSZKA 0,5 L	5908258856903	900	szt	0.54	RB-04-02	2024-12-09	0	900
2659	BUT FOR	BUTELKA ZWR FORTUNA 0,5 L	\N	900	szt	0.00	RB-04-03	2024-12-09	0	900
2660	DUV POD	DUVEL 6.66 PODKŁADKI	5123456789852	900	szt	0.00	RB-04-04	2024-12-09	0	900
2661	DUV 330	DUVEL BUT. 0,33 L	5411681014005	900	szt	0.50	RB-05-02	2024-12-09	0	900
2662	BŁO KUR P	BŁONIE KUR ZAPIAŁ PUSZKA 0,5 L	5908258856903	900	szt	0.54	RB-05-03	2024-12-09	0	900
2663	BUT FOR	BUTELKA ZWR FORTUNA 0,5 L	\N	900	szt	0.00	RB-05-04	2024-12-09	0	900
2664	DUV POD	DUVEL 6.66 PODKŁADKI	5123456789852	900	szt	0.00	RB-06-02	2024-12-09	0	900
2665	DUV 330	DUVEL BUT. 0,33 L	5411681014005	900	szt	0.50	RB-06-03	2024-12-09	0	900
2666	BUT FOR	BUTELKA ZWR FORTUNA 0,5 L	\N	900	szt	0.00	RB-06-04	2024-12-09	0	900
2667	DUV 330	DUVEL BUT. 0,33 L	5411681014005	900	szt	0.50	RB-07-02	2024-12-09	0	900
2668	BUT FOR	BUTELKA ZWR FORTUNA 0,5 L	\N	900	szt	0.00	RB-07-03	2024-12-09	0	900
2669	BUT FOR	BUTELKA ZWR FORTUNA 0,5 L	\N	900	szt	0.00	RB-07-04	2024-12-09	0	900
2670	BUT FOR	BUTELKA ZWR FORTUNA 0,5 L	\N	900	szt	0.00	RB-08-02	2024-12-09	0	900
\.


--
-- TOC entry 4904 (class 0 OID 25336)
-- Dependencies: 228
-- Data for Name: relocation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.relocation (id, initial_location, product_name, ean, amount, target_location, user_id, date, "time", status) FROM stdin;
1	RA-03-00	ALEBROWAR MANGO MAN BUT. 0,5 L	5907771341064	15	RK-03-00	\N	2024-12-09	19:33:31+02	done
2	RA-11-00	ARTEZAN MERA IPA BUT. 0,5 L	5904730574013	74	RL-03-00	KS	2024-12-09	20:27:04+02	done
3	RA-02-00	ALEBROWAR EL FRUTO BUT. 0,5 L	5907222039106	60	RL-11-01	KS	2024-12-09	17:44:45+01	done
\.


--
-- TOC entry 4898 (class 0 OID 25281)
-- Dependencies: 222
-- Data for Name: reservation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reservation (product_name, ean, amount, reserved_amount, available_amount, id) FROM stdin;
ST. FEUILLIEN TRIPEL BUT. 0,33 L	5412138403311	285	0	285	1
SAISON DUPONT SZKLANKA 0,33 L	5123456791027	204	0	204	2
HARPAGAN AMRITA PUSZKA 0,5 L	5905450141059	247	0	247	3
TRZECH KUMPLI CITRUS SESSION JUICY IPA - OUR NEW IPA PUSZKA 0,5 L	5904252699782	289	0	289	4
BOON GEUZE SZKLANKA 0,375 L	5123456791049	266	0	266	5
ST. BERNARDUS WATAU KIELICH 0,5 L	5123456791173	205	0	205	6
SAISON 1858 SZKLANKA 0,25 L	5123456791028	206	0	206	7
DUGGES POPSICLE PUSZKA 0,33 L	7350038226167	213	0	213	8
KOMES WYMRAЇANY BARLEY WINE OLD FORESTER BA BUT. 0,33 L	5902838991411	238	0	238	9
CZTERY ЊCIANY BENEFIS PUSZKA 0,5 L	5905108498832	205	0	205	10
JURAJSKIE PORZECZKA BUT. 0,5 L	5905331026895	259	0	259	11
KEG SCHLENKERLA 30 L	5123456792019	210	0	210	12
KASTEEL RUBUS FRAMBOISE KEG 20 L	\N	203	0	203	13
3 FONTEINEN OUDE KRIEK  2019/20 BUT. 1,5 L	5425007818598	203	0	203	14
LINDEMANS FLAGA	5123456791139	208	0	208	15
LINDEMANS FARO BUT. 0,25 L	5411223101019	217	0	217	16
GRYFUS GRYFITA BUT. 0,5 L	5907222685167	280	0	280	17
CZTERY ЊCIANY KAMPER PUSZKA 0,5 L	5906874341674	375	0	375	18
DUCKPOND DARKWING PUSZKA 0,33 L	7350015140219	201	0	201	19
JURAJSKIE ALE MEKSYK BUT. 0,5 L	5905331026376	350	0	350	20
CHYLICZKI CYDR IMBIROWY SAD BUT. 0,33 L	5905279058323	305	0	305	21
DEER BEAR COLD CAT KEG 30 L	\N	201	0	201	22
CZTERY ЊCIANY ILUZJA PUSZKA 0,5 L	5905108498870	334	0	334	23
WIDAWA PREMIUM BUT. 0,5 L	5907710904008	220	0	220	24
ROCKMILL SOURLAND #2 PUSZKA 0,5 L	5908291862732	384	0	384	25
ANDERSON JEAN GINIE TEQUILA BA BUT. 0,33 L	4744175010995	232	0	232	26
MAES SZKLANKA 0,33 L	5123456791036	204	0	204	27
GULDEN DRAAK QUADRUPLE BUT. 0,75 L	5411663002853	205	0	205	28
NEPOMUCEN HOPOLLO PUSZKA 0,5 L	5907709756946	300	0	300	29
VIGO Kombucha BIO Acerola Imbir but. 0,33 l	5902768514308	265	0	265	30
PRZETWУRNIA CHMIELU OWOC PUSZKA 0,5 L	5905476980588	325	0	325	31
MARYENSZTADT OAT CHOCOLATE RIS HEAVEN HILL KENTUCKY STRAIGHT BURBON WHISKEY & COGNAC B.A. BUT. 0,33 L	5903424615780	212	0	212	32
DUGGES SEBASTIAN PUSZKA 0,5 L	7350038227232	221	0	221	33
PIWNE PODZIEMIE KRAKEN OF DOOM – SPECIAL VERSION BUT. 0,33 L	5904305482590	226	0	226	34
ARTEZAN JARDIN DU CHВTEAU DRUIF BUT. 0,375 L	5904708750609	305	0	305	35
WRКЇEL MALTIC STORM BOWMORE BUT. 0,5 L	5904181970280	284	0	284	36
WIDAWA 10TH ANNIVERSARY IMPERIAL BALTIC PORTER BA BUT. 0,33 L	5907710904541	229	0	229	37
FUNKY FLUID JAM SESSION PUSZKA 0,5 L	5907772092279	1656	0	1656	38
SKRZYNKA NA PIWO CZECHY ( B )	\N	224	0	224	39
BIRBANT RATIO PUSZKA 0,5 L	5904041703829	578	0	578	40
PINTA Otwieracz magnes Modern Drinking	5904165101655	209	0	209	41
KASTEEL DONKER BUT. 0,33 L	5411081000523	241	0	241	42
CZTERY ЊCIANY PALMA PUSZKA 0,5 L	5906874341933	235	0	235	43
PINTA T-shirt biaіy duїe logo M	5904165102454	202	0	202	44
DUGGES DOUBLE RAINBOW PUSZKA 0,5 L	7350038227959	209	0	209	45
ALEBROWAR MINT OF CHANGE - MOHITO BUT. 0,5 L	5907771343389	291	0	291	46
ARTEZAN BEZ KROPKI TO NIE WITAM BUT. 0,5 L	5904708750784	249	0	249	47
IMBIOROWICZ MIУD PITNY TRУJNIAK MIУD MALINA BUT. 0,375 L	5905669820394	201	0	201	48
VIGO Kombucha Jagody Acai but. 0,33 l	5902768514896	335	0	335	49
KORMORAN 6-PAK ЊLIWKA W PIWIE  BUT. 0,375 L PROMOCJA (do 11.10.23)	\N	238	0	238	50
MIЈOSЈAW CHMIELOWY LAGER BZW BUT. 0,5 L	\N	266	0	266	51
PINTA Psst... It's Your Weekend IPA - Cold IPA 15,0° keg 20 l	5123456780029	201	0	201	52
LA TRAPPE WITTE TRAPPIST BUT. 0,75 L	8711406103876	451	0	451	53
MADAME BARREL PATI CZECK BUT. 0,5 L PROMOCJA (do 30.09.23)	\N	205	0	205	54
STRUISE PANNEPOT 2020 BUT. 0,33 L	5425017810049	201	0	201	55
ST. FEUILLIEN SAISON BUT. 0,75 L	5412138317519	258	0	258	56
CROOKED STAVE L`BRETT D`BLUEBERRY 2016 BUT. 0,75L	854512003932	203	0	203	57
BROWAR JANA APA BUT. 0,5 L	5902429980022	571	0	571	58
PINTA Hazy Discovery Minas Gerais 16,5° can 0,5 l	5904165104649	201	0	201	59
JAN OLBRACHT LEGENDY POLSKIE: CZART BA BUT. 0,33 L	5902627012242	211	0	211	60
SVIJANY RYTIR 12% BUTELKA 0,5 L	8594030010075	210	0	210	61
GULDEN DRAAK POKAL 0,33 L	5123456791088	202	0	202	62
NEPOMUCEN FLY ME TO BEMOWO PUSZKA 0,5 L	5905701060238	246	0	246	63
CHYLICZKI CYDR JAPOСSKI SAD BUT. 0,5 L	5905279058224	339	0	339	64
LINDEMANS FARO MEDALION RYBIE OKO	\N	201	0	201	65
TRZECH KUMPLI AMERICAN BEAUTY PUSZKA 0,5 L	5904252699478	316	0	316	66
PINTA T-shirt zielony duїe logo L	5904165102560	202	0	202	67
BALADIN XYAUYU KENTUCKY 2017 BUT. 0,5 L	8032942290609	251	0	251	68
KASTEEL ROUGE PODKЈADKI	5123456791338	212	0	212	69
AUGUSTIJN GRAND CRU BUT. 0,33 L	5411663002204	212	0	212	70
LINDEMANS MATA BAROWA 57/13	5123456791137	203	0	203	71
PINTA T-shirt czarny duїe logo S	5904165102393	202	0	202	72
LUBROW PORTERITO PUSZKA 0,33 L	5903686842856	231	0	231	73
ZA MIASTEM SPOTKANIE PRZYJACIУЈ BUT. 0,5 L	5906874605462	216	10	216	74
NEPOMUCEN THE SPIRAL PUSZKA 0,5 L	5905701060276	280	0	280	75
BROKREACJA RICKSHAW BUT. 0,5 L	5904422197940	207	0	207	76
MAGIC ROAD WILD PRETTY #11 DOUBLE BARREL AGED PUSZKA 0,33 L	5905204130636	308	0	308	77
ED RED CHILI CON CARNE Z BRҐZ. RYЇEM - WIEPRZOWINA	5904083584165	210	0	210	78
STONE CRIME BUT. 0,5 L	636251870415	213	0	213	79
DRAKES DRAKONIC BUT. 0,65 L	854957002071	203	0	203	80
LUPULUS BLONDE TRIPLE BUT. 0,33 L	5425025122035	218	0	218	81
MOERSLEUTEL 6Y SJAAK PUSZKA 0,44 L	8720615260539	201	0	201	82
JURAJSKIE Z OSTROPESTEM BUT. 0,5 L	5905331025294	255	0	255	83
NEPOMUCEN TROPICAL FEET PUSZKA 0,5 L	5905701060085	202	0	202	84
PINTA Hazy Morning 12,0° keg 30 l	5123456789713	201	0	201	85
IMBIOROWICZ MIУD PITNY TRУJNIAK ЇҐDЈO Z BECZKI BA BUT. 0,5 L	5905669820424	226	0	226	86
LINDEMANS GUEUZE SZKLANKA 0,25 L	5123456791039	350	0	350	87
MOCZYBRODA FLAN PARISIEN PUSZKA 0,5 L	5904673801078	249	0	249	88
FUNKY FLUID TRIPLE GELATO: BIANCO PUSZKA 0,5 L	5903999513832	210	0	210	89
VERHAEGHE DUCHESSE DE BOURGOGNE BUT. 0,25 L	5411364151119	292	0	292	90
ALEBROWAR OCEAN EMPEROR BUT. 0,5 L	5907771342634	280	0	280	91
ARTEZAN 11 BUT. 0,5 L	5904708750746	311	0	311	92
JURAJSKIE MOTOCYKLOWE BUT. 0,5 L	5905331026369	493	0	493	93
DUVEL POKAL 666 0,33 L	5123456791094	247	0	247	94
STAROPOLSKIE KULTOWE PILS BUT. 0,5 L	5905669086455	258	0	258	95
DZIK CYDR SZKLANKA SHAKER 0,5 L	5123456791447	213	0	213	96
LA TRAPPE ISID`OR BUT. 0,33 L	8711406031681	353	0	353	97
PINTA RISFACTOR Cocoa Nibs and Coconut 30,0° keg 10 l	5123456780052	201	0	201	98
P?HJALA MUST KULD PAPER MILL PUSZKA 0,33 L	4742976015621	211	0	211	99
PINTA T-shirt Atak Chmielu S	5903990622694	202	0	202	100
FORTUNA BEZALKOHOLOWE CZARNE BUT. 0,5 L	5902838990667	295	0	295	101
BRUSSELS BEER PROJECT TEKU 0,33 L	5123456791009	241	0	241	102
ENAME TRIPLE BUT. 0,33 L	5412583240363	213	0	213	103
INNE BECZKI SOURZILLA PUSZKA 0,5 L	5903661281434	810	0	810	104
TANKBUSTERS BROTHERS IN ARMS PUSZKA 0,5 L	5904365781497	304	0	304	105
FUNKY FLUID VOYAGE, VOYAGE PUSZKA 0,5 L	5903999514204	284	0	284	106
PRAIRIE CHRISTMAS BOMB! BUT. 0,355 L	683318988354	202	0	202	107
TRZECH KUMPLI OATY BUT. 0,33 L	5904252699751	297	0	297	108
LINDEMANS TABLICA PODЊWIETLANA Z PODSTAWKҐ NA BUTELKI	5123456791370	202	0	202	109
PINTA T-shirt szary duїe logo M	5904165102508	202	0	202	110
ZAKЈADOWY WUJEK ZE SЈOWENII BUT. 0,5 L	5907753172013	201	0	201	111
ST. GUMMARUS DUBBEL BUT. 0,33 L	5413699011168	232	0	232	112
IGNACУW CYDR POM BUT. 0,375 L	\N	258	0	258	113
MARYENSZTADT KLASYCZNIE GERMAN PILS BUT. 0,5 L	5903678022181	220	0	220	114
STRUISE BLACK DAMNATION X - DOUBLE WOOD BUT. 0,33 L	5425017666103	214	0	214	115
BOON KRIEK KIELISZEK 0,5 L	5123456791167	248	0	248	116
CANTILLON GUEUZE-LAMBIC BIO 2022 BUT. 0,75L	5123456788010	239	0	239	117
JURAJSKIE VERMONT IPA BUT. 0,5 L	5905331026963	245	0	245	118
PINTA Hazy Delivery 15,0° keg 20 l	5123456780022	205	0	205	119
MARYENSZTADT KLASYCZNIE CZESKA DESITKA BUT. 0,5 L	5905669542586	228	0	228	120
SCHLENKERLA RAUCHBIER EICHE VINTAGE 2018 19,9° BUT. 0,5 L	\N	223	0	223	121
DE CAM TROSBESSEN BUT. 0,75 L	5425021680133	202	0	202	122
DZIKI WSCHУD ORЈA CIEС BUT. 0,5 L	5906874369418	260	0	260	123
TRZECH KUMPLI UNPLUGGED IPA PUSZKA 0,5 L	5904252699522	370	0	370	124
CZTERY ЊCIANY ROSA PUSZKA 0,5 L	5906874341988	244	0	244	125
AMBER GRAND BUT. 0,5 L	5906591000816	243	0	243	126
PIWOTEKA CYTRYNOWYM SKRYTOPIJCOM BUT. 0,5 L	5905669428132	213	0	213	127
JUPILER KEG 6 L	5410228177494	201	0	201	128
ST. MARTIN BLONDE 7% BUT. 0,33 L	5411065403319	230	0	230	129
DEER BEAR YAM YAM PUSZKA 0,5 L	5905204172148	235	0	235	130
KOMES PORTER MALINOWY BUT. 0,5 L	5901687910833	245	0	245	131
RADUGA GAME#2 BUT. 0,5 L	5902176770075	319	0	319	132
DUGGES COLA PUSZKA 0,33 L	7350038224774	238	0	238	133
CHIMAY BLUE BARRIQUE BUT. 0,375 L	5410908002337	211	0	211	134
TRZECH KUMPLI PIECE OF CAKE BUT. 0,5 L PROMOCJA (do 14.10.23)	\N	331	0	331	135
HOEGAARDEN BLANCHE BUT. 0,33 L	5410228141785	399	0	399	136
MOON LARK ARCHES 3.0. WEST COAST DIPA PUSZKA 0,5 L	5905255346482	274	0	274	137
TROUBADOUR MAGMA BUT. 0,33 L	5425006700139	204	0	204	138
FUNKY FLUID THRILLED BLACK IPA PUSZKA 0,5 L	5903999514228	686	0	686	139
PINTA Atak Chmielu 15,0° but. 0,5 l	5904730438605	1978	0	1978	140
MONVIN KRAFKA 0,25 L / 0,5 L	5123456791448	212	0	212	141
CHYLICZKI CYDR SWEET OAK 2019 BUT. 0,5 L	5123456790090	264	0	264	142
RODENBACH ROSSO TAP HANDLE	5123456791378	201	0	201	143
RADUGA MANGOTRIX BUT. 0,5 L	5902176770853	600	0	600	144
PINTA Otwieracz magnes Kwas XY	5904165101600	208	0	208	145
SPECIATION SALTATION BUT. 0,375 L	5123456790109	252	0	252	146
WRКЇEL BUFFALO TRACE BARREL AGED BUT. 0,33 L	5904730465069	216	0	216	147
MAGIC ROAD HOT OR NOT? PUSZKA 0,44 L	5905204130896	264	0	264	148
DZIKI WSCHУD NOLAN PUSZKA 0,5 L	5906874369067	220	0	220	149
ALEBROWAR HERR AXOLOTL WITH APRICOT BUT. 0,5 L	5907771343365	230	0	230	150
MARYENSZTADT WILD & FUNKY CHERRY FLANDERS RED ALE BUT. 0,75 L	5903678022860	208	0	208	151
LINDEMANS T-SHIRT MКSKI SZARY (S)	\N	202	0	202	152
STU MOSTУW ART+66 DOUBLE NEIPA PUSZKA 0,44 L	5907614682941	241	0	241	153
LINDEMANS KUBEK 0,33 L	5123456791151	248	0	248	154
IMBIOROWICZ MIУD PITNY DWУJNIAK PANIEСSKI KAMIONKA 0,70 L	5905669820639	209	0	209	155
ED RED KONSERWA INDYK W SOSIE SEROWO-ZIOЈOWYM	5904083584066	215	0	215	156
CIESZYN SZKLANKA 0,5 L	5123456789850	339	0	339	157
LUPULUS ORGANICUS BUT. 0,33 L	5425025122073	212	0	212	158
ARTEZAN JARDIN DU CHВTEAU PECHE BUT. 0,375 L	5904708750616	300	0	300	159
RADUGA UNEXPECTED GUESTS BUT. 0,5 L PROMOCJA (do 13.09.23)	\N	304	0	304	160
SCHNEIDER LOVE BEER 11,5° BUT. 0,5 L	4003669016692	574	0	574	161
WRКЇEL CHERRY NO.1 BUT. 0,5 L	5904730465977	220	0	220	162
CANTILLON ROSЙ DE GAMBRINUS KEG 20 L	5123456789010	201	0	201	163
MIO MIO COLA BUT. 0,5 L	4002846034368	391	0	391	164
STARA SZKOЈA STARA STODOЈA BUT. 0,5 L	5906874548172	230	0	230	165
FUNKY FLUID FREE GELATO: PINA COLADA PUSZKA 0,5 L	5903999512545	337	0	337	166
ED RED KONSERWA STEK RZEЏNIKA W SOSIE PIEPRZOWYM	5903940086545	210	0	210	167
TRZECH KUMPLI SZKLANKA SHAKER 0,5 L	5123456791266	209	0	209	168
PRAIRIE APRICOT FUNK BUT. 0,5 L	683318988408	219	0	219	169
LUBROW FOREIGN EXTRA STOUT – NITRO CLASSIC ALES PUSZKA 0,33 L	5903686842795	255	0	255	170
FUNKY FLUID STRAWBERRY PUSZKA 0,5 L	5903999514587	247	0	247	171
NEPOMUCEN LOST BUT FOUND PUSZKA 0,5 L	5905701060320	423	0	423	172
BIRBANT HERO% PUSZKA 0,5 L	5903240620944	549	0	549	173
LINDEMANS GUEUZE CUVEE RENE BUT. 0,75 L	5411223020709	239	0	239	174
KOMES IMPERIAL IPA BUT. 0,5 L	5902838990636	244	0	244	175
MOERSLEUTEL 6Y TOM PUSZKA 0,44 L	8720615260508	201	0	201	176
PINTA T-shirt szary duїe logo S	5904165102492	201	0	201	177
TANKBUSTERS ALONE IN SPACE PUSZKA 0,5 L	5904365781053	201	0	201	178
BRUSSELS BEER PROJECT PINARD DE BUT. 0,75 L	5123456788001	225	0	225	179
ALEBROWAR ICED SORRY GRIGORY BUT. 0,25 L	5907771341927	207	0	207	180
LINDEMANS PECHERESSE KEG 20 L	5123456789032	208	0	208	181
DZIKI WSCHУD TYTANOWE JAJO BUT. 0,5 L	5906874369302	260	0	260	182
RACIBORSKIE PYRSK CYTRYNA-KONOPIA BUT. 0,33 L	5905249834094	257	0	257	183
MAREDSOUS 10% TRIPLE BUT. 0,33 L	5411681038001	270	0	270	184
ZA MIASTEM DOBRY NASTRУJ BUT. 0,5 L	5904905630162	421	0	421	185
PINTA Kwas Gamma 13,0° but. 0,5 l	5903990622052	1361	0	1361	186
SCHNEIDER WEISSE BLACHA REKLAMOWA	5123456791345	205	0	205	187
SCHNEIDER TAP06 AVENTINUS 18,5° BUT. 0,5 L	4003669018207	664	0	664	188
BROWARNY BIRIBOMBA PUSZKA 0,5 L	5905450141035	300	0	300	189
HOPUS POKAL 0,33 L	5123456791084	201	0	201	190
DZIKI WSCHУD FREEROKEZ BUT. 0,5 L	5906874369685	275	0	275	191
MOCZYBRODA SUMMERTIME MADNESS BUT. 0,5 L	5904673800996	244	0	244	192
ST. BERNARDUS PRIOR 8 BUT. 0,33 L	54079014	359	0	359	193
ALEBROWAR HOPPY ELEVEN BUT. 0,5 L	5907771340067	285	0	285	194
PINTA Psst... It's Your Weekend IPA - West Coast IPA 15,0° keg 30 l	5123456780039	202	0	202	195
LINDEMANS GINGER GUEUZE BUT. 0,75 L	5411223100036	326	0	326	196
LINDEMANS BEARDY HIPSTER T-SHIRT (L)	5123456791148	201	0	201	197
ROCKMILL BE WILD #2 0 BUT. 0,75 L	5906874027547	210	0	210	198
CIESZYN HIGHLANDER BUT. 0,33 L	5905279156296	206	0	206	199
MALTGARDEN GATE NO 7/2022 PUSZKA 0,33 L	5904050721937	224	0	224	200
STU MOSTУW WRCLW LEKKI BUT. 0,5 L	5907614682118	260	0	260	201
PINTA Koszulka їуіta M	5904165100474	202	0	202	202
MIЈOSЈAW CYDR MIЈOSЈAWSKI PУЈWYTRAWNY BUT. 0,5 L	5901687910505	320	0	320	203
KINGPIN PORTER BAЈTYCKI BUT. 0,5 L	5904730290791	510	0	510	204
PINTA Pierwsza Pomoc 10,5° keg 30 l	5123456789765	242	0	242	205
UNTITLED ART. DBL CHOC BROWNIE PUSZKA 0,354 L PROMOCJA (do 03.10.23)	\N	202	0	202	206
TRZECH KUMPLI PILS KEG 30 L	5123456789499	204	0	204	207
CA`DEL BRADO CUVEE DE ZRISA - CHERRY SOUR ALE BUT. 0,375 L	5123456790123	202	0	202	208
PINTA I'm so Horny! 18,0° keg 30 l	5123456780034	202	0	202	209
TILQUIN OUDE MURE A L’ANCIENNE BUT. 0,75 L	5425029530171	202	0	202	210
ST. MARTIN TRIPLE 9% BUT. 0,33 L	5411065210856	221	0	221	211
SOWIE JASNE PEЈNE BUT. 0,5 L	5907222560082	680	0	680	212
GRYBУW PILSVAR PSZENICZNE BUT. 0,5 L	5902516000589	295	0	295	213
CANTILLON GRAND CRU BRUOCSELLA LAMBIC BIO 2022 BUT. 0,75 L	\N	231	0	231	214
PINTA Kwas Jota 10,5° but. 0,5 l	5904165103048	264	0	264	215
LIMBURGSE WITTE POKAL 0,33 L	5123456789853	274	0	274	216
CANTILLON GUEUZE-LAMBIC KEG 20L	5123456789011	208	0	208	217
ROCKMILL HERMANOS POLACOS PUSZKA 0,5 L	5908291862695	214	0	214	218
LUBROW DOBRE TAKIE TROPIKALNE! PUSZKA 0,33 L	5903686842917	222	0	222	219
RACIBORSKIE BEZALKOHOLOWE ZW BUT. 0,5 L	5907506252504	355	0	355	220
PINTA PORTERMASS Classic 30,0° keg 20 l	5123456789770	201	0	201	221
JURAJSKIE RУЇOWA PANTERA BUT. 0,5 L	5905331026048	387	0	387	222
ZIEMIA OBIECANA AYE! PUSZKA 0,5 L	5905186484642	210	0	210	223
ZA MIASTEM LETNIA PRZYGODA BUT. 0,5 L	5906874605103	299	9	299	224
VEDETT EXTRA ORDINARY IPA BUT. 0,33 L	5411681401775	465	0	465	225
SATAN RED BUT. 0,33 L	5412107000398	211	0	211	226
TRZECH KUMPLI TASSIE KEG 30 L	\N	203	0	203	227
TRZECH KUMPLI BOCK BUT. 0,5 L	5905669479509	245	0	245	228
BIRBANT THE LAST DROP PUSZKA 0,5 L	5904041703805	228	0	228	229
NEPOMUCEN ATO IPA PUSZKA 0,5 L	5905701060030	253	0	253	230
CHIMAY GOLD BUT. 0,33 L	5410908000128	396	0	396	231
SCHNEEEULE WEISSE ROSE BUT. 0,75 L	\N	206	0	206	232
FLYING MONKEYS GINGER BELLE BARREL AGED BUT. 0,473 L	870766000640	225	0	225	233
TRZECH KUMPLI WEIZEN KEG 30 L	5123456789520	202	0	202	235
ST. BERNARDUS EXTRA 4 KEG 20 L	\N	202	0	202	236
O'HARA'S TROPICAL IPA BUT. 0,5 L	5391500602135	235	0	235	237
AUGUSTIJN BLOND BUT. 0,33 L	5411663002181	242	0	242	238
CA' DEL BRADO U BACCABIANCA - ITALIAN GRAPE ALE BUT. 0,375 L	\N	206	0	206	240
P?HJALA PRENZLAUER BERG PUSZKA 0,33 L	4742976013689	222	0	222	241
LUBROW LAGERFEUER PUSZKA 0,33 L	5903686842757	236	0	236	242
ARTEZAN IT'S A FEATURE 2 BUT. 0,33 L	5904708750388	211	0	211	243
BIRBANT CLONY PUSZKA 0,5 L	5904041703652	220	0	220	244
RACIBORSKIE AMERICAN WHEAT LAGER ZW  BUT. 0,5 L	\N	285	0	285	245
SARABANDA BACK TO THE ROOTS PUSZKA 0,5 L PROMOCJA (do 05.10.23)	\N	268	0	268	246
BROKREACJA SAVAGE 001 BUT. 0,5 L	5907610243528	291	0	291	247
LA TRAPPE DUBBEL BUT. 0,75 L	8711406129777	285	0	285	248
JURAJSKIE POMARAСCZA BEZALKOHOLOWE BUT. 0,5 L	5905331026987	672	0	672	249
DZIK CYDR TRAWA CYTRYNOWA 0% BUT. 0,33 L	\N	680	0	680	250
LINDEMANS BLACHA OUD GUEUZE	5123456791141	208	0	208	251
KAZIMIERZ MAGOG BUT. 0,33 L	5906660570639	243	0	243	252
KORMORAN PORTER WARMIСSKI BUT. 0,5 L	5902528420016	234	0	234	253
MARYENSZTADT PROJEKT 30 #5 BUT 0,33 L	5903678022525	221	0	221	254
STAROPOLSKIE BESTBIR MALINA I PIGWA BUT. 0,5 L	5903111989989	397	0	397	255
MAREDSOUS 8% BRUNE BUT. 0,33 L	5411681037004	242	0	242	256
MOON LARK GLOW. AMERICAN PALE ALE PUSZKA 0,5 L	5905255346024	253	0	253	257
MARYENSZTADT YES WE CAN VOL. 4 – MICRO HAZY IPA PUSZKA 0,5 L	5903678022679	227	0	227	258
KORMORAN MIODNE BUT. 0,5 L	5902528431210	257	0	257	259
MAGIC ROAD BEYOND TIME PUSZKA 0,5 L	5905204131244	307	0	307	260
MAGIC ROAD WILD PRETTY #10 RIOJA BARREL AGED PUSZKA 0,33 L	5905204130629	296	0	296	261
ZA MIASTEM PEЈNIA ЇYCIA BUT. 0,5 L	5906874605479	302	0	302	262
LUBROW WC IPA PUSZKA 0,33 L	5900779755123	259	0	259	263
HOPPIN' FROG / TO OL SS STOUT BUT. 0,65 L	665760945994	220	0	220	264
FUNKY FLUID FREE GELATO: MANGO STICKY RICE PUSZKA 0,5 L	5903999514884	280	0	280	265
VAL-DIEU TRIPLE BUT. 0,75 L	5413977000051	263	0	263	266
LUPULUS ORGANICUS BUT. 0,75 L	5425025126002	233	0	233	267
RODENBACH SZKLANKA 0,33 L	5123456791032	216	0	216	268
SCHLENKERLA RAUCHBIER FASTENBIER VINTAGE 2019 BUT. 0,5 L	4037458000166	215	0	215	269
KEG BELGIA A3	5123456792002	225	0	225	270
WRКЇEL CARDINAL BUT. 0,5 L	5904730465120	240	0	240	271
MONVIN APERITIVO SPRITZ KEG 20 L	8013324024449	206	0	206	272
LINDEMANS TACA	5123456791129	247	0	247	273
KEG CZECHY (D) 30 L	\N	243	0	243	274
PRAIRIE VOUS FRANCAIS BUT. 0,75 L	683318988255	207	0	207	275
HOEGAARDEN BLANCHE KEG 20 L	5123456789020	202	0	202	276
KAZIMIERZ LATAJҐCY JELEС BARREL AGED BUT. 0,33 L	5906660570332	240	0	240	277
BLANCHE DE BRUXELLES SZKLANKA 0,33 L	5123456791053	227	0	227	278
PINTA Hazy Discovery Sofia can 0,5 l	5904165105073	830	0	830	279
MALTGARDEN HOW TO SPELL FUN PUSZKA 0,5 L	5907710943830	299	0	299	280
BROWARNY YANGA PUSZKA 0,44 L	5905450141141	300	0	300	281
FUNKY FLUID LEVIATHAN 2022 PUSZKA 0,33 L	5903999510435	251	0	251	282
WRКЇEL SAIL-ON BUT. 0,5 L	5904730465199	205	0	205	283
BROKREACJA COACHMAN'S CALL BUT. 0,5 L	5904422197827	276	0	276	284
ALEBROWAR CHILLED TO THE BONE BUT. 0,5 L	5907771342993	506	5	506	234
NEPOMUCEN APPETIZING PUSZKA 0,5 L	5905701060290	362	0	362	285
LA TRAPPE QUADRUPEL BUT. 0,33 L	8711406022207	411	0	411	286
DZIKI WSCHУD WILD WILD EAST - BLACK WILD ALE BUT. 0,375 L	5906874369890	228	0	228	287
PINTA PARTY STARTER PAK 6 x 0,5 L PUSZKA	5904165103673	210	0	210	288
ST. BERNARDUS WIT PUSZKA 0,33 L	5411911003359	416	0	416	289
LINDEMANS TAROT D'OR KEG 20 L	\N	209	0	209	290
MOON LARK CASUAL. WEST COAST PALE ALE PUSZKA 0,5 L	5905255346468	327	0	327	291
CIESZYN DOUBLE IPA BUT. 0,5 L	5905279156067	490	0	490	292
FUNKY FLUID SPLASH: PINK PUSZKA 0,5 L	5903999513276	467	0	467	293
MARYENSZTADT WHEAT WINE COGNAC B.A. BUT. 0,33 L	5905669542890	229	0	229	294
SOWIE AMPER BUT. 0,5 L	5907222560136	830	0	830	295
BROKREACJA SAVAGE 004 BUT. 0,5 L	5907610243924	244	0	244	296
LEFFE BLONDE KEG 20 L	5123456789017	201	0	201	297
MALTGARDEN GATE NO 5/2021 BUT. 0,5 L	5904050721562	244	0	244	298
MALTGARDEN GATE NO 1/2022 BUT. 0,5 L	5904050721609	215	0	215	299
MOON LARK FREAK ME. NEW ZEALAND PILS 12,0° PUSZKA 0,5 L	5905255346420	240	0	240	300
BIRRA MANIA WIT BIANCA BUT. 0,33 L	5907694918435	204	0	204	301
NEPOMUCEN CHARLOTTE BUT. 0,5 L	5905279959699	248	0	248	302
KAZIMIERZ SPICHLERZ EUROPY BUT. 0,5 L	5906660570158	274	0	274	303
PINTA Psst... It's Your Weekend IPA - West Coast IPA 15,0° but. 0,5 l	5904165104717	246	0	246	304
LINDEMANS TUMBLER 0,25 L	5123456791131	223	0	223	305
CHIMAY RED BUT. 0,75 L	5410908000043	290	0	290	306
BOON OUDE GUEUZE BUT. 0,75 L	5412783052193	314	0	314	307
3 FONTEINEN KRYSZTAЈOWY KIELISZEK 0,33 L	5123456791155	202	0	202	308
PIWNE PODZIEMIE JUICILICIOUS BUT. 0,5 L	5907222444108	252	0	252	309
PINTA Otwieracz magnes Pierwsza Pomoc	5904165101617	203	0	203	310
RECRAFT HAZY APA BUT. 0,5 L	5900779755888	288	0	288	311
LINDEMANS FARO BUT. 0,355 L	5411223101057	328	0	328	312
LERVIG MATA BAROWA	5123456791367	201	0	201	313
PINTA Koszulka HC czarna S	5904165103000	202	0	202	314
RACIBORSKIE RADLER GREJPFRUT BEZALKOHOLOWE ZW BUT. 0,5 L	5907506252528	403	0	403	315
ZAKЈADOWY Z CAЈYM SZACUNKIEM BUT. 0,5 L	5907753172341	228	0	228	316
STU MOSTУW AMERICAN IPA BUT. 0,5 L	5905279213210	300	0	300	317
PINTA Koszulka szara M	5904165101266	202	0	202	318
DE MOLEN OP & TOP BUT. 0,33 L	8717624421020	274	0	274	319
DZIKI WSCHУD WILD WILD EAST - PINEAPPLE TART WILD ALE BUT. 0,375 L	5906874369920	228	0	228	320
PINTA Mata barowa	5903990622434	208	0	208	321
RECRAFT OCEANIA PILS PUSZKA 0,5 L	5900779755895	204	0	204	322
ARTEZAN AND THE PLANETS ARE GOING CRAZY BUT. 0,5 L	5904708750791	265	0	265	323
VAL-DIEU BIERE DE NOЛL BUT. 0,75 L	5413977000259	238	0	238	324
DELIRIUM RED KEG 30 L	\N	201	0	201	325
SCHLENKERLA SZKLANKA 0,25 L	5123456791247	227	0	227	326
FUNKY FLUID SASSY PUSZKA 0,5 L	5903999513696	205	0	205	327
PINTA Їytorillo 14,0° but. 0,5 l	5904165103543	1168	0	1168	328
POKAL DUBBEL CIESZYСSKI 0,4 L	5123456791316	357	0	357	329
DZIKI WSCHУD HASTIIN PUSZKA 0,5 L	5906874369524	255	0	255	330
BROKREACJA POTION #22 BUT. 0,33 L	5904422197582	239	0	239	331
DEER BEAR KOMPOT #2 PUSZKA 0,5 L	5905204172162	259	0	259	332
RECRAFT BLACK CURRIS BUT. 0,33 L	5900779755086	1047	0	1047	333
CZTERY ЊCIANY KAMPER BUT. 0,5 L	5906874341117	320	0	320	334
FUNKY FLUID MY CUP OF TEA PUSZKA 0,5 L	5903999514570	564	0	564	335
REVOLTA ROOIBOS PEAR MELON AIPA BUT. 0,5 L	5900470079009	300	0	300	336
NEPOMUCEN NEPO FINEST – GOLDEN HIND BUT. 0,375 L	5905191386610	221	0	221	337
SCHLENKERLA SZKLANKA 0,5 L	5123456791248	216	0	216	338
LINDEMANS PECHERESSE MEDALION RYBIE OKO	\N	201	0	201	339
TRZECH KUMPLI PAN IPANI DOUBLE PUSZKA 0,5 L	5904252699256	366	0	366	340
PINTA BARREL BREWING TEMPLE 12,0° BUT. 0,375 L	5904335577525	243	0	243	341
ZA MIASTEM DZIEС DOBRY BUT. 0,5 L	5906874605288	372	0	372	342
KEG CZECHY (B) 30 L	\N	210	0	210	343
DEER BEAR TOY BOY PUSZKA 0,5 L	5903678460563	430	0	430	344
FORTUNA MIRABELKA BUT. 0,5 L	5901687910291	309	0	309	345
DE LA SENNE POKAL 0,33 L	5123456791098	298	0	298	346
JURAJSKIE KWAS PRUSKI BUT. 0,5 L	5905331025607	574	0	574	347
PINTA Dobry Wieczуr 13,0° can 0,5 l PROMOCJA (do 20.11.23)	\N	771	0	771	348
TRZECH KUMPLI QUADRUPEL BUT. 0,33 L	5905669479677	243	0	243	349
PINTA Bluza czarna XL	5904165100542	202	0	202	350
ST. BERNARDUS CHRISTMAS ALE BUT. 0,33 L	5411911001768	416	0	416	351
MOERSLEUTEL MUSCOVADO MAPLE MAGICIAN PUSZKA 0,44 L	8719992492763	201	0	201	352
SCHLENKERLA POKAL EICHE 0,4 L	5123456791246	211	0	211	353
SCHLENKERLA TABLICA REKLAMOWA	5123456791340	216	0	216	354
ST. BERNARDUS TRIPEL BUT. 0,33 L	54079038	338	0	338	355
BUTELKA ZWR SVIJANY 0,5 L	\N	705	0	705	356
SCHNEEEULE YASMIN KEG 20 L	\N	201	0	201	357
LINDEMANS TAROT NOIR KEG 20 L	\N	216	0	216	358
ACHEL BRUIN 8% BUT. 0,33 L	5425007658880	239	0	239	359
DUGGES BIG BLACK APPLE PUSZKA 0,5 L	7350038226372	215	0	215	360
MAGIC ROAD FREE PRETTY KIWI, PEAR, PEACH & SWEET ROLL PUSZKA 0,5 L	5905204130926	230	0	230	361
STARA SZKOЈA KOLENDRA BUT. 0,5 L	5906874548059	280	0	280	362
ALEBROWAR HERR AXOLOTL WITH GRAPEFRUIT BUT. 0,5 L	5907771343457	595	0	595	363
FUNKY FLUID GUMMY: PINK PUSZKA 0,5 L PROMOCJA (do 06.10.23)	\N	484	0	484	364
STAROPOLSKIE CHMIELNE BUT. 0,5 L	5903111989873	286	0	286	365
STAROPOLSKIE NIEMDЈE PSZENICZNE BUT. 0,5 L	5903021503343	305	0	305	366
CA' DEL BRADO ANNIVERSARIO 2020 BUT. 0,375 L	5123456790119	207	0	207	367
MARYENSZTADT BARREL AGED ICE BRETT PORTER DOUBLE BA - BIAЈA CZEKOLADA I PRAЇONY ORZECH PUSZKA 0,44 L	5903678022075	221	0	221	368
PINTA Otwieracz magnes Beskidy	5903990622588	209	0	209	369
PETRUS BORDEAUX TAP HANDLE	5123456791374	201	0	201	370
INNE BECZKI CHERRY ELEPHANT BUT. 0,5 L	5905669683258	1022	0	1022	371
SCHLENKERLA RAUCHBIER WEIZEN 13,2° BUT. 0,5 L	4037458000159	561	0	561	372
PINTA A'la Grodzisz 7,8° but. 0,5 l	5904165104311	335	0	335	373
RECRAFT JUICY SOUR SERIES – GRAVIOLA X LIMONKA PUSZKA 0,5 L	5900779755932	283	6	283	374
PINTA Bluza czarna S	5904165100511	202	0	202	375
PIWNE PODZIEMIE CHMIELOKRATA CASHMERE KEG 30 L	\N	201	0	201	376
STU MOSTУW WRCLW PILS BUT. 0,5 L	5907614680473	265	0	265	377
GRIMBERGEN DOUBLE BUT. 0,33 L	5410263010664	362	0	362	378
SOWIE MIODOWE BUT. 0,5 L	5907222560181	211	0	211	379
SMYKAN CYDR KWAЊNY ZDZICHU BUT. 0,5 L	5905669332170	227	0	227	380
DUGGES TROPIC THUNDER PUSZKA 0,33 L	7350038224903	235	0	235	381
LINDEMANS METALOWE PUDEЈKO PREZENTOWE	5123456791126	203	0	203	382
GRYFUS GRINGO AT SUNRISE PUSZKA 0,5 L	5900779755833	295	0	295	383
STU MOSTУW CHOCOLATE STOUT NITRO BUT. 0,5 L	5907614680275	325	0	325	384
GRODZISKIE PIWOBRANIOWE 2023 BUT. 0,5 L	5905279533714	299	0	299	385
TRZECH KUMPLI TAURA BUT. 0,5 L	5905669479493	230	0	230	386
PETRUS TRIPEL BUT. 0,75 L	875213000099	209	0	209	387
MALTGARDEN GATE NO 8/2022 PUSZKA 0,33 L	5904050721944	224	0	224	388
SCHNEEEULE WILDER BILLY SALAT CONTROL W. FUERST WIACEK BUT. 0,75 L	\N	204	0	204	389
CHIMAY GOLD BUT. 0,75 L	5410908000425	356	0	356	390
FUNKY FLUID CLASSY PUSZKA 0,5 L	5903999514785	400	0	400	391
LEFFE BRUNE BUT. 0,33 L	5410228146162	684	0	684	392
RACIBORSKIE ZESTAW BARLEY WINE + IMPERIAL PORTER + SZKЈO DEGUSTACYJNE	5905249834025	211	0	211	393
RACIBORSKIE BEZALKOHOLOWE BUT. 0,5 L	5907506252504	220	0	220	394
CORSENDONK ZESTAW  (2 X BUT. 0,33 L + SZKЈO)	5411491001899	201	0	201	395
NEPOMUCEN SQUASH PUSZKA 0,5 L	5905191386955	201	0	201	396
MOCZYBRODA BREWTOPIA PUSZKA 0,5 L	5904673800828	235	0	235	397
ST. FEUILLIEN GRAND CRU BUT. 0,75 L PROMOCJA (do 04.10.23)	\N	213	0	213	398
MIKKELLER CHERRY FREDERIKSDAL DOUBLEBOCK 2019 BUT. 0,375 L	5704255119238	217	0	217	399
P?HJALA COSY NIGHTS KEG 20 L	5123456789914	201	0	201	400
P?HJALA - MIKKELLER SEA FOG PUSZKA 0,33 L	4742976015201	215	0	215	401
TRZECH KUMPLI HOPPY WEIZEN BUT. 0,5 L	5904252699546	502	0	502	402
KORMORAN ЊWIEЇE BUT. 0,5 L	5902528001093	382	0	382	403
P?HJALA SATURNUS PUSZKA 0,44 L	4742976015911	216	0	216	404
THE BRUERY SHARE THIS: MINT CHIP BUT. 0,75 L	19962362057	226	0	226	405
PINTA Szklanka Weizen 2021 0,5 l	5904165100696	269	0	269	406
KOMES POCZWУRNY BUT. 0,5 L	5901687910208	215	0	215	407
FUNKY FLUID BLACK CURRANT SOUR BUT. 0,5 L	5906395560349	744	0	744	408
KASTEEL ROUGE KEG 20 L	\N	203	0	203	409
3 FONTEINEN FRAMBOOS OOGST 2019 BUT. 0,375 L	5425007818338	216	0	216	410
ZAKЈADOWY PIERWSZA ZMIANA BUT. 0,5 L	5906395388004	220	0	220	411
BOON KRIEK KEG 20 L	\N	206	0	206	412
PINTA Double Delivery 18,0° keg 30 l	5123456780045	212	0	212	413
BROKREACJA MEET THE BARREL #1 - PURE OAK BUT. 0,33 L	5907610243979	202	0	202	414
BACCHUS GRAAL SZKLANKA 0,25 L	5123456791335	212	0	212	415
IMBIOROWICZ MIУD PITNY TRУJNIAK AIRONIA BUT. 0,75 L	5905669820257	205	0	205	416
GRISETTE POKAL 0,25 L	5123456791089	202	0	202	417
SCHNEIDER WEISSE AVENTINUS SZKLANKA 0,3 L	5123456791253	202	0	202	418
THE BRUERY JARDINIER BUT. 0,75 L	705105538457	230	0	230	419
KASTEEL BARISTA CHOCOLATE QUAD BUT. 0,33 L	5411081005696	207	0	207	420
MIЈOSЈAW & MAKЈOWICZ ARCY APA BUT. 0,5 L	5902838991435	484	0	484	421
DE LA SENNE SAISON BUT. 0,33 L	5425029020832	270	0	270	422
CUVEE DES TROLLS TRIPLE BUT. 0,75 L	5411551210513	203	0	203	423
ARTEZAN DODO BUT. 0,5 L - PROMOCJA	\N	625	0	625	424
MALTGARDEN WHERE ARE MY GOGGLES? PUSZKA 0,5 L	5907710943304	413	0	413	425
ZAKЈADOWY KINO KOSMOS BUT. 0,5 L	5907753170286	243	0	243	426
MAGIC ROAD PERFECT LUNCH PUSZKA 0,44 L	5905204130988	259	0	259	427
SCHLENKERLA RAUCHBIER EICHE VINTAGE 2017 19,9° BUT. 0,5 L	\N	224	0	224	429
ZA MIASTEM DOBRA NOC BUT. 0,5 L	5906874605059	240	0	240	430
IMBIOROWICZ MIУD PITNY TRУJNIAK AIRONIA BUT. 0,375 L	5905669820264	211	0	211	431
DEER BEAR SZKLANKA SHAKER 0,5 L	5123456791452	207	0	207	432
MARYENSZTADT SOURTIME MANGO-POMARAСCZA-MARAKUJA BUT. 0,5 L	5905669542005	257	0	257	433
WIDAWA SHARK BUT. 0,5 L	5907710904046	403	0	403	434
3 FONTEINEN OUDE KRIEK VAT BUT. 0,375 L	5425007810813	205	0	205	435
WRКЇEL MALTIC STORM HEAVEN HILL BUT. 0,5 L	5904181970297	284	0	284	436
PIWNE PODZIEMIE KRAKEN OF DOOM BUT. 0,33 L	5904305482583	230	0	230	437
ЈAСCUT ACIDUM FRUCTUS BUT. 0,5 L	5906395997886	201	0	201	438
MIKKELLER SPONTAN PASSION FRUIT BUT. 0,375 L	818534018732	212	0	212	439
KEG BELGIA A5	5123456792003	248	0	248	440
BЈONIE ZASIALI GУRALE BUT. 0,5 L	5908258856095	855	0	855	441
LIMBURGSE WITTE LEMON KEG 20 L	\N	201	0	201	442
THE BRUERY / FUNKY BUDDHA !GUAVA LIBRE! BUT. 0,75 L	653341008428	219	0	219	443
MIKKELLER SPONTAN PEACH BUT. 0,375 L	5704255117982	227	0	227	444
CHYLICZKI CYDR Z ODMIANY CHOPIN KEG 30 L	5123456789027	204	0	204	445
PINTA Barrel Brewing Scarlet but. 0,375 l	5904335577549	232	0	232	446
PINTA Upgrade Your September 12,0° can 0,5 l	5904165105158	218	0	218	447
MOCZYBRODA BRAIN SMASHER BUT 0,5 L	5903351761741	194	-18	194	448
SANTE ADAIRIUS FOUR LEGS GOOD BUT. 0,75 L	5123456790148	212	0	212	449
ZA MIASTEM 5TH ELEMENT AMERICAN PALE ALE BUT. 0,5 L	5904905630186	765	0	765	450
STONE ENJOY AFTER 7.4.16 BUT. 0,75 L	636251772108	220	0	220	451
HOEGAARDEN GRAND CRU BUT. 0,33 L	5410228141921	254	0	254	452
DE MOLEN DAG & DAUW BUT. 0,33 L	8717624423215	292	0	292	453
STONE T-SHIRT CZARNY (XXL)	5123456791054	201	0	201	454
3 FONTEINEN KRYSZTAЈOWY KIELISZEK 0,645 L	5123456791153	201	0	201	455
MIKKELLER RUNNING CLUB SPODNIE CZARNE (L)	5123456791116	202	0	202	456
SCHNEEEULE OTTO BUT. 0,75 L	\N	206	0	206	457
STU MOSTУW RODZINA - VILD BUT. 0,375 L	7390305201299	205	0	205	458
MAGIC ROAD KIWI? KIWI! PUSZKA 0,5 L	5905204130940	218	0	218	459
TRZECH KUMPLI RAUCHDOPPELBOCK KEG 20 L	5123456789504	201	0	201	460
LINDEMANS FARO TAP HANDLE	5123456791016	202	0	202	461
ZA MIASTEM DOBRZE JEST BUT. 0,5 L	5906874605417	308	0	308	462
BROKREACJA LUDZIE TRZYMAJCIE KAPELUSZE WILD TURKEY BOURBON B.A. BUT. 0,33 L	5904422197001	211	0	211	463
DRY & BITTER CZAPKA ZIMOWA ZIELONA	5123456791356	202	0	202	464
PINTA Koszulka biaіa XL	5904165100443	202	0	202	465
CHIMAY KIELICH 0,33 L	5123456791189	678	0	678	466
FUNKY FLUID YUZUALLY PUSZKA 0,5 L	5903999513764	471	0	471	467
MARYENSZTADT NEW WAVE PILS BUT. 0,5 L	5905669542968	284	0	284	468
BROKREACJA FOWL QUEEN PUSZKA 0,5 L	5904422197797	479	0	479	469
KORMORAN KRZEPKIE BUT. 0,5 L	5902528573354	242	0	242	470
SCHNEIDER WEISSE KUFEL CERAMIKA WYSOKI 0,5 L	5123456791325	270	0	270	471
SCHLENKERLA RAUCHBIER EICHE VINTAGE 2015 19,9° BUT. 0,5 L	5123456790103	213	0	213	472
TRZECH KUMPLI NESTA BUT. 0,5 L	5904252699027	294	0	294	473
TRZECH KUMPLI UNPLUGGED IPA BUT. 0,33 L	5904252699768	305	0	305	474
SOWIE GRAPER BUT. 0,5 L PROMOCJA (do 04.10.23)	\N	287	0	287	475
MALHEUR 12% BUT. 0,33 L	5413970140396	290	0	290	476
ZAKЈADOWY WRУBEL W GARЊCI BUT. 0,5 L	5907753172327	275	0	275	477
MALTGARDEN TRUNK FULL OF FRUITS BUT. 0,5 L	5904050721838	212	0	212	478
PINTA Atak Chmielu 15,0° keg 20 l	5123456789661	206	0	206	479
STAROPOLSKIE BESTBIR TRUSKAWKA BUT. 0,5 L	5903021501097	273	0	273	480
ST. LOUIS PREMIUM GUEUZE BUT. 0,25 L	5411081000233	255	0	255	481
ST. BERNARDUS CHRISTMAS ALE KEG 20 L	5123456789438	210	0	210	482
MALTGARDEN NEWS DAILY PUSZKA 0,5 L	5904050721869	208	0	208	483
PINTA Koszulka szara S	5904165101259	202	0	202	484
LINDEMANS FRAMBOISE MEDALION RYBIE OKO	\N	201	0	201	485
JAN OLBRACHT LEGENDY POLSKIE: CZART BUT. 0,33 L	5902627012235	241	0	241	486
PINTA Kwas Jota 10,5° keg 20 l	5123456789728	202	0	202	487
PINTA Barrel Brewing Grandeur but. 0,33 l	5904335577341	221	0	221	488
STAROPOLSKIE THE ART OF HOPPING AFRICAN SOUL SINGLE HOP IPA BUT. 0,5 L	5903021504913	253	0	253	489
ZA MIASTEM PEЈNIA SZCZКЊCIA BUT. 0,5 L	5904905630124	265	0	265	490
MARYENSZTADT GWIAZDA PУЈNOCY BUT. 0,33 L	5905669542708	231	0	231	491
LUBROW POLSKA GUROM 2.0 PUSZKA 0,33 L	5903686842825	220	0	220	492
DWIE WIEЇE FLANDERS FA + BA BUT. 0,33 L PROMOCJA (do 30.09.23)	\N	211	0	211	493
ALEBROWAR HERR AXOLOTL WITH LOTUS & ENIGMA BUT. 0,5 L	5907771343723	255	0	255	494
PRZETWУRNIA CHMIELU DROBINKA #4 PUSZKA 0,5 L	5905476980571	251	0	251	495
SMYKAN CYDR GROCHУWKA BUT. 0,75 L	5905669332033	211	0	211	496
NEPOMUCEN BIRDLAND PUSZKA 0,5 L	5905701060047	257	0	257	497
GWAREK ZERO MATES LIQUID YELLOW BUT. 0,5 L	5903938751738	290	0	290	498
STAROPOLSKIE PRL PIWO PEЈNE 0,5 L	5905669086240	274	0	274	499
KORMORAN COPERNIKUS TUBA BUT. 0,5 L	5902528208584	220	0	220	500
PIWNE PODZIEMIE DR. HAZY #1 PUSZKA 0,5 L	5904305482835	317	0	317	501
OUD BEERSEL BERSALIS TRIPEL OAK AGED BUT. 0,375 L	5425018070763	217	0	217	502
PALATUM AQUA IMPERIALE PUSZKA 0,5 L	5905159520100	209	0	209	503
PINTA Beskidy APA 12,0° keg 20 l	5123456789669	202	0	202	504
HOLBA ЉERБK 11° KEG 30 L	\N	203	0	203	505
PIWOTEKA DOBRE BO ЈУDZKIE BUT. 0,5 L	5905669428224	263	0	263	506
LUBROW BERLIBERRY PUSZKA 0,33 L	5903686842894	307	0	307	507
PIWNE PODZIEMIE EXOTICA KEG 30 L	\N	201	0	201	508
PINTA Barrel Brewing Scarlet but. 0,75 l	5904335577556	203	0	203	509
HOPPIN' FROG / SIREN 5-ALARM CHILI BEER: AMERICAN STYLE BUT. 0,65 L	665760945901	202	0	202	510
ST. BERNARDUS ABT 12 BUT. 0,75 L	5411911000310	259	0	259	511
ZA MIASTEM CHWILA ODDECHU BUT. 0,5 L	5904905630209	950	0	950	512
MAGIC ROAD CHERRY GIVEAWAY PUSZKA 0,5 L PROMOCJA (do 30.09.23)	\N	266	0	266	513
CHIMAY TRIPLE BUT. 0,75 L	5410908000135	273	0	273	514
BIRBANT CATALITYC PUSZKA 0,5 L	5904041703607	225	0	225	515
PRZETWУRNIA CHMIELU SЈOMKA PUSZKA 0,5 L	5905476980311	323	0	323	516
MATE - MATE BUT. 0,5 L	4260310557410	218	0	218	517
MARYENSZTADT RIGHT NOW BUT. 0,5 L	5905669542173	244	0	244	518
ALEBROWAR HOODED BLACK BARLEY BUT. 0,33 L	5907771343495	245	0	245	520
AMBER IPA PUSZKA 0,5 L	5906591002971	257	0	257	521
REVOLTA EARL GREY AIPA BUT. 0,5 L	5900470050008	296	6	296	522
FUNKY FLUID EVERYDAY BUT. 0,5 L	5906395560240	494	14	494	523
MIKKELLER BAGHAVEN: REFSAESOEN ABRIKOS BUT. 0,75 L	732003233542	213	0	213	524
STAROPOLSKIE BESTBIR GRUSZKA I MELISA BUT. 0,5 L	5905669086141	497	0	497	525
FUNKY FLUID GELATO: ROSSO PUSZKA 0,5 L	5903999514365	225	0	225	526
ROCHEFORT TRAPPISTES 6* BUT. 0,33 L	5412858000067	427	0	427	527
TRZECH KUMPLI W STYLU GRODZISKIE Z GRILOWANYMI CYTRYNAMI PUSZKA 0,5 L	5904252699218	417	0	417	528
KORMORAN 1 NA 100 PIGWOWIEC + MIУD BUT. 0,5 L	5902528523311	353	0	353	529
STRUISE BLACK DAMNATION IX - BEGGARS' ART BUT. 0,33 L	5425017666097	211	0	211	530
FUNKY FLUID FUSION: MOON LARK PUSZKA 0,5 L	5903999514181	642	0	642	531
PETRUS AGED PALE TAP HANDLE	5123456791373	201	0	201	532
P?HJALA STRUDEL STOUT KEG 20 L	\N	201	0	201	533
BIRBANT DELUSION PUSZKA 0,5 L	5904041703720	237	0	237	534
SZRENIAWA PEATED BROWN ALE BUT. 0,33 L	5903857178395	227	0	227	535
INNE BECZKI SWEATER WHEATER PUSZKA 0,5 L	5903661281786	229	0	229	537
DELIRIUM ARGENTUM BUT. 0,75 L	5412186003600	210	0	210	538
PIWOTEKA SZTUKA ETRUSKA BUT. 0,5 L	5905669428064	269	0	269	539
NEPOMUCEN FULL OPEN CRAFT PUSZKA 0,5 L	5905701060269	292	0	292	540
FUNKY FLUID GELATO: YELLOW FLUFF PUSZKA 0,5 L	5903999514389	216	0	216	541
KASTEEL POKAL 0,33 L	5123456791082	296	0	296	542
BACCHUS BUT. 0,375 L	5411081004736	268	0	268	543
PIRAAT TRIPLE HOP BUT. 0,33 L	5411663004772	231	0	231	544
MOON LARK / PINTA STAY HERE #3 14,0° CAN 0,5 L	5905255346512	683	0	683	545
DUVEL MATA BAROWA	5123456791202	204	0	204	546
LOCO ENERGY LEMON BUT. 0,33 L	5907694918381	202	0	202	547
WRКЇEL MEXICO TRIP: PART TWO BUT. 0,5 L	5904181970471	215	0	215	548
WIDAWA FRUIT BOMB BUT. 0,5 L	5907710904060	208	0	208	549
ZULI STURNUS TRУJNIAK WIЊNIOWY BUT. 0,7 L	5904933314263	221	0	221	550
BOSTEELS TRIPEL KARMELIET POKAL 0,33 L	5123456791063	277	0	277	551
NEPOMUCEN JOSE BUT. 0,5 L	5905279959712	378	0	378	552
NEPOMUCEN PIJЇE BUT. 0,5 L	5905279959972	456	0	456	554
TARNOBRZEG GANGSTAR BUT. 0,5 L	5903661867768	405	0	405	555
LEFFE BRUNE BUT. 0,75 L	5410228145226	249	0	249	556
PINTA Kubek plastikowy Eco 0,5 l	5904165103123	272	0	272	557
PINTA Party Starter Session IPA 12,0° keg 30 l	5123456780016	216	0	216	558
BROKREACJA THE BARBER BUT. 0,5 L	5905669783644	263	0	263	559
DZIKI WSCHУD ISKA PUSZKA 0,5 L	\N	230	0	230	560
SCHLENKERLA RAUCHBIER KRAUSEN 11,5° BUT. 0,5 L	4037458000173	354	0	354	561
DE MOLEN HEEN & WEER BUT. 0,33 L	8717624421242	270	0	270	562
PINTA Party'23 Collab 12,0° can 0,5 l	5904165105011	795	0	795	563
PRZETWУRNIA CHMIELU PRZECIER PUSZKA 0,5 L PROMOCJA (DO 24.10.23)	\N	204	0	204	564
PINTA Sangriale 15,0° but. 0,5 l	5904165103703	271	0	271	565
P?HJALA HELGE PUSZKA 0,33 L	4742976013535	224	0	224	566
ED RED KONSERWA MASSAMAN CURRY Z KURCZAKIEM	59040835841037	210	0	210	567
KASTEEL ROUGE PUSZKA 0,5 L	5411081006112	228	9	228	519
PIWNE PODZIEMIE KRAUTROCK BUT. 0,5 L	5904305482767	216	0	216	568
DUVEL BUT. 0,75 L	5411681402635	569	0	569	569
LIMBURGSE WITTE MATA BAROWA	5123456791349	205	0	205	570
PIWNE PODRУЇE PORTERRA NOVA BUT. 0,5 L	5907222560020	318	0	318	571
GWAREK ONYX PUSZKA 0,5 L	5903938751523	365	0	365	572
WIEZE TRIPEL BUT. 0,33 L	5425036510012	227	0	227	573
BROKREACJA THE DEALER BUT. 0,5 L	5905669783255	257	0	257	574
MALTGARDEN GATE NO 4/2021 BUT. 0,5 L	5904050721555	237	0	237	575
NEPOMUCEN KIND OF MAGIC PUSZKA 0,5 L	5905191386573	202	0	202	576
ZAKЈADOWY GOЈҐB NA DACHU BUT. 0,5 L	5907753172334	244	0	244	577
SCHLENKERLA RAUCHBIER WEICHSEL ROTBIER BUT. 0,5 L	4037458000197	264	0	264	578
PINTA Oto mata IPA 14,0° but. 0,5 l	5908252864300	975	0	975	579
PINTA RISFACTOR Cocoa Nibs and Roasted Peanuts 30,0° keg 10 l	5123456780017	201	0	201	580
BOON OUDE GUEUZE BLACK LABEL N*8 BUT. 0,75 L	5412783152787	254	0	254	581
DZIK CYDR GRUSZKA KEG 30 L	5906395413072	219	0	219	582
KORMORAN TERRA DONUM BRAGGOT BUT. 0,375 L	5902528000447	227	0	227	583
MIKKELLER PUMA BOKSERKA SPORTOWA NIEBIESKA (L)	5123456791123	206	0	206	584
RACIBORSKIE PYRSK JABЈKO-PIGWOWIEC BUT. 0,33 L	5905249834087	282	0	282	585
VAL-DIEU BIERE DE NOЛL BUT. 0,33 L	5413977000044	269	0	269	586
DU BOCQ BLANCHE DE NAMUR ZESTAW (3 X BUT. 0,33 L + SZKЈO)	5411633333017	204	0	204	587
CHYLICZKI CYDR ROSE 2021 BUT. 0,75 L	5905279058187	237	0	237	589
ЈAСCUT DZIKI RYE BUT. 0,5 L	5906395997954	292	0	292	590
NEPOMUCEN ACIDO BUT. 0,5 L	5905279959637	410	0	410	591
CZTERY ЊCIANY TROPIK DOUBLE PUSZKA 0,5 L	5906874341780	212	0	212	592
STU MOSTУW ART+67 DDH PALE ALE PUSZKA 0,44 L	5907614682972	261	0	261	593
STAROPOLSKIE PORTER CHERRY BUT. 0,5 L	5903021503275	269	0	269	594
P?HJALA ЦЦ KEG 20L	5123456789915	203	0	203	595
PINTA Pils Time 12,0° keg 30 l	\N	202	0	202	596
KINGPIN PLUSH PUSZKA 0,5 L	5904730290418	208	0	208	597
BROWAR JANA PSZENICZNE BUT. 0,5 L	5902429980015	380	0	380	598
TRYBUNAЈ ZERO BUT. 0,5 L	5905689311377	500	0	500	599
PINTA T-shirt szary duїe logo XL	5904165102522	202	0	202	600
STAROPOLSKIE MIODNE BUT. 0,5 L	5903111989835	213	0	213	601
STONE TAP HANDLE	5123456791011	213	0	213	602
GRIMBERGEN FENIKS POKAL 0,33 L	5123456791090	239	0	239	603
PINTA A ja Pale Ale 12,0° but. 0,5 l	5904730438582	1151	0	1151	604
ALMANAC SOUR IPA BUT. 0,375 L	748252022707	212	0	212	605
MAGIC ROAD BORN TO BE JUICY LIMITED EDITION BUT. 0,33 L	5905204130445	232	0	232	606
AMAGER / DБDIVA VIEWPOINT COCO BUT. 0,33 L	5704603303012	224	0	224	607
MAGIC ROAD HAPPY BIRTHDAY PRZYSTANEK BEMOWO PUSZKA 0,5 L	5905204130995	231	0	231	608
SCHLENKERLA SZKLANKA URBOCK 0,5 L	5123456791329	226	0	226	609
MIKKELLER CHERRY FREDERIKSDAL TRIPELBOCK 2019 BUT. 0,375 L	5704255119221	221	0	221	610
MAGIC ROAD WICKED PUSZKA 0,5 L	5905204130841	208	0	208	611
PIWNE PODZIEMIE PHANTASTIC DAY PUSZKA 0,5 L	5904305482842	220	0	220	612
ЈAСCUT PSZEPAN BUT. 0,5 L	5906395997220	565	0	565	613
INNE BECZKI EL ALMANTE PUSZKA 0,5 L	5903661281540	295	0	295	614
CANTILLON LAMBIC KEG 20L	5123456789018	201	0	201	615
CANTILLON KRIEK-LAMBIC BIO 2022 BUT. 0,75 L	5411024000023	240	0	240	616
ST. FEUILLIEN SAISON BUT. 0,33 L	5412138333311	256	0	256	617
RODENBACH KEG 20 L PROMOCJA (do 17.09.23)	\N	205	0	205	618
WRКЇEL MANGOVE BUT. 0,5 L	5904730465304	255	0	255	619
RACIBORSKIE RADLER GREJPFRUT BEZALKOHOLOWE BUT. 0,5 L	5907506252528	289	0	289	620
SVIJANY SZKLANKA 0,5 L	\N	272	0	272	621
CHYLICZKI CYDR STARY SAD EDYCJA LIMITOWANA BUT. 0,75 L	5905279058279	225	0	225	622
LITOVEL ИERNY CITRON NON-ALCO BUT. 0,5 L	8593875518210	218	0	218	623
SMYKAN CYDR LODOWY GROCHУWKA BUT. 0,375 L	5905669332163	231	0	231	624
GOЊCISZEWO GУROЈAZ BUT. 0,5 L	5903364108984	247	0	247	625
STU MOSTУW ART+70 PUSZKA 0,44 L	5907614683221	278	0	278	626
DZIKI WSCHУD TYTANOWA CZACHA BUT. 0,5 L	5906874369630	220	0	220	627
O'HARA'S IRISH RED NITRO K-KEG 30 L	5391500601343	206	0	206	628
WIDAWA SIMCOE PILS BUT. 0,5 L	5907710904220	241	0	241	629
MIЈOSЈAW PILZNER BUT. 0,5 L	5902709615323	227	0	227	630
DZIKI WSCHУD SAMOTNY JEЏDZIEC BUT. 0,5 L	5906874369876	283	0	283	631
CIESZYN ANGIELSKI LORD BUT. 0,33 L	5907612240198	233	0	233	632
MARYENSZTADT KLASYCZNIE IPA BUT. 0,5 L	5903678022891	240	0	240	633
ST. BERNARDUS TABLICA REKLAMOWA	5123456791382	202	0	202	634
PINTA Beskidy APA 12,0° keg 30 l	5123456789670	205	0	205	635
STAROPOLSKIE KULTOWE BEZ GLUTENU BUT. 0,5 L	5905669086943	255	0	255	636
ARTEZAN JARDIN DU CHВTEAU FRAISE BUT. 0,375 L	5904708750623	306	0	306	637
STONE XOCOVEZA EXTRA ANEJO 2015 BUT. 0,5 L	636251740619	238	0	238	638
CHYLICZKI CYDR CZARNY SAD BUT. 0,5 L	5905279058194	334	0	334	639
SCHNEIDER WEISSE POKAL SOMMELIER 0,2 L	5123456791256	207	0	207	640
TRZECH KUMPLI MISTY BUT. 0,5 L	5905669479189	304	0	304	641
PINTA RISFACTOR Cocoa Nibs and Coconut 30,0° but. 0,33 l	5904165102263	243	0	243	642
PINTA Barrel Brewing Memory but. 0,33 l	5904335577419	497	0	497	643
PINTA Hazy Delivery 15,0° but. 0,5 l	5904165103741	1820	0	1820	644
BOON OUDE KRIEK BUT. 0,75 L	5412783053879	211	0	211	645
BROKREACJA MEET THE BARREL #5 – RYE GIN BUT. 0,33 L	5904422197407	221	0	221	646
CZTERY ЊCIANY MURAWA PUSZKA 0,5 L	5905108498221	201	0	201	647
KASTEEL BARISTA CHOCOLATE QUAD KEG 20 L	5123456789882	202	0	202	648
PRZETWУRNIA CHMIELU MUS PUSZKA 0,5 L	5905476980540	242	0	242	649
MAGIC ROAD PRETTY CHERRY, CRANBERRY, BLACKBERRY & ALMONDS PUSZKA 0,5 L	5905204130810	206	0	206	650
DE MOLEN BLACHA REKLAMOWA	5123456791209	203	0	203	651
STAROPOLSKIE ZЈOTY POTRУJNIE GRYCZANE BUT. 0,5 L	5905669086264	235	0	235	652
MARYENSZTADT IMPERIAL BALTIC PORTER HEAVEN HILL KENTUCKY STRAIGHT BURBON WHISKEY B.A. BUT. 0,33 L	5903424615742	230	0	230	653
LINDEMANS TAROT NOIR MEDALION RYBIE OKO	\N	201	0	201	654
ALEBROWAR ICE PASTRY MASTER BUT. 0,25 L	5907771341088	212	0	212	655
FUNKY FLUID CHERRY PUSZKA 0,5 L	5903999514068	1389	0	1389	656
FLORIS APPLE BUT. 0,33 L	5412186001095	221	0	221	657
PINTA Kartonik a4	5123456791292	270	0	270	658
ALEBROWAR HERR AXOLOTL WITH APPLE & LIME BUT. 0,5 L	5907771340074	249	0	249	659
LITOVEL PREMIUM 12° BZW. BUT. 0,5 L	8593875510115	539	0	539	660
ST. LOUIS PREMIUM FRAMBOISE BUT. 0,25 L	5411081000264	249	0	249	661
DELIRIUM TREMENS KEG 30 L	5123456789027	201	0	201	662
ST. HUBERTUS TRIPLE BLONDE BUT. 0,33 L	5413982600000	215	0	215	663
ST. FEUILLIEN CUVЙE DE NOEL BUT. 0,75 L	5412138307510	236	0	236	664
BROKREACJA POTION #24 BUT. 0,33 L	5904422197780	248	0	248	665
RACIBORSKIE AMERICAN IPA ZW BUT. 0,5 L	5907506252047	325	0	325	666
JURAJSKIE POMARAСCZA KEG 30 L	5123456789259	205	0	205	667
SCHNEEEULE BLAUE BLUMEN BUT. 0,75 L	\N	204	0	204	668
KASTEEL TRIPEL BUT. 0,33 L	5411081000677	340	0	340	669
ARTEZAN LOW HANGING FRUIT BUT. 0,5 L	5904708750753	248	0	248	670
STU MOSTУW WRCLW PSZENICZNY BUT. 0,5 L	5907614680497	225	0	225	671
KAZIMIERZ SZKLANKOWY KIWOGREST BUT. 0,5 L	5906660570462	204	0	204	672
LITOVEL ИERNY CITRON 4% BUT. 0,5 L	8593875518418	342	0	342	673
NERDBREWING SUSPEND MAPLE AND CINNAMON IMP OATMEAL STOUT BUT. 0,33 L	7350080581160	212	0	212	674
TOOL THROUGH THE EYES OF MORTALS BUT. 0,75 L	5711474009936	203	0	203	675
DUGGES HYBRID 02 BUT. 0,33 L	7350038223722	247	0	247	676
BALADIN XYAUYU ORO 2018 BUT. 0,5 L	8032942291293	237	0	237	677
SOWIE MARCOWE BUT. 0,5 L	5907222560068	567	0	567	678
JURAJSKIE ЊWIҐTECZNE BUT. 0,5 L	5095331025247	202	0	202	679
NERDBREWING HOTPATH IMPERIAL CHILI STOUT - 004 ANCHO BUT. 0,33 L	7350080580910	204	0	204	680
ALEBROWAR SINGLE HOP STYRIAN CARDINAL HAZY APA BUT. 0,5 L	5907771343402	259	0	259	681
ED RED KONSERWA LECZO Z KIEЈBASҐ Z RUSIBORZA	5904083584110	210	0	210	682
P?HJALA COSY NIGHTS BUT. 0,33 L	4742976015508	249	0	249	683
NEPOMUCEN FREE ODRA PANY PUSZKA 0,5 L	5904555992795	283	0	283	684
MAGIC ROAD PERFECT BREAKFAST JACK DANIELS BA PUSZKA 0,33 L	5905204130308	204	0	204	685
DUGGES MANGO MANGO MANGO PUSZKA 0,33 L	7350038224897	224	0	224	686
ARTEZAN STUDIUM PRZYPADKU BUT. 0,5 L	5904708750524	208	0	208	687
PINTA BARREL BREWING DISCLOSED 12,0° BUT. 0,375 L	5904335577501	220	0	220	688
CHYLICZKI CYDR SWEET OAK 2018 BUT. 0,5 L	5905279058217	285	0	285	689
BIRBANT WEIZEN KLASYCZNY BUT. 0,5 L	5903240620517	362	0	362	690
KRAJAN IRLANDZKIE JASNE BUT. 0,5 L	5907582579434	395	0	395	691
JUDAS POKAL 0,33 L	5123456791083	204	0	204	692
BRUNEHAUT BLANCHE BIO GLUTEN FREE BUT. 0,75 L	5411065200895	220	0	220	693
TRZECH KUMPLI WHEELER PUSZKA 0,5 L	5904252699294	315	0	315	694
3 FONTEINEN INTENSE RED OUDE KRIEK BUT. 0,75 L	5425007810981	208	0	208	695
BALADIN XYAUYU FUME 2016 BUT. 0,5 L	8032942290586	259	0	259	696
MARYENSZTADT BY THE WAY BUT 0,5 L	5903678022372	250	0	250	697
PINTA A ja pale ale 12,0° keg 20 l	5123456789652	203	0	203	698
LINDEMANS GOYCK BUT. 0,75 L	5430001057010	240	0	240	699
INNE BECZKI TOPAZ BUT. 0,5 L	5903661280963	675	0	675	700
MAGIC ROAD SEASON FOR SAISON BUT. 0,5 L PROMOCJA (do 15.10.23)	\N	219	0	219	701
MAGIC ROAD PRETTY STRAWBERRY, CHERRY, BLACKCURRANT & MAPLE SYRUP PUSZKA 0,5 L	5905204130919	211	0	211	702
FUNKY FLUID GELATO: POMEGRANATE & PLUM MOCHA PUSZKA 0,5 L	5903999514082	267	0	267	703
BOSTEELS PAUWEL KWAK POKAL 0,33 L	5123456791081	220	0	220	704
BOON KRIEK BUT. 0,75 L	5412783053190	297	0	297	705
STU MOSTУW DRUNKEN SAILOR PUSZKA 0,33 L	5907614682491	242	0	242	706
PRIMБTOR WEIZEN BUT. 0,5 L	8594006931663	850	0	850	707
LIMBURGSE WITTE KEG 20 L	24242424	227	0	227	708
FUNKY FLUID SANDY BUT. 0,5 L	5907772092170	262	0	262	709
FUNKY FLUID GELATO: TARTA DE QUESO PUSZKA 0,5 L	5903999514662	236	0	236	710
NEPOMUCEN SIMPLY & EASY PUSZKA 0,5 L	5905191386108	205	0	205	711
FLYING DOG SZKLANKA 1/2 PINT	5123456791390	276	0	276	712
RODENBACH ALEXANDER BUT. 0,75 L	5410583802048	623	0	623	713
KINGPIN ATAVISTIC PUSZKA 0,5 L	5904730290821	620	0	620	714
MAGIC ROAD COLOURS: JUST PINK PUSZKA 0,5 L	5905204131008	408	0	408	715
SCHNEIDER TAP07 ORIGINAL 12,8° BUT. 0,5 L	4003669016203	994	0	994	716
RACIBORSKIE KLASYCZNE PUSZKA 0,5 L	5907506252719	282	0	282	717
Paleta transportowa zw	\N	3406	0	3406	718
ZA MIASTEM WARTO STRZELIЖ BUT. 0,5 L	5906874605455	467	0	467	719
BROKREACJA TIMBER PUSZKA 0,5 L	5904422197889	232	0	232	720
BROWAR GУRNICZO-HUTNICZY IMPERIAL BALTIC PORTER BARREL AGED BUT. 0,33 L	5907796630105	254	0	254	721
MOCZYBRODA JACK MANGOW BUT. 0,5 L	5903351761406	462	0	462	722
LINDEMANS TAROT D'OR BUT. 0,25 L	5411223005317	2605	0	2605	723
PIWNE PODZIEMIE TROPICALIA KEG 30 L	5123456789400	204	0	204	724
MOCZYBRODA INTO THE VOID PUSZKA 0,5 L	5904673800804	228	0	228	725
PINTA MASTERBAR Vanilla & Coconut 30,0° but. 0,33 l	5904165103642	239	0	239	726
BROKREACJA THE FARMER BUT. 0,5 L	5905669783040	327	0	327	727
THE BRUERY GYPSY TART BUT. 0,75 L	705105537955	206	0	206	728
BIRBANT SKULLY PUSZKA 0,5 L	5904041703874	223	0	223	729
MC CHOUFFE BUT. 0,33 L	5410769200088	343	0	343	730
ALEBROWAR SON OF THE SON BUT. 0,5 L	\N	292	0	292	731
KASTEEL RUBUS FRAMBOISE 0,33 L	5411081009854	324	0	324	732
TRZECH KUMPLI W STYLU GRODZISKIE BUT. 0,5 L	5905669479400	484	0	484	733
MALTGARDEN A TASTE OF MADNESS BUT. 0,5 L	5904050721876	253	0	253	734
PIRAAT RED BUT. 0,33 L	5411663000781	318	0	318	735
MATE - MATE KONOPIA HEMP BUT. 0,5 L	4260310559056	218	0	218	736
BOON LAMBIEK 2 YEAR OLD KEG 20 L	\N	204	0	204	737
BROWAR JANA RZEЊKIE BUT. 0,5 L	5902429980947	316	0	316	738
LA TRAPPE FLAGA	5123456791149	201	0	201	739
STAROPOLSKIE MY WAY DOPPEL WIZENBOCK BUT. 0,5 L	5903021505774	232	0	232	740
MAREDSOUS 6% BLONDE BUT 0,33 L	5411681035000	227	0	227	741
RACIBORSKIE KLASYCZNE ZW BUT. 0,5 L	5907506252276	354	0	354	742
FUNKY FLUID SPIFFY PUSZKA 0,5 L	5903999514488	452	0	452	743
MIKKELLER RUNNING CLUB SPODNIE CZARNE (S)	5123456791117	202	0	202	744
BUTELKA ZWROTNA RACIBУRZ 0,5 L	\N	2167	0	2167	745
DE STRUISE DARK HORSE SOUR ALE BUT. 0,75 L	5425017002758	220	8	220	746
PINTA BARREL BREWING DIRECTION 30,0° BUT. 0,33 L	5904335577495	230	15	230	747
DELIRIUM RED BUT. 0,33 L	5412186002436	239	0	239	748
LEFFE RUBY KEG 6 L	5410228200147	201	0	201	749
DUGGES SUPERIOR PUSZKA 0,33 L	7350038226044	207	0	207	750
PINTA Pierwsza Pomoc 10,5° but. 0,5 l	5904730438575	1302	0	1302	751
LINDEMANS PECHERESSE BUT. 0,25 L	5411223100838	500	0	500	752
ZAKЈADOWY SEZON CZWARTY BUT. 0,5 L	5907753172136	245	0	245	753
CHIMAY KIELICH W PUDEЈKU 0,18 L	5123456791186	209	0	209	754
PINTA Bawarka 13,0° but. 0,5 l	5908252864003	657	0	657	755
MOON LARK SILK. HEFEWEIZEN PUSZKA 0,5 L	5905255346369	444	0	444	756
DE MOLEN HAMER & SIKKEL BUT. 0,33 L	8717624421228	273	0	273	757
LINDEMANS TAROT POKAL 0,33 L	\N	221	0	221	758
NEPOMUCEN TAKE IT! PUSZKA 0,5 L	5905701060115	228	0	228	759
FUNKY FLUID GELATO: ARANCIA PUSZKA 0,5 L	5903999514402	272	0	272	760
CYRILOVY BRAMBURKY SOLONE - CHIPSY 100 G	8594021041064	350	0	350	761
ZA MIASTEM DZIEС DOBRY Z POMARAСCZҐ BUT. 0,5 L	5904905630179	235	0	235	762
PIWNE PODZIEMIE CHMIELOKRATA HBC 586 PUSZKA 0,5 L	5904305482088	541	0	541	763
NEPOMUCEN FRUITLAND PUSZKA 0,5 L	5905191386900	225	0	225	764
MONSTERS FRUIT MACHINE #8 PUSZKA 0,5 L	5905476980663	285	0	285	765
PINTA T-shirt zielony duїe logo S	5904165102546	203	0	203	766
TILQUIN OUDE GEWURZT A L'ANCIENNE BUT. 0,75 L	5425029530812	201	0	201	768
DZIKI WSCHУD SAA PUSZKA 0,5 L	5906874369586	233	0	233	769
DZIKI WSCHУD BUSZUJҐCY W ZBOЇU BUT. 0,5 L	5906874369265	340	0	340	770
MARYENSZTADT SOURTIME AGREST BUT. 0,5 L	5905669542456	453	0	453	771
STU MOSTУW WILD #12 BIERE DE SOIF PEACHES AND CHERRIES BUT. 0,375 L	5907614680350	223	0	223	772
MARYENSZTADT BARREL AGED PROJECT – COCONUT RIS RUM BARREL AGED PUSZKA 0,44 L	5903424615728	237	0	237	773
FUNKY FLUID SPLASH: WHITE PUSZKA 0,5 L	5903999512491	221	0	221	774
MARYENSZTADT HOPPY LEMO - GRANAT & CHMIEL BUT. 0,33 L	5903678022044	329	0	329	775
DUBUISSON PECHE MEL BUSH BUT. 0,33 L	5411551130392	203	0	203	776
SCHNEIDER TAP04 FESTWEISSE 13,4° BUT. 0,5 L	4003669016609	475	0	475	777
TILQUIN OUDE PINOT NOIR A L'ANCIENNE BUT. 0,75 L	5425029530232	201	0	201	778
ED RED KONSERWA KACZE ЇOЈҐDKI W SOSIE ESTRAGONOWYM	5903940086552	210	0	210	779
TARNOBRZEG AWATAR BUT. 0,5 L	5907713309725	353	0	353	780
ARTEZAN NO WORRIES! BUT. 0,5 L	5904730574310	259	0	259	781
STU MOSTУW WILD #11 BIERE DE GARDE BUT. 0,375 L	5907614680282	240	0	240	782
L'INSTANT MOONSPELL KEG 20 L	\N	201	0	201	783
TIMMERMANS FARO BUT. 0,375 L	5411516001491	221	0	221	784
RADUGA GAME#4 BUT. 0,5 L	5902176770877	725	0	725	785
PRZETWУRNIA CHMIELU PRECEL PUSZKA 0,5 L	5905476980526	237	0	237	786
PINTA Cold Delivery 14,0° keg 30 l	5123456780036	202	0	202	787
BROKREACJA PIRATE BAY BUT. 0,5 L	5904422197810	208	0	208	788
DE MOLEN POKAL 0,330 L	5123456791096	203	0	203	789
CIGAR CITY FAIR EXCHANGE PUSZKA 0,355 L	850005189756	206	0	206	790
NEPOMUCEN NACHMIELONA CHMIEL+WODA PUSZKA 0,5 L	5905191386689	292	0	292	791
AMAGER COBRAS FUMANTES BUT. 0,33 L	5704603303043	202	0	202	792
KEG FORTUNA 30 L	5123456792017	234	0	234	793
SMYKAN CYDR CHMIELONY SAD KEG 30 L	5123456791297	204	0	204	794
DZIKI WSCHУD WILD WILD EAST CRANBERRY WILD ALE BUT. 0,375 L	5906874369623	219	0	219	795
3 FONTEINEN FRAMBOOS OOGST 2019 BUT. 0,75 L	5425007818116	214	0	214	796
PINTA Bawarka 13,0° keg 30 l	5123456789666	201	0	201	797
PODGУRZ 652 M N.P.M. BOURBON B.A. BUT. 0,5 L	5906874055007	249	0	249	798
SOFIA ELECTRIC / PINTA FORTUNE TAMER PUSZKA 0,33 L	3800501676431	910	0	910	799
ST. BERNARDUS PODKЈADKI	\N	699	0	699	800
MOCZYBRODA POPART #05 CHOCOLATE PASTRY IMPERIAL STOUT BUT. 0,5 L	5904673800415	223	0	223	801
LUBROW PRAUSTBANDE'23 PUSZKA 0,33 L	5903686842504	265	0	265	802
CANTILLON KRIEK-LAMBIC BIO 2022 BUT. 0,375 L	5411024000054	280	0	280	803
KAZIMIERZ MANGOЈ BUT. 0,5 L	5906660570103	355	0	355	804
SZRENIAWA MIODOWE BUT. 0,5 L	5903857178302	2325	0	2325	805
P?HJALA VARSKE PUSZKA 0,33 L	4742976014655	247	0	247	806
TRZECH KUMPLI PIECE OF CAKE PUSZKA 0,5 L PROMOCJA (do 14.10.23)	\N	277	0	277	807
ALEBROWAR SINGLE HOP EL DORADO BUT. 0,5 L	5907771343242	491	0	491	808
DUVEL OTWIERACZ	5123456791200	203	0	203	809
MALTGARDEN SLEEPING IN ORCHARD BUT. 0,5 L	5907710943878	214	0	214	810
INNE BECZKI ZERO TO HERO BUT. 0,5 L	5901122234203	910	0	910	811
BЈONIE CUDA WIANKI BUT. 0,5 L	5908258856088	605	0	605	812
ST. FEUILLIEN SAISON SZKLANKA 0,33 L	5123456791029	226	0	226	813
MALTGARDEN ENDLESS PARTY PUSZKA 0,5 L	5904050721968	233	0	233	814
ZAKЈADOWY PROSTY WYBУR BUT. 0,5 L	5907753172402	237	0	237	815
JACKIE O'S POCKETS OF SUNLIGHT BUT. 0,5 L	855647004832	208	0	208	816
TRZECH KUMPLI IGROK BUT. 0,33 L	5905669479684	244	0	244	817
GRYFUS PORTOWIEC BUT. 0,5 L	5904905850072	315	0	315	818
ALEBROWAR FREE WAY BUT. 0,5 L	5907222039526	338	0	338	819
MARYENSZTADT KLASYCZNIE BAWARSKA PSZENICA BUT. 0,5 L	5905669542579	260	0	260	820
Ca' del Brado / PINTA Barrel Brewing Copernicana 8,5° but. 0,375 l	\N	208	0	208	821
JACKIE O'S / CASITA CERVECERНA CARROTS & STICKS BUT. 0,375 L	855647004917	203	0	203	822
WIDAWA LE POLONAISE C’T’UNE JOKE CABERNET CORTIS B.A. BUT. 0,75 L	5907710904602	240	0	240	823
MIKKELLER RUNNING CLUB SPODNIE CZARNE (XXL)	5123456791118	201	0	201	824
LIMBURGSE WITTE POKAL 0,5 L	5123456791073	206	0	206	825
TRZECH KUMPLI PORTER BAЈTYCKI BUT. 0,5 L	5905669479516	335	0	335	826
FORTUNA WIЊNIOWA BUT. 0,5 L	5902709615200	306	0	306	827
TARNOBRZEG SANTAROSA BUT. 0,5 L	5907713309732	290	0	290	828
MOON LARK PRIME. WEST COAST IPA PUSZKA 0,5 L	5905255346000	263	0	263	829
SAMUEL SMITH IMPERIAL STOUT BUT. 0,355 L	5010149200846	252	0	252	830
JURAJSKIE ALE SZOPKA BUT. 0,5 L	5905331026062	223	0	223	831
DUVEL TRIPLE HOP CASHMERE BUT. 0,33 L	5411681406039	424	0	424	832
BURLEY OAK MID LIFE RIGHTEOUS PUSZKA 0,473 L	\N	202	0	202	833
FUNKY FLUID HIGH FIVE! PUSZKA 0,5 L	5903999514464	380	0	380	834
90 BPM MINITEL ROSE KEG 30 L	\N	201	0	201	835
THE BREWING PROJEKT THINGS OF THAT PUSZKA 0, 473 L	810059390799	203	0	203	836
PINTA Kwas Xy 12,0° keg 20 l	5123456789810	203	0	203	837
CHIMAY BLUE BUT. 0,33 L	5410908000036	569	0	569	838
P?HJALA VIRMASILED O ALKOHOLIVABA IPA PUSZKA 0,33 L	4742976013658	243	0	243	839
SZRENIAWA BI?RE DE GARDE BUT. 0,33 L	5903857178296	201	0	201	840
HERKENRODE NOCTIS BUT. 0,33 L	5413699101234	201	0	201	841
NEPOMUCEN LIKE A FOREST PUSZKA 0,5 L	5907709756540	443	0	443	842
SMYKAN CYDR WYSPOWA ANTONУWKA BUT. 0,75 L	5905669332248	253	0	253	843
RACIBORSKIE KLASYCZNE BUT. 0,5 L	5907506252726	1519	0	1519	844
GRYFUS FLORA BUT. 0,5 L	5904905850171	255	0	255	845
VITAMINE SEA CURRENCY CHECK PUSZKA 0,473 L	5123456790113	208	0	208	846
HOLBA PREMIUM 12° BZW.  BUT. 0,5 L	8593875610112	498	0	498	847
BIRBANT MUERTE PUSZKA 0,33 L	5904041703348	218	0	218	848
STAROPOLSKIE PRL PIWO JASNE 0,5 L	5905669086257	254	0	254	849
SMYKAN CYDR SMYKAN 2021 BUT. 0,75 L	5905669332002	227	0	227	850
PINTA Atak Chmielu 15,0° keg 30 l	5123456789662	231	0	231	851
DUVEL NEON	5123456791201	201	0	201	852
P?HJALA BALTIC PORTER DAY 2023 KEG 20 L	\N	202	0	202	853
ZAKЈADOWY POZAMIATANE BUT. 0,5 L	5907753172310	201	0	201	854
ED RED KONSERWA ЇEBERKA W SOSIE BBQ Z CHILI	5903940086514	210	0	210	855
CA' DEL BRADO ZENA - WILD GOSE BUT. 0,375 L	\N	203	0	203	856
BЈONIE KUR ZAPIAЈ BUT. 0,5 L	5908258856101	710	0	710	857
STU MOSTУW ART+68 PASTRY IMPERIAL STOUT PECAN NUTS-COCONUT BUT. 0,33 L	5907614682989	240	0	240	858
RACIBORSKIE CIEMNE BUT. 0,5 L	5907506252207	428	0	428	859
MARYENSZTADT SOURTIME PASTRY SOUR GRANAT I POMARAСCZA BUT 0,5 L	5903678022099	347	0	347	860
MALTGARDEN PROTON BUT. 0,5 L	590405072103	386	0	386	861
PETRUS TRADITION ZESTAW (3X 0,33 L + SZKЈO)	5411831002500	224	0	224	862
KEG DU BOCQ 20L	\N	207	0	207	863
TRZECH KUMPLI IMPERIAL BERLINER WEISSE 30 L	5123456789481	203	0	203	864
JURAJSKIE SZKLANKA SHAKER 0,5 L	5123456791393	347	0	347	865
CHYLICZKI CYDR ANTONУWKA KEG 30 L	5123456789026	202	0	202	866
FUNKY FLUID THOMAS - GELATO: SCHWARZWДLDER KIRSCHTORTE PUSZKA 0,5 L	5903999513610	234	0	234	867
SCHNEEEULE IRMGARD KEG 20 L	\N	201	0	201	868
PINTA Otwieracz magnes Logo	5904165101648	201	0	201	869
MONSTERS JUICY #3  PUSZKA 0,5 L	5905476980595	252	0	252	870
HOFSTETTNER GRANITBOCK ICE BUT. 0,33 L	9007293384030	214	0	214	871
TRZECH KUMPLI BOCK KEG 30 L	5123456789462	203	0	203	872
FUNKY FLUID TRIPLE GELATO: RASPBERRY & RED GRAPE COCONUT BAR PUSZKA 0,5 L	5903999513733	251	0	251	873
PINTA T-shirt czarny duїe logo XL	5904165102423	201	0	201	874
VIGO Kombucha BIO Rуїa but. 0,33 l	5902768514346	209	0	209	875
CINEY BRUIN BUT. 0,25 L	54055315	213	0	213	876
KAZIMIERZ MUSTAFA BUT. 0,5 L	5906660570493	122	0	122	877
TIMMERMANS FRAMBOISE BUT. 0,25 L	5411516010707	212	0	212	878
ROMY SZKLANKA 0,25 L	5123456791030	203	0	203	879
MALTGARDEN FUNKY GARDEN VOL. 8  PUSZKA 0,5 L	5904050721128	284	0	284	880
PINTA Hazy Delivery 15,0° keg 30 l	5123456780042	205	0	205	881
FILOMELOS CYDR SPOKOJNY JABЈKOWY BUT. 0,75 L	5900168509023	228	0	228	882
KASTEEL ROUGE BUT. 0,33 L	5411081003654	385	0	385	883
ST. FEUILLIEN GRAND CRU BUT. 0,75 L	5412138617510	212	0	212	884
PIWNE PODZIEMIE AMERICAN CLASSIC #1 PUSZKA 0,5 L	5904305482774	245	0	245	885
WIDAWA CZARNY KUR BUT. 0,5 L	5907710904015	235	0	235	886
ЈAСCUT LEMUR PARADISE BUT. 0,5 L	5906395997961	303	0	303	887
GOЊCISZEWO LETNIK BUT. 0,5 L	5903364108977	307	0	307	888
ST. BERNARDUS PATER 6 BUT. 0,33 L	54079007	278	0	278	889
WESTMALLE DUBBEL KEG 20 L	5412343001418	203	0	203	890
ZIEMIA OBIECANA TRIPLE BAJLANDO PUSZKA 0,5 L	5905186484314	215	0	215	891
TRZECH KUMPLI IDIOTA BUT. 0,33 L	5905669479387	260	0	260	892
KRAJAN IRLANDZKIE CZERWONE BUT. 0,5 L	5907804436248	300	0	300	894
PINTA Cold Delivery 14,0° can 0,5 l	5904165104939	272	0	272	895
STAROPOLSKIE BESTBIR ЇURAWINA BUT. 0,5 L	5903021503268	256	0	256	896
FILOMELOS PERRY ZAGRUSZKA BUT. 0,75 L	5900168509085	205	0	205	897
FUNKY FLUID FREE TROPIC PUSZKA 0,33 L	5903999514754	288	12	288	898
DU BOCQ BLANCHE DE NAMUR BUT. 0,75 L	5411633750050	239	0	239	899
BIRBANT RED AIPA BUT. 0,5 L	5903240620371	245	0	245	900
NEPOMUCEN HENRYK PUSZKA 0,5 L	5905191386399	230	0	230	901
TRZECH KUMPLI UNPLUGGED NITRO OATMEAL STOUT BUT. 0,5 L	5905669479844	310	0	310	902
STAROPOLSKIE ZЈOTY UL 3 MIODY BUT. 0,5 L	5905669086288	250	0	250	903
MALTGARDEN DEAD PHONE CALLING BUT. 0,5 L	5907710943977	250	0	250	904
NEPOMUCEN D-TONACJA 2023 PUSZKA 0,33 L	5905191386566	216	0	216	905
CZTERY ЊCIANY LUSTRO PUSZKA 0,5 L	5905108498801	205	0	205	906
DUVEL CZAPKA Z DZASKIEM SZARA	5123456791453	205	0	205	907
PRZETWУRNIA CHMIELU PLANTACJA #3 PUSZKA 0,5 L	5905476980717	204	0	204	908
JURAJSKIE AMERYKAСSKA PSZENICA BUT. 0,5 L	5905331025355	281	0	281	909
NEPOMUCEN SPURS PUSZKA 0,5 L	5905701060146	208	0	208	910
OUD BEERSEL OUDE GUEUZE BARREL SELECTION OUDE PIJPEN BUT. 0,375 L	5425018070459	239	0	239	911
CHYLICZKI CYDR ALWA KEG 30 L	\N	202	0	202	912
P?HJALA PRENZLAUER PUSZKA 0,33 L	4742976013498	249	0	249	913
CIESZYN RAUCHBOCK - GRAND CHAMPION 2022 BUT. 0,33 L	5907612240822	202	0	202	914
LUBROW CRYO APA EL DORADO PUSZKA 0,33 L PROMOCJA (do 14.10.23)	\N	225	0	225	915
FUNKY FLUID GELATO: BERRIES & CREAM PUSZKA 0,5 L	5903999510107	345	0	345	916
MAGIC ROAD FREE PRETTY MANGO, PASSIONFRUIT & WHITE CHOCOLATE PUSZKA 0,5 L	5905204130933	205	0	205	917
PINTA Double Delivery 18,0° can 0,5 l	5904165104977	272	0	272	918
MINISTER NICE RICE BUT. 0,5 L	5903351660273	731	0	731	919
PINTA Psst... It's Your Weekend IPA - Hazy IPA 15,0° but. 0,5 l	5904165104694	1167	0	1167	920
DZIKI WSCHУD SZALONY KOС BUT. 0,5 L	5906874369296	240	0	240	921
PINTA T-shirt czarny duїe logo M	5904165102409	201	0	201	922
RECRAFT JUICY SOUR SERIES – LICZI X ANANAS X BANAN X WINOGRONA PUSZKA 0,5 L	5900779755963	323	0	323	923
MARYENSZTADT BARREL AGED RIS HEAVEN HILL BOURBON WHITE & DARK CHOCOLATE & COCONUT PUSZKA 0,44 L	5903678022082	218	0	218	924
STU MOSTУW LAST RESORT PUSZKA 0,33 L	5907614682507	303	0	303	925
ALEBROWAR BAЈTYCKI DZIAD STOUT BUT. 0,5 L	5907771342283	244	0	244	926
ANDERSON JEAN GINIE GIN BA BUT. 0,33 L	4744175010582	216	0	216	927
PIWNE PODZIEMIE GEORGIA PEACH MOCHI PUSZKA 0,5 L	5904305482736	463	0	463	928
LA TRAPPE TRIPEL BUT. 0,75 L	8711406137192	257	0	257	929
BIRBANT FLEX PUSZKA 0,5 L	5904041703843	619	0	619	930
BOON SCHAARBEEKSE KRIEK BUT. 0,375 L	5412783153258	276	0	276	931
MAGIC ROAD EVERGLOW PUSZKA 0,5 L	5905204130834	225	0	225	932
PRAIRIE / TRVE EDITION SOUR RED FARMHOUSE ALE BUT. 0,5 L	683318988224	212	0	212	933
ALEBROWAR HERR AXOLOTL WITH GOLDENBERRY BUT. 0,5 L	5907771343716	335	0	335	934
RADUGA IS THIS THE REAL LIFE? PUSZKA 0,5 L	5902176772017	534	0	534	935
TRZECH KUMPLI TASSIE BUT. 0,5 L	5905669479974	327	0	327	936
INNE BECZKI SUMMERTIME BUT. 0,5 L	5901122234654	483	0	483	937
FUNKY FLUID FOGGY PUSZKA 0,5 L	5907772092408	837	0	837	938
NEPOMUCEN CITRUS TIRAMISU PUSZKA 0,5 L	5905701060313	358	0	358	939
DU BOCQ BLANCHE DE NAMUR BUT. 0,33 L	5411633330054	273	0	273	940
NEPOMUCEN OLE BUT. 0,5 L	5905279959910	339	0	339	941
GRYFUS STERNIK BUT. 0,5 L	5907222685198	290	0	290	942
HOUBLON CHOUFFE BUT. 0,75 L	5410769300115	301	0	301	943
DUGGES BIG LITTLE FIVE PUSZKA 0,5 L	7350038226143	223	0	223	944
ARTEZAN VOLARE BUT. 0,5 L	5904708750654	208	0	208	945
STU MOSTУW WRCLW SCHOPS BUT. 0,5 L	5907614680480	364	0	364	946
MOON LARK / PINTA STAY HERE #3 14,0° KEG 30 L	\N	211	0	211	947
P?HJALA ЦЦ BUT. 0,33 L	4742976010015	294	0	294	948
KAZIMIERZ ALDONA BUT. 0,5 L	5906660570042	294	0	294	949
KORMORAN ZЈOTY EXPORT LAGER BUT. 0,5 L PROMOCJA (do 17.10.23)	\N	201	0	201	950
ST. GUMMARUS TRIPEL BUT. 0,33 L	5413699011106	227	0	227	951
PIWOTEKA GORZKI ЊNIEG BUT. 0,5 L	5905669428170	247	0	247	952
MARYENSZTADT SUMMERTIME HOPPY HEFEWEIZEN BUT. 0,5 L	5903424615094	257	0	257	953
SCHLENKERLA SZKLANKA NOSTALGY 0,5 L	5123456791328	239	0	239	954
LINDEMANS T-SHIRT DAMSKI SZARY (S)	\N	202	0	202	955
MALTGARDEN GATE NO 3/2023 PUSZKA 0,33 L	5907710943168	212	0	212	956
AMAGER / DБDIVA VIEWPOINT BUT. 0,33 L	5704603303005	213	0	213	957
DUBUISSON BUSH PRESTIGE BUT. 0,75 L	5411551677880	218	0	218	958
NEPOMUCEN SZOSA BUT. 0,5 L	5907709756106	433	0	433	959
CIESZYN SOUR BARLEY WINE BARREL AGED BUT. 0,33 L	5905279156579	227	0	227	960
LUBROW INFUSED NO. 2 PUSZKA 0,33 L	5903686842863	265	0	265	961
LAMORAL POKAL 0,33 L	5123456791076	201	0	201	962
PINTA Double Delivery 18,0° but. 0,5 l	5904165104953	225	0	225	963
DE MOLEN VUUR & VLAM BUT. 0,33 L	8717624421037	282	0	282	964
TRZECH KUMPLI W STYLU GRODZISKIE KEG 20 L	5123456789517	201	0	201	965
ZAKЈADOWY BRAMA WJAZDOWA BUT. 0,5 L	5906395388066	300	0	300	966
BIRBANT HAWKINS HOPS PUSZKA 0,5 L	5904041703515	237	0	237	967
GWAREK ZERO MATES LIQUID RED BUT. 0,5 L	5903938751745	300	0	300	968
MARYENSZTADT ICE IMPERIAL BALTIC PORTER BURBON BARREL AGED PUSZKA 0,44 L	5905669542883	225	0	225	969
SATAN GOLD BUT. 0,33 L	5412107000466	217	0	217	970
GOЊCISZEWO SZEWC BUT. 0,5 L	5903364108991	240	7	240	971
LUBROW WEST COAST HIGHWAY PUSZKA 0,33 L	5903686842627	330	0	330	972
O'HARA'S SZKLANKA SHAKER 0,5 L	5123456791388	254	0	254	973
BIRBANT LOWKEY PUSZKA 0,5 L	5904041703737	241	0	241	974
CHIMAY TRIPLE BUT. 0,33 L	5410908000029	357	0	357	975
MIKKELLER TAP HANDLE	5123456791331	218	0	218	976
FILOMELOS PERRY HULAJ GRUSZKA BUT. 0,33 L	5900168509108	355	0	355	977
ALEBROWAR LOVELY VIOLA BUT. 0,5 L	5907771340050	262	0	262	978
NEPOMUCEN LOVELAS TRIPLE FOREST IPA PUSZKA 0,5 L	5907709756700	336	0	336	979
JURAJSKIE PORTER BAЈTYCKI BUT. 0,33 L	5905331025416	332	0	332	980
PINTA T-shirt biaіy duїe logo XXL	5904165102485	201	0	201	981
KASTEEL RКCZNIK BAROWY	\N	205	0	205	982
CORSENDONK AGNUS TRIPLE BUT. 0,33 L	54069022	287	0	287	983
NEPOMUCEN PRECIOUS PUSZKA 0,5 L	5905191386030	314	0	314	984
NEPOMUCEN FOREST IPA BUT. 0,5 L	5905279959521	702	0	702	985
BROWARNY ROYALS PUSZKA 0,5 L	5905450141127	272	0	272	986
DUBUISSON BUSH ZESTAW (2 X CARACTERE BUT. 0,33 L + 2 X TRIPLE BUT. 0,33 L +SZKЈO)	5411551120515	201	0	201	987
NEPOMUCEN KEEP ON ROLLIN’ PUSZKA 0,5 L	5905701060245	261	0	261	988
ALEBROWAR ICE NAKED MUMMY BUT. 0,25 L	5907771341385	203	0	203	989
LINDEMANS POKAL SENSORIK 200 ANNIVERSARY 0,25 L	5123456791132	312	0	312	990
PINTA Szklanka Your Beer Your Glass 0,5 l	\N	726	0	726	991
MARYENSZTADT BARREL AGED RIS HEAVEN HILL BOURBON BROWNIE PUSZKA 0,44 L	5903424615018	210	0	210	992
PALETA FORTUNA EPAL 1200X800	\N	210	0	210	993
VAL-DIEU BLONDE BUT. 0,75 L	5413977000266	216	0	216	994
UNTITLE ART. SWEET SOUR TANGERINE PUSZKA 0,473 L	850011756935	235	0	235	995
SAMUEL SMITH OATMEAL STOUT BUT. 0,355 L	5010149200822	235	0	235	996
ARTEZAN PACIFIC BUT. 0,5 L	5904730574051	219	0	219	997
SOWIE PORTER BAЈTYCKI 22 BUT. 0,5 L	5907222560334	241	0	241	998
LINDEMANS TAROT BLACHA	\N	201	0	201	999
P?HJALA TUME LAAGER PUSZKA 0,44 L	4742976015362	223	0	223	1000
BIRBANT FRIDAY PUSZKA 0,5 L	5904041703676	212	0	212	1001
GRYBУW PILSVAR EXCLUSIVE BUT. 0,5 L	5902516000329	231	0	231	1002
NEPOMUCEN MICRO LINES PUSZKA 0,5 L	5905701060009	315	0	315	1003
ZA MIASTEM PIҐTEK WIECZУR BUT. 0,5 L	5904905630100	262	0	262	1004
ЈAСCUT PODCHMIELONY WOJOWNIK BUT. 0,5 L	5906395997985	244	0	244	1005
MIKKELLER OREGON FRUIT SERIES: SPONTANBLUEBERRY BUT. 0,75 L	5704255115551	213	0	213	1006
PIRAAT BUT. 0,33 L	5411663002600	205	0	205	1007
PRAIRIE PARADAISE BUT. 0,355 L	683318988323	206	0	206	1008
TRZECH KUMPLI MVPILS KEG 30 L	5123456789487	204	0	204	1009
STU MOSTУW STRAWBERRY BERLINER WEISSE BUT. 0,5 L	5905279213388	541	0	541	1010
LINDEMANS POKAL SENSORIK  0,25 L	5123456791229	273	0	273	1011
NEPOMUCEN CASTLE PARTY PUSZKA 0,5 L	5905701060122	240	0	240	1012
ЈAСCUT MITYNG BUT. 0,5 L	5906395997091	404	0	404	1013
DZIKI WSCHУD TAСCZҐCY Z CHMIELAMI BUT. 0,5 L	5906874369135	300	0	300	1014
BUTELKA ZWR FORTUNA 0,5 L	\N	9777	0	9777	1015
SCHLENKERLA RAUCHBIER MДRZEN KEG 30 L	5123456789425	201	0	201	1016
BOON FRAMBOISE BUT. 0,375 L	5412783055842	296	0	296	1017
STAROPOLSKIE THE ART OF HOPPING EL DORADO SIGLE HOP HAZY IPA BUT. 0,5 L	5903021505491	283	0	283	1018
RECRAFT POLISH HAZY IPA AMORA PRETA & 3/20 PUSZKA 0,5 L	5904730663786	348	0	348	1019
ST. BERNARDUS WIT BUT. 0,75 L	5411911001515	275	0	275	1020
STAROPOLSKIE KULTOWE BEZ GLUTENU PSZENICZNE BUT. 0,5 L	5903021504401	212	0	212	1021
PASSENDALE POKAL 0,25 L	5123456791069	201	0	201	1022
MOON LARK CHEERFUL. ESTRA SPECIAL BITTER PUSZKA 0,5 L	5905255346505	323	0	323	1023
RACIBORSKIE SZKLANKA 0,5 L	\N	260	0	260	1024
MIЈOSЈAW ZESTAW MAKЈOWICZ 4 PIWA 0,5 L + LIMITOWANE SZKЈO	5902838991350	215	0	215	1025
HOEGAARDEN KEG 6 L	5410228187615	201	0	201	1026
NEPOMUCEN NACHMIELONA CHMIEL+WODA BUT. 0,5 L	5905279959316	235	0	235	1027
LINDEMANS POTYKACZ	5123456791133	206	0	206	1028
STAROPOLSKIE PORTER RUM BUT. 0,5 L	5903021503282	234	0	234	1029
FUNKY FLUID POINT FIVE HAZY IPA PUSZKA 0,5 L	5907772092958	337	0	337	1030
CORSENDONK AGNUS BUT. 0,75 L	5411491011164	220	0	220	1031
STAROPOLSKIE MY WAY DOUBLE WEST COAST IPA BUT. 0,5 L	5903021505767	232	0	232	1032
GRYBУW PILSVAR SVEJKOVE BUT. 0,5 L	5902516000831	280	0	280	1033
FORTUNA CZARNE BUT. 0,5 L	5902709615064	240	0	240	1034
DZIK CYDR JABЈKO KEG 30 L	5906395413065	219	0	219	1035
KINGPIN MELT PUSZKA 0,5 L	5904730290036	291	0	291	1036
CHYLICZKI CYDR LODOWY KEG 15 L	5123456789031	201	0	201	1037
MIKKELLER OREGON FRUIT SERIES: SPONTANPLUM BUT. 0,375 L	5704255117302	213	0	213	1038
ZA MIASTEM SЈODKIE LENISTWO Z KAKAOWCEM BUT. 0,5 L	5906874605240	240	0	240	1039
INNE BECZKI FREE IPA BUT. 0,5 L	5901122234432	650	0	650	1040
NEPOMUCEN MEET OUR FRIENDS | EPISODE 12: MOON LARK PUSZKA 0,5 L	5905701060092	331	0	331	1041
LINDEMANS T-SHIRT MКSKI SZARY (M)	\N	201	0	201	1042
MALTGARDEN GATE NO 1/2023 PUSZKA 0,33 L	5904050721999	216	0	216	1043
3 FONTEINEN KRYSZTAЈOWY KIELISZEK ZENNE 0,645 L	5123456791154	206	9	206	1044
MARYENSZTADT YES WE CAN VOL. 5 PUSZKA 0,5 L	5903424615919	246	10	246	1045
Dalons / PINTA Indian Baltic Porter 20,0° but. 0,33 l	3770012486549	214	0	214	1046
3 FONTEINEN HOMMAGE 2019/20 BUT. 0,375 L	5425007818192	226	0	226	1047
BROKREACJA GONE WITH THE PILS BUT. 0,5 L	5904422197995	278	0	278	1048
TRZECH KUMPLI RAGNAR BUT. 0,33 L	5905669479356	237	0	237	1049
TRZECH KUMPLI PILS BUT. 0,5 L	5905669479233	426	0	426	1050
PINTA Bluza czarna L	5904165100535	201	0	201	1051
LIMBURGSE WITTE PEAR APPLE BUT. 0,33 L	5413699165151	213	0	213	1052
PINTA MASTERBAR Vanilla & Coconut 30,0° keg 20 l	\N	201	0	201	1053
JUPILER NA BUT. 0,25 L	5410228231325	219	0	219	1054
TRZECH KUMPLI PAN IPANI KEG 30 L	5123456789495	213	0	213	1055
PINTA Psst... It's Your Weekend IPA - Foggy IPA 15,0° keg 30 l	5123456780050	201	0	201	1056
MOCZYBRODA POCO LOCO BUT.0,5 L	5903351761581	536	0	536	1057
VAL-DIEU GRAND BUT. 0,33 L	5413977000723	242	0	242	1058
OUD BEERSEL GEUZE VANDERVELDEN 137 BUT. 0,375 L	5425018070640	225	0	225	1059
STU MOSTУW KILWATER IMPERIAL BALTIC PORTER BBA (PLUMS, FIGS & DATES) BUT. 0,33 L	5907614682729	214	0	214	1060
DEER BEAR FLORAL PUSZKA 0,5 L	5905204172179	243	0	243	1061
FILOMELOS CYDR ANGELA BUT. 0,75 L	5900168509122	223	0	223	1062
INNE BECZKI JUNGLE IPA BUT. 0,5 L	5905669683005	439	0	439	1063
KAZIMIERZ DESET Z DESETI  BUT. 0,5 L	5906660570769	245	0	245	1064
O'HARA'S LEANN FOLLAIN BUT. 0,5 L	5391500600551	300	0	300	1065
STU MOSTУW WRCLW GRODZISKI BUT. 0,5 L	5907614683016	289	0	289	1066
MAGIC ROAD ULTIMATE COCONUT PRETTY LIMITED EDITION BUT. 0,33 L	5905204130452	223	0	223	1067
CIESZYN PILSNER BUT. 0,5 L	5907612240860	525	0	525	1068
LIMBURGSE WITTE TAP HANDLE	5123456791368	201	0	201	1069
MIKKELLER PUMA BOKSERKA SPORTOWA CZARNA (XXL)	5123456791120	201	0	201	1070
STU MOSTУW BON VOYAGE PUSZKA 0,44 L	5907614683191	240	0	240	1071
STAROPOLSKIE KULTOWE BEZ GLUTENU CYTRYNOWE BUT. 0,5 L	5903021504395	300	0	300	1072
DZIK CYDR WYTRAWNY BUT. 0,5 L	5906395413492	556	0	556	1073
SCHNEIDER TAP02 KRISTALL 11,2° BUT. 0,5 L	4003669016500	469	0	469	1074
RECRAFT ORGANIC PILS PUSZKA 0,5 L	5900779755314	312	0	312	1075
BOON GUEUZE MARIAGE PARFAIT BUT. 0,75 L	5412783052872	281	0	281	1076
MOCZYBRODA LOVE WITH THE COCO BUT. 0,33 L	5903351761710	302	0	302	1077
STONE SPROCKETBIER BUT. 0,65 L	636251899003	220	0	220	1078
CHYLICZKI CYDR SZARA & ZЈOTA RENETA BUT. 0,33 L	5905279058316	316	0	316	1079
JAN OLBRACHT ЊMIETANKA BUT. 0,5 L	5904730284035	310	0	310	1080
ABBAYE OUBLI?E BUT. 0,75 L	5425006246354	204	0	204	1081
NEPOMUCEN BUDDIES PUSZKA 0,5 L	5904555992511	245	0	245	1082
ROCKMILL GALACTIC BROTHERHOOD: HOPPINESS BUT. 0,5 L	5908291862022	241	0	241	1083
AYINGER CELEBRATOR BUT. 0,33 L	4104170022025	212	0	212	1084
MOCZYBRODA NEKTAR BOGУW BUT. 0,5 L	5903351761208	583	0	583	1085
ZAKЈADOWY PSZENICA BUT. 0,5 L	5907753172235	302	0	302	1086
STU MOSTУW WILD #19 DOUBLE PEACH MIX FERMENTATION SAISON BUT. 0,375 L	5907614682958	239	0	239	1087
BROKREACJA SEA BREEZE PUSZKA 0,5 L	5904422197902	456	0	456	1089
BROKREACJA THE FIGHTER BUT. 0,5 L	5905669783248	255	0	255	1090
KINGPIN GORDITO PUSZKA 0,5 L	5904730290937	286	0	286	1091
PINTA Bluza bordowa XL	5904165100597	201	0	201	1092
CHYLICZKI CYDR ALWA BUT. 0,75 L	5905279058262	259	0	259	1093
MALTGARDEN WE GOT THE FIRE BUT. 0,5 L	5904050721623	228	0	228	1094
TOOL GLЦGGLICH RUM, RED WINE & PORT WINE BUT. 0,375 L	5711474008519	211	0	211	1095
GRIMBERGEN TRIPLE BUT. 0,33 L	5410263011661	282	0	282	1096
ALEBROWAR IMPERIAL HERR AXOLOTL CHERRY BUT. 0,5 L PROMOCJA (do 19.10.23)	\N	288	0	288	1097
CIESZYN PSZENICZNE BUT. 0,5 L	5905279156043	403	0	403	1098
ED RED KONSERWA RAGU ALLA BOLOGNESE	5903940086590	212	0	212	1099
GRODZISKIE BIAЈE BUT. 0,5 L	5905279533677	362	0	362	1100
SCHLENKERLA RAUCHBIER MДRZEN 13,5° BUT. 0,5 L	4037458000012	318	0	318	1101
RADUGA EAST OF EDEN PUSZKA 0,5 L	5902176771768	201	0	201	1102
STU MOSTУW TROPICAL GOSE BUT. 0,5 L	5907614681982	238	0	238	1103
PINTA Szklanka PM 2022 0,5 l	5904165102065	217	0	217	1104
LINDEMANS KOSZULA MКSKA (XL)	5123456791158	201	0	201	1105
BЈONIE HULAJ DUSZA PUSZKA 0,5 L	5908258856941	3628	0	3628	1106
MIЈOSЈAW PSZENICZNE BEZALKOHOLOWE BUT. 0,5 L	5902838991473	295	0	295	1107
TRZECH KUMPLI CALIFIA KEG 30 L	5123456789465	205	0	205	1108
TRZECH KUMPLI IMPERIAL BERLINER WEISSE  BUT. 0,5 L	5905669479769	354	0	354	1109
STU MOSTУW WILD #17 MIXED FERMENTATION SAISON WITH ZAPIAIN BUT. 0,375 L	5907614682835	238	0	238	1110
ALEBROWAR PAPA TWINS BUT. 0,5 L	5907771343426	320	0	320	1111
KINGPIN FREE RIDE PUSZKA 0,5 L	5904730290272	418	0	418	1113
DZIKI WSCHУD WILD WILD EAST - XMAS WILD ALE BUT. 0,375 L	5906874369913	231	0	231	1114
RADUGA CITRUS CITRUS BUTELKA 0,5 L	5902176771706	215	0	215	1115
CHERRY CHOUFFE BUT. 0,33 L	5410769800097	204	0	204	1116
TRZECH KUMPLI LAGER WIEDEСSKI KEG 30 L	\N	201	0	201	1117
ARTEZAN JASNE ROZUMIEM BUT. 0,5 L	5904708750593	207	0	207	1118
GOЊCISZEWO TRAGARZ BUT. 0,5 L	5903364108052	234	0	234	1119
PETRUS RED KIELICH 0,25 L	5123456791177	209	0	209	1120
MARYENSZTADT FREEKY MANGO ALE BUT 0,5 L	5903424615148	319	0	319	1121
TRZECH KUMPLI PAN IPANI PUSZKA 0,5 L	5904252699041	260	0	260	1122
STAROPOLSKIE KULTOWE PROZDROWOTNE 0,0% BUT. 0,5 L PROMOCJA (do 21.10.23)	\N	258	0	258	1123
AMBER CHMIELOWY BUT. 0,5 L	5906591001479	237	0	237	1124
P?HJALA LAAGER PUSZKA 0,44 L	4742976014082	210	0	210	1125
LINDEMANS APPLE KEG 20 L	5123456789028	207	0	207	1126
MAGIC ROAD PRETTY PINEAPPLE, MANGO, PINK GUAVA & PEANUT BUTTER PUSZKA 0,5 L	5905204130902	228	0	228	1127
RADUGA IS THIS JUST FANTASY? PUSZKA 0,5 L	5902176772000	525	0	525	1128
OUD BEERSEL GEUZE VANDERVELDEN 135 BUT. 0,375 L	5425018070404	332	0	332	1129
KINGPIN MARQUIS BUT. 0,33 L	5904730290555	216	0	216	1130
SVIJANY TACA	\N	202	0	202	1131
PRIMБTOR PREMIUM LAGER 12° KEG 30 L	5123456789917	204	0	204	1132
FORTUNA MIRABELKA BEZALKOHOLOWE BUT. 0,5 L	5902838990988	256	0	256	1133
PRAIRIE BOMB! DECONSTRUCTED: CACAO NIBS BUT. 0,355 L	680132989055	242	0	242	1134
DUBUISSON BUSH BLONDE TRIPLE BUT. 0,33 L	5411551310817	254	0	254	1136
PIWOTEKA PARУWKOWYM SKRYTOЇERCOM BUT. 0,5 L	5905669428118	212	0	212	1137
BOON OUDE KRIEK BUT. 0,375 L	5412783053862	253	0	253	1138
ARTEZAN JARDIN DU CHВTEAU CASSIS BUT. 0,375 L	5904708750630	294	0	294	1139
BIRBANT DRONIC PUSZKA 0,5 L	5904041703621	229	0	229	1140
NEPOMUCEN THE DARKNESS BUT. 0,5 L	5905191386061	240	0	240	1141
STAROPOLSKIE BESTBIR CYTRYNA BUT. 0,5 L	5903111989996	251	0	251	1142
RECRAFT JUICY SOUR SERIES – MANGO LASSI PUSZKA 0,5 L	5900779755901	262	0	262	1143
CANTILLON NATH BUT. 0,75 L	\N	231	0	231	1144
CHIMAY TRIPLE KEG 20 L	5123456789004	201	0	201	1145
GRYBУW PILSVAR ZERO BUT. 0,5 L	5902516001074	305	0	305	1146
CHIMAY RED BUT. 0,33 L	5410908000012	263	0	263	1147
P?HJALA ORANGE GOSE PUSZ. 0,33 L PROMOCJA (do 12.10.23)	\N	219	0	219	1148
LIEFMANS FRUITESSE BUT. 0,25 L	5411686700118	202	0	202	1149
ST. BERNARDUS DUЇA FLAGA	5123456791384	201	0	201	1150
INNE BECZKI MANGO JERRY BUT. 0,5 L	5903661280987	666	0	666	1151
KRAJAN IRLANDZKIE ZIELONE BUT. 0,5 L	5907804436071	795	0	795	1152
90 BPM GRODOUDOUBLE IPA KEG 30 L	\N	201	0	201	1153
MARYENSZTADT BARREL AGED ICE RYE RIS TIRAMISU RIOJA BA PUSZKA 0,44 L	5905669542531	212	0	212	1154
BAVARIA MALT BUT. 0,33 L	8714800003384	201	0	201	1155
ЈAСCUT IDZIE ZIMA BUT. 0,5 L	5906395997107	213	0	213	1156
PIWNE PODZIEMIE NOWOCZESNY PILS BUT. 0,5 L	5906874079409	391	0	391	1157
LUBROW ECLARON PILS PUSZKA 0,33 L	5903686842887	246	0	246	1158
TRZECH KUMPLI IMPERIAL GRAFF GRODZISKIE PUSZKA 0,5 L	5904252699843	349	0	349	1159
FUNKY FLUID GELATO: BUBLANINA PUSZKA 0,5 L	5903999514037	532	0	532	1160
FILOU BUT. 0,33 L	5411081006211	257	0	257	1161
FILOMELOS CYDR RУЇANIECKI BUT. 0,33 L	5900168509030	325	0	325	1162
BOON OUDE GUEUZE VAT 109 BUT. 0,375 L	5412783052933	270	0	270	1163
STU MOSTУW ART+69 MODERN SILLY SOUR MANGO-LIME-ORANGE PUSZKA 0,44 L	5907614683078	222	0	222	1164
MIKKELLER T-SHIRT S	5123456791372	201	0	201	1165
PINTA Czarna Dziura 13,0° but. 0,5 l PROMOCJA (do 05.11.23)	\N	630	0	630	1166
MOCZYBRODA ЇAR TROPIKУW BUT. 0,5 L	5903351761079	275	0	275	1167
TRZECH KUMPLI TRIPADELIC KEG 30 L	5123456789514	202	0	202	1168
PRZETWУRNIA CHMIELU ЈUSKA PUSZKA 0,5 L	5905476980557	272	0	272	1169
CIESZYN SZKLANKA SHAKER 0,5 L	5123456789849	291	0	291	1170
PINTA BARREL BREWING AUTHORITY 15,0° BUT. 0,375 L	5904335577655	201	0	201	1171
FLORIS FRAMBOISE BUT. 0,33 L	5412186001217	234	0	234	1172
NEPOMUCEN MORE HOPS & MORE FOREST PUSZKA 0,5 L	5905191386498	236	0	236	1173
VIGO Kombucha BIO Mango Marakuja but. 0,33 l	5902768514186	307	0	307	1174
NEPOMUCEN WALKING KEYS PUSZKA 0,5 L	5905701060078	353	0	353	1175
DZIKI WSCHУD DZIEWCZYNA SZAMANA BUT. 0,5 L	5906874369197	331	0	331	1176
LES INTENABLES MANU MILITARI BIERE PUSZ. 0,33 L	3770017907445	205	0	205	1177
WRКЇEL BOWMORE BARREL AGED BUT. 0,33 L	5904730465038	221	0	221	1178
STAROPOLSKIE BESTBIR CZEKOLADA Z POMARAСCZҐ BUT. 0,5 L	5903021500236	318	0	318	1179
NEPOMUCEN THE HEDGEHOG PUSZKA 0,5 L	5905701060337	549	0	549	1180
ALEBROWAR ROWING JACK BUT. 0,5 L	5907222039083	575	0	575	1181
RECRAFT MC FARMER BUT. 0,5 L	5904730663052	396	0	396	1182
DUGGES ELECTRO PUSZKA 0,33 L	7350038226297	204	0	204	1183
BROKREACJA WHERE IS LEITMOTIV? GUAVA-ANANAS BUT. 0,5 L	5904422197926	535	0	535	1184
SCHNEEEULE JOHNS TAGE BUT. 0,75 L	\N	205	0	205	1185
O'HARA'S SESSION IPA BUT. 0,5 L	5391500602111	250	0	250	1187
CIESZYN SZKLANKA WEIZEN 0,5 L	5123456789851	218	0	218	1188
BIRBANT PORTER BAЈTYCKI KLASYCZNY BUT. 0,5 L	5903240620470	263	0	263	1189
MAGIC ROAD SUNRISE PUSZKA 0,5 L PROMOCJA (do 15.10.23)	\N	225	0	225	1190
MOON LARK SHELTER. GERMAN PILS PUSZKA 0,5 L	5905255346185	459	0	459	1191
BIAЈY ARIZONA DREAM BUT. 0,5 L	5903246576290	201	0	201	1192
LHG TORBA	5123456791357	202	0	202	1193
CANTILLON KRIEK-LAMBIC  KEG 20L	5123456789013	202	11	202	1194
PRZETWУRNIA CHMIELU POMPA PUSZKA 0,5 L	5905476980670	210	0	210	1195
PIWOJAD SUSKA BUT. 0,5 L	5906395053001	201	0	201	1196
MIO MIO LEMON BUT. 0,5 L	4002846038915	323	0	323	1197
TRZECH KUMPLI WONDER HAZE KEG 30 L	5123456789640	201	0	201	1198
P?HJALA ЦЦ XO BUT. 0,33 L	4742976010794	221	0	221	1199
IMBIOROWICZ MIУD PITNY DWУJNIAK MALINOWY BUT. 0,375 L	5905669820615	234	0	234	1200
MONVIN KIELISZEK 0,1 L	5123456791449	217	0	217	1186
DEER BEAR RAMEN SHOP BUT. 0,5 L	5903678460013	215	0	215	1201
BACCHUS THUR POKAL 0,5 L	5123456791336	207	0	207	1202
ST. FEUILLIEN BLONDE BUT. 0,33 L	5412138103310	338	0	338	1203
LINDEMANS PODSTAWKA NA PODKЈADKI	5123456791327	235	0	235	1204
VAL-DIEU BRUNE BUT. 0,33 L	5413977000020	271	0	271	1205
TRZECH KUMPLI TAURA PUSZKA 0,5 L	5904252699607	270	0	270	1206
FISCHER BLONDE BUT. 0,65 L PROMOCJA (do 30.09.23)	\N	235	0	235	1207
PINTA Party Starter NZ Pale Ale 12,0° keg 30 l	\N	201	0	201	1208
RODENBACH CLASSIC BUT. 0,25 L	54125001	793	0	793	1209
RACIBORSKIE PYRSK JABЈKO-GRANAT BUT. 0,33 L	5905249834100	217	0	217	1210
BOON KIELISZEK TULP 0,25 L	5123456791166	237	0	237	1211
SMYKAN CYDR KRONSELKA/ANTONУWKA KEG 30 L	\N	203	0	203	1212
LUBROW SOURHEAD MONKEY PUSZKA 0,33 L	5903686842948	274	0	274	1213
TRZECH KUMPLI WEIZEN BUT. 0,5 L	5905669479394	617	0	617	1214
MOCZYBRODA POPART #12 DOPPEL RAUCHBOCK BUT. 0,5 L	5901087374594	244	0	244	1215
DZIKI WSCHУD NESSO PUSZKA 0,5 L	5906874369500	250	0	250	1216
ЈAСCUT PODBIPIКTA PORTER IMPERIALNY BOURBON B.A. BUT. 0,33 L	5906395997633	232	0	232	1217
KAZIMIERZ ЇYTKO BUT. 0,5 L	5906660570059	381	0	381	1218
CHYLICZKI GRAFF NO. 2 KEG 30 L	\N	201	0	201	1219
TIMMERMANS OUDE GUEUZE BUT. 0,375 L	5411516002306	251	0	251	1220
JAN OLBRACHT POMARAСCZARNIA BUT. 0,5 L	5904730284660	369	0	369	1221
STAROPOLSKIE THE ART OF HOPPING WAKATU ORGANIC SINGLE HOP AMBER ALE BUT. 0,5 L	5903021505712	366	0	366	1222
MOCZYBRODA MOTHER OF DRAGONS GUANABANANA EDITION BUT. 0,5 L	5903351761444	288	0	288	1223
GUMMARUS POKAL 0,33 L	5123456791085	266	0	266	1224
LUBROW LIGHTHOUSE IPA PUSZKA 0,33 L	5903686842900	257	0	257	1225
BUSH KIELICH 0,33 L	5123456791190	203	0	203	1226
WIDAWA LATO CZEKA BUT. 0,5 L	5907710904053	420	0	420	1227
VITAMINE SEA CLOWNING AROUND PUSZKA 0,473 L	5123456790118	204	0	204	1228
LINDEMANS / MIKKELLER SPONTANBASIL BUT. 0,75 L	5411223010571	299	0	299	1229
PINTA Koszulka їуіta S	5904165100467	201	0	201	1230
ALEBROWAR IMPERIAL HERR AXOLOTL BLACK CURRANT BUT. 0,5 L PROMOCJA (do 20.10.23)	\N	313	0	313	1231
PIWNE PODZIEMIE CHMIELOKRATA CASHMERE PUSZKA 0,5 L	5904305482781	222	0	222	1232
STAROPOLSKIE BESTBIR KIWI BUT. 0,5 L	5903021505606	444	0	444	1233
INNE BECZKI DEEZ NUTS PUSZKA 0,5 L	5903661281557	230	0	230	1234
REVOLTA LEMON & EARL GREY AIPA BUT. 0,5 L	5900470058004	645	0	645	1235
DUVEL ЊWIATЈO ROWEROWE	\N	205	0	205	1236
ALEBROWAR KWAS CHLEBOWY BUT. 0,33 L	5907771340012	211	0	211	1237
DUGGES JUICY FRUITY PUSZKA 0,5 L	7350038227607	237	0	237	1238
MIЈOSЈAW CYDR MIЈOSЈAWSKI PУЈSЈODKI BUT. 0,5 L	5901687910307	343	0	343	1239
P?HJALA SUN CITY PUSZKA 0,44 L	4742976015133	241	0	241	1240
BOSTEELS PAUWEL KWAK BUT. 0,75 L	5410228285182	223	0	223	1241
STAROPOLSKIE THE ART OF HOPPING WARRIOR SINGLE HOP WEST COAST IPA BUT. 0,5 L	5903021505743	271	0	271	1242
PIWNE PODZIEMIE JUICILICIOUS KEG 30 L	5123456789399	204	0	204	1243
BROKREACJA PARIS SYNDROME 2 BOURBON BARREL AGED BUT. 0,33 L	5907610243757	274	0	274	1244
MARYENSZTADT SOURTIME PASTRY SOUR RED CURRANT & CHERRY BUT. 0,5 L PROMOCJA (do 05.10.23)	\N	225	0	225	1245
DZIK CYDR PУЈSЈODKI BUT. 0,5 L	5906395413485	655	0	655	1246
ZA MIASTEM BЈOGI NASTRУJ BUT. 0,5 L	5904905630131	604	0	604	1247
LA CHOUFFE BLANCHE BUT. 0,33 L	5410769800820	510	0	510	1248
INNE BECZKI SPILL THE TEA BUT. 0,5 L	5901122234173	356	0	356	1249
O’SO THE CONTINENTAL BUT. 0,75 L	892370002810	207	0	207	1250
BOON GEUZE SZKLANKA  0,25 L	5123456791050	221	0	221	1251
STAROPOLSKIE PORTER IRISH COFFEE BUT. 0,5 L	5903021503299	249	0	249	1252
ST. BERNARDUS WATAU KIELICH  0,25 L	5123456791175	221	0	221	1253
SMYKAN CYDR RENETY 2022 KEG 30 L	\N	206	0	206	1254
TRZECH KUMPLI BLACKCYL PUSZKA 0,5 L	5904252699423	300	0	300	1255
PINTA PORTERMASS Smoked Plum & Coco Nibs 30,0° but. 0,33 l	5904165103512	201	0	201	1256
ZIEMIA OBIECANA TRIPLE LE SZEF PUSZKA 0,5 L	5905186484734	269	0	269	1257
INNE BECZKI WAKE & BAKE BUT. 0,5 L	5903661281069	680	0	680	1258
PIWNE PODZIEMIE APRICOT GOSE PUSZKA 0,5 L	5904305482804	259	0	259	1259
PINTA Barrel Brewing Enology 2023 but. 0,75 l	5904335577570	209	0	209	1260
BIRBANT GUILTY PLEASURE PUSZKA 0,5 L PROMOCJA (do 07.10.23)	\N	402	0	402	1261
BALADIN XYAUYU BARREL 2017 BUT. 0,5 L	8032942290548	252	0	252	1262
PINTA Psst... It's Your Weekend IPA - Cold IPA 15,0° keg 30 l	5123456780030	201	0	201	1263
RECRAFT JUICE SOUR SERIES – BLACK FRUITS PUSZKA 0,5 L	5904730663793	462	0	462	1264
LEELANAU / EVIL TWIN / JOLLY PUMPKIN THE DOGMATIST BUT. 0,375 L	5123456790146	205	0	205	1265
TRZECH KUMPLI PAN IPANI DOUBLE BUT. 0,5 L	5905669479257	567	0	567	1266
MIKKELLER SPONTAN CASSIS BUT. 0,375 L	818534013119	215	0	215	1267
MIKKELLER SPONTAN LEMON BUT. 0,375 L	818534020865	221	0	221	1268
O'HARA'S IRISH STOUT BUT. 0,5 L	5391500600032	511	0	511	1269
SMYKAN CYDR ANTONI WISIENKA KEG 30 L	5123456791293	204	0	204	1270
DUVEL 6.66 PODKЈADKI	5123456789852	5000	0	5000	1271
ZA MIASTEM SMAK WAKACJI BUT. 0,5 L	5904905630148	216	0	216	1272
NEPOMUCEN NACHMIELONA CHMIEL+JABЈKO+CYTRYNA BUT. 0,5 L	5905279959552	299	0	299	1273
DE MOLEN FRUIT & KRUID BUT. 0,33 L	8717624420412	308	0	308	1274
LINDEMANS CASSIS MEDALION RYBIE OKO	\N	201	0	201	1275
GULDEN DRAAK KEG 5 L	\N	205	0	205	1276
NEPOMUCEN CULTO KWAS PUSZKA 0,5 L	5905701060153	245	0	245	1277
CIESZYN NOSZAK BUT. 0,5 L	5905279156852	209	0	209	1278
CIESZYN PORTER BAЈTYCKI BUT. 0,5 L	5905279156104	413	0	413	1279
LINDEMANS BEARDY HIPSTER T-SHIRT (S)	5123456791146	202	0	202	1280
KORMORAN BEZGLUTENOWE BUT. 0,5 L	5902528442230	513	0	513	1281
RACIBORSKIE MIODOWE ZW BUT. 0,5 L	5907506252085	345	0	345	1282
FILOMELOS CYDR WYTRAWNY BUT. 0,75 L	5900168509016	239	0	239	1283
LUBROW TRDELNIK PUSZKA 0,33 L	5903686842726	224	0	224	1284
MARYENSZTADT KLASYCZNIE POLSKI LAGER BUT. 0,5 L	5905669542395	262	0	262	1285
ZAKЈADOWY Z FARTEM MORDECZKO KEG 30 L	\N	201	0	201	1286
FUNKY FLUID GELATO: GIALLO PUSZKA 0,5 L	5903999514792	532	0	532	1287
MOON LARK TUNE UP. KELLERBIER PUSZKA 0,5 L	5905255346444	339	0	339	1288
RACIBORSKIE PYRSK JABЈKO-POMARAСCZA-IMBIR BUT. 0,33 L	5905249834070	277	0	277	1289
LINDEMANS FRAMBOISE TAP HANDLE	5123456791359	203	0	203	1290
MIЈOSЈAW & MAKЈOWICZ ARCY IPA BUT. 0,5 L	5902838991343	675	0	675	1291
BЈONIE KALINA MALINA BUT. 0,5 L	5908258856125	515	0	515	1292
ARTEZAN TOO YOUNG TO BE HEROD BUT. 0,5 L	5904730574006	209	0	209	1293
GOЊCISZEWO RYCERZ BUT. 0,5 L	5903364108014	225	0	225	1294
GULDEN DRAAK BUT. 0,33 L	5411663002716	1864	0	1864	1295
ALEBROWAR CRAZY MIKE BUT. 0,5 L	5903364108359	530	0	530	1296
TIMMERMANS OUDE KRIEK BUT. 0,375 L	5411516002269	239	0	239	1297
PINTA Barrel Brewing Liberty 2023 but. 0,33 l	5904335577075	239	0	239	1298
ALEBROWAR BE LIKE MITCH BUT. 0,5 L	5903364108496	286	0	286	1299
DUGGES 9+9 SOUR PUSZKA 0,5 L	7350038227706	220	0	220	1300
ST. BERNARDUS ABT 12 BUT. 0,33 L	54079021	900	0	900	1301
PINTA IIPPAA 18,0° keg 20 l	5123456789722	202	0	202	1302
TRZECH KUMPLI NESTA PUSZKA 0,5 L	5904252699652	265	0	265	1303
TRZECH KUMPLI GOEDEMORGEN KEG 30 L	5123456789476	201	0	201	1304
DEER BEAR DEER BEARD BUT. 0,5 L	5906395303335	223	0	223	1305
PINTA BARREL BREWING SEED 12,0° BUT. 0,750 L	5904335577648	213	0	213	1306
PINTA Party'23 Collab 12,0° keg 30 l	5123456780023	206	0	206	1307
PRAIRIE FUNKY GOLD MOSAIC BUT. 0,5 L	894776000995	208	0	208	1308
ICE BREAKER CARPOOL KARAOKE KEG 30 L PROMOCJA (do 09.09.23)	\N	201	0	201	1309
DZIK CYDR MARAKUJA 0% BUT. 0,5 L	5906395413515	1074	0	1074	1310
ST. BERNARDUS WATOU TRIPEL BUT. 0,33 L	54079045	240	0	240	1311
PINTA Koszulka biaіa L	5904165100436	202	0	202	1312
PINTA / Sibeeria Cold's Cool 13,0° can 0,5 l	8596301014331	1284	0	1284	1313
JURAJSKIE MOJITO BUT. 0,5 L	5905331026642	445	0	445	1314
DUVEL POKAL 0,33 L	5123456791095	351	0	351	1315
PETRUS MATA BAROWA	5123456791375	201	0	201	1316
ЈAСCUT ZAPOMNIANY DIABEЈ BUT. 0,33 L	5906395997879	273	0	273	1317
KORMORAN COPERNIKUS BUT. 0,5 L	5902528000157	216	0	216	1318
TANKBUSTERS THIRD BIRTHDAY AND HOMIES X MOONLARK PUSZKA 0,5 L	5904365781473	285	0	285	1319
MARYENSZTADT NEW BLACK - OAT STOUT CZEKOLADOWA PRALINA Z WIЊNIҐ BUT. 0,5 L	5903424615933	215	0	215	1320
PINTA A ja pale ale 12,0° keg 30 l	5123456789653	216	0	216	1321
AYINGER JAHRHUNDERT BIER BUT. 0,5 L	4104170022209	288	0	288	1322
RECRAFT POLSKA PSZENICA BUT. 0,5 L	5904730663113	296	0	296	1323
GEKKO BEERS INTO THE THICK OF IT PUSZ. 0,44 L	3770011188178	202	0	202	1324
ZA MIASTEM 5TH ELEMENT ALCOHOL FREE APA BUT. 0,5 L	5904905630193	757	0	757	1325
OMNIPOLLO SZKLANKA 0,3 L	5123456791109	208	0	208	1326
MARYENSZTADT SMOOTHIE BEER SWEET MANGO-COCONUT-ORANGE-VANILLA-WHITE CHOCOLATE PUSZKA 0,5 L	5903424615537	257	0	257	1327
GWAREK A HUNDRED PERCENT OF...MOSAIC PUSZKA 0,5 L	5903938751714	240	0	240	1328
TIMMERMANS PECHE BUT. 0,25 L	5411516010905	205	0	205	1329
HOUBLON CHOUFFE BUT. 0,33 L	5410769300085	437	0	437	1330
ST. BERNARDUS ZESTAW (4X 0,33 L + SZKЈO)	5411911003540	264	0	264	1331
KASTEEL BRIGAND BUT. 0,33 L	5411081000332	284	0	284	1332
LA TRAPPE BLONDE BUT. 0,33 L	8711406032602	472	0	472	1333
SCHLENKERLA RAUCHBIER FASTENBIER VINTAGE 2018 BUT. 0,5 L	4037458000166	207	0	207	1334
BROKREACJA TUK TUK BUT. 0,5 L	5904422197834	219	0	219	1335
VAL-DIEU CUVEE 800 BUT. 0,33 L	5413977000945	272	0	272	1336
DUCHESSE DE BOURGOGNE BUT. 0,75 L	5411364151300	217	0	217	1337
PINTA Koszulka їуіta XL	5904165100498	202	0	202	1338
CHYLICZKI GRAFF NO. 2 BUT. 0,5 L	5905279058255	308	0	308	1339
MARYENSZTADT OAT WINE BLENDED SINGLE MALT WHISKY BUT. 0,33 L	5905669542920	214	0	214	1340
TRZECH KUMPLI SZKLANKA NONIC 0,5 L	5123456791265	202	2	202	1341
CA' DEL BRADO ANNIVERSARIO 2021 BUT. 0,375 L	5123456790123	202	0	202	1342
PINTA Koszulka szara XL	5904165101280	202	0	202	1343
FUNKY FLUID FULL CLIP BUT. 0,5 L	5903999514327	212	0	212	1344
STU MOSTУW WAKE-UP CALL IMPERIAL BALTIC PORTER BBA (COCONUT & PALO SANTO) BUT. 0,33 L	5907614682712	215	0	215	1345
ROCHEFORT TRAPPISTES 10* BUT. 0,33 L	5412858000104	454	0	454	1346
DEER BEAR LET'S COOK - GUAVA PUSZKA 0,5 L	5905204172193	430	0	430	1347
CA' DEL BRADO U BACCAROSSA - ITALIAN GRAPE ALE BUT. 0,375 L	5123456790120	210	0	210	1348
WRКЇEL VIVA ESPANA ONE PUSZKA 0,5 L PROMOCJA (do 20.10.23)	\N	233	0	233	1349
ZAKЈADOWY Z FARTEM MORDECZKO BUT. 0,5 L	5907753172273	282	0	282	1350
JAN OLBRACHT CУRA KORYNTU BUT. 0,5 L	\N	205	0	205	1351
MIKKELLER SPONTAN APRICOT BUT. 0,375 L	818534015748	221	0	221	1352
KEG INBEV 20L	5123456792007	280	0	280	1353
3 FONTEINEN FROMBOZENLAMBIK OOGST 2019/20 BUT. 0,375 L	5425007818611	223	0	223	1354
ZAKЈADOWY ALE TO TY DZWONISZ BUT. 0,5 L	5907753172280	235	0	235	1355
DUBUISSON RASTA TROLLS BUT. 0,33 L	5411551171074	236	0	236	1356
GOLEM SZKЈO FIRMOWE 0,3 L	5123456791225	222	0	222	1357
PINTA Koszulka HC czarna XL	5904165103017	202	0	202	1358
ROCHEFORT TRAPPISTES 8* BUT. 0,33 L	5412858000081	410	0	410	1359
PINTA Modern Drinking 15,0° keg 20 l	5123456789741	204	0	204	1360
GRODZISKIE BEZALKOHOLOWE MANGO ALE BUT. 0,5 L	5905279533554	635	0	635	1361
RODENBACH ROSSO SZKLANKA 0,5 L	5123456791031	208	0	208	1362
SVIJANY KUFEL SZKLANY 0,5 L	\N	222	0	222	1363
ALEBROWAR HOP SASA BUT. 0,5 L	5907771343730	300	0	300	1364
RACIBORSKIE PSZENICZNE BUT. 0,5 L	5907506252450	279	0	279	1365
SOWIE PSZENICZNE MANGO I MARAKUJA BUT. 0,5 L	5907222560228	361	0	361	1366
LINDEMANS FRAMBOISE KEG 25 L	\N	204	0	204	1367
BIRRA MANIA SEXY ARANCIA APA BUT. 0,33 L	5907694918428	252	0	252	1368
PINTA Barrel Brewing Enology 2023 but. 0,375 l	5904335577365	227	0	227	1369
BOON OUDE GUEUZE BUT. 0,375 L	5412783052841	373	0	373	1370
JURAJSKIE SЈODKIE CYTRYNY BUT. 0,5 L	5905331026994	410	0	410	1371
MARYENSZTADT THE ROOTS#5 PUSZKA 0,5 L	5905669542074	216	0	216	1372
DUGGES DAYDREAM PUSZKA 0,33 L	7350038228390	219	0	219	1373
DELIRIUM RED BUT. 0,75 L	5412186003495	217	0	217	1374
BRUGSE ZOT BLONDE BUT. 0,75 L	5425017240044	223	0	223	1375
SCHNEIDER TAP03 ALKOHOLFREE BUT. 0,5 L	4003669016906	1195	0	1195	1376
DELIRIUM TREMENS BUT. 0,75 L	5412186000043	288	0	288	1377
PRZETWУRNIA CHMIELU TWIST #3 WIЊNIA PUSZKA 0,5 L	5905476980533	261	0	261	1378
BROKREACJA THE DANCER BUT. 0,5 L	5905669783279	240	0	240	1379
KORMORAN 6-PAK ЊWIEЇE BUT. 0,375 L PROMOCJA (do 10.10.23)	\N	231	0	231	1380
TRZECH KUMPLI PORTER BAЈTYCKI KEG 30 L	5123456789501	201	0	201	1381
CZTERY ЊCIANY REWIR PUSZKA 0,5 L	5905108498849	212	0	212	1382
LINDEMANS MAЈA TABLICA	5123456791127	207	0	207	1383
STU MOSTУW AMERICAN UNCLE PUSZKA 0,44 L PROMOCJA (do 10.10.23)	\N	201	0	201	1384
ЈAСCUT RAJSKY PLYN BUT. 0,5 L	5906395997473	293	0	293	1385
BOON KRIEK BUT. 0,375 L	5412783053848	360	0	360	1386
KAZIMIERZ MR. SHERMAN BUT. 0,5 L	5906660570349	309	0	309	1387
O'HARA'S LEANN FOLLAIN K-KEG 30 L	5123456791279	203	0	203	1388
JAN OLBRACHT LEGENDY POLSKIE: STRZYGA BA BUT. 0,33 L	5902627012228	203	0	203	1389
TRZECH KUMPLI GOSE MANGO MARAKUJA BUT. 0,5 L	5905669479752	488	0	488	1390
DU BOCQ BLANCHE DE NAMUR SZKLANKA 0,33 L	5123456791051	288	0	288	1391
ALEBROWAR VANILLA PASSION BUT. 0,5 L	5907771343792	340	0	340	1392
BIRBANT ACADIA PUSZKA 0,5 L	5904041703850	636	0	636	1393
BIRBANT WEIZEN MANGO BUT. 0,5 L	5903240620524	620	0	620	1394
KAZIMIERZ MUSZKIETEROWIE BUT. 0,5 L	5906660570585	220	0	220	1395
STAROPOLSKIE THE ART OF HOPPING TRISKEL SINGLE HOP IPA BUT. 0,5 L	5903021505132	260	0	260	1396
TRZECH KUMPLI UNPLUGGED CITRUS APA 0,0% PUSZKA 0,5 L	5904252699805	370	0	370	1397
GAULOISE BLACHA REKLAMOWA	5123456791366	201	0	201	1398
CZTERY ЊCIANY REWIR BUT. 0,5 L	5905108498856	310	0	310	1399
BOON GUEUZE MARIAGE PARFAIT BUT. 0,375 L	5412783052865	386	0	386	1400
BRUNEHAUT KIELISZEK 0,25 L	5123456791165	212	0	212	1401
O'HARA'S WHITE HAZE BUT. 0,5 L	5391500601954	245	0	245	1402
MIKKELLER SPONTAN ELDERFLOWER BUT. 0,375 L	5704255115612	229	0	229	1403
SCHLENKERLA RAUCHBIER URBOCK 17,5° PARTY-FASS 5 L PROMOCJA (do 31.08.23)	\N	201	0	201	1404
PALM GREEN NA BUT. 0,25 L	5410783031019	405	0	405	1405
NEPOMUCEN HIGHWAY BUT. 0,5 L	5907709756083	658	0	658	1406
P?HJALA - STILLWATER RANNAK PUSZKA 0,33 L	4742976016215	244	0	244	1407
ED RED KONSERWA CHILI CON CARNE	5904083584035	210	0	210	1408
SMYKAN CYDR GROCHУWKA KEG 30 L	5123456791299	202	0	202	1409
DZIKI WSCHУD POMA RANCZO BUT. 0,5 L	5906874369579	295	0	295	1410
LITOVEL PЉENIИNЭ LEЋБK 11° KEG 30 L	5123456789886	203	0	203	1411
STU MOSTУW IMPERIAL PASTRY STOUT COCOA NIBS, COOKIES AND WHITE CHOCOLATE PUSZKA 0,44 L	5907614681722	426	0	426	1412
MONVIN ROSE FRIZZANTE KEG 20 L	8013651024792	205	0	205	1413
KWAREMONT PITTING BLOND BUT. 0,33 L	5411831000957	209	0	209	1414
MOCZYBRODA BERRYLICIOUS DELIGHT PUSZKA 0,5 L	5904673801085	248	13	248	1415
AMBER BEZALKOHOLOWE IPA BUT. 0,5 L	5906591002520	265	0	265	1416
TRZECH KUMPLI FULL MOSAIC KEG 30 L	\N	201	0	201	1417
KEG PERFECTDRAFT 6L	5123456792000	369	0	369	1418
TRZECH KUMPLI PILS PUSZKA 0,5 L	5904252699072	311	0	311	1419
PINTA RISFACTOR Cinnamon and Cocoa Nibs 30,0° keg 20 l	5123456789908	201	0	201	1420
GRYBУW PILSVAR KONOPNIAK BUT. 0,5 L	5902516011400	345	0	345	1421
PINTA Beskidy Pils 12,0° but. 0,5 l	5904730438926	1650	0	1650	1422
KINGPIN PILS BUT 0,5 L	5904730290692	238	0	238	1423
ZA MIASTEM CHWILA SPOKOJU BUT. 0,5 L	5904905630155	219	0	219	1424
BROWAR JANA ZESTAW 2 x BUT. 0,5 L	\N	219	0	219	1425
NOOK FIGARBO BUT. 0,33 L	5903240848386	221	0	221	1426
MOCZYBRODA FULL TIME HEAVEN PUSZKA 0,5 L	5904673800767	220	0	220	1427
MARYENSZTADT BEZGLUTENOWY JASNY LAGER BUT. 0,5 L	5903678022020	311	0	311	1428
BROKREACJA SAVAGE 003 BUT. 0,5 L	5904422197056	227	0	227	1429
DEER BEAR LET'S COOK APRICOT-LIME PUSZKA 0,5 L	5906395303069	282	0	282	1430
DUVEL TRIPLE HOP CITRA BUT. 0,33 L	5411681401164	752	0	752	1431
GRYBУW PILSVAR STAROSҐDECKIE BUT. 0,5 L	5902516000688	276	0	276	1432
GRIMBERGEN BLONDE BUT. 0,33 L	5410263015669	354	0	354	1433
NEPOMUCEN NEPO FINEST – ROYAL FORTUNE BUT. 0,375 L	5905191386603	206	0	206	1434
FUNKY FLUID LECKER BUT. 0,5 L	5903999514310	256	0	256	1435
FORTUNA ЊLIWKOWA BUT. 0,5 L	5901687910161	319	0	319	1436
TRZECH KUMPLI RAGNAR PUSZKA 0,33 L	5904252699577	236	0	236	1437
CIESZYN RYE WINE BUT. 0,33 L	5907612240235	258	0	258	1438
SCHNEIDER WEISSE SZKLANKA 0,3 L	5123456791258	224	0	224	1439
SPECIATION SANGRIA INCIPIENT PUSZKA 0,473 L	5123456790110	254	0	254	1440
NEPOMUCEN JOURNEY TO TO THE VALLEY VOL.2 BUT. 0,5 L	5905701060252	647	0	647	1441
LINDEMANS PECHERESSE TAP HANDLE	5123456791013	203	0	203	1442
RADUGA METROPOLIS BUT. 0,5 L	5907431705083	255	0	255	1443
PINTA Koszulka szara L	5904165101273	202	0	202	1444
STU MOSTУW CHERRY ME PUSZKA 0,33 L	5907614682453	281	0	281	1445
PINTA Collab PL: Cztery Њciany 15,0° keg 30 l	5123456780041	201	0	201	1446
AMBER KOЏLAK BUT. 0,5 L	5906591000540	386	0	386	1447
PINTA T-shirt zielony duїe logo M	5904165102553	202	0	202	1448
PETRUS RED TAP HANDLE	5123456791377	201	0	201	1449
RADUGA GOOD DAY! PUSZKA 0,5 L	5902176772031	264	0	264	1450
PIWNE PODZIEMIE PERMANENT VACATION KEG 30 L	\N	201	0	201	1451
KASTEEL MATA BAROWA (5X KASTEEL)	5123456791346	208	0	208	1452
SCHLENKERLA RAUCHBIER MДRZEN 13,5° PARTY-FASS 5 L	4037458100200	206	0	206	1453
MONGOZO BANANA BUT. 0,33 L	8715608000025	227	0	227	1454
RECRAFT POLISH HAZY IPA AMORA PRETA & KSIҐЇКCY PUSZKA 0,5 L	5904730663779	337	0	337	1455
HOEGAARDEN SZKLANKA  0,25 L	5123456791046	206	0	206	1456
DUGGES LUXURY PUSZKA 0,5 L	7350038226839	201	0	201	1457
NEPOMUCEN RAJ PUSZKA 0,5 L	5905701060054	295	0	295	1458
PETRUS BLACHA REKLAMOWA	5123456791101	207	0	207	1459
MOERSLEUTEL 6Y MARGREET PUSZKA 0,44 L	8720615260522	201	0	201	1460
SOWIE PSZENICZNE BUT. 0,5 L	5907222560037	302	0	302	1461
LINDEMANS CASSIS K-KEG 20 L	\N	212	0	212	1462
KORMORAN REWOLUCJE WARMIСSKIE BUT. 0,5 L	5902528999994	225	0	225	1463
LINDEMANS BLACHA	5123456791142	220	0	220	1464
PINTA Collab Dois Corvos - Magnetic Poles 22,0° can 0,44 l	5600701480467	201	0	201	1465
MOON LARK REEF. HAZY IPA PUSZKA 0,5 L	5905255346048	367	0	367	1466
TARNOBRZEG SZKLANKA NONIC 0,5 L	5123456791455	212	0	212	1467
PETRUS NITRO CHERRY CHOCO BUT. 0,33 L	875213001522	495	0	495	1468
ST. BERNARDUS EXTRA 4 BUT. 0,33 L	5411911001782	353	0	353	1469
LINDEMANS NEON	5123456791136	205	0	205	1470
MIO MIO MATE IMBIR BUT. 0,5 L	4002846034689	649	0	649	1471
DUGGES BIG BLACK VIOLET PUSZKA 0,5 L	7350038226402	220	0	220	1472
LA CHOUFFE BLONDE BUT. 0,33 L	5410769100081	1368	0	1368	1473
PINTA T-shirt biaіy duїe logo L	5904165102461	202	0	202	1474
ARTEZAN TRENDING UP BUT. 0,5 L	5904708750722	293	0	293	1475
DU BOCQ BLANCHE DE NAMUR T-SHIRT	5123456791022	201	0	201	1476
REVOLTA ORANGE & YERBA MATE AIPA  BUT. 0,5 L	5900470071003	594	0	594	1477
DZIKI WSCHУD WOLNY DUCH BUT. 0,5 L	5906874369340	228	0	228	1478
PINTA Szklanka Atlantik 0,3 l	5904165100955	251	0	251	1479
ED RED POTRAWKA Z PIECZARKAMI Z KASZҐ GR - KURCZAK	5904083584141	210	0	210	1480
PINTA Beskidy Prawdziwe Ciemne 13,0° but. 0,5 l	5904730438995	1607	0	1607	1481
SARABANDA LIQUID FORMS PUSZKA 0,5 L PROMOCJA (do 05.10.23)	\N	283	0	283	1482
KOMES PORTER BAЈTYCKI PЈATKI DКBOWE BUT. 0,5 L	5901687910826	313	0	313	1483
MIKKELLER NELSON SAUVIN ORANGE & PASSIONFRIUT BUT. 0,75 L	818534024733	204	0	204	1485
MIKKELLER PUMA BOKSERKA SPORTOWA NIEBIESKA  (XL)	5123456791122	202	0	202	1486
MARYENSZTADT THE ROOTS#10 PUSZKA 0,5 L PROMOCJA (do 19.10.23)	\N	205	0	205	1487
TRZECH KUMPLI CALIFIA BUT. 0,5 L	5905669479264	294	0	294	1488
ALEBROWAR SINGLE HOP VERMELHO HAZY APA BUT. 0,5 L	5907771343419	239	0	239	1489
CA' DEL BRADO CUVЙE DE KIWI - KIWI SOUR ALE BUT. 0,375 L	\N	207	0	207	1490
THE BRUERY 11 PIPERS PIPING BUT. 0,75 L	718122104338	202	0	202	1491
SCHNEIDER TAP07 ORIGINAL KEG 20 L	2100006B234B9	213	0	213	1492
SCHNEIDER TAPX CUVEE BARRIQUE 21,5° BUT. 0,75 l	4003669022778	208	0	208	1493
MOON LARK OUTDOOR. HAZY DIPA PUSZKA 0,5 L	5905255346475	316	0	316	1494
LERVIG KONRADS STOUT PUSZKA 0,33 L	7072712000763	203	0	203	1495
GRODZISKIE PIWO Z GRODZISKA BUT. 0,5 L	5905279533264	274	0	274	1496
ST. BERNARDUS TRIPEL BUT. 0,75 L	5411911001492	259	0	259	1497
PINTA Hop Selection - Sabro can 0,5 l	5904165104779	218	0	218	1498
GRIMBERGEN FENIKS POKAL 0,25 L	5123456791091	209	0	209	1499
CIESZYN PILSNER KEG 30 L	\N	217	0	217	1500
RODENBACH GRAND CRU BUT. 0,75 L	5410583800181	404	0	404	1501
PINTA Bluza czarna XXL	5904165100559	201	0	201	1502
PINTA Beskidy Pszeniczne 13,0° but. 0,5 l	5904730438933	830	0	830	1503
DELIRIUM NOCTURNUM BUT. 0,75 L	5412186000722	240	0	240	1504
P?HJALA MUST KULD PUSZKA 0,33 L	4742976013764	220	0	220	1505
BROKREACJA RED SUN PUSZKA 0,5 L	5904422197872	201	0	201	1506
P?HJALA BALTIC PORTER DAY BA 2022 BUT. 0,33 L	4742976015829	247	0	247	1507
DUGGES PARADISI PUSZKA 0,33 L	7350038227171	213	0	213	1508
PIWOTEKA BARON OSTRКЇYСSKI  BUT. 0,5 L	5905669428088	246	0	246	1509
LUBROW SЈODOWY PUSZKA 0,33 L	5903686842702	262	0	262	1510
MARYENSZTADT HOPPY LEMO - MANGO & CHMIEL BUT. 0,33 L	5903424615674	355	0	355	1511
KOMES WYMRAЇANY PORTER BAЈTYCKI JACK DANIEL'S BA BUT. 0,33 L	5902838991428	236	0	236	1512
PINTA Їytorillo 14,0° keg 20 l PROMOCJA (do 29.09.23)	5123456780019	202	0	202	1513
HARDYWOOD CUVEE GOLD BUT. 0,75 L	856718003068	201	0	201	1514
MARYENSZTADT BEZGLUTENOWY SESYJNE APA BUT. 0,5 L	5903678022037	245	0	245	1515
BIRBANT MELLO JELL-OH PUSZKA 0,5 L PROMOCJA (do 11.10.23)	\N	485	0	485	1516
FUNKY FLUID GELATO: BLUEBERRY CHEESECAKE PUSZKA 0,5 L	5903999514501	339	0	339	1517
TRZECH KUMPLI OATY BUT. 0,5 L	5905669479646	421	0	421	1518
SZRENIAWA LETNIE PSZENICZNE BUT. 0,5 L	5903857178340	2120	0	2120	1519
DUVEL 6.66 BUT. 0,33 L	5411681408002	912	0	912	1520
STAROPOLSKIE BESTBIR WIЊNIA BUT. 0,5 L	5903021503244	290	0	290	1521
DEER BEAR FLORAL KEG 30 L	\N	201	0	201	1522
MARYENSZTADT FREEKY APA BEZALKOHOLOWE BUT. 0,5 L	5903424615568	287	0	287	1523
WESTVLETEREN 12 XII BUT. 0,33 L	5123456790130	247	0	247	1524
WRКЇEL CHERRY WILD BARREL AGED BUT. 0,33 L	5904730465984	214	0	214	1525
TARNOBRZEG JASNE PEЈNE BUT. 0,5 L	5903661867713	415	0	415	1526
INNE BECZKI TUTTI FRUTTI BUT. 0,5 L	5905669683296	660	0	660	1527
NEPOMUCEN SOUR MADNESS - BLACK PUSZKA 0,5 L	5905701060016	231	0	231	1528
BROKREACJA THE LUMBERJACK BUT. 0,5 L	5905669783026	284	0	284	1529
BROKREACJA POTION #23 BUT. 0,33 L	5904422197674	236	0	236	1530
ZAKЈADOWY ЈATWO POSZЈO BUT. 0,5 L	5907753171351	249	0	249	1531
AMBER JOHANNES BUT. 0,5 L	5906591001233	360	0	360	1532
PIWNE PODZIEMIE CHMIELOKRATA NELSON SAUVIN PUSZKA 0,5 L	5904305482149	222	0	222	1533
BROWAR JANA SZKLANKA 0,5 L	\N	217	0	217	1534
PIWNE PODZIEMIE COSMIC HIGHWAY BUT. 0,5 L	5904305482828	311	0	311	1535
CORSENDONK PATER BUT. 0,75 L	5411491011157	302	0	302	1536
STAROPOLSKIE BESTBIR PACIFIC BRZOSKWINIA BUT. 0,5 L	5905669086677	437	0	437	1537
STRAFFE HENDRIK TRIPLE BUT. 0,33 L	5425017240457	259	0	259	1538
O'HARA'S LEANN FOLLAIN PUSZKA 0,44 L	5391500602524	530	0	530	1539
ARTEZAN MERA IPA BUT. 0,5 L	5904730574013	374	0	374	1540
P?HJALA MUST KULD CHAI LATTE PUSZKA 0,33 L	4742976015423	226	0	226	1541
AMBER BARLEY DESSERT BUT. 0,5 L	5906591002421	256	0	256	1542
NEPOMUCEN COMMON GULL PUSZKA 0,5 L	5905191386771	242	0	242	1543
MALTGARDEN GATE NO 2_2022 PUSZKA 0,33 L	5904050721616	297	0	297	1544
BOON / MIKKELLER OUDE GEUZE BUT. 0,75 L	5412783552709	224	0	224	1545
LINDEMANS DZBANEK (PIASKOWY) 1 L	5123456791140	207	0	207	1546
DUVEL POKAL 3 L	5123456791454	203	0	203	1547
THE BRUERY 10 LORDS-A-LEAPING BUT. 0,75 L	718122104338	213	0	213	1548
BALADIN XYAUYU KIOKE BUT. 0,5 L	8032942297325	239	0	239	1549
FUNKY FLUID SUSKA SECHLOСSKA PUSZKA 0,44 L	8720615260690	203	0	203	1550
L'INSTANT WORLD OF HOPS PUSZ. 0,44 L	3770011969425	209	0	209	1551
P?HJALA MUST KULD BUT. 0,33 L	4742976010107	283	0	283	1552
STAROPOLSKIE BESTBIR PIECZONE JABЈKO BUT. 0,5 L	5905669086127	231	0	231	1553
JUPILER NA BUT. 0,25 L PROMOCJA (do 25.09.23)	\N	209	0	209	1554
CANTILLON ROSE DE GAMBRINUS 2022 BUT. 0,75 L	5123456790143	222	0	222	1555
ZA MIASTEM PEЈEN LUZ BUT. 0,5 L	5906874605141	239	0	239	1556
P?HJALA ЦЦ XO KEG 20 L	5123456789008	202	0	202	1557
KAZIMIERZ CZAS NA FAIRANT BUT. 0,5 L	5906660570554	332	0	332	1558
JAN OLBRACHT ZERO STRESU BEZALKOHOLOWE APA BUT. 0,5 L	5902627011481	638	0	638	1559
PINTA Kwas Xy 12,0° but. 0,5 l	5908252864355	1750	0	1750	1560
LINDEMANS OTWIERACZ	5123456791135	209	0	209	1561
VEDETT KIELISZEK  0,33 L	5123456791161	203	0	203	1562
ST. FEUILLIEN GREEN FLESH POKAL 0,33 L	5123456791066	201	0	201	1563
ED RED TIKKA MASALA Z BRҐZ. RYЇEM - KURCZAK	5904083584172	168	-28	168	1564
AFFLIGEM TRIPLE  BUT. 0,33 L	5410263925753	195	0	195	1565
WRКЇEL COOLIBER BUT. 0,5 L	5904730465939	235	0	235	1566
ZA MIASTEM SIЈA WOLI BUT. 0,33 L	5904905630070	261	0	261	1567
TOOL BLACHA REKLAMOWA	5123456791380	201	0	201	1568
MIO MIO GUARANA GRANAT BUT. 0,5 L	4002846034788	201	0	201	1569
LA TRAPPE QUADRUPEL BUT. 0,75 L	8711406135723	304	0	304	1570
PINTA SZKLANKA PM 2023 0,5 L	\N	594	0	594	1571
JAN OLBRACHT LEGENDY POLSKIE: LESZY BUT. 0,33 L	5902627012211	232	0	232	1572
FUNKY FLUID MANIAC PUSZKA 0,5 L	5907772092866	290	0	290	1573
ICE BREAKER SILVAS PROFUNDAS COLLAB. BREWING BEARS KEG 30 L	\N	201	0	201	1574
LOCO CANNABIS BUT. 0,33 L	5907694918442	280	0	280	1575
KASTEEL XTRA BUT. 0,33 L	5411081009007	235	0	235	1576
KOMES PORTER BOURBON OAK BUT. 0,5 L	5902838991244	214	0	214	1577
MATE MOC SABOR CITRUS BUT. 0,33 L	5902768762471	425	0	425	1578
CUVEE DES TROLLS KEG 5 L	5411551010205	203	0	203	1579
CIESZYN WILD ALE B.A. BUT. 0,33 L	5907612240747	237	0	237	1580
BOON OUDE GUEUZE VAT 92 BUT. 0,375 L	5412783000927	221	0	221	1581
STONE OLD GUARDIAN RED WINE BA 2011 BUT. 0,5 L	636251802089	201	0	201	1582
MOCZYBRODA CITRUS BLAST PUSZKA 0,5 L	5904673801115	255	0	255	1583
GOЊCISZEWO BABA JAGA BUT. 0,5 L	5903364108885	230	0	230	1584
MIKKELLER SPONTAN BLACKBERRY BUT. 0,375 L	818534015687	212	0	212	1585
3 FONTEINEN KRYSZTAЈOWA SZKLANKA 0,2 L	5123456791157	210	0	210	1586
MAGIC ROAD ONE HUNDRED TOGETHER PUSZKA 0,5 L	5905204131084	240	0	240	1587
JURAJSKIE KWAЊNY MNISZEK BUT. 0,5 L	5905331026178	330	0	330	1588
MIЈOSЈAW BEZALKOHOLOWE IPA PUSZKA 0,5 L	5902838990575	218	0	218	1589
ROCKMILL 4TH ANNIVERSARY BUT. 0,5L	5908291862282	209	0	209	1590
TRZECH KUMPLI CALIFIA PUSZKA 0,5 L	5904252699058	240	0	240	1591
DUBUISSON BUSH BLONDE TRIPLE BUT. 0,75 L	5411551270722	228	0	228	1592
BOSTEELS TRIPEL KARMELIET ZESTAW 4X BUT. 0,33 L + SZKЈO	5410693100492	206	0	206	1593
GEKKO BEERS SLINGSHOT PUSZ. 0,44 L PROMOCJA (do 05.10.23)	\N	202	0	202	1594
ARTEZAN CINNAMON ROLLS BUT. 0,5 L	5904708750838	222	0	222	1595
O'HARA'S / FIRESTONE WALKER FIБIN HONEY ALE BUT. 0,375 L	602755011531	305	0	305	1596
MARYENSZTADT SOURTIME BERLINER WEISSE TRUSKAWKA BUT. 0,5 L	5903424615254	334	0	334	1597
LIMBURGSE WITTE FLAGA	5123456791358	202	0	202	1598
BIRBANT BINGE DRINKING PUSZKA 0,5 L PROMOCJA (do 10.10.23)	\N	209	0	209	1599
TRZECH KUMPLI HAZY RYE MICRO IPA - OUR NEW IPA PUSZKA 0,5 L	5904252699836	396	0	396	1600
GRYBУW PILSVAR GRYBУW BUT. 0,5 L	5902516000268	227	0	227	1601
DZIKI WSCHУD TКPA DZIDA BUT. 0,5 L	5906874369159	397	0	397	1602
P?HJALA - LINDHEIM THE CHERRY OF MY EYE  BUT. 0,33 L	4742976016116	236	0	236	1603
STRUISE BLACK DAMNATION VIII - S.H.I.T. BUT. 0,33 L	5425017666080	218	0	218	1604
ALEBROWAR KWAS CHLEBOWY JASNY BUT. 0,5 L	5907771340036	207	0	207	1605
3 FONTEINEN INTENSE ROOD A83 2018/19 BUT. 0,375 L	5425007810943	201	0	201	1606
LINDEMANS BEARDY HIPSTER T-SHIRT (M)	5123456791147	201	0	201	1607
PINTA Kwas Jota 10,5° keg 30 l	5123456789729	203	0	203	1608
TRZECH KUMPLI IDIOTA PUSZKA 0,33 L	5904252699508	257	0	257	1609
PIWNE PODZIEMIE APRICOT GOSE KEG 30 L	\N	201	0	201	1610
ARTEZAN WITAM BUT. 0,5 L	5904730574211	229	0	229	1611
LA TRAPPE TAP HANDLE	5123456791361	202	0	202	1612
KAPITTEL BLONDE BUT. 0,33 L	5412896000432	208	0	208	1613
PINTA Oto mata IPA 14,0° keg 30 l	5123456789755	210	0	210	1614
ZAKЈADOWY WUJEK Z AMERYKI BUT. 0,5 L	5906395388400	400	0	400	1615
MOON LARK MIRAGE 2.0. SESSION HAZY IPA PUSZKA 0,5 L	5905255346345	201	0	201	1616
LA CHOUFFE POKAL 0,33 L	5123456791079	279	0	279	1617
BROKREACJA TEST DRIVE IPA BUT. 0,5 L	5905910086005	375	0	375	1618
MOON LARK RAISE. HELLES LAGER PUSZKA 0,5 L	5905255346208	359	0	359	1619
MONGOZO POKAL 0,25 L	5123456791071	215	0	215	1620
SKRZYNKA A-20 BROWAR FORTUNA	\N	685	0	685	1621
HOPPIN' FROG LIQUOR BARREL AGED TURBO SHANDY – BOURBON BUT. 0,65 L	804551312052	201	0	201	1622
DUGGES BLACK CURRANT ORGANIC PUSZKA 0,33 L	7350038223562	264	0	264	1623
GWAREK PINK PUCKER PUSZKA 0,5 L	5903938751684	254	0	254	1624
ALEBROWAR CRAZY MIKE ICE PROJECT BUT. 0,25 L + KIELISZEK	5907771341378	203	0	203	1625
TRZECH KUMPLI BREW NOTE BUT. 0,5 L	5905669479363	366	0	366	1626
BACCHUS KRIEK BUT. 0,375 L	5411081004309	213	0	213	1627
VERHAEGHE CHERRY DUCHESSE DE BOURGOGNE BUT. 0,33 L	5411364151911	279	0	279	1628
KAZIMIERZ DOBRE TO TO WYSZЈO #1 BUT. 0,5 L	5906660570363	408	0	408	1629
NEPOMUCEN MICHAEL PUSZKA 0,5 L PROMOCJA (do 11.10.23)	\N	217	0	217	1630
JURAJSKIE KWAЊNA AЊKA BUT. 0,5 L	5905331025058	360	0	360	1631
FLOREFFE PRIMA MELIOR BUT. 0,33 L	5411276300513	223	0	223	1632
KING MULE BUT. 0,33 L	5413699206519	248	0	248	1633
AMBER PSZENICZNIAK BUT. 0,5 L	5906591001332	229	0	229	1634
BIRBANT PILS KLASYCZNY BUT. 0,5 L	5903240620418	216	0	216	1635
PINTA Double Delivery 18,0° keg 20 l	5123456780021	201	0	201	1636
MALTGARDEN FOLLOW THE RECIPE BUT. 0,5 L	5904050721500	203	0	203	1637
LA TRAPPE ZESTAW (4x BUT. 0,33L QUADRUPEL/ISID'OR/TRIPEL/DUBBEL + SZKЈO)	8711406009413	236	0	236	1638
TRZECH KUMPLI HOPPY WEIZEN KEG 30 L	\N	203	0	203	1639
TRZECH KUMPLI BLACKCYL BUT. 0,5 L	5905669479240	245	0	245	1640
STAROPOLSKIE PORTER BAЈTYCKI BUT. 0,5 L	5905669086707	234	0	234	1641
PINTA Szklanka Pinta Party 2022	5123456791324	253	0	253	1642
PINTA Risfactor 30,0° keg 20 l	5123456789782	201	0	201	1643
VAL-DIEU BLONDE BUT. 0,33 L	5413977000013	263	0	263	1644
LINDEMANS FARO SZKLANKA 0,25 L	5123456791040	236	0	236	1645
STAROPOLSKIE COFFEE FRIENDS  BUT. 0,5 L	5903021506085	736	0	736	1646
TRZECH KUMPLI OATY PUSZKA 0,5 L	5904252699188	260	0	260	1647
WIDAWA LE POLONAIS C'T'UNE JOKE 2022 BARREL AGED BUT. 0,75 L	5907710904602	221	0	221	1648
GWAREK ZERO INON VOL.2 PUSZKA 0,5 L	5903938751721	255	0	255	1649
ZA MIASTEM RZEЊKI PORANEK BUT. 0,5 L	5904905630025	1080	0	1080	1650
ZA MIASTEM RADOЊЖ ЇYCIA BUT. 0,5 L	5906874605196	997	0	997	1651
KASTEEL ROUGE MATA BAROWA	5123456791347	205	0	205	1652
TRYBUNAЈ PORTER BAЈTYCKI BUT. 0,5 L	5905689309978	434	0	434	1653
SOWIE PILS BUT. 0,5 L	5907222560075	433	0	433	1654
BACCHUS FRAMBOZENBIER BUT. 0,375 L	5411081004316	204	0	204	1655
FUNKY FLUID TRINITY SIMCOE PILS PUSZKA 0,5 L	5903999514150	676	0	676	1656
PINTA Koszulka miкtowa M	5904165101310	202	0	202	1657
SAISON DUPONT BIOLOGIQUE BUT. 0,33 L	5410702000836	236	0	236	1658
PINTA Every Body August 10,5° keg 30 l	5123456780033	205	0	205	1659
ZA MIASTEM NA WYPASIE BUT. 0,5 L	5906874605042	1106	0	1106	1660
MIKKELLER RUNNING CLUB SPODNIE CZARNE ( M )	5123456791115	201	0	201	1661
NEPOMUCEN WASSILY PUSZKA 0,5 L	5904555992139	257	0	257	1662
DZIKI WSCHУD WILD WILD EAST - PEATED DARK WILD ALE BUT. 0,375 L	5906874369906	227	0	227	1663
RODENBACH ALEXANDER BUT. 0,33 L	5410583802574	771	0	771	1664
GRYFUS AHOJ 2.0 BUT. 0,5 L	5904905850140	280	0	280	1665
ROCKMILL TROPICAL IMPERIAL SOUR ALE PUSZKA 0,44 L PROMOCJA (do 18.10.23)	\N	268	0	268	1666
LERVIG RACKHOUSE OFF THE RACK PARAGON 2020 BUT. 0,75 L	7072712008639	201	0	201	1667
INNE BECZKI ZISSOU APA BUT. 0,5 L	5905669683012	445	0	445	1668
PINTA Bluza bordowa S	5904165100566	201	0	201	1669
BROKREACJA POTION #21 BUT. 0,33 L	5904422197445	327	0	327	1670
VAL-DIEU TRIPLE BUT. 0,33 L	5413977000037	336	0	336	1671
PINTA Psst... It's Your Weekend IPA - Cold IPA 15,0° but. 0,5 l	5904165104687	203	0	203	1672
LUBROW GRUBY BAMBER PUSZKA 0,33 L	5903686842924	282	0	282	1674
KEG SCHNEIDER 20 L	5123456792020	225	0	225	1675
KORMORAN 1 NA 100 LITE RYE APA BUT. 0,5 L	5902528052347	649	0	649	1676
PRZETWУRNIA CHMIELU SZYSZKA #1 GALAXY-SABRO PUSZKA 0,5 L	5907675597888	277	0	277	1677
KORMORAN CORNUS LUPUS BUT. 0,375 L	5902528000553	229	0	229	1678
FUNKY FLUID FUSION: PRZETWУRNIA CHMIELU PUSZKA 0,5 L	5903999514860	311	0	311	1679
PIWNE PODZIEMIE PERMANENT VACATION PUSZKA 0,5 L	5904305482811	224	0	224	1680
ALEBROWAR MANGO MAN BUT. 0,5 L	5907771341064	315	0	315	1681
PINTA IIPPAA 18,0° but. 0,5 l	5904730438766	2178	0	2178	1682
NEPOMUCEN PELICAN BUT. 0,5 L	5905279959750	310	0	310	1683
ED RED KONSERWA BOEUF STROGANOV	5903940086538	210	0	210	1684
STAROPOLSKIE THE ART OF HOPPING STYRIAN GOLDING SINGLE HOP IPA BUT. 0,5 L	5903021504951	270	0	270	1685
ROCKMILL GALACTIC BROTHERHOOD: Z INNEJ BECZKI BUT. 0,5 L	5908291862060	235	0	235	1686
MIKKELLER SAKIEWKA	5123456791111	222	0	222	1687
ED RED KONSERWA KARKУWKA Z PIWEM PIERWSZA POMOC	5904083584127	220	0	220	1688
MALTGARDEN GATE NO 3/2021 BUT. 0,5 L	5904050721401	215	0	215	1689
MINISTER SALTY TRIP BUT. 0,5 L	5903351660129	451	0	451	1690
DUVEL OTWIERACZ D	5123456791199	218	0	218	1691
MAGIC ROAD WILD ALE AGED IN WINE BARRELS BUT 0,75 L	\N	205	0	205	1692
TRZECH KUMPLI UNPLUGGED IPA BUT. 0,5 L	5905669479806	433	0	433	1693
SCHLENKERLA KUFEL CERAMICZNY RAUCHBIER 0,5 L	5123456791242	219	0	219	1694
AYINGER POKAL 0,3 L	5123456791213	216	0	216	1695
BOSTEELS PAUWEL KWAK BUT. 0,33 L	54050051	652	0	652	1696
DUBUISSON BUSH DE NOЛL BUT. 0,33 L	5411551320809	244	0	244	1697
O'HARA'S DOUBLE IPA BUT. 0,5 L	5391500600834	270	0	270	1698
STAROPOLSKIE PORTER BAЈTYCKI ZE ЊWIDOЊLIWҐ BUT. 0,5 L	5903021506269	349	0	349	1699
PINTA Barrel Brewing - After Hours - Tropical Wild Ale 12,0° keg 10 L	5123456780018	201	0	201	1700
RECRAFT WIELKA SZYCHA BUT. 0,5 L	5904730663014	298	0	298	1701
RACIBORSKIE SUMMER ALE CANNABIS EDITION BUT. 0,5 L	5905249834063	232	0	232	1702
BIRBANT KIZZY PUSZKA 0,5 L	5904041703836	623	0	623	1703
FUNKY FLUID FUSION: MAGIC ROAD PUSZKA 0,5 L	5903999513924	205	0	205	1704
STONE ENCORE VERTICAL EPIC 020202 2016 BUT. 0,65 L	636251908323	201	0	201	1705
LINDEMANS POKAL SENSORIK 0,5 L	5123456791003	349	0	349	1706
RADUGA TRAPEZE BUT. 0,5 L	5907431705359	287	0	287	1707
LUBROW AZEDO FRUTADO PUSZKA 0,33 L	5903686842191	212	0	212	1708
DZIKI WSCHУD TAREE'UUX PUSZKA 0,5 L	5906874369210	231	0	231	1709
ST. BERNARDUS PRIOR 8 BUT. 0,75 L	5411911001362	297	0	297	1710
HOEGAARDEN SZKLANKA 0,33 L	5123456791045	260	5	260	1711
GOЊCISZEWO SURFER BUT. 0,5 L	5903364108045	235	14	235	1712
MOCZYBRODA FOGGY SUMMIT PUSZKA 0,5 L	5904673800880	211	8	211	1713
LINDEMANS SZKLANKA SPONTANBASIL 0,25 L	5123456791038	224	0	224	1714
CANTILLON CUVEE SAINT-GILLOISE 2021 BUT. 0,75 L	5123456790012	226	0	226	1715
FILOU THUR POKAL 0,25 L	5123456791343	206	0	206	1716
HARPAGAN PUNKY MONKEY PUSZKA 0,5 L PROMOCJA (do 28.10.23)	\N	219	0	219	1717
PINTA Barrel Brewing Pokal Teku 0,1 l	5904335577051	205	0	205	1718
HARPAGAN JEONG BUT. 0,5 L	5905316580053	203	0	203	1719
ED RED KONSERWA SZAKSZUKA Z TOFU	5904083584042	210	0	210	1720
KENT FALLS SHADOW PYRAMIDS BUT. 0,5 L	5123456790145	201	0	201	1721
LITOVEL MORAVAN 11° KEG 30 L	\N	204	0	204	1722
SZRENIAWA BELGIAN BLOND BUT. 0,5 L	5907632926270	410	0	410	1723
MINISTER LUCKY GHOST BUT. 0,5 L	5903351660068	404	0	404	1724
STAROPOLSKIE DWORSKIE BUT. 0,5 L	5903111989811	292	0	292	1725
SCHLENKERLA KUFEL SZKLANY 0,4 L	5123456791244	201	0	201	1726
CROOKED STAVE ORIGINS BUT. 0,75 L	854512003185	211	0	211	1727
MARYENSZTADT CHOCOLATE RYE RIS JACK DANIELS B.A. BUT. 0,33 L	5905669542944	227	0	227	1728
STU MOSTУW ART+65 SOUR IPA PUSZKA 0,44 L	5907614682965	270	0	270	1729
SCHNEIDER TAP01 HELLE WEISSE 11,3° BUT. 0,5 L	4003669016807	1034	0	1034	1730
ALEBROWAR ICE SWEET COW WITH COCOA NIBS BUT. 0,25 L	5907771343327	249	0	249	1731
MC CHOUFFE BUT. 0,75 L	5410769200095	416	0	416	1732
HANSSENS OUDE KRIEK BUT. 0,375 L	5430000304047	232	0	232	1733
OSKAR BLUES CAN-O-BLISS RESINOUS PUSZKA 0,35 L	819942001811	201	0	201	1734
VEDETT WHITE BUT. 0,33 L	5411681400310	224	0	224	1735
KRAJAN IRLANDZKIE CIEMNE BUT. 0,5 L	5907582579410	704	0	704	1736
CHYLICZKI CYDR STARY SAD KEG 30 L	5123456789033	204	0	204	1737
FUNKY FLUID PILS PLEASE BUT. 0,5 L	5906395560257	502	0	502	1738
MIKKELLER PUMA BOKSERKA SPORTOWA CZARNA (L)	5123456791121	201	0	201	1739
KORMORAN ASTUS MALUM BUT. 0,375 L	5902528000348	237	0	237	1740
GRYBУW PILSVAR PORTER BUT. 0,5 L	5902516000435	214	0	214	1741
GRODZISKIE APA BUT. 0,5 L	5905279533233	270	0	270	1742
ARTEZAN SO EASY BUT. 0,5 L	5904708750814	232	0	232	1743
PIWOJAD TRIPLE MUFFIN BUT. 0,33 L	5906395053346	228	0	228	1744
ALEBROWAR SWEET 'N' HEAT BUT. 0,5 L	5907771343785	345	0	345	1745
LINDEMANS BEARDY HIPSTER T-SHIRT (XXL)	5123456791144	202	0	202	1746
TRZECH KUMPLI GOSE MANGO MARAKUJA KEG 30 L	5123456789477	204	0	204	1747
FUNKY FLUID USUAL PUSZKA 0,5 L	5907772092798	1324	0	1324	1748
WESTBROOK RHUBARB REMIX BUT. 0,75 L	856467003616	208	0	208	1749
DE LA SENNE JAMBE DE BOIS T-SHIRT M	5123456791364	201	0	201	1750
CHYLICZKI PERRY 2021 BUT. 0,75 L	5905279058170	225	0	225	1751
DZIKI WSCHУD TJMMNW BUT. 0,5 L PROMOCJA (do 01.10.23)	\N	211	0	211	1752
ED RED KONSERWA KACZKA KONFITOWANA Z JABЈKIEM	5903940086521	219	0	219	1753
SCHNEEEULE MARIANNA BUT. 0,75 L	\N	203	0	203	1754
PINTA Angielskie Њniadanie 14,0° but. 0,5 l	5904165100849	201	0	201	1755
PRZETWУRNIA CHMIELU TWIST #2 PUSZKA 0,5 L	5905476980335	267	0	267	1756
PODGУRZ IMPERIALNY 652 M N.P.M. BOURBON BA BUT. 0,5 L	5906874055373	231	0	231	1757
GWAREK OWSIANE WZGУRZA PUSZKA 0,5 L	5903938751127	221	0	221	1758
BROKREACJA ALL BEERS MATTER - OLD ALE BUT. 0,5 L	5904422197988	235	0	235	1759
RACIBORSKIE PILS BUT. 0,5 L	5907506252269	501	0	501	1760
DZIKI WSCHУD TETON PUSZKA 0,5 L	5906874369029	240	0	240	1761
VITAMINE SEA BELOW SEA LEVEL PUSZKA 0,473 L	5123456790117	204	0	204	1762
DEER BEAR SCOUT PUSZKA 0,5 L	5905204172155	247	0	247	1763
LINDEMANS KRIEK BUT. 0,25 L	5411223100463	3629	0	3629	1764
TRZECH KUMPLI KIOKIO BUT. 0,5 L	5905669479745	253	0	253	1765
GRYBУW PILSVAR MIODOWY BUT. 0,5 L	5902516000985	215	0	215	1766
FUNKY FLUID FUNKY FRUIT: PEACH WEIZEN BUT. 0,5 L	5906395560318	693	0	693	1767
ARTEZAN LATARNIA MORSKA BUT. 0,5 L	5904708750807	285	0	285	1768
NEPOMUCEN AROUND BUT. 0,5 L	5904555992610	365	0	365	1769
PINTA Bluza czarna M	5904165100528	202	0	202	1770
TRZECH KUMPLI PINK BOOTS 2023 PUSZKA 0,5 L	5904252699713	275	0	275	1771
STAROPOLSKIE NIEMDЈE KLASYCZNE BUT. 0,5 L	5903021503336	295	0	295	1772
ALEBROWAR KING OF HOP BUT. 0,5 L	5907222039182	280	0	280	1773
JURAJSKIE APA BUT. 0,5 L	5905331025089	270	0	270	1774
DZIKI WSCHУD MENOTSE PUSZKA 0,5 L PROMOCJA (do 25.10.23)	\N	249	0	249	1775
JURAJSKIE SЈODKI DRWAL BUT. 0,5 L	5905331026956	262	0	262	1776
BIRBANT MORPHIC PUSZKA 0,5 L	5904041703614	225	0	225	1777
PINTA MASTERBAR Cocoa Nibs & Orange Peel 30,0° keg 10 l	\N	203	0	203	1778
SARABANDA SCRUB THE BARREL PUSZKA 0,5 L	5904501978262	226	0	226	1779
CA' DEL BRADO NESSUN DORMA - SOUR ALE BUT. 0,375 L	\N	217	0	217	1780
SCHNEIDER TACA	5123456791352	204	0	204	1781
PINTA Jak w dym 18,0° keg 20 l PROMOCJA	5123456780027	208	0	208	1782
TANKBUSTERS ATTACK OF FRUITINESS PUSZKA 0,5 L	5905316580114	206	0	206	1783
PINTA Jak w dym 18,0° keg 30 l	5123456789727	202	0	202	1784
KOMES WYMRAЇANY PORTER MALINOWY WHISKEY BA BUT. 0,33 L	5902838991541	242	0	242	1785
PIRAAT POKAL 0,33 L	5123456791068	202	0	202	1786
TRZECH KUMPLI PILS BUT. 0,33 L	5904252699744	260	0	260	1787
LINDEMANS FRAMBOISE BUT. 0,75 L	5411223005249	279	14	279	1788
PRAIRIE BIRTHDAY BOMB! - BARREL AGED BUT. 0,355 L	680132989260	220	0	220	1789
BIRBANT HYPNOS PUSZKA 0,5 L	5904041703638	201	0	201	1790
INNE BECZKI IPARALIZATOR PUSZKA 0,5 L	5903661281779	344	0	344	1791
P?HJALA ЦЦ BUT. 0,33 L PROMOCJA (do 28.10.23)	\N	255	0	255	1792
KAZIMIERZ ORANGE BUT. 0,5 L	5906660570011	260	0	260	1793
BOURGOGNE DES FLANDRES BRUNE BUT. 0,33 L	5411516000517	246	0	246	1794
LINDEMANS FARO BUT. 0,75 L	5411223020204	266	0	266	1795
MARYENSZTADT SOURTIME CALAMANSI I LIMONKA BUT. 0,5 L L	5905669542043	310	0	310	1796
DELIRIUM NOЛL BUT. 0,75 L	5412186000975	231	0	231	1797
MALTGARDEN THE MIDDLE OF SILENCE 2022 ICE EDITION BUT. 0,25 L	5904050721517	374	0	374	1798
TRZECH KUMPLI LAGER WIEDEСSKI BUT. 0,5 L	5904252699683	325	0	325	1799
OUD BEERSEL OUDE GUEUZE 2016 BUT. 0,75 L	5425018070121	243	0	243	1800
LA TRAPPE BOCKBIER BUT. 0,75 L	8711406136638	218	0	218	1801
LUPULUS HOPERA BUT. 0,33 L	5425025122011	230	0	230	1802
ARTEZAN INNY TYP CZЈOWIEKA BUT. 0,5 L	5904708750456	208	0	208	1803
PINTA Koszulka biaіa XXL	5904165100450	202	0	202	1804
DZIKI WSCHУD CZAJ APACZA BUT. 0,5 L	5906874369326	255	0	255	1805
MOCZYBRODA CZAS SURFERУW BUT. 0,5 L	5903351761086	230	0	230	1806
MALTGARDEN PERFECT FOR EVERYDAY PUSZKA 0,5 L	5904050721975	218	0	218	1807
MARYENSZTADT KLASYCZNIE GOSE BUT 0,5 L	5903678022112	248	0	248	1808
WRКЇEL PINK PANTHER BUT. 0,5 L	5904181970440	215	0	215	1809
KEG GULDEN DRAK 20 L	\N	202	0	202	1810
PINTA Otwieracz magnes Atak Chmielu	5904165101594	208	0	208	1811
FILOMELOS CYDR PУЈ WYTRAWNY BUT. 0,75 L	5900168509092	226	0	226	1812
PINTA Koszulka czarna M	5904165100375	201	0	201	1813
TRZECH KUMPLI W STYLU GRODZISKIE PUSZKA 0,5 L	5904252699195	375	0	375	1814
BROWAR JANA COLD IPA BUT. 0,5 L	5902429981548	425	0	425	1815
BOSTEELS TRIPEL KARMELIET BUT. 0,33 L	54050082	955	0	955	1816
NEPOMUCEN FREE FAM DESIRE PUSZKA 0,5 L	5905701060160	569	0	569	1817
ZA MIASTEM SPOKУJ DUCHA BUT. 0,5 L	\N	338	0	338	1819
PINTA Koszulka czarna XL	5904165100399	202	0	202	1820
BOON KRIEK KIELISZEK 0,3 L	5123456791168	201	0	201	1821
SCHLENKERLA RAUCHBIER HANSLA 3,4° BUT. 0,5 L	4037458000180	384	0	384	1822
CUVEE DES TROLLS KEG 30 L	5123456789002	202	0	202	1823
RACIBORSKIE MIODOWE BUT. 0,5 L	5907506252573	425	0	425	1824
CANTILLON SAINT-LAMVINUS 2021 BUT.  0,75 L	5123456790018	283	0	283	1825
DUGGES HEAT PUSZKA 0,33 L	7350038225887	223	0	223	1826
DE MOLEN WATER & VUUR BUT. 0,33 L	8717624422409	288	0	288	1827
SCHNEEEULE AUTOBAHN COLLABO BRUSSELS BEER PROJECT BUT. 0,75 L	\N	205	0	205	1828
PINTA Upgrade Your September 12,0° keg 30 l	5123456780044	212	0	212	1829
FUNKY FLUID TRIPLE GELATO: VERDE PUSZKA 0,5 L	5903999514525	277	0	277	1830
PINTA Otwieracz magnes Ala Grodziskie	5904165101679	210	0	210	1831
LEFFE BLONDE BUT. 0,75 L	5410228102762	444	0	444	1832
KEG SVIJANY 30 L	\N	206	0	206	1833
INNE BECZKI ESTEBAN BUT. 0,5 L	5905669683289	854	0	854	1834
ARTEZAN S’MORES BUT. 0,5 L	5904708750821	240	0	240	1835
SCHLENKERLA RAUCHBIER URBOCK VINTAGE 2017 17,5° BUT. 0,5 L	5123456790101	202	0	202	1836
RADUGA SAMURAI REBELLION BUT. 0,5 L	5907431705236	448	0	448	1837
PINTA Koszulka HC czarna L	5904165102980	203	0	203	1838
BROKREACJA ORIGAMI PANDA BUT. 0,5 L	5904422197933	243	0	243	1839
KAZIMIERZ NEVER ENDING STORY BUT. 0,5 L	5906660570752	215	0	215	1840
VITAMINE SEA DUE SOUTH PUSZKA 0,473 L	5123456790112	204	0	204	1841
MOCZYBRODA PULP FUSION BUT. 0,5 L	5904673800279	254	0	254	1842
FILOMELOS PERRY HULAJ GRUSZKA BUT. 0,75 L	5900168509078	236	0	236	1843
RECRAFT WHITEOUT PUSZKA 0,5 L	5900779755543	226	0	226	1844
KASTEEL DONKER/ TRIPEL PODKЈADKI	5123456791337	212	0	212	1845
STARA SZKOЈA WERBENA BUT. 0,5 L	5906874548219	256	0	256	1846
STAROPOLSKIE BESTBIR DZIKA RУЇA BUT. 0,5 L	5905669086110	256	0	256	1847
ROCKMILL COFFEECAT PUSZKA 0,5 L	5908291862459	224	0	224	1848
IGNACУW CYDR BRETTUS BUT. 0,75 L	5902768323047	234	0	234	1849
FUNKY FLUID FREE GELATO: BERRIES & CREAM PUSZKA 0,5 L	5907772092620	467	0	467	1850
CHYLICZKI CYDR CHOPIN BUT. 0,75 L	5905279058200	269	0	269	1851
DUGGES CINNA PUSZKA 0,33 L	7350038225924	222	0	222	1852
MALTGARDEN MUSEUM OF CLASSIC BEERS (HALLERTAUER PILS) BUT. 0,5 L	5905669632546	273	0	273	1853
LERVIG ORIGINAL SIN PUSZKA 0,33 L	7072712006505	222	0	222	1854
LINDEMANS CASSIS TAP HANDLE	5123456791017	203	0	203	1855
INNE BECZKI BLACK SANDS BUT. 0,5 L	5901122234807	294	0	294	1856
ZAKЈADOWY NAPУJ FIRMOWY BUT. 0,5 L	5907753172020	350	0	350	1857
SCHNEIDER BAYRISCH HELL BLACHA REKLAMOWA	5123456791333	215	0	215	1858
ZAKЈADOWY SOKOWIRУWKA ARONIA & PORZECZKA BUT. 0,5 L PROMOCJA (do 28.10.23)	\N	325	0	325	1859
ZA MIASTEM LENIWE CHWILE BUT. 0,5 L	5906874605189	295	0	295	1860
TRZECH KUMPLI AMERICAN BEAUTY KEG 30 L	5123456789457	205	5	205	1861
PINTA Upgrade Your September 12,0° keg 20 l	5123456780043	201	0	201	1862
ZULI MELARYA IMBIR QUATRO BUT. 0,33 L	5904933314287	283	0	283	1863
KING MULE TAP HANDLE	5123456791351	204	0	204	1864
MIKKELLER PUMA BOKSERKA SPORTOWA CZARNA (XL)	5123456791119	204	0	204	1865
PINTA Beskidy Pils 12,0° keg 20 l	5123456789671	201	0	201	1866
FUNKY FLUID BUONASERA PUSZKA 0,5 L	5903999514648	317	0	317	1867
PIWNE PODZIEMIE KOSIARZ UMYSЈУW BUT. 0,33 L	5904305482606	230	0	230	1868
DUGGES RAINBOW PUSZKA 0,33 L	7350038226778	222	0	222	1869
PIWOTEKA LAS ЈAGIEWNICKI BUT. 0,5 L	5905669428569	233	0	233	1870
CHYLICZKI CYDR SZARA & ZЈOTA RENETA 2021 BUT. 0,75 L	5905279058057	235	0	235	1871
BACCHUS PODKЈADKI	5123456791341	206	0	206	1872
ST. MARTIN BRUNE 8% BUT. 0,33 L	5411065403326	228	0	228	1873
ICE BREAKER BOOMBOX KEG 30 L	\N	201	0	201	1874
TRZECH KUMPLI CITRUS SESSION JUICY IPA - OUR NEW IPA KEG 30 L	\N	202	0	202	1875
PINTA Barrel Brewing Moss but. 0,33 l	5904335577563	210	0	210	1876
WIDAWA HOP INCIDENT 02 BUT. 0,5 L	5907710904619	325	0	325	1877
STAROPOLSKIE MY WAY DOGBERRY-CHERRY WHEAT BUT. 0,5 L	5903021505781	252	0	252	1878
AMBER NATURALNY BUT. 0,5 L	5906591002834	250	0	250	1879
NEPOMUCEN TOUCAN BUT. 0,5 L	5905279959675	389	0	389	1880
MARYENSZTADT FREEKY HAZY IPA GLUTEN & ALCOHOL FREE BUT. 0,5 L	5903424615285	301	0	301	1881
O'HARA'S SZKLANKA NONIC 0,5 L	5123456791387	233	0	233	1882
ZA MIASTEM ЊWIКTY SPOKУJ BUT. 0,5 L	5906874605066	322	0	322	1883
GOЊCISZEWO DRWAL AUSTRALIAN BUT. 0,5	5903364108465	295	0	295	1884
STAROPOLSKIE BESTBIR ANANAS BUT. 0,5 L	5903021500007	271	0	271	1885
GWAREK ORCHARD BLEND PUSZKA 0,5 L	5903938751707	323	0	323	1886
CHIMAY RED KEG 20 L	5410908002016	203	0	203	1887
BROKREACJA PARIS SYNDROME 1 BOURBON BARREL AGED BUT. 0,33 L	5907610243740	257	0	257	1888
CIESZYN NOSZAK KEG 30 L	5123456789079	204	0	204	1889
BOON KRIEK MARIAGE PARFAIT BUT. 0,375 L	5412783053886	371	0	371	1890
STAROPOLSKIE PORTER 180 BUT. 0,5 L	5905669086691	343	0	343	1891
MALHEUR 10% BUT. 0,33 L	5413970200014	296	0	296	1892
KEG BELGIA A6	5123456792004	214	0	214	1893
ALEBROWAR EL FRUTO BUT. 0,5 L	5907222039106	360	0	360	1894
FLOREFFE TRIPLE BUT. 0,75 L	5411276200929	219	0	219	1895
P?HJALA MUDCAKE BДNGER BUT. 0,33 L	4742976015584	210	0	210	1896
ARTEZAN SPOILER ALERT BUT. 0,5 L	5904708750661	235	0	235	1897
PINTA Szklanka Mini Maxi IPA 0,5 l	5904165102164	203	0	203	1898
PIWNE PODZIEMIE WELWETOWE PODZIEMIE PUSZKA 0,5 L	5904305482798	230	0	230	1899
LINDEMANS KRIEK CUVEE RENE BUT. 0,75 L	5411223020778	307	0	307	1900
STRUISE BLACK DAMNATION II - MOCHA BOMB BUT. 0,33 L	5425017666028	202	0	202	1901
CANTILLON SANG BLEU KEG 20L	5123456789021	202	0	202	1902
CA' DEL BRADO CUVЙE DE PESGA - PEACH SOUR ALE BUT. 0,375 L	\N	202	0	202	1903
DUGGES FIRE PUSZKA 0,33 L	7350038225900	213	0	213	1904
BOON OUDE GUEUZE VAT DISCOVERY BOX (4 X 0,375 L)	5412783182944	399	0	399	1905
P?HJALA BELLE BULLE BUT. 0,33 L	4742976014228	234	0	234	1906
LA CORNE BLONDE BUT. 0,33 L	5425026610005	231	0	231	1907
IGNACУW CYDR AMARUS BUT. 0,5 L	\N	322	0	322	1908
TANKBUSTERS HELLO HELLES PUSZKA 0,5 L	5904365781398	235	0	235	1910
INNE BECZKI HAZY HAKA BUT. 0,5 L	5903661281106	510	0	510	1911
TOOL OMNIPRESENT BUT. 0,375 L	5711474009363	208	0	208	1912
ARTEZAN A PILS BUT. 0,5 L	5904730574624	221	0	221	1913
STU MOSTУW WRCLW BEZALKOHOLOWY IPA BUT. 0,5 L	5907614681890	233	0	233	1914
CIDER INN GЈКBSZY SMAK PУЈWYTRAWNY 4,5%  BUT.0,33 L	5900468000077	216	0	216	1915
KINGPIN FIDELITY PUSZKA 0,5 L	5904730290777	275	0	275	1916
STU MOSTУW IMPERIAL STOUT VANILLA  BOURBON B.A. NITRO BUT. 0,33 L	5907614680879	214	0	214	1917
LOCO BEER NARANJA IPA PUSZKA 0,5 L	5907694918480	309	0	309	1918
BOON FRAMBOISE KIELISZEK 0,15 L	5123456791170	203	0	203	1919
MARYENSZTADT KLASYCZNIE APA BUT. 0,5 L	5905669542821	238	0	238	1920
LINDEMANS PECHERESSE BUT. 0,355 L	5411223101071	351	0	351	1921
MARYENSZTADT MYSTERIOUS IPA BUT. 0,5 L	5905669542470	245	0	245	1922
FLYING MONKEYS SZKLANKA  0,25 L	5123456791047	201	0	201	1923
PINTA Kwas Xy 12,0° keg 30 l	5123456789811	209	0	209	1924
WRКЇEL ZERO Z MANGO BUT. 0,5 L	5904181970525	220	0	220	1925
CIDER INN GЈКBSZY SMAK WYTRAWNY 4,4 %  BUT. 0,33 L	5900468000138	215	0	215	1926
LA TRAPPE ZESTAW (6X BUT. 0,33L WITTE/BLOND/DUBBEL/ISID`OR/TRIPEL/QUADRUPEL)	8711406344248	255	0	255	1927
MALTGARDEN BOAT TO INDIA BUT. 0,5 L	5907710943472	237	0	237	1928
STU MOSTУW 8TH ANNIVERSARY MIXED FERMENTATION GRAFF  BUT. 0,375 L	5907614682514	208	0	208	1929
TOOL JULE MALT IMPERIAL MILK STOUT BUT. 0,375 L	5711474000698	524	0	524	1930
KARL STRAUSS WRECK ALLEY IMPERIAL STOUT BUT. 0,65 L	796535001161	209	0	209	1931
PINTA RISFACTOR Cocoa Nibs and Coconut 30,0° keg 20 l	5123456789783	202	0	202	1932
BROKREACJA SNOW GUENON BUT. 0,5 L	5904422197773	230	0	230	1933
TOOL UTOPIAN TONES BUT. 0,75 L	5711474009349	205	5	205	1934
ST. FEUILLIEN BLONDE BUT. 0,75 L	5412138107554	252	6	252	1935
PINTA Hazy Discovery Sofia keg 30 l	5123456780020	203	13	203	1936
STAROPOLSKIE KULTOWE JASNE BUT. 0,5 L	5905669086233	257	0	257	1937
NEPOMUCEN LOST BUT FOUND KEG 20L	\N	201	0	201	1938
PINTA Selection: IPA 3-pak + szkіo + podkіadki	5904165104076	208	0	208	1939
KEG PIRAAT 20 L	\N	204	0	204	1940
INNE BECZKI HOLY MONUNTAIN PUSZKA 0,5 L	5903661281410	295	0	295	1941
PINTA T-shirt biaіy duїe logo S	5904165102447	202	0	202	1942
CANTILLON SANG BLEU 2022 BUT. 0,75 L	5123456790019	327	0	327	1943
MARYENSZTADT KLASYCZNIE KOЏLAK BUT. 0,5 L	5903424615001	228	0	228	1944
FUNKY FLUID ASHES & DIAMONDS COCONUT / COFFEE BUT. 0,33 L	5903999511852	289	0	289	1945
WESTMALLE DUBBEL BUT. 0,33 L	5412343152332	271	0	271	1946
PRAIRIE BOMB! DECONSTRUCTED: VANILLA BUT. 0,355 L	680132989055	230	0	230	1947
LITOVEL ИERNY CITRON 4% KEG 30 L	\N	202	0	202	1948
SCHNEIDER WEISSE SZKLANKA 0,5 L	5123456791259	232	0	232	1949
PIWNE PODZIEMIE PHANTASMIC REALITY KEG 30 L	\N	201	0	201	1950
TRYBUNAЈ EXPORT BUT. 0,5 L	5905689304263	465	0	465	1951
ЈAСCUT POSPOLITE RUSZENIE BUT. 0,5 L	5906395997015	530	0	530	1952
BOSTEELS TRIPEL KARMELIET BUT. 0,75 L	5410693100553	236	0	236	1953
90 BPM L'AUTRE GANDALF KEG 30 L	\N	201	0	201	1954
NEPOMUCEN SHORELINE BUT. 0,5 L	5905191386481	304	0	304	1955
STRUISE / HOPY PEOPLE CLASH OF THE TITANS RESERVA BUT. 0,33 L	5425017181330	218	0	218	1956
SOWIE BEZALKOHOLOWE APA BUT. 0,5 L	5907222560143	413	0	413	1957
KASTEEL TRIGNAC BUT. 0,75 L	5411081005344	212	0	212	1958
PINTA BARREL BREWING INFLAME 12,0° BUT. 0,750 L	5904335577624	210	0	210	1959
P?HJALA LIQUID PINATA BUT. 0,33 L	4742976014884	228	0	228	1960
ST. LOUIS PREMIUM PECHE BUT. 0,25 L	5411081000363	250	0	250	1961
RADUGA WAKE ME! PUSZKA 0,5 L	5902176772048	275	0	275	1962
BROKREACJA POTION #25 BUT. 0,33 L	5904422197896	231	0	231	1963
MARYENSZTADT SOURTIME MIRABELKA I LIMONKA BUT. 0,5 L	5903424615322	275	0	275	1964
FLORIS CHOCOLAT BUT. 0,33 L	5412186000401	211	0	211	1966
BROKREACJA ERMINE FLAIR PUSZKA 0,5 L	5904422197803	559	0	559	1967
ZA MIASTEM UЊMIECH LOSU BUT. 0,5 L	5906874605424	294	0	294	1968
SVIJANY WAFLOWNICA	\N	214	0	214	1969
ZA MIASTEM PEЈEN RELAKS BUT. 0,5 L	5904905630223	284	0	284	1970
PINTA BARREL BREWING INFLAME 12,0° BUT. 0,375 L	5904335577617	219	0	219	1971
STELLA ARTOIS NEON REKLAMOWY	5123456791056	210	0	210	1972
DELIRIUM NOCTURNUM BUT. 0,33 L	5412186000715	448	0	448	1973
BROKREACJA WHERE IS LEITMOTIV? KIWI-MATCHA BUT. 0,5 L	5904422197919	223	0	223	1974
SMYKAN CYDR STARY SAD KEG 30 L	5123456791305	202	0	202	1975
PINTA Hazy Discovery Timisoara keg 30 l	5123456780049	203	0	203	1976
P?HJALA GIMME DANGER BUT. 0,33 L	4742976012293	283	0	283	1977
WRКЇEL PILS BUT. 0,5 L	5904730465731	255	0	255	1978
SMYKAN CYDR STARY SAD BUT. 0,33 L	5905669332101	267	7	267	1909
P?HJALA OCEAN ROAD PUSZKA 0,33 L	4742976016093	206	0	206	1979
BROKREACJA ALL BEERS MATTER - ENGLISH IPA BUT. 0,5 L	5904422197971	209	0	209	1980
ALEBROWAR HERR AXOLOTL WITH WHITE GUAVA BUT. 0,5 L	5907222039786	211	0	211	1981
CHYLICZKI CYDR JAPOСSKI SAD KEG 30 L	5123456789029	206	0	206	1982
GRYBУW PILSVAR GУRALSKIE BUT. 0,5 L	5902516000411	473	0	473	1983
DZIKI WSCHУD WILD WILD EAST CHERRY WILD ALE BUT. 0,375 L	5906874369609	221	0	221	1984
BIRRA MANIA SICILIAN IPA BUT. 0,33 L	5907694918411	203	0	203	1985
STAROPOLSKIE GRAPE ALE BUT. 0,5 L	5903021506276	477	0	477	1986
MALTGARDEN I'M YOUR BARISTA / PANAMA GEISHA FINCA DEBORAH NIRVANA PUSZKA 0,5 L	5904050721234	406	0	406	1987
FUNKY FLUID HALLERTAUER PILS PUSZKA 0,5 L	5903999514198	340	0	340	1988
KAZIMIERZ LATAJҐCY JELEС BUT. 0,5 L	5906660570240	260	0	260	1989
LIMBURGSE WITTE CZAPKA Z DASZKIEM	5123456791348	205	0	205	1990
LITOVEL MIODOWY BUT. 0,5 L	8593875516711	465	0	465	1991
WESTMALLE DUBBEL BUT. 0,75 L	5412343001166	297	0	297	1992
MIKKELLER SPONTAN HIBISCUS BUT. 0,375 L	5704255115605	230	0	230	1993
OUD BEERSEL OUDE GUEUZE VANDERVELDEN 140 YEARS BUT. 0,375 L	5425018071234	208	0	208	1994
LERVIG HIPSTER FOR CHRISTMAS 2020 PUSZKA 0,33 L	7072712006406	207	0	207	1995
BACCHUS TABLICA REKLAMOWA	5123456791362	201	0	201	1996
TRZECH KUMPLI MVPILS BUT. 0,5 L	5905669479448	358	0	358	1997
P?HJALA PIME ЦЦ BUT. 0,33 L	4742976010183	260	0	260	1998
DZIKI WSCHУD CHMIELOBRANIE Z KOFEINҐ BUT. 0,5 L	5900779755819	209	0	209	1999
ST. BERNARDUS WATAU KIELICH  0,33 L	5123456791174	217	0	217	2000
ZAKЈADOWY WNIOSEK URLOPOWY BUT. 0,5 L	5906395388219	274	0	274	2001
TRZECH KUMPLI TRIPADELIC BUT. 0,5 L	5905669479127	257	0	257	2002
MALTGARDEN HELLO LAGER PUSZKA 0,5 L	5907710943007	240	0	240	2003
BROWAR JANA WEIZEN MANGO BUT. 0,5 L	5902429981012	424	0	424	2004
SOFIA ELECTRIC CATCH SOME RAYS K-KEG 20 L PROMOCJA (do 22.09.23)	\N	201	0	201	2005
SKRZYNKA SVIJANY A-20	\N	226	0	226	2006
AUGUSTIJN BRUNE BUT. 0,33 L	5411663007001	260	0	260	2007
DU BOCQ BLANCHE DE NAMUR SZKLANKA 0,25 L NOWA	5123456791052	213	0	213	2008
PETRUS ROOD BRUIN BUT. 0,33 L	875213000068	244	0	244	2009
GRODZISKIE SESSION ALE BUT. 0,5 L	5905279533523	245	0	245	2010
WESTVLETEREN 8 EXTRA BUT. 0,33 L	5123456790132	206	5	206	2011
SMYKAN CYDR RENETY 2022 BUT. 0,75 L	5905669332224	214	0	214	2012
AMBER PO GODZINACH - STOUT BUT. 0,5 L	5906591001981	255	0	255	2013
RADUGA GAME#3 BUT. 0,5 L	5902176770860	445	0	445	2014
KORMORAN JASNY BUT. 0,5 L	5902528462337	201	0	201	2015
NEPOMUCEN LABIRYTM BUT. 0,5 L	5905279959101	269	0	269	2016
RADUGA MARTIAN BUT. 0,33 L	5902176770037	222	0	222	2017
LA TRAPPE ZESTAW (2X BUT. 0,75 L BLOND/QUADRUPEL)	8711406567685	242	0	242	2018
BROWAR JANA JASNE PEЈNE BUT. 0,5 L	5902429980008	433	0	433	2019
MAGIC ROAD BOCK LORD HALLELUJAH PUSZKA 0,44 L	5905204130216	240	0	240	2020
ЈAСCUT POPROSZК O DOLEWKК BUT. 0,5 L	5906395997978	423	0	423	2021
ROCKMILL BE WILD #1 0 BUT. 0,75 L	5906874027509	210	0	210	2022
NEPOMUCEN ENDLESS LINES PUSZKA 0,5 L	5905191386948	220	0	220	2023
ST. FEUILLIEN KIELICH 0,33 L	5123456791176	251	0	251	2024
GAULOISE BLONDE BUT. 0,33 L	5411633331013	210	0	210	2025
WRКЇEL CELTIC SURPRISE PART TWO BUT. 0,5 L	5904181970341	201	0	201	2026
SCHNEIDER WEISSE KUFEL CERAMIKA 0,5 L	5123456791255	331	0	331	2027
BROKREACJA ALMOST GRIZZLY BUT. 0,5 L	5904422197841	248	0	248	2028
PRAIRIE PRISON RODEO BUT. 0,355 L	683318988415	219	0	219	2029
SMYKAN SZKLANKA 0,33 L	\N	212	0	212	2030
PIWNE PODZIEMIE PHANTASMIC REALITY PUSZKA 0,5 L	5904305482859	306	0	306	2031
LINDEMANS ZESTAW (1X BUT. 0,375 L + 3X BUT. 0,355 L + SZKЈO)	5411223002064	202	0	202	2032
PIWOTEKA POMALUTKU I DO SKUTKU BUT. 0,5 L	5905669428125	207	0	207	2033
PETRUS BLOND BUT. 0,33 L	875213000044	252	0	252	2034
TRZECH KUMPLI PAN IPANI DOUBLE KEG 20 L	\N	201	0	201	2035
BAVIK SUPER WIT PUSZKA 0,33 L	875213001720	221	0	221	2036
PIWNE PODZIEMIE KOSIARZ UMYSЈУW BOURBON OAK CHIPS X VANILLA BUT. 0,33 L	5904305482613	240	0	240	2037
RODENBACH VINTAGE 2019 BUT. 0,75 L	5410583803090	210	0	210	2038
THE BRUERY 6 GEESE A LAYING 0,75 L	718122104338	211	0	211	2039
P?HJALA VIRVATULI BUT. 0,33 L	4742976015607	300	0	300	2040
MARYENSZTADT SOURTIME CZARNA PORZECZKA BUT. 0,5 L	5905669542326	291	0	291	2041
CHYLICZKI PERRY LODOWA GRUSZKA 2021 BUT. 0,5 L	5905279058286	245	0	245	2042
MALTGARDEN TOPPING REVOLUTION PUSZKA 0,5 L	5904050721982	226	0	226	2043
KINGPIN RECKLESS PUSZKA 0,5 L	5904730290227	588	0	588	2044
KAZIMIERZ ZERRO% BUT. 0,5 L	5906660570479	340	0	340	2045
RODENBACH GRAND CRU EVOLVED BUT. 0,75 L	5410583804103	528	0	528	2046
MARYENSZTADT UP TO ME BUT. 0,5 L	5903424615490	277	0	277	2047
PINTA Hazy Delivery 15,0° can 0,5 l	5904165103840	1652	0	1652	2048
LINDEMANS KRIEK TAP HANDLE	5123456791014	204	0	204	2049
DZIKI WSCHУD NUNPA PUSZKA 0,5 L	5906874369395	214	0	214	2050
ROCKMILL BE WILD #3 0 BUT. 0,75 L	5906874027516	205	0	205	2051
RADUGA LEON BUT. 0,5 L	5902176770099	245	0	245	2052
MARYENSZTADT SMOOTHIE BEER: MANGO-ORANGE-BANANA-MARSHMALLOW PUSZKA 0,44 L	5903424615117	225	0	225	2053
PINTA Modern Drinking 15,0° keg 30 l	5123456789742	210	0	210	2054
PINTA Beskidy Pszeniczne 13,0° keg 30 l	5123456789676	214	0	214	2055
MOON LARK MIRAGE 3.0. HAZY SESSION IPA PUSZKA 0,5 L	5905255346451	348	0	348	2056
MIKKELLER SPONTAN CHERRY W. FREDERIKSDAL BUT. 0,375 L	818534011566	220	0	220	2057
ZIEMIA OBIECANA DOZO! PUSZKA 0,5 L	5905186484710	230	0	230	2058
KASTEEL TRIPEL KEG 20 L	5123456789884	202	0	202	2059
KAZIMIERZ ALEDЏWIEDЏ BUT. 0,5 L	5906660570028	205	0	205	2060
PRAIRIE BOMB! DECONSTRUCTED: COFFEE BUT. 0,355 L	680132989055	243	0	243	2061
LINDEMANS WIKLINOWY KOSZYK NA LAMBIKI	5123456791005	207	0	207	2062
ASLIN BC TRANS AM TRAV PUSZKA 0,473 L	725272730744	206	0	206	2063
LINDEMANS KRIEK BUT. 0,75 L	5411223100920	676	0	676	2064
LA TRAPPE ZESTAW (3x BUT. 0,33L BLOND/DUBBEL/TRIPLE + SZKЈO)	8711406566718	221	0	221	2065
WIDAWA TROPICAL STORM BUT. 0,5 L	5907710904039	349	0	349	2066
KINGPIN ZIPPY PUSZKA 0,5 L	5904730290258	555	0	555	2067
PALATUM ETERNAL ECLIPSE COCOA EDDITON PUSZKA 0,5 L	5905159520179	230	0	230	2068
PINTA Otwieracz magnes IIPPAA	5904165101624	209	0	209	2069
MAGIC ROAD DESTINATION NOWHERE PUSZKA 0,5 L	5905204131091	215	0	215	2070
CIESZYN BARLEY WINE Z WIЊNIAMI B.A. BUT. 0,33 L	5907612240723	221	0	221	2071
SAISON DUPONT BIOLOGIGUE BUT. 0,75 L	5410702000812	206	0	206	2072
PINTA T-shirt szary duїe logo L	5904165102515	202	0	202	2073
MONVIN KARAFKA 0,5 L / 1,0 L	5123456791450	212	0	212	2074
FUNKY FLUID GELATO: ROSA PUSZKA 0,5 L	5903999514419	328	0	328	2075
IGUANA Metabolizm BIO but. 0,475 L	5905689311117	494	0	494	2076
LUBROW TARNICA 1346 PUSZKA 0,33 L	5903686842931	234	0	234	2077
DELIRIUM ARGENTUM BUT. 0,33 L	5412186003594	389	0	389	2078
LINDEMANS TAROT D'OR MEDALION RYBIE OKO	\N	201	0	201	2079
TARNOBRZEG URODZINOWE FEAT POPARZENI KAWҐ TRZY BUT. 0,5 L	5904533544077	305	0	305	2080
LEFFE TRIPLE BUT. 0,33 L	5410228145912	332	0	332	2081
LUBROW CHMIELEWSKI PUSZKA 0,33 L	5903686842696	240	0	240	2082
PIWNE PODZIEMIE WELWETOWE PODZIEMIE KEG 30 L	5123456789401	201	0	201	2083
MOCZYBRODA RETRO PISTACHIO PUSZKA 0,5 L	5904673800415	223	0	223	2084
ALEBROWAR BAЈTYCKI DZIAD PILS BUT. 0,5 L	5907771342276	280	0	280	2085
MALTGARDEN BEAUTY IS POWER PUSZKA 0,5 L	5904050721951	235	5	235	2086
STAROPOLSKIE KULTOWE BEZ GLUTENU PROZDROWOTNE 0,0 % BUT. 0,5 L	5903021505521	258	0	258	2087
TOOL TAP HANDLE	5123456791006	202	0	202	2088
ALEBROWAR SINGLE HOP NECTARON HAZY IPA BUT. 0,5 L	5907771342979	210	0	210	2089
LUBROW ZOMBIE SABRO IPA PUSZKA 0,33 L	5903686842849	248	0	248	2090
LINDEMANS LEЇAK PLAЇOWY	5123456791138	206	0	206	2091
STU MOSTУW PUMPKIN SPICE SOUR BUT. 0,5 L	5907614683306	205	0	205	2092
ED RED MIELONKA NAJDROЇSZA	5904083584134	210	0	210	2093
WRКЇEL MALTIC STORM ISLAY SA BUT. 0,5 L	5904181970273	269	0	269	2094
PINTA typ niepoHOPny 12,0° but. 0,5 l PROMOCJA (do 27.10.23)	\N	210	0	210	2095
FUNKY FLUID MATE PUSZKA 0,5 L	5907772092026	339	0	339	2096
ALEBROWAR PEACHOLINA BUT. 0,5 L	5907771340685	287	0	287	2097
STAROPOLSKIE KULTOWE BEZ GLUTENU MALINOWE BUT. 0,5 L	5903021500618	235	0	235	2098
3 FONTEINEN OUDE GEUZE CUVEE ARMAND & GASTON 2016/17 BUT. 0,375 L	5425007813012	239	0	239	2099
P?HJALA BANGER BUT. 0,33 l	4742976015874	213	0	213	2100
MOCZYBRODA NEW WAVE #12 BUT. 0,33 L	5903351761727	206	0	206	2101
MARYENSZTADT KLASYCZNIE DRY STOUT BUT. 0,5 L	5903678022952	240	0	240	2102
TRZECH KUMPLI MISTY KEG 30 L	5123456789486	207	0	207	2103
DEER BEAR LET'S COOK SOUR APA BUT. 0,5 L PROMOCJA (do 05.10.23)	\N	209	0	209	2104
DUVEL BUT. 0,33 L	5411681014005	5955	0	5955	2105
KEG BROWAR ZAMKOWY CIESZYN 30 L	5123456792016	275	0	275	2106
BIRBANT SAGA BUT. 0,5 L	5904041703669	290	0	290	2107
P?HJALA CHERRY GARDEN PUSZKA 0,33 L	4742976015447	248	0	248	2108
LINDEMANS PECHERESSE BUT. 0,75 L	5411223100876	412	0	412	2109
MARYENSZTADT SOURTIME MANGO IIPA BUT. 0,5 L	5905669542722	553	0	553	2110
STONE SZKLANKA 0,33 L	5123456791025	292	0	292	2111
MAGIC ROAD WE KEEP OUR PROMISES PUSZKA 0,5 L	5905204130148	221	0	221	2112
WRКЇEL BUTTERFLY BUT. 0,5 L	5904730465137	220	0	220	2113
DE LA SENNE BLUZA L	5123456791363	201	0	201	2114
ED RED KONSERWA KURCZAK Z GRZYBAMI Z LASU	5904083584011	210	0	210	2115
FUNKY FLUID COPACABANA PUSZKA 0,5 L	5903999514372	350	0	350	2116
MONGOZO KOKOS POKAL	5123456791070	201	0	201	2117
MISSION DARK SEAS IMPERIAL STOUT BUT. 0,3 L	850411004056	232	0	232	2118
P?HJALA - WEIHENSTEPHAN ZEIT BUT. 0,33 L	4742976016079	226	0	226	2119
PRZETWУRNIA CHMIELU TWIST #4 MARAKUJA PUSZKA 0,5 L	5905476980649	285	0	285	2120
NEPOMUCEN BRUSCO PUSZKA 0,5 L	5905701060139	263	0	263	2121
FUNKY FLUID MOODY PUSZKA 0,5 L	5903999514174	562	0	562	2122
LINDEMANS KRIEK KEG 25 L	5123456789024	252	0	252	2123
DZIKI WSCHУD ZЈOTE KALESONY PUSZKA 0,5 L	5906874369951	252	0	252	2124
ZA MIASTEM SЈONECZNY DZIEС BUT. 0,5 L	5906874605097	223	0	223	2125
FUNKY FLUID TRIPLE GELATO: BERRIES & CREAM PUSZKA 0,5 L	5903999510893	239	0	239	2126
ARTEZAN SAMIEC ALFA 2023 SOCIAL VANILLA BUT. 0,5 L	5904708750678	223	0	223	2127
PINTA Pils Time 12,0° but. 0,5 l	5904165104182	1607	0	1607	2128
TOOL KAFFE OG ROG BUT. 0,33 L	5711474002180	285	0	285	2129
FUNKY FLUID FUSION: TANKBUSTERS PUSZKA 0,5 L	5903999514358	237	0	237	2130
PRIMБTOR LEЋБK 11° KEG 30 L	5123456789916	201	0	201	2131
RECRAFT ЊWIКTY PATRYK BUT. 0,5 L	5900779755062	391	0	391	2132
WESTMALLE BLACHA REKLAMOWA	5123456791207	201	0	201	2133
WRКЇEL VIVA ESPANA TWO PUSZKA 0,5 L PROMOCJA (do 20.10.23)	\N	219	0	219	2134
KAZIMIERZ ELA UNDER MY UMBRELLA BUT. 0,5 L PROMOCJA	\N	241	0	241	2135
MARYENSZTADT BARLEY WINE LAPHROIG B.A. BUT. 0,33 L	5905669542937	227	0	227	2136
LINDEMANS TAP HANDLE (DREWNO) 28 CM	5123456791019	216	0	216	2137
KASTEEL BRIGAND KIELICH 0,33 L	5123456791344	206	0	206	2138
LA TRAPPE KIELICH 0,25 L	5123456791184	306	0	306	2139
PINTA Koszulka czarna L	5904165100382	202	0	202	2140
LINDEMANS APPLE TAP HANDLE	5123456791354	204	0	204	2141
VAL-DIEU CUVEE 800 BUT. 0,75 L	5413977000952	220	0	220	2142
LINDEMANS FRAMBOISE BUT. 0,355 L	5411223101064	409	0	409	2143
PINTA MASTERBAR Cocoa Nibs & Orange Peel 30,0° but. 0,33 l	5904165104021	245	0	245	2144
SVIJANY MATA BAROWA	\N	202	0	202	2145
HEMP & BREW CBD PALE ALE BUT. 0,5 L	5903661867751	225	0	225	2146
PETRUS NITRO CHERRY CHOCO KEG 30 L	5123456789019	201	0	201	2147
TIMMERMANS KRIEK BUT. 0,25 L	5411516010110	225	0	225	2148
KORMORAN KRZEPKIE BUT. 0,5 L PROMOCJA (do 10.19.23)	\N	201	0	201	2149
TRZECH KUMPLI GOEDEMORGEN BUT. 0,5 L	5905669479318	280	0	280	2150
DUGGES TWISTER PUSZKA 0,33 L	7350038224996	223	0	223	2151
ST. FEUILLIEN GRAND CRU BUT. 0,33 L	5412138653310	236	0	236	2152
STU MOSTУW X MOERSLEUTEL MADNESS PUSZKA 0,33 L	5907614682750	208	0	208	2153
HANSSENS FRAMBOISE BUT. 0,375 L	5430000304085	224	0	224	2154
PRAIRIE STANDARD BUT. 0,355 L	894776000063	208	0	208	2155
SAMUEL SMITH TADDY PORTER BUT. 0,355 L	5010149200808	243	0	243	2156
BIRBANT YUMMY BUT. 0,5 L	5903240620852	345	0	345	2157
RACIBORSKIE SUMMER ALE BUT. 0,5 L	5907506252542	293	0	293	2158
TOOL PAID IN DIAMONDS - CABERNET BUT. 0,375 L	5711474010048	202	0	202	2159
KASTEEL CUVEE DE CHATEAU KEG 20 L	5123456789883	203	0	203	2160
NEPOMUCEN FRUTTATO PUSZKA 0,5 L PROMOCJA (do 06.10.23)	\N	219	0	219	2161
LINDEMANS KRIEK MEDALION RYBIE OKO	\N	201	0	201	2162
ЈAСCUT ANGLOSAS BUT. 0,5 L	5906395997251	307	0	307	2163
MIKKELLER SCOUR SCANDINAVIA SPONTAN SEABUCKTHORN BUT. 0,375 L	5704255118323	214	0	214	2164
PETRUS BORDEAUX KEG 30 L	\N	202	0	202	2165
SCHNEEEULE BESTE FREUNDE BUT. 0,75 L	\N	206	0	206	2166
PINTA Otwieracz barmaсski	5123456791386	201	0	201	2167
KAZIMIERZ DOBRE TO TO WYSZЈO #2 BUT. 0,5 L	5906660570509	340	0	340	2168
ARTEZAN PEANUT BUTTER CHOCOLATE BUT. 0,5 L	5904708750845	240	0	240	2169
TRZECH KUMPLI BLACKCYL KEG 30 L	5123456789460	201	0	201	2170
ALEBROWAR BAЈTYCKI DZIAD WEIZEN BUT. 0,5 L	5907771342269	248	0	248	2171
PIWOTEKA CZAISZ BAZК: LAPSANG SOUCHONG BUT. 0,5 L	5905669428101	241	0	241	2172
CIESZYN PORTER BAЈTYCKI BARREL AGED BUT. 0,33 L	5905279156531	243	0	243	2173
SARABANDA PLEASUREDOME PUSZKA 0,5 L	5904501978255	321	0	321	2174
GRYFUS SEDINA BUT. 0,5 L	5907222685174	245	0	245	2175
NEPOMUCEN RANGE PALE ALE BUT. 0,5 L	5905279959323	213	0	213	2176
DUGGES TROPIC SHAKE PUSZKA 0,33 L	7350038226624	202	0	202	2177
PINTA Szklanka Apfelwein 0,5 l	5904165100665	207	0	207	2178
ST. BERNARDUS PRIOR 8 KEG 20 L	5123456789439	201	0	201	2179
FORTUNA KWAЊNA PIGWA BUT. 0,5 L	5902838990452	360	0	360	2180
FUNKY FLUID SPLASH: PINK PUSZKA 0,5 L PROMOCJA (do 27.09.23)	\N	249	0	249	2181
MARYENSZTADT HEY OH BUT. 0,5 L	5905669542340	393	0	393	2182
SCHNEIDER TAP01 HELLE WEISSE 11,3° KEG 20 L	2100006E2AD9B	210	0	210	2183
BIRBANT HOPSBANT FRESH IPA BUT. 0,5 L	5903240620166	264	0	264	2184
BIRBANT TIAMAT PUSZKA 0,33 L	5904041703270	204	0	204	2185
PINTA RISFACTOR Cocoa Nibs and Roasted Peanuts 30,0° but. 0,33 l	5904165104267	385	0	385	2186
JACKIE O'S OFF THE BEATEN PATH 3 BUT. 0,5 L	855647004719	208	0	208	2187
LINDEMANS GUEUZE BUT. 0,25 L	5411223101002	329	0	329	2188
CHYLICZKI CYDR ANTONУWKA BUT. 0,5 L	5905279058101	347	0	347	2189
WESTMALLE TRIPEL BUT. 0,75 L	5412343001227	244	0	244	2190
ANDERSON JEAN GINIE LAPHROAIG BA BUT. 0,33 L	4744175010988	236	0	236	2191
INNE BECZKI OLDSCHOOLOWIEC BUT. 0,5 L	5903661281618	690	0	690	2192
TRZECH KUMPLI PAN IPANI BUT. 0,33 L	5904252699737	293	0	293	2193
PIWNE PODZIEMIE JASNE! CHEЈMLOVE! BUT. 0,5 L	5904305482743	583	0	583	2194
RECRAFT PURISTA BUT. 0,33 L	5900779755079	1059	0	1059	2195
SZRENIAWA PERLAGE BUT. 0,5 L	5903857178425	2441	0	2441	2196
DUGGES BOURBON SAFFRON BUT. 0,33 L	7350038226501	206	0	206	2197
BROKREACJA THE ALCHEMIST BUT. 0,5 L	5905669783033	358	0	358	2198
TRZECH KUMPLI MISTY PUSZKA 0,5 L	5904252699065	381	0	381	2199
GRODZISKIE WHITE IPA BUT. 0,5 L	5905279533240	275	0	275	2200
DZIKI WSCHУD SЈOСCE PRERII BUT. 0,5 L	5906874369258	281	0	281	2201
PAX PILS SZKLANKA 0,25 L	5123456791033	257	0	257	2202
DZIKI WSCHУD AYANI PUSZKA 0,5 L	5906874369944	225	0	225	2203
DU BOCQ BLANCHE DE NAMUR ROSEE KEG 20 L	\N	201	0	201	2204
ST. FEUILLIEN CUVЙE DE NOEL BUT. 0,33 L	5412138303314	269	0	269	2205
STU MOSTУW ALL INCLUSIVE PUSZKA 0,44 L	5907614683184	212	0	212	2206
SMYKAN CYDR ANTONI WISIENKA BUT. 0,5 L	5905669332187	213	0	213	2207
KAZIMIERZ ILE TO MA IBU? BUT. 0,5 L	5906660570271	303	0	303	2208
BROWARNY EVIL BOY PUSZKA 0,5 L	5905450141134	305	0	305	2209
MALTGARDEN WINDOW BLINDS DOWN BUT. 0,5 L	5907710943298	608	0	608	2210
OMNIPOLLO PLUCKIN’ FEATHERS  BUT. 0,33 L	7350064995075	241	0	241	2211
PINTA RISFACTOR Cinnamon and Cocoa Nibs 30,0° but. 0,33 l	5904165103383	229	0	229	2212
RODENBACH RED TRIPEL BUT. 0,75 L PROMOCJA (do 29.09.23)	\N	257	0	257	2213
ARTEZAN CZARNA WOЈGA BUT. 0,5 L	5904730574020	211	0	211	2214
RADUGA GOOD MATERIAL BUT. 0,5 L	5902176771485	221	0	221	2215
TRZECH KUMPLI AMERICAN BEAUTY BUT. 0,5 L	5905669479349	448	0	448	2216
PODGУRZ MAЈY ALE WARIAT BUT. 0,5 L	5906874055540	262	0	262	2217
PINTA Beskidy APA 12,0° but. 0,5 l	5908252864188	1326	0	1326	2218
DUGGES MANGO SHAKE PUSZKA 0,33 L	7350038227492	219	0	219	2219
PIWNE PODZIEMIE ICE TEA BERLINER PUSZKA 0,5 L	5904305482378	480	0	480	2220
ROCKMILL FRIEND OR FOE? ARMAGNAC BA BUT. 0,33 L	5908291862497	230	0	230	2221
GOЊCISZEWO SOЈTYS BUT. 0,5 L	5903364108557	269	0	269	2222
TRZECH KUMPLI BREW NOTE PUSZKA 0,5 L	5904252699706	301	0	301	2223
MOINETTE BLONDE BUT. 0,33 L	5410702000133	244	0	244	2224
PRIMБTOR PREMIUM LAGER 12° BUT. 0,5 L	8594006933391	550	0	550	2225
MOINETTE BLONDE BUT. 0,75 L	5410702000119	230	0	230	2226
BUTELKA ZWR CZECHY ( B) 0,5 L	\N	581	0	581	2227
BIRBANT IMPERIAL CITRA IPA BUT. 0,5 L	5903240620142	1135	0	1135	2228
ONE MORE BEER T-SHIRT SZARY (XXL)	5123456791108	201	0	201	2229
3 FONTEINEN HOMMAGE BIO FRAMBOOS 2018/2019 BUT. 0,375 L	5425007818314	253	0	253	2230
ST. BERNARDUS WIT BUT. 0,33 L	54079052	572	0	572	2231
PINTA Koszulka HC czarna 3XL	5904165102973	202	0	202	2232
DE KONINCK TRIPLE D`ANVERS BUT. 0,33 L	54107090	219	0	219	2233
JURAJSKIE POMARAСCZA BUT. 0,5 L	5905331025362	1166	0	1166	2234
PINTA T-shirt biaіy duїe logo XL	5904165102478	202	0	202	2235
LUBROW INFUSED NO. 1 PUSZKA 0,33 L	5903686842832	233	7	233	2236
MIKKELLER SPONTAN DOUBLE CASSIS BUT. 0,375 L	5704255118736	219	0	219	2237
NIECZAJNA RUSSIAN IMPERIAL STOUT BUT. 0,5 L	5903796782233	268	0	268	2238
STAROPOLSKIE BESTBIR PACIFIC MANGO I ANANAS BUT. 0,5 L	5905669086653	244	0	244	2239
LINDEMANS SUMMERBERRY TAP HANDLE	5123456791012	202	0	202	2240
GRYFUS BASZTA BUT. 0,5 L	5907222685204	290	0	290	2241
LINDEMANS TAROT NOIR BUT. 0,25 L	5411223005300	2628	0	2628	2242
MINISTER PARADAJZ BUT. 0,5 L	5903351660006	476	0	476	2243
KORMORAN IRISH BEER BUT. 0,5 L	5902528300004	225	0	225	2244
RECRAFT JUICY SOUR SERIES – CHERRY X BLUEBERRY PUSZKA 0,5 L	5900779755871	287	0	287	2245
VAL-DIEU GRAND CRU BUT. 0,75 L	5413977000273	254	0	254	2246
BOON GEUZE SELECTION KEG 20 L	\N	202	0	202	2247
ZA MIASTEM OWOCNE ROZMOWY BUT. 0,5 L	5904905630216	334	0	334	2248
LA TRAPPE WITTE BUT. 0,33 L	8711406985489	451	0	451	2249
PINTA Pierwsza Pomoc 10,5° keg 20 l	5123456789764	208	0	208	2250
STELLA ARTOIS POKAL  0,5 L	5123456791064	216	0	216	2251
PINTA Mini Maxi IPA but. 0,5 l	5904730438001	2416	0	2416	2252
PINTA Otwieracz magnes Dobry Wieczуr	5904165101662	206	0	206	2253
CA' DEL BRADO PIE VELOCE BRUX CASCADE - BRETT ALE BUT. 0,375 L	\N	204	0	204	2254
BROWAR JANA BEZALKOHOLOWE BUT. 0,5 L	5902429980930	393	0	393	2255
CHYLICZKI CYDR LODOWY BUT. 0,375 L	5905279058040	237	0	237	2256
LINDEMANS ZIGZAG KORKOCIҐG W PUDEЈKU	5123456791128	206	0	206	2257
ZAKЈADOWY BAЈAGAN BUT. 0,5 L	5907753171597	275	0	275	2258
MALTGARDEN DREAMS GONE SOUTH BUT. 0,5 L	5907710943854	205	0	205	2259
BIG CHOUFFE BUT. 1,5 L	5410769100999	202	0	202	2260
STU MOSTУW WILD #18 MIXED FERMENTATION PIQUETTE SAISON BUT. 0,375 L	5907614682842	235	0	235	2261
STAROPOLSKIE PSZENNE BUT. 0,5 L	5905669086806	225	0	225	2262
PINTA Beskidy Pils 12,0° keg 30 l	5123456789672	202	0	202	2263
MATE MOC KATUAVA BUT. 0,33 L	5902768762891	363	0	363	2264
CHIMAY 150 / SPЙCIALE CENT CINQUANTE BUT. 0,33 L	5410908100118	317	0	317	2265
MIЈOSЈAW BEZALKOHOLOWE IPA BUT. 0,5 L	5902838990469	480	0	480	2266
RODENBACH VINTAGE 2021 BUT. 0,75 L	5410583804196	600	0	600	2267
INNE BECZKI NEIPARADISE PUSZKA 0,5 L	5903661281427	207	0	207	2268
NEPOMUCEN NACHMIELONA CHMIEL+SOSNA+JABЈKO+POMARAСCZA BUT. 0,5 L	5905279959996	291	0	291	2269
KAZIMIERZ GRUPA WZAJEMNEJ ADORACJI BUT. 0,5 L	5906660570707	210	0	210	2270
STELLA ARTOIS SZKLANKA 0,25 L	5123456791026	204	0	204	2271
PIRAAT RED BUT. 0,33 L PROMOCJA (do 07.10.23)	\N	221	0	221	2272
PINTA Barrel Brewing Courage but. 0,33 l	5904335577464	248	0	248	2273
ST. LOUIS PREMIUM KRIEK BUT. 0,25 L	5411081002220	241	0	241	2274
GRYFUS RUSAЈKA BUT. 0,5 L	5907222685181	270	0	270	2275
TRZECH KUMPLI RAUCHDOPPELBOCK BUT. 0,5 L	5905669479738	252	0	252	2276
FUNKY FLUID BEEP PUSZKA 0,5 L	5903999514167	599	0	599	2277
MORT SUBITE OUDE KRIEK BUT. 0,375 L	5411656052223	276	0	276	2278
PINTA Beskidy Prawdziwe Ciemne 15,0° but. 0,5 l	5904730438995	205	0	205	2279
MARYENSZTADT THE ROOTS#4 DOUBLE WEST COAST IPA PUSZKA 0,5 L	5903678022402	240	0	240	2280
CZTERY ЊCIANY POLANA BUT. 0,5 L	5905108498139	234	0	234	2281
FUNKY FLUID GELATO: PASSION FRUIT MANGO PEACH PUSZKA 0,5 L	5907772092552	1643	0	1643	2282
GRYBУW PILSVAR MIУD-MALINA BUT. 0,5 L	5902516000978	380	0	380	2283
MOCZYBRODA FRANKIE SAY RELAX PUSZKA 0,5 L	5904673800798	241	0	241	2284
PINTA Pils Time 12,0° can 0,5 l	5904165104281	713	0	713	2285
MOCZYBRODA HOPPY HOPAROO PUSZKA 0,5 L	5904673800910	225	0	225	2286
BOON OUDE GUEUZE VAT 91 BUT. 0,375 L	5412783000910	228	0	228	2287
MIO MIO MATE BUT. 0,5 L	4002846034528	737	0	737	2288
STAROPOLSKIE THE ART OF HOPPING HARMONIE SINGLE HOP PILS BUT. 0,5 L	5903021505514	291	0	291	2289
FUNKY FLUID COCONUT ZINGY PUSZKA 0,5 L	5903999514778	423	0	423	2290
SAMUEL SMITH ORGANIC CHOCOLATE STOUT BUT. 0,355 L	5010149201171	549	0	549	2291
ARTEZAN TEN COLLAB BUT. 0,5 L	5904708750739	260	0	260	2292
BIRBANT FOMO PUSZKA 0,5 L	5904041703751	231	0	231	2293
LITOVEL PREMIUM 12° KEG 30 L	\N	201	0	201	2294
O'HARA'S IRISH RED BUT. 0,5 L	5391500600025	278	0	278	2295
KORMORAN IMPERIUM PRUNUM BUT. 0,375 L	5902528342387	227	0	227	2296
KASTEEL ROUGE TABLICA REKLAMOWA	5123456791353	203	0	203	2297
MOCZYBRODA REBEL RAIDER BUT. 0,5 L	5904673800903	244	0	244	2298
BROKREACJA HERMIT PUSZKA 0,5 L	5904422197865	386	0	386	2299
LOCO BEER LEMON GRASS NON ALCOHOL BUT. 0,33 L	5907694918367	227	0	227	2300
PINTA Koszulka miкtowa S	5904165101303	202	0	202	2301
BROKREACJA ALL BEERS MATTER - ENGLISH IPA KEG 30 L	\N	201	0	201	2302
CORONADO STUPID STOUT BUT. 0,65 L	896311000019	205	0	205	2303
KAZIMIERZ DOBRE TO TO WYSZЈO #2 BUT. 0,5 L PROMOCJA (do 19.10.23)	\N	204	0	204	2304
VAULT CITY - FAITH IN SOUR PUSZKA 0,44 L	5056412005305	240	0	240	2305
STU MOSTУW WILD #20 CHERRY MIX FERMENTATION ALE BUT. 0,375 L	5907614682934	246	0	246	2306
PINTA Barrel Brewing - After Hours - Rose Wild Ale 12,0° keg 10 L	5123456780031	201	0	201	2307
KAZIMIERZ PILSIWKO BUT. 0,5 L	5906660570219	288	13	288	2308
LINDEMANS FRAMBOISE BUT. 0,25 L	5411223100487	2838	-36	2838	2309
GOЊCISZEWO SҐSIAD BUT. 0,5 L	5903364108007	282	0	282	2310
P?HJALA MUST KULD KEG 30 L	5123456789007	201	0	201	2311
NEPOMUCEN MILO BUT. 0,5 L	5905279959286	353	0	353	2312
NEPOMUCEN FREE PAN DA PUSZKA 0,5 L	5907709756434	256	0	256	2313
MARYENSZTADT SOURTIME STRAWBERRY & RHUBARB GOSE BUT. 0,5 L	5903424615193	320	0	320	2314
TRZECH KUMPLI PINK BOOTS 2023 KEG 20 L	\N	201	0	201	2315
O'HARA'S IRISH STOUT NITRO K-KEG 30 L	5391500601336	206	0	206	2316
FORTUNA MIODOWE BUT. 0,5 L	5902709615187	340	0	340	2317
BROKREACJA THE BARTENDER BUT. 0,5 L	5904422197735	255	0	255	2318
P?HJALA DRAYMAN'S BLEND BUT. 0,33 L	4742976015096	216	0	216	2319
BЈONIE KUR ZAPIAЈ PUSZKA 0,5 L	5908258856903	4300	0	4300	2320
ST. FEUILLIEN FIVE BUT. 0,33 L	5412138763316	231	0	231	2321
FLOREFFE POKAL  0,25 L	5123456791092	206	0	206	2322
INNE BECZKI FRESH PRINCE BUT. 0,5 L	5905669683319	868	0	868	2323
PETRUS BLOND BUT. 0,75 L	875213000228	214	0	214	2324
REVOLTA  ALKOHOLFREE 0% TONIC & LEMON EARL GREY AIPA BUT. 0,5 L	5900470095009	222	0	222	2325
STAROPOLSKIE BESTBIR PIERNIK ZE ЊLIWKҐ BUT. 0,5 L	5903021500243	230	0	230	2326
ENAME POKAL 0,33 L	5123456791093	224	0	224	2327
PINTA July Jungle Tour 12,0° keg 30 l	5123456780032	201	0	201	2328
ALEBROWAR CHILLIN' PICO - PINACOLADA BUT. 0,5 L	5907771343396	225	0	225	2329
STAROPOLSKIE BESTBIR IMBIR Z MIODEM BUT. 0,5 L	5905669086134	304	0	304	2330
BOON OUDE GUEUZE VAT 110 BUT. 0,375 L	5412783001108	209	0	209	2331
KORMORAN WIЊNIA W PIWIE BUT. 0,5 L	5902528410000	240	0	240	2332
LINDEMANS APPLE BUT. 0,355 L	5411223101095	656	0	656	2333
ZAKЈADOWY PRODUKT WZORCOWY BUT. 0,5 L	5906395388028	270	0	270	2334
MALTGARDEN GATE NO 1/2021 BUT. 0,5 L	5904050721388	220	0	220	2335
DUVEL BRELOK DO KLUCZY D (CZERWONY)	5123456791203	201	0	201	2336
PODGУRZ 652 M N.P.M. BUT. 0,5 L	5906874055007	291	0	291	2337
MONVIN BIANCO FRIZZANTE KEG 20 L	8013651024099	210	0	210	2338
KINGPIN MANDARIN BUT. 0,5 L	5904730290074	390	0	390	2339
BROWAR JANA PILS BUT. 0,5 L	5902429980251	352	0	352	2340
DUVEL BRELOK DO KLUCZY / OTWIERACZ	5123456791204	202	0	202	2341
ST. FEUILLIEN QUADRUPLE BUT. 0,33 L	5412138402604	261	0	261	2342
HOFSTETTNER GRANITBOCK WILDBRETT BUT. 0,75 L	5123456790128	207	0	207	2343
WIDAWA CHRZҐSTAWSKI LAGER BUT. 0,5 L	5907710904206	224	0	224	2344
MOCZYBRODA BITTER BURST PUSZKA 0,5 L	5904673801122	244	0	244	2345
AMBER ZЈOTE LWY BUT. 0,5 L	5906591000724	304	0	304	2346
NEPOMUCEN BERLINER INSIDE – MEET OUR PLACES | EPISODE 01: CHMIELARNIA PUSZKA 0,5 L	5904041706875	205	0	205	2347
FUNKY FLUID MODERN POLISH IPA PUSZKA 0,5 L	5903999510510	243	0	243	2348
CHIMAY GOLD KEG 20 L	5410908000166	202	0	202	2349
RODENBACH GRAND CRU BUT. 0,33 L	54125032	496	0	496	2350
HARPAGAN BAROTRAUMA TOBACCO BUT. 0,33 L	5905316580046	249	0	249	2351
HOEGAARDEN ROSEE 0% BUT. 0,25 L	5410228205876	213	0	213	2352
SVIJANY KNIZE 13% BUTELKA 0,5 L	8594030010051	275	0	275	2353
ZA MIASTEM WIELKA RADOЊЖ BUT. 0,5 L	5904905630230	1062	0	1062	2354
SCHNEIDER WEISSE SZKLANKA WEIZEN 0,5 L	5123456791260	506	0	506	2355
BROWAR JANA BEZGLUTENOWE JASNE PEЈNE BUT. 0,5 L	5902429980961	220	0	220	2356
STAROPOLSKIE KULTOWE PROZDROWOTNE 0,0% BUT. 0,5 L	5903021505118	335	0	335	2357
UNTITLE ART. ROCKY ROAD STOUT PUSZKA 0,473 L	854141006731	218	0	218	2358
PETRUS POLO SHIRT XL	5123456791360	202	0	202	2359
MOCZYBRODA VELVET NIGHTFALL BUT. 0,5 L	\N	211	0	211	2360
BOON KRIEK KIELISZEK  0,2 L	5123456791169	235	0	235	2361
CHIMAY BLUE BARRIQUE BUT. 0,75 L	5410908002344	279	0	279	2362
MARYENSZTADT WILD & FUNKY WILD QUADRUPEL RIOJA BARREL AGED PUSZKA 0,44 L	5903678022518	220	0	220	2363
BROWARNY PYRAMIDS PUSZKA 0,5 L	5905450141073	224	0	224	2364
ZA MIASTEM DZIEС WOLNY BUT. 0,5 L	5906874605028	388	0	388	2365
ZA MIASTEM WЈASNE SPRAWY BUT. 0,5 L	5906874605035	862	0	862	2366
LA TRAPPE DUBBEL BUT 0,33 L	8711406000564	1600	0	1600	2367
RACIBORSKIE PSZENICZNE ZW BUT. 0,5 L	5907506252450	305	0	305	2368
MAGIC ROAD SUMMER BANGER PUSZKA 0,5 L	5905204131053	274	0	274	2369
STONE / DOGFISH HEAD SAISON DU BUFF BUT. 0,5 L	636251870255	269	0	269	2370
WESTMALLE EXTRA BUT. 0,33 L	5412343000749	268	0	268	2371
PINTA Podkіadka korkowa Atak Chmielu 2011 Vintage	5903990622410	201	0	201	2372
MOINETTE BONS VOEUX BUT. 0,75 L	5410702000010	229	0	229	2373
DUBUISSON BUSH AMBER CARACTERE BUT. 0,75 L	5411551260723	231	0	231	2374
ARTEZAN CHATEAU 2021 BUT. 0,375 L	5904730574846	255	0	255	2375
ALEBROWAR BRAMBLE RUMBLE BUT. 0,5 L	5907771340692	315	0	315	2376
ALCORYTHM® TACA 20 SZT.	2590745162104	292	0	292	2377
ZAKЈADOWY PILS BUT. 0,5 L	5907753172228	300	0	300	2378
LINDEMANS GUEUZE CUVEE RENE BUT. 0,375 L	5411223100999	301	0	301	2379
LINDEMANS CASSIS BUT. 0,355 L	5411223101088	448	0	448	2380
PINTA Barrel Brewing Curiosity but. 0,375 l	5904335577457	517	0	517	2381
BRUGSE ZOT BLONDE BUT. 0,33 L	5425017240013	202	0	202	2382
LINDEMANS CASSIS BUT. 0,25 L	5411223100555	1517	12	1517	2383
GULDEN DRAAK CUVEE PRESTIGE MADEIRA BUT. 0,75 L	5411663708908	221	0	221	2384
ROCKMILL FRIEND OR FOE? RUM BA BUT. 0,33 L	5908291862480	214	0	214	2385
ALEBROWAR SINGLE HOP AMORA PRETA BUT. 0,5 L	5907771343235	478	0	478	2386
IMBIOROWICZ MIУD PITNY TRУJNIAK 966 BUT. 0,75 L	5905669820073	206	0	206	2387
STAROPOLSKIE BESTBIR LETNIA ЊLIWKA BUT. 0,5 L	5903111989972	303	0	303	2388
PINTA / Sibeeria Cold's Cool 13,0° keykeg 20 l	\N	206	0	206	2389
WRКЇEL HEFEWEIZEN PSZENICZNE JASNE BUT. 0,5 L	5904730465045	282	0	282	2390
3 FONTEINEN HOMMAGE BIO 2018/19 BUT. 0,75 L	5425007818154	212	0	212	2391
INNE BECZKI MIAMI BUT. 0,5 L	5905669683180	1229	0	1229	2392
ROCKMILL INFINITY RUM BA BUT. 0,5 L	5908291862299	201	0	201	2393
SCHLENKERLA HELLES LAGERBIER 11,0° BUT. 0,5 L	4037458000111	479	0	479	2394
CHYLICZKI CYDR STARY SAD 2022 BUT. 0,33 L	5905279058033	249	0	249	2395
3 FONTEINEN HOMMAGE BUT. 0,75 L	5425007818123	206	0	206	2396
ЈAСCUT MOPS 'N' HOPS BUT. 0,5 L	5906395997992	331	0	331	2397
STU MOSTУW NON ALCOHOLIC BERLINER WEISSE PECH & APRICOT BUT. 0,5 L	5907614682798	263	0	263	2398
FLOREFFE TRIPLE BUT. 0,33 L	5411276200516	232	0	232	2399
NEPOMUCEN ODRA PANY PUSZKA 0,5 L	5904555992788	358	0	358	2400
LA TRAPPE BLONDE BUT. 0,75 L	8711406121580	326	0	326	2401
WIDAWA AUGUSTIAСSKIE BUT. 0,5 L	5907710904022	220	0	220	2402
WRКЇEL MIЊ WOJTEK BRAGGOT BUT. 0,5 L	5904181970419	201	0	201	2403
CYRILOVY BRAMBURKY CZOSNKOWE - CHIPSY 100 G	8594021041071	330	0	330	2404
ARTEZAN LOST IN THE WOODS BUT. 0,5 L	5904708750777	235	0	235	2405
ROCKMILL INFINITY ARMAGNAC BA BUT. 0,5 L	5908291862305	206	0	206	2406
LUBROW BLEND NO. 2 PUSZKA 0,33 L	5903686842870	303	0	303	2407
LINDEMANS KRIEK BUT. 0,355 L	5411223101033	887	0	887	2408
KINGPIN WEIZEN BUT. 0,5 L	5904730290746	235	0	235	2409
PINTA Psst... It's Your Weekend IPA - Foggy IPA 15,0° but. 0,5 l	5904165104700	1046	0	1046	2410
FUNKY FLUID THUNDER BOLT PUSZKA 0,5 L	5903999514761	301	0	301	2411
JAN OLBRACHT ZESTAW KORD BUT. 0,33 L + POKAL	5902627010873	213	0	213	2412
ZA MIASTEM CICHY WIECZУR BUT. 0,5 L	5906874605011	301	0	301	2413
HANSSENS OUDE GUEUZE BUT. 0,75 L	5430000304016	211	0	211	2414
NEPOMUCEN NACHMIELONA CHMIEL+SOSNA+JABЈKO+POMARAСCZA PUSZKA 0,5 L	5905191386702	279	0	279	2415
KINGPIN LUNATIC BUT. 0,5 L PROMOCJA (do 13.10.23)	\N	276	0	276	2416
P?HJALA ELECTRIC BABA TONKA BUT. 0,33 L	4742976015157	210	0	210	2417
ZULI MELARYA IMBIR BUT. 0,33 L	5904933314201	292	0	292	2418
PINTA IIPPAA 18,0° keg 30 l	5123456789723	213	0	213	2419
JURAJSKIE WIЊNIA W CZEKOLADZIE BUT. 0,5 L	5905331026017	289	0	289	2420
KEG AYINGER / HOSL 30 L	5123456792012	238	0	238	2421
MARYENSZTADT SOURTIME PASTRY SOUR IPA MANGO & PEACH BUT. 0,5 L	5903424615964	210	0	210	2422
MAGIC ROAD NA STO DWA SZKLANEK PUSZKA 0,5 L	5905204130711	277	0	277	2423
CIESZYN WHEAT WINE BUT. 0,33 L	5907612240341	244	0	244	2424
HANSSENS OUDBEITJE BUT. 0,375 L	5430000304078	207	0	207	2425
GOЊCISZEWO KOMTUR BUT. 0,5 L	5903364108281	226	0	226	2426
BROKREACJA THE NURSE BUT. 0,5 L	5905669783095	317	0	317	2427
CANTILLON ROSE DE GAMBRINUS 2022 BUT. 0,375 L	5123456790017	259	0	259	2428
ARTEZAN PAKIET POWITALNY BUT. 0,5 L	5904708750760	256	0	256	2429
JUPILER T-SHIRT (L)	5123456791191	201	0	201	2430
PINTA Koszulka szara XXL	5904165101297	202	0	202	2431
LITOVEL ИERNY CITRON 4% BZW.  BUT. 0,5 L	8593875518418	335	0	335	2432
FUNKY FLUID HONK PUSZKA 0,5 L	5903999514020	216	0	216	2433
RADUGA LAST SUMMER BUT. 0,5 L	5902448150178	384	0	384	2434
PINTA Koszulka HC czarna 2XL	5904165102966	203	0	203	2435
ALEBROWAR ICED SWEET AS SONYA BUT. 0,25 L	5907771341910	211	0	211	2436
NEPOMUCEN FOR.REST BUT. 0,5 L	5907709756243	404	0	404	2437
MARYENSZTADT NEW BLACK - CHOCOLATE HAZELNUT OAT STOUT BUT. 0,5 L PROMOCJA (do 29.09.23)	\N	205	0	205	2438
P?HJALA ORANGE GOSE PUSZ. 0,33 L	4742976013610	224	0	224	2439
LEFFE BLONDE BUT. 0,33 L	5410228142089	378	0	378	2440
CHYLICZKI CYDR SZARA & ZЈOTA RENETA KEG 30 L	5123456789034	202	0	202	2441
DRY & BITTER CZAPKA ZIMOWA BORDOWA	5123456791381	201	0	201	2442
BROWAR JANA IPA BUT. 0,5 L	5902429980145	465	0	465	2443
ST. FEUILLIEN TRIPLE BUT. 0,75 L	5412138507552	225	0	225	2444
NOOK EBONO BUT. 0,33 L	5903240848409	277	0	277	2445
STAROPOLSKIE BESTBIR KOKOS BUT. 0,5 L	5905669086073	306	0	306	2446
JURAJSKIE SZATAСSKA OBELGA BUT. 0,5 L	5905331025485	381	0	381	2447
PINTA Szklanka Omer 2021 0,3 l	5904165100689	213	0	213	2448
MALTGARDEN CUSTOM SNEAKERS PUSZKA 0,5 L	5907710943014	211	0	211	2449
FUNKY FLUID CRAZY HAZY BUT. 0,5 L	5907772092187	389	0	389	2450
STU MOSTУW PALE ALE BUT. 0,5 L	5905279213234	244	0	244	2452
ЈAСCUT CZARNA POLEWKA BUT. 0,5 L	5906395997008	250	0	250	2453
VAL-DIEU BRUNE BUT. 0,75 L	5413977000068	245	0	245	2454
CANTILLON GUEUZE LAMBIC-BIO 2022 BUT. 0,375 L	5411024000047	241	0	241	2455
PINTA Kwas Gamma 13,0° keg 30 l	5123456789703	214	0	214	2456
RADUGA KINGDOM OF FRUITS BUT. 0,5 L	5902176772055	292	0	292	2457
ZAKЈADOWY CO BКDZIE W LIPCU? BUT. 0,5 L	5907753172358	235	0	235	2458
NEPOMUCEN SZOSA PUSZKA 0,5 L	5904041706288	328	0	328	2459
ЈAСCUT DIMI3RI BUT. 0,33 L	5906395997732	253	0	253	2460
PINTA Modern Drinking 15,0° but. 0,5 l	5904730438599	1512	0	1512	2461
MARYENSZTADT OAT CHOCOLATE RIS HEAVEN HILL KENTUCKY STRAIGHT BURBON WHISKEY & COGNAC B.A. BUT. 0,33 L PROMO	\N	213	0	213	2462
MORT SUBITE GUEUZE BUT. 0,375 L	5411656052001	282	0	282	2463
DUGGES BLOOM PUSZKA 0,33 L	7350038225948	219	0	219	2464
YOKO Matcha BIO but. 0,33 l	5902768514988	411	0	411	2465
PINTA Collab PL: Brokreacja 15,0° can 0,5 l	5904165104564	633	0	633	2466
MORT SUBITE OUDE GUEUZE BUT. 0,375 L	5411656052193	234	0	234	2467
SCHNEIDER BLACHA REKLAMOWA	5123456791339	209	0	209	2468
LINDEMANS T-SHIRT MКSKI SZARY (L)	\N	201	0	201	2469
LINDEMANS FARO KEG 20 L	5123456789030	203	0	203	2470
CYRILOVY BRAMBURKY MUSZTARDOWE - CHIPSY 100 G	8594021041088	377	0	377	2471
MINISTER PILZNER BUT. 0,5 L	5903351660105	756	0	756	2472
LINDEMANS KIELISZEK 3-IN-1 0,25 L	5123456791171	238	0	238	2473
BIRBANT KOLO% PUSZKA 0,5 L	5904041703713	241	0	241	2474
MIKKELLER SPONTAN CARROT BUT. 0,375 L	5704255117975	225	0	225	2475
ALEBROWAR BANA MAMA BUT. 0,5 L	5907771342320	204	0	204	2476
MIЈOSЈAW PERRY MIЈOSЈAWSKI BUT. 0,5 L	5901687910512	342	0	342	2477
SATAN BLACK BUT. 0,33 L	5412107000794	248	0	248	2478
MOCZYBRODA LSD (LIGHT SOUR DELICIOUS) BUT. 0,5 L	5903351761307	396	0	396	2479
PINTA Collab PL: Cztery Њciany 15,0° keg 20 l	5123456780040	206	0	206	2480
VITAMINE SEA BABY WAVES PUSZKA 0,473 L	5123456790115	208	0	208	2481
ST. BERNARDUS CHRISTMAS ALE BUT. 0,75 L	5411911004004	207	0	207	2482
TRZECH KUMPLI WONDER HAZE PUSZKA 0,5 L	5904252699539	726	0	726	2483
MAGIC ROAD CHOCOLATE BAR VOL. 2 HEAVEN HILL & WILD TURKEY DBA PUSZKA 0,33 L	5905204130339	208	0	208	2484
TRZECH KUMPLI PAN IPANI BUT. 0,5 L	5905669479196	1072	0	1072	2485
BROWAR JANA WEIZEN MARAKUJA BUT. 0,5 L	5902429981449	254	0	254	2486
KAZIMIERZ BABCIA RУZIA BUT. 0,5 L	5906660570523	215	0	215	2487
RECRAFT AMSTERDAM PILS PUSZKA 0,5 L	5904730663748	225	0	225	2488
PINTA Koszulka HC czarna M	5904165102997	202	0	202	2489
MIKKELLER BLACK BUT. 0,375 L	818534018534	355	0	355	2490
CIESZYN KARTONIK A4	5123456791385	220	0	220	2491
ARTEZAN UЊMIECH BOMBELKA BANAN-BRZOSKWINIA-TRUSKAWKA PUSZKA 0,5 L	5904708750272	480	0	480	2492
90 BPM BIERE NOIRE PIVO PUSZ. 0,33 L	683489591551	202	0	202	2493
BRUNEHAUT TRIPLE BIO GLUTEN FREE BUT. 0,75 L	5411065201311	234	0	234	2494
STONE STYGIAN DESCENT 2016 BUT. 0,5 L	636251740718	225	0	225	2495
ALEBROWAR LADY BLANCHE BUT. 0,5 L	5907222039137	650	0	650	2496
BROKREACJA EDWARD BUT. 0,5 L	5904422197957	269	0	269	2497
RODENBACH CARACTERE ROUGE BUT. 0,75 L	5410583802482	322	0	322	2498
PODGУRZ IMPERIALNY 652 M N.P.M BUT. 0,5 L	5906874055373	311	0	311	2499
BROKREACJA SAVAGE 005 BUT. 0,5 L	5904422197537	244	0	244	2500
ZAKЈADOWY BUMELANT BUT. 0,5 L PROMOCJA (do 04.10.23)	\N	244	0	244	2501
SCHLENKERLA SPIEL - GRA PLANSZOWA	5123456791314	204	0	204	2502
CHIMAY BLUE BUT. 0,75 L	5410908000074	432	0	432	2503
PRAIRIE BOMB! DECONSTRUCTED: CHILLI BUT. 0,355 L	680132989055	249	0	249	2504
PINTA Hazy Discovery Timisoara can 0,5 l	5904165105097	937	0	937	2505
CHIMAY RED BUT. 1,5 L	5410908500048	202	0	202	2506
MOCZYBRODA BITTER SYMPHONY PUSZKA 0,5 L	5904673800873	214	0	214	2507
ANCHOR SZKLANKA 1/2 PINT	5123456791391	206	0	206	2508
P?HJALA CHВTEAU NOIR BUT. 0,33 L	4742976014778	218	0	218	2509
ST. FEUILLIEN BRUNE BUT. 0,33 L	5412138203317	282	0	282	2510
PINTA Psst... It's Your Weekend IPA - Hazy IPA 15,0° keg 30 l	5123456780047	202	0	202	2511
KASTEEL POKAL 0,5 L	5123456791311	252	0	252	2512
WIDAWA LE POLONAISE C’T’UNE JOKE’21 MARSALA BA BUT. 0,75 L	5907710904084	231	0	231	2513
KINGPIN BURLESCA BUT. 0,33 L	5904730290180	243	0	243	2514
ST. GUMMARUS DUBBEL KEG 20 L	\N	202	0	202	2515
PINTA Hazy Morning 12,0° but. 0,5 l	5904730438612	2069	0	2069	2516
SMYKAN CYDR KWAЊNY ZDZICHU KEG 30 L	5123456791300	205	0	205	2517
KAZIMIERZ NORMALNE PIWO BUT. 0,5 L	5906660570448	251	0	251	2518
MARYENSZTADT FREEKY ORANGE ALE BUT 0,5 L	5903424615292	322	0	322	2519
PINTA Koszulka їуіta L	5904165100481	202	0	202	2520
KORMORAN RADLER GORZKA POMARAСCZA BUT. 0,5 L	5902528119828	297	0	297	2521
HOLBA PREMIUM 12° KEG 30 L	\N	205	0	205	2522
KOMES ZESTAW KONESERA 4 PIWA 0,5 L + POKAL	5901687910857	234	0	234	2523
ZULI MELARYA CHMIEL BUT. 0,33 L	5904933314218	271	0	271	2524
MAGIC ROAD SAWA SAWA PUSZKA 0,5 L	5905204131107	212	0	212	2525
DEER BEAR COLD CAT PUSZKA 0,5 L	5905204172186	263	0	263	2526
MIKKELLER SPONTAN SEA BUCKTHORN BUT. 0,375 L	818534013126	206	0	206	2527
SCHNEIDER KUBEK PLASTIKOWY 0,5 L	5123456791326	244	0	244	2528
ARTEZAN ZIELONE ЊWIATЈO BUT. 0,5 L	5904708750449	205	0	205	2529
FUNKY FLUID KALIMERA PUSZKA 0,5 L	5903999514631	295	8	295	2530
FUNKY FLUID NECTARINE SOUR PUSZKA 0,5 L	5903999514143	308	0	308	2531
DUGGES MANGO MANGO MINI PUSZKA 0,33 L	7350038226525	248	0	248	2532
GOЊCISZEWO CZAROWNICA BUT. 0,5 L	5903364108854	222	0	222	2533
STONE SNIFTER STONE 0,33 L	5123456791058	511	0	511	2534
JURAJSKIE JABЈKO-MIКTA BUT. 0,5 L	5905331025997	340	0	340	2535
RECRAFT CITRUS INDIA PALE ALE PUSZKA 0,5 L	5904730663809	438	0	438	2536
IGNACУW CYDR SICERO BUT. 0,5 L	5902768323030	329	0	329	2537
PETRUS KIELICH 0,33 L	5123456791178	404	0	404	2538
SCHNEIDER TAP09 AVENTINUS EISBOCK 25,5° BUT. 0,33 L	4003669018269	608	0	608	2539
TARNOBRZEG SUPERSTAR VOL.3 BUT. 0,5 L	5904533544121	350	0	350	2540
MIЈOSЈAW MARCOWE BUT. 0,5 L	5902709615286	210	0	210	2541
KORMORAN ZЈOTY EXPORT LAGER BUT. 0,5 L	5902528000065	234	0	234	2542
ALEBROWAR SINGLE HOP KOHATU BUT. 0,5 L	5907771343259	223	0	223	2543
ZA MIASTEM DЈUGI WEEKEND BUT. 0,5 L	5906874605004	549	0	549	2545
PRAIRIE ALE BUT. 0,5 L	894776000179	214	0	214	2546
DZIKI WSCHУD KIRRAI PUSZKA 0,5 L	5906874369081	228	0	228	2547
CUVEE DES TROLLS BUT. 0,25 L	5411551141091	262	0	262	2548
CORSENDONK PATER DOUBLE BUT. 0,33 L	54069015	249	0	249	2549
ARTEZAN KOSZYK NA 8 LITER BUT. 0,5 L	5904708750685	244	0	244	2550
VIGO Kombucha Original but. 0,33 l	5902768514803	297	0	297	2551
SCHNEIDER WEISSE SZKLANKA  ALKOHOFREI 0,5 L	5123456791257	227	0	227	2552
PETRUS RED CZAPKA Z DASZKIEM	5123456791376	201	0	201	2553
PIWNE PODZIEMIE EXOTICA PUSZKA  0,5 L	5904305482095	554	0	554	2554
FUNKY FLUID FIVE FINGER DISCOUNT PUSZKA 0,5 L	5903999512934	231	0	231	2555
LINDEMANS APPLE BUT. 0,25 L	5411223100579	607	0	607	2556
WRКЇEL ZERO BUT. 0,5 L	5904181970105	230	0	230	2557
P?HJALA OHTU PUSZKA 0,33 L	4742976013726	219	0	219	2558
FUNKY FLUID LAGER BUT. 0,5 L	5903999514426	226	0	226	2559
LIMBURGSE WITTE POKAL 0,25 L	5123456791074	247	0	247	2560
FUNKY FLUID HITS FROM THE BONG BUT. 0,5 L	5903999510459	202	0	202	2561
NEPOMUCEN BE CAREFUL BUT. 0,5 L	5907709756052	285	0	285	2562
DRY& BITTER BLACHA REKLAMOWA	5123456791365	201	0	201	2563
CHIMAY 150 / SPЙCIALE CENT CINQUANTE BUT. 0,75 L	5410908100149	289	0	289	2564
TRZECH KUMPLI UNPLUGGED CITRUS APA 0,0% BUT. 0,5 L	5904252699799	1021	0	1021	2565
BIRBANT LAGER PUSZKA 0,5 L	5904041703430	359	0	359	2566
SARABANDA SOURVENTURE PUSZKA 0,5 L	5904501978231	273	0	273	2567
CIESZYN POKAL 0,3 L	5123456791332	202	0	202	2568
ED RED STROGANOV Z PКCZAKIEM - WIEPRZOWINA	5904083584158	210	0	210	2569
CINEY BLOND BUT.0,25 L	54055308	268	0	268	2570
RACIBORSKIE PORTER BUT. 0,5 L	5907506252115	320	0	320	2571
PINTA MASTERBAR Vanilla & Coconut 30,0° keg 10 l	\N	201	0	201	2572
ANDERSON VALLEY SZKLANKA SHAKER 0,5 L	5123456791394	208	0	208	2573
KORMORAN BARLOW SORBUS  BUT. 0,375 L	5902528000409	240	0	240	2574
SMYKAN CYDR CHMIELONY SAD BUT. 0,75 L	5905669332156	257	0	257	2575
MARYENSZTADT BEZGLUTENOWY OATMEAL STOUT BUT. 0,5 L	5903678022549	329	0	329	2576
TOOL POLYRADIANT BUT. 0,75 L	5711474008915	203	0	203	2577
RADUGA NOSFERATU PUSZKA 0,5 L	5902176772024	399	0	399	2578
FORTUNA CZARNE WHISKY WOOD BUT. 0,5 L	5902838990544	300	0	300	2579
NEPOMUCEN FRUTOLLO PUSZKA 0,5 L	5907709756939	233	12	233	2580
STU MOSTУW LAST MINUTE PUSZKA 0,44 L	5907614683177	253	8	253	2581
IMBIOROWICZ MIУD PITNY TRУJNIAK ЇҐDЈO Z KAWҐ BUT. 0,5 L	5905669820462	207	10	207	2582
KEG LINDEMANS 20/25 L	5123456792018	367	8	367	2583
MOCZYBRODA WIT ME BABY BUT. 0,5 L	5903351761369	502	10	502	2584
PINTA Їytorillo 14,0° keg 30 l	5123456780024	206	7	206	2585
NEPOMUCEN HEAT PUSZKA 0,5 L	5904041706684	260	9	260	2586
3 FONTEINEN FRAMBOOS OOGST 2017 BUT. 0,75 L	5425007818116	202	12	202	2587
LA CHOUFFE BLONDE BUT. 0,75 L	5410769100098	405	15	405	2588
INNE BECZKI PILZNER BUT. 0,5 L	5905669683043	603	7	603	2589
FUNKY FLUID GELATO: BANANA CREPES SUZETTE PUSZKA 0,5 L	5903999514655	272	5	272	2590
WIDAWA NZ PILS BUT. 0,5 L	5907710904220	317	7	317	2591
TARNOBRZEG WHEATART BUT. 0,5 L	5904533544046	490	14	490	2592
NEPOMUCEN NACHMIELONA CHMIEL+JABЈKO+CYTRYNA PUSZKA 0,5 L	5905191386696	305	15	305	2593
BROKREACJA BATTLE MASTER 2023 BUT. 0,33 L	5905910086012	333	6	333	2594
PINTA BARREL BREWING PERCEPTION 30,0° BUT. 0,33 L	5904335577471	208	5	208	2595
NOOK MAHAGANO BUT. 0,33 L	5903240848393	210	6	210	2596
VIGO Kombucha BIO Ogуrek Kolendra but. 0,33 l	5902768514322	216	14	216	2597
LOCO BEER TROPICAL NON ALCOHOL BUT. 0,33 L	5907694918374	271	6	271	2598
PINTA Koszulka їуіta XXL	5904165100504	202	15	202	2599
VERHAEGHE CHOCOLATE CHERRY DUCHESSE DE BOURGOGNE BUT. 0,33 L	5411364151928	298	9	298	2600
IMBIOROWICZ MIУD PITNY TRУJNIAK MEADNIGHT BUT. 0,5 L	5905669820646	231	-28	231	2601
JAN OLBRACHT KORD JACK WHISKEY BARREL AGED BUT. 0,37 L	5902627012822	262	0	262	2602
OUD BEERSEL TRADITIONAL OUDE GEUZE/KRIEK SZKLANKA 0,25 L	5123456791103	267	10	267	2603
TRZECH KUMPLI WКDZONY PORTER BAЈTYCKI KEG 20 L	5123456789924	201	1	201	2604
DUGGES ASTEROID PUSZKA 0,5 L	7350038227355	208	12	208	2605
AYINGER ALTBAIRISCH DUNKEL BUT. 0,5 L	4104170020700	343	13	343	2607
SCHLENKERLA RAUCHBIER MДRZEN UNGEFILTERET 13,5° BUT. 0,5 L	4037458021109	379	6	379	2608
VITAMINE SEA GREETINGS FROM WEYMOUTH PUSZKA 0,473 L	5123456790116	204	4	204	2609
CANTILLON SAINT LAMVINUS KEG 20 L	5123456789014	202	2	202	2610
PINTA I'm so Horny! 18,0° but. 0,5 l	5904165103864	890	15	890	2611
TRZECH KUMPLI WКDZONY PORTER BAЈTYCKI BUT. 0,5 L	5904252699638	369	9	369	2612
MARYENSZTADT BARREL AGED ICE BRETT PORTER DOUBLE BA - SUSZONA ЊLIWKA I CYNAMON PUSZKA 0,44 L	5903424615131	405	13	405	2613
FUNKY FLUID WATCH YA SELF PUSZKA 0,5 L	5903999514556	251	15	251	2606
MAGIC ROAD WON’T YOU TELL ME YOUR NAME? PUSZKA 0,5 L	5905204130605	219	10	219	2614
MOCZYBRODA PEARFECTLY GREEN PUSZKA 0,5 L	5904673801061	283	5	283	2615
LINDEMANS GUEUZE TAP HANDLE	5123456791015	201	11	201	2616
MAGIC ROAD CITRUS GIVEAWAY PUSZKA 0,5 L	5905204130698	203	3	203	2617
REVOLTA NON ALCOHOLIC LEMON EARL GREY AIPA BUT. 0,5 L	5900470056000	462	8	462	2618
SCHNEIDER TAP05 HOPFENWEISSE  18,5° KEG 20 L	2100006E34652	201	8	201	2619
CHYLICZKI GRAFF NO. 1 BUT. 0,5 L	5905279058231	204	9	204	2620
WRКЇEL MILK ME BUT. 0,5 L	5904730465366	193	-30	193	2621
MIKKELLER SPONTAN TRIPPLE CHERRY 2020 BUT. 0,375 L	5704255121095	203	0	203	2622
MIЈOSЈAW SOSNOWE APA BUT. 0,5 L	5901687910765	297	0	297	2623
BOON FARO BUT. 0,25 L	5412783054012	264	7	264	2624
CHIMAY KIELICH W PUDEЈKU 0,33 L	5123456791185	212	10	212	2625
MAGIC ROAD (EVERGREEN PRETTY)3 PUSZKA 0,5 L	5905204130773	204	11	204	2626
STAROPOLSKIE KULTOWE BEZ GLUTENU MIODOWE BUT. 0,5 L	5903021500625	210	7	210	2627
CIESZYN LAGER BUT. 0,5 L	5905279156005	433	6	433	2628
ED RED KONSERWA CHILI SIN CARNE	5904083584059	210	5	210	2629
CIESZYN BEZALKOHOLOWY LAGER BUT. 0,5 L	5905279156814	295	11	295	2630
ZIEMIA OBIECANA BANIALUKI PUSZKA 0,5 L	5905186484666	220	11	220	2631
DEER BEAR KAME HAME KEG 30 L	5123456789116	202	2	202	2632
LA TRAPPE ISID`OR BUT. 0,75 L	8711406136775	376	13	376	2633
WESTMALLE TRIPEL BUT. 0,33 L	5412343201337	208	14	208	2634
SOWIE INDUKTOR BUT. 0,5 L	5907222560846	413	12	413	2635
PINTA Bluza bordowa M	5904165100573	202	7	202	2636
GRYFUS SZKLANKA 0,5 L	5123456791395	318	9	318	2637
FUNKY FLUID ASHES & DIAMONDS RAISINS / FIGS / DATES BUT. 0,33 L	5903999511876	223	11	223	2638
KAZIMIERZ KWASIMIERZ BUT. 0,5 L	5906660570141	313	13	313	2639
TRYBUNAЈ PILS BUT. 0,5 L	5905689308124	569	6	569	2640
O'HARA'S FREEBIRD IPA BUT. 0,5 L	5391500601169	241	6	241	2641
GRIMBERGEN DESKA DEGUSTACYJNA	5123456791350	204	12	204	2642
TRZECH KUMPLI RUSTY KEG 30 L	5123456789506	201	1	201	2643
BROWARNY UNHOLY PUSZKA 0,5 L	5905450141080	300	5	300	2644
SCHLENKERLA SZKLANKA WEIZEN 0,5 L	5123456789848	233	0	233	2645
PINTA Hazy Morning 12,0° keg 20 l	5123456789712	200	0	200	1135
ZA MIASTEM POGODA DUCHA BUT. 0,5 L	5906874605073	237	0	237	428
KOMES RUSSIAN IMPERIAL STOUT BUT. 0,5 L	5901687910840	201	0	201	1112
ROCKMILL SOURLAND #1 PUSZKA 0,5 L	5908291862725	356	0	356	2451
PINTA Hop Selection - Simcoe can 0,5 l	5904165104786	200	0	200	553
ALEBROWAR HERR AXOLOTL WITH SABRO & HBC472 HOPS BUT. 0,5 L	5907771343464	270	0	270	536
STRUISE / PIPEWORKS XENOPHON'S WINE BUT. 0,33 L	5425017200062	207	7	207	1088
MALTGARDEN SUMMER MOVIE PUSZKA 0,5 L	5907710943267	252	13	252	893
RODENBACH FRUITAGE BUT. 0,25 L	54125063	1509	7	1509	2544
KASTEEL CUVEE DU CHATEAU BUT. 0,33 L	5411081004811	202	2	202	239
KOMES BARLEY WINE BUT. 0,5 L	5902838990285	240	7	240	1965
PIWOTEKA CZAISZ BAZК: EARL GREY BUT. 0,5 L	5905669428095	253	0	260	1484
FUNKY FLUID CLOUDY PUSZKA 0,5 L	5907772092316	1232	0	1242	1818
WRКЇEL MALTIC STORM BUFFALO TRACE BUT. 0,5 L	5904181970303	295	7	295	1673
STAROPOLSKIE NIEMDЈE ANANASOWE BUT. 0,5 L	5903021503350	285	11	285	588
AMBER MARANGO BUT. 0,5 L	5906591002995	220	5	220	767
\.


--
-- TOC entry 4892 (class 0 OID 25177)
-- Dependencies: 216
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.suppliers (supplier_id, company_name, contact_name, contact_title, address, city, region, postal_code, country, phone, fax, homepage) FROM stdin;
1	Exotic Liquids	Charlotte Cooper	Purchasing Manager	49 Gilbert St.	London	\N	EC1 4SD	UK	(171) 555-2222	\N	\N
2	New Orleans Cajun Delights	Shelley Burke	Order Administrator	P.O. Box 78934	New Orleans	LA	70117	USA	(100) 555-4822	\N	#CAJUN.HTM#
3	Grandma Kelly's Homestead	Regina Murphy	Sales Representative	707 Oxford Rd.	Ann Arbor	MI	48104	USA	(313) 555-5735	(313) 555-3349	\N
4	Tokyo Traders	Yoshi Nagase	Marketing Manager	9-8 Sekimai Musashino-shi	Tokyo	\N	100	Japan	(03) 3555-5011	\N	\N
5	Cooperativa de Quesos 'Las Cabras'	Antonio del Valle Saavedra	Export Administrator	Calle del Rosal 4	Oviedo	Asturias	33007	Spain	(98) 598 76 54	\N	\N
6	Mayumi's	Mayumi Ohno	Marketing Representative	92 Setsuko Chuo-ku	Osaka	\N	545	Japan	(06) 431-7877	\N	Mayumi's (on the World Wide Web)#http://www.microsoft.com/accessdev/sampleapps/mayumi.htm#
7	Pavlova, Ltd.	Ian Devling	Marketing Manager	74 Rose St. Moonie Ponds	Melbourne	Victoria	3058	Australia	(03) 444-2343	(03) 444-6588	\N
8	Specialty Biscuits, Ltd.	Peter Wilson	Sales Representative	29 King's Way	Manchester	\N	M14 GSD	UK	(161) 555-4448	\N	\N
9	PB Knäckebröd AB	Lars Peterson	Sales Agent	Kaloadagatan 13	Göteborg	\N	S-345 67	Sweden	031-987 65 43	031-987 65 91	\N
10	Refrescos Americanas LTDA	Carlos Diaz	Marketing Manager	Av. das Americanas 12.890	Sao Paulo	\N	5442	Brazil	(11) 555 4640	\N	\N
11	Heli Süßwaren GmbH & Co. KG	Petra Winkler	Sales Manager	Tiergartenstraße 5	Berlin	\N	10785	Germany	(010) 9984510	\N	\N
12	Plutzer Lebensmittelgroßmärkte AG	Martin Bein	International Marketing Mgr.	Bogenallee 51	Frankfurt	\N	60439	Germany	(069) 992755	\N	Plutzer (on the World Wide Web)#http://www.microsoft.com/accessdev/sampleapps/plutzer.htm#
13	Nord-Ost-Fisch Handelsgesellschaft mbH	Sven Petersen	Coordinator Foreign Markets	Frahmredder 112a	Cuxhaven	\N	27478	Germany	(04721) 8713	(04721) 8714	\N
14	Formaggi Fortini s.r.l.	Elio Rossi	Sales Representative	Viale Dante, 75	Ravenna	\N	48100	Italy	(0544) 60323	(0544) 60603	#FORMAGGI.HTM#
15	Norske Meierier	Beate Vileid	Marketing Manager	Hatlevegen 5	Sandvika	\N	1320	Norway	(0)2-953010	\N	\N
16	Bigfoot Breweries	Cheryl Saylor	Regional Account Rep.	3400 - 8th Avenue Suite 210	Bend	OR	97101	USA	(503) 555-9931	\N	\N
17	Svensk Sjöföda AB	Michael Björn	Sales Representative	Brovallavägen 231	Stockholm	\N	S-123 45	Sweden	08-123 45 67	\N	\N
18	Aux joyeux ecclésiastiques	Guylène Nodier	Sales Manager	203, Rue des Francs-Bourgeois	Paris	\N	75004	France	(1) 03.83.00.68	(1) 03.83.00.62	\N
19	New England Seafood Cannery	Robb Merchant	Wholesale Account Agent	Order Processing Dept. 2100 Paul Revere Blvd.	Boston	MA	02134	USA	(617) 555-3267	(617) 555-3389	\N
20	Leka Trading	Chandra Leka	Owner	471 Serangoon Loop, Suite #402	Singapore	\N	0512	Singapore	555-8787	\N	\N
21	Lyngbysild	Niels Petersen	Sales Manager	Lyngbysild Fiskebakken 10	Lyngby	\N	2800	Denmark	43844108	43844115	\N
22	Zaanse Snoepfabriek	Dirk Luchte	Accounting Manager	Verkoop Rijnweg 22	Zaandam	\N	9999 ZZ	Netherlands	(12345) 1212	(12345) 1210	\N
23	Karkki Oy	Anne Heikkonen	Product Manager	Valtakatu 12	Lappeenranta	\N	53120	Finland	(953) 10956	\N	\N
24	G'day, Mate	Wendy Mackenzie	Sales Representative	170 Prince Edward Parade Hunter's Hill	Sydney	NSW	2042	Australia	(02) 555-5914	(02) 555-4873	G'day Mate (on the World Wide Web)#http://www.microsoft.com/accessdev/sampleapps/gdaymate.htm#
25	Ma Maison	Jean-Guy Lauzon	Marketing Manager	2960 Rue St. Laurent	Montréal	Québec	H1J 1C3	Canada	(514) 555-9022	\N	\N
26	Pasta Buttini s.r.l.	Giovanni Giudici	Order Administrator	Via dei Gelsomini, 153	Salerno	\N	84100	Italy	(089) 6547665	(089) 6547667	\N
27	Escargots Nouveaux	Marie Delamare	Sales Manager	22, rue H. Voiron	Montceau	\N	71300	France	85.57.00.07	\N	\N
28	Gai pâturage	Eliane Noz	Sales Representative	Bat. B 3, rue des Alpes	Annecy	\N	74000	France	38.76.98.06	38.76.98.58	\N
29	Forêts d'érables	Chantal Goulet	Accounting Manager	148 rue Chasseur	Ste-Hyacinthe	Québec	J2S 7S8	Canada	(514) 555-2955	(514) 555-2921	\N
30	JABEX	Lepek	MR	Bestwinska	Bielsko	slask	33-400	Poland	7777777	999999	www.andrzej.pl
31	JABEX	Lepek	MR	Bestwinska	Bielsko	slask	33-400	Poland	7777777	999999	www.andrzej.pl
\.


--
-- TOC entry 4914 (class 0 OID 28006)
-- Dependencies: 238
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, user_id, user_name, password) FROM stdin;
1	KJ	Kupa Jadu	scrypt:32768:8:1$cBEsnu4tmY5C818O$1227174807617aa687067aff569db388ce629e6ff579297012ffbe45fc9863e63b95076a6a2a218ce1ea4f55c782d5d88e1aca33a349e14e1011e4ecff26f3d8
2	KS	Kolo Srolo	scrypt:32768:8:1$q1zJGwpULK3nxUtA$723830d99491cfa94d86b082656d3d675c8f0ccf2f998240ec23b6e7f3eaae8609f1864754aee91d56b1e4cd33ad8bf0e43281187b79127ad86e7d327b36e977
3	AA	Anonimowy Alkoholik	scrypt:32768:8:1$gWnbhmGYwOX7BITp$7d02725325d37b1e490c7cb84842f9c0a86e9e6863e5aeb1795b9acbfb6c9d9a59168e47cbd9743a1e3b2e16143e057f26018ce407936568af8ba163d47490d3
\.


--
-- TOC entry 4931 (class 0 OID 0)
-- Dependencies: 231
-- Name: deliver_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.deliver_details_id_seq', 11, true);


--
-- TOC entry 4932 (class 0 OID 0)
-- Dependencies: 226
-- Name: order_picking_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_picking_details_id_seq', 46, true);


--
-- TOC entry 4933 (class 0 OID 0)
-- Dependencies: 223
-- Name: orders_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_details_id_seq', 287, true);


--
-- TOC entry 4934 (class 0 OID 0)
-- Dependencies: 224
-- Name: picks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.picks_id_seq', 17, true);


--
-- TOC entry 4935 (class 0 OID 0)
-- Dependencies: 233
-- Name: product_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_details_id_seq', 2654, true);


--
-- TOC entry 4936 (class 0 OID 0)
-- Dependencies: 235
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_id_seq', 2703, true);


--
-- TOC entry 4937 (class 0 OID 0)
-- Dependencies: 229
-- Name: relocation_session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.relocation_session_id_seq', 3, true);


--
-- TOC entry 4938 (class 0 OID 0)
-- Dependencies: 234
-- Name: reservation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reservation_id_seq', 2645, true);


--
-- TOC entry 4939 (class 0 OID 0)
-- Dependencies: 240
-- Name: suppliers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.suppliers_id_seq', 30, false);


--
-- TOC entry 4940 (class 0 OID 0)
-- Dependencies: 239
-- Name: suppliers_supplier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.suppliers_supplier_id_seq', 31, true);


--
-- TOC entry 4941 (class 0 OID 0)
-- Dependencies: 237
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 3, true);


--
-- TOC entry 4737 (class 2606 OID 25440)
-- Name: deliver_details deliver_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliver_details
    ADD CONSTRAINT deliver_details_pkey PRIMARY KEY (id);


--
-- TOC entry 4735 (class 2606 OID 25443)
-- Name: delivery_order delivery_order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_order
    ADD CONSTRAINT delivery_order_pkey PRIMARY KEY (deliver_id);


--
-- TOC entry 4731 (class 2606 OID 25330)
-- Name: order_picking_details order_picking_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_picking_details
    ADD CONSTRAINT order_picking_details_pkey PRIMARY KEY (id);


--
-- TOC entry 4725 (class 2606 OID 25301)
-- Name: orders_details orders_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_details
    ADD CONSTRAINT orders_details_pkey PRIMARY KEY (id);


--
-- TOC entry 4723 (class 2606 OID 25231)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- TOC entry 4729 (class 2606 OID 25310)
-- Name: picks picks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.picks
    ADD CONSTRAINT picks_pkey PRIMARY KEY (id);


--
-- TOC entry 4715 (class 2606 OID 25217)
-- Name: customers pk_customers; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT pk_customers PRIMARY KEY (customer_id);


--
-- TOC entry 4717 (class 2606 OID 25183)
-- Name: suppliers pk_suppliers; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT pk_suppliers PRIMARY KEY (supplier_id);


--
-- TOC entry 4721 (class 2606 OID 27980)
-- Name: product_details product_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_details
    ADD CONSTRAINT product_details_pkey PRIMARY KEY (id);


--
-- TOC entry 4739 (class 2606 OID 27998)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- TOC entry 4733 (class 2606 OID 25347)
-- Name: relocation relocation_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relocation
    ADD CONSTRAINT relocation_session_pkey PRIMARY KEY (id);


--
-- TOC entry 4727 (class 2606 OID 27989)
-- Name: reservation reservation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_pkey PRIMARY KEY (id);


--
-- TOC entry 4742 (class 2606 OID 28011)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4744 (class 2606 OID 28013)
-- Name: users users_user_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_user_name_key UNIQUE (user_name);


--
-- TOC entry 4719 (class 2606 OID 25199)
-- Name: location_weights weights_amounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_weights
    ADD CONSTRAINT weights_amounts_pkey PRIMARY KEY (location);


--
-- TOC entry 4740 (class 1259 OID 28014)
-- Name: ix_users_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_users_user_id ON public.users USING btree (user_id);


--
-- TOC entry 4747 (class 2606 OID 25444)
-- Name: deliver_details deliver_details_deliver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliver_details
    ADD CONSTRAINT deliver_details_deliver_id_fkey FOREIGN KEY (deliver_id) REFERENCES public.delivery_order(deliver_id) NOT VALID;


--
-- TOC entry 4745 (class 2606 OID 25225)
-- Name: orders orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- TOC entry 4746 (class 2606 OID 25235)
-- Name: orders_details orders_details_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_details
    ADD CONSTRAINT orders_details_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


-- Completed on 2026-01-04 18:40:32

--
-- PostgreSQL database dump complete
--


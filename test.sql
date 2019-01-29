--
-- PostgreSQL database dump
--

-- Dumped from database version 11.1
-- Dumped by pg_dump version 11.1

-- Started on 2019-01-28 04:59:22

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--user
CREATE USER test_user WITH
  LOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;
ALTER USER test_user WITH ENCRYPTED PASSWORD 'test_user';

--
-- TOC entry 203 (class 1255 OID 24801)
-- Name: organization_delete(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.organization_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM address WHERE address.id = OLD.address_id;
    RETURN OLD;
END $$;


ALTER FUNCTION public.organization_delete() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 200 (class 1259 OID 24764)
-- Name: address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.address (
    id integer NOT NULL,
    street character varying(100)
);


ALTER TABLE public.address OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 24767)
-- Name: address_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.address_id_seq OWNER TO postgres;

--
-- TOC entry 2852 (class 0 OID 0)
-- Dependencies: 201
-- Name: address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.address_id_seq OWNED BY public.address.id;


--
-- TOC entry 198 (class 1259 OID 24755)
-- Name: organization; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization (
    id integer NOT NULL,
    name character varying(100),
    address_id integer
);


ALTER TABLE public.organization OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 24758)
-- Name: organization_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.organization_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.organization_id_seq OWNER TO postgres;

--
-- TOC entry 2855 (class 0 OID 0)
-- Dependencies: 199
-- Name: organization_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.organization_id_seq OWNED BY public.organization.id;


--
-- TOC entry 202 (class 1259 OID 24773)
-- Name: organization_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization_users (
    organization_id integer,
    users_id integer,
    date_register timestamp without time zone DEFAULT now()
);


ALTER TABLE public.organization_users OWNER TO postgres;

--
-- TOC entry 196 (class 1259 OID 24741)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    login character varying(20) NOT NULL,
    pass character varying(20),
    name character varying(100),
    address_id integer
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 197 (class 1259 OID 24744)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 2859 (class 0 OID 0)
-- Dependencies: 197
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 2704 (class 2604 OID 24769)
-- Name: address id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.address ALTER COLUMN id SET DEFAULT nextval('public.address_id_seq'::regclass);


--
-- TOC entry 2703 (class 2604 OID 24760)
-- Name: organization id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization ALTER COLUMN id SET DEFAULT nextval('public.organization_id_seq'::regclass);


--
-- TOC entry 2702 (class 2604 OID 24746)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 2843 (class 0 OID 24764)
-- Dependencies: 200
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.address (id, street) FROM stdin;
1	Street 1, New York, 77000
2	dwedfewfdew
3	dwedfewfdew
4	aaaa
5	aaaa 11
6	Street 2, New York 88800
7	Street 2, NY, 88880
8	Street 3, NY, 33333
9	co4 adr
10	co44
13	202020
14	a 21 21 21
15	us1 adr
16	Co5 address
\.


--
-- TOC entry 2841 (class 0 OID 24755)
-- Dependencies: 198
-- Data for Name: organization; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization (id, name, address_id) FROM stdin;
1	Co1	6
14	Co2	7
15	Co3	8
17	co4	10
20	Co5	16
\.


--
-- TOC entry 2845 (class 0 OID 24773)
-- Dependencies: 202
-- Data for Name: organization_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization_users (organization_id, users_id, date_register) FROM stdin;
1	1	2019-01-28 01:01:46.037134
1	2	2019-01-28 01:01:46.037134
1	3	2019-01-28 01:01:46.037134
14	4	2019-01-28 04:56:25.030373
14	5	2019-01-28 04:56:25.030373
20	7	2019-01-28 04:57:22.215407
20	8	2019-01-28 04:57:22.215407
20	47	2019-01-28 04:57:22.215407
\.


--
-- TOC entry 2839 (class 0 OID 24741)
-- Dependencies: 196
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, login, pass, name, address_id) FROM stdin;
2	user2	\N	\N	\N
3	user3	\N	\N	\N
4	user6	6	\N	\N
5	user7	7	\N	\N
6	user8	8	\N	\N
7	user9	9	\N	\N
8	user10	10	\N	\N
1	user1	\N	User One	1
47	u11	\N	User 11	5
\.


--
-- TOC entry 2861 (class 0 OID 0)
-- Dependencies: 201
-- Name: address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.address_id_seq', 16, true);


--
-- TOC entry 2862 (class 0 OID 0)
-- Dependencies: 199
-- Name: organization_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.organization_id_seq', 20, true);


--
-- TOC entry 2863 (class 0 OID 0)
-- Dependencies: 197
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 50, true);


--
-- TOC entry 2713 (class 2606 OID 24778)
-- Name: address address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (id);


--
-- TOC entry 2711 (class 2606 OID 24780)
-- Name: organization organization_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization
    ADD CONSTRAINT organization_pkey PRIMARY KEY (id);


--
-- TOC entry 2707 (class 2606 OID 24754)
-- Name: users users_login_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key UNIQUE (login);


--
-- TOC entry 2709 (class 2606 OID 24748)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 2717 (class 2620 OID 24802)
-- Name: organization organization_delete; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER organization_delete BEFORE DELETE ON public.organization FOR EACH ROW EXECUTE PROCEDURE public.organization_delete();


--
-- TOC entry 2716 (class 2606 OID 24808)
-- Name: organization_users organization_users_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_users
    ADD CONSTRAINT organization_users_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organization(id) ON DELETE CASCADE;


--
-- TOC entry 2715 (class 2606 OID 24803)
-- Name: organization_users organization_users_users_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_users
    ADD CONSTRAINT organization_users_users_id_fkey FOREIGN KEY (users_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 2714 (class 2606 OID 24796)
-- Name: users users_address_id_pkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_address_id_pkey FOREIGN KEY (address_id) REFERENCES public.address(id);


--
-- TOC entry 2851 (class 0 OID 0)
-- Dependencies: 200
-- Name: TABLE address; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.address TO test_user;


--
-- TOC entry 2853 (class 0 OID 0)
-- Dependencies: 201
-- Name: SEQUENCE address_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.address_id_seq TO test_user;


--
-- TOC entry 2854 (class 0 OID 0)
-- Dependencies: 198
-- Name: TABLE organization; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.organization TO test_user;


--
-- TOC entry 2856 (class 0 OID 0)
-- Dependencies: 199
-- Name: SEQUENCE organization_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.organization_id_seq TO test_user;


--
-- TOC entry 2857 (class 0 OID 0)
-- Dependencies: 202
-- Name: TABLE organization_users; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.organization_users TO test_user;


--
-- TOC entry 2858 (class 0 OID 0)
-- Dependencies: 196
-- Name: TABLE users; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.users TO test_user;


--
-- TOC entry 2860 (class 0 OID 0)
-- Dependencies: 197
-- Name: SEQUENCE users_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.users_id_seq TO test_user;


-- Completed on 2019-01-28 04:59:28

--
-- PostgreSQL database dump complete
--


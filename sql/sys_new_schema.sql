--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: stories_answer; Type: TABLE; Schema: public; Owner: klp; Tablespace: 
--

CREATE TABLE stories_answer (
    id integer NOT NULL,
    story_id integer NOT NULL,
    question_id integer NOT NULL,
    text text NOT NULL
);


ALTER TABLE public.stories_answer OWNER TO klp;

--
-- Name: stories_answer_id_seq; Type: SEQUENCE; Schema: public; Owner: klp
--

CREATE SEQUENCE stories_answer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stories_answer_id_seq OWNER TO klp;

--
-- Name: stories_answer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: klp
--

ALTER SEQUENCE stories_answer_id_seq OWNED BY stories_answer.id;


--
-- Name: stories_question; Type: TABLE; Schema: public; Owner: klp; Tablespace: 
--

CREATE TABLE stories_question (
    id integer NOT NULL,
    text text NOT NULL,
    data_type integer NOT NULL,
    question_type_id integer NOT NULL,
    options text,
    is_active boolean NOT NULL,
    school_type integer,
    qid integer
);


ALTER TABLE public.stories_question OWNER TO klp;

--
-- Name: stories_question_id_seq; Type: SEQUENCE; Schema: public; Owner: klp
--

CREATE SEQUENCE stories_question_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stories_question_id_seq OWNER TO klp;

--
-- Name: stories_question_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: klp
--

ALTER SEQUENCE stories_question_id_seq OWNED BY stories_question.id;


--
-- Name: stories_questiongroup; Type: TABLE; Schema: public; Owner: klp; Tablespace: 
--

CREATE TABLE stories_questiongroup (
    id integer NOT NULL,
    version integer NOT NULL,
    source_id integer NOT NULL
);


ALTER TABLE public.stories_questiongroup OWNER TO klp;

--
-- Name: stories_questiongroup_id_seq; Type: SEQUENCE; Schema: public; Owner: klp
--

CREATE SEQUENCE stories_questiongroup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stories_questiongroup_id_seq OWNER TO klp;

--
-- Name: stories_questiongroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: klp
--

ALTER SEQUENCE stories_questiongroup_id_seq OWNED BY stories_questiongroup.id;


--
-- Name: stories_questiongroup_questions; Type: TABLE; Schema: public; Owner: klp; Tablespace: 
--

CREATE TABLE stories_questiongroup_questions (
    id integer NOT NULL,
    questiongroup_id integer NOT NULL,
    question_id integer NOT NULL,
    sequence integer
);


ALTER TABLE public.stories_questiongroup_questions OWNER TO klp;

--
-- Name: stories_questiongroup_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: klp
--

CREATE SEQUENCE stories_questiongroup_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stories_questiongroup_questions_id_seq OWNER TO klp;

--
-- Name: stories_questiongroup_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: klp
--

ALTER SEQUENCE stories_questiongroup_questions_id_seq OWNED BY stories_questiongroup_questions.id;


--
-- Name: stories_questiontype; Type: TABLE; Schema: public; Owner: klp; Tablespace: 
--

CREATE TABLE stories_questiontype (
    id integer NOT NULL,
    name character varying(64) NOT NULL
);


ALTER TABLE public.stories_questiontype OWNER TO klp;

--
-- Name: stories_questiontype_id_seq; Type: SEQUENCE; Schema: public; Owner: klp
--

CREATE SEQUENCE stories_questiontype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stories_questiontype_id_seq OWNER TO klp;

--
-- Name: stories_questiontype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: klp
--

ALTER SEQUENCE stories_questiontype_id_seq OWNED BY stories_questiontype.id;


--
-- Name: stories_source; Type: TABLE; Schema: public; Owner: klp; Tablespace: 
--

CREATE TABLE stories_source (
    id integer NOT NULL,
    name character varying(64) NOT NULL
);


ALTER TABLE public.stories_source OWNER TO klp;

--
-- Name: stories_source_id_seq; Type: SEQUENCE; Schema: public; Owner: klp
--

CREATE SEQUENCE stories_source_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stories_source_id_seq OWNER TO klp;

--
-- Name: stories_source_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: klp
--

ALTER SEQUENCE stories_source_id_seq OWNED BY stories_source.id;


--
-- Name: stories_story; Type: TABLE; Schema: public; Owner: klp; Tablespace: 
--

CREATE TABLE stories_story (
    id integer NOT NULL,
    user_id integer,
    school_id integer NOT NULL,
    group_id integer NOT NULL,
    is_verified boolean NOT NULL,
    name character varying(100),
    email character varying(100),
    date character varying(50),
    telephone character varying(50),
    entered_timestamp timestamp with time zone,
    comments character varying(2000),
    sysid integer
);


ALTER TABLE public.stories_story OWNER TO klp;

--
-- Name: stories_story_id_seq; Type: SEQUENCE; Schema: public; Owner: klp
--

CREATE SEQUENCE stories_story_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stories_story_id_seq OWNER TO klp;

--
-- Name: stories_story_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: klp
--

ALTER SEQUENCE stories_story_id_seq OWNED BY stories_story.id;


--
-- Name: stories_storyimage; Type: TABLE; Schema: public; Owner: klp; Tablespace: 
--

CREATE TABLE stories_storyimage (
    id integer NOT NULL,
    story_id integer NOT NULL,
    image character varying(100) NOT NULL,
    is_verified boolean NOT NULL,
    filename character varying(50)
);


ALTER TABLE public.stories_storyimage OWNER TO klp;

--
-- Name: stories_storyimage_id_seq; Type: SEQUENCE; Schema: public; Owner: klp
--

CREATE SEQUENCE stories_storyimage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stories_storyimage_id_seq OWNER TO klp;

--
-- Name: stories_storyimage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: klp
--

ALTER SEQUENCE stories_storyimage_id_seq OWNED BY stories_storyimage.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: klp
--

ALTER TABLE ONLY stories_answer ALTER COLUMN id SET DEFAULT nextval('stories_answer_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: klp
--

ALTER TABLE ONLY stories_question ALTER COLUMN id SET DEFAULT nextval('stories_question_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: klp
--

ALTER TABLE ONLY stories_questiongroup ALTER COLUMN id SET DEFAULT nextval('stories_questiongroup_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: klp
--

ALTER TABLE ONLY stories_questiongroup_questions ALTER COLUMN id SET DEFAULT nextval('stories_questiongroup_questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: klp
--

ALTER TABLE ONLY stories_questiontype ALTER COLUMN id SET DEFAULT nextval('stories_questiontype_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: klp
--

ALTER TABLE ONLY stories_source ALTER COLUMN id SET DEFAULT nextval('stories_source_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: klp
--

ALTER TABLE ONLY stories_story ALTER COLUMN id SET DEFAULT nextval('stories_story_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: klp
--

ALTER TABLE ONLY stories_storyimage ALTER COLUMN id SET DEFAULT nextval('stories_storyimage_id_seq'::regclass);


--
-- Data for Name: stories_answer; Type: TABLE DATA; Schema: public; Owner: klp
--

COPY stories_answer (id, story_id, question_id, text) FROM stdin;
1	2905	58	Yes
2	2905	57	No
3	2905	59	Akshaya Patra
4	2905	46	5
5	2905	50	1
6	2905	49	3
7	2905	52	Yes
8	2905	51	Yes
9	2905	54	Yes
10	2905	53	No
11	2905	56	Yes
12	2905	55	Yes
13	10	58	Yes
14	10	57	Yes
15	10	59	Other
16	10	46	13
17	10	50	4
18	10	49	8
19	10	52	Yes
20	10	51	Yes
21	10	54	Yes
22	10	53	Yes
23	10	56	Yes
24	10	55	Yes
25	1	58	Yes
26	1	57	Yes
27	1	59	Other
28	1	46	4
29	1	50	2
30	1	49	5
31	1	52	Yes
32	1	51	Yes
33	1	54	Yes
34	1	53	Yes
35	1	56	No
36	1	55	No
37	2	58	Yes
38	2	57	Yes
39	2	59	Akshaya Patra
40	2	46	5
41	2	52	No
42	2	51	No
43	2	54	Yes
44	2	53	No
45	2	56	No
46	2	55	No
47	21	58	Yes
48	21	57	Yes
49	21	59	Other
50	21	46	12
51	21	50	3
52	21	49	14
53	21	52	No
54	21	51	No
55	21	54	Yes
56	21	53	Yes
57	21	56	Yes
58	21	55	Yes
59	14	58	Yes
60	14	57	Yes
61	14	59	Other
62	14	46	40
63	14	50	6
64	14	49	15
65	14	52	Yes
66	14	51	Yes
67	14	54	Yes
68	14	53	Yes
69	14	56	Yes
70	14	55	Yes
71	23	58	Yes
72	23	57	Yes
73	23	59	Other
74	23	46	12
75	23	50	1
76	23	49	10
77	23	52	No
78	23	54	Yes
79	23	53	Yes
80	23	56	Yes
81	23	55	Yes
82	7	58	Yes
83	7	57	No
84	7	59	Other
85	7	46	6
86	7	50	3
87	7	49	4
88	7	52	No
89	7	51	No
90	7	54	Yes
91	7	53	Yes
92	7	56	No
93	7	55	No
94	8	58	Yes
95	8	57	Yes
96	8	59	Other
97	8	46	4
98	8	50	2
99	8	49	2
100	8	52	No
101	8	54	Yes
102	8	53	Yes
103	8	56	No
104	8	55	No
105	2913	58	Yes
106	2913	57	No
107	2913	59	Other
108	2913	46	3
109	2913	50	2
110	2913	49	2
111	2913	52	No
112	2913	51	No
113	2913	54	Yes
114	2913	53	Yes
115	2913	56	No
116	2913	55	No
117	16	58	Yes
118	16	57	No
119	16	59	Akshaya Patra
120	16	46	4
121	16	50	1
122	16	49	3
123	16	52	Yes
124	16	51	No
125	16	54	Yes
126	16	53	Yes
127	16	56	Yes
128	16	55	Yes
129	17	58	No
130	17	57	Yes
131	17	59	Other
132	17	46	3
133	17	50	1
134	17	49	4
135	17	52	Yes
136	17	51	No
137	17	54	No
138	17	53	Yes
139	17	56	No
140	17	55	Yes
141	18	58	Yes
142	18	57	No
143	18	59	Other
144	18	46	3
145	18	50	1
146	18	49	3
147	18	52	No
148	18	51	No
149	18	54	Yes
150	18	53	No
151	18	56	No
152	18	55	Yes
153	41	58	Yes
154	41	57	Yes
155	41	59	Other
156	41	46	15
157	41	50	4
158	41	49	18
159	41	52	Yes
160	41	51	Yes
161	41	54	Yes
162	41	53	Yes
163	41	56	Yes
164	41	55	Yes
165	49	58	Yes
166	49	57	No
167	49	59	Akshaya Patra
168	49	46	2
169	49	50	2
170	49	49	2
171	49	52	No
172	49	51	No
173	49	54	Yes
174	49	53	Yes
175	49	56	No
176	49	55	Yes
177	2927	58	Yes
178	2927	57	No
179	2927	59	Akshaya Patra
180	2927	46	10
181	2927	50	1
182	2927	49	10
183	2927	52	No
184	2927	51	No
185	2927	54	Yes
186	2927	53	Yes
187	2927	56	Yes
188	2927	55	Yes
189	48	58	Yes
190	48	57	Yes
191	48	59	Other
192	48	46	10
193	48	50	3
194	48	49	7
195	48	52	Yes
196	48	51	Yes
197	48	54	Yes
198	48	53	Yes
199	48	56	Yes
200	48	55	Yes
201	50	58	Yes
202	50	57	No
203	50	59	Other
204	50	46	1
205	50	50	0
206	50	49	1
207	50	52	No
208	50	51	No
209	50	54	No
210	50	53	No
211	50	56	No
212	50	55	No
213	34	58	Yes
214	34	57	Yes
215	34	59	Other
216	34	46	10
217	34	50	3
218	34	49	9
219	34	52	No
220	34	51	No
221	34	54	No
222	34	53	No
223	34	56	Yes
224	34	55	Yes
225	36	58	Yes
226	36	57	Yes
227	36	59	Akshaya Patra
228	36	46	10
229	36	50	2
230	36	49	9
231	36	52	Yes
232	36	51	Yes
233	36	54	Yes
234	36	53	No
235	36	56	Yes
236	36	55	Yes
237	35	58	Yes
238	35	57	No
239	35	59	Other
240	35	46	12
241	35	50	3
242	35	49	8
243	35	52	Yes
244	35	51	Yes
245	35	54	Yes
246	35	53	Yes
247	35	56	Yes
248	35	55	Yes
249	29	58	Yes
250	29	57	No
251	29	59	Other
252	29	46	3
253	29	50	2
254	29	49	3
255	29	52	No
256	29	51	Yes
257	29	54	Yes
258	29	53	Yes
259	29	56	Yes
260	29	55	Yes
261	2930	58	Yes
262	2930	57	No
263	2930	59	Other
264	2930	46	2
265	2930	50	1
266	2930	49	2
267	2930	52	No
268	2930	51	Yes
269	2930	54	Yes
270	2930	53	No
271	2930	56	Yes
272	2930	55	Yes
273	43	58	Yes
274	43	57	Yes
275	43	59	Other
276	43	46	2
277	43	50	0
278	43	49	2
279	43	52	No
280	43	51	No
281	43	54	Yes
282	43	53	No
283	43	56	Yes
284	43	55	Yes
285	44	58	Yes
286	44	57	No
287	44	59	Other
288	44	46	5
289	44	50	3
290	44	49	4
291	44	52	Yes
292	44	51	Yes
293	44	54	Yes
294	44	53	Yes
295	44	56	Yes
296	44	55	Yes
297	42	58	Yes
298	42	57	No
299	42	59	Other
300	42	46	2
301	42	50	2
302	42	49	2
303	42	52	No
304	42	51	Yes
305	42	54	Yes
306	42	53	Yes
307	42	56	Yes
308	42	55	Yes
309	46	58	Yes
310	46	57	No
311	46	59	Other
312	46	46	4
313	46	50	3
314	46	49	2
315	46	52	Yes
316	46	51	Yes
317	46	54	Yes
318	46	53	Yes
319	46	56	Yes
320	46	55	Yes
321	38	58	Yes
322	38	57	Yes
323	38	59	Other
324	38	46	1
325	38	50	3
326	38	49	1
327	38	52	Yes
328	38	51	Yes
329	38	54	Yes
330	38	53	Yes
331	38	56	Yes
332	38	55	Yes
333	40	57	No
334	40	59	Other
335	40	46	1
336	40	50	3
337	40	49	1
338	40	52	Yes
339	40	51	Yes
340	40	54	Yes
341	40	53	Yes
342	40	56	Yes
343	40	55	Yes
344	39	58	Yes
345	39	57	No
346	39	59	Other
347	39	46	2
348	39	50	3
349	39	49	2
350	39	52	Yes
351	39	51	Yes
352	39	54	Yes
353	39	53	Yes
354	39	56	Yes
355	39	55	Yes
356	37	58	Yes
357	37	57	Yes
358	37	59	Akshaya Patra
359	37	46	10
360	37	50	2
361	37	49	9
362	37	52	Yes
363	37	51	Yes
364	37	54	Yes
365	37	53	Yes
366	37	56	Yes
367	37	55	Yes
368	30	58	Yes
369	30	57	No
370	30	59	Other
371	30	46	4
372	30	50	3
373	30	49	5
374	30	52	Yes
375	30	51	Yes
376	30	54	Yes
377	30	53	Yes
378	30	56	Yes
379	30	55	Yes
380	45	58	Yes
381	45	57	Yes
382	45	59	Other
383	45	46	6
384	45	50	5
385	45	49	5
386	45	52	Yes
387	45	51	Yes
388	45	54	Yes
389	45	53	Yes
390	45	56	Yes
391	45	55	Yes
392	2914	58	Yes
393	2914	57	No
394	2914	59	Other
395	2914	46	3
396	2914	50	2
397	2914	49	2
398	2914	52	Yes
399	2914	51	Yes
400	2914	54	No
401	2914	53	No
402	2914	56	Yes
403	2914	55	Yes
404	2915	58	Yes
405	2915	57	Yes
406	2915	59	Other
407	2915	46	4
408	2915	50	4
409	2915	49	5
410	2915	52	Yes
411	2915	51	Yes
412	2915	54	Yes
413	2915	53	Yes
414	2915	56	Yes
415	2915	55	Yes
416	6	58	Yes
417	6	57	Yes
418	6	59	Other
419	6	46	2
420	6	50	1
421	6	49	2
422	6	52	No
423	6	51	No
424	6	54	No
425	6	53	No
426	6	56	No
427	6	55	Yes
428	2932	58	Yes
429	2932	57	Yes
430	2932	59	Akshaya Patra
431	2932	46	4
432	2932	50	3
433	2932	49	4
434	2932	52	Yes
435	2932	51	Yes
436	2932	54	Yes
437	2932	53	Yes
438	2932	56	No
439	2932	55	Yes
440	65	58	Yes
441	65	57	No
442	65	59	Akshaya Patra
443	65	46	3
444	65	50	2
445	65	49	5
446	65	52	Yes
447	65	51	Yes
448	65	54	Yes
449	65	53	No
450	65	56	No
451	65	55	Yes
452	66	58	Yes
453	66	57	No
454	66	59	Akshaya Patra
455	66	46	24
456	66	50	7
457	66	49	30
458	66	52	Yes
459	66	51	Yes
460	66	54	Yes
461	66	53	Yes
462	66	56	No
463	66	55	Yes
464	67	58	Yes
465	67	57	Yes
466	67	59	Akshaya Patra
467	67	46	6
468	67	50	3
469	67	49	3
470	67	52	Yes
471	67	51	Yes
472	67	54	Yes
473	67	53	Yes
474	67	56	Yes
475	67	55	Yes
476	2906	58	Yes
477	2906	57	No
478	2906	59	Other
479	2906	46	2
480	2906	50	1
481	2906	49	2
482	2906	52	No
483	2906	51	No
484	2906	54	Yes
485	2906	53	Yes
486	2906	56	Yes
487	2906	55	Yes
488	2933	58	Yes
489	2933	57	Yes
490	2933	59	Akshaya Patra
491	2933	46	15
492	2933	50	3
493	2933	49	3
494	2933	52	Yes
495	2933	51	Yes
496	2933	54	Yes
497	2933	53	Yes
498	2933	56	No
499	2933	55	Yes
500	61	58	Yes
501	61	57	Yes
502	61	59	Other
503	61	46	14
504	61	50	6
505	61	49	11
506	61	52	Yes
507	61	51	Yes
508	61	54	Yes
509	61	53	Yes
510	61	56	Yes
511	61	55	Yes
512	2907	58	Yes
513	2907	57	Yes
514	2907	59	Other
515	2907	46	16
516	2907	50	04
517	2907	49	17
518	2907	52	Yes
519	2907	51	Yes
520	2907	54	Yes
521	2907	53	No
522	2907	56	Yes
523	2907	55	Yes
524	47	58	Yes
525	47	57	Available and functional
526	47	59	2
527	47	62	1
528	47	46	No
529	47	50	Not available
530	47	54	Not available
531	47	53	Available and functional
532	2924	58	Yes
533	2924	59	3
534	2924	62	2
535	2924	50	Not available
536	2924	54	Available and functional
537	2924	53	Available and functional
538	2924	56	Available and functional
539	89	58	Yes
540	89	59	1
541	89	62	2
542	89	50	Not available
543	89	54	Not available
544	89	53	Available and functional
545	89	56	Available and functional
546	89	55	Not available
547	87	58	Yes
548	87	59	2
549	87	62	2
550	87	50	Available and functional
551	87	54	Available and functional
552	87	53	Available and functional
553	87	56	Available and functional
554	90	59	1
555	90	62	2
556	90	50	Not available
557	90	54	Available and functional
558	90	53	Available and functional
559	90	56	Available and functional
560	90	55	Available and functional
561	2950	59	2
562	2950	62	2
563	2950	50	Available and functional
564	2950	54	Available and functional
565	2950	53	Available and functional
566	2950	56	Available and functional
567	2950	55	Not available
568	81	59	8
569	81	62	5
570	81	50	Not available
571	81	54	Available and functional
572	81	53	Available and functional
573	81	56	Available and functional
574	81	55	Available and functional
575	82	59	3
576	82	62	3
577	82	50	Not available
578	82	54	Available and functional
579	82	53	Available and functional
580	82	56	Available and functional
581	82	55	Available and functional
582	83	59	2
583	83	62	2
584	83	50	Not available
585	83	54	Available and functional
586	83	53	Available and functional
587	83	56	Available and functional
588	83	55	Available and functional
589	84	59	2
590	84	62	2
591	84	50	Not available
592	84	54	Available and functional
593	84	53	Available and functional
594	84	56	Available and functional
595	84	55	Available and functional
596	31	59	4
597	31	62	6
598	31	50	Available and functional
599	31	54	Available and functional
600	31	53	Available and functional
601	31	56	Available and functional
602	31	55	Available and functional
603	32	59	2
604	32	62	2
605	32	50	Available and functional
606	32	54	Available and functional
607	32	53	Available and functional
608	32	56	Available and functional
609	32	55	Available and functional
610	78	59	2
611	78	62	2
612	78	50	Available and functional
613	78	54	Available and functional
614	78	53	Available and functional
615	78	56	Available and functional
616	78	55	Available and functional
617	62	59	8
618	62	62	8
619	62	50	Not available
620	62	54	Available and functional
621	62	53	Available and functional
622	62	56	Available and functional
623	62	55	Available and functional
624	77	59	8
625	77	62	8
626	77	50	Not available
627	77	54	Available and functional
628	77	53	Available and functional
629	77	56	Available and functional
630	77	55	Available and functional
631	76	59	5
632	76	62	5
633	76	50	Not available
634	76	54	Not available
635	76	53	Available and functional
636	76	56	Available and functional
637	76	55	Available and functional
638	75	59	5
639	75	62	5
640	75	50	Not available
641	75	54	Available and functional
642	75	53	Available and functional
643	75	56	Available and functional
644	75	55	Available and functional
645	2951	59	2
646	2951	62	2
647	2951	50	Not available
648	2951	54	Not available
649	2951	53	Available and functional
650	2951	55	Available and functional
651	73	59	2
652	73	62	2
653	73	50	Available and functional
654	73	54	Available and functional
655	73	53	Available and functional
656	73	56	Available and functional
657	73	55	Available and functional
658	2916	59	2
659	2916	62	2
660	2916	50	Available and functional
661	2916	54	Available and functional
662	2916	53	Available and functional
663	2916	56	Available and functional
664	2916	55	Available and functional
665	2952	59	2
666	2952	62	3
667	2952	50	Not available
668	2952	54	Available and functional
669	2952	53	Available and functional
670	2952	56	Available and functional
671	2953	59	5
672	2953	62	4
673	2953	50	Available and functional
674	2953	54	Available and functional
675	2953	53	Available and functional
676	2953	56	Available and functional
677	2954	59	3
678	2954	62	2
679	2954	50	Available and functional
680	2954	54	Available and functional
681	2954	53	Available and functional
682	2954	56	Available and functional
683	2954	55	Available and functional
684	2955	56	Available and functional
685	2955	55	Available and functional
686	2955	50	Available and functional
687	2955	54	Available and functional
688	2955	53	Available and functional
689	71	59	8
690	71	62	8
691	71	50	Available and functional
692	71	53	Available and functional
693	71	56	Available and functional
694	71	55	Available and functional
695	91	59	2
696	91	62	1
697	91	50	Available and functional
698	91	53	Available and functional
699	91	56	Available and functional
700	91	55	Available and functional
701	70	59	1
702	70	62	1
703	70	50	Not available
704	70	54	Available and functional
705	70	53	Available and functional
706	70	56	Available and functional
707	70	55	Available and functional
708	2959	59	2
709	2959	62	2
710	2959	50	Not available
711	2959	54	Available and functional
712	2959	53	Available and functional
713	2959	56	Available and functional
714	2959	55	Available and functional
715	2960	59	2
716	2960	62	2
717	2960	50	Not available
718	2960	54	Available and functional
719	2960	53	Available and functional
720	2960	56	Available and functional
721	2960	55	Available and functional
722	2961	59	2
723	2961	62	2
724	2961	50	Not available
725	2961	54	Available and functional
726	2961	53	Available and functional
727	2961	56	Available and functional
728	2961	55	Available and functional
729	2956	59	2
730	2956	62	2
731	2956	50	Available and functional
732	2956	53	Available and functional
733	2956	56	Available and functional
734	2956	55	Available and functional
735	2957	59	2
736	2957	62	2
737	2957	50	Available and functional
738	2957	54	Available and functional
739	2957	53	Available and functional
740	2957	56	Available and functional
741	2957	55	Available and functional
742	69	59	5
743	69	62	4
744	69	50	Not available
745	69	54	Available and functional
746	69	53	Available and functional
747	69	56	Available and functional
748	69	55	Available and functional
749	88	59	2
750	88	62	1
751	88	50	Not available
752	88	54	Not available
753	88	53	Available and functional
754	88	56	Available and functional
755	88	55	Available and functional
756	2958	59	2
757	2958	62	2
758	2958	50	Not available
759	2958	54	Available and functional
760	2958	53	Available and functional
761	2958	56	Available and functional
762	2958	55	Available and functional
763	2962	59	1
764	2962	62	1
765	2962	50	Not available
766	2962	54	Available and functional
767	2962	53	Available and functional
768	2962	56	Available and functional
769	2962	55	Available and functional
770	2963	59	2
771	2963	62	2
772	2963	50	Not available
773	2963	54	Available and functional
774	2963	53	Available and functional
775	2963	56	Available and functional
776	2963	55	Available and functional
777	2964	59	1
778	2964	62	1
779	2964	50	Not available
780	2964	53	Available and functional
781	2964	56	Available and functional
782	2964	55	Not available
783	2965	59	2
784	2965	62	2
785	2965	54	Available and functional
786	2965	53	Available and functional
787	2965	56	Available and functional
788	2965	55	Available and functional
789	2966	59	2
790	2966	62	2
791	2966	50	Not available
792	2966	54	Not available
793	2966	53	Available and functional
794	2966	56	Available and functional
795	2966	55	Available and functional
796	2967	59	2
797	2967	62	2
798	2967	50	Not available
799	2967	54	Available and functional
800	2967	53	Available and functional
801	2967	56	Available and functional
802	2967	55	Available and functional
803	2968	59	2
804	2968	62	2
805	2968	50	Not available
806	2968	54	Available and functional
807	2968	53	Available and functional
808	2968	56	Available and functional
809	2968	55	Available and functional
810	80	59	4
811	80	62	3
812	80	50	Not available
813	80	54	Available and functional
814	80	53	Available and functional
815	80	56	Available and functional
816	80	55	Available and functional
817	79	59	2
818	79	62	2
819	79	54	Available and functional
820	79	53	Available and functional
821	79	56	Available and functional
822	79	55	Available and functional
823	2969	59	2
824	2969	62	2
825	2969	50	Not available
826	2969	53	Available and functional
827	2969	56	Available and functional
828	2969	55	Available and functional
829	86	56	Available and functional
830	86	55	Available and functional
831	86	50	Not available
832	86	54	Available and functional
833	86	53	Available and functional
834	2970	56	Available and functional
835	2970	55	Available and functional
836	2970	50	Not available
837	2970	54	Not available
838	2970	53	Available and functional
839	2971	59	2
840	2971	62	2
841	2971	54	Not available
842	2971	53	Available and functional
843	2971	56	Available and functional
844	2971	55	Available and functional
845	2972	59	2
846	2972	62	2
847	2972	50	Not available
848	2972	54	Not available
849	2972	53	Available and functional
850	2972	56	Available and functional
851	2972	55	Available and functional
852	85	59	2
853	85	62	2
854	85	50	Not available
855	85	54	Available and functional
856	85	53	Available and functional
857	85	56	Available and functional
858	85	55	Available and functional
859	2973	59	4
860	2973	62	4
861	2973	50	Not available
862	2973	54	Available and functional
863	2973	53	Available and functional
864	2973	56	Available and functional
865	2973	55	Available and functional
866	2974	59	2
867	2974	62	2
868	2974	50	Not available
869	2974	54	Available and functional
870	2974	53	Available and functional
871	2974	56	Available and functional
872	2974	55	Available and functional
873	2975	59	2
874	2975	62	2
875	2975	50	Available and functional
876	2975	54	Available and functional
877	2975	53	Available and functional
878	2975	56	Available and functional
879	2975	55	Available and functional
880	72	59	3
881	72	62	3
882	72	50	Available and functional
883	72	54	Available and functional
884	72	53	Available and functional
885	72	56	Available and functional
886	72	55	Not available
887	2976	59	2
888	2976	62	2
889	2976	50	Not available
890	2976	54	Not available
891	2976	53	Available and functional
892	2976	56	Available and functional
893	2976	55	Not available
894	2977	59	7
895	2977	62	3
896	2977	50	Not available
897	2977	54	Available and functional
898	2977	53	Available and functional
899	2977	56	Available and functional
900	2977	55	Available and functional
901	2978	59	2
902	2978	62	1
903	2978	50	Not available
904	2978	54	Not available
905	2978	53	Available and functional
906	2978	56	Available and functional
907	2978	55	Available and functional
908	2931	59	5
909	2931	62	5
910	2931	50	Not available
911	2931	54	Not available
912	2931	53	Available and functional
913	2931	56	Available and functional
914	2931	55	Available and functional
915	74	57	Available and functional
916	74	59	8
917	74	62	9
918	74	50	Available and functional
919	74	54	Available and functional
920	74	53	Available and functional
921	74	56	Available and functional
922	74	55	Available and functional
923	68	59	2
924	68	62	2
925	68	50	Not available
926	68	54	Available and functional
927	68	53	Available and functional
928	68	56	Available and functional
929	68	55	Available and functional
930	64	59	5
931	64	62	7
932	64	50	Available and functional
933	64	54	Available and functional
934	64	53	Available and functional
935	64	56	Available and functional
936	64	55	Available and functional
937	63	59	4
938	63	62	3
939	63	50	Not available
940	63	53	Available and functional
941	63	56	Available and functional
942	63	55	Available and functional
943	2979	59	4
944	2979	62	6
945	2979	50	Available and functional
946	2979	54	Available and functional
947	2979	53	Available and functional
948	2979	56	Available and functional
949	2979	55	Available and functional
950	2980	59	2
951	2980	62	2
952	2980	50	Not available
953	2980	54	Available and functional
954	2980	53	Available and functional
955	2980	56	Available and functional
956	2980	55	Available and functional
957	2981	59	1
958	2981	62	2
959	2981	50	Not available
960	2981	54	Available and functional
961	2981	53	Available and functional
962	2981	56	Available and functional
963	2981	55	Available and functional
964	2982	59	2
965	2982	62	2
966	2982	50	Not available
967	2982	54	Available and functional
968	2982	53	Available and functional
969	2982	56	Available and functional
970	2982	55	Available and functional
971	2985	59	12
972	2985	62	7
973	2985	50	Available and functional
974	2985	54	Available and functional
975	2985	53	Available and functional
976	2985	56	Available and functional
977	2985	55	Available and functional
978	2986	59	1
979	2986	62	1
980	2986	50	Not available
981	2986	54	Available and functional
982	2986	53	Available and functional
983	2986	56	Available and functional
984	2986	55	Available and functional
985	2910	71	Unknown
986	2910	72	Do Not Know
987	2910	73	Yes
988	2910	74	Yes
989	2910	67	Yes
990	2910	68	Yes
991	2910	69	Unknown
992	2910	70	Do Not Know
993	2910	75	Yes
994	2910	76	Yes
995	2910	86	Yes
996	2910	85	Available and used
997	2910	64	Do Not Know
998	2910	63	Yes
999	2910	66	Unknown
1000	2910	65	Yes
1001	2910	78	Do Not Know
1002	2910	77	Do Not Know
1003	2910	84	Available and used
1004	2910	83	Do Not Know
1005	2910	82	Do Not Know
1006	2910	80	Unknown
1007	2910	79	Do Not Know
1008	2901	58	No
1009	2901	57	Not available
1010	2901	60	0
1011	2901	59	4
1012	2901	62	4
1013	2901	61	0
1014	2901	46	Yes
1015	2901	50	Available and functional
1016	2901	49	Available and functional
1017	2901	52	Available and functional
1018	2901	51	Not available
1019	2901	54	Not available
1020	2901	53	Available but not functional
1021	2901	56	Available and functional
1022	2901	55	Available and functional
1023	2877	58	Yes
1024	2877	46	Yes
1025	2877	50	Available and functional
1026	2877	49	Available and functional
1027	2877	52	Available and functional
1028	2877	51	Available and functional
1029	2877	53	Available and functional
1030	2877	56	Available and functional
1031	2890	58	Yes
1032	2890	57	Available and functional
1033	2890	60	The 1st, 2nd & 3rd grade was combined into 1 class
1034	2890	59	12-15
1035	2890	62	approximately 10
1036	2890	61	Not sure, may be some - that's why they combine lower classes
1037	2890	46	Yes
1038	2890	50	Available and functional
1039	2890	49	Available and functional
1040	2890	52	Available and functional
1041	2890	51	Not available
1042	2890	54	Available and functional
1043	2890	53	Available and functional
1044	2890	56	Available and functional
1045	2890	55	Available and functional
1046	2889	58	Yes
1047	2889	57	Not available
1048	2889	46	Yes
1049	2889	50	Available and functional
1050	2889	49	Available and functional
1051	2889	52	Available and functional
1052	2889	51	Available and functional
1053	2889	54	Available but not functional
1054	2889	53	Available and functional
1055	2889	56	Available but not functional
1056	2909	58	Yes
1057	2909	57	Available and functional
1058	2909	60	
1059	2909	59	6
1060	2909	62	7
1061	2909	61	2
1062	2909	46	Yes
1063	2909	50	Available and functional
1064	2909	49	Available and functional
1065	2909	52	Available and functional
1066	2909	51	Not available
1067	2909	54	Available and functional
1068	2909	53	Not available
1069	2909	56	Available and functional
1070	2909	55	Not available
1071	2904	58	Yes
1072	2904	60	0
1073	2904	59	8
1074	2904	62	6
1075	2904	61	0
1076	2904	46	Yes
1077	2904	50	Available and functional
1078	2904	49	Available and functional
1079	2904	52	Available and functional
1080	2904	51	Not available
1081	2904	54	Available and functional
1082	2904	53	Not available
1083	2904	56	Available and functional
1084	2904	55	Available and functional
1085	2878	71	Not available
1086	2878	72	Do Not Know
1087	2878	73	No
1088	2878	74	No
1089	2878	67	No
1090	2878	68	No
1091	2878	69	Not available
1092	2878	70	No
1093	2878	75	No
1094	2878	76	Yes
1095	2878	86	No
1096	2878	85	Not available
1097	2878	64	No
1098	2878	63	Yes
1099	2878	66	Not available
1100	2878	65	Yes
1101	2878	78	No
1102	2878	77	No
1103	2878	84	Not available
1104	2878	83	Do Not Know
1105	2878	82	Do Not Know
1106	2878	81	No
1107	2878	80	Not available
1108	2878	79	No
1109	2903	71	Not available
1110	2903	72	Do Not Know
1111	2903	73	No
1112	2903	74	No
1113	2903	67	No
1114	2903	68	No
1115	2903	69	Not available
1116	2903	70	No
1117	2903	75	No
1118	2903	76	Yes
1119	2903	86	No
1120	2903	85	Not available
1121	2903	64	No
1122	2903	63	Yes
1123	2903	66	Not available
1124	2903	65	Yes
1125	2903	78	No
1126	2903	77	No
1127	2903	84	Not available
1128	2903	83	Do Not Know
1129	2903	82	Do Not Know
1130	2903	81	No
1131	2903	80	Not available
1132	2903	79	No
1133	2891	71	Unknown
1134	2891	72	Do Not Know
1135	2891	73	No
1136	2891	74	Yes
1137	2891	67	No
1138	2891	68	No
1139	2891	69	Not available
1140	2891	70	No
1141	2891	75	Yes
1142	2891	76	No
1143	2891	86	Yes
1144	2891	85	Available and used
1145	2891	64	Yes
1146	2891	63	Yes
1147	2891	66	Not available
1148	2891	65	Yes
1149	2891	78	Do Not Know
1150	2891	77	Do Not Know
1151	2891	84	Available but not used
1152	2891	83	Do Not Know
1153	2891	82	Do Not Know
1154	2891	81	Yes
1155	2891	80	Unknown
1156	2891	79	Do Not Know
1157	2879	71	Not available
1158	2879	72	Do Not Know
1159	2879	73	No
1160	2879	74	No
1161	2879	67	No
1162	2879	68	No
1163	2879	69	Not available
1164	2879	70	No
1165	2879	75	No
1166	2879	76	No
1167	2879	86	Yes
1168	2879	85	Available and used
1169	2879	64	Yes
1170	2879	63	Yes
1171	2879	66	Not available
1172	2879	65	Yes
1173	2879	78	No
1174	2879	77	Do Not Know
1175	2879	84	Available but not used
1176	2879	83	Do Not Know
1177	2879	82	Do Not Know
1178	2879	81	Yes
1179	2879	80	Not available
1180	2879	79	No
1181	2892	71	Not available
1182	2892	72	Do Not Know
1183	2892	73	Yes
1184	2892	74	Yes
1185	2892	67	Yes
1186	2892	68	Yes
1187	2892	69	Available and used
1188	2892	70	Yes
1189	2892	75	Do Not Know
1190	2892	76	No
1191	2892	86	No
1192	2892	85	Not available
1193	2892	64	Yes
1194	2892	63	Yes
1195	2892	66	Available and used
1196	2892	65	Yes
1197	2892	78	No
1198	2892	77	No
1199	2892	84	Available and used
1200	2892	83	Do Not Know
1201	2892	82	Do Not Know
1202	2892	81	Do Not Know
1203	2892	80	Not available
1204	2892	79	No
1205	2880	86	Yes
1206	2880	85	Available and used
1207	2880	67	No
1208	2880	68	Yes
1209	2880	64	Yes
1210	2880	63	Yes
1211	2880	66	Available and used
1212	2880	65	Yes
1213	2880	69	Available and used
1214	2880	84	Unknown
1215	2893	71	Available and used
1216	2893	72	Do Not Know
1217	2893	73	Yes
1218	2893	74	Yes
1219	2893	67	Yes
1220	2893	68	Yes
1221	2893	69	Available and used
1222	2893	70	Yes
1223	2893	75	Yes
1224	2893	76	Yes
1225	2893	86	Yes
1226	2893	85	Available and used
1227	2893	64	Yes
1228	2893	63	Yes
1229	2893	66	Unknown
1230	2893	65	Yes
1231	2893	78	Yes
1232	2893	77	Yes
1233	2893	84	Available and used
1234	2893	83	Do Not Know
1235	2893	82	Do Not Know
1236	2893	81	Yes
1237	2893	80	Unknown
1238	2893	79	Do Not Know
1239	2882	71	Available and used
1240	2882	72	Yes
1241	2882	73	Yes
1242	2882	74	Yes
1243	2882	67	No
1244	2882	68	No
1245	2882	69	Not available
1246	2882	70	Yes
1247	2882	75	Yes
1248	2882	76	Yes
1249	2882	86	Yes
1250	2882	85	Unknown
1251	2882	64	Yes
1252	2882	63	Yes
1253	2882	66	Available and used
1254	2882	65	Yes
1255	2882	77	Yes
1256	2882	84	Not available
1257	2882	83	Do Not Know
1258	2882	82	Do Not Know
1259	2882	81	Yes
1260	2882	80	Available and used
1261	2882	79	Yes
1262	2883	71	Unknown
1263	2883	72	Yes
1264	2883	73	Yes
1265	2883	74	Yes
1266	2883	67	No
1267	2883	68	No
1268	2883	69	Available and used
1269	2883	70	Yes
1270	2883	75	Yes
1271	2883	76	Yes
1272	2883	86	Yes
1273	2883	85	Available and used
1274	2883	64	Yes
1275	2883	63	Do Not Know
1276	2883	66	Not available
1277	2883	65	Yes
1278	2883	78	No
1279	2883	77	No
1280	2883	84	Available and used
1281	2883	83	Do Not Know
1282	2883	82	Do Not Know
1283	2883	81	Do Not Know
1284	2883	80	Unknown
1285	2883	79	No
1286	2896	71	Available and used
1287	2896	72	Yes
1288	2896	73	Yes
1289	2896	74	Yes
1290	2896	67	Yes
1291	2896	68	Yes
1292	2896	69	Available and used
1293	2896	70	Yes
1294	2896	75	Yes
1295	2896	76	Yes
1296	2896	86	No
1297	2896	85	Available and used
1298	2896	64	Yes
1299	2896	63	Yes
1300	2896	66	Available and used
1301	2896	65	Yes
1302	2896	78	Do Not Know
1303	2896	77	Yes
1304	2896	84	Available but not used
1305	2896	83	Do Not Know
1306	2896	82	Do Not Know
1307	2896	81	Do Not Know
1308	2896	80	Not available
1309	2896	79	Do Not Know
1310	2895	71	Available and used
1311	2895	72	Do Not Know
1312	2895	73	Yes
1313	2895	74	Yes
1314	2895	67	Yes
1315	2895	68	Yes
1316	2895	69	Available and used
1317	2895	70	Yes
1318	2895	75	Yes
1319	2895	76	No
1320	2895	86	No
1321	2895	85	Not available
1322	2895	64	Yes
1323	2895	63	Yes
1324	2895	66	Available and used
1325	2895	65	Yes
1326	2895	78	Do Not Know
1327	2895	77	Yes
1328	2895	84	Available but not used
1329	2895	83	Do Not Know
1330	2895	82	Do Not Know
1331	2895	81	Do Not Know
1332	2895	80	Not available
1333	2895	79	No
1334	2898	71	Available and used
1335	2898	72	Do Not Know
1336	2898	73	Yes
1337	2898	74	Yes
1338	2898	67	Yes
1339	2898	68	No
1340	2898	69	Available and used
1341	2898	70	Yes
1342	2898	75	Yes
1343	2898	76	No
1344	2898	86	No
1345	2898	85	Not available
1346	2898	64	No
1347	2898	63	Yes
1348	2898	66	Available and used
1349	2898	65	Yes
1350	2898	78	Do Not Know
1351	2898	77	Yes
1352	2898	84	Available but not used
1353	2898	83	Yes
1354	2898	82	Do Not Know
1355	2898	81	Do Not Know
1356	2898	80	Not available
1357	2898	79	No
1358	2897	71	Available and used
1359	2897	72	Yes
1360	2897	73	Yes
1361	2897	74	Yes
1362	2897	67	Yes
1363	2897	68	Yes
1364	2897	69	Available and used
1365	2897	70	Yes
1366	2897	75	Yes
1367	2897	76	Yes
1368	2897	86	Yes
1369	2897	85	Available and used
1370	2897	64	Yes
1371	2897	63	Yes
1372	2897	66	Available and used
1373	2897	65	Yes
1374	2897	78	Yes
1375	2897	77	Yes
1376	2897	84	Available and used
1377	2897	83	Do Not Know
1378	2897	82	Yes
1379	2897	81	Yes
1380	2897	80	Available and used
1381	2897	79	Yes
1382	2884	71	Unknown
1383	2884	72	Do Not Know
1384	2884	73	Yes
1385	2884	74	Yes
1386	2884	67	Yes
1387	2884	68	No
1388	2884	69	Available and used
1389	2884	70	Yes
1390	2884	75	Yes
1391	2884	76	Yes
1392	2884	86	No
1393	2884	85	Unknown
1394	2884	64	Yes
1395	2884	63	Yes
1396	2884	66	Unknown
1397	2884	65	Yes
1398	2884	78	Do Not Know
1399	2884	77	Do Not Know
1400	2884	82	Do Not Know
1401	2884	81	Do Not Know
1402	2884	80	Not available
1403	2884	79	No
1404	2894	58	No
1405	2894	46	Yes
1406	2894	50	Available and functional
1407	2894	49	Available and functional
1408	2894	52	Available and functional
1409	2894	51	Available and functional
1410	2894	54	Available and functional
1411	2894	56	Available and functional
1412	2900	71	Available and used
1413	2900	72	Do Not Know
1414	2900	73	No
1415	2900	74	Yes
1416	2900	67	No
1417	2900	68	No
1418	2900	69	Available and used
1419	2900	70	No
1420	2900	75	No
1421	2900	76	Yes
1422	2900	86	Yes
1423	2900	85	Available and used
1424	2900	64	Do Not Know
1425	2900	63	Yes
1426	2900	66	Available and used
1427	2900	65	Yes
1428	2900	78	No
1429	2900	77	No
1430	2900	84	Available and used
1431	2900	83	Do Not Know
1432	2900	82	Do Not Know
1433	2900	81	Do Not Know
1434	2900	80	Not available
1435	2900	79	Do Not Know
1436	2886	71	Unknown
1437	2886	72	Do Not Know
1438	2886	73	Yes
1439	2886	74	Yes
1440	2886	67	No
1441	2886	68	No
1442	2886	69	Not available
1443	2886	70	Do Not Know
1444	2886	75	Yes
1445	2886	76	Yes
1446	2886	86	Do Not Know
1447	2886	85	Unknown
1448	2886	64	Do Not Know
1449	2886	63	Yes
1450	2886	66	Unknown
1451	2886	65	No
1452	2886	78	Do Not Know
1453	2886	77	No
1454	2886	84	Not available
1455	2886	83	Do Not Know
1456	2886	82	Do Not Know
1457	2886	81	Do Not Know
1458	2886	80	Not available
1459	2886	79	Yes
1460	2902	71	Unknown
1461	2902	72	Do Not Know
1462	2902	73	Yes
1463	2902	74	Yes
1464	2902	67	No
1465	2902	68	No
1466	2902	69	Not available
1467	2902	70	No
1468	2902	75	Yes
1469	2902	76	Yes
1470	2902	86	Yes
1471	2902	85	Available and used
1472	2902	64	No
1473	2902	63	Yes
1474	2902	66	Available and used
1475	2902	65	No
1476	2902	78	No
1477	2902	77	No
1478	2902	84	Available and used
1479	2902	83	Do Not Know
1480	2902	82	Do Not Know
1481	2902	81	Do Not Know
1482	2902	80	Available but not used
1483	2902	79	No
1484	2887	71	Unknown
1485	2887	72	Do Not Know
1486	2887	74	Yes
1487	2887	67	No
1488	2887	68	No
1489	2887	69	Unknown
1490	2887	70	Yes
1491	2887	75	Yes
1492	2887	76	Yes
1493	2887	86	Yes
1494	2887	85	Available and used
1495	2887	64	No
1496	2887	63	Yes
1497	2887	66	Available and used
1498	2887	65	Yes
1499	2887	78	Yes
1500	2887	77	Yes
1501	2887	84	Available and used
1502	2887	83	Do Not Know
1503	2887	82	Do Not Know
1504	2887	81	Do Not Know
1505	2887	80	Unknown
1506	2887	79	Yes
1507	2888	71	Unknown
1508	2888	72	Do Not Know
1509	2888	73	Yes
1510	2888	74	Yes
1511	2888	67	Yes
1512	2888	68	No
1513	2888	69	Available and used
1514	2888	70	Yes
1515	2888	75	Yes
1516	2888	76	Yes
1517	2888	86	Yes
1518	2888	85	Available and used
1519	2888	64	Yes
1520	2888	63	Yes
1521	2888	66	Available and used
1522	2888	65	Yes
1523	2888	78	Yes
1524	2888	77	No
1525	2888	84	Available and used
1526	2888	83	Do Not Know
1527	2888	82	Do Not Know
1528	2888	81	Do Not Know
1529	2888	80	Available and used
1530	2888	79	Do Not Know
1531	2917	71	Available but not used
1532	2917	72	No
1533	2917	73	Yes
1534	2917	74	Yes
1535	2917	67	Yes
1536	2917	68	No
1537	2917	69	Available and used
1538	2917	70	No
1539	2917	75	Yes
1540	2917	76	Yes
1541	2917	86	No
1542	2917	85	Available but not used
1543	2917	63	Yes
1544	2917	66	Available and used
1545	2917	65	Yes
1546	2917	78	No
1547	2917	77	No
1548	2917	84	Available but not used
1549	2917	83	No
1550	2917	82	No
1551	2917	81	No
1552	2917	80	Available but not used
1553	2917	79	No
1554	2921	71	Unknown
1555	2921	72	Do Not Know
1556	2921	73	Yes
1557	2921	74	Yes
1558	2921	67	No
1559	2921	68	No
1560	2921	69	Not available
1561	2921	70	No
1562	2921	75	Yes
1563	2921	76	Yes
1564	2921	86	Yes
1565	2921	85	Not available
1566	2921	64	Yes
1567	2921	63	Yes
1568	2921	66	Available and used
1569	2921	65	Yes
1570	2921	78	Do Not Know
1571	2921	77	No
1572	2921	84	Available and used
1573	2921	83	Do Not Know
1574	2921	82	Do Not Know
1575	2921	81	Do Not Know
1576	2921	80	Available and used
1577	2921	79	Do Not Know
1578	2922	71	Available and used
1579	2922	72	Yes
1580	2922	73	Yes
1581	2922	74	Yes
1582	2922	67	No
1583	2922	68	No
1584	2922	69	Not available
1585	2922	70	Yes
1586	2922	75	Yes
1587	2922	76	Yes
1588	2922	86	Yes
1589	2922	85	Available and used
1590	2922	64	No
1591	2922	63	Yes
1592	2922	66	Available and used
1593	2922	65	Yes
1594	2922	78	Yes
1595	2922	77	Do Not Know
1596	2922	84	Available and used
1597	2922	83	Do Not Know
1598	2922	82	Do Not Know
1599	2922	81	Yes
1600	2922	80	Available and used
1601	2922	79	No
1602	2918	65	Yes
1603	2918	64	Do Not Know
1604	2918	63	No
1605	2920	71	Unknown
1606	2920	72	Do Not Know
1607	2920	73	No
1608	2920	74	No
1609	2920	67	No
1610	2920	68	Yes
1611	2920	69	Available and used
1612	2920	70	Yes
1613	2920	75	No
1614	2920	76	No
1615	2920	86	Yes
1616	2920	85	Available but not used
1617	2920	64	Yes
1618	2920	63	Yes
1619	2920	66	Unknown
1620	2920	65	Yes
1621	2920	78	Yes
1622	2920	77	Yes
1623	2920	84	Available and used
1624	2920	83	Do Not Know
1625	2920	82	Do Not Know
1626	2920	81	Do Not Know
1627	2920	80	Not available
1628	2920	79	Do Not Know
1629	2923	46	yes
1630	2923	50	yes
1631	2923	56	yes
1632	2923	57	yes
1633	2923	58	yes
1634	2923	91	yes
1635	2923	92	yes
1636	2987	46	yes
1637	2987	49	yes
1638	2987	91	yes
1639	2936	79	yes
1640	2936	80	yes
1641	2936	81	yes
1642	2936	85	yes
1643	2936	86	yes
1644	2936	63	yes
1645	2936	64	yes
1646	2936	65	yes
1647	2936	66	yes
1648	2936	67	yes
1649	2936	68	yes
1650	2936	69	yes
1651	2936	71	yes
1652	2936	72	yes
1653	2936	73	yes
1654	2936	74	yes
1655	2936	75	yes
1656	2936	76	yes
1657	2936	78	yes
1658	3012	49	yes
1659	3012	58	yes
1660	3012	52	yes
1661	3012	53	yes
1662	3012	54	yes
1663	3012	55	yes
1664	3012	57	yes
1665	3012	90	yes
1666	3012	91	yes
1667	3012	92	yes
1668	3012	89	yes
1669	2946	64	yes
1670	2939	46	yes
1671	2939	53	yes
1672	2939	55	yes
1673	2939	88	yes
1674	2939	89	yes
1675	2939	58	yes
1676	2939	91	yes
1677	2939	60	yes
1678	2939	92	yes
1679	2939	87	yes
1680	2939	56	yes
1681	2938	46	yes
1682	2938	87	yes
1683	2938	56	yes
1684	2938	58	yes
1685	2938	91	yes
1686	2938	92	yes
1687	2925	46	yes
1688	2925	49	yes
1689	2925	87	yes
1690	2925	88	yes
1691	2925	89	yes
1692	2925	58	yes
1693	2925	91	yes
1694	2925	92	yes
1695	2925	56	yes
1696	2937	49	yes
1697	2937	58	yes
1698	2937	52	yes
1699	2937	53	yes
1700	2937	55	yes
1701	2937	56	yes
1702	2937	89	yes
1703	2937	90	yes
1704	2937	91	yes
1705	2937	92	yes
1706	2937	87	yes
1707	2937	88	yes
1708	2945	53	yes
1709	2945	55	yes
1710	2945	56	yes
1711	2945	89	yes
1712	2945	58	yes
1713	2945	91	yes
1714	2945	60	yes
1715	2945	92	yes
1716	2945	87	yes
1717	2945	88	yes
1718	2944	46	yes
1719	2944	49	yes
1720	2944	50	yes
1721	2944	51	yes
1722	2944	52	yes
1723	2944	53	yes
1724	2944	54	yes
1725	2944	55	yes
1726	2944	56	yes
1727	2944	89	yes
1728	2944	90	yes
1729	2944	91	yes
1730	2944	92	yes
1731	2944	87	yes
1732	2944	88	yes
1733	2943	46	yes
1734	2943	49	yes
1735	2943	50	yes
1736	2943	52	yes
1737	2943	53	yes
1738	2943	54	yes
1739	2943	55	yes
1740	2943	56	yes
1741	2943	57	yes
1742	2943	90	yes
1743	2943	91	yes
1744	2943	92	yes
1745	2943	58	yes
1746	2943	87	yes
1747	2943	88	yes
1748	2943	89	yes
1749	2935	46	yes
1750	2935	49	yes
1751	2935	50	yes
1752	2935	53	yes
1753	2935	54	yes
1754	2935	55	yes
1755	2935	56	yes
1756	2935	89	yes
1757	2935	90	yes
1758	2935	91	yes
1759	2935	92	yes
1760	2935	58	yes
1761	2935	87	yes
1762	2935	88	yes
1763	2940	46	yes
1764	2940	49	yes
1765	2940	50	yes
1766	2940	52	yes
1767	2940	54	yes
1768	2940	55	yes
1769	2940	56	yes
1770	2940	89	yes
1771	2940	90	yes
1772	2940	91	yes
1773	2940	92	yes
1774	2940	58	yes
1775	2940	87	yes
1776	2940	88	yes
1777	2934	46	yes
1778	2934	49	yes
1779	2934	50	yes
1780	2934	52	yes
1781	2934	53	yes
1782	2934	54	yes
1783	2934	55	yes
1784	2934	56	yes
1785	2934	89	yes
1786	2934	90	yes
1787	2934	91	yes
1788	2934	92	yes
1789	2934	58	yes
1790	2934	87	yes
1791	2934	88	yes
1792	2988	46	yes
1793	2988	49	yes
1794	2988	58	yes
1795	2988	52	yes
1796	2988	53	yes
1797	2988	54	yes
1798	2988	55	yes
1799	2988	56	yes
1800	2988	90	yes
1801	2988	91	yes
1802	2988	92	yes
1803	2988	87	yes
1804	2988	88	yes
1805	2947	81	yes
1806	2947	64	yes
1807	2947	65	yes
1808	2947	67	yes
1809	2947	69	yes
1810	2947	72	yes
1811	2948	64	yes
1812	2948	76	yes
1813	3013	46	yes
1814	3013	49	yes
1815	3013	50	yes
1816	3013	52	yes
1817	3013	53	yes
1818	3013	54	yes
1819	3013	87	yes
1820	3013	56	yes
1821	3013	89	yes
1822	3013	90	yes
1823	3013	91	yes
1824	3013	92	yes
1825	3013	88	yes
1826	3015	80	yes
1827	3015	84	yes
1828	3015	85	yes
1829	3015	86	yes
1830	3015	64	yes
1831	3015	65	yes
1832	3015	66	yes
1833	3015	69	yes
1834	3015	71	yes
1835	3015	72	yes
1836	3015	73	yes
1837	3015	74	yes
1838	3015	75	yes
1839	3019	46	yes
1840	3019	49	yes
1841	3019	50	yes
1842	3019	52	yes
1843	3019	54	yes
1844	3019	55	yes
1845	3019	56	yes
1846	3019	57	yes
1847	3019	90	yes
1848	3019	91	yes
1849	3019	92	yes
1850	3019	58	yes
1851	3019	87	yes
1852	3019	89	yes
1853	3021	81	yes
1854	3021	64	yes
1855	3021	65	yes
1856	3021	67	yes
1857	3021	68	yes
1858	3021	71	yes
1859	3020	79	yes
1860	3020	80	yes
1861	3020	81	yes
1862	3020	84	yes
1863	3020	85	yes
1864	3020	86	yes
1865	3020	63	yes
1866	3020	65	yes
1867	3020	66	yes
1868	3020	72	yes
1869	3020	77	yes
1870	3020	78	yes
1871	2912	79	yes
1872	2912	80	yes
1873	2912	81	yes
1874	2912	84	yes
1875	2912	85	yes
1876	2912	86	yes
1877	2912	63	yes
1878	2912	65	yes
1879	2912	66	yes
1880	2912	68	yes
1881	2912	69	yes
1882	2912	73	yes
1883	2912	75	yes
1884	2912	77	yes
1885	2941	75	yes
1886	2941	68	yes
1887	3022	46	yes
1888	3022	49	yes
1889	3022	50	yes
1890	3022	54	yes
1891	3022	55	yes
1892	3022	88	yes
1893	3022	89	yes
1894	3022	90	yes
1895	3022	91	yes
1896	3022	92	yes
1897	3022	87	yes
1898	3024	46	yes
1899	3024	49	yes
1900	3024	54	yes
1901	3024	87	yes
1902	3024	88	yes
1903	3024	58	yes
1904	3024	91	yes
1905	3024	92	yes
1906	3023	46	yes
1907	3023	49	yes
1908	3023	50	yes
1909	3023	51	yes
1910	3023	52	yes
1911	3023	53	yes
1912	3023	54	yes
1913	3023	55	yes
1914	3023	56	yes
1915	3023	57	yes
1916	3023	90	yes
1917	3023	91	yes
1918	3023	58	yes
1919	3023	87	yes
1920	3023	88	yes
1921	3023	89	yes
1922	3027	81	yes
1923	3027	84	yes
1924	3027	86	yes
1925	3027	64	yes
1926	3027	65	yes
1927	3027	66	yes
1928	3027	69	yes
1929	3027	73	yes
1930	3027	74	yes
1931	3027	75	yes
1932	3028	46	yes
1933	3028	49	yes
1934	3028	50	yes
1935	3028	52	yes
1936	3028	54	yes
1937	3028	55	yes
1938	3028	90	yes
1939	3028	91	yes
1940	3028	92	yes
1941	3028	58	yes
1942	3030	46	yes
1943	3030	49	yes
1944	3030	50	yes
1945	3030	52	yes
1946	3030	54	yes
1947	3030	55	yes
1948	3030	57	yes
1949	3030	90	yes
1950	3030	58	yes
1951	3030	89	yes
1952	3029	58	yes
1953	3029	52	yes
1954	3029	92	yes
1955	3032	46	yes
1956	3032	49	yes
1957	3032	50	yes
1958	3032	52	yes
1959	3032	56	yes
1960	3032	89	yes
1961	3032	90	yes
1962	3032	91	yes
1963	3032	92	yes
1964	3032	58	yes
1965	3031	46	yes
1966	3031	49	yes
1967	3031	50	yes
1968	3031	52	yes
1969	3031	56	yes
1970	3031	89	yes
1971	3031	58	yes
1972	3031	91	yes
1973	3033	46	yes
1974	3033	49	yes
1975	3033	58	yes
1976	3033	52	yes
1977	3033	55	yes
1978	3033	56	yes
1979	3033	90	yes
1980	3033	91	yes
1981	3033	87	yes
1982	3033	88	yes
1983	3035	55	yes
1984	3035	49	yes
1985	3035	50	yes
1986	3035	91	yes
1987	3035	92	yes
1988	3034	49	yes
1989	3034	58	yes
1990	3034	52	yes
1991	3034	87	yes
1992	3034	56	yes
1993	3034	89	yes
1994	3034	90	yes
1995	3034	91	yes
1996	3034	60	yes
1997	3034	92	yes
1998	3016	58	yes
1999	3016	50	yes
2000	3016	91	yes
2001	3036	46	yes
2002	3036	49	yes
2003	3036	58	yes
2004	3036	52	yes
2005	3036	87	yes
2006	3036	88	yes
2007	3036	89	yes
2008	3036	90	yes
2009	3036	91	yes
2010	3036	92	yes
2011	3036	56	yes
2012	3037	84	yes
2013	3037	85	yes
2014	3037	86	yes
2015	3037	64	yes
2016	3037	65	yes
2017	3037	66	yes
2018	3037	67	yes
2019	3037	69	yes
2020	3037	73	yes
2021	3037	74	yes
2022	3037	78	yes
2023	3017	80	yes
2024	3017	84	yes
2025	3017	85	yes
2026	3017	86	yes
2027	3017	65	yes
2028	3017	69	yes
2029	3017	74	yes
2030	3017	78	yes
2031	3039	46	yes
2032	3039	58	yes
2033	3039	52	yes
2034	3039	55	yes
2035	3039	88	yes
2036	3039	89	yes
2037	3039	90	yes
2038	3039	91	yes
2039	3039	92	yes
2040	3039	87	yes
2041	3039	56	yes
2042	3040	79	yes
2043	3040	80	yes
2044	3040	81	yes
2045	3040	84	yes
2046	3040	85	yes
2047	3040	86	yes
2048	3040	64	yes
2049	3040	65	yes
2050	3040	69	yes
2051	3040	71	yes
2052	3040	72	yes
2053	3040	73	yes
2054	3040	74	yes
2055	3040	75	yes
2056	3040	76	yes
2057	3041	79	yes
2058	3041	80	yes
2059	3041	84	yes
2060	3041	85	yes
2061	3041	86	yes
2062	3041	64	yes
2063	3041	65	yes
2064	3041	67	yes
2065	3041	68	yes
2066	3041	69	yes
2067	3041	71	yes
2068	3041	72	yes
2069	3041	73	yes
2070	3041	74	yes
2071	3041	76	yes
2072	3041	77	yes
2073	3041	78	yes
2074	3058	79	yes
2075	3058	80	yes
2076	3058	84	yes
2077	3058	85	yes
2078	3058	86	yes
2079	3058	63	yes
2080	3058	64	yes
2081	3058	65	yes
2082	3058	66	yes
2083	3058	67	yes
2084	3058	68	yes
2085	3058	69	yes
2086	3058	71	yes
2087	3058	72	yes
2088	3058	73	yes
2089	3058	74	yes
2090	3058	75	yes
2091	3058	76	yes
2092	3058	78	yes
2093	3085	49	yes
2094	3085	50	yes
2095	3085	54	yes
2096	3085	55	yes
2097	3085	89	yes
2098	3085	90	yes
2099	3085	91	yes
2100	3085	92	yes
2101	3085	58	yes
2102	3085	57	yes
2103	3086	46	yes
2104	3086	49	yes
2105	3086	58	yes
2106	3086	51	yes
2107	3086	54	yes
2108	3086	55	yes
2109	3086	56	yes
2110	3086	57	yes
2111	3086	90	yes
2112	3086	91	yes
2113	3086	92	yes
2114	3086	89	yes
2115	3087	46	yes
2116	3087	49	yes
2117	3087	50	yes
2118	3087	55	yes
2119	3087	56	yes
2120	3087	57	yes
2121	3087	90	yes
2122	3087	91	yes
2123	3087	92	yes
2124	3087	89	yes
2125	3088	49	yes
2126	3088	50	yes
2127	3088	52	yes
2128	3088	53	yes
2129	3088	55	yes
2130	3088	56	yes
2131	3088	57	yes
2132	3088	90	yes
2133	3088	91	yes
2134	3088	58	yes
2135	3088	87	yes
2136	3088	89	yes
2137	3089	49	yes
2138	3089	50	yes
2139	3089	87	yes
2140	3089	56	yes
2141	3089	90	yes
2142	3089	91	yes
2143	3089	92	yes
2144	3089	58	yes
2145	3313	46	yes
2146	3313	49	yes
2147	3313	50	yes
2148	3313	52	yes
2149	3313	58	yes
2150	3313	90	yes
2151	3112	46	yes
2152	3112	49	yes
2153	3112	50	yes
2154	3112	52	yes
2155	3112	54	yes
2156	3112	55	yes
2157	3112	56	yes
2158	3112	58	yes
2159	3112	91	yes
2160	3112	92	yes
2161	3112	87	yes
2162	3090	46	YES
2163	3090	49	YES
2164	3090	50	NO
2165	3090	51	YES
2166	3090	52	NO
2167	3090	53	YES
2168	3090	54	YES
2169	3090	55	YES
2170	3090	56	YES
2171	3090	57	NO
2172	3090	90	YES
2173	3090	91	YES
2174	3090	60	NO
2175	3090	92	YES
2176	3090	58	YES
2177	3090	87	YES
2178	3090	88	YES
2179	3090	89	YES
2180	3091	46	YES
2181	3091	49	YES
2182	3091	50	YES
2183	3091	51	YES
2184	3091	52	NO
2185	3091	53	YES
2186	3091	54	YES
2187	3091	55	YES
2188	3091	56	YES
2189	3091	57	YES
2190	3091	90	YES
2191	3091	91	YES
2192	3091	60	NO
2193	3091	92	YES
2194	3091	58	YES
2195	3091	87	YES
2196	3091	88	NO
2197	3091	89	YES
2198	3092	46	YES
2199	3092	49	YES
2200	3092	50	NO
2201	3092	51	YES
2202	3092	52	NO
2203	3092	53	YES
2204	3092	54	YES
2205	3092	55	YES
2206	3092	56	YES
2207	3092	57	YES
2208	3092	90	YES
2209	3092	91	YES
2210	3092	60	NO
2211	3092	92	YES
2212	3092	58	YES
2213	3092	87	YES
2214	3092	88	YES
2215	3092	89	YES
2216	3093	46	NO
2217	3093	49	NO
2218	3093	50	NO
2219	3093	51	NO
2220	3093	52	NO
2221	3093	53	YES
2222	3093	54	YES
2223	3093	55	YES
2224	3093	56	YES
2225	3093	57	YES
2226	3093	90	NO
2227	3093	91	YES
2228	3093	60	NO
2229	3093	92	YES
2230	3093	58	YES
2231	3093	87	YES
2232	3093	88	NO
2233	3093	89	YES
2234	3094	46	YES
2235	3094	49	YES
2236	3094	50	YES
2237	3094	51	YES
2238	3094	52	NO
2239	3094	53	YES
2240	3094	54	YES
2241	3094	55	YES
2242	3094	56	YES
2243	3094	57	YES
2244	3094	90	YES
2245	3094	91	YES
2246	3094	60	NO
2247	3094	92	YES
2248	3094	58	YES
2249	3094	87	YES
2250	3094	88	NO
2251	3094	89	YES
2252	3095	46	YES
2253	3095	49	NO
2254	3095	50	NO
2255	3095	51	NO
2256	3095	52	NO
2257	3095	53	YES
2258	3095	54	YES
2259	3095	55	YES
2260	3095	56	YES
2261	3095	57	YES
2262	3095	90	NO
2263	3095	91	YES
2264	3095	60	NO
2265	3095	92	YES
2266	3095	58	YES
2267	3095	87	YES
2268	3095	88	YES
2269	3095	89	YES
2270	3096	46	YES
2271	3096	49	NO
2272	3096	50	NO
2273	3096	51	NO
2274	3096	52	NO
2275	3096	53	NO
2276	3096	54	YES
2277	3096	55	YES
2278	3096	56	YES
2279	3096	57	YES
2280	3096	90	NO
2281	3096	91	YES
2282	3096	60	NO
2283	3096	92	YES
2284	3096	58	YES
2285	3096	87	YES
2286	3096	88	NO
2287	3096	89	YES
2288	3097	46	YES
2289	3097	49	YES
2290	3097	50	YES
2291	3097	51	YES
2292	3097	52	YES
2293	3097	53	YES
2294	3097	54	YES
2295	3097	55	YES
2296	3097	56	YES
2297	3097	57	YES
2298	3097	90	YES
2299	3097	91	YES
2300	3097	60	NO
2301	3097	92	YES
2302	3097	58	YES
2303	3097	87	YES
2304	3097	88	NO
2305	3097	89	YES
2306	3098	46	YES
2307	3098	49	NO
2308	3098	50	NO
2309	3098	51	NO
2310	3098	52	NO
2311	3098	53	YES
2312	3098	54	YES
2313	3098	55	YES
2314	3098	56	YES
2315	3098	57	YES
2316	3098	90	YES
2317	3098	91	YES
2318	3098	60	NO
2319	3098	92	YES
2320	3098	58	YES
2321	3098	87	YES
2322	3098	88	YES
2323	3098	89	YES
2324	3099	46	YES
2325	3099	49	YES
2326	3099	50	YES
2327	3099	51	NO
2328	3099	52	NO
2329	3099	53	YES
2330	3099	54	YES
2331	3099	55	YES
2332	3099	56	YES
2333	3099	57	YES
2334	3099	90	YES
2335	3099	91	YES
2336	3099	60	NO
2337	3099	92	YES
2338	3099	58	YES
2339	3099	87	YES
2340	3099	88	NO
2341	3099	89	YES
2342	3100	46	YES
2343	3100	49	YES
2344	3100	50	NO
2345	3100	51	YES
2346	3100	52	NO
2347	3100	53	YES
2348	3100	54	YES
2349	3100	55	YES
2350	3100	56	YES
2351	3100	57	YES
2352	3100	90	YES
2353	3100	91	YES
2354	3100	60	NO
2355	3100	92	YES
2356	3100	58	YES
2357	3100	87	YES
2358	3100	88	NO
2359	3100	89	YES
2360	3101	46	YES
2361	3101	49	YES
2362	3101	50	YES
2363	3101	51	YES
2364	3101	52	NO
2365	3101	53	YES
2366	3101	54	YES
2367	3101	55	YES
2368	3101	56	YES
2369	3101	57	YES
2370	3101	90	YES
2371	3101	91	YES
2372	3101	60	NO
2373	3101	92	YES
2374	3101	58	YES
2375	3101	87	YES
2376	3101	88	YES
2377	3101	89	YES
2378	3102	46	YES
2379	3102	49	YES
2380	3102	50	NO
2381	3102	51	YES
2382	3102	52	NO
2383	3102	53	YES
2384	3102	54	YES
2385	3102	55	YES
2386	3102	56	YES
2387	3102	57	YES
2388	3102	90	NO
2389	3102	91	YES
2390	3102	60	NO
2391	3102	92	YES
2392	3102	58	YES
2393	3102	87	YES
2394	3102	88	YES
2395	3102	89	YES
2396	3103	46	YES
2397	3103	49	YES
2398	3103	50	YES
2399	3103	51	YES
2400	3103	52	NO
2401	3103	53	YES
2402	3103	54	YES
2403	3103	55	YES
2404	3103	56	YES
2405	3103	57	YES
2406	3103	90	YES
2407	3103	91	YES
2408	3103	60	NO
2409	3103	92	YES
2410	3103	58	YES
2411	3103	87	YES
2412	3103	88	NO
2413	3103	89	YES
2414	3104	46	YES
2415	3104	49	YES
2416	3104	50	NO
2417	3104	51	YES
2418	3104	52	NO
2419	3104	53	YES
2420	3104	54	YES
2421	3104	55	YES
2422	3104	56	YES
2423	3104	57	YES
2424	3104	90	YES
2425	3104	91	YES
2426	3104	60	NO
2427	3104	92	YES
2428	3104	58	YES
2429	3104	87	YES
2430	3104	88	YES
2431	3104	89	YES
2432	3105	46	YES
2433	3105	49	YES
2434	3105	50	YES
2435	3105	51	YES
2436	3105	52	NO
2437	3105	53	YES
2438	3105	54	YES
2439	3105	55	YES
2440	3105	56	YES
2441	3105	57	YES
2442	3105	90	NO
2443	3105	91	YES
2444	3105	60	NO
2445	3105	92	YES
2446	3105	58	YES
2447	3105	87	YES
2448	3105	88	YES
2449	3105	89	YES
2450	3106	46	YES
2451	3106	49	YES
2452	3106	50	YES
2453	3106	51	YES
2454	3106	52	NO
2455	3106	53	YES
2456	3106	54	YES
2457	3106	55	YES
2458	3106	56	YES
2459	3106	57	YES
2460	3106	90	YES
2461	3106	91	YES
2462	3106	60	NO
2463	3106	92	YES
2464	3106	58	YES
2465	3106	87	YES
2466	3106	88	NO
2467	3106	89	YES
2468	3107	46	YES
2469	3107	49	YES
2470	3107	50	NO
2471	3107	51	NO
2472	3107	52	NO
2473	3107	53	YES
2474	3107	54	YES
2475	3107	55	YES
2476	3107	56	YES
2477	3107	57	YES
2478	3107	90	NO
2479	3107	91	YES
2480	3107	60	NO
2481	3107	92	YES
2482	3107	58	YES
2483	3107	87	YES
2484	3107	88	NO
2485	3107	89	YES
2486	3108	46	YES
2487	3108	49	YES
2488	3108	50	NO
2489	3108	51	NO
2490	3108	52	NO
2491	3108	53	YES
2492	3108	54	NO
2493	3108	55	YES
2494	3108	56	YES
2495	3108	57	YES
2496	3108	90	YES
2497	3108	91	YES
2498	3108	60	NO
2499	3108	92	YES
2500	3108	58	YES
2501	3108	87	YES
2502	3108	88	NO
2503	3108	89	YES
2504	3109	46	YES
2505	3109	49	YES
2506	3109	50	NO
2507	3109	51	YES
2508	3109	52	NO
2509	3109	53	YES
2510	3109	54	NO
2511	3109	55	YES
2512	3109	56	YES
2513	3109	57	YES
2514	3109	90	YES
2515	3109	91	YES
2516	3109	60	NO
2517	3109	92	YES
2518	3109	58	YES
2519	3109	87	YES
2520	3109	88	YES
2521	3109	89	YES
2522	3110	46	YES
2523	3110	49	NO
2524	3110	50	NO
2525	3110	51	NO
2526	3110	52	NO
2527	3110	53	YES
2528	3110	54	YES
2529	3110	55	NO
2530	3110	56	YES
2531	3110	57	YES
2532	3110	90	NO
2533	3110	91	YES
2534	3110	60	YES
2535	3110	92	YES
2536	3110	58	YES
2537	3110	87	YES
2538	3110	88	NO
2539	3110	89	YES
2540	3111	46	YES
2541	3111	49	NO
2542	3111	50	NO
2543	3111	51	YES
2544	3111	52	NO
2545	3111	53	YES
2546	3111	54	YES
2547	3111	55	YES
2548	3111	56	YES
2549	3111	57	YES
2550	3111	90	YES
2551	3111	91	YES
2552	3111	60	NO
2553	3111	92	YES
2554	3111	58	YES
2555	3111	87	YES
2556	3111	88	YES
2557	3111	89	YES
2558	3048	46	YES
2559	3048	49	YES
2560	3048	50	YES
2561	3048	51	YES
2562	3048	52	NO
2563	3048	53	YES
2564	3048	54	YES
2565	3048	55	YES
2566	3048	56	YES
2567	3048	57	YES
2568	3048	90	YES
2569	3048	91	YES
2570	3048	60	YES
2571	3048	92	YES
2572	3048	58	YES
2573	3048	87	YES
2574	3048	88	NO
2575	3048	89	YES
2576	3049	46	YES
2577	3049	49	YES
2578	3049	50	NO
2579	3049	51	YES
2580	3049	52	NO
2581	3049	53	YES
2582	3049	54	YES
2583	3049	55	YES
2584	3049	56	YES
2585	3049	57	YES
2586	3049	90	NO
2587	3049	91	YES
2588	3049	60	NO
2589	3049	92	YES
2590	3049	58	YES
2591	3049	87	YES
2592	3049	88	NO
2593	3049	89	YES
2594	3050	46	YES
2595	3050	49	YES
2596	3050	50	YES
2597	3050	51	NO
2598	3050	52	NO
2599	3050	53	YES
2600	3050	54	YES
2601	3050	55	YES
2602	3050	56	YES
2603	3050	57	YES
2604	3050	90	YES
2605	3050	91	YES
2606	3050	60	YES
2607	3050	92	YES
2608	3050	58	YES
2609	3050	87	YES
2610	3050	88	YES
2611	3050	89	YES
2612	3044	46	YES
2613	3044	49	YES
2614	3044	50	YES
2615	3044	51	YES
2616	3044	52	NO
2617	3044	53	YES
2618	3044	54	YES
2619	3044	55	YES
2620	3044	56	YES
2621	3044	57	YES
2622	3044	90	YES
2623	3044	91	YES
2624	3044	60	NO
2625	3044	92	YES
2626	3044	58	YES
2627	3044	87	YES
2628	3044	88	YES
2629	3044	89	YES
2630	3045	46	YES
2631	3045	49	YES
2632	3045	50	NO
2633	3045	51	YES
2634	3045	52	YES
2635	3045	53	YES
2636	3045	54	YES
2637	3045	55	YES
2638	3045	56	YES
2639	3045	57	YES
2640	3045	90	NO
2641	3045	91	YES
2642	3045	60	YES
2643	3045	92	YES
2644	3045	58	YES
2645	3045	87	YES
2646	3045	88	YES
2647	3045	89	YES
2648	3051	46	YES
2649	3051	49	YES
2650	3051	50	YES
2651	3051	51	NO
2652	3051	52	NO
2653	3051	53	YES
2654	3051	54	YES
2655	3051	55	YES
2656	3051	56	YES
2657	3051	57	YES
2658	3051	90	YES
2659	3051	91	YES
2660	3051	60	NO
2661	3051	92	YES
2662	3051	58	YES
2663	3051	87	YES
2664	3051	88	NO
2665	3051	89	YES
2666	3052	46	YES
2667	3052	49	YES
2668	3052	50	NO
2669	3052	51	YES
2670	3052	52	NO
2671	3052	53	YES
2672	3052	54	NO
2673	3052	55	YES
2674	3052	56	YES
2675	3052	57	NO
2676	3052	90	NO
2677	3052	91	YES
2678	3052	60	NO
2679	3052	92	NO
2680	3052	58	YES
2681	3052	87	YES
2682	3052	88	YES
2683	3052	89	YES
2684	3053	46	YES
2685	3053	49	YES
2686	3053	50	YES
2687	3053	51	YES
2688	3053	52	YES
2689	3053	53	YES
2690	3053	54	YES
2691	3053	55	YES
2692	3053	56	YES
2693	3053	57	YES
2694	3053	90	YES
2695	3053	91	YES
2696	3053	60	NO
2697	3053	92	NO
2698	3053	58	YES
2699	3053	87	YES
2700	3053	88	YES
2701	3053	89	YES
2702	3054	46	YES
2703	3054	49	YES
2704	3054	50	YES
2705	3054	51	YES
2706	3054	52	NO
2707	3054	53	YES
2708	3054	54	NO
2709	3054	55	YES
2710	3054	56	YES
2711	3054	57	YES
2712	3054	90	NO
2713	3054	91	NO
2714	3054	60	NO
2715	3054	92	NO
2716	3054	58	NO
2717	3054	87	YES
2718	3054	88	YES
2719	3054	89	YES
2720	3055	46	YES
2721	3055	49	YES
2722	3055	50	YES
2723	3055	51	YES
2724	3055	52	YES
2725	3055	53	YES
2726	3055	54	NO
2727	3055	55	YES
2728	3055	56	YES
2729	3055	57	NO
2730	3055	90	NO
2731	3055	91	YES
2732	3055	60	NO
2733	3055	92	YES
2734	3055	58	YES
2735	3055	87	YES
2736	3055	88	YES
2737	3055	89	YES
2738	3056	46	YES
2739	3056	49	NO
2740	3056	50	NO
2741	3056	51	YES
2742	3056	52	NO
2743	3056	53	YES
2744	3056	54	YES
2745	3056	55	YES
2746	3056	56	YES
2747	3056	57	YES
2748	3056	90	NO
2749	3056	91	NO
2750	3056	60	NO
2751	3056	92	NO
2752	3056	58	NO
2753	3056	87	YES
2754	3056	88	YES
2755	3056	89	YES
2756	3062	46	YES
2757	3062	49	YES
2758	3062	50	YES
2759	3062	51	YES
2760	3062	52	NO
2761	3062	53	YES
2762	3062	54	YES
2763	3062	55	YES
2764	3062	56	YES
2765	3062	57	YES
2766	3062	90	NO
2767	3062	91	NO
2768	3062	60	NO
2769	3062	92	NO
2770	3062	58	NO
2771	3062	87	YES
2772	3062	88	YES
2773	3062	89	YES
2774	3063	46	YES
2775	3063	49	YES
2776	3063	50	YES
2777	3063	51	NO
2778	3063	52	NO
2779	3063	53	YES
2780	3063	54	YES
2781	3063	55	YES
2782	3063	56	YES
2783	3063	57	YES
2784	3063	90	NO
2785	3063	91	YES
2786	3063	60	NO
2787	3063	92	YES
2788	3063	58	YES
2789	3063	87	NO
2790	3063	88	NO
2791	3063	89	YES
2792	3064	46	YES
2793	3064	49	YES
2794	3064	50	YES
2795	3064	51	YES
2796	3064	52	NO
2797	3064	53	YES
2798	3064	54	YES
2799	3064	55	YES
2800	3064	56	YES
2801	3064	57	YES
2802	3064	90	NO
2803	3064	91	YES
2804	3064	60	NO
2805	3064	92	YES
2806	3064	58	YES
2807	3064	87	NO
2808	3064	88	NO
2809	3064	89	YES
2810	3065	46	YES
2811	3065	49	YES
2812	3065	50	YES
2813	3065	51	YES
2814	3065	52	NO
2815	3065	53	YES
2816	3065	54	YES
2817	3065	55	YES
2818	3065	56	YES
2819	3065	57	YES
2820	3065	90	NO
2821	3065	91	YES
2822	3065	60	NO
2823	3065	92	NO
2824	3065	58	YES
2825	3065	87	YES
2826	3065	88	NO
2827	3065	89	YES
2828	3066	46	YES
2829	3066	49	YES
2830	3066	50	YES
2831	3066	51	YES
2832	3066	52	YES
2833	3066	53	YES
2834	3066	54	YES
2835	3066	55	YES
2836	3066	56	YES
2837	3066	57	YES
2838	3066	90	NO
2839	3066	91	NO
2840	3066	60	NO
2841	3066	92	NO
2842	3066	58	NO
2843	3066	87	YES
2844	3066	88	YES
2845	3066	89	YES
2846	3067	46	YES
2847	3067	49	NO
2848	3067	50	NO
2849	3067	51	YES
2850	3067	52	NO
2851	3067	53	NO
2852	3067	54	YES
2853	3067	55	YES
2854	3067	56	YES
2855	3067	57	YES
2856	3067	90	NO
2857	3067	91	NO
2858	3067	60	NO
2859	3067	92	NO
2860	3067	58	NO
2861	3067	87	YES
2862	3067	88	YES
2863	3067	89	YES
2864	3068	46	YES
2865	3068	49	NO
2866	3068	50	NO
2867	3068	51	YES
2868	3068	52	NO
2869	3068	53	YES
2870	3068	54	YES
2871	3068	55	YES
2872	3068	56	YES
2873	3068	57	YES
2874	3068	90	NO
2875	3068	91	YES
2876	3068	60	NO
2877	3068	92	YES
2878	3068	58	YES
2879	3068	87	YES
2880	3068	88	YES
2881	3068	89	YES
2882	3069	46	YES
2883	3069	49	YES
2884	3069	50	NO
2885	3069	51	YES
2886	3069	52	NO
2887	3069	53	YES
2888	3069	54	YES
2889	3069	55	YES
2890	3069	56	YES
2891	3069	57	YES
2892	3069	90	NO
2893	3069	91	YES
2894	3069	60	NO
2895	3069	92	YES
2896	3069	58	YES
2897	3069	87	YES
2898	3069	88	YES
2899	3069	89	YES
2900	3070	46	YES
2901	3070	49	YES
2902	3070	50	YES
2903	3070	51	YES
2904	3070	52	NO
2905	3070	53	YES
2906	3070	54	NO
2907	3070	55	YES
2908	3070	56	YES
2909	3070	57	YES
2910	3070	90	NO
2911	3070	91	NO
2912	3070	60	YES
2913	3070	92	NO
2914	3070	58	YES
2915	3070	87	NO
2916	3070	88	NO
2917	3070	89	YES
2918	3071	46	YES
2919	3071	49	YES
2920	3071	50	YES
2921	3071	51	YES
2922	3071	52	NO
2923	3071	53	YES
2924	3071	54	YES
2925	3071	55	YES
2926	3071	56	YES
2927	3071	57	YES
2928	3071	90	NO
2929	3071	91	YES
2930	3071	60	NO
2931	3071	92	NO
2932	3071	58	YES
2933	3071	87	YES
2934	3071	88	YES
2935	3071	89	YES
2936	3072	46	YES
2937	3072	49	YES
2938	3072	50	YES
2939	3072	51	YES
2940	3072	52	NO
2941	3072	53	YES
2942	3072	54	YES
2943	3072	55	YES
2944	3072	56	YES
2945	3072	57	YES
2946	3072	90	NO
2947	3072	91	NO
2948	3072	60	NO
2949	3072	92	NO
2950	3072	58	NO
2951	3072	87	YES
2952	3072	88	NO
2953	3072	89	YES
2954	3073	46	YES
2955	3073	49	NO
2956	3073	50	NO
2957	3073	51	NO
2958	3073	52	NO
2959	3073	53	YES
2960	3073	54	NO
2961	3073	55	YES
2962	3073	56	YES
2963	3073	57	YES
2964	3073	90	NO
2965	3073	91	YES
2966	3073	60	NO
2967	3073	92	YES
2968	3073	58	YES
2969	3073	87	YES
2970	3073	88	NO
2971	3073	89	YES
2972	3074	46	YES
2973	3074	49	YES
2974	3074	50	NO
2975	3074	51	NO
2976	3074	52	YES
2977	3074	53	YES
2978	3074	54	NO
2979	3074	55	YES
2980	3074	56	YES
2981	3074	57	YES
2982	3074	90	NO
2983	3074	91	YES
2984	3074	60	NO
2985	3074	92	NO
2986	3074	58	YES
2987	3074	87	YES
2988	3074	88	YES
2989	3074	89	YES
2990	3075	46	NO
2991	3075	49	NO
2992	3075	50	NO
2993	3075	51	NO
2994	3075	52	NO
2995	3075	53	YES
2996	3075	54	NO
2997	3075	55	YES
2998	3075	56	YES
2999	3075	57	YES
3000	3075	90	NO
3001	3075	91	YES
3002	3075	60	NO
3003	3075	92	NO
3004	3075	58	YES
3005	3075	87	NO
3006	3075	88	NO
3007	3075	89	YES
3008	3076	46	YES
3009	3076	49	YES
3010	3076	50	YES
3011	3076	51	YES
3012	3076	52	NO
3013	3076	53	YES
3014	3076	54	YES
3015	3076	55	YES
3016	3076	56	YES
3017	3076	57	YES
3018	3076	90	NO
3019	3076	91	NO
3020	3076	60	NO
3021	3076	92	NO
3022	3076	58	NO
3023	3076	87	YES
3024	3076	88	NO
3025	3076	89	YES
3026	3057	46	YES
3027	3057	49	NO
3028	3057	50	YES
3029	3057	51	YES
3030	3057	52	NO
3031	3057	53	YES
3032	3057	54	YES
3033	3057	55	YES
3034	3057	56	YES
3035	3057	57	YES
3036	3057	90	NO
3037	3057	91	YES
3038	3057	60	NO
3039	3057	92	YES
3040	3057	58	YES
3041	3057	87	NO
3042	3057	88	NO
3043	3057	89	YES
3044	3060	46	YES
3045	3060	49	YES
3046	3060	50	NO
3047	3060	51	NO
3048	3060	52	NO
3049	3060	53	YES
3050	3060	54	YES
3051	3060	55	YES
3052	3060	56	YES
3053	3060	57	NO
3054	3060	90	NO
3055	3060	91	YES
3056	3060	60	NO
3057	3060	92	YES
3058	3060	58	YES
3059	3060	87	YES
3060	3060	88	YES
3061	3060	89	YES
3062	3077	46	YES
3063	3077	49	YES
3064	3077	50	YES
3065	3077	51	YES
3066	3077	52	NO
3067	3077	53	YES
3068	3077	54	YES
3069	3077	55	YES
3070	3077	56	YES
3071	3077	57	YES
3072	3077	90	NO
3073	3077	91	YES
3074	3077	60	NO
3075	3077	92	YES
3076	3077	58	YES
3077	3077	87	YES
3078	3077	88	YES
3079	3077	89	YES
3080	3078	46	YES
3081	3078	49	YES
3082	3078	50	YES
3083	3078	51	YES
3084	3078	52	NO
3085	3078	53	YES
3086	3078	54	YES
3087	3078	55	YES
3088	3078	56	YES
3089	3078	57	YES
3090	3078	90	NO
3091	3078	91	YES
3092	3078	60	NO
3093	3078	92	YES
3094	3078	58	YES
3095	3078	87	YES
3096	3078	88	YES
3097	3078	89	YES
3098	3079	46	YES
3099	3079	49	YES
3100	3079	50	NO
3101	3079	51	YES
3102	3079	52	NO
3103	3079	53	YES
3104	3079	54	NO
3105	3079	55	YES
3106	3079	56	YES
3107	3079	57	NO
3108	3079	90	NO
3109	3079	91	YES
3110	3079	60	YES
3111	3079	92	YES
3112	3079	58	YES
3113	3079	87	YES
3114	3079	88	NO
3115	3079	89	NO
3116	3080	46	YES
3117	3080	49	NO
3118	3080	50	NO
3119	3080	51	YES
3120	3080	52	YES
3121	3080	53	YES
3122	3080	54	YES
3123	3080	55	YES
3124	3080	56	YES
3125	3080	57	YES
3126	3080	90	YES
3127	3080	91	YES
3128	3080	60	NO
3129	3080	92	NO
3130	3080	58	YES
3131	3080	87	YES
3132	3080	88	YES
3133	3080	89	YES
3134	3081	46	YES
3135	3081	49	NO
3136	3081	50	NO
3137	3081	51	NO
3138	3081	52	NO
3139	3081	53	YES
3140	3081	54	NO
3141	3081	55	YES
3142	3081	56	YES
3143	3081	57	NO
3144	3081	90	NO
3145	3081	91	NO
3146	3081	60	YES
3147	3081	92	NO
3148	3081	58	NO
3149	3081	87	YES
3150	3081	88	YES
3151	3081	89	YES
3152	3082	46	YES
3153	3082	49	YES
3154	3082	50	NO
3155	3082	51	NO
3156	3082	52	NO
3157	3082	53	YES
3158	3082	54	YES
3159	3082	55	YES
3160	3082	56	YES
3161	3082	57	YES
3162	3082	90	NO
3163	3082	91	YES
3164	3082	60	NO
3165	3082	92	YES
3166	3082	58	YES
3167	3082	87	NO
3168	3082	88	NO
3169	3082	89	YES
3170	3083	46	YES
3171	3083	49	YES
3172	3083	50	YES
3173	3083	51	NO
3174	3083	52	NO
3175	3083	53	YES
3176	3083	54	YES
3177	3083	55	YES
3178	3083	56	YES
3179	3083	57	YES
3180	3083	90	NO
3181	3083	91	NO
3182	3083	60	NO
3183	3083	92	NO
3184	3083	58	NO
3185	3083	87	YES
3186	3083	88	YES
3187	3083	89	YES
3188	3113	46	YES
3189	3113	49	YES
3190	3113	50	YES
3191	3113	51	YES
3192	3113	52	YES
3193	3113	53	YES
3194	3113	54	YES
3195	3113	55	YES
3196	3113	56	YES
3197	3113	57	YES
3198	3113	90	NO
3199	3113	91	YES
3200	3113	60	NO
3201	3113	92	YES
3202	3113	58	YES
3203	3113	87	YES
3204	3113	88	YES
3205	3113	89	YES
3206	3114	46	YES
3207	3114	49	YES
3208	3114	50	YES
3209	3114	51	YES
3210	3114	52	NO
3211	3114	53	YES
3212	3114	54	YES
3213	3114	55	YES
3214	3114	56	YES
3215	3114	57	YES
3216	3114	90	NO
3217	3114	91	YES
3218	3114	60	NO
3219	3114	92	YES
3220	3114	58	YES
3221	3114	87	YES
3222	3114	88	YES
3223	3114	89	YES
3224	3115	46	YES
3225	3115	49	YES
3226	3115	50	NO
3227	3115	51	YES
3228	3115	52	NO
3229	3115	53	YES
3230	3115	54	YES
3231	3115	55	YES
3232	3115	56	YES
3233	3115	57	YES
3234	3115	90	NO
3235	3115	91	YES
3236	3115	60	NO
3237	3115	92	YES
3238	3115	58	YES
3239	3115	87	YES
3240	3115	88	YES
3241	3115	89	YES
3242	3116	46	YES
3243	3116	49	YES
3244	3116	50	NO
3245	3116	51	YES
3246	3116	52	NO
3247	3116	53	YES
3248	3116	54	YES
3249	3116	55	YES
3250	3116	56	YES
3251	3116	57	YES
3252	3116	90	NO
3253	3116	91	YES
3254	3116	60	NO
3255	3116	92	YES
3256	3116	58	YES
3257	3116	87	YES
3258	3116	88	YES
3259	3116	89	YES
3260	3117	46	YES
3261	3117	49	YES
3262	3117	50	YES
3263	3117	51	YES
3264	3117	52	YES
3265	3117	53	YES
3266	3117	54	YES
3267	3117	55	YES
3268	3117	56	YES
3269	3117	57	YES
3270	3117	90	NO
3271	3117	91	YES
3272	3117	60	NO
3273	3117	92	YES
3274	3117	58	YES
3275	3117	87	YES
3276	3117	88	YES
3277	3117	89	YES
3278	3118	46	YES
3279	3118	49	YES
3280	3118	50	YES
3281	3118	51	YES
3282	3118	52	NO
3283	3118	53	YES
3284	3118	54	YES
3285	3118	55	YES
3286	3118	56	YES
3287	3118	57	YES
3288	3118	90	NO
3289	3118	91	YES
3290	3118	60	NO
3291	3118	92	YES
3292	3118	58	YES
3293	3118	87	YES
3294	3118	88	YES
3295	3118	89	YES
3296	3119	46	YES
3297	3119	49	YES
3298	3119	50	YES
3299	3119	51	YES
3300	3119	52	YES
3301	3119	53	YES
3302	3119	54	YES
3303	3119	55	YES
3304	3119	56	YES
3305	3119	57	YES
3306	3119	90	YES
3307	3119	91	YES
3308	3119	60	NO
3309	3119	92	YES
3310	3119	58	YES
3311	3119	87	YES
3312	3119	88	YES
3313	3119	89	YES
3314	3120	46	YES
3315	3120	49	YES
3316	3120	50	YES
3317	3120	51	YES
3318	3120	52	YES
3319	3120	53	NO
3320	3120	54	YES
3321	3120	55	YES
3322	3120	56	YES
3323	3120	57	YES
3324	3120	90	NO
3325	3120	91	YES
3326	3120	60	NO
3327	3120	92	YES
3328	3120	58	YES
3329	3120	87	YES
3330	3120	88	YES
3331	3120	89	YES
3332	3121	46	YES
3333	3121	49	NO
3334	3121	50	NO
3335	3121	51	YES
3336	3121	52	NO
3337	3121	53	YES
3338	3121	54	YES
3339	3121	55	YES
3340	3121	56	YES
3341	3121	57	YES
3342	3121	90	NO
3343	3121	91	YES
3344	3121	60	NO
3345	3121	92	YES
3346	3121	58	YES
3347	3121	87	YES
3348	3121	88	YES
3349	3121	89	YES
3350	3122	46	YES
3351	3122	49	YES
3352	3122	50	NO
3353	3122	51	YES
3354	3122	52	NO
3355	3122	53	YES
3356	3122	54	YES
3357	3122	55	YES
3358	3122	56	YES
3359	3122	57	NO
3360	3122	90	NO
3361	3122	91	YES
3362	3122	60	NO
3363	3122	92	YES
3364	3122	58	YES
3365	3122	87	YES
3366	3122	88	YES
3367	3122	89	YES
3368	3123	46	NO
3369	3123	49	YES
3370	3123	50	YES
3371	3123	51	YES
3372	3123	52	NO
3373	3123	53	YES
3374	3123	54	YES
3375	3123	55	YES
3376	3123	56	YES
3377	3123	57	YES
3378	3123	90	NO
3379	3123	91	YES
3380	3123	60	NO
3381	3123	92	YES
3382	3123	58	YES
3383	3123	87	YES
3384	3123	88	YES
3385	3123	89	YES
3386	3124	46	YES
3387	3124	49	YES
3388	3124	50	YES
3389	3124	51	YES
3390	3124	52	NO
3391	3124	53	YES
3392	3124	54	YES
3393	3124	55	YES
3394	3124	56	YES
3395	3124	57	YES
3396	3124	90	NO
3397	3124	91	YES
3398	3124	60	NO
3399	3124	92	YES
3400	3124	58	YES
3401	3124	87	YES
3402	3124	88	YES
3403	3124	89	YES
3404	3125	46	YES
3405	3125	49	YES
3406	3125	50	YES
3407	3125	51	YES
3408	3125	52	NO
3409	3125	53	YES
3410	3125	54	YES
3411	3125	55	YES
3412	3125	56	YES
3413	3125	57	YES
3414	3125	90	NO
3415	3125	91	YES
3416	3125	60	NO
3417	3125	92	YES
3418	3125	58	YES
3419	3125	87	YES
3420	3125	88	YES
3421	3125	89	YES
3422	3126	46	YES
3423	3126	49	YES
3424	3126	50	YES
3425	3126	51	YES
3426	3126	52	NO
3427	3126	53	YES
3428	3126	54	YES
3429	3126	55	YES
3430	3126	56	YES
3431	3126	57	YES
3432	3126	90	NO
3433	3126	91	YES
3434	3126	60	NO
3435	3126	92	YES
3436	3126	58	YES
3437	3126	87	YES
3438	3126	88	YES
3439	3126	89	YES
3440	3127	46	YES
3441	3127	49	YES
3442	3127	50	NO
3443	3127	51	YES
3444	3127	52	NO
3445	3127	53	YES
3446	3127	54	YES
3447	3127	55	YES
3448	3127	56	YES
3449	3127	57	YES
3450	3127	90	YES
3451	3127	91	YES
3452	3127	60	NO
3453	3127	92	YES
3454	3127	58	YES
3455	3127	87	YES
3456	3127	88	YES
3457	3127	89	YES
3458	3128	46	YES
3459	3128	49	NO
3460	3128	50	YES
3461	3128	51	NO
3462	3128	52	NO
3463	3128	53	YES
3464	3128	54	YES
3465	3128	55	YES
3466	3128	56	YES
3467	3128	57	YES
3468	3128	90	YES
3469	3128	91	YES
3470	3128	60	NO
3471	3128	92	YES
3472	3128	58	YES
3473	3128	87	YES
3474	3128	88	YES
3475	3128	89	YES
3476	3129	46	YES
3477	3129	49	YES
3478	3129	50	YES
3479	3129	51	YES
3480	3129	52	YES
3481	3129	53	YES
3482	3129	54	YES
3483	3129	55	YES
3484	3129	56	YES
3485	3129	57	YES
3486	3129	90	YES
3487	3129	91	YES
3488	3129	60	NO
3489	3129	92	YES
3490	3129	58	YES
3491	3129	87	YES
3492	3129	88	YES
3493	3129	89	YES
3494	3130	46	YES
3495	3130	49	NO
3496	3130	50	NO
3497	3130	51	YES
3498	3130	52	NO
3499	3130	53	YES
3500	3130	54	NO
3501	3130	55	YES
3502	3130	56	YES
3503	3130	57	YES
3504	3130	90	NO
3505	3130	91	YES
3506	3130	60	NO
3507	3130	92	YES
3508	3130	58	YES
3509	3130	87	YES
3510	3130	88	YES
3511	3130	89	YES
3512	3131	46	YES
3513	3131	49	NO
3514	3131	50	NO
3515	3131	51	NO
3516	3131	52	NO
3517	3131	53	YES
3518	3131	54	NO
3519	3131	55	YES
3520	3131	56	YES
3521	3131	57	YES
3522	3131	90	YES
3523	3131	91	YES
3524	3131	60	YES
3525	3131	92	YES
3526	3131	58	YES
3527	3131	87	YES
3528	3131	88	YES
3529	3131	89	YES
3530	3132	46	YES
3531	3132	49	YES
3532	3132	50	NO
3533	3132	51	YES
3534	3132	52	NO
3535	3132	53	YES
3536	3132	54	YES
3537	3132	55	YES
3538	3132	56	YES
3539	3132	57	NO
3540	3132	90	NO
3541	3132	91	YES
3542	3132	60	YES
3543	3132	92	YES
3544	3132	58	YES
3545	3132	87	YES
3546	3132	88	YES
3547	3132	89	YES
3548	3133	46	YES
3549	3133	49	YES
3550	3133	50	NO
3551	3133	51	YES
3552	3133	52	NO
3553	3133	53	YES
3554	3133	54	YES
3555	3133	55	YES
3556	3133	56	YES
3557	3133	57	YES
3558	3133	90	NO
3559	3133	91	YES
3560	3133	60	NO
3561	3133	92	YES
3562	3133	58	NO
3563	3133	87	YES
3564	3133	88	YES
3565	3133	89	YES
3566	3134	46	YES
3567	3134	49	YES
3568	3134	50	YES
3569	3134	51	YES
3570	3134	52	YES
3571	3134	53	YES
3572	3134	54	YES
3573	3134	55	YES
3574	3134	56	YES
3575	3134	57	YES
3576	3134	90	NO
3577	3134	91	YES
3578	3134	60	NO
3579	3134	92	YES
3580	3134	58	YES
3581	3134	87	YES
3582	3134	88	YES
3583	3134	89	YES
3584	3135	46	YES
3585	3135	49	YES
3586	3135	50	YES
3587	3135	51	YES
3588	3135	52	YES
3589	3135	53	YES
3590	3135	54	YES
3591	3135	55	YES
3592	3135	56	YES
3593	3135	57	YES
3594	3135	90	YES
3595	3135	91	YES
3596	3135	60	NO
3597	3135	92	YES
3598	3135	58	YES
3599	3135	87	YES
3600	3135	88	YES
3601	3135	89	YES
3602	3136	46	YES
3603	3136	49	YES
3604	3136	50	YES
3605	3136	51	NO
3606	3136	52	NO
3607	3136	53	YES
3608	3136	54	YES
3609	3136	55	YES
3610	3136	56	YES
3611	3136	57	YES
3612	3136	90	YES
3613	3136	91	YES
3614	3136	60	NO
3615	3136	92	YES
3616	3136	58	YES
3617	3136	87	YES
3618	3136	88	YES
3619	3136	89	YES
3620	3137	46	YES
3621	3137	49	YES
3622	3137	50	NO
3623	3137	51	YES
3624	3137	52	NO
3625	3137	53	YES
3626	3137	54	YES
3627	3137	55	YES
3628	3137	56	YES
3629	3137	57	YES
3630	3137	90	NO
3631	3137	91	YES
3632	3137	60	NO
3633	3137	92	YES
3634	3137	58	YES
3635	3137	87	YES
3636	3137	88	YES
3637	3137	89	YES
3638	3138	46	YES
3639	3138	49	YES
3640	3138	50	NO
3641	3138	51	YES
3642	3138	52	NO
3643	3138	53	YES
3644	3138	54	YES
3645	3138	55	YES
3646	3138	56	YES
3647	3138	57	NO
3648	3138	90	NO
3649	3138	91	YES
3650	3138	60	YES
3651	3138	92	NO
3652	3138	58	YES
3653	3138	87	YES
3654	3138	88	YES
3655	3138	89	YES
3656	3139	46	YES
3657	3139	49	YES
3658	3139	50	NO
3659	3139	51	YES
3660	3139	52	NO
3661	3139	53	YES
3662	3139	54	YES
3663	3139	55	YES
3664	3139	56	YES
3665	3139	57	NO
3666	3139	90	NO
3667	3139	91	YES
3668	3139	60	YES
3669	3139	92	YES
3670	3139	58	YES
3671	3139	87	YES
3672	3139	88	YES
3673	3139	89	YES
3674	3140	46	NO
3675	3140	49	NO
3676	3140	50	NO
3677	3140	51	YES
3678	3140	52	NO
3679	3140	53	YES
3680	3140	54	YES
3681	3140	55	YES
3682	3140	56	YES
3683	3140	57	YES
3684	3140	90	NO
3685	3140	91	YES
3686	3140	60	NO
3687	3140	92	YES
3688	3140	58	YES
3689	3140	87	YES
3690	3140	88	YES
3691	3140	89	YES
3692	3141	46	YES
3693	3141	49	YES
3694	3141	50	NO
3695	3141	51	YES
3696	3141	52	NO
3697	3141	53	YES
3698	3141	54	YES
3699	3141	55	YES
3700	3141	56	YES
3701	3141	57	YES
3702	3141	90	NO
3703	3141	91	YES
3704	3141	60	YES
3705	3141	92	NO
3706	3141	58	YES
3707	3141	87	YES
3708	3141	88	YES
3709	3141	89	YES
3710	3142	46	YES
3711	3142	49	YES
3712	3142	50	NO
3713	3142	51	YES
3714	3142	52	NO
3715	3142	53	YES
3716	3142	54	YES
3717	3142	55	NO
3718	3142	56	YES
3719	3142	57	NO
3720	3142	90	NO
3721	3142	91	YES
3722	3142	60	NO
3723	3142	92	YES
3724	3142	58	YES
3725	3142	87	YES
3726	3142	88	YES
3727	3142	89	YES
3728	3143	46	YES
3729	3143	49	YES
3730	3143	50	NO
3731	3143	51	YES
3732	3143	52	YES
3733	3143	53	YES
3734	3143	54	YES
3735	3143	55	YES
3736	3143	56	YES
3737	3143	57	YES
3738	3143	90	YES
3739	3143	91	YES
3740	3143	60	NO
3741	3143	92	NO
3742	3143	58	NO
3743	3143	87	YES
3744	3143	88	YES
3745	3143	89	YES
3746	3144	46	YES
3747	3144	49	YES
3748	3144	50	NO
3749	3144	51	NO
3750	3144	52	NO
3751	3144	53	YES
3752	3144	54	YES
3753	3144	55	YES
3754	3144	56	YES
3755	3144	57	NO
3756	3144	90	NO
3757	3144	91	YES
3758	3144	60	YES
3759	3144	92	YES
3760	3144	58	YES
3761	3144	87	YES
3762	3144	88	YES
3763	3144	89	YES
3764	3145	46	YES
3765	3145	49	YES
3766	3145	50	YES
3767	3145	51	YES
3768	3145	52	YES
3769	3145	53	YES
3770	3145	54	YES
3771	3145	55	YES
3772	3145	56	YES
3773	3145	57	NO
3774	3145	90	YES
3775	3145	91	YES
3776	3145	60	NO
3777	3145	92	YES
3778	3145	58	YES
3779	3145	87	YES
3780	3145	88	YES
3781	3145	89	YES
3782	3146	46	YES
3783	3146	49	YES
3784	3146	50	YES
3785	3146	51	YES
3786	3146	52	YES
3787	3146	53	YES
3788	3146	54	YES
3789	3146	55	YES
3790	3146	56	YES
3791	3146	57	YES
3792	3146	90	NO
3793	3146	91	YES
3794	3146	60	NO
3795	3146	92	YES
3796	3146	58	YES
3797	3146	87	YES
3798	3146	88	YES
3799	3146	89	YES
3800	3147	46	YES
3801	3147	49	YES
3802	3147	50	YES
3803	3147	51	YES
3804	3147	52	NO
3805	3147	53	NO
3806	3147	54	YES
3807	3147	55	YES
3808	3147	56	YES
3809	3147	57	YES
3810	3147	90	NO
3811	3147	91	YES
3812	3147	60	NO
3813	3147	92	YES
3814	3147	58	YES
3815	3147	87	YES
3816	3147	88	YES
3817	3147	89	YES
3818	3148	46	YES
3819	3148	49	YES
3820	3148	50	YES
3821	3148	51	YES
3822	3148	52	NO
3823	3148	53	YES
3824	3148	54	YES
3825	3148	55	YES
3826	3148	56	YES
3827	3148	57	YES
3828	3148	90	NO
3829	3148	91	YES
3830	3148	60	NO
3831	3148	92	YES
3832	3148	58	YES
3833	3148	87	YES
3834	3148	88	YES
3835	3148	89	YES
3836	3149	46	YES
3837	3149	49	YES
3838	3149	50	YES
3839	3149	51	YES
3840	3149	52	NO
3841	3149	53	YES
3842	3149	54	YES
3843	3149	55	YES
3844	3149	56	YES
3845	3149	57	NO
3846	3149	90	NO
3847	3149	91	YES
3848	3149	60	NO
3849	3149	92	YES
3850	3149	58	YES
3851	3149	87	YES
3852	3149	88	YES
3853	3149	89	YES
3854	3150	46	YES
3855	3150	49	NO
3856	3150	50	NO
3857	3150	51	NO
3858	3150	52	NO
3859	3150	53	YES
3860	3150	54	YES
3861	3150	55	YES
3862	3150	56	YES
3863	3150	57	YES
3864	3150	90	NO
3865	3150	91	YES
3866	3150	60	YES
3867	3150	92	YES
3868	3150	58	YES
3869	3150	87	YES
3870	3150	88	YES
3871	3150	89	YES
3872	3151	46	YES
3873	3151	49	YES
3874	3151	50	NO
3875	3151	51	YES
3876	3151	52	NO
3877	3151	53	YES
3878	3151	54	YES
3879	3151	55	YES
3880	3151	56	YES
3881	3151	57	YES
3882	3151	90	NO
3883	3151	91	YES
3884	3151	60	NO
3885	3151	92	YES
3886	3151	58	YES
3887	3151	87	YES
3888	3151	88	YES
3889	3151	89	YES
3890	3152	46	YES
3891	3152	49	YES
3892	3152	50	YES
3893	3152	51	YES
3894	3152	52	NO
3895	3152	53	YES
3896	3152	54	YES
3897	3152	55	YES
3898	3152	56	YES
3899	3152	57	YES
3900	3152	90	NO
3901	3152	91	YES
3902	3152	60	NO
3903	3152	92	YES
3904	3152	58	YES
3905	3152	87	YES
3906	3152	88	YES
3907	3152	89	YES
3908	3153	46	YES
3909	3153	49	YES
3910	3153	50	NO
3911	3153	51	YES
3912	3153	52	NO
3913	3153	53	YES
3914	3153	54	YES
3915	3153	55	YES
3916	3153	56	YES
3917	3153	57	YES
3918	3153	90	NO
3919	3153	91	YES
3920	3153	60	NO
3921	3153	92	YES
3922	3153	58	YES
3923	3153	87	YES
3924	3153	88	YES
3925	3153	89	YES
3926	3154	46	NO
3927	3154	49	YES
3928	3154	50	NO
3929	3154	51	NO
3930	3154	52	NO
3931	3154	53	YES
3932	3154	54	YES
3933	3154	55	YES
3934	3154	56	YES
3935	3154	57	YES
3936	3154	90	NO
3937	3154	91	YES
3938	3154	60	NO
3939	3154	92	NO
3940	3154	58	YES
3941	3154	87	YES
3942	3154	88	NO
3943	3154	89	YES
3944	3155	46	YES
3945	3155	49	YES
3946	3155	50	NO
3947	3155	51	YES
3948	3155	52	NO
3949	3155	53	YES
3950	3155	54	YES
3951	3155	55	YES
3952	3155	56	YES
3953	3155	57	YES
3954	3155	90	NO
3955	3155	91	YES
3956	3155	60	NO
3957	3155	92	NO
3958	3155	58	YES
3959	3155	87	YES
3960	3155	88	NO
3961	3155	89	YES
3962	3156	46	YES
3963	3156	49	YES
3964	3156	50	NO
3965	3156	51	NO
3966	3156	52	NO
3967	3156	53	YES
3968	3156	54	YES
3969	3156	55	YES
3970	3156	56	YES
3971	3156	57	YES
3972	3156	90	NO
3973	3156	91	YES
3974	3156	60	NO
3975	3156	92	NO
3976	3156	58	YES
3977	3156	87	YES
3978	3156	88	NO
3979	3156	89	YES
3980	3157	46	YES
3981	3157	49	YES
3982	3157	50	YES
3983	3157	51	YES
3984	3157	52	NO
3985	3157	53	YES
3986	3157	54	YES
3987	3157	55	YES
3988	3157	56	YES
3989	3157	57	YES
3990	3157	90	NO
3991	3157	91	YES
3992	3157	60	NO
3993	3157	92	YES
3994	3157	58	YES
3995	3157	87	YES
3996	3157	88	NO
3997	3157	89	YES
3998	3158	46	NO
3999	3158	49	YES
4000	3158	50	YES
4001	3158	51	YES
4002	3158	52	YES
4003	3158	53	YES
4004	3158	54	YES
4005	3158	55	YES
4006	3158	56	YES
4007	3158	57	YES
4008	3158	90	YES
4009	3158	91	YES
4010	3158	60	NO
4011	3158	92	YES
4012	3158	58	YES
4013	3158	87	YES
4014	3158	88	NO
4015	3158	89	YES
4016	3159	46	YES
4017	3159	49	NO
4018	3159	50	NO
4019	3159	51	NO
4020	3159	52	NO
4021	3159	53	YES
4022	3159	54	YES
4023	3159	55	YES
4024	3159	56	YES
4025	3159	57	YES
4026	3159	90	NO
4027	3159	91	YES
4028	3159	60	YES
4029	3159	92	YES
4030	3159	58	YES
4031	3159	87	YES
4032	3159	88	NO
4033	3159	89	YES
4034	3161	46	YES
4035	3161	49	YES
4036	3161	50	YES
4037	3161	51	YES
4038	3161	52	YES
4039	3161	53	YES
4040	3161	54	YES
4041	3161	55	YES
4042	3161	56	YES
4043	3161	57	YES
4044	3161	90	YES
4045	3161	91	YES
4046	3161	60	NO
4047	3161	92	YES
4048	3161	58	YES
4049	3161	87	YES
4050	3161	88	NO
4051	3161	89	YES
4052	3162	46	YES
4053	3162	49	NO
4054	3162	50	NO
4055	3162	51	NO
4056	3162	52	NO
4057	3162	53	YES
4058	3162	54	YES
4059	3162	55	NO
4060	3162	56	YES
4061	3162	57	YES
4062	3162	90	NO
4063	3162	91	YES
4064	3162	60	YES
4065	3162	92	YES
4066	3162	58	YES
4067	3162	87	YES
4068	3162	88	NO
4069	3162	89	YES
4070	3163	46	YES
4071	3163	49	YES
4072	3163	50	YES
4073	3163	51	YES
4074	3163	52	NO
4075	3163	53	YES
4076	3163	54	YES
4077	3163	55	YES
4078	3163	56	YES
4079	3163	57	YES
4080	3163	90	YES
4081	3163	91	YES
4082	3163	60	YES
4083	3163	92	YES
4084	3163	58	YES
4085	3163	87	YES
4086	3163	88	NO
4087	3163	89	YES
4088	3164	46	YES
4089	3164	49	YES
4090	3164	50	NO
4091	3164	51	YES
4092	3164	52	NO
4093	3164	53	NO
4094	3164	54	YES
4095	3164	55	YES
4096	3164	56	YES
4097	3164	57	YES
4098	3164	90	NO
4099	3164	91	YES
4100	3164	60	YES
4101	3164	92	YES
4102	3164	58	YES
4103	3164	87	YES
4104	3164	88	NO
4105	3164	89	YES
4106	3165	46	NO
4107	3165	49	YES
4108	3165	50	YES
4109	3165	51	NO
4110	3165	52	YES
4111	3165	53	YES
4112	3165	54	YES
4113	3165	55	YES
4114	3165	56	YES
4115	3165	57	YES
4116	3165	90	YES
4117	3165	91	YES
4118	3165	60	NO
4119	3165	92	YES
4120	3165	58	YES
4121	3165	87	YES
4122	3165	88	NO
4123	3165	89	YES
4124	3166	46	YES
4125	3166	49	YES
4126	3166	50	NO
4127	3166	51	YES
4128	3166	52	NO
4129	3166	53	YES
4130	3166	54	YES
4131	3166	55	YES
4132	3166	56	YES
4133	3166	57	YES
4134	3166	90	NO
4135	3166	91	YES
4136	3166	60	NO
4137	3166	92	YES
4138	3166	58	YES
4139	3166	87	YES
4140	3166	88	NO
4141	3166	89	YES
4142	3167	46	NO
4143	3167	49	YES
4144	3167	50	YES
4145	3167	51	YES
4146	3167	52	YES
4147	3167	53	YES
4148	3167	54	YES
4149	3167	55	YES
4150	3167	56	YES
4151	3167	57	YES
4152	3167	90	YES
4153	3167	91	YES
4154	3167	60	NO
4155	3167	92	YES
4156	3167	58	YES
4157	3167	87	YES
4158	3167	88	NO
4159	3167	89	YES
4160	3168	46	NO
4161	3168	49	NO
4162	3168	50	NO
4163	3168	51	NO
4164	3168	52	NO
4165	3168	53	YES
4166	3168	54	NO
4167	3168	55	YES
4168	3168	56	YES
4169	3168	57	YES
4170	3168	90	NO
4171	3168	91	YES
4172	3168	60	NO
4173	3168	92	YES
4174	3168	58	YES
4175	3168	87	YES
4176	3168	88	NO
4177	3168	89	YES
4178	3169	46	NO
4179	3169	49	YES
4180	3169	50	NO
4181	3169	51	NO
4182	3169	52	NO
4183	3169	53	YES
4184	3169	54	YES
4185	3169	55	YES
4186	3169	56	YES
4187	3169	57	YES
4188	3169	90	NO
4189	3169	91	YES
4190	3169	60	NO
4191	3169	92	YES
4192	3169	58	YES
4193	3169	87	YES
4194	3169	88	NO
4195	3169	89	YES
4196	3170	46	YES
4197	3170	49	NO
4198	3170	50	NO
4199	3170	51	NO
4200	3170	52	NO
4201	3170	53	YES
4202	3170	54	YES
4203	3170	55	YES
4204	3170	56	YES
4205	3170	57	YES
4206	3170	90	YES
4207	3170	91	YES
4208	3170	60	NO
4209	3170	92	YES
4210	3170	58	YES
4211	3170	87	YES
4212	3170	88	NO
4213	3170	89	YES
4214	3171	46	YES
4215	3171	49	YES
4216	3171	50	YES
4217	3171	51	YES
4218	3171	52	YES
4219	3171	53	YES
4220	3171	54	YES
4221	3171	55	YES
4222	3171	56	YES
4223	3171	57	YES
4224	3171	90	YES
4225	3171	91	YES
4226	3171	60	NO
4227	3171	92	YES
4228	3171	58	YES
4229	3171	87	YES
4230	3171	88	NO
4231	3171	89	YES
4232	3172	46	YES
4233	3172	49	YES
4234	3172	50	YES
4235	3172	51	YES
4236	3172	52	YES
4237	3172	53	YES
4238	3172	54	YES
4239	3172	55	YES
4240	3172	56	YES
4241	3172	57	YES
4242	3172	90	YES
4243	3172	91	YES
4244	3172	60	NO
4245	3172	92	YES
4246	3172	58	YES
4247	3172	87	YES
4248	3172	88	NO
4249	3172	89	YES
4250	3174	46	NO
4251	3174	49	NO
4252	3174	50	NO
4253	3174	51	NO
4254	3174	52	NO
4255	3174	53	YES
4256	3174	54	YES
4257	3174	55	YES
4258	3174	56	YES
4259	3174	57	YES
4260	3174	90	NO
4261	3174	91	YES
4262	3174	60	YES
4263	3174	92	YES
4264	3174	58	YES
4265	3174	87	YES
4266	3174	88	NO
4267	3174	89	YES
4268	3175	46	NO
4269	3175	49	YES
4270	3175	50	YES
4271	3175	51	YES
4272	3175	52	NO
4273	3175	53	YES
4274	3175	54	YES
4275	3175	55	YES
4276	3175	56	YES
4277	3175	57	YES
4278	3175	90	YES
4279	3175	91	YES
4280	3175	60	YES
4281	3175	92	YES
4282	3175	58	YES
4283	3175	87	YES
4284	3175	88	NO
4285	3175	89	YES
4286	3176	46	YES
4287	3176	49	YES
4288	3176	50	YES
4289	3176	51	YES
4290	3176	52	YES
4291	3176	53	YES
4292	3176	54	YES
4293	3176	55	YES
4294	3176	56	YES
4295	3176	57	YES
4296	3176	90	YES
4297	3176	91	YES
4298	3176	60	NO
4299	3176	92	YES
4300	3176	58	YES
4301	3176	87	YES
4302	3176	88	NO
4303	3176	89	YES
4304	3177	46	YES
4305	3177	49	NO
4306	3177	50	YES
4307	3177	51	NO
4308	3177	52	NO
4309	3177	53	YES
4310	3177	54	YES
4311	3177	55	YES
4312	3177	56	YES
4313	3177	57	YES
4314	3177	90	NO
4315	3177	91	YES
4316	3177	60	YES
4317	3177	92	YES
4318	3177	58	YES
4319	3177	87	YES
4320	3177	88	NO
4321	3177	89	YES
4322	3178	46	NO
4323	3178	49	YES
4324	3178	50	NO
4325	3178	51	YES
4326	3178	52	NO
4327	3178	53	YES
4328	3178	54	YES
4329	3178	55	YES
4330	3178	56	YES
4331	3178	57	YES
4332	3178	90	YES
4333	3178	91	YES
4334	3178	60	NO
4335	3178	92	YES
4336	3178	58	YES
4337	3178	87	YES
4338	3178	88	NO
4339	3178	89	YES
4340	3179	46	YES
4341	3179	49	YES
4342	3179	50	YES
4343	3179	51	YES
4344	3179	52	YES
4345	3179	53	YES
4346	3179	54	YES
4347	3179	55	YES
4348	3179	56	YES
4349	3179	57	YES
4350	3179	90	YES
4351	3179	91	YES
4352	3179	60	NO
4353	3179	92	YES
4354	3179	58	YES
4355	3179	87	YES
4356	3179	88	NO
4357	3179	89	YES
4358	3180	46	YES
4359	3180	49	NO
4360	3180	50	NO
4361	3180	51	NO
4362	3180	52	NO
4363	3180	53	YES
4364	3180	54	YES
4365	3180	55	YES
4366	3180	56	YES
4367	3180	57	YES
4368	3180	90	YES
4369	3180	91	YES
4370	3180	60	NO
4371	3180	92	YES
4372	3180	58	YES
4373	3180	87	YES
4374	3180	88	NO
4375	3180	89	YES
4376	3181	46	YES
4377	3181	49	YES
4378	3181	50	NO
4379	3181	51	NO
4380	3181	52	YES
4381	3181	53	YES
4382	3181	54	YES
4383	3181	55	YES
4384	3181	56	YES
4385	3181	57	YES
4386	3181	90	YES
4387	3181	91	YES
4388	3181	60	NO
4389	3181	92	YES
4390	3181	58	YES
4391	3181	87	YES
4392	3181	88	NO
4393	3181	89	YES
4394	3182	46	YES
4395	3182	49	YES
4396	3182	50	YES
4397	3182	51	YES
4398	3182	52	NO
4399	3182	53	YES
4400	3182	54	YES
4401	3182	55	YES
4402	3182	56	YES
4403	3182	57	YES
4404	3182	90	NO
4405	3182	91	YES
4406	3182	60	NO
4407	3182	92	NO
4408	3182	58	NO
4409	3182	87	YES
4410	3182	88	YES
4411	3182	89	YES
4412	3183	46	YES
4413	3183	49	YES
4414	3183	50	YES
4415	3183	51	YES
4416	3183	52	YES
4417	3183	53	YES
4418	3183	54	YES
4419	3183	55	YES
4420	3183	56	YES
4421	3183	57	YES
4422	3183	90	YES
4423	3183	91	YES
4424	3183	60	NO
4425	3183	92	NO
4426	3183	58	YES
4427	3183	87	YES
4428	3183	88	YES
4429	3183	89	YES
4430	3184	46	YES
4431	3184	49	YES
4432	3184	50	YES
4433	3184	51	YES
4434	3184	52	NO
4435	3184	53	YES
4436	3184	54	YES
4437	3184	55	YES
4438	3184	56	YES
4439	3184	57	YES
4440	3184	90	YES
4441	3184	91	YES
4442	3184	60	NO
4443	3184	92	YES
4444	3184	58	YES
4445	3184	87	YES
4446	3184	88	YES
4447	3184	89	YES
4448	3185	46	YES
4449	3185	49	YES
4450	3185	50	YES
4451	3185	51	YES
4452	3185	52	NO
4453	3185	53	YES
4454	3185	54	YES
4455	3185	55	YES
4456	3185	56	YES
4457	3185	57	YES
4458	3185	90	YES
4459	3185	91	YES
4460	3185	60	NO
4461	3185	92	YES
4462	3185	58	YES
4463	3185	87	YES
4464	3185	88	YES
4465	3185	89	YES
4466	3186	46	YES
4467	3186	49	YES
4468	3186	50	YES
4469	3186	51	YES
4470	3186	52	NO
4471	3186	53	YES
4472	3186	54	YES
4473	3186	55	YES
4474	3186	56	YES
4475	3186	57	YES
4476	3186	90	YES
4477	3186	91	YES
4478	3186	60	NO
4479	3186	92	YES
4480	3186	58	YES
4481	3186	87	YES
4482	3186	88	YES
4483	3186	89	YES
4484	3187	46	YES
4485	3187	49	YES
4486	3187	50	NO
4487	3187	51	YES
4488	3187	52	NO
4489	3187	53	YES
4490	3187	54	YES
4491	3187	55	NO
4492	3187	56	YES
4493	3187	57	YES
4494	3187	90	NO
4495	3187	91	YES
4496	3187	60	NO
4497	3187	92	YES
4498	3187	58	NO
4499	3187	87	YES
4500	3187	88	YES
4501	3187	89	YES
4502	3188	46	YES
4503	3188	49	NO
4504	3188	50	YES
4505	3188	51	YES
4506	3188	52	NO
4507	3188	53	YES
4508	3188	54	YES
4509	3188	55	YES
4510	3188	56	YES
4511	3188	57	YES
4512	3188	90	YES
4513	3188	91	YES
4514	3188	60	NO
4515	3188	92	YES
4516	3188	58	YES
4517	3188	87	YES
4518	3188	88	YES
4519	3188	89	YES
4520	3189	46	YES
4521	3189	49	YES
4522	3189	50	YES
4523	3189	51	NO
4524	3189	52	NO
4525	3189	53	YES
4526	3189	54	YES
4527	3189	55	YES
4528	3189	56	YES
4529	3189	57	YES
4530	3189	90	NO
4531	3189	91	NO
4532	3189	60	NO
4533	3189	92	YES
4534	3189	58	NO
4535	3189	87	YES
4536	3189	88	YES
4537	3189	89	YES
4538	3190	46	YES
4539	3190	49	YES
4540	3190	50	YES
4541	3190	51	YES
4542	3190	52	NO
4543	3190	53	YES
4544	3190	54	YES
4545	3190	55	YES
4546	3190	56	YES
4547	3190	57	YES
4548	3190	90	YES
4549	3190	91	YES
4550	3190	60	NO
4551	3190	92	NO
4552	3190	58	NO
4553	3190	87	YES
4554	3190	88	YES
4555	3190	89	YES
4556	3191	46	YES
4557	3191	49	YES
4558	3191	50	YES
4559	3191	51	YES
4560	3191	52	YES
4561	3191	53	YES
4562	3191	54	YES
4563	3191	55	YES
4564	3191	56	YES
4565	3191	57	YES
4566	3191	90	YES
4567	3191	91	YES
4568	3191	60	NO
4569	3191	92	YES
4570	3191	58	NO
4571	3191	87	YES
4572	3191	88	YES
4573	3191	89	YES
4574	3192	46	YES
4575	3192	49	YES
4576	3192	50	YES
4577	3192	51	YES
4578	3192	52	YES
4579	3192	53	YES
4580	3192	54	YES
4581	3192	55	YES
4582	3192	56	YES
4583	3192	57	YES
4584	3192	90	YES
4585	3192	91	YES
4586	3192	60	NO
4587	3192	92	YES
4588	3192	58	NO
4589	3192	87	YES
4590	3192	88	YES
4591	3192	89	YES
4592	3193	46	YES
4593	3193	49	YES
4594	3193	50	NO
4595	3193	51	YES
4596	3193	52	YES
4597	3193	53	YES
4598	3193	54	YES
4599	3193	55	YES
4600	3193	56	YES
4601	3193	57	YES
4602	3193	90	YES
4603	3193	91	YES
4604	3193	60	NO
4605	3193	92	YES
4606	3193	58	NO
4607	3193	87	YES
4608	3193	88	YES
4609	3193	89	YES
4610	3194	46	YES
4611	3194	49	YES
4612	3194	50	YES
4613	3194	51	YES
4614	3194	52	NO
4615	3194	53	YES
4616	3194	54	YES
4617	3194	55	YES
4618	3194	56	YES
4619	3194	57	YES
4620	3194	90	NO
4621	3194	91	YES
4622	3194	60	NO
4623	3194	92	YES
4624	3194	58	NO
4625	3194	87	YES
4626	3194	88	YES
4627	3194	89	YES
4628	3195	46	YES
4629	3195	49	YES
4630	3195	50	YES
4631	3195	51	YES
4632	3195	52	YES
4633	3195	53	YES
4634	3195	54	YES
4635	3195	55	YES
4636	3195	56	YES
4637	3195	57	YES
4638	3195	90	YES
4639	3195	91	YES
4640	3195	60	NO
4641	3195	92	YES
4642	3195	58	NO
4643	3195	87	YES
4644	3195	88	YES
4645	3195	89	YES
4646	3196	46	YES
4647	3196	49	YES
4648	3196	50	YES
4649	3196	51	YES
4650	3196	52	NO
4651	3196	53	YES
4652	3196	54	YES
4653	3196	55	YES
4654	3196	56	YES
4655	3196	57	YES
4656	3196	90	YES
4657	3196	91	YES
4658	3196	60	NO
4659	3196	92	YES
4660	3196	58	NO
4661	3196	87	YES
4662	3196	88	YES
4663	3196	89	YES
4664	3197	46	YES
4665	3197	49	YES
4666	3197	50	YES
4667	3197	51	NO
4668	3197	52	NO
4669	3197	53	NO
4670	3197	54	YES
4671	3197	55	YES
4672	3197	56	YES
4673	3197	57	YES
4674	3197	90	YES
4675	3197	91	YES
4676	3197	60	NO
4677	3197	92	YES
4678	3197	58	NO
4679	3197	87	YES
4680	3197	88	YES
4681	3197	89	YES
4682	3198	46	YES
4683	3198	49	NO
4684	3198	50	NO
4685	3198	51	NO
4686	3198	52	NO
4687	3198	53	YES
4688	3198	54	YES
4689	3198	55	YES
4690	3198	56	YES
4691	3198	57	YES
4692	3198	90	YES
4693	3198	91	YES
4694	3198	60	NO
4695	3198	92	YES
4696	3198	58	NO
4697	3198	87	YES
4698	3198	88	YES
4699	3198	89	YES
4700	3199	46	NO
4701	3199	49	NO
4702	3199	50	NO
4703	3199	51	YES
4704	3199	52	NO
4705	3199	53	YES
4706	3199	54	YES
4707	3199	55	YES
4708	3199	56	YES
4709	3199	57	YES
4710	3199	90	NO
4711	3199	91	YES
4712	3199	60	YES
4713	3199	92	YES
4714	3199	58	NO
4715	3199	87	YES
4716	3199	88	YES
4717	3199	89	YES
4718	3200	46	YES
4719	3200	49	YES
4720	3200	50	YES
4721	3200	51	YES
4722	3200	52	YES
4723	3200	53	YES
4724	3200	54	YES
4725	3200	55	YES
4726	3200	56	YES
4727	3200	57	YES
4728	3200	90	YES
4729	3200	91	NO
4730	3200	60	NO
4731	3200	92	YES
4732	3200	58	NO
4733	3200	87	YES
4734	3200	88	YES
4735	3200	89	YES
4736	3201	46	YES
4737	3201	49	YES
4738	3201	50	YES
4739	3201	51	YES
4740	3201	52	YES
4741	3201	53	YES
4742	3201	54	NO
4743	3201	55	YES
4744	3201	56	YES
4745	3201	57	YES
4746	3201	90	YES
4747	3201	91	YES
4748	3201	60	NO
4749	3201	92	YES
4750	3201	58	YES
4751	3201	87	YES
4752	3201	88	NO
4753	3201	89	YES
4754	3202	46	YES
4755	3202	49	YES
4756	3202	50	YES
4757	3202	51	YES
4758	3202	52	YES
4759	3202	53	YES
4760	3202	54	YES
4761	3202	55	YES
4762	3202	56	YES
4763	3202	57	YES
4764	3202	90	YES
4765	3202	91	YES
4766	3202	60	NO
4767	3202	92	YES
4768	3202	58	YES
4769	3202	87	YES
4770	3202	88	YES
4771	3202	89	YES
4772	3203	46	YES
4773	3203	49	YES
4774	3203	50	YES
4775	3203	51	YES
4776	3203	52	NO
4777	3203	53	YES
4778	3203	54	YES
4779	3203	55	YES
4780	3203	56	YES
4781	3203	57	YES
4782	3203	90	YES
4783	3203	91	YES
4784	3203	60	NO
4785	3203	92	YES
4786	3203	58	YES
4787	3203	87	YES
4788	3203	88	YES
4789	3203	89	YES
4790	3204	46	YES
4791	3204	49	YES
4792	3204	50	YES
4793	3204	51	YES
4794	3204	52	YES
4795	3204	53	YES
4796	3204	54	YES
4797	3204	55	YES
4798	3204	56	YES
4799	3204	57	YES
4800	3204	90	YES
4801	3204	91	YES
4802	3204	60	NO
4803	3204	92	YES
4804	3204	58	NO
4805	3204	87	YES
4806	3204	88	YES
4807	3204	89	YES
4808	3205	46	YES
4809	3205	49	YES
4810	3205	50	NO
4811	3205	51	YES
4812	3205	52	NO
4813	3205	53	YES
4814	3205	54	YES
4815	3205	55	YES
4816	3205	56	YES
4817	3205	57	YES
4818	3205	90	YES
4819	3205	91	YES
4820	3205	60	NO
4821	3205	92	YES
4822	3205	58	YES
4823	3205	87	YES
4824	3205	88	YES
4825	3205	89	YES
4826	3206	46	YES
4827	3206	49	YES
4828	3206	50	NO
4829	3206	51	YES
4830	3206	52	YES
4831	3206	53	YES
4832	3206	54	YES
4833	3206	55	YES
4834	3206	56	YES
4835	3206	57	YES
4836	3206	90	YES
4837	3206	91	YES
4838	3206	60	NO
4839	3206	92	YES
4840	3206	58	NO
4841	3206	87	YES
4842	3206	88	YES
4843	3206	89	YES
4844	3160	46	YES
4845	3160	49	YES
4846	3160	50	YES
4847	3160	51	YES
4848	3160	52	YES
4849	3160	53	YES
4850	3160	54	YES
4851	3160	55	YES
4852	3160	56	YES
4853	3160	57	YES
4854	3160	90	YES
4855	3160	91	YES
4856	3160	60	NO
4857	3160	92	YES
4858	3160	58	YES
4859	3160	87	NO
4860	3160	88	YES
4861	3160	89	YES
4862	3207	46	YES
4863	3207	49	YES
4864	3207	50	YES
4865	3207	51	YES
4866	3207	52	NO
4867	3207	53	YES
4868	3207	54	YES
4869	3207	55	YES
4870	3207	56	YES
4871	3207	57	YES
4872	3207	90	YES
4873	3207	91	YES
4874	3207	60	NO
4875	3207	92	YES
4876	3207	58	YES
4877	3207	87	YES
4878	3207	88	YES
4879	3207	89	YES
4880	3208	46	YES
4881	3208	49	YES
4882	3208	50	YES
4883	3208	51	YES
4884	3208	52	YES
4885	3208	53	YES
4886	3208	54	YES
4887	3208	55	YES
4888	3208	56	YES
4889	3208	57	YES
4890	3208	90	YES
4891	3208	91	YES
4892	3208	60	NO
4893	3208	92	YES
4894	3208	58	YES
4895	3208	87	YES
4896	3208	88	YES
4897	3208	89	YES
4898	3209	46	YES
4899	3209	49	YES
4900	3209	50	YES
4901	3209	51	YES
4902	3209	52	NO
4903	3209	53	YES
4904	3209	54	YES
4905	3209	55	YES
4906	3209	56	YES
4907	3209	57	YES
4908	3209	90	NO
4909	3209	91	YES
4910	3209	60	NO
4911	3209	92	YES
4912	3209	58	YES
4913	3209	87	YES
4914	3209	88	YES
4915	3209	89	YES
4916	3210	46	YES
4917	3210	49	YES
4918	3210	50	YES
4919	3210	51	NO
4920	3210	52	NO
4921	3210	53	YES
4922	3210	54	YES
4923	3210	55	YES
4924	3210	56	YES
4925	3210	57	YES
4926	3210	90	NO
4927	3210	91	YES
4928	3210	60	YES
4929	3210	92	YES
4930	3210	58	YES
4931	3210	87	YES
4932	3210	88	YES
4933	3210	89	YES
4934	3211	46	YES
4935	3211	49	YES
4936	3211	50	YES
4937	3211	51	YES
4938	3211	52	YES
4939	3211	53	YES
4940	3211	54	YES
4941	3211	55	YES
4942	3211	56	YES
4943	3211	57	YES
4944	3211	90	YES
4945	3211	91	YES
4946	3211	60	YES
4947	3211	92	YES
4948	3211	58	YES
4949	3211	87	YES
4950	3211	88	YES
4951	3211	89	YES
4952	3212	46	YES
4953	3212	49	YES
4954	3212	50	YES
4955	3212	51	YES
4956	3212	52	YES
4957	3212	53	YES
4958	3212	54	YES
4959	3212	55	YES
4960	3212	56	YES
4961	3212	57	YES
4962	3212	90	YES
4963	3212	91	YES
4964	3212	60	NO
4965	3212	92	YES
4966	3212	58	YES
4967	3212	87	YES
4968	3212	88	YES
4969	3212	89	YES
4970	3213	46	YES
4971	3213	49	YES
4972	3213	50	YES
4973	3213	51	YES
4974	3213	52	YES
4975	3213	53	YES
4976	3213	54	YES
4977	3213	55	YES
4978	3213	56	YES
4979	3213	57	YES
4980	3213	90	YES
4981	3213	91	YES
4982	3213	60	NO
4983	3213	92	NO
4984	3213	58	YES
4985	3213	87	YES
4986	3213	88	YES
4987	3213	89	YES
4988	3214	46	YES
4989	3214	49	YES
4990	3214	50	YES
4991	3214	51	NO
4992	3214	52	YES
4993	3214	53	YES
4994	3214	54	YES
4995	3214	55	YES
4996	3214	56	YES
4997	3214	57	YES
4998	3214	90	NO
4999	3214	91	YES
5000	3214	60	NO
5001	3214	92	NO
5002	3214	58	YES
5003	3214	87	YES
5004	3214	88	YES
5005	3214	89	YES
5006	3215	46	YES
5007	3215	49	YES
5008	3215	50	YES
5009	3215	51	YES
5010	3215	52	NO
5011	3215	53	YES
5012	3215	54	YES
5013	3215	55	YES
5014	3215	56	YES
5015	3215	57	YES
5016	3215	90	YES
5017	3215	91	YES
5018	3215	60	NO
5019	3215	92	YES
5020	3215	58	YES
5021	3215	87	YES
5022	3215	88	YES
5023	3215	89	YES
5024	3216	46	YES
5025	3216	49	YES
5026	3216	50	YES
5027	3216	51	YES
5028	3216	52	NO
5029	3216	53	YES
5030	3216	54	YES
5031	3216	55	YES
5032	3216	56	YES
5033	3216	57	YES
5034	3216	90	NO
5035	3216	91	YES
5036	3216	60	YES
5037	3216	92	YES
5038	3216	58	YES
5039	3216	87	YES
5040	3216	88	YES
5041	3216	89	YES
5042	3217	46	YES
5043	3217	49	YES
5044	3217	50	YES
5045	3217	51	YES
5046	3217	52	NO
5047	3217	53	YES
5048	3217	54	YES
5049	3217	55	YES
5050	3217	56	YES
5051	3217	57	YES
5052	3217	90	YES
5053	3217	91	YES
5054	3217	60	NO
5055	3217	92	YES
5056	3217	58	YES
5057	3217	87	YES
5058	3217	88	YES
5059	3217	89	YES
5060	3218	46	YES
5061	3218	49	NO
5062	3218	50	YES
5063	3218	51	YES
5064	3218	52	NO
5065	3218	53	YES
5066	3218	54	YES
5067	3218	55	YES
5068	3218	56	YES
5069	3218	57	YES
5070	3218	90	NO
5071	3218	91	YES
5072	3218	60	NO
5073	3218	92	YES
5074	3218	58	YES
5075	3218	87	YES
5076	3218	88	YES
5077	3218	89	YES
5078	3219	46	YES
5079	3219	49	YES
5080	3219	50	YES
5081	3219	51	YES
5082	3219	52	NO
5083	3219	53	YES
5084	3219	54	YES
5085	3219	55	YES
5086	3219	56	YES
5087	3219	57	YES
5088	3219	90	YES
5089	3219	91	YES
5090	3219	60	NO
5091	3219	92	YES
5092	3219	58	YES
5093	3219	87	YES
5094	3219	88	YES
5095	3219	89	YES
5096	3220	46	YES
5097	3220	49	YES
5098	3220	50	YES
5099	3220	51	YES
5100	3220	52	YES
5101	3220	53	YES
5102	3220	54	YES
5103	3220	55	YES
5104	3220	56	YES
5105	3220	57	YES
5106	3220	90	YES
5107	3220	91	YES
5108	3220	60	NO
5109	3220	92	YES
5110	3220	58	YES
5111	3220	87	YES
5112	3220	88	YES
5113	3220	89	YES
5114	3221	46	YES
5115	3221	49	NO
5116	3221	50	YES
5117	3221	51	YES
5118	3221	52	NO
5119	3221	53	YES
5120	3221	54	NO
5121	3221	55	YES
5122	3221	56	YES
5123	3221	57	YES
5124	3221	90	NO
5125	3221	91	YES
5126	3221	60	NO
5127	3221	92	YES
5128	3221	58	YES
5129	3221	87	YES
5130	3221	88	YES
5131	3221	89	YES
5132	3222	46	YES
5133	3222	49	YES
5134	3222	50	YES
5135	3222	51	YES
5136	3222	52	YES
5137	3222	53	YES
5138	3222	54	YES
5139	3222	55	YES
5140	3222	56	YES
5141	3222	57	YES
5142	3222	90	YES
5143	3222	91	YES
5144	3222	60	NO
5145	3222	92	YES
5146	3222	58	YES
5147	3222	87	YES
5148	3222	88	YES
5149	3222	89	YES
5150	3223	46	YES
5151	3223	49	YES
5152	3223	50	YES
5153	3223	51	YES
5154	3223	52	YES
5155	3223	53	YES
5156	3223	54	YES
5157	3223	55	YES
5158	3223	56	YES
5159	3223	57	YES
5160	3223	90	YES
5161	3223	91	YES
5162	3223	60	NO
5163	3223	92	YES
5164	3223	58	YES
5165	3223	87	YES
5166	3223	88	YES
5167	3223	89	YES
5168	3224	46	YES
5169	3224	49	YES
5170	3224	50	YES
5171	3224	51	YES
5172	3224	52	NO
5173	3224	53	YES
5174	3224	54	YES
5175	3224	55	YES
5176	3224	56	YES
5177	3224	57	YES
5178	3224	90	YES
5179	3224	91	YES
5180	3224	60	NO
5181	3224	92	YES
5182	3224	58	YES
5183	3224	87	YES
5184	3224	88	NO
5185	3224	89	YES
5186	3225	46	YES
5187	3225	49	YES
5188	3225	50	YES
5189	3225	51	YES
5190	3225	52	NO
5191	3225	53	NO
5192	3225	54	YES
5193	3225	55	YES
5194	3225	56	YES
5195	3225	57	YES
5196	3225	90	YES
5197	3225	91	YES
5198	3225	60	NO
5199	3225	92	YES
5200	3225	58	YES
5201	3225	87	YES
5202	3225	88	YES
5203	3225	89	YES
5204	3226	46	YES
5205	3226	49	NO
5206	3226	50	YES
5207	3226	51	YES
5208	3226	52	NO
5209	3226	53	YES
5210	3226	54	NO
5211	3226	55	YES
5212	3226	56	YES
5213	3226	57	YES
5214	3226	90	NO
5215	3226	91	YES
5216	3226	60	NO
5217	3226	92	YES
5218	3226	58	YES
5219	3226	87	YES
5220	3226	88	YES
5221	3226	89	YES
5222	3227	46	YES
5223	3227	49	YES
5224	3227	50	YES
5225	3227	51	YES
5226	3227	52	NO
5227	3227	53	YES
5228	3227	54	YES
5229	3227	55	YES
5230	3227	56	YES
5231	3227	57	YES
5232	3227	90	NO
5233	3227	91	YES
5234	3227	60	YES
5235	3227	92	NO
5236	3227	58	YES
5237	3227	87	YES
5238	3227	88	NO
5239	3227	89	YES
5240	3228	46	YES
5241	3228	49	YES
5242	3228	50	YES
5243	3228	51	YES
5244	3228	52	NO
5245	3228	53	YES
5246	3228	54	YES
5247	3228	55	YES
5248	3228	56	YES
5249	3228	57	YES
5250	3228	90	NO
5251	3228	91	YES
5252	3228	60	NO
5253	3228	92	NO
5254	3228	58	YES
5255	3228	87	YES
5256	3228	88	YES
5257	3228	89	YES
5258	3229	46	YES
5259	3229	49	YES
5260	3229	50	YES
5261	3229	51	NO
5262	3229	52	NO
5263	3229	53	YES
5264	3229	54	NO
5265	3229	55	YES
5266	3229	56	YES
5267	3229	57	YES
5268	3229	90	NO
5269	3229	91	YES
5270	3229	60	NO
5271	3229	92	YES
5272	3229	58	YES
5273	3229	87	YES
5274	3229	88	YES
5275	3229	89	YES
5276	3230	46	YES
5277	3230	49	YES
5278	3230	50	YES
5279	3230	51	YES
5280	3230	52	YES
5281	3230	53	YES
5282	3230	54	YES
5283	3230	55	YES
5284	3230	56	YES
5285	3230	57	YES
5286	3230	90	NO
5287	3230	91	YES
5288	3230	60	NO
5289	3230	92	YES
5290	3230	58	YES
5291	3230	87	YES
5292	3230	88	YES
5293	3230	89	YES
5294	3231	46	YES
5295	3231	49	YES
5296	3231	50	YES
5297	3231	51	NO
5298	3231	52	NO
5299	3231	53	YES
5300	3231	54	YES
5301	3231	55	YES
5302	3231	56	YES
5303	3231	57	YES
5304	3231	90	NO
5305	3231	91	NO
5306	3231	60	YES
5307	3231	92	YES
5308	3231	58	YES
5309	3231	87	YES
5310	3231	88	YES
5311	3231	89	YES
5312	3232	46	NO
5313	3232	49	YES
5314	3232	50	YES
5315	3232	51	NO
5316	3232	52	NO
5317	3232	53	YES
5318	3232	54	YES
5319	3232	55	YES
5320	3232	56	YES
5321	3232	57	NO
5322	3232	90	NO
5323	3232	91	NO
5324	3232	60	NO
5325	3232	92	YES
5326	3232	58	YES
5327	3232	87	NO
5328	3232	88	NO
5329	3232	89	YES
5330	3233	46	YES
5331	3233	49	YES
5332	3233	50	YES
5333	3233	51	YES
5334	3233	52	YES
5335	3233	53	YES
5336	3233	54	YES
5337	3233	55	YES
5338	3233	56	YES
5339	3233	57	YES
5340	3233	90	YES
5341	3233	91	YES
5342	3233	60	NO
5343	3233	92	NO
5344	3233	58	YES
5345	3233	87	YES
5346	3233	88	YES
5347	3233	89	YES
5348	3234	46	NO
5349	3234	49	YES
5350	3234	50	YES
5351	3234	51	NO
5352	3234	52	NO
5353	3234	53	YES
5354	3234	54	YES
5355	3234	55	YES
5356	3234	56	YES
5357	3234	57	YES
5358	3234	90	NO
5359	3234	91	NO
5360	3234	60	NO
5361	3234	92	NO
5362	3234	58	YES
5363	3234	87	YES
5364	3234	88	YES
5365	3234	89	YES
5366	3235	46	YES
5367	3235	49	YES
5368	3235	50	NO
5369	3235	51	NO
5370	3235	52	NO
5371	3235	53	YES
5372	3235	54	YES
5373	3235	55	YES
5374	3235	56	YES
5375	3235	57	YES
5376	3235	90	NO
5377	3235	91	YES
5378	3235	60	NO
5379	3235	92	YES
5380	3235	58	YES
5381	3235	87	YES
5382	3235	88	YES
5383	3235	89	YES
5384	3236	46	YES
5385	3236	49	YES
5386	3236	50	YES
5387	3236	51	NO
5388	3236	52	NO
5389	3236	53	YES
5390	3236	54	YES
5391	3236	55	YES
5392	3236	56	YES
5393	3236	57	YES
5394	3236	90	NO
5395	3236	91	YES
5396	3236	60	NO
5397	3236	92	YES
5398	3236	58	YES
5399	3236	87	YES
5400	3236	88	YES
5401	3236	89	YES
5402	3237	46	YES
5403	3237	49	YES
5404	3237	50	YES
5405	3237	51	NO
5406	3237	52	NO
5407	3237	53	YES
5408	3237	54	NO
5409	3237	55	YES
5410	3237	56	YES
5411	3237	57	YES
5412	3237	90	NO
5413	3237	91	YES
5414	3237	60	NO
5415	3237	92	YES
5416	3237	58	YES
5417	3237	87	YES
5418	3237	88	YES
5419	3237	89	YES
5420	3238	46	YES
5421	3238	49	YES
5422	3238	50	NO
5423	3238	51	NO
5424	3238	52	NO
5425	3238	53	YES
5426	3238	54	NO
5427	3238	55	YES
5428	3238	56	YES
5429	3238	57	YES
5430	3238	90	NO
5431	3238	91	YES
5432	3238	60	NO
5433	3238	92	YES
5434	3238	58	YES
5435	3238	87	YES
5436	3238	88	YES
5437	3238	89	YES
5438	3239	46	YES
5439	3239	49	YES
5440	3239	50	YES
5441	3239	51	NO
5442	3239	52	NO
5443	3239	53	YES
5444	3239	54	YES
5445	3239	55	YES
5446	3239	56	YES
5447	3239	57	YES
5448	3239	90	YES
5449	3239	91	NO
5450	3239	60	NO
5451	3239	92	YES
5452	3239	58	YES
5453	3239	87	YES
5454	3239	88	YES
5455	3239	89	YES
5456	3240	46	YES
5457	3240	49	YES
5458	3240	50	YES
5459	3240	51	NO
5460	3240	52	NO
5461	3240	53	YES
5462	3240	54	YES
5463	3240	55	YES
5464	3240	56	YES
5465	3240	57	YES
5466	3240	90	NO
5467	3240	91	NO
5468	3240	60	NO
5469	3240	92	YES
5470	3240	58	YES
5471	3240	87	NO
5472	3240	88	YES
5473	3240	89	YES
5474	3241	46	YES
5475	3241	49	YES
5476	3241	50	NO
5477	3241	51	YES
5478	3241	52	NO
5479	3241	53	YES
5480	3241	54	YES
5481	3241	55	YES
5482	3241	56	YES
5483	3241	57	YES
5484	3241	90	NO
5485	3241	91	YES
5486	3241	60	YES
5487	3241	92	NO
5488	3241	58	YES
5489	3241	87	YES
5490	3241	88	YES
5491	3241	89	YES
5492	3242	46	YES
5493	3242	49	YES
5494	3242	50	YES
5495	3242	51	YES
5496	3242	52	NO
5497	3242	53	YES
5498	3242	54	YES
5499	3242	55	YES
5500	3242	56	YES
5501	3242	57	YES
5502	3242	90	YES
5503	3242	91	YES
5504	3242	60	NO
5505	3242	92	NO
5506	3242	58	YES
5507	3242	87	YES
5508	3242	88	YES
5509	3242	89	YES
5510	3243	46	YES
5511	3243	49	YES
5512	3243	50	YES
5513	3243	51	YES
5514	3243	52	NO
5515	3243	53	YES
5516	3243	54	YES
5517	3243	55	YES
5518	3243	56	YES
5519	3243	57	YES
5520	3243	90	YES
5521	3243	91	YES
5522	3243	60	NO
5523	3243	92	YES
5524	3243	58	YES
5525	3243	87	YES
5526	3243	88	YES
5527	3243	89	YES
5528	3244	46	YES
5529	3244	49	YES
5530	3244	50	YES
5531	3244	51	YES
5532	3244	52	YES
5533	3244	53	YES
5534	3244	54	YES
5535	3244	55	YES
5536	3244	56	YES
5537	3244	57	YES
5538	3244	90	NO
5539	3244	91	YES
5540	3244	60	NO
5541	3244	92	YES
5542	3244	58	YES
5543	3244	87	YES
5544	3244	88	YES
5545	3244	89	YES
5546	3245	46	YES
5547	3245	49	YES
5548	3245	50	YES
5549	3245	51	NO
5550	3245	52	NO
5551	3245	53	YES
5552	3245	54	YES
5553	3245	55	NO
5554	3245	56	YES
5555	3245	57	YES
5556	3245	90	NO
5557	3245	91	NO
5558	3245	60	YES
5559	3245	92	YES
5560	3245	58	YES
5561	3245	87	NO
5562	3245	88	YES
5563	3245	89	YES
5564	3246	46	YES
5565	3246	49	YES
5566	3246	50	YES
5567	3246	51	YES
5568	3246	52	YES
5569	3246	53	YES
5570	3246	54	YES
5571	3246	55	YES
5572	3246	56	YES
5573	3246	57	YES
5574	3246	90	YES
5575	3246	91	YES
5576	3246	60	NO
5577	3246	92	YES
5578	3246	58	YES
5579	3246	87	YES
5580	3246	88	YES
5581	3246	89	YES
5582	3247	46	YES
5583	3247	49	YES
5584	3247	50	YES
5585	3247	51	YES
5586	3247	52	NO
5587	3247	53	YES
5588	3247	54	YES
5589	3247	55	NO
5590	3247	56	YES
5591	3247	57	YES
5592	3247	90	NO
5593	3247	91	YES
5594	3247	60	NO
5595	3247	92	YES
5596	3247	58	YES
5597	3247	87	YES
5598	3247	88	YES
5599	3247	89	YES
5600	3248	46	YES
5601	3248	49	YES
5602	3248	50	YES
5603	3248	51	YES
5604	3248	52	YES
5605	3248	53	YES
5606	3248	54	YES
5607	3248	55	YES
5608	3248	56	YES
5609	3248	57	YES
5610	3248	90	NO
5611	3248	91	YES
5612	3248	60	NO
5613	3248	92	YES
5614	3248	58	YES
5615	3248	87	YES
5616	3248	88	YES
5617	3248	89	YES
5618	3249	46	YES
5619	3249	49	YES
5620	3249	50	NO
5621	3249	51	NO
5622	3249	52	NO
5623	3249	53	YES
5624	3249	54	YES
5625	3249	55	YES
5626	3249	56	YES
5627	3249	57	YES
5628	3249	90	NO
5629	3249	91	YES
5630	3249	60	YES
5631	3249	92	YES
5632	3249	58	YES
5633	3249	87	NO
5634	3249	88	NO
5635	3249	89	YES
5636	3250	46	YES
5637	3250	49	NO
5638	3250	50	NO
5639	3250	51	NO
5640	3250	52	NO
5641	3250	53	YES
5642	3250	54	YES
5643	3250	55	YES
5644	3250	56	YES
5645	3250	57	YES
5646	3250	90	NO
5647	3250	91	YES
5648	3250	60	NO
5649	3250	92	YES
5650	3250	58	YES
5651	3250	87	YES
5652	3250	88	YES
5653	3250	89	YES
5654	3251	46	NO
5655	3251	49	YES
5656	3251	50	YES
5657	3251	51	NO
5658	3251	52	NO
5659	3251	53	YES
5660	3251	54	YES
5661	3251	55	YES
5662	3251	56	YES
5663	3251	57	YES
5664	3251	90	NO
5665	3251	91	YES
5666	3251	60	NO
5667	3251	92	YES
5668	3251	58	YES
5669	3251	87	YES
5670	3251	88	YES
5671	3251	89	YES
5672	3252	46	YES
5673	3252	49	YES
5674	3252	50	YES
5675	3252	51	NO
5676	3252	52	NO
5677	3252	53	YES
5678	3252	54	YES
5679	3252	55	YES
5680	3252	56	YES
5681	3252	57	YES
5682	3252	90	NO
5683	3252	91	YES
5684	3252	60	NO
5685	3252	92	YES
5686	3252	58	YES
5687	3252	87	YES
5688	3252	88	YES
5689	3252	89	YES
5690	3253	46	YES
5691	3253	49	YES
5692	3253	50	YES
5693	3253	51	YES
5694	3253	52	YES
5695	3253	53	YES
5696	3253	54	YES
5697	3253	55	YES
5698	3253	56	YES
5699	3253	57	YES
5700	3253	90	YES
5701	3253	91	YES
5702	3253	60	NO
5703	3253	92	YES
5704	3253	58	YES
5705	3253	87	YES
5706	3253	88	YES
5707	3253	89	YES
5708	3255	46	YES
5709	3255	49	YES
5710	3255	50	YES
5711	3255	51	YES
5712	3255	52	YES
5713	3255	53	NO
5714	3255	54	YES
5715	3255	55	YES
5716	3255	56	YES
5717	3255	57	YES
5718	3255	90	YES
5719	3255	91	YES
5720	3255	60	NO
5721	3255	92	NO
5722	3255	58	YES
5723	3255	87	YES
5724	3255	88	YES
5725	3255	89	YES
5726	3256	46	YES
5727	3256	49	YES
5728	3256	50	YES
5729	3256	51	YES
5730	3256	52	NO
5731	3256	53	YES
5732	3256	54	YES
5733	3256	55	YES
5734	3256	56	YES
5735	3256	57	YES
5736	3256	90	YES
5737	3256	91	YES
5738	3256	60	NO
5739	3256	92	NO
5740	3256	58	YES
5741	3256	87	YES
5742	3256	88	YES
5743	3256	89	YES
5744	3257	46	YES
5745	3257	49	YES
5746	3257	50	YES
5747	3257	51	YES
5748	3257	52	NO
5749	3257	53	YES
5750	3257	54	YES
5751	3257	55	YES
5752	3257	56	YES
5753	3257	57	YES
5754	3257	90	YES
5755	3257	91	YES
5756	3257	60	NO
5757	3257	92	NO
5758	3257	58	YES
5759	3257	87	YES
5760	3257	88	YES
5761	3257	89	YES
5762	3258	46	YES
5763	3258	49	YES
5764	3258	50	YES
5765	3258	51	YES
5766	3258	52	YES
5767	3258	53	YES
5768	3258	54	YES
5769	3258	55	YES
5770	3258	56	YES
5771	3258	57	YES
5772	3258	90	YES
5773	3258	91	YES
5774	3258	60	NO
5775	3258	92	NO
5776	3258	58	YES
5777	3258	87	YES
5778	3258	88	YES
5779	3258	89	YES
5780	3259	46	YES
5781	3259	49	YES
5782	3259	50	YES
5783	3259	51	NO
5784	3259	52	NO
5785	3259	53	YES
5786	3259	54	YES
5787	3259	55	YES
5788	3259	56	YES
5789	3259	57	YES
5790	3259	90	YES
5791	3259	91	YES
5792	3259	60	YES
5793	3259	92	NO
5794	3259	58	YES
5795	3259	87	YES
5796	3259	88	YES
5797	3259	89	YES
5798	3260	46	YES
5799	3260	49	YES
5800	3260	50	YES
5801	3260	51	YES
5802	3260	52	NO
5803	3260	53	YES
5804	3260	54	YES
5805	3260	55	YES
5806	3260	56	YES
5807	3260	57	YES
5808	3260	90	YES
5809	3260	91	YES
5810	3260	60	NO
5811	3260	92	YES
5812	3260	58	YES
5813	3260	87	YES
5814	3260	88	YES
5815	3260	89	YES
5816	3261	46	YES
5817	3261	49	YES
5818	3261	50	YES
5819	3261	51	YES
5820	3261	52	NO
5821	3261	53	YES
5822	3261	54	YES
5823	3261	55	YES
5824	3261	56	YES
5825	3261	57	YES
5826	3261	90	YES
5827	3261	91	YES
5828	3261	60	NO
5829	3261	92	YES
5830	3261	58	YES
5831	3261	87	YES
5832	3261	88	YES
5833	3261	89	YES
5834	3262	46	YES
5835	3262	49	YES
5836	3262	50	YES
5837	3262	51	YES
5838	3262	52	NO
5839	3262	53	YES
5840	3262	54	YES
5841	3262	55	YES
5842	3262	56	YES
5843	3262	57	YES
5844	3262	90	NO
5845	3262	91	YES
5846	3262	60	YES
5847	3262	92	YES
5848	3262	58	YES
5849	3262	87	YES
5850	3262	88	YES
5851	3262	89	YES
5852	3263	46	YES
5853	3263	49	YES
5854	3263	50	YES
5855	3263	51	NO
5856	3263	52	NO
5857	3263	53	YES
5858	3263	54	YES
5859	3263	55	YES
5860	3263	56	YES
5861	3263	57	YES
5862	3263	90	NO
5863	3263	91	YES
5864	3263	60	YES
5865	3263	92	YES
5866	3263	58	YES
5867	3263	87	YES
5868	3263	88	YES
5869	3263	89	YES
5870	3264	46	NO
5871	3264	49	YES
5872	3264	50	YES
5873	3264	51	NO
5874	3264	52	NO
5875	3264	53	YES
5876	3264	54	YES
5877	3264	55	YES
5878	3264	56	YES
5879	3264	57	YES
5880	3264	90	NO
5881	3264	91	YES
5882	3264	60	YES
5883	3264	92	YES
5884	3264	58	YES
5885	3264	87	YES
5886	3264	88	YES
5887	3264	89	YES
5888	3265	46	YES
5889	3265	49	NO
5890	3265	50	YES
5891	3265	51	YES
5892	3265	52	YES
5893	3265	53	YES
5894	3265	54	YES
5895	3265	55	YES
5896	3265	56	YES
5897	3265	57	YES
5898	3265	90	YES
5899	3265	91	YES
5900	3265	60	NO
5901	3265	92	NO
5902	3265	58	YES
5903	3265	87	YES
5904	3265	88	YES
5905	3265	89	YES
5906	3266	46	YES
5907	3266	49	YES
5908	3266	50	YES
5909	3266	51	YES
5910	3266	52	YES
5911	3266	53	YES
5912	3266	54	YES
5913	3266	55	YES
5914	3266	56	YES
5915	3266	57	YES
5916	3266	90	YES
5917	3266	91	YES
5918	3266	60	NO
5919	3266	92	NO
5920	3266	58	YES
5921	3266	87	YES
5922	3266	88	YES
5923	3266	89	YES
5924	3267	46	YES
5925	3267	49	YES
5926	3267	50	YES
5927	3267	51	NO
5928	3267	52	NO
5929	3267	53	YES
5930	3267	54	YES
5931	3267	55	YES
5932	3267	56	YES
5933	3267	57	YES
5934	3267	90	NO
5935	3267	91	YES
5936	3267	60	NO
5937	3267	92	YES
5938	3267	58	YES
5939	3267	87	YES
5940	3267	88	YES
5941	3267	89	YES
5942	3268	46	YES
5943	3268	49	YES
5944	3268	50	YES
5945	3268	51	NO
5946	3268	52	NO
5947	3268	53	YES
5948	3268	54	YES
5949	3268	55	YES
5950	3268	56	YES
5951	3268	57	YES
5952	3268	90	NO
5953	3268	91	YES
5954	3268	60	NO
5955	3268	92	YES
5956	3268	58	YES
5957	3268	87	YES
5958	3268	88	YES
5959	3268	89	YES
5960	3269	46	YES
5961	3269	49	YES
5962	3269	50	YES
5963	3269	51	YES
5964	3269	52	NO
5965	3269	53	YES
5966	3269	54	YES
5967	3269	55	YES
5968	3269	56	YES
5969	3269	57	YES
5970	3269	90	YES
5971	3269	91	YES
5972	3269	60	NO
5973	3269	92	YES
5974	3269	58	YES
5975	3269	87	YES
5976	3269	88	YES
5977	3269	89	YES
5978	3270	46	YES
5979	3270	49	YES
5980	3270	50	YES
5981	3270	51	YES
5982	3270	52	NO
5983	3270	53	NO
5984	3270	54	YES
5985	3270	55	YES
5986	3270	56	YES
5987	3270	57	YES
5988	3270	90	NO
5989	3270	91	YES
5990	3270	60	NO
5991	3270	92	NO
5992	3270	58	YES
5993	3270	87	YES
5994	3270	88	YES
5995	3270	89	YES
5996	3271	46	YES
5997	3271	49	YES
5998	3271	50	YES
5999	3271	51	YES
6000	3271	52	YES
6001	3271	53	YES
6002	3271	54	YES
6003	3271	55	YES
6004	3271	56	YES
6005	3271	57	YES
6006	3271	90	NO
6007	3271	91	YES
6008	3271	60	NO
6009	3271	92	NO
6010	3271	58	YES
6011	3271	87	YES
6012	3271	88	YES
6013	3271	89	YES
6014	3272	46	YES
6015	3272	49	YES
6016	3272	50	YES
6017	3272	51	YES
6018	3272	52	YES
6019	3272	53	YES
6020	3272	54	YES
6021	3272	55	YES
6022	3272	56	YES
6023	3272	57	YES
6024	3272	90	YES
6025	3272	91	YES
6026	3272	60	NO
6027	3272	92	NO
6028	3272	58	YES
6029	3272	87	YES
6030	3272	88	YES
6031	3272	89	YES
6032	3273	46	YES
6033	3273	49	YES
6034	3273	50	YES
6035	3273	51	YES
6036	3273	52	YES
6037	3273	53	YES
6038	3273	54	YES
6039	3273	55	YES
6040	3273	56	YES
6041	3273	57	YES
6042	3273	90	NO
6043	3273	91	YES
6044	3273	60	NO
6045	3273	92	YES
6046	3273	58	YES
6047	3273	87	YES
6048	3273	88	YES
6049	3273	89	YES
6050	3274	46	YES
6051	3274	49	YES
6052	3274	50	YES
6053	3274	51	NO
6054	3274	52	NO
6055	3274	53	YES
6056	3274	54	YES
6057	3274	55	YES
6058	3274	56	YES
6059	3274	57	YES
6060	3274	90	NO
6061	3274	91	YES
6062	3274	60	NO
6063	3274	92	YES
6064	3274	58	YES
6065	3274	87	YES
6066	3274	88	YES
6067	3274	89	YES
6068	3275	46	YES
6069	3275	49	YES
6070	3275	50	YES
6071	3275	51	YES
6072	3275	52	NO
6073	3275	53	YES
6074	3275	54	YES
6075	3275	55	YES
6076	3275	56	YES
6077	3275	57	YES
6078	3275	90	YES
6079	3275	91	YES
6080	3275	60	NO
6081	3275	92	YES
6082	3275	58	YES
6083	3275	87	YES
6084	3275	88	YES
6085	3275	89	YES
6086	3276	46	YES
6087	3276	49	YES
6088	3276	50	YES
6089	3276	51	YES
6090	3276	52	YES
6091	3276	53	YES
6092	3276	54	YES
6093	3276	55	YES
6094	3276	56	YES
6095	3276	57	YES
6096	3276	90	YES
6097	3276	91	YES
6098	3276	60	NO
6099	3276	92	NO
6100	3276	58	YES
6101	3276	87	YES
6102	3276	88	YES
6103	3276	89	YES
6104	3277	46	YES
6105	3277	49	YES
6106	3277	50	NO
6107	3277	51	YES
6108	3277	52	NO
6109	3277	53	YES
6110	3277	54	YES
6111	3277	55	YES
6112	3277	56	YES
6113	3277	57	YES
6114	3277	90	NO
6115	3277	91	YES
6116	3277	60	NO
6117	3277	92	NO
6118	3277	58	YES
6119	3277	87	NO
6120	3277	88	NO
6121	3277	89	YES
6122	3278	46	YES
6123	3278	49	YES
6124	3278	50	YES
6125	3278	51	YES
6126	3278	52	NO
6127	3278	53	YES
6128	3278	54	YES
6129	3278	55	YES
6130	3278	56	YES
6131	3278	57	YES
6132	3278	90	NO
6133	3278	91	YES
6134	3278	60	NO
6135	3278	92	NO
6136	3278	58	YES
6137	3278	87	NO
6138	3278	88	NO
6139	3278	89	YES
6140	3279	46	YES
6141	3279	49	YES
6142	3279	50	YES
6143	3279	51	YES
6144	3279	52	NO
6145	3279	53	YES
6146	3279	54	YES
6147	3279	55	YES
6148	3279	56	YES
6149	3279	57	YES
6150	3279	90	NO
6151	3279	91	YES
6152	3279	60	NO
6153	3279	92	NO
6154	3279	58	NO
6155	3279	87	NO
6156	3279	88	NO
6157	3279	89	YES
6158	3280	46	YES
6159	3280	49	YES
6160	3280	50	YES
6161	3280	51	YES
6162	3280	52	YES
6163	3280	53	YES
6164	3280	54	YES
6165	3280	55	YES
6166	3280	56	YES
6167	3280	57	YES
6168	3280	90	YES
6169	3280	91	YES
6170	3280	60	NO
6171	3280	92	NO
6172	3280	58	YES
6173	3280	87	NO
6174	3280	88	NO
6175	3280	89	YES
6176	3281	46	YES
6177	3281	49	YES
6178	3281	50	YES
6179	3281	51	YES
6180	3281	52	NO
6181	3281	53	YES
6182	3281	54	YES
6183	3281	55	YES
6184	3281	56	YES
6185	3281	57	YES
6186	3281	90	NO
6187	3281	91	YES
6188	3281	60	NO
6189	3281	92	NO
6190	3281	58	YES
6191	3281	87	NO
6192	3281	88	NO
6193	3281	89	YES
6194	3282	46	YES
6195	3282	49	YES
6196	3282	50	YES
6197	3282	51	YES
6198	3282	52	NO
6199	3282	53	YES
6200	3282	54	YES
6201	3282	55	YES
6202	3282	56	YES
6203	3282	57	YES
6204	3282	90	NO
6205	3282	91	YES
6206	3282	60	NO
6207	3282	92	NO
6208	3282	58	NO
6209	3282	87	NO
6210	3282	88	NO
6211	3282	89	YES
6212	3283	46	YES
6213	3283	49	YES
6214	3283	50	NO
6215	3283	51	YES
6216	3283	52	NO
6217	3283	53	NO
6218	3283	54	YES
6219	3283	55	YES
6220	3283	56	YES
6221	3283	57	YES
6222	3283	90	YES
6223	3283	91	YES
6224	3283	60	NO
6225	3283	92	YES
6226	3283	58	YES
6227	3283	87	NO
6228	3283	88	NO
6229	3283	89	YES
6230	3284	46	YES
6231	3284	49	YES
6232	3284	50	NO
6233	3284	51	NO
6234	3284	52	YES
6235	3284	53	YES
6236	3284	54	YES
6237	3284	55	YES
6238	3284	56	YES
6239	3284	57	YES
6240	3284	90	YES
6241	3284	91	YES
6242	3284	60	NO
6243	3284	92	YES
6244	3284	58	YES
6245	3284	87	NO
6246	3284	88	NO
6247	3284	89	YES
6248	3285	46	YES
6249	3285	49	YES
6250	3285	50	YES
6251	3285	51	YES
6252	3285	52	YES
6253	3285	53	YES
6254	3285	54	YES
6255	3285	55	YES
6256	3285	56	YES
6257	3285	57	YES
6258	3285	90	YES
6259	3285	91	YES
6260	3285	60	NO
6261	3285	92	NO
6262	3285	58	YES
6263	3285	87	NO
6264	3285	88	NO
6265	3285	89	YES
6266	3286	46	YES
6267	3286	49	YES
6268	3286	50	YES
6269	3286	51	YES
6270	3286	52	NO
6271	3286	53	YES
6272	3286	54	YES
6273	3286	55	YES
6274	3286	56	YES
6275	3286	57	YES
6276	3286	90	NO
6277	3286	91	YES
6278	3286	60	NO
6279	3286	92	YES
6280	3286	58	YES
6281	3286	87	NO
6282	3286	88	NO
6283	3286	89	YES
6284	3287	46	NO
6285	3287	49	NO
6286	3287	50	NO
6287	3287	51	YES
6288	3287	52	NO
6289	3287	53	YES
6290	3287	54	YES
6291	3287	55	YES
6292	3287	56	YES
6293	3287	57	YES
6294	3287	90	NO
6295	3287	91	YES
6296	3287	60	NO
6297	3287	92	NO
6298	3287	58	YES
6299	3287	87	NO
6300	3287	88	NO
6301	3287	89	YES
6302	3288	46	YES
6303	3288	49	YES
6304	3288	50	YES
6305	3288	51	YES
6306	3288	52	NO
6307	3288	53	YES
6308	3288	54	YES
6309	3288	55	YES
6310	3288	56	YES
6311	3288	57	YES
6312	3288	90	NO
6313	3288	91	YES
6314	3288	60	NO
6315	3288	92	NO
6316	3288	58	YES
6317	3288	87	NO
6318	3288	88	NO
6319	3288	89	YES
6320	3289	46	YES
6321	3289	49	NO
6322	3289	50	NO
6323	3289	51	YES
6324	3289	52	NO
6325	3289	53	YES
6326	3289	54	YES
6327	3289	55	YES
6328	3289	56	YES
6329	3289	57	YES
6330	3289	90	NO
6331	3289	91	YES
6332	3289	60	NO
6333	3289	92	NO
6334	3289	58	YES
6335	3289	87	NO
6336	3289	88	NO
6337	3289	89	YES
6338	3290	46	YES
6339	3290	49	YES
6340	3290	50	YES
6341	3290	51	YES
6342	3290	52	NO
6343	3290	53	YES
6344	3290	54	YES
6345	3290	55	YES
6346	3290	56	YES
6347	3290	57	YES
6348	3290	90	NO
6349	3290	91	YES
6350	3290	60	NO
6351	3290	92	NO
6352	3290	58	YES
6353	3290	87	NO
6354	3290	88	NO
6355	3290	89	YES
6356	3291	46	YES
6357	3291	49	NO
6358	3291	50	YES
6359	3291	51	NO
6360	3291	52	NO
6361	3291	53	YES
6362	3291	54	YES
6363	3291	55	YES
6364	3291	56	YES
6365	3291	57	YES
6366	3291	90	YES
6367	3291	91	YES
6368	3291	60	NO
6369	3291	92	YES
6370	3291	58	NO
6371	3291	87	NO
6372	3291	88	NO
6373	3291	89	YES
6374	3292	46	YES
6375	3292	49	YES
6376	3292	50	YES
6377	3292	51	YES
6378	3292	52	YES
6379	3292	53	YES
6380	3292	54	YES
6381	3292	55	YES
6382	3292	56	YES
6383	3292	57	YES
6384	3292	90	NO
6385	3292	91	YES
6386	3292	60	NO
6387	3292	92	YES
6388	3292	58	YES
6389	3292	87	NO
6390	3292	88	NO
6391	3292	89	YES
6392	3293	46	YES
6393	3293	49	YES
6394	3293	50	YES
6395	3293	51	YES
6396	3293	52	NO
6397	3293	53	YES
6398	3293	54	YES
6399	3293	55	YES
6400	3293	56	YES
6401	3293	57	YES
6402	3293	90	NO
6403	3293	91	YES
6404	3293	60	NO
6405	3293	92	YES
6406	3293	58	YES
6407	3293	87	NO
6408	3293	88	NO
6409	3293	89	YES
6410	3294	46	YES
6411	3294	49	YES
6412	3294	50	YES
6413	3294	51	YES
6414	3294	52	NO
6415	3294	53	YES
6416	3294	54	NO
6417	3294	55	YES
6418	3294	56	YES
6419	3294	57	YES
6420	3294	90	NO
6421	3294	91	YES
6422	3294	60	NO
6423	3294	92	YES
6424	3294	58	NO
6425	3294	87	NO
6426	3294	88	NO
6427	3294	89	YES
6428	3295	46	YES
6429	3295	49	YES
6430	3295	50	YES
6431	3295	51	YES
6432	3295	52	NO
6433	3295	53	YES
6434	3295	54	YES
6435	3295	55	YES
6436	3295	56	YES
6437	3295	57	YES
6438	3295	90	NO
6439	3295	91	YES
6440	3295	60	NO
6441	3295	92	YES
6442	3295	58	NO
6443	3295	87	NO
6444	3295	88	NO
6445	3295	89	YES
6446	3296	46	YES
6447	3296	49	YES
6448	3296	50	YES
6449	3296	51	YES
6450	3296	52	NO
6451	3296	53	YES
6452	3296	54	NO
6453	3296	55	YES
6454	3296	56	YES
6455	3296	57	YES
6456	3296	90	NO
6457	3296	91	YES
6458	3296	60	NO
6459	3296	92	YES
6460	3296	58	YES
6461	3296	87	NO
6462	3296	88	NO
6463	3296	89	YES
6464	3297	46	YES
6465	3297	49	YES
6466	3297	50	YES
6467	3297	51	YES
6468	3297	52	NO
6469	3297	53	YES
6470	3297	54	YES
6471	3297	55	YES
6472	3297	56	YES
6473	3297	57	YES
6474	3297	90	NO
6475	3297	91	YES
6476	3297	60	NO
6477	3297	92	YES
6478	3297	58	YES
6479	3297	87	NO
6480	3297	88	NO
6481	3297	89	YES
6482	3298	46	YES
6483	3298	49	YES
6484	3298	50	YES
6485	3298	51	YES
6486	3298	52	NO
6487	3298	53	YES
6488	3298	54	YES
6489	3298	55	YES
6490	3298	56	YES
6491	3298	57	YES
6492	3298	90	NO
6493	3298	91	YES
6494	3298	60	NO
6495	3298	92	NO
6496	3298	58	YES
6497	3298	87	NO
6498	3298	88	NO
6499	3298	89	YES
6500	3299	46	YES
6501	3299	49	NO
6502	3299	50	NO
6503	3299	51	YES
6504	3299	52	NO
6505	3299	53	YES
6506	3299	54	YES
6507	3299	55	YES
6508	3299	56	YES
6509	3299	57	YES
6510	3299	90	YES
6511	3299	91	YES
6512	3299	60	NO
6513	3299	92	NO
6514	3299	58	YES
6515	3299	87	NO
6516	3299	88	NO
6517	3299	89	YES
6518	3300	46	NO
6519	3300	49	NO
6520	3300	50	YES
6521	3300	51	YES
6522	3300	52	YES
6523	3300	53	YES
6524	3300	54	YES
6525	3300	55	YES
6526	3300	56	YES
6527	3300	57	YES
6528	3300	90	YES
6529	3300	91	YES
6530	3300	60	NO
6531	3300	92	NO
6532	3300	58	NO
6533	3300	87	NO
6534	3300	88	NO
6535	3300	89	YES
6536	3301	46	YES
6537	3301	49	YES
6538	3301	50	YES
6539	3301	51	YES
6540	3301	52	NO
6541	3301	53	YES
6542	3301	54	YES
6543	3301	55	YES
6544	3301	56	YES
6545	3301	57	YES
6546	3301	90	NO
6547	3301	91	YES
6548	3301	60	NO
6549	3301	92	NO
6550	3301	58	NO
6551	3301	87	NO
6552	3301	88	NO
6553	3301	89	YES
6554	3302	46	YES
6555	3302	49	YES
6556	3302	50	YES
6557	3302	51	YES
6558	3302	52	NO
6559	3302	53	YES
6560	3302	54	YES
6561	3302	55	YES
6562	3302	56	YES
6563	3302	57	YES
6564	3302	90	NO
6565	3302	91	YES
6566	3302	60	NO
6567	3302	92	NO
6568	3302	58	NO
6569	3302	87	NO
6570	3302	88	NO
6571	3302	89	YES
6572	3173	46	YES
6573	3173	49	YES
6574	3173	50	NO
6575	3173	51	YES
6576	3173	52	NO
6577	3173	53	YES
6578	3173	54	YES
6579	3173	55	YES
6580	3173	56	YES
6581	3173	57	YES
6582	3173	90	NO
6583	3173	91	YES
6584	3173	60	NO
6585	3173	92	NO
6586	3173	58	YES
6587	3173	87	NO
6588	3173	88	NO
6589	3173	89	YES
6590	3303	46	YES
6591	3303	49	YES
6592	3303	50	YES
6593	3303	51	YES
6594	3303	52	NO
6595	3303	53	YES
6596	3303	54	YES
6597	3303	55	YES
6598	3303	56	YES
6599	3303	57	YES
6600	3303	90	NO
6601	3303	91	YES
6602	3303	60	NO
6603	3303	92	YES
6604	3303	58	YES
6605	3303	87	YES
6606	3303	88	YES
6607	3303	89	YES
6608	3304	46	YES
6609	3304	49	NO
6610	3304	50	NO
6611	3304	51	YES
6612	3304	52	NO
6613	3304	53	YES
6614	3304	54	YES
6615	3304	55	YES
6616	3304	56	YES
6617	3304	57	YES
6618	3304	90	NO
6619	3304	91	YES
6620	3304	60	NO
6621	3304	92	YES
6622	3304	58	YES
6623	3304	87	YES
6624	3304	88	YES
6625	3304	89	YES
6626	3305	46	YES
6627	3305	49	YES
6628	3305	50	NO
6629	3305	51	YES
6630	3305	52	NO
6631	3305	53	YES
6632	3305	54	YES
6633	3305	55	YES
6634	3305	56	YES
6635	3305	57	YES
6636	3305	90	NO
6637	3305	91	YES
6638	3305	60	YES
6639	3305	92	YES
6640	3305	58	YES
6641	3305	87	YES
6642	3305	88	YES
6643	3305	89	YES
6644	3306	46	YES
6645	3306	49	YES
6646	3306	50	NO
6647	3306	51	YES
6648	3306	52	NO
6649	3306	53	YES
6650	3306	54	YES
6651	3306	55	YES
6652	3306	56	YES
6653	3306	57	YES
6654	3306	90	NO
6655	3306	91	YES
6656	3306	60	NO
6657	3306	92	YES
6658	3306	58	YES
6659	3306	87	YES
6660	3306	88	YES
6661	3306	89	YES
6662	3307	46	YES
6663	3307	49	YES
6664	3307	50	NO
6665	3307	51	NO
6666	3307	52	NO
6667	3307	53	YES
6668	3307	54	YES
6669	3307	55	YES
6670	3307	56	YES
6671	3307	57	YES
6672	3307	90	NO
6673	3307	91	YES
6674	3307	60	NO
6675	3307	92	YES
6676	3307	58	YES
6677	3307	87	YES
6678	3307	88	YES
6679	3307	89	YES
6680	3308	46	YES
6681	3308	49	YES
6682	3308	50	NO
6683	3308	51	NO
6684	3308	52	YES
6685	3308	53	YES
6686	3308	54	YES
6687	3308	55	YES
6688	3308	56	YES
6689	3308	57	YES
6690	3308	90	NO
6691	3308	91	YES
6692	3308	60	NO
6693	3308	92	YES
6694	3308	58	YES
6695	3308	87	YES
6696	3308	88	YES
6697	3308	89	YES
6698	3309	46	YES
6699	3309	49	NO
6700	3309	50	NO
6701	3309	51	YES
6702	3309	52	YES
6703	3309	53	YES
6704	3309	54	YES
6705	3309	55	YES
6706	3309	56	YES
6707	3309	57	YES
6708	3309	90	YES
6709	3309	91	YES
6710	3309	60	NO
6711	3309	92	YES
6712	3309	58	YES
6713	3309	87	YES
6714	3309	88	YES
6715	3309	89	YES
6716	3314	57	yes
6717	3314	56	yes
6718	3314	49	yes
6719	3314	50	yes
6720	3314	52	yes
6721	3310	79	yes
6722	3310	81	yes
6723	3310	84	yes
6724	3310	85	yes
6725	3310	86	yes
6726	3310	63	yes
6727	3310	64	yes
6728	3310	65	yes
6729	3310	67	yes
6730	3310	68	yes
6731	3310	69	yes
6732	3310	71	yes
6733	3310	72	yes
6734	3310	73	yes
6735	3310	74	yes
6736	3310	75	yes
6737	3310	76	yes
6738	3310	78	yes
6739	3311	46	yes
6740	3311	49	yes
6741	3311	50	yes
6742	3311	51	yes
6743	3311	52	yes
6744	3311	54	yes
6745	3311	55	yes
6746	3311	56	yes
6747	3311	90	yes
6748	3311	91	yes
6749	3311	92	yes
6750	3311	58	yes
6751	3311	88	yes
6752	3312	46	yes
6753	3312	49	yes
6754	3312	58	yes
6755	3312	51	yes
6756	3312	52	yes
6757	3312	54	yes
6758	3312	55	yes
6759	3312	56	yes
6760	3312	57	yes
6761	3312	90	yes
6762	3312	91	yes
6763	3312	92	yes
6764	3312	87	yes
6765	3312	88	yes
6766	3312	89	yes
6767	3315	80	yes
6768	3315	84	yes
6769	3315	85	yes
6770	3315	86	yes
6771	3315	64	yes
6772	3315	65	yes
6773	3315	66	yes
6774	3315	69	yes
6775	3315	72	yes
6776	3315	73	yes
6777	3315	74	yes
6778	3317	46	yes
6779	3317	49	yes
6780	3317	50	yes
6781	3317	52	yes
6782	3317	54	yes
6783	3317	87	yes
6784	3317	56	yes
6785	3317	89	yes
6786	3317	90	yes
6787	3317	91	yes
6788	3317	92	yes
6789	3317	58	yes
6790	3317	88	yes
6791	3318	58	yes
6792	3318	52	yes
6793	3318	55	yes
6794	3318	56	yes
6795	3318	57	yes
6796	3318	90	yes
6797	3318	91	yes
6798	3318	92	yes
6799	3318	87	yes
6800	3318	88	yes
6801	3318	89	yes
6802	3319	46	yes
6803	3319	87	yes
6804	3319	88	yes
6805	3319	89	yes
6806	3319	58	yes
6807	3319	91	yes
6808	3319	60	yes
6809	3319	92	yes
6810	3316	46	yes
6811	3316	56	yes
6812	3316	89	yes
6813	3316	58	yes
6814	3316	91	yes
6815	3316	60	yes
6816	3316	92	yes
6817	3320	49	yes
6818	3320	50	yes
6819	3320	52	yes
6820	3320	55	yes
6821	3320	56	yes
6822	3320	57	yes
6823	3320	90	yes
6824	3320	91	yes
6825	3320	92	yes
6826	3320	58	yes
6827	3320	88	yes
6828	3320	89	yes
6829	3321	49	yes
6830	3321	50	yes
6831	3321	54	yes
6832	3321	55	yes
6833	3321	56	yes
6834	3321	58	yes
6835	3321	91	yes
6836	3321	60	yes
6837	3321	92	yes
6838	3321	88	yes
6839	3324	58	yes
6840	3324	52	yes
6841	3324	55	yes
6842	3324	88	yes
6843	3324	57	yes
6844	3324	90	yes
6845	3324	91	yes
6846	3324	92	yes
6847	3324	87	yes
6848	3324	89	yes
6849	3322	49	yes
6850	3322	50	yes
6851	3322	52	yes
6852	3322	53	yes
6853	3322	54	yes
6854	3322	55	yes
6855	3322	56	yes
6856	3322	57	yes
6857	3322	90	yes
6858	3322	91	yes
6859	3322	92	yes
6860	3322	58	yes
6861	3322	87	yes
6862	3322	88	yes
6863	3322	89	yes
6864	3323	58	yes
6865	3323	52	yes
6866	3323	53	yes
6867	3323	54	yes
6868	3323	55	yes
6869	3323	56	yes
6870	3323	57	yes
6871	3323	90	yes
6872	3323	91	yes
6873	3323	92	yes
6874	3323	87	yes
6875	3323	88	yes
6876	3323	89	yes
6877	3325	46	YES
6878	3325	49	YES
6879	3325	50	YES
6880	3325	51	YES
6881	3325	52	NO
6882	3325	53	YES
6883	3325	54	YES
6884	3325	55	YES
6885	3325	56	NO
6886	3325	57	YES
6887	3325	90	YES
6888	3325	91	NO
6889	3325	60	NO
6890	3325	92	NO
6891	3325	58	YES
6892	3325	87	NO
6893	3325	88	NO
6894	3325	89	YES
6895	3326	46	YES
6896	3326	49	NO
6897	3326	50	YES
6898	3326	51	YES
6899	3326	52	NO
6900	3326	53	YES
6901	3326	54	YES
6902	3326	55	YES
6903	3326	56	NO
6904	3326	57	NO
6905	3326	90	YES
6906	3326	91	NO
6907	3326	60	NO
6908	3326	92	NO
6909	3326	58	YES
6910	3326	87	NO
6911	3326	88	NO
6912	3326	89	YES
6913	3327	46	YES
6914	3327	49	YES
6915	3327	50	NO
6916	3327	51	YES
6917	3327	52	NO
6918	3327	53	YES
6919	3327	54	YES
6920	3327	55	YES
6921	3327	56	NO
6922	3327	57	NO
6923	3327	90	YES
6924	3327	91	NO
6925	3327	60	NO
6926	3327	92	NO
6927	3327	58	YES
6928	3327	87	NO
6929	3327	88	NO
6930	3327	89	YES
6931	3328	46	YES
6932	3328	49	YES
6933	3328	50	YES
6934	3328	51	YES
6935	3328	52	NO
6936	3328	53	YES
6937	3328	54	YES
6938	3328	55	NO
6939	3328	56	NO
6940	3328	57	NO
6941	3328	90	YES
6942	3328	91	NO
6943	3328	60	NO
6944	3328	92	NO
6945	3328	58	YES
6946	3328	87	NO
6947	3328	88	NO
6948	3328	89	YES
6949	3329	46	YES
6950	3329	49	YES
6951	3329	50	NO
6952	3329	51	YES
6953	3329	52	NO
6954	3329	53	YES
6955	3329	54	YES
6956	3329	55	YES
6957	3329	56	NO
6958	3329	57	YES
6959	3329	90	YES
6960	3329	91	NO
6961	3329	60	NO
6962	3329	92	NO
6963	3329	58	YES
6964	3329	87	NO
6965	3329	88	NO
6966	3329	89	YES
6967	3330	46	YES
6968	3330	49	YES
6969	3330	50	NO
6970	3330	51	NO
6971	3330	52	NO
6972	3330	53	YES
6973	3330	54	YES
6974	3330	55	YES
6975	3330	56	NO
6976	3330	57	NO
6977	3330	90	YES
6978	3330	91	NO
6979	3330	60	YES
6980	3330	92	NO
6981	3330	58	YES
6982	3330	87	NO
6983	3330	88	NO
6984	3330	89	YES
6985	3331	46	YES
6986	3331	49	YES
6987	3331	50	NO
6988	3331	51	YES
6989	3331	52	NO
6990	3331	53	YES
6991	3331	54	YES
6992	3331	55	YES
6993	3331	56	NO
6994	3331	57	NO
6995	3331	90	YES
6996	3331	91	NO
6997	3331	60	NO
6998	3331	92	NO
6999	3331	58	YES
7000	3331	87	NO
7001	3331	88	NO
7002	3331	89	YES
7003	3332	46	YES
7004	3332	49	YES
7005	3332	50	YES
7006	3332	51	YES
7007	3332	52	YES
7008	3332	53	YES
7009	3332	54	YES
7010	3332	55	YES
7011	3332	56	NO
7012	3332	57	YES
7013	3332	90	YES
7014	3332	91	NO
7015	3332	60	NO
7016	3332	92	NO
7017	3332	58	NO
7018	3332	87	NO
7019	3332	88	NO
7020	3332	89	YES
7021	3333	46	YES
7022	3333	49	YES
7023	3333	50	YES
7024	3333	51	YES
7025	3333	52	YES
7026	3333	53	YES
7027	3333	54	YES
7028	3333	55	YES
7029	3333	56	NO
7030	3333	57	YES
7031	3333	90	YES
7032	3333	91	NO
7033	3333	60	NO
7034	3333	92	NO
7035	3333	58	NO
7036	3333	87	NO
7037	3333	88	NO
7038	3333	89	YES
7039	3334	46	YES
7040	3334	49	YES
7041	3334	50	NO
7042	3334	51	NO
7043	3334	52	NO
7044	3334	53	NO
7045	3334	54	NO
7046	3334	55	YES
7047	3334	56	NO
7048	3334	57	NO
7049	3334	90	YES
7050	3334	91	NO
7051	3334	60	NO
7052	3334	92	NO
7053	3334	58	NO
7054	3334	87	NO
7055	3334	88	NO
7056	3334	89	YES
7057	3335	46	YES
7058	3335	49	YES
7059	3335	50	NO
7060	3335	51	YES
7061	3335	52	NO
7062	3335	53	YES
7063	3335	54	YES
7064	3335	55	YES
7065	3335	56	NO
7066	3335	57	YES
7067	3335	90	YES
7068	3335	91	NO
7069	3335	60	NO
7070	3335	92	NO
7071	3335	58	NO
7072	3335	87	NO
7073	3335	88	NO
7074	3335	89	YES
7075	3336	46	YES
7076	3336	49	YES
7077	3336	50	NO
7078	3336	51	YES
7079	3336	52	NO
7080	3336	53	NO
7081	3336	54	YES
7082	3336	55	YES
7083	3336	56	NO
7084	3336	57	NO
7085	3336	90	YES
7086	3336	91	NO
7087	3336	60	NO
7088	3336	92	NO
7089	3336	58	YES
7090	3336	87	NO
7091	3336	88	NO
7092	3336	89	YES
7093	3337	46	YES
7094	3337	49	YES
7095	3337	50	NO
7096	3337	51	YES
7097	3337	52	NO
7098	3337	53	YES
7099	3337	54	YES
7100	3337	55	YES
7101	3337	56	NO
7102	3337	57	NO
7103	3337	90	YES
7104	3337	91	NO
7105	3337	60	NO
7106	3337	92	NO
7107	3337	58	YES
7108	3337	87	NO
7109	3337	88	NO
7110	3337	89	YES
7111	3338	46	YES
7112	3338	49	YES
7113	3338	50	NO
7114	3338	51	NO
7115	3338	52	NO
7116	3338	53	YES
7117	3338	54	YES
7118	3338	55	YES
7119	3338	56	NO
7120	3338	57	NO
7121	3338	90	YES
7122	3338	91	NO
7123	3338	60	NO
7124	3338	92	NO
7125	3338	58	YES
7126	3338	87	NO
7127	3338	88	NO
7128	3338	89	YES
7129	3339	46	YES
7130	3339	49	YES
7131	3339	50	NO
7132	3339	51	YES
7133	3339	52	NO
7134	3339	53	YES
7135	3339	54	YES
7136	3339	55	YES
7137	3339	56	NO
7138	3339	57	NO
7139	3339	90	NO
7140	3339	91	YES
7141	3339	60	NO
7142	3339	92	NO
7143	3339	58	YES
7144	3339	87	NO
7145	3339	88	NO
7146	3339	89	YES
7147	3340	46	YES
7148	3340	49	YES
7149	3340	50	NO
7150	3340	51	YES
7151	3340	52	NO
7152	3340	53	YES
7153	3340	54	YES
7154	3340	55	NO
7155	3340	56	NO
7156	3340	57	NO
7157	3340	90	YES
7158	3340	91	NO
7159	3340	60	NO
7160	3340	92	NO
7161	3340	58	NO
7162	3340	87	NO
7163	3340	88	NO
7164	3340	89	YES
7165	3341	46	YES
7166	3341	49	YES
7167	3341	50	YES
7168	3341	51	YES
7169	3341	52	YES
7170	3341	53	YES
7171	3341	54	YES
7172	3341	55	NO
7173	3341	56	NO
7174	3341	57	YES
7175	3341	90	YES
7176	3341	91	NO
7177	3341	60	NO
7178	3341	92	NO
7179	3341	58	YES
7180	3341	87	NO
7181	3341	88	NO
7182	3341	89	YES
7183	3342	46	YES
7184	3342	49	YES
7185	3342	50	NO
7186	3342	51	YES
7187	3342	52	NO
7188	3342	53	YES
7189	3342	54	YES
7190	3342	55	YES
7191	3342	56	NO
7192	3342	57	NO
7193	3342	90	YES
7194	3342	91	NO
7195	3342	60	NO
7196	3342	92	NO
7197	3342	58	YES
7198	3342	87	NO
7199	3342	88	NO
7200	3342	89	YES
7201	2942	46	YES
7202	2942	49	YES
7203	2942	50	NO
7204	2942	51	YES
7205	2942	52	NO
7206	2942	53	YES
7207	2942	54	NO
7208	2942	55	NO
7209	2942	56	NO
7210	2942	57	NO
7211	2942	90	YES
7212	2942	91	YES
7213	2942	60	NO
7214	2942	92	NO
7215	2942	58	YES
7216	2942	87	NO
7217	2942	88	NO
7218	2942	89	YES
7219	3343	46	YES
7220	3343	49	YES
7221	3343	50	NO
7222	3343	51	YES
7223	3343	52	NO
7224	3343	53	YES
7225	3343	54	YES
7226	3343	55	NO
7227	3343	56	NO
7228	3343	57	YES
7229	3343	90	YES
7230	3343	91	YES
7231	3343	60	NO
7232	3343	92	NO
7233	3343	58	YES
7234	3343	87	NO
7235	3343	88	NO
7236	3343	89	YES
7237	3344	46	YES
7238	3344	49	YES
7239	3344	50	YES
7240	3344	51	YES
7241	3344	52	NO
7242	3344	53	YES
7243	3344	54	YES
7244	3344	55	YES
7245	3344	56	NO
7246	3344	57	NO
7247	3344	90	YES
7248	3344	91	NO
7249	3344	60	NO
7250	3344	92	NO
7251	3344	58	YES
7252	3344	87	NO
7253	3344	88	NO
7254	3344	89	YES
7255	3345	46	YES
7256	3345	49	YES
7257	3345	50	NO
7258	3345	51	YES
7259	3345	52	NO
7260	3345	53	YES
7261	3345	54	YES
7262	3345	55	YES
7263	3345	56	NO
7264	3345	57	NO
7265	3345	90	YES
7266	3345	91	NO
7267	3345	60	NO
7268	3345	92	NO
7269	3345	58	YES
7270	3345	87	NO
7271	3345	88	NO
7272	3345	89	YES
7273	3346	46	YES
7274	3346	49	YES
7275	3346	50	NO
7276	3346	51	YES
7277	3346	52	NO
7278	3346	53	YES
7279	3346	54	YES
7280	3346	55	NO
7281	3346	56	NO
7282	3346	57	NO
7283	3346	90	YES
7284	3346	91	NO
7285	3346	60	NO
7286	3346	92	NO
7287	3346	58	NO
7288	3346	87	NO
7289	3346	88	NO
7290	3346	89	YES
7291	3347	46	YES
7292	3347	49	NO
7293	3347	50	YES
7294	3347	51	NO
7295	3347	52	NO
7296	3347	53	YES
7297	3347	54	NO
7298	3347	55	NO
7299	3347	56	YES
7300	3347	57	YES
7301	3347	90	YES
7302	3347	91	NO
7303	3347	60	NO
7304	3347	92	NO
7305	3347	58	NO
7306	3347	87	YES
7307	3347	88	NO
7308	3347	89	YES
7309	3348	46	YES
7310	3348	49	YES
7311	3348	50	YES
7312	3348	51	NO
7313	3348	52	YES
7314	3348	53	YES
7315	3348	54	YES
7316	3348	55	YES
7317	3348	56	YES
7318	3348	57	YES
7319	3348	90	YES
7320	3348	91	YES
7321	3348	60	NO
7322	3348	92	YES
7323	3348	58	YES
7324	3348	87	YES
7325	3348	88	YES
7326	3348	89	YES
7327	3349	46	YES
7328	3349	49	YES
7329	3349	50	YES
7330	3349	51	NO
7331	3349	52	YES
7332	3349	53	YES
7333	3349	54	YES
7334	3349	55	YES
7335	3349	56	YES
7336	3349	57	YES
7337	3349	90	YES
7338	3349	91	YES
7339	3349	60	NO
7340	3349	92	YES
7341	3349	58	YES
7342	3349	87	YES
7343	3349	88	YES
7344	3349	89	YES
7345	3350	46	YES
7346	3350	49	YES
7347	3350	50	YES
7348	3350	51	YES
7349	3350	52	YES
7350	3350	53	YES
7351	3350	54	NO
7352	3350	55	YES
7353	3350	56	YES
7354	3350	57	YES
7355	3350	90	YES
7356	3350	91	YES
7357	3350	60	NO
7358	3350	92	YES
7359	3350	58	YES
7360	3350	87	YES
7361	3350	88	YES
7362	3350	89	YES
7363	3351	46	YES
7364	3351	49	YES
7365	3351	50	YES
7366	3351	51	YES
7367	3351	52	YES
7368	3351	53	YES
7369	3351	54	YES
7370	3351	55	YES
7371	3351	56	YES
7372	3351	57	YES
7373	3351	90	YES
7374	3351	91	YES
7375	3351	60	NO
7376	3351	92	YES
7377	3351	58	YES
7378	3351	87	YES
7379	3351	88	YES
7380	3351	89	YES
7381	3352	46	YES
7382	3352	49	YES
7383	3352	50	YES
7384	3352	51	NO
7385	3352	52	YES
7386	3352	53	YES
7387	3352	54	YES
7388	3352	55	NO
7389	3352	56	YES
7390	3352	57	YES
7391	3352	90	NO
7392	3352	91	YES
7393	3352	60	NO
7394	3352	92	YES
7395	3352	58	YES
7396	3352	87	YES
7397	3352	88	YES
7398	3352	89	YES
7399	3353	46	YES
7400	3353	49	NO
7401	3353	50	YES
7402	3353	51	NO
7403	3353	52	NO
7404	3353	53	YES
7405	3353	54	NO
7406	3353	55	NO
7407	3353	56	YES
7408	3353	57	YES
7409	3353	90	NO
7410	3353	91	YES
7411	3353	60	NO
7412	3353	92	YES
7413	3353	58	YES
7414	3353	87	YES
7415	3353	88	YES
7416	3353	89	YES
7417	3354	46	YES
7418	3354	49	YES
7419	3354	50	YES
7420	3354	51	YES
7421	3354	52	YES
7422	3354	53	YES
7423	3354	54	YES
7424	3354	55	YES
7425	3354	56	YES
7426	3354	57	YES
7427	3354	90	YES
7428	3354	91	YES
7429	3354	60	NO
7430	3354	92	YES
7431	3354	58	YES
7432	3354	87	YES
7433	3354	88	YES
7434	3354	89	YES
7435	3355	46	YES
7436	3355	49	YES
7437	3355	50	YES
7438	3355	51	YES
7439	3355	52	YES
7440	3355	53	YES
7441	3355	54	YES
7442	3355	55	YES
7443	3355	56	YES
7444	3355	57	YES
7445	3355	90	YES
7446	3355	91	YES
7447	3355	60	NO
7448	3355	92	YES
7449	3355	58	YES
7450	3355	87	YES
7451	3355	88	YES
7452	3355	89	YES
7453	3356	46	YES
7454	3356	49	YES
7455	3356	50	YES
7456	3356	51	YES
7457	3356	52	YES
7458	3356	53	YES
7459	3356	54	YES
7460	3356	55	YES
7461	3356	56	YES
7462	3356	57	YES
7463	3356	90	YES
7464	3356	91	NO
7465	3356	60	NO
7466	3356	92	NO
7467	3356	58	NO
7468	3356	87	YES
7469	3356	88	YES
7470	3356	89	YES
7471	3357	46	YES
7472	3357	49	YES
7473	3357	50	YES
7474	3357	51	YES
7475	3357	52	NO
7476	3357	53	YES
7477	3357	54	YES
7478	3357	55	YES
7479	3357	56	YES
7480	3357	57	YES
7481	3357	90	NO
7482	3357	91	NO
7483	3357	60	NO
7484	3357	92	YES
7485	3357	58	NO
7486	3357	87	YES
7487	3357	88	YES
7488	3357	89	YES
7489	3358	46	YES
7490	3358	49	YES
7491	3358	50	YES
7492	3358	51	YES
7493	3358	52	NO
7494	3358	53	YES
7495	3358	54	NO
7496	3358	55	YES
7497	3358	56	YES
7498	3358	57	YES
7499	3358	90	YES
7500	3358	91	YES
7501	3358	60	NO
7502	3358	92	NO
7503	3358	58	YES
7504	3358	87	YES
7505	3358	88	YES
7506	3358	89	YES
7507	3359	46	YES
7508	3359	49	YES
7509	3359	50	YES
7510	3359	51	NO
7511	3359	52	NO
7512	3359	53	YES
7513	3359	54	YES
7514	3359	55	YES
7515	3359	56	YES
7516	3359	57	YES
7517	3359	90	NO
7518	3359	91	YES
7519	3359	60	NO
7520	3359	92	NO
7521	3359	58	NO
7522	3359	87	YES
7523	3359	88	YES
7524	3359	89	YES
7525	3360	46	YES
7526	3360	49	YES
7527	3360	50	YES
7528	3360	51	YES
7529	3360	52	YES
7530	3360	53	YES
7531	3360	54	YES
7532	3360	55	YES
7533	3360	56	YES
7534	3360	57	YES
7535	3360	90	YES
7536	3360	91	NO
7537	3360	60	NO
7538	3360	92	NO
7539	3360	58	NO
7540	3360	87	YES
7541	3360	88	YES
7542	3360	89	YES
7543	3361	46	YES
7544	3361	49	YES
7545	3361	50	YES
7546	3361	51	YES
7547	3361	52	YES
7548	3361	53	YES
7549	3361	54	YES
7550	3361	55	YES
7551	3361	56	YES
7552	3361	57	YES
7553	3361	90	YES
7554	3361	91	YES
7555	3361	60	NO
7556	3361	92	YES
7557	3361	58	YES
7558	3361	87	YES
7559	3361	88	YES
7560	3361	89	YES
7561	3362	46	YES
7562	3362	49	YES
7563	3362	50	YES
7564	3362	51	NO
7565	3362	52	YES
7566	3362	53	YES
7567	3362	54	YES
7568	3362	55	YES
7569	3362	56	YES
7570	3362	57	YES
7571	3362	90	YES
7572	3362	91	NO
7573	3362	60	NO
7574	3362	92	NO
7575	3362	58	NO
7576	3362	87	YES
7577	3362	88	YES
7578	3362	89	YES
7579	3363	46	YES
7580	3363	49	YES
7581	3363	50	YES
7582	3363	51	YES
7583	3363	52	NO
7584	3363	53	NO
7585	3363	54	YES
7586	3363	55	NO
7587	3363	56	YES
7588	3363	57	YES
7589	3363	90	NO
7590	3363	91	NO
7591	3363	60	YES
7592	3363	92	NO
7593	3363	58	NO
7594	3363	87	YES
7595	3363	88	YES
7596	3363	89	YES
7597	3364	46	YES
7598	3364	49	YES
7599	3364	50	YES
7600	3364	51	YES
7601	3364	52	YES
7602	3364	53	YES
7603	3364	54	YES
7604	3364	55	YES
7605	3364	56	YES
7606	3364	57	YES
7607	3364	90	YES
7608	3364	91	YES
7609	3364	60	NO
7610	3364	92	YES
7611	3364	58	NO
7612	3364	87	YES
7613	3364	88	YES
7614	3364	89	YES
7615	3365	46	YES
7616	3365	49	YES
7617	3365	50	YES
7618	3365	51	YES
7619	3365	52	YES
7620	3365	53	YES
7621	3365	54	YES
7622	3365	55	YES
7623	3365	56	YES
7624	3365	57	YES
7625	3365	90	YES
7626	3365	91	YES
7627	3365	60	NO
7628	3365	92	NO
7629	3365	58	NO
7630	3365	87	YES
7631	3365	88	YES
7632	3365	89	YES
7633	3366	46	YES
7634	3366	49	YES
7635	3366	50	YES
7636	3366	51	YES
7637	3366	52	YES
7638	3366	53	YES
7639	3366	54	YES
7640	3366	55	YES
7641	3366	56	YES
7642	3366	57	YES
7643	3366	90	YES
7644	3366	91	YES
7645	3366	60	NO
7646	3366	92	YES
7647	3366	58	NO
7648	3366	87	YES
7649	3366	88	YES
7650	3366	89	YES
7651	3367	46	YES
7652	3367	49	NO
7653	3367	50	YES
7654	3367	51	YES
7655	3367	52	NO
7656	3367	53	NO
7657	3367	54	YES
7658	3367	55	NO
7659	3367	56	YES
7660	3367	57	YES
7661	3367	90	YES
7662	3367	91	YES
7663	3367	60	NO
7664	3367	92	YES
7665	3367	58	YES
7666	3367	87	YES
7667	3367	88	YES
7668	3367	89	YES
7669	3368	46	YES
7670	3368	49	YES
7671	3368	50	YES
7672	3368	51	NO
7673	3368	52	YES
7674	3368	53	NO
7675	3368	54	YES
7676	3368	55	NO
7677	3368	56	YES
7678	3368	57	YES
7679	3368	90	NO
7680	3368	91	YES
7681	3368	60	NO
7682	3368	92	YES
7683	3368	58	YES
7684	3368	87	YES
7685	3368	88	YES
7686	3368	89	YES
7687	3369	46	YES
7688	3369	49	YES
7689	3369	50	YES
7690	3369	51	YES
7691	3369	52	NO
7692	3369	53	YES
7693	3369	54	YES
7694	3369	55	YES
7695	3369	56	YES
7696	3369	57	YES
7697	3369	90	NO
7698	3369	91	YES
7699	3369	60	NO
7700	3369	92	NO
7701	3369	58	YES
7702	3369	87	YES
7703	3369	88	YES
7704	3369	89	YES
7705	3370	46	YES
7706	3370	49	YES
7707	3370	50	YES
7708	3370	51	NO
7709	3370	52	YES
7710	3370	53	YES
7711	3370	54	YES
7712	3370	55	YES
7713	3370	56	YES
7714	3370	57	YES
7715	3370	90	YES
7716	3370	91	YES
7717	3370	60	NO
7718	3370	92	YES
7719	3370	58	YES
7720	3370	87	YES
7721	3370	88	YES
7722	3370	89	YES
7723	3371	46	YES
7724	3371	49	YES
7725	3371	50	NO
7726	3371	51	NO
7727	3371	52	NO
7728	3371	53	YES
7729	3371	54	NO
7730	3371	55	NO
7731	3371	56	YES
7732	3371	57	YES
7733	3371	90	NO
7734	3371	91	NO
7735	3371	60	NO
7736	3371	92	NO
7737	3371	58	NO
7738	3371	87	YES
7739	3371	88	NO
7740	3371	89	YES
7741	3372	46	YES
7742	3372	49	YES
7743	3372	50	YES
7744	3372	51	NO
7745	3372	52	NO
7746	3372	53	YES
7747	3372	54	YES
7748	3372	55	YES
7749	3372	56	YES
7750	3372	57	YES
7751	3372	90	NO
7752	3372	91	YES
7753	3372	60	NO
7754	3372	92	YES
7755	3372	58	YES
7756	3372	87	YES
7757	3372	88	YES
7758	3372	89	YES
7759	3373	46	YES
7760	3373	49	YES
7761	3373	50	YES
7762	3373	51	YES
7763	3373	52	YES
7764	3373	53	YES
7765	3373	54	YES
7766	3373	55	NO
7767	3373	56	YES
7768	3373	57	YES
7769	3373	90	YES
7770	3373	91	YES
7771	3373	60	NO
7772	3373	92	NO
7773	3373	58	YES
7774	3373	87	YES
7775	3373	88	YES
7776	3373	89	YES
7777	3374	46	YES
7778	3374	49	YES
7779	3374	50	YES
7780	3374	51	YES
7781	3374	52	YES
7782	3374	53	YES
7783	3374	54	YES
7784	3374	55	YES
7785	3374	56	YES
7786	3374	57	YES
7787	3374	90	NO
7788	3374	91	YES
7789	3374	60	NO
7790	3374	92	YES
7791	3374	58	YES
7792	3374	87	YES
7793	3374	88	YES
7794	3374	89	YES
7795	3375	46	YES
7796	3375	49	NO
7797	3375	50	NO
7798	3375	51	YES
7799	3375	52	NO
7800	3375	53	YES
7801	3375	54	YES
7802	3375	55	YES
7803	3375	56	NO
7804	3375	57	YES
7805	3375	90	NO
7806	3375	91	NO
7807	3375	60	YES
7808	3375	92	NO
7809	3375	58	YES
7810	3375	87	NO
7811	3375	88	NO
7812	3375	89	YES
7813	3376	46	YES
7814	3376	49	YES
7815	3376	50	YES
7816	3376	51	YES
7817	3376	52	NO
7818	3376	53	YES
7819	3376	54	NO
7820	3376	55	NO
7821	3376	56	YES
7822	3376	57	YES
7823	3376	90	NO
7824	3376	91	NO
7825	3376	60	YES
7826	3376	92	NO
7827	3376	58	YES
7828	3376	87	YES
7829	3376	88	YES
7830	3376	89	YES
7831	3377	46	YES
7832	3377	49	YES
7833	3377	50	YES
7834	3377	51	YES
7835	3377	52	NO
7836	3377	53	YES
7837	3377	54	YES
7838	3377	55	YES
7839	3377	56	YES
7840	3377	57	YES
7841	3377	90	YES
7842	3377	91	NO
7843	3377	60	NO
7844	3377	92	NO
7845	3377	58	NO
7846	3377	87	YES
7847	3377	88	NO
7848	3377	89	YES
7849	3378	46	YES
7850	3378	49	YES
7851	3378	50	YES
7852	3378	51	YES
7853	3378	52	NO
7854	3378	53	YES
7855	3378	54	YES
7856	3378	55	YES
7857	3378	56	YES
7858	3378	57	YES
7859	3378	90	YES
7860	3378	91	NO
7861	3378	60	NO
7862	3378	92	NO
7863	3378	58	YES
7864	3378	87	YES
7865	3378	88	YES
7866	3378	89	YES
7867	3379	46	YES
7868	3379	49	YES
7869	3379	50	YES
7870	3379	51	YES
7871	3379	52	NO
7872	3379	53	YES
7873	3379	54	YES
7874	3379	55	YES
7875	3379	56	YES
7876	3379	57	YES
7877	3379	90	YES
7878	3379	91	NO
7879	3379	60	NO
7880	3379	92	NO
7881	3379	58	NO
7882	3379	87	YES
7883	3379	88	YES
7884	3379	89	YES
7885	3380	46	YES
7886	3380	49	YES
7887	3380	50	YES
7888	3380	51	YES
7889	3380	52	NO
7890	3380	53	YES
7891	3380	54	YES
7892	3380	55	YES
7893	3380	56	NO
7894	3380	57	YES
7895	3380	90	YES
7896	3380	91	NO
7897	3380	60	NO
7898	3380	92	NO
7899	3380	58	YES
7900	3380	87	NO
7901	3380	88	NO
7902	3380	89	YES
7903	3381	46	YES
7904	3381	49	YES
7905	3381	50	YES
7906	3381	51	YES
7907	3381	52	NO
7908	3381	53	YES
7909	3381	54	YES
7910	3381	55	YES
7911	3381	56	YES
7912	3381	57	YES
7913	3381	90	YES
7914	3381	91	NO
7915	3381	60	NO
7916	3381	92	NO
7917	3381	58	YES
7918	3381	87	YES
7919	3381	88	NO
7920	3381	89	YES
7921	3382	46	YES
7922	3382	49	YES
7923	3382	50	YES
7924	3382	51	YES
7925	3382	52	NO
7926	3382	53	YES
7927	3382	54	NO
7928	3382	55	YES
7929	3382	56	YES
7930	3382	57	YES
7931	3382	90	NO
7932	3382	91	NO
7933	3382	60	NO
7934	3382	92	NO
7935	3382	58	NO
7936	3382	87	YES
7937	3382	88	YES
7938	3382	89	YES
7939	3383	46	YES
7940	3383	49	YES
7941	3383	50	YES
7942	3383	51	YES
7943	3383	52	NO
7944	3383	53	YES
7945	3383	54	NO
7946	3383	55	YES
7947	3383	56	YES
7948	3383	57	YES
7949	3383	90	NO
7950	3383	91	NO
7951	3383	60	NO
7952	3383	92	NO
7953	3383	58	YES
7954	3383	87	YES
7955	3383	88	NO
7956	3383	89	YES
7957	3384	46	YES
7958	3384	49	YES
7959	3384	50	NO
7960	3384	51	YES
7961	3384	52	NO
7962	3384	53	YES
7963	3384	54	YES
7964	3384	55	YES
7965	3384	56	YES
7966	3384	57	YES
7967	3384	90	YES
7968	3384	91	NO
7969	3384	60	YES
7970	3384	92	NO
7971	3384	58	YES
7972	3384	87	YES
7973	3384	88	NO
7974	3384	89	YES
7975	3385	46	YES
7976	3385	49	YES
7977	3385	50	YES
7978	3385	51	YES
7979	3385	52	NO
7980	3385	53	YES
7981	3385	54	NO
7982	3385	55	YES
7983	3385	56	NO
7984	3385	57	YES
7985	3385	90	YES
7986	3385	91	NO
7987	3385	60	NO
7988	3385	92	NO
7989	3385	58	YES
7990	3385	87	NO
7991	3385	88	NO
7992	3385	89	YES
7993	3386	46	YES
7994	3386	49	YES
7995	3386	50	YES
7996	3386	51	YES
7997	3386	52	NO
7998	3386	53	YES
7999	3386	54	YES
8000	3386	55	YES
8001	3386	56	NO
8002	3386	57	YES
8003	3386	90	YES
8004	3386	91	NO
8005	3386	60	NO
8006	3386	92	NO
8007	3386	58	YES
8008	3386	87	NO
8009	3386	88	NO
8010	3386	89	YES
8011	3387	46	YES
8012	3387	49	YES
8013	3387	50	YES
8014	3387	51	YES
8015	3387	52	NO
8016	3387	53	YES
8017	3387	54	YES
8018	3387	55	YES
8019	3387	56	YES
8020	3387	57	YES
8021	3387	90	YES
8022	3387	91	NO
8023	3387	60	NO
8024	3387	92	NO
8025	3387	58	YES
8026	3387	87	YES
8027	3387	88	NO
8028	3387	89	YES
8029	3388	46	YES
8030	3388	49	YES
8031	3388	50	YES
8032	3388	51	YES
8033	3388	52	NO
8034	3388	53	YES
8035	3388	54	NO
8036	3388	55	YES
8037	3388	56	NO
8038	3388	57	YES
8039	3388	90	NO
8040	3388	91	NO
8041	3388	60	NO
8042	3388	92	NO
8043	3388	58	YES
8044	3388	87	NO
8045	3388	88	NO
8046	3388	89	YES
8047	3389	46	YES
8048	3389	49	YES
8049	3389	50	NO
8050	3389	51	YES
8051	3389	52	NO
8052	3389	53	NO
8053	3389	54	NO
8054	3389	55	YES
8055	3389	56	NO
8056	3389	57	NO
8057	3389	90	NO
8058	3389	91	NO
8059	3389	60	YES
8060	3389	92	NO
8061	3389	58	YES
8062	3389	87	NO
8063	3389	88	NO
8064	3389	89	YES
8065	3390	46	YES
8066	3390	49	YES
8067	3390	50	YES
8068	3390	51	YES
8069	3390	52	NO
8070	3390	53	YES
8071	3390	54	YES
8072	3390	55	YES
8073	3390	56	NO
8074	3390	57	YES
8075	3390	90	NO
8076	3390	91	NO
8077	3390	60	YES
8078	3390	92	NO
8079	3390	58	YES
8080	3390	87	NO
8081	3390	88	NO
8082	3390	89	YES
8083	3391	46	YES
8084	3391	49	YES
8085	3391	50	NO
8086	3391	51	YES
8087	3391	52	NO
8088	3391	53	YES
8089	3391	54	YES
8090	3391	55	NO
8091	3391	56	NO
8092	3391	57	YES
8093	3391	90	NO
8094	3391	91	NO
8095	3391	60	YES
8096	3391	92	NO
8097	3391	58	YES
8098	3391	87	NO
8099	3391	88	NO
8100	3391	89	YES
8101	3392	46	YES
8102	3392	49	YES
8103	3392	50	YES
8104	3392	51	YES
8105	3392	52	NO
8106	3392	53	YES
8107	3392	54	YES
8108	3392	55	YES
8109	3392	56	YES
8110	3392	57	YES
8111	3392	90	YES
8112	3392	91	NO
8113	3392	60	NO
8114	3392	92	NO
8115	3392	58	YES
8116	3392	87	YES
8117	3392	88	NO
8118	3392	89	YES
8119	3393	46	YES
8120	3393	49	YES
8121	3393	50	YES
8122	3393	51	YES
8123	3393	52	NO
8124	3393	53	YES
8125	3393	54	YES
8126	3393	55	YES
8127	3393	56	NO
8128	3393	57	YES
8129	3393	90	NO
8130	3393	91	NO
8131	3393	60	NO
8132	3393	92	NO
8133	3393	58	YES
8134	3393	87	NO
8135	3393	88	NO
8136	3393	89	YES
8137	3394	46	YES
8138	3394	49	NO
8139	3394	50	NO
8140	3394	51	NO
8141	3394	52	NO
8142	3394	53	NO
8143	3394	54	NO
8144	3394	55	NO
8145	3394	56	NO
8146	3394	57	NO
8147	3394	90	NO
8148	3394	91	NO
8149	3394	60	NO
8150	3394	92	NO
8151	3394	58	YES
8152	3394	87	NO
8153	3394	88	NO
8154	3394	89	NO
8155	3059	46	YES
8156	3059	49	NO
8157	3059	50	NO
8158	3059	51	NO
8159	3059	52	YES
8160	3059	53	YES
8161	3059	54	NO
8162	3059	55	YES
8163	3059	56	NO
8164	3059	57	NO
8165	3059	90	NO
8166	3059	91	NO
8167	3059	60	NO
8168	3059	92	NO
8169	3059	58	YES
8170	3059	87	NO
8171	3059	88	NO
8172	3059	89	YES
8173	3395	46	YES
8174	3395	49	YES
8175	3395	50	NO
8176	3395	51	YES
8177	3395	52	YES
8178	3395	53	YES
8179	3395	54	YES
8180	3395	55	YES
8181	3395	56	NO
8182	3395	57	YES
8183	3395	90	YES
8184	3395	91	NO
8185	3395	60	NO
8186	3395	92	NO
8187	3395	58	YES
8188	3395	87	NO
8189	3395	88	NO
8190	3395	89	YES
8191	3396	46	YES
8192	3396	49	YES
8193	3396	50	NO
8194	3396	51	NO
8195	3396	52	NO
8196	3396	53	YES
8197	3396	54	YES
8198	3396	55	YES
8199	3396	56	NO
8200	3396	57	YES
8201	3396	90	YES
8202	3396	91	NO
8203	3396	60	NO
8204	3396	92	NO
8205	3396	58	YES
8206	3396	87	NO
8207	3396	88	NO
8208	3396	89	YES
8209	3397	46	YES
8210	3397	49	YES
8211	3397	50	NO
8212	3397	51	NO
8213	3397	52	NO
8214	3397	53	YES
8215	3397	54	YES
8216	3397	55	NO
8217	3397	56	NO
8218	3397	57	NO
8219	3397	90	NO
8220	3397	91	NO
8221	3397	60	NO
8222	3397	92	NO
8223	3397	58	YES
8224	3397	87	NO
8225	3397	88	NO
8226	3397	89	YES
8227	3398	46	YES
8228	3398	49	YES
8229	3398	50	NO
8230	3398	51	NO
8231	3398	52	YES
8232	3398	53	YES
8233	3398	54	YES
8234	3398	55	NO
8235	3398	56	NO
8236	3398	57	NO
8237	3398	90	YES
8238	3398	91	NO
8239	3398	60	NO
8240	3398	92	NO
8241	3398	58	YES
8242	3398	87	NO
8243	3398	88	NO
8244	3398	89	YES
8245	3399	46	YES
8246	3399	49	YES
8247	3399	50	YES
8248	3399	51	YES
8249	3399	52	YES
8250	3399	53	YES
8251	3399	54	NO
8252	3399	55	YES
8253	3399	56	NO
8254	3399	57	YES
8255	3399	90	YES
8256	3399	91	NO
8257	3399	60	NO
8258	3399	92	NO
8259	3399	58	YES
8260	3399	87	NO
8261	3399	88	NO
8262	3399	89	YES
8263	3400	46	YES
8264	3400	49	YES
8265	3400	50	YES
8266	3400	51	YES
8267	3400	52	YES
8268	3400	53	YES
8269	3400	54	YES
8270	3400	55	YES
8271	3400	56	NO
8272	3400	57	NO
8273	3400	90	YES
8274	3400	91	NO
8275	3400	60	NO
8276	3400	92	NO
8277	3400	58	YES
8278	3400	87	NO
8279	3400	88	NO
8280	3400	89	YES
8281	3401	46	YES
8282	3401	49	YES
8283	3401	50	YES
8284	3401	51	NO
8285	3401	52	YES
8286	3401	53	YES
8287	3401	54	YES
8288	3401	55	YES
8289	3401	56	NO
8290	3401	57	YES
8291	3401	90	YES
8292	3401	91	NO
8293	3401	60	NO
8294	3401	92	NO
8295	3401	58	NO
8296	3401	87	NO
8297	3401	88	NO
8298	3401	89	NO
8299	3402	46	YES
8300	3402	49	YES
8301	3402	50	YES
8302	3402	51	YES
8303	3402	52	YES
8304	3402	53	YES
8305	3402	54	YES
8306	3402	55	YES
8307	3402	56	NO
8308	3402	57	NO
8309	3402	90	YES
8310	3402	91	NO
8311	3402	60	NO
8312	3402	92	NO
8313	3402	58	NO
8314	3402	87	NO
8315	3402	88	NO
8316	3402	89	YES
8317	3403	46	YES
8318	3403	49	YES
8319	3403	50	YES
8320	3403	51	NO
8321	3403	52	NO
8322	3403	53	NO
8323	3403	54	YES
8324	3403	55	NO
8325	3403	56	NO
8326	3403	57	NO
8327	3403	90	NO
8328	3403	91	NO
8329	3403	60	NO
8330	3403	92	NO
8331	3403	58	YES
8332	3403	87	NO
8333	3403	88	NO
8334	3403	89	NO
8335	3404	46	YES
8336	3404	49	YES
8337	3404	50	YES
8338	3404	51	YES
8339	3404	52	YES
8340	3404	53	YES
8341	3404	54	YES
8342	3404	55	NO
8343	3404	56	YES
8344	3404	57	YES
8345	3404	90	YES
8346	3404	91	NO
8347	3404	60	NO
8348	3404	92	NO
8349	3404	58	YES
8350	3404	87	YES
8351	3404	88	NO
8352	3404	89	YES
8353	3405	46	YES
8354	3405	49	YES
8355	3405	50	NO
8356	3405	51	NO
8357	3405	52	YES
8358	3405	53	NO
8359	3405	54	YES
8360	3405	55	YES
8361	3405	56	YES
8362	3405	57	NO
8363	3405	90	NO
8364	3405	91	NO
8365	3405	60	NO
8366	3405	92	NO
8367	3405	58	YES
8368	3405	87	NO
8369	3405	88	NO
8370	3405	89	YES
8371	3406	46	YES
8372	3406	49	YES
8373	3406	50	YES
8374	3406	51	YES
8375	3406	52	NO
8376	3406	53	YES
8377	3406	54	NO
8378	3406	55	YES
8379	3406	56	NO
8380	3406	57	NO
8381	3406	90	NO
8382	3406	91	NO
8383	3406	60	NO
8384	3406	92	NO
8385	3406	58	YES
8386	3406	87	NO
8387	3406	88	NO
8388	3406	89	NO
8389	3407	46	YES
8390	3407	49	YES
8391	3407	50	YES
8392	3407	51	NO
8393	3407	52	YES
8394	3407	53	YES
8395	3407	54	YES
8396	3407	55	YES
8397	3407	56	YES
8398	3407	57	YES
8399	3407	90	YES
8400	3407	91	YES
8401	3407	60	NO
8402	3407	92	NO
8403	3407	58	YES
8404	3407	87	YES
8405	3407	88	NO
8406	3407	89	YES
8407	3408	46	YES
8408	3408	49	NO
8409	3408	50	YES
8410	3408	51	NO
8411	3408	52	NO
8412	3408	53	NO
8413	3408	54	NO
8414	3408	55	YES
8415	3408	56	NO
8416	3408	57	NO
8417	3408	90	NO
8418	3408	91	NO
8419	3408	60	NO
8420	3408	92	NO
8421	3408	58	YES
8422	3408	87	NO
8423	3408	88	NO
8424	3408	89	NO
8425	3409	46	YES
8426	3409	49	YES
8427	3409	50	YES
8428	3409	51	NO
8429	3409	52	YES
8430	3409	53	YES
8431	3409	54	YES
8432	3409	55	YES
8433	3409	56	NO
8434	3409	57	YES
8435	3409	90	NO
8436	3409	91	NO
8437	3409	60	NO
8438	3409	92	NO
8439	3409	58	YES
8440	3409	87	NO
8441	3409	88	NO
8442	3409	89	NO
8443	3410	46	YES
8444	3410	49	YES
8445	3410	50	NO
8446	3410	51	NO
8447	3410	52	YES
8448	3410	53	YES
8449	3410	54	YES
8450	3410	55	NO
8451	3410	56	YES
8452	3410	57	YES
8453	3410	90	YES
8454	3410	91	NO
8455	3410	60	NO
8456	3410	92	NO
8457	3410	58	YES
8458	3410	87	YES
8459	3410	88	NO
8460	3410	89	YES
8461	3411	46	YES
8462	3411	49	YES
8463	3411	50	NO
8464	3411	51	NO
8465	3411	52	NO
8466	3411	53	NO
8467	3411	54	NO
8468	3411	55	NO
8469	3411	56	NO
8470	3411	57	NO
8471	3411	90	NO
8472	3411	91	NO
8473	3411	60	NO
8474	3411	92	NO
8475	3411	58	YES
8476	3411	87	NO
8477	3411	88	NO
8478	3411	89	NO
8479	3412	46	YES
8480	3412	49	YES
8481	3412	50	YES
8482	3412	51	YES
8483	3412	52	YES
8484	3412	53	YES
8485	3412	54	NO
8486	3412	55	YES
8487	3412	56	NO
8488	3412	57	NO
8489	3412	90	YES
8490	3412	91	NO
8491	3412	60	NO
8492	3412	92	NO
8493	3412	58	YES
8494	3412	87	NO
8495	3412	88	NO
8496	3412	89	YES
8497	3413	46	YES
8498	3413	49	YES
8499	3413	50	YES
8500	3413	51	NO
8501	3413	52	YES
8502	3413	53	YES
8503	3413	54	NO
8504	3413	55	NO
8505	3413	56	NO
8506	3413	57	YES
8507	3413	90	YES
8508	3413	91	NO
8509	3413	60	NO
8510	3413	92	NO
8511	3413	58	YES
8512	3413	87	NO
8513	3413	88	NO
8514	3413	89	YES
8515	3414	46	YES
8516	3414	49	NO
8517	3414	50	NO
8518	3414	51	NO
8519	3414	52	YES
8520	3414	53	YES
8521	3414	54	NO
8522	3414	55	NO
8523	3414	56	NO
8524	3414	57	NO
8525	3414	90	YES
8526	3414	91	NO
8527	3414	60	NO
8528	3414	92	NO
8529	3414	58	NO
8530	3414	87	NO
8531	3414	88	NO
8532	3414	89	YES
8533	3415	46	YES
8534	3415	49	NO
8535	3415	50	YES
8536	3415	51	YES
8537	3415	52	NO
8538	3415	53	NO
8539	3415	54	NO
8540	3415	55	YES
8541	3415	56	YES
8542	3415	57	YES
8543	3415	90	NO
8544	3415	91	NO
8545	3415	60	NO
8546	3415	92	NO
8547	3415	58	YES
8548	3415	87	YES
8549	3415	88	YES
8550	3415	89	YES
8551	3416	46	YES
8552	3416	49	NO
8553	3416	50	NO
8554	3416	51	YES
8555	3416	52	NO
8556	3416	53	YES
8557	3416	54	YES
8558	3416	55	YES
8559	3416	56	NO
8560	3416	57	YES
8561	3416	90	NO
8562	3416	91	NO
8563	3416	60	YES
8564	3416	92	NO
8565	3416	58	NO
8566	3416	87	NO
8567	3416	88	NO
8568	3416	89	YES
8569	3417	46	YES
8570	3417	49	NO
8571	3417	50	YES
8572	3417	51	YES
8573	3417	52	YES
8574	3417	53	YES
8575	3417	54	YES
8576	3417	55	YES
8577	3417	56	YES
8578	3417	57	YES
8579	3417	90	YES
8580	3417	91	YES
8581	3417	60	NO
8582	3417	92	NO
8583	3417	58	YES
8584	3417	87	YES
8585	3417	88	YES
8586	3417	89	YES
8587	3418	46	YES
8588	3418	49	NO
8589	3418	50	YES
8590	3418	51	YES
8591	3418	52	NO
8592	3418	53	YES
8593	3418	54	YES
8594	3418	55	YES
8595	3418	56	NO
8596	3418	57	YES
8597	3418	90	NO
8598	3418	91	YES
8599	3418	60	YES
8600	3418	92	NO
8601	3418	58	YES
8602	3418	87	NO
8603	3418	88	NO
8604	3418	89	YES
8605	3419	46	YES
8606	3419	49	NO
8607	3419	50	YES
8608	3419	51	YES
8609	3419	52	YES
8610	3419	53	YES
8611	3419	54	NO
8612	3419	55	YES
8613	3419	56	YES
8614	3419	57	YES
8615	3419	90	NO
8616	3419	91	YES
8617	3419	60	YES
8618	3419	92	NO
8619	3419	58	YES
8620	3419	87	YES
8621	3419	88	YES
8622	3419	89	YES
8623	3420	46	YES
8624	3420	49	YES
8625	3420	50	NO
8626	3420	51	NO
8627	3420	52	NO
8628	3420	53	YES
8629	3420	54	YES
8630	3420	55	NO
8631	3420	56	YES
8632	3420	57	YES
8633	3420	90	NO
8634	3420	91	YES
8635	3420	60	YES
8636	3420	92	NO
8637	3420	58	YES
8638	3420	87	YES
8639	3420	88	YES
8640	3420	89	YES
8641	3421	46	YES
8642	3421	49	YES
8643	3421	50	NO
8644	3421	51	NO
8645	3421	52	YES
8646	3421	53	YES
8647	3421	54	YES
8648	3421	55	YES
8649	3421	56	YES
8650	3421	57	YES
8651	3421	90	YES
8652	3421	91	YES
8653	3421	60	NO
8654	3421	92	NO
8655	3421	58	YES
8656	3421	87	YES
8657	3421	88	YES
8658	3421	89	YES
8659	3422	46	YES
8660	3422	49	YES
8661	3422	50	NO
8662	3422	51	YES
8663	3422	52	YES
8664	3422	53	YES
8665	3422	54	NO
8666	3422	55	YES
8667	3422	56	YES
8668	3422	57	YES
8669	3422	90	NO
8670	3422	91	YES
8671	3422	60	NO
8672	3422	92	YES
8673	3422	58	YES
8674	3422	87	YES
8675	3422	88	YES
8676	3422	89	YES
8677	3423	46	YES
8678	3423	49	YES
8679	3423	50	NO
8680	3423	51	YES
8681	3423	52	NO
8682	3423	53	YES
8683	3423	54	YES
8684	3423	55	YES
8685	3423	56	YES
8686	3423	57	YES
8687	3423	90	NO
8688	3423	91	YES
8689	3423	60	YES
8690	3423	92	YES
8691	3423	58	YES
8692	3423	87	NO
8693	3423	88	NO
8694	3423	89	YES
8695	3424	46	YES
8696	3424	49	NO
8697	3424	50	NO
8698	3424	51	YES
8699	3424	52	NO
8700	3424	53	YES
8701	3424	54	YES
8702	3424	55	YES
8703	3424	56	NO
8704	3424	57	YES
8705	3424	90	NO
8706	3424	91	YES
8707	3424	60	NO
8708	3424	92	NO
8709	3424	58	YES
8710	3424	87	NO
8711	3424	88	NO
8712	3424	89	YES
8713	3425	46	YES
8714	3425	49	YES
8715	3425	50	NO
8716	3425	51	YES
8717	3425	52	YES
8718	3425	53	YES
8719	3425	54	YES
8720	3425	55	YES
8721	3425	56	YES
8722	3425	57	YES
8723	3425	90	YES
8724	3425	91	YES
8725	3425	60	NO
8726	3425	92	NO
8727	3425	58	YES
8728	3425	87	YES
8729	3425	88	YES
8730	3425	89	YES
8731	3426	46	YES
8732	3426	49	YES
8733	3426	50	NO
8734	3426	51	YES
8735	3426	52	YES
8736	3426	53	YES
8737	3426	54	YES
8738	3426	55	NO
8739	3426	56	YES
8740	3426	57	YES
8741	3426	90	YES
8742	3426	91	YES
8743	3426	60	YES
8744	3426	92	NO
8745	3426	58	YES
8746	3426	87	YES
8747	3426	88	YES
8748	3426	89	YES
8749	3427	46	YES
8750	3427	49	YES
8751	3427	50	YES
8752	3427	51	YES
8753	3427	52	YES
8754	3427	53	YES
8755	3427	54	YES
8756	3427	55	YES
8757	3427	56	YES
8758	3427	57	YES
8759	3427	90	YES
8760	3427	91	YES
8761	3427	60	NO
8762	3427	92	NO
8763	3427	58	YES
8764	3427	87	NO
8765	3427	88	NO
8766	3427	89	YES
8767	3428	46	YES
8768	3428	49	YES
8769	3428	50	NO
8770	3428	51	YES
8771	3428	52	YES
8772	3428	53	YES
8773	3428	54	YES
8774	3428	55	NO
8775	3428	56	YES
8776	3428	57	YES
8777	3428	90	YES
8778	3428	91	YES
8779	3428	60	NO
8780	3428	92	NO
8781	3428	58	YES
8782	3428	87	NO
8783	3428	88	NO
8784	3428	89	YES
8785	3429	46	YES
8786	3429	49	YES
8787	3429	50	YES
8788	3429	51	YES
8789	3429	52	YES
8790	3429	53	YES
8791	3429	54	YES
8792	3429	55	NO
8793	3429	56	YES
8794	3429	57	YES
8795	3429	90	NO
8796	3429	91	YES
8797	3429	60	YES
8798	3429	92	NO
8799	3429	58	YES
8800	3429	87	NO
8801	3429	88	NO
8802	3429	89	YES
8803	3430	46	YES
8804	3430	49	YES
8805	3430	50	YES
8806	3430	51	YES
8807	3430	52	YES
8808	3430	53	YES
8809	3430	54	YES
8810	3430	55	NO
8811	3430	56	NO
8812	3430	57	YES
8813	3430	90	NO
8814	3430	91	YES
8815	3430	60	YES
8816	3430	92	NO
8817	3430	58	YES
8818	3430	87	NO
8819	3430	88	NO
8820	3430	89	YES
8821	3431	46	YES
8822	3431	49	YES
8823	3431	50	YES
8824	3431	51	YES
8825	3431	52	YES
8826	3431	53	YES
8827	3431	54	YES
8828	3431	55	YES
8829	3431	56	YES
8830	3431	57	YES
8831	3431	90	NO
8832	3431	91	YES
8833	3431	60	YES
8834	3431	92	NO
8835	3431	58	YES
8836	3431	87	NO
8837	3431	88	NO
8838	3431	89	YES
8839	3432	46	YES
8840	3432	49	YES
8841	3432	50	YES
8842	3432	51	YES
8843	3432	52	YES
8844	3432	53	YES
8845	3432	54	YES
8846	3432	55	NO
8847	3432	56	NO
8848	3432	57	YES
8849	3432	90	NO
8850	3432	91	YES
8851	3432	60	YES
8852	3432	92	NO
8853	3432	58	YES
8854	3432	87	NO
8855	3432	88	NO
8856	3432	89	YES
8857	3433	46	YES
8858	3433	49	NO
8859	3433	50	YES
8860	3433	51	YES
8861	3433	52	YES
8862	3433	53	YES
8863	3433	54	YES
8864	3433	55	YES
8865	3433	56	YES
8866	3433	57	YES
8867	3433	90	NO
8868	3433	91	YES
8869	3433	60	YES
8870	3433	92	NO
8871	3433	58	YES
8872	3433	87	YES
8873	3433	88	NO
8874	3433	89	YES
8875	3434	46	YES
8876	3434	49	YES
8877	3434	50	NO
8878	3434	51	YES
8879	3434	52	YES
8880	3434	53	YES
8881	3434	54	YES
8882	3434	55	YES
8883	3434	56	YES
8884	3434	57	YES
8885	3434	90	NO
8886	3434	91	YES
8887	3434	60	YES
8888	3434	92	NO
8889	3434	58	YES
8890	3434	87	NO
8891	3434	88	NO
8892	3434	89	YES
8893	3435	46	YES
8894	3435	49	YES
8895	3435	50	YES
8896	3435	51	YES
8897	3435	52	YES
8898	3435	53	YES
8899	3435	54	YES
8900	3435	55	YES
8901	3435	56	YES
8902	3435	57	YES
8903	3435	90	YES
8904	3435	91	YES
8905	3435	60	YES
8906	3435	92	NO
8907	3435	58	YES
8908	3435	87	NO
8909	3435	88	NO
8910	3435	89	YES
8911	3436	46	YES
8912	3436	49	YES
8913	3436	50	YES
8914	3436	51	YES
8915	3436	52	YES
8916	3436	53	YES
8917	3436	54	YES
8918	3436	55	YES
8919	3436	56	YES
8920	3436	57	YES
8921	3436	90	YES
8922	3436	91	YES
8923	3436	60	NO
8924	3436	92	NO
8925	3436	58	YES
8926	3436	87	NO
8927	3436	88	NO
8928	3436	89	YES
8929	3437	46	YES
8930	3437	49	NO
8931	3437	50	NO
8932	3437	51	YES
8933	3437	52	YES
8934	3437	53	YES
8935	3437	54	YES
8936	3437	55	YES
8937	3437	56	YES
8938	3437	57	YES
8939	3437	90	NO
8940	3437	91	NO
8941	3437	60	YES
8942	3437	92	NO
8943	3437	58	YES
8944	3437	87	NO
8945	3437	88	NO
8946	3437	89	YES
8947	3438	46	YES
8948	3438	49	NO
8949	3438	50	NO
8950	3438	51	YES
8951	3438	52	NO
8952	3438	53	YES
8953	3438	54	YES
8954	3438	55	NO
8955	3438	56	YES
8956	3438	57	YES
8957	3438	90	NO
8958	3438	91	YES
8959	3438	60	YES
8960	3438	92	NO
8961	3438	58	YES
8962	3438	87	NO
8963	3438	88	NO
8964	3438	89	YES
8965	3439	46	YES
8966	3439	49	NO
8967	3439	50	NO
8968	3439	51	NO
8969	3439	52	NO
8970	3439	53	YES
8971	3439	54	YES
8972	3439	55	NO
8973	3439	56	YES
8974	3439	57	YES
8975	3439	90	NO
8976	3439	91	YES
8977	3439	60	YES
8978	3439	92	NO
8979	3439	58	YES
8980	3439	87	NO
8981	3439	88	NO
8982	3439	89	YES
8983	3440	46	YES
8984	3440	49	YES
8985	3440	50	YES
8986	3440	51	YES
8987	3440	52	NO
8988	3440	53	YES
8989	3440	54	YES
8990	3440	55	YES
8991	3440	56	NO
8992	3440	57	YES
8993	3440	90	NO
8994	3440	91	YES
8995	3440	60	YES
8996	3440	92	NO
8997	3440	58	YES
8998	3440	87	NO
8999	3440	88	NO
9000	3440	89	YES
9001	3441	46	YES
9002	3441	49	YES
9003	3441	50	NO
9004	3441	51	YES
9005	3441	52	YES
9006	3441	53	YES
9007	3441	54	YES
9008	3441	55	YES
9009	3441	56	YES
9010	3441	57	YES
9011	3441	90	NO
9012	3441	91	YES
9013	3441	60	YES
9014	3441	92	NO
9015	3441	58	YES
9016	3441	87	YES
9017	3441	88	NO
9018	3441	89	YES
9019	3442	46	YES
9020	3442	49	NO
9021	3442	50	YES
9022	3442	51	YES
9023	3442	52	NO
9024	3442	53	YES
9025	3442	54	YES
9026	3442	55	YES
9027	3442	56	YES
9028	3442	57	YES
9029	3442	90	NO
9030	3442	91	YES
9031	3442	60	YES
9032	3442	92	NO
9033	3442	58	YES
9034	3442	87	NO
9035	3442	88	NO
9036	3442	89	YES
9037	3443	46	YES
9038	3443	49	NO
9039	3443	50	YES
9040	3443	51	NO
9041	3443	52	NO
9042	3443	53	NO
9043	3443	54	YES
9044	3443	55	NO
9045	3443	56	NO
9046	3443	57	NO
9047	3443	90	NO
9048	3443	91	NO
9049	3443	60	YES
9050	3443	92	NO
9051	3443	58	NO
9052	3443	87	NO
9053	3443	88	NO
9054	3443	89	YES
9055	3444	46	YES
9056	3444	49	YES
9057	3444	50	NO
9058	3444	51	YES
9059	3444	52	YES
9060	3444	53	YES
9061	3444	54	YES
9062	3444	55	NO
9063	3444	56	YES
9064	3444	57	YES
9065	3444	90	YES
9066	3444	91	YES
9067	3444	60	NO
9068	3444	92	NO
9069	3444	58	YES
9070	3444	87	YES
9071	3444	88	YES
9072	3444	89	YES
9073	3445	46	YES
9074	3445	49	YES
9075	3445	50	NO
9076	3445	51	YES
9077	3445	52	YES
9078	3445	53	YES
9079	3445	54	YES
9080	3445	55	YES
9081	3445	56	YES
9082	3445	57	YES
9083	3445	90	NO
9084	3445	91	YES
9085	3445	60	YES
9086	3445	92	NO
9087	3445	58	YES
9088	3445	87	YES
9089	3445	88	NO
9090	3445	89	YES
9091	3446	46	YES
9092	3446	49	NO
9093	3446	50	NO
9094	3446	51	YES
9095	3446	52	NO
9096	3446	53	YES
9097	3446	54	YES
9098	3446	55	NO
9099	3446	56	NO
9100	3446	57	YES
9101	3446	90	NO
9102	3446	91	YES
9103	3446	60	YES
9104	3446	92	NO
9105	3446	58	YES
9106	3446	87	NO
9107	3446	88	NO
9108	3446	89	YES
9109	3447	46	YES
9110	3447	49	NO
9111	3447	50	NO
9112	3447	51	YES
9113	3447	52	NO
9114	3447	53	YES
9115	3447	54	YES
9116	3447	55	YES
9117	3447	56	YES
9118	3447	57	NO
9119	3447	90	NO
9120	3447	91	YES
9121	3447	60	YES
9122	3447	92	NO
9123	3447	58	YES
9124	3447	87	NO
9125	3447	88	NO
9126	3447	89	YES
9127	3448	46	YES
9128	3448	49	YES
9129	3448	50	NO
9130	3448	51	YES
9131	3448	52	NO
9132	3448	53	YES
9133	3448	54	YES
9134	3448	55	YES
9135	3448	56	NO
9136	3448	57	NO
9137	3448	90	YES
9138	3448	91	YES
9139	3448	60	YES
9140	3448	92	NO
9141	3448	58	YES
9142	3448	87	NO
9143	3448	88	NO
9144	3448	89	NO
9145	3449	46	YES
9146	3449	49	YES
9147	3449	50	YES
9148	3449	51	NO
9149	3449	52	NO
9150	3449	53	YES
9151	3449	54	NO
9152	3449	55	NO
9153	3449	56	NO
9154	3449	57	NO
9155	3449	90	NO
9156	3449	91	NO
9157	3449	60	YES
9158	3449	92	NO
9159	3449	58	YES
9160	3449	87	NO
9161	3449	88	NO
9162	3449	89	YES
9163	3450	46	YES
9164	3450	49	YES
9165	3450	50	YES
9166	3450	51	NO
9167	3450	52	NO
9168	3450	53	YES
9169	3450	54	YES
9170	3450	55	YES
9171	3450	56	YES
9172	3450	57	YES
9173	3450	90	YES
9174	3450	91	YES
9175	3450	60	NO
9176	3450	92	NO
9177	3450	58	YES
9178	3450	87	NO
9179	3450	88	NO
9180	3450	89	YES
9181	3451	46	YES
9182	3451	49	NO
9183	3451	50	NO
9184	3451	51	YES
9185	3451	52	NO
9186	3451	53	YES
9187	3451	54	YES
9188	3451	55	YES
9189	3451	56	NO
9190	3451	57	YES
9191	3451	90	NO
9192	3451	91	YES
9193	3451	60	NO
9194	3451	92	NO
9195	3451	58	YES
9196	3451	87	NO
9197	3451	88	NO
9198	3451	89	YES
9199	3452	46	YES
9200	3452	49	NO
9201	3452	50	YES
9202	3452	51	YES
9203	3452	52	YES
9204	3452	53	YES
9205	3452	54	YES
9206	3452	55	YES
9207	3452	56	YES
9208	3452	57	YES
9209	3452	90	YES
9210	3452	91	YES
9211	3452	60	YES
9212	3452	92	YES
9213	3452	58	YES
9214	3452	87	NO
9215	3452	88	YES
9216	3452	89	YES
9217	3453	46	YES
9218	3453	49	YES
9219	3453	50	NO
9220	3453	51	NO
9221	3453	52	NO
9222	3453	53	YES
9223	3453	54	YES
9224	3453	55	NO
9225	3453	56	NO
9226	3453	57	YES
9227	3453	90	NO
9228	3453	91	YES
9229	3453	60	NO
9230	3453	92	YES
9231	3453	58	YES
9232	3453	87	NO
9233	3453	88	NO
9234	3453	89	YES
9235	3454	46	YES
9236	3454	49	YES
9237	3454	50	YES
9238	3454	51	YES
9239	3454	52	YES
9240	3454	53	YES
9241	3454	54	YES
9242	3454	55	YES
9243	3454	56	YES
9244	3454	57	YES
9245	3454	90	YES
9246	3454	91	YES
9247	3454	60	NO
9248	3454	92	NO
9249	3454	58	YES
9250	3454	87	NO
9251	3454	88	YES
9252	3454	89	YES
9253	3455	46	YES
9254	3455	49	NO
9255	3455	50	NO
9256	3455	51	NO
9257	3455	52	NO
9258	3455	53	YES
9259	3455	54	YES
9260	3455	55	YES
9261	3455	56	NO
9262	3455	57	NO
9263	3455	90	NO
9264	3455	91	YES
9265	3455	60	NO
9266	3455	92	NO
9267	3455	58	YES
9268	3455	87	NO
9269	3455	88	NO
9270	3455	89	YES
9271	3456	46	YES
9272	3456	49	YES
9273	3456	50	NO
9274	3456	51	NO
9275	3456	52	NO
9276	3456	53	YES
9277	3456	54	YES
9278	3456	55	NO
9279	3456	56	NO
9280	3456	57	YES
9281	3456	90	YES
9282	3456	91	YES
9283	3456	60	YES
9284	3456	92	NO
9285	3456	58	YES
9286	3456	87	NO
9287	3456	88	NO
9288	3456	89	YES
9289	3457	46	YES
9290	3457	49	NO
9291	3457	50	YES
9292	3457	51	YES
9293	3457	52	YES
9294	3457	53	YES
9295	3457	54	YES
9296	3457	55	YES
9297	3457	56	YES
9298	3457	57	YES
9299	3457	90	NO
9300	3457	91	YES
9301	3457	60	NO
9302	3457	92	NO
9303	3457	58	YES
9304	3457	87	NO
9305	3457	88	YES
9306	3457	89	YES
9307	3458	46	YES
9308	3458	49	NO
9309	3458	50	NO
9310	3458	51	YES
9311	3458	52	NO
9312	3458	53	YES
9313	3458	54	YES
9314	3458	55	YES
9315	3458	56	YES
9316	3458	57	YES
9317	3458	90	NO
9318	3458	91	YES
9319	3458	60	NO
9320	3458	92	NO
9321	3458	58	YES
9322	3458	87	YES
9323	3458	88	YES
9324	3458	89	YES
9325	3459	46	YES
9326	3459	49	NO
9327	3459	50	YES
9328	3459	51	NO
9329	3459	52	NO
9330	3459	53	YES
9331	3459	54	YES
9332	3459	55	NO
9333	3459	56	NO
9334	3459	57	YES
9335	3459	90	NO
9336	3459	91	YES
9337	3459	60	NO
9338	3459	92	NO
9339	3459	58	YES
9340	3459	87	NO
9341	3459	88	NO
9342	3459	89	YES
9343	3460	46	YES
9344	3460	49	YES
9345	3460	50	YES
9346	3460	51	YES
9347	3460	52	YES
9348	3460	53	YES
9349	3460	54	YES
9350	3460	55	YES
9351	3460	56	YES
9352	3460	57	YES
9353	3460	90	YES
9354	3460	91	YES
9355	3460	60	NO
9356	3460	92	NO
9357	3460	58	YES
9358	3460	87	YES
9359	3460	88	NO
9360	3460	89	YES
9361	3461	46	YES
9362	3461	49	NO
9363	3461	50	YES
9364	3461	51	YES
9365	3461	52	NO
9366	3461	53	YES
9367	3461	54	NO
9368	3461	55	YES
9369	3461	56	YES
9370	3461	57	YES
9371	3461	90	NO
9372	3461	91	YES
9373	3461	60	NO
9374	3461	92	NO
9375	3461	58	YES
9376	3461	87	NO
9377	3461	88	YES
9378	3461	89	YES
9379	3462	46	YES
9380	3462	49	NO
9381	3462	50	NO
9382	3462	51	NO
9383	3462	52	NO
9384	3462	53	YES
9385	3462	54	NO
9386	3462	55	YES
9387	3462	56	NO
9388	3462	57	NO
9389	3462	90	NO
9390	3462	91	YES
9391	3462	60	YES
9392	3462	92	NO
9393	3462	58	YES
9394	3462	87	NO
9395	3462	88	NO
9396	3462	89	YES
9397	3463	46	YES
9398	3463	49	NO
9399	3463	50	NO
9400	3463	51	NO
9401	3463	52	NO
9402	3463	53	YES
9403	3463	54	NO
9404	3463	55	NO
9405	3463	56	NO
9406	3463	57	YES
9407	3463	90	NO
9408	3463	91	YES
9409	3463	60	YES
9410	3463	92	NO
9411	3463	58	YES
9412	3463	87	NO
9413	3463	88	NO
9414	3463	89	YES
9415	3464	46	YES
9416	3464	49	YES
9417	3464	50	YES
9418	3464	51	YES
9419	3464	52	NO
9420	3464	53	YES
9421	3464	54	NO
9422	3464	55	YES
9423	3464	56	YES
9424	3464	57	YES
9425	3464	90	NO
9426	3464	91	YES
9427	3464	60	YES
9428	3464	92	NO
9429	3464	58	YES
9430	3464	87	NO
9431	3464	88	YES
9432	3464	89	YES
9433	3465	46	YES
9434	3465	49	NO
9435	3465	50	NO
9436	3465	51	YES
9437	3465	52	NO
9438	3465	53	NO
9439	3465	54	NO
9440	3465	55	YES
9441	3465	56	YES
9442	3465	57	YES
9443	3465	90	NO
9444	3465	91	YES
9445	3465	60	YES
9446	3465	92	NO
9447	3465	58	YES
9448	3465	87	NO
9449	3465	88	YES
9450	3465	89	YES
9451	3466	46	YES
9452	3466	49	NO
9453	3466	50	YES
9454	3466	51	YES
9455	3466	52	NO
9456	3466	53	YES
9457	3466	54	YES
9458	3466	55	YES
9459	3466	56	NO
9460	3466	57	NO
9461	3466	90	NO
9462	3466	91	YES
9463	3466	60	YES
9464	3466	92	NO
9465	3466	58	YES
9466	3466	87	NO
9467	3466	88	NO
9468	3466	89	YES
9469	3467	46	YES
9470	3467	49	NO
9471	3467	50	NO
9472	3467	51	YES
9473	3467	52	NO
9474	3467	53	YES
9475	3467	54	NO
9476	3467	55	YES
9477	3467	56	NO
9478	3467	57	YES
9479	3467	90	NO
9480	3467	91	YES
9481	3467	60	YES
9482	3467	92	NO
9483	3467	58	YES
9484	3467	87	NO
9485	3467	88	NO
9486	3467	89	NO
9487	3468	46	YES
9488	3468	49	NO
9489	3468	50	YES
9490	3468	51	YES
9491	3468	52	NO
9492	3468	53	YES
9493	3468	54	YES
9494	3468	55	NO
9495	3468	56	YES
9496	3468	57	YES
9497	3468	90	YES
9498	3468	91	YES
9499	3468	60	NO
9500	3468	92	NO
9501	3468	58	YES
9502	3468	87	NO
9503	3468	88	YES
9504	3468	89	YES
9505	3469	46	YES
9506	3469	49	YES
9507	3469	50	YES
9508	3469	51	YES
9509	3469	52	YES
9510	3469	53	YES
9511	3469	54	YES
9512	3469	55	YES
9513	3469	56	YES
9514	3469	57	YES
9515	3469	90	NO
9516	3469	91	YES
9517	3469	60	YES
9518	3469	92	NO
9519	3469	58	YES
9520	3469	87	NO
9521	3469	88	NO
9522	3469	89	YES
9523	3470	46	YES
9524	3470	49	YES
9525	3470	50	YES
9526	3470	51	NO
9527	3470	52	NO
9528	3470	53	YES
9529	3470	54	NO
9530	3470	55	YES
9531	3470	56	NO
9532	3470	57	YES
9533	3470	90	NO
9534	3470	91	NO
9535	3470	60	NO
9536	3470	92	NO
9537	3470	58	YES
9538	3470	87	NO
9539	3470	88	NO
9540	3470	89	YES
9541	3471	46	YES
9542	3471	49	YES
9543	3471	50	NO
9544	3471	51	YES
9545	3471	52	NO
9546	3471	53	YES
9547	3471	54	NO
9548	3471	55	YES
9549	3471	56	YES
9550	3471	57	YES
9551	3471	90	NO
9552	3471	91	NO
9553	3471	60	YES
9554	3471	92	NO
9555	3471	58	YES
9556	3471	87	NO
9557	3471	88	NO
9558	3471	89	YES
9559	3472	46	YES
9560	3472	49	YES
9561	3472	50	NO
9562	3472	51	YES
9563	3472	52	NO
9564	3472	53	YES
9565	3472	54	YES
9566	3472	55	YES
9567	3472	56	YES
9568	3472	57	YES
9569	3472	90	YES
9570	3472	91	YES
9571	3472	60	NO
9572	3472	92	NO
9573	3472	58	YES
9574	3472	87	NO
9575	3472	88	NO
9576	3472	89	YES
9577	3473	46	NO
9578	3473	49	YES
9579	3473	50	NO
9580	3473	51	NO
9581	3473	52	NO
9582	3473	53	NO
9583	3473	54	NO
9584	3473	55	YES
9585	3473	56	YES
9586	3473	57	NO
9587	3473	90	NO
9588	3473	91	YES
9589	3473	60	YES
9590	3473	92	YES
9591	3473	58	YES
9592	3473	87	NO
9593	3473	88	NO
9594	3473	89	YES
9595	3474	46	YES
9596	3474	49	YES
9597	3474	50	YES
9598	3474	51	NO
9599	3474	52	YES
9600	3474	53	YES
9601	3474	54	YES
9602	3474	55	YES
9603	3474	56	YES
9604	3474	57	YES
9605	3474	90	NO
9606	3474	91	YES
9607	3474	60	YES
9608	3474	92	NO
9609	3474	58	YES
9610	3474	87	NO
9611	3474	88	NO
9612	3474	89	YES
9613	3475	46	YES
9614	3475	49	YES
9615	3475	50	YES
9616	3475	51	YES
9617	3475	52	NO
9618	3475	53	YES
9619	3475	54	YES
9620	3475	55	YES
9621	3475	56	NO
9622	3475	57	YES
9623	3475	90	NO
9624	3475	91	NO
9625	3475	60	YES
9626	3475	92	NO
9627	3475	58	YES
9628	3475	87	NO
9629	3475	88	NO
9630	3475	89	YES
9631	3476	46	YES
9632	3476	49	YES
9633	3476	50	YES
9634	3476	51	YES
9635	3476	52	NO
9636	3476	53	YES
9637	3476	54	YES
9638	3476	55	YES
9639	3476	56	NO
9640	3476	57	YES
9641	3476	90	NO
9642	3476	91	NO
9643	3476	60	YES
9644	3476	92	NO
9645	3476	58	YES
9646	3476	87	NO
9647	3476	88	NO
9648	3476	89	YES
9649	3477	46	YES
9650	3477	49	YES
9651	3477	50	YES
9652	3477	51	YES
9653	3477	52	YES
9654	3477	53	YES
9655	3477	54	YES
9656	3477	55	YES
9657	3477	56	YES
9658	3477	57	YES
9659	3477	90	NO
9660	3477	91	NO
9661	3477	60	YES
9662	3477	92	NO
9663	3477	58	YES
9664	3477	87	NO
9665	3477	88	NO
9666	3477	89	YES
9667	3478	46	YES
9668	3478	49	YES
9669	3478	50	YES
9670	3478	51	NO
9671	3478	52	NO
9672	3478	53	YES
9673	3478	54	YES
9674	3478	55	YES
9675	3478	56	YES
9676	3478	57	YES
9677	3478	90	NO
9678	3478	91	NO
9679	3478	60	YES
9680	3478	92	NO
9681	3478	58	YES
9682	3478	87	NO
9683	3478	88	NO
9684	3478	89	YES
9685	3479	46	YES
9686	3479	49	YES
9687	3479	50	YES
9688	3479	51	NO
9689	3479	52	NO
9690	3479	53	YES
9691	3479	54	YES
9692	3479	55	YES
9693	3479	56	YES
9694	3479	57	YES
9695	3479	90	YES
9696	3479	91	YES
9697	3479	60	NO
9698	3479	92	NO
9699	3479	58	YES
9700	3479	87	NO
9701	3479	88	NO
9702	3479	89	YES
9703	3480	46	YES
9704	3480	49	YES
9705	3480	50	YES
9706	3480	51	NO
9707	3480	52	NO
9708	3480	53	YES
9709	3480	54	NO
9710	3480	55	NO
9711	3480	56	NO
9712	3480	57	YES
9713	3480	90	NO
9714	3480	91	NO
9715	3480	60	NO
9716	3480	92	NO
9717	3480	58	YES
9718	3480	87	NO
9719	3480	88	NO
9720	3480	89	YES
9721	3481	46	YES
9722	3481	49	YES
9723	3481	50	NO
9724	3481	51	YES
9725	3481	52	NO
9726	3481	53	YES
9727	3481	54	NO
9728	3481	55	YES
9729	3481	56	YES
9730	3481	57	NO
9731	3481	90	NO
9732	3481	91	YES
9733	3481	60	YES
9734	3481	92	NO
9735	3481	58	YES
9736	3481	87	NO
9737	3481	88	NO
9738	3481	89	YES
9739	3482	46	YES
9740	3482	49	YES
9741	3482	50	YES
9742	3482	51	YES
9743	3482	52	NO
9744	3482	53	YES
9745	3482	54	YES
9746	3482	55	YES
9747	3482	56	YES
9748	3482	57	YES
9749	3482	90	YES
9750	3482	91	YES
9751	3482	60	NO
9752	3482	92	NO
9753	3482	58	YES
9754	3482	87	NO
9755	3482	88	NO
9756	3482	89	YES
9757	3483	46	YES
9758	3483	49	YES
9759	3483	50	NO
9760	3483	51	YES
9761	3483	52	YES
9762	3483	53	YES
9763	3483	54	NO
9764	3483	55	YES
9765	3483	56	YES
9766	3483	57	YES
9767	3483	90	NO
9768	3483	91	YES
9769	3483	60	NO
9770	3483	92	NO
9771	3483	58	YES
9772	3483	87	NO
9773	3483	88	NO
9774	3483	89	YES
9775	3484	46	YES
9776	3484	49	NO
9777	3484	50	NO
9778	3484	51	NO
9779	3484	52	NO
9780	3484	53	NO
9781	3484	54	NO
9782	3484	55	NO
9783	3484	56	NO
9784	3484	57	NO
9785	3484	90	NO
9786	3484	91	NO
9787	3484	60	YES
9788	3484	92	NO
9789	3484	58	NO
9790	3484	87	NO
9791	3484	88	NO
9792	3484	89	YES
9793	3485	46	YES
9794	3485	49	YES
9795	3485	50	YES
9796	3485	51	YES
9797	3485	52	YES
9798	3485	53	YES
9799	3485	54	YES
9800	3485	55	YES
9801	3485	56	YES
9802	3485	57	YES
9803	3485	90	YES
9804	3485	91	YES
9805	3485	60	YES
9806	3485	92	NO
9807	3485	58	YES
9808	3485	87	NO
9809	3485	88	NO
9810	3485	89	YES
9811	3486	46	YES
9812	3486	49	YES
9813	3486	50	YES
9814	3486	51	YES
9815	3486	52	NO
9816	3486	53	YES
9817	3486	54	YES
9818	3486	55	YES
9819	3486	56	YES
9820	3486	57	YES
9821	3486	90	YES
9822	3486	91	YES
9823	3486	60	NO
9824	3486	92	NO
9825	3486	58	YES
9826	3486	87	NO
9827	3486	88	NO
9828	3486	89	YES
9829	3487	46	YES
9830	3487	49	YES
9831	3487	50	YES
9832	3487	51	YES
9833	3487	52	NO
9834	3487	53	YES
9835	3487	54	YES
9836	3487	55	YES
9837	3487	56	YES
9838	3487	57	YES
9839	3487	90	NO
9840	3487	91	YES
9841	3487	60	NO
9842	3487	92	NO
9843	3487	58	YES
9844	3487	87	NO
9845	3487	88	NO
9846	3487	89	NO
9847	3488	46	YES
9848	3488	49	YES
9849	3488	50	YES
9850	3488	51	NO
9851	3488	52	YES
9852	3488	53	YES
9853	3488	54	YES
9854	3488	55	YES
9855	3488	56	YES
9856	3488	57	YES
9857	3488	90	NO
9858	3488	91	NO
9859	3488	60	NO
9860	3488	92	NO
9861	3488	58	YES
9862	3488	87	NO
9863	3488	88	YES
9864	3488	89	YES
9865	3489	46	YES
9866	3489	49	YES
9867	3489	50	YES
9868	3489	51	YES
9869	3489	52	YES
9870	3489	53	YES
9871	3489	54	YES
9872	3489	55	NO
9873	3489	56	NO
9874	3489	57	YES
9875	3489	90	YES
9876	3489	91	NO
9877	3489	60	NO
9878	3489	92	YES
9879	3489	58	YES
9880	3489	87	NO
9881	3489	88	NO
9882	3489	89	YES
9883	3490	46	YES
9884	3490	49	YES
9885	3490	50	NO
9886	3490	51	YES
9887	3490	52	YES
9888	3490	53	YES
9889	3490	54	YES
9890	3490	55	YES
9891	3490	56	YES
9892	3490	57	YES
9893	3490	90	YES
9894	3490	91	NO
9895	3490	60	NO
9896	3490	92	NO
9897	3490	58	YES
9898	3490	87	YES
9899	3490	88	YES
9900	3490	89	YES
9901	3491	46	YES
9902	3491	49	YES
9903	3491	50	NO
9904	3491	51	YES
9905	3491	52	NO
9906	3491	53	YES
9907	3491	54	YES
9908	3491	55	NO
9909	3491	56	NO
9910	3491	57	YES
9911	3491	90	YES
9912	3491	91	NO
9913	3491	60	YES
9914	3491	92	NO
9915	3491	58	YES
9916	3491	87	NO
9917	3491	88	NO
9918	3491	89	YES
9919	3492	46	YES
9920	3492	49	YES
9921	3492	50	YES
9922	3492	51	YES
9923	3492	52	NO
9924	3492	53	YES
9925	3492	54	YES
9926	3492	55	YES
9927	3492	56	NO
9928	3492	57	YES
9929	3492	90	YES
9930	3492	91	NO
9931	3492	60	NO
9932	3492	92	NO
9933	3492	58	YES
9934	3492	87	NO
9935	3492	88	NO
9936	3492	89	YES
9937	3493	46	YES
9938	3493	49	YES
9939	3493	50	YES
9940	3493	51	YES
9941	3493	52	NO
9942	3493	53	YES
9943	3493	54	NO
9944	3493	55	NO
9945	3493	56	NO
9946	3493	57	YES
9947	3493	90	YES
9948	3493	91	NO
9949	3493	60	NO
9950	3493	92	NO
9951	3493	58	YES
9952	3493	87	NO
9953	3493	88	NO
9954	3493	89	YES
9955	3494	46	YES
9956	3494	49	YES
9957	3494	50	YES
9958	3494	51	YES
9959	3494	52	NO
9960	3494	53	YES
9961	3494	54	NO
9962	3494	55	YES
9963	3494	56	YES
9964	3494	57	YES
9965	3494	90	YES
9966	3494	91	NO
9967	3494	60	NO
9968	3494	92	NO
9969	3494	58	YES
9970	3494	87	YES
9971	3494	88	YES
9972	3494	89	YES
9973	3495	46	YES
9974	3495	49	YES
9975	3495	50	YES
9976	3495	51	YES
9977	3495	52	NO
9978	3495	53	YES
9979	3495	54	YES
9980	3495	55	YES
9981	3495	56	YES
9982	3495	57	YES
9983	3495	90	NO
9984	3495	91	NO
9985	3495	60	YES
9986	3495	92	NO
9987	3495	58	NO
9988	3495	87	NO
9989	3495	88	YES
9990	3495	89	YES
9991	3496	46	YES
9992	3496	49	YES
9993	3496	50	YES
9994	3496	51	YES
9995	3496	52	NO
9996	3496	53	YES
9997	3496	54	YES
9998	3496	55	NO
9999	3496	56	YES
10000	3496	57	YES
10001	3496	90	NO
10002	3496	91	NO
10003	3496	60	YES
10004	3496	92	NO
10005	3496	58	NO
10006	3496	87	YES
10007	3496	88	YES
10008	3496	89	YES
10009	3497	46	YES
10010	3497	49	YES
10011	3497	50	YES
10012	3497	51	YES
10013	3497	52	NO
10014	3497	53	YES
10015	3497	54	NO
10016	3497	55	YES
10017	3497	56	YES
10018	3497	57	YES
10019	3497	90	YES
10020	3497	91	NO
10021	3497	60	NO
10022	3497	92	NO
10023	3497	58	NO
10024	3497	87	YES
10025	3497	88	YES
10026	3497	89	YES
10027	3498	46	YES
10028	3498	49	YES
10029	3498	50	NO
10030	3498	51	YES
10031	3498	52	NO
10032	3498	53	NO
10033	3498	54	YES
10034	3498	55	YES
10035	3498	56	NO
10036	3498	57	YES
10037	3498	90	YES
10038	3498	91	NO
10039	3498	60	NO
10040	3498	92	NO
10041	3498	58	YES
10042	3498	87	NO
10043	3498	88	NO
10044	3498	89	YES
10045	3499	46	YES
10046	3499	49	YES
10047	3499	50	YES
10048	3499	51	YES
10049	3499	52	NO
10050	3499	53	YES
10051	3499	54	NO
10052	3499	55	NO
10053	3499	56	NO
10054	3499	57	YES
10055	3499	90	NO
10056	3499	91	NO
10057	3499	60	YES
10058	3499	92	NO
10059	3499	58	NO
10060	3499	87	NO
10061	3499	88	NO
10062	3499	89	YES
10063	3500	46	YES
10064	3500	49	YES
10065	3500	50	YES
10066	3500	51	YES
10067	3500	52	YES
10068	3500	53	YES
10069	3500	54	YES
10070	3500	55	YES
10071	3500	56	NO
10072	3500	57	YES
10073	3500	90	YES
10074	3500	91	NO
10075	3500	60	NO
10076	3500	92	NO
10077	3500	58	NO
10078	3500	87	NO
10079	3500	88	NO
10080	3500	89	YES
10081	3501	46	YES
10082	3501	49	YES
10083	3501	50	YES
10084	3501	51	YES
10085	3501	52	NO
10086	3501	53	YES
10087	3501	54	NO
10088	3501	55	YES
10089	3501	56	YES
10090	3501	57	YES
10091	3501	90	YES
10092	3501	91	NO
10093	3501	60	NO
10094	3501	92	NO
10095	3501	58	NO
10096	3501	87	YES
10097	3501	88	YES
10098	3501	89	YES
10099	3502	46	YES
10100	3502	49	YES
10101	3502	50	NO
10102	3502	51	YES
10103	3502	52	NO
10104	3502	53	YES
10105	3502	54	NO
10106	3502	55	YES
10107	3502	56	NO
10108	3502	57	YES
10109	3502	90	NO
10110	3502	91	NO
10111	3502	60	YES
10112	3502	92	NO
10113	3502	58	YES
10114	3502	87	NO
10115	3502	88	NO
10116	3502	89	YES
10117	3503	46	YES
10118	3503	49	YES
10119	3503	50	YES
10120	3503	51	YES
10121	3503	52	NO
10122	3503	53	YES
10123	3503	54	NO
10124	3503	55	YES
10125	3503	56	NO
10126	3503	57	YES
10127	3503	90	YES
10128	3503	91	NO
10129	3503	60	NO
10130	3503	92	NO
10131	3503	58	YES
10132	3503	87	NO
10133	3503	88	NO
10134	3503	89	YES
10135	3504	46	YES
10136	3504	49	YES
10137	3504	50	NO
10138	3504	51	YES
10139	3504	52	NO
10140	3504	53	YES
10141	3504	54	YES
10142	3504	55	YES
10143	3504	56	NO
10144	3504	57	YES
10145	3504	90	YES
10146	3504	91	NO
10147	3504	60	NO
10148	3504	92	NO
10149	3504	58	YES
10150	3504	87	NO
10151	3504	88	NO
10152	3504	89	YES
10153	3505	46	YES
10154	3505	49	NO
10155	3505	50	YES
10156	3505	51	YES
10157	3505	52	NO
10158	3505	53	YES
10159	3505	54	YES
10160	3505	55	NO
10161	3505	56	NO
10162	3505	57	YES
10163	3505	90	YES
10164	3505	91	YES
10165	3505	60	NO
10166	3505	92	NO
10167	3505	58	YES
10168	3505	87	NO
10169	3505	88	NO
10170	3505	89	YES
10171	3506	46	YES
10172	3506	49	NO
10173	3506	50	YES
10174	3506	51	YES
10175	3506	52	NO
10176	3506	53	YES
10177	3506	54	YES
10178	3506	55	YES
10179	3506	56	YES
10180	3506	57	YES
10181	3506	90	YES
10182	3506	91	NO
10183	3506	60	NO
10184	3506	92	NO
10185	3506	58	NO
10186	3506	87	YES
10187	3506	88	YES
10188	3506	89	YES
10189	3507	46	YES
10190	3507	49	YES
10191	3507	50	YES
10192	3507	51	YES
10193	3507	52	NO
10194	3507	53	YES
10195	3507	54	NO
10196	3507	55	NO
10197	3507	56	NO
10198	3507	57	YES
10199	3507	90	NO
10200	3507	91	NO
10201	3507	60	YES
10202	3507	92	NO
10203	3507	58	YES
10204	3507	87	NO
10205	3507	88	NO
10206	3507	89	YES
10207	3508	46	YES
10208	3508	49	YES
10209	3508	50	NO
10210	3508	51	YES
10211	3508	52	NO
10212	3508	53	YES
10213	3508	54	NO
10214	3508	55	NO
10215	3508	56	YES
10216	3508	57	YES
10217	3508	90	NO
10218	3508	91	NO
10219	3508	60	YES
10220	3508	92	NO
10221	3508	58	NO
10222	3508	87	YES
10223	3508	88	YES
10224	3508	89	YES
10225	3509	46	YES
10226	3509	49	NO
10227	3509	50	YES
10228	3509	51	NO
10229	3509	52	NO
10230	3509	53	YES
10231	3509	54	NO
10232	3509	55	YES
10233	3509	56	YES
10234	3509	57	NO
10235	3509	90	YES
10236	3509	91	NO
10237	3509	60	NO
10238	3509	92	YES
10239	3509	58	NO
10240	3509	87	NO
10241	3509	88	YES
10242	3509	89	YES
10243	3510	46	YES
10244	3510	49	YES
10245	3510	50	YES
10246	3510	51	NO
10247	3510	52	NO
10248	3510	53	YES
10249	3510	54	YES
10250	3510	55	YES
10251	3510	56	YES
10252	3510	57	NO
10253	3510	90	YES
10254	3510	91	NO
10255	3510	60	NO
10256	3510	92	NO
10257	3510	58	NO
10258	3510	87	YES
10259	3510	88	NO
10260	3510	89	YES
10261	3511	46	YES
10262	3511	49	YES
10263	3511	50	NO
10264	3511	51	YES
10265	3511	52	NO
10266	3511	53	YES
10267	3511	54	YES
10268	3511	55	YES
10269	3511	56	YES
10270	3511	57	YES
10271	3511	90	YES
10272	3511	91	NO
10273	3511	60	YES
10274	3511	92	NO
10275	3511	58	YES
10276	3511	87	YES
10277	3511	88	YES
10278	3511	89	YES
10279	3512	46	YES
10280	3512	49	YES
10281	3512	50	YES
10282	3512	51	YES
10283	3512	52	NO
10284	3512	53	YES
10285	3512	54	NO
10286	3512	55	YES
10287	3512	56	YES
10288	3512	57	YES
10289	3512	90	YES
10290	3512	91	NO
10291	3512	60	NO
10292	3512	92	NO
10293	3512	58	NO
10294	3512	87	YES
10295	3512	88	YES
10296	3512	89	YES
10297	3513	46	YES
10298	3513	49	YES
10299	3513	50	NO
10300	3513	51	YES
10301	3513	52	NO
10302	3513	53	YES
10303	3513	54	YES
10304	3513	55	YES
10305	3513	56	YES
10306	3513	57	YES
10307	3513	90	YES
10308	3513	91	NO
10309	3513	60	NO
10310	3513	92	NO
10311	3513	58	NO
10312	3513	87	YES
10313	3513	88	YES
10314	3513	89	YES
10315	3514	46	NO
10316	3514	49	YES
10317	3514	50	NO
10318	3514	51	NO
10319	3514	52	NO
10320	3514	53	YES
10321	3514	54	NO
10322	3514	55	NO
10323	3514	56	YES
10324	3514	57	YES
10325	3514	90	YES
10326	3514	91	YES
10327	3514	60	YES
10328	3514	92	NO
10329	3514	58	YES
10330	3514	87	NO
10331	3514	88	YES
10332	3514	89	NO
10333	3515	46	NO
10334	3515	49	NO
10335	3515	50	YES
10336	3515	51	YES
10337	3515	52	NO
10338	3515	53	YES
10339	3515	54	YES
10340	3515	55	YES
10341	3515	56	YES
10342	3515	57	YES
10343	3515	90	YES
10344	3515	91	YES
10345	3515	60	NO
10346	3515	92	NO
10347	3515	58	YES
10348	3515	87	YES
10349	3515	88	YES
10350	3515	89	YES
10351	3516	46	YES
10352	3516	49	NO
10353	3516	50	NO
10354	3516	51	NO
10355	3516	52	NO
10356	3516	53	YES
10357	3516	54	NO
10358	3516	55	YES
10359	3516	56	YES
10360	3516	57	YES
10361	3516	90	YES
10362	3516	91	YES
10363	3516	60	NO
10364	3516	92	YES
10365	3516	58	YES
10366	3516	87	YES
10367	3516	88	YES
10368	3516	89	YES
10369	3517	46	YES
10370	3517	49	YES
10371	3517	50	YES
10372	3517	51	YES
10373	3517	52	YES
10374	3517	53	YES
10375	3517	54	YES
10376	3517	55	YES
10377	3517	56	YES
10378	3517	57	YES
10379	3517	90	YES
10380	3517	91	YES
10381	3517	60	NO
10382	3517	92	NO
10383	3517	58	YES
10384	3517	87	YES
10385	3517	88	YES
10386	3517	89	YES
10387	3518	46	YES
10388	3518	49	YES
10389	3518	50	YES
10390	3518	51	YES
10391	3518	52	YES
10392	3518	53	YES
10393	3518	54	YES
10394	3518	55	YES
10395	3518	56	YES
10396	3518	57	YES
10397	3518	90	YES
10398	3518	91	YES
10399	3518	60	NO
10400	3518	92	YES
10401	3518	58	YES
10402	3518	87	YES
10403	3518	88	YES
10404	3518	89	YES
10405	3519	46	YES
10406	3519	49	NO
10407	3519	50	NO
10408	3519	51	YES
10409	3519	52	NO
10410	3519	53	YES
10411	3519	54	YES
10412	3519	55	YES
10413	3519	56	YES
10414	3519	57	NO
10415	3519	90	YES
10416	3519	91	NO
10417	3519	60	YES
10418	3519	92	NO
10419	3519	58	NO
10420	3519	87	NO
10421	3519	88	YES
10422	3519	89	YES
10423	3520	46	YES
10424	3520	49	YES
10425	3520	50	YES
10426	3520	51	YES
10427	3520	52	NO
10428	3520	53	YES
10429	3520	54	YES
10430	3520	55	YES
10431	3520	56	YES
10432	3520	57	YES
10433	3520	90	YES
10434	3520	91	YES
10435	3520	60	NO
10436	3520	92	NO
10437	3520	58	YES
10438	3520	87	YES
10439	3520	88	YES
10440	3520	89	YES
10441	3522	46	YES
10442	3522	49	NO
10443	3522	50	YES
10444	3522	51	YES
10445	3522	52	YES
10446	3522	53	YES
10447	3522	54	YES
10448	3522	55	YES
10449	3522	56	YES
10450	3522	57	YES
10451	3522	90	YES
10452	3522	91	YES
10453	3522	60	NO
10454	3522	92	NO
10455	3522	58	YES
10456	3522	87	YES
10457	3522	88	YES
10458	3522	89	YES
10459	3523	46	YES
10460	3523	49	YES
10461	3523	50	NO
10462	3523	51	YES
10463	3523	52	YES
10464	3523	53	YES
10465	3523	54	NO
10466	3523	55	YES
10467	3523	56	YES
10468	3523	57	NO
10469	3523	90	YES
10470	3523	91	YES
10471	3523	60	YES
10472	3523	92	NO
10473	3523	58	YES
10474	3523	87	YES
10475	3523	88	YES
10476	3523	89	YES
10477	3524	46	YES
10478	3524	49	NO
10479	3524	50	YES
10480	3524	51	NO
10481	3524	52	YES
10482	3524	53	YES
10483	3524	54	YES
10484	3524	55	YES
10485	3524	56	YES
10486	3524	57	YES
10487	3524	90	NO
10488	3524	91	NO
10489	3524	60	NO
10490	3524	92	NO
10491	3524	58	NO
10492	3524	87	YES
10493	3524	88	YES
10494	3524	89	YES
10495	3525	46	YES
10496	3525	49	NO
10497	3525	50	NO
10498	3525	51	NO
10499	3525	52	NO
10500	3525	53	YES
10501	3525	54	NO
10502	3525	55	YES
10503	3525	56	NO
10504	3525	57	NO
10505	3525	90	YES
10506	3525	91	NO
10507	3525	60	YES
10508	3525	92	NO
10509	3525	58	NO
10510	3525	87	NO
10511	3525	88	NO
10512	3525	89	YES
10513	3526	46	YES
10514	3526	49	YES
10515	3526	50	YES
10516	3526	51	NO
10517	3526	52	NO
10518	3526	53	NO
10519	3526	54	YES
10520	3526	55	YES
10521	3526	56	NO
10522	3526	57	YES
10523	3526	90	YES
10524	3526	91	NO
10525	3526	60	YES
10526	3526	92	NO
10527	3526	58	NO
10528	3526	87	NO
10529	3526	88	NO
10530	3526	89	YES
10531	3527	46	NO
10532	3527	49	YES
10533	3527	50	YES
10534	3527	51	YES
10535	3527	52	YES
10536	3527	53	YES
10537	3527	54	NO
10538	3527	55	NO
10539	3527	56	YES
10540	3527	57	YES
10541	3527	90	YES
10542	3527	91	YES
10543	3527	60	NO
10544	3527	92	NO
10545	3527	58	YES
10546	3527	87	YES
10547	3527	88	YES
10548	3527	89	YES
10549	3528	46	NO
10550	3528	49	YES
10551	3528	50	YES
10552	3528	51	YES
10553	3528	52	NO
10554	3528	53	YES
10555	3528	54	NO
10556	3528	55	YES
10557	3528	56	YES
10558	3528	57	NO
10559	3528	90	YES
10560	3528	91	NO
10561	3528	60	NO
10562	3528	92	YES
10563	3528	58	NO
10564	3528	87	YES
10565	3528	88	YES
10566	3528	89	NO
10567	3529	46	YES
10568	3529	49	YES
10569	3529	50	YES
10570	3529	51	YES
10571	3529	52	NO
10572	3529	53	YES
10573	3529	54	YES
10574	3529	55	YES
10575	3529	56	YES
10576	3529	57	YES
10577	3529	90	YES
10578	3529	91	YES
10579	3529	60	NO
10580	3529	92	NO
10581	3529	58	NO
10582	3529	87	YES
10583	3529	88	YES
10584	3529	89	YES
10585	3530	46	YES
10586	3530	49	NO
10587	3530	50	NO
10588	3530	51	NO
10589	3530	52	NO
10590	3530	53	YES
10591	3530	54	YES
10592	3530	55	YES
10593	3530	56	YES
10594	3530	57	NO
10595	3530	90	YES
10596	3530	91	NO
10597	3530	60	NO
10598	3530	92	NO
10599	3530	58	YES
10600	3530	87	YES
10601	3530	88	YES
10602	3530	89	YES
10603	3531	46	YES
10604	3531	49	YES
10605	3531	50	YES
10606	3531	51	YES
10607	3531	52	NO
10608	3531	53	YES
10609	3531	54	YES
10610	3531	55	YES
10611	3531	56	YES
10612	3531	57	YES
10613	3531	90	YES
10614	3531	91	YES
10615	3531	60	NO
10616	3531	92	NO
10617	3531	58	YES
10618	3531	87	YES
10619	3531	88	YES
10620	3531	89	YES
10621	3532	46	YES
10622	3532	49	YES
10623	3532	50	YES
10624	3532	51	YES
10625	3532	52	NO
10626	3532	53	YES
10627	3532	54	YES
10628	3532	55	YES
10629	3532	56	YES
10630	3532	57	YES
10631	3532	90	YES
10632	3532	91	NO
10633	3532	60	NO
10634	3532	92	NO
10635	3532	58	NO
10636	3532	87	YES
10637	3532	88	YES
10638	3532	89	YES
10639	3533	46	YES
10640	3533	49	YES
10641	3533	50	NO
10642	3533	51	NO
10643	3533	52	NO
10644	3533	53	YES
10645	3533	54	NO
10646	3533	55	YES
10647	3533	56	YES
10648	3533	57	YES
10649	3533	90	YES
10650	3533	91	NO
10651	3533	60	NO
10652	3533	92	NO
10653	3533	58	YES
10654	3533	87	YES
10655	3533	88	YES
10656	3533	89	YES
10657	3534	46	NO
10658	3534	49	YES
10659	3534	50	YES
10660	3534	51	YES
10661	3534	52	NO
10662	3534	53	YES
10663	3534	54	NO
10664	3534	55	NO
10665	3534	56	YES
10666	3534	57	NO
10667	3534	90	YES
10668	3534	91	YES
10669	3534	60	NO
10670	3534	92	NO
10671	3534	58	YES
10672	3534	87	YES
10673	3534	88	YES
10674	3534	89	NO
10675	3535	46	YES
10676	3535	49	YES
10677	3535	50	YES
10678	3535	51	NO
10679	3535	52	NO
10680	3535	53	YES
10681	3535	54	NO
10682	3535	55	YES
10683	3535	56	YES
10684	3535	57	NO
10685	3535	90	YES
10686	3535	91	YES
10687	3535	60	NO
10688	3535	92	NO
10689	3535	58	YES
10690	3535	87	YES
10691	3535	88	YES
10692	3535	89	NO
10693	3536	46	YES
10694	3536	49	YES
10695	3536	50	YES
10696	3536	51	YES
10697	3536	52	NO
10698	3536	53	YES
10699	3536	54	YES
10700	3536	55	YES
10701	3536	56	YES
10702	3536	57	YES
10703	3536	90	YES
10704	3536	91	YES
10705	3536	60	NO
10706	3536	92	NO
10707	3536	58	YES
10708	3536	87	YES
10709	3536	88	YES
10710	3536	89	YES
10711	3254	49	yes
10712	3254	50	yes
10713	3521	46	yes
10714	3521	49	yes
10715	3521	50	yes
10716	3521	52	yes
10717	3521	55	yes
10718	3521	88	yes
10719	3521	89	yes
10720	3521	90	yes
10721	3521	91	yes
10722	3521	60	yes
10723	3521	92	yes
10724	3521	58	yes
10725	3537	55	yes
10726	3537	46	yes
10727	3537	49	yes
10728	3537	50	yes
10729	3537	52	yes
10730	3538	49	yes
10731	3538	58	yes
10732	3538	52	yes
10733	3538	53	yes
10734	3538	89	yes
10735	3538	90	yes
10736	3538	91	yes
10737	3538	60	yes
10738	3538	92	yes
10739	3544	49	yes
10740	3544	58	yes
10741	3544	52	yes
10742	3544	53	yes
10743	3544	56	yes
10744	3544	89	yes
10745	3544	90	yes
10746	3544	91	yes
10747	3544	60	yes
10748	3544	92	yes
10749	3544	57	yes
10750	3539	46	yes
10751	3539	49	yes
10752	3539	50	yes
10753	3539	52	yes
10754	3539	57	yes
10755	3539	90	yes
10756	3539	91	yes
10757	3539	92	yes
10758	3539	58	yes
10759	3540	46	yes
10760	3540	49	yes
10761	3540	50	yes
10762	3540	54	yes
10763	3540	55	yes
10764	3540	57	yes
10765	3540	90	yes
10766	3540	91	yes
10767	3540	92	yes
10768	3540	58	yes
10769	3540	89	yes
10770	3542	46	yes
10771	3542	49	yes
10772	3542	58	yes
10773	3542	51	yes
10774	3542	52	yes
10775	3542	54	yes
10776	3542	55	yes
10777	3542	56	yes
10778	3542	57	yes
10779	3542	90	yes
10780	3542	91	yes
10781	3542	92	yes
10782	3542	89	yes
10783	3541	46	yes
10784	3541	49	yes
10785	3541	58	yes
10786	3541	53	yes
10787	3541	54	yes
10788	3541	55	yes
10789	3541	57	yes
10790	3541	90	yes
10791	3541	91	yes
10792	3541	92	yes
10793	3541	87	yes
10794	3541	89	yes
10795	3543	58	yes
10796	3543	50	yes
10797	3543	91	yes
10798	3543	53	yes
10799	3546	46	yes
10800	3546	49	yes
10801	3546	58	yes
10802	3546	52	yes
10803	3546	53	yes
10804	3546	54	yes
10805	3546	55	yes
10806	3546	56	yes
10807	3546	89	yes
10808	3546	90	yes
10809	3546	91	yes
10810	3546	92	yes
10811	3546	88	yes
10812	3547	46	yes
10813	3547	49	yes
10814	3547	50	yes
10815	3547	52	yes
10816	3547	53	yes
10817	3547	54	yes
10818	3547	55	yes
10819	3547	56	yes
10820	3547	89	yes
10821	3547	90	yes
10822	3547	91	yes
10823	3547	92	yes
10824	3547	58	yes
10825	3547	88	yes
10826	3550	46	yes
10827	3550	49	yes
10828	3550	58	yes
10829	3550	53	yes
10830	3550	55	yes
10831	3550	56	yes
10832	3550	89	yes
10833	3550	90	yes
10834	3550	91	yes
10835	3550	92	yes
\.


--
-- Name: stories_answer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: klp
--

SELECT pg_catalog.setval('stories_answer_id_seq', 10835, true);


--
-- Data for Name: stories_question; Type: TABLE DATA; Schema: public; Owner: klp
--

COPY stories_question (id, text, data_type, question_type_id, options, is_active, school_type, qid) FROM stdin;
46	An All weather (pucca) building	1	2	\N	t	2	1
47	An All weather (pucca) building	1	2	\N	t	2	1
48	An All weather (pucca) building	1	2	\N	t	2	1
49	Boundary wall/ Fencing	1	2	\N	t	2	2
50	Play ground	1	2	\N	t	2	3
51	Accessibility to students with disabilities	1	2	\N	t	2	4
52	Separate office for Headmaster	1	2	\N	t	2	5
53	Separate room as Kitchen / Store for Mid day meals	1	2	\N	t	2	6
54	Separate Toilets for Boys and Girls	1	2	\N	t	2	7
55	Drinking Water facility	1	2	\N	t	2	8
56	Library	1	2	\N	t	2	9
57	Play Material or Sports Equipment	1	2	\N	t	2	10
58	Did you see any evidence of mid day meal being served (food being cooked, food waste etc.) on the day of your visit?	1	1	{Yes,No}	t	2	11
59	How many functional class rooms (exclude rooms that are not used for conducting classes for whatever reason) does the school have?	1	2	\N	t	2	12
60	Teachers sharing a single class room	1	2	\N	t	2	13
61	How many classrooms had no teachers in the class?	1	2	\N	t	2	14
62	What was the total numbers of teachers present (including head master)?	1	2	\N	t	2	15
63	Anganwadi opened on time (10 A.M)	1	2	\N	t	1	16
64	A proper building (designated for running Anganwadi)	1	2	\N	t	1	17
65	Were at least 50% of the children enrolled were present on the day of visit?	1	1	{Yes,No}	t	1	18
66	Attendance being recorded	1	2	\N	t	1	19
67	Spacious enough premises for children	1	2	\N	t	1	20
68	Space for the Children to Play	1	2	\N	t	1	21
69	Designated area for storing and cooking food	1	2	\N	t	1	22
70	If this space to stock food was observed, was this space  neat and free from dust, waste and protected from rain and wind and free from pest, worms and rats?	1	2	\N	t	1	23
71	Hygeinic measures for storing and cooking food	1	2	\N	t	1	24
72	Evidence of Food served on time	1	2	\N	t	1	25
73	Well maintained floor 	1	2	\N	t	1	26
74	Roof well maintained - without damage /leakage 	1	2	\N	t	1	27
75	Boundary Wall, Doors, windows for security	1	2	\N	t	1	28
76	Colourful Wall paintings	1	2	\N	t	1	29
77	Use of a Waste Basket	1	2	\N	t	1	30
78	Drinking Water facility	1	2	\N	t	1	31
79	Hand Wash facility	1	2	\N	t	1	32
80	Toilet	1	2	\N	t	1	33
81	Is the teacher trained  to teach physically challenged / disabled children?	1	1	{Yes,No}	t	1	34
82	Are Bal Vikas Samithi meetings held as per the norm?	1	2	\N	t	1	35
83	Is there a Friends of Anganwadi group for this anganwadi?	1	2	\N	t	1	36
84	Blackboard	1	2	\N	t	1	37
85	Teaching and Learning Material	1	2	\N	t	1	38
86	Play material	1	2	\N	t	1	39
87	Designated Librarian/Teacher	1	2	\N	t	2	40
88	Class-wise timetable for the Library	1	2	\N	t	2	41
89	Teaching and Learning material	1	2	\N	t	2	42
90	Sufficient number of class rooms	1	2	\N	t	2	43
91	Were at least 50% of the children enrolled present on the day you visited the school?	1	1	{Yes,No}	t	2	44
92	Were all teachers present on the day you visited the school?	1	1	{Yes,No}	t	2	45
\.


--
-- Name: stories_question_id_seq; Type: SEQUENCE SET; Schema: public; Owner: klp
--

SELECT pg_catalog.setval('stories_question_id_seq', 92, true);


--
-- Data for Name: stories_questiongroup; Type: TABLE DATA; Schema: public; Owner: klp
--

COPY stories_questiongroup (id, version, source_id) FROM stdin;
1	1	2
\.


--
-- Name: stories_questiongroup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: klp
--

SELECT pg_catalog.setval('stories_questiongroup_id_seq', 1, true);


--
-- Data for Name: stories_questiongroup_questions; Type: TABLE DATA; Schema: public; Owner: klp
--

COPY stories_questiongroup_questions (id, questiongroup_id, question_id, sequence) FROM stdin;
2	1	46	1
3	1	49	2
4	1	50	3
5	1	51	4
6	1	52	5
7	1	53	6
8	1	54	7
9	1	55	8
10	1	56	9
11	1	57	10
12	1	58	11
13	1	59	12
14	1	60	13
15	1	61	14
16	1	62	15
17	1	63	1
18	1	64	2
19	1	65	3
20	1	66	4
21	1	67	5
22	1	68	6
23	1	69	7
24	1	70	8
25	1	71	9
26	1	72	10
27	1	73	11
28	1	74	12
29	1	75	13
30	1	76	14
31	1	77	15
32	1	78	16
33	1	79	17
34	1	80	18
35	1	81	19
36	1	82	20
37	1	83	21
38	1	84	22
39	1	85	23
40	1	86	24
41	1	87	16
42	1	88	17
43	1	89	18
44	1	90	19
45	1	91	20
46	1	92	21
\.


--
-- Name: stories_questiongroup_questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: klp
--

SELECT pg_catalog.setval('stories_questiongroup_questions_id_seq', 46, true);


--
-- Data for Name: stories_questiontype; Type: TABLE DATA; Schema: public; Owner: klp
--

COPY stories_questiontype (id, name) FROM stdin;
1	radio
2	checkbox
\.


--
-- Name: stories_questiontype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: klp
--

SELECT pg_catalog.setval('stories_questiontype_id_seq', 2, true);


--
-- Data for Name: stories_source; Type: TABLE DATA; Schema: public; Owner: klp
--

COPY stories_source (id, name) FROM stdin;
1	csv
2	web
3	ivrs
4	mobile
\.


--
-- Name: stories_source_id_seq; Type: SEQUENCE SET; Schema: public; Owner: klp
--

SELECT pg_catalog.setval('stories_source_id_seq', 4, true);


--
-- Data for Name: stories_story; Type: TABLE DATA; Schema: public; Owner: klp
--

COPY stories_story (id, user_id, school_id, group_id, is_verified, name, email, date, telephone, entered_timestamp, comments, sysid) FROM stdin;
1	1	33425	1	t	AKHILA BEGUM	akhila@akshara.org.in	17-08-2010	9741390735	2010-08-25 07:09:12.227232+00	Library is not functioning in the school    	5
2	1	33425	1	t	akhila	begum.akhila@gmail.com	02-08-2010	25485800	2010-08-25 07:09:12.227232+00	No separate toilet for staff	7
3	1	32504	1	t	Munirathna.k	munirathnak@gmail.com	08-07-2010	9035663072	2010-08-25 07:09:12.227232+00	1)SubbaiahnPalya  inthis  school H.M and techers are very coperated to akshara people. They have give inforamtion one by one. they have impression about akshara programmes.	26
4	1	32839	1	t	MURTHY	murthy50644@gmail.com	08-07-2010	9141450264	2010-08-25 07:09:12.227232+00	The school Head master was interested to give the data's, but he asked me to visit  next day..	20
5	1	31425	1	t	MURTHY	murthy50644@gmail.com	08-07-2010	9141450264	2010-08-25 07:09:12.227232+00	anganwadi teacher was interested to give data's....	22
6	1	32212	1	t	Ayesha	\N	23-08-2010	\N	2010-08-31 05:39:07.857912+00	water problam	120
7	1	32444	1	t	NASEEM TAJ	tajnaseem@yahoo.com	\N	9901091761	2010-08-25 07:09:12.227232+00	GKTHPS ANJANNAPPA GARDEN AND GKNTHPS ANJANNAPPA GARDEN School teacher are co operated with me successfully.  Because I had experienced there and it is easy to collect the information.	54
8	1	32136	1	t	NASEEM TAJ	tajnaseem@yahoo.com	09-07-2010	9901091761	2010-08-25 07:09:12.227232+00	In GTLPS BELIMUTT School teacher are co operate with me lately because they are busy in work and later they gave the children information.  And they told that the teachers and our foundation are both wasting the time of children by collecting information.  In which they both can help the childrens to learn and they told our foundation had given library books wrongly, instead of giving Tamil books in tamil school they gaved us telugu books which are not used in there schools.	56
9	1	32484	1	t	Munirathna.k	munirathnak@gmail.com	12-07-2010	9035663072	2010-08-25 07:09:12.227232+00	GKHPS Hunasamaranahalli  in this schools H.M was very strict  in our  vist time he had taken  the class  we have wait for him. After he came the office room we said we are coming for akshara foundation we want teachers and new children list he ask why you are taking the this information what's the reason . After he had gave the teachers infromation and children names charts and attendence book.	52
10	1	32149	1	t	Venkatesh	kannadavenki@gmail.com	14-08-2010	9741390756	2010-08-25 07:09:12.227232+00	The School have  very nice Building which constructed by Rotary Club and SSA collaboration , CRP centre also here only.  : the present academic year near 480 children are there in 1st to 8th std. 	3
11	1	33161	1	t	Mohsina Taj	mohsinataj83@yahoo.com	08-07-2010	\N	2010-08-25 07:09:12.227232+00	HM and teacher's good responses and I am explain how to cross check and I am seat to HM room and collect to new children's detail's	38
12	1	32653	1	t	SHAKUNTHALA.S	selvashakunthala@gmail.com	09-06-2010	9900456596	2010-08-25 07:09:12.227232+00	As i am visited the school Head masters & teachers they are ready to give the data's.In that school facilities was very good.The teachers said the library is very use full to children's.	32
13	1	30580	1	t	MURTHY	murthy50644@gmail.com	09-07-2010	9141450264	2010-08-25 07:09:12.227232+00	anganwadi teacher was interested to give data's....	30
14	1	32133	1	t	NASEEM TAJ	tajnaseem@yahoo.com	12-7-2010 14-7-2010	9901091761	2010-08-25 07:09:12.227232+00	In  GUMPBS FAROOQNAGAR Ihad experienced there that made easy to collect the data and teachers  were co operate with us.We went to GUMPBS FAROOQNAGAR School to collect remaing children information.  operated with us.	36
15	1	32841	1	t	MURTHY	murthy50644@gmail.com	09-07-2010	9141450264	2010-08-25 07:09:12.227232+00	The School Head master was interested to give data's	34
16	1	33139	1	t	Kanchan	kanchan@akshara.org.in	17-08-2010	\N	2010-08-25 07:09:12.227232+00	There were about 60 children in the entire school. Teachers were conducting combined classes.	62
17	1	32197	1	t	purvi	purvi@prathambooks.org	18-08-2010	\N	2010-08-25 07:09:12.227232+00	wonderful to see more girls than boys!	64
18	1	32074	1	t	Shaheen fathima	\N	24-08-2010	9743213359	2010-08-25 07:09:12.227232+00	No electrcity,no play ground,	66
19	1	33280	1	t	SHAKUNTHALA.S	selvashakunthala@gmail.com	08-07-2010	9900456596	2010-08-25 07:09:12.227232+00	As am visited the school Head mistress & teachers they are ready to give the data's but there no facilities for children's.	13
20	1	32505	1	t	Munirathna.k	munirathnak@gmail.com	08-07-2010	9035663072	2010-08-25 07:09:12.227232+00	In this school we have visited time H.M  has taken the leave that day. Teachers has said you please come tomorrow but we have request after they have agreed to give the data.   In cross verification time they have also helped to us.	15
21	1	32132	1	t	NASEEM TAJ	tajnaseem@yahoo.com	15-07-2010	9901091761	2010-08-25 07:09:12.227232+00	GUHPBS JJR NAGAR School to collect the data and HM called all the teachers to their office and gaved the information successfully.  Instead of sending us to collect the data class wise they called all the teachers to their office, but they gave the charts all the data are written by us.  And HM had goodly by giving lunch to us and also gaved sncks to us.	18
22	1	33155	1	t	Mohsina Taj	mohsinataj83@yahoo.com	\N	\N	2010-08-25 07:09:12.227232+00	HM give to  2 to 8 std attends and new children's detail's book and said go out side seat and cross, check after write new children's detail's 	48
23	1	32135	1	t	NASEEM TAJ	tajnaseem@yahoo.com	14-07-2010	9901091761	2010-08-25 07:09:12.227232+00	we went to GUMPS GORIPALYA CORP BUILDING and we took the childrens data. Teachers were co operate with us, and write the childrens information.	46
24	1	33148	1	t	Mohsina Taj	mohsinataj83@yahoo.com	\N	\N	2010-08-25 07:09:12.227232+00	I will go to HM room and said I am doing cross check to children's can you said all teacher's give  information HM said you seat I will called teacher's and u give to formant calls vies teacher's and explain you how to cross check  and give new children's sheet ok.	44
25	1	32506	1	t	Munirathna.k	munirathnak@gmail.com	09-07-2010	9035663072	2010-08-25 07:09:12.227232+00	1)Ramaswamipalya  techers give the good response  and said please come any time i am ready to give the information.	42
26	1	32022	1	t	SHAKUNTHALA.S	selvashakunthala@gmail.com	09-06-2010	9900456596	2010-08-25 07:09:12.227232+00	As i am visited to this school the Head master was not there , but the teachers are interested to give data,s	40
27	1	32848	1	t	MURTHY	murthy50644@gmail.com	08-07-2010	9141450264	2010-08-25 07:09:12.227232+00	The school head master was interested to give data's but tel Him give me new library books …...anganwadi teacher was interested to give data's.  Library is not functioning in the school   	9
28	1	33159	1	t	\N	\N	\N	\N	2010-08-25 07:09:12.227232+00	HM and teaches give respect teacher tack all formant and cross check. i am collect new children's data	50
29	1	32857	1	t	RESHMA	\N	25-08-2010	\N	2010-08-26 15:34:26.571623+00	This school has only two toilets and this school situated in nice environment.	90
30	1	33439	1	t	Sandeep Raj	\N	23-08-2010	\N	2010-08-26 16:16:15.907348+00	This school has small play ground. This school situated in Bommasandra Industrial area The source of drinking water is very polluted by Various industries specially by Bio-con. Biocon promised to construct new building by demolishing old building but the work is not started yet.	110
157	1	33767	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:20.823175+00	\N	370
31	1	32808	1	t	Chandrakala	\N	26-08-2010	\N	2010-09-10 02:50:43.473484+00	Compound Required	160
32	1	32811	1	t	Chandrakala	\N	26-08-2010	\N	2010-09-10 02:52:12.406913+00	Computer required.One room required for teachers staff room  	162
33	1	34053	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:20.840625+00	\N	396
34	1	32460	1	t	Jayamala	bhagya@akshara.org.in	23-08-2010	9741390731	2010-08-26 11:40:22.827856+00	ಈ ಶಾಲೆಯ ಮುಖ್ಯೋಪಾದ್ಯಾರು ಮಕ್ಕಳಿಗೆ ಯಾವ ಕಾರ್ಯ ಕ್ರಮಗಳನ್ನು ಹಮ್ಮಿಕೊಂಡು ಮಾಡಿಸುತ್ತಾರೆ. ಶಿಕ್ಷಕರು ಚಟುವಟಿಕೆಯಿಂದ ಮಕ್ಕಳಿಗೆ ಪಾಠ ಕಲಿಸುತ್ತಾರೆ.	82
35	1	32861	1	t	RESHMA	\N	25-08-2010	\N	2010-08-26 15:30:07.187079+00	This schools has no play ground but strength is high. teachers are very cooperative. Nice School	86
36	1	32860	1	t	MANJULA. GR	\N	26-08-2010	\N	2010-08-26 15:22:06.487288+00	This school has very nice play ground. Teachers are very cooperative with community. In this school mid-day meal served by Iskan. Teachers are working hard for over all development of school and they are inventing new new methods to give quality education.	84
37	1	32317	1	t	MANJULA. GR	\N	26-08-2010	\N	2010-08-26 16:07:47.2976+00	There is no separate toilets for girls and boys. both are using same toilets. teachers are very cooperative with community. and they are working hard for over all development of school. Mid-day Meal supplied by Iskan and vegetables not boiled properly.	108
38	1	32855	1	t	Savitha	\N	24-08-2010	\N	2010-08-26 15:56:51.062023+00	This school has only one room but teachers were teaching well. Nice environment.	102
39	1	32859	1	t	Savitha	\N	26-08-2010	\N	2010-08-26 16:02:45.817013+00	Nice environment. Teachers were teaching science using new methods and some interesting hand made materials.	106
40	1	32860	1	t	Savitha	\N	25-08-2010	\N	2010-08-26 16:00:27.072321+00	Teachers were teaching well but environment was very bad and huge number of dogs were there in school compound	104
41	1	32348	1	t	Bhagya	bhagya@akshara.org.in	23-08-2010	9741390704	2010-08-26 08:12:36.913656+00	ಅಂಜನಾಪುರ ಶಾಲೆಯಲ್ಲಿ ಶಿಕ್ಷಕರು ತುಂಬಾ ಚಟುವಟಿಕೆಯಿಂದ ಮಕ್ಕಳ ಜೊತೆ ಪಾಲ್ಗೋಳ್ಳುತ್ತಾರೆ. ಮುಖ್ಯ ಶಿಕ್ಷರ ಪ್ರೋತ್ಸಾಹ ತುಂಬಾ ಚೆನ್ನಾಗಿದೆ.  ಮಕ್ಕಳಿಗೆ ಆಟವಾಡಲು ಆಟ ಮೈದಾನದ ವ್ಯವಸ್ಥೆ ಈ ಶಾಲೆಯಲ್ಲಿ ಅನುಕೂಲಕರವಾಗಿದೆ.	68
42	1	32625	1	t	Timmakka	\N	26-08-2010	\N	2010-08-26 15:50:03.857269+00	Presently the school is conducted in home which is near to school because that school building is under construction. (demolishing to construct new building)	98
43	1	32621	1	t	Timmakka	\N	23-08-2010	\N	2010-08-26 15:41:47.973916+00	Small but nice School.	94
44	1	32615	1	t	Timmakka	\N	24-08-2010	\N	2010-08-26 15:45:32.812275+00	In this school There is no HM. No cooperation between teachers. Every Cleaning works done by children only.	96
45	1	33097	1	t	reshma	bhagya@akshara.org.in	23-08-2010	9741390804	2010-08-27 06:55:26.020613+00	ಶಾಲೆಯಲ್ಲಿ ಶಿಕ್ಷಕರ ಸಮಯಪಾಲನೆ , ಭೋದನೆ ಎಲ್ಲಾ ತುಂಬ ಚೆನ್ನಾಗಿ ನಡೆಯುತ್ತಿದೆ. ಮಕ್ಕಳು ಸಹ ಓದುವುದರಲ್ಲಿ ಮುಂದಿದ್ದಾರೆ. ಕಥೆ ಪುಸ್ತಕಗಳನ್ನು ಒಂದು ದಿವಸ ತಪ್ಪದೆ ಓದುತ್ತಾರೆ	112
46	1	32851	1	t	Savitha	\N	23-08-2010	\N	2010-08-26 15:53:56.896757+00	This school is small but nice school teachers are very cooperative. Nice environment.	100
47	1	32406	1	t	VENKATESH. R	\N	31-08-2010	\N	2010-09-10 02:34:39.841063+00	there is no toilet for boys and girls	140
48	1	32454	1	t	jayamala	bhagya@akshara.org.in	23-08-2010	9741390731	2010-08-26 08:45:29.573423+00	ಚುಂಚನಘಟ್ಟ ಶಾಲೆಯಲ್ಲಿ ಶಿಕ್ಷಕರ ಸಮಯಪಾಲನೆ , ಭೋದನೆ ಎಲ್ಲಾ ತುಂಬ ಚೆನ್ನಾಗಿ ನಡೆಯುತ್ತಿದೆ. ಮಕ್ಕಳು ಸಹ ಓದುವುದರಲ್ಲಿ ಮುಂದಿದ್ದಾರೆ. ಕಥೆ ಪುಸ್ತಕಗಳನ್ನು ಒಂದು ದಿವಸ ತಪ್ಪದೆ ಓದುತ್ತಾರೆ	76
49	1	32792	1	t	Noor Arifa	\N	26-08-2010	7760404848	2010-08-26 08:35:11.148927+00	NNG workbooks for all classes should given story books to be kept in our school also so that children can read they want,	72
50	1	33823	1	t	Jayamala	bhagya@akshara.org.in	21-08-2010	9741390731	2010-08-26 11:08:20.939612+00	ಈ ಅಂಗನವಾಡಿಯಲ್ಲಿ  ಶೌಚಲಯದ ವ್ಯವಸ್ಥೆ ಇಲ್ಲ ಮಕ್ಕಳಿಗೆ ಇದರಿಂದ ತೊಂದರೆಯಾಗುತ್ತಿದೆ.  ಅಲ್ಲಿನ ಕಾರ್ಯಕರ್ತೆ ಸುನಂದರವರು ಶಾಲಾ ಪೂರ್ವ ಶಿಕ್ಷಣವನ್ನು ತುಂಬಾ ಚೆನ್ನಾಗಿ ಮಾಡುತ್ತಾರೆ.	78
51	1	33752	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:20.828353+00	\N	373
52	1	33758	1	t	LOCALCIRCLE	\N	17-07-2010	\N	2010-12-02 17:08:20.828741+00	\N	374
53	1	31362	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:20.829129+00	\N	375
54	1	33744	1	t	LOCALCIRCLE	\N	17-07-2010	\N	2010-12-02 17:08:20.829516+00	\N	376
55	1	33746	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:20.829907+00	\N	377
56	1	31082	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:20.830304+00	\N	378
57	1	31336	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:20.830696+00	\N	379
58	1	33666	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:20.831084+00	\N	380
59	1	31040	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:20.831478+00	\N	381
60	1	33926	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:20.778313+00	\N	304
61	1	32740	1	f	Channamma	\N	25-08-2010	9741390706	2010-08-31 06:52:39.146065+00	Nothing	134
62	1	32801	1	t	GOPAL	\N	27-08-2010	\N	2010-09-10 02:55:40.972126+00	Required Computer Training for Teachers	166
63	1	33411	1	t	Mu	\N	25-08-2010	\N	2010-09-10 03:54:07.995306+00	Shortage of teachers	262
64	1	32078	1	t	Muniraju	\N	24-08-2010	\N	2010-09-10 03:52:50.606772+00	Computer teacher required	260
65	1	32072	1	t	shamshad Begum	\N	24-08-2010	9741390819	2010-08-31 05:47:37.793681+00	toilet are not good	124
66	1	32068	1	t	shamshad Begum	\N	\N	9741390819	2010-08-31 05:54:59.781335+00	no kaveri water to drink the children	126
67	1	33141	1	t	Yasmeen Taj	\N	30-08-2010	9741390773	2010-08-31 06:03:16.962309+00	Strength  less	128
68	1	32081	1	t	Muniraju	\N	26-08-2010	\N	2010-09-10 03:51:39.868352+00	Sports equipments are needed	258
69	1	33424	1	t	Shwetha	\N	30-08-2010	\N	2010-09-10 03:18:42.81147+00	there is no toilet for staff	198
70	1	33425	1	t	Shwetha	\N	30-08-2010	\N	2010-09-10 03:17:35.22284+00	There is no computer and play ground	196
71	1	32401	1	t	\N	\N	\N	\N	2010-09-10 03:13:47.573772+00	No computer	192
72	1	33413	1	t	Nagesh	\N	24-08-2010	\N	2010-09-10 03:44:02.298021+00	Water Problem	246
73	1	32521	1	t	GOPAL	\N	28-08-2010	\N	2010-09-10 03:03:29.761215+00	Required Computers	176
158	1	33769	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:20.823567+00	\N	371
74	1	32082	1	t	Muniraju	\N	25-08-2010	\N	2010-09-10 03:50:37.549094+00	Computer and staff toilet needed	256
75	1	32517	1	t	GOPAL	\N	30-08-2010	\N	2010-09-10 03:00:50.140304+00	Required Computer	172
76	1	32516	1	t	GOPAL	\N	27-08-2010	\N	2010-09-10 02:59:37.746551+00	There is no proper building for school	170
77	1	32801	1	t	GOPAL	\N	27-08-2010	\N	2010-09-10 02:56:15.717263+00	Required Computer Training for Teachers	168
78	1	32807	1	t	Chandrakala	\N	26-08-2010	\N	2010-09-10 02:53:25.705412+00	Teachers Required	164
79	1	32227	1	t	Mala	\N	30-08-2010	\N	2010-09-10 03:31:51.969658+00	No computer	226
80	1	33392	1	t	Mala	\N	30-08-2010	\N	2010-09-10 03:30:40.109928+00	Rooms Problem. Table Problem	224
81	1	32803	1	t	GOPAL	\N	31-08-2010	\N	2010-09-10 02:45:10.01042+00	Less teachers. Lack of computer Training to teachers.  Lack of lay ground	152
82	1	32813	1	t	GOPAL	\N	31-08-2010	\N	2010-09-10 02:46:37.824734+00	no play ground.. They are expecting computer 	154
83	1	32805	1	t	GOPAL	\N	31-08-2010	\N	2010-09-10 02:47:54.977561+00	There is no play ground	156
84	1	32806	1	t	GOPAL	\N	31-08-2010	\N	2010-09-10 02:49:21.15527+00	Shortage of furnitures	158
85	1	32959	1	t	Mala	\N	30-08-2010	\N	2010-09-10 03:37:55.72625+00	Computer Needed	238
86	1	32221	1	t	Mala	\N	30-08-2010	\N	2010-09-10 03:33:59.171176+00	Water Problem	230
87	1	32405	1	t	venkatesh	\N	31-08-2010	\N	2010-09-10 02:39:55.088197+00	there is no toilet for girls	146
88	1	33427	1	t	Shwetha	\N	30-08-2010	\N	2010-09-10 03:19:58.784957+00	There is no Play ground, And also there is no computer  	200
89	1	32416	1	t	venkatesh	\N	31-08-2010	\N	2010-09-10 02:38:29.035221+00	there is no play ground	144
90	1	32408	1	t	vemkatesh	\N	31-08-2010	\N	2010-09-10 02:41:16.246266+00	no play ground	148
91	1	32402	1	t	Shwetha	\N	30-08-2010	\N	2010-09-10 03:15:12.581376+00	Toilet Required	194
92	1	33863	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:20.778704+00	\N	305
93	1	33861	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:20.779098+00	\N	306
94	1	33854	1	t	LOCALCIRCLE	\N	31-08-2010	\N	2010-12-02 17:08:20.779488+00	\N	307
95	1	33850	1	t	LOCALCIRCLE	\N	31-08-2010	\N	2010-12-02 17:08:20.779883+00	\N	308
96	1	33542	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:20.780279+00	\N	309
97	1	31541	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:20.780666+00	\N	310
98	1	31494	1	t	LOCALCIRCLE	\N	31-08-2010	\N	2010-12-02 17:08:20.781058+00	\N	311
99	1	31502	1	t	LOCALCIRCLE	\N	31-08-2010	\N	2010-12-02 17:08:20.781452+00	\N	312
100	1	31245	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:20.781844+00	\N	313
101	1	31306	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:20.785363+00	\N	314
102	1	30867	1	t	LOCALCIRCLE	\N	31-08-2010	\N	2010-12-02 17:08:20.785765+00	\N	315
103	1	30869	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:20.78616+00	\N	316
104	1	30847	1	t	LOCALCIRCLE	\N	31-08-2010	\N	2010-12-02 17:08:20.786617+00	\N	317
105	1	30853	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:20.78701+00	\N	318
106	1	30860	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:20.787399+00	\N	319
107	1	33784	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:20.787793+00	\N	320
108	1	31521	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:20.788188+00	\N	321
109	1	33755	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:20.788575+00	\N	322
110	1	31365	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:20.78897+00	\N	323
111	1	30943	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:20.78936+00	\N	324
112	1	31314	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:20.789753+00	\N	325
113	1	33788	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.794964+00	\N	326
114	1	33791	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:20.795352+00	\N	327
115	1	33763	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:20.79574+00	\N	328
116	1	33759	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:20.796128+00	\N	329
117	1	33749	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:20.796516+00	\N	330
118	1	33745	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.796909+00	\N	331
119	1	30986	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:20.7973+00	\N	332
120	1	30987	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:20.797693+00	\N	333
121	1	30987	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:20.798086+00	\N	334
122	1	30976	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:20.798478+00	\N	335
123	1	30712	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:20.798871+00	\N	336
124	1	30644	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:20.80329+00	\N	337
125	1	29704	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:20.803682+00	\N	338
126	1	29700	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:20.804124+00	\N	339
127	1	29697	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:20.804515+00	\N	340
128	1	33772	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:20.804907+00	\N	341
129	1	31486	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:20.8053+00	\N	342
130	1	31485	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:20.805692+00	\N	343
131	1	31480	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:20.806087+00	\N	344
132	1	31476	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:20.806479+00	\N	345
133	1	33849	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:20.806871+00	\N	346
134	1	31474	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:20.807264+00	\N	347
135	1	31468	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:20.807658+00	\N	348
136	1	31465	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:20.808203+00	\N	349
137	1	31401	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:20.808592+00	\N	350
138	1	31386	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:20.808987+00	\N	351
139	1	30736	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:20.809377+00	\N	352
140	1	30722	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:20.809771+00	\N	353
141	1	30710	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:20.810228+00	\N	354
142	1	30716	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:20.810616+00	\N	355
143	1	30721	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:20.81101+00	\N	356
144	1	30695	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:20.8114+00	\N	357
145	1	30685	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:20.811795+00	\N	358
146	1	30691	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:20.812186+00	\N	359
147	1	34015	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:20.812577+00	\N	360
148	1	34013	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:20.812977+00	\N	361
149	1	33807	1	t	LOCALCIRCLE	\N	17-07-2010	\N	2010-12-02 17:08:20.820023+00	\N	362
150	1	33814	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:20.820426+00	\N	363
151	1	33785	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:20.820818+00	\N	364
152	1	33779	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:20.821211+00	\N	365
153	1	33778	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:20.821603+00	\N	366
154	1	33770	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:20.821998+00	\N	367
155	1	33776	1	t	LOCALCIRCLE	\N	17-07-2010	\N	2010-12-02 17:08:20.822388+00	\N	368
156	1	33764	1	t	LOCALCIRCLE	\N	17-07-2010	\N	2010-12-02 17:08:20.822783+00	\N	369
159	1	33748	1	t	LOCALCIRCLE	\N	17-07-2010	\N	2010-12-02 17:08:20.823998+00	\N	372
160	1	31027	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:20.831871+00	\N	382
161	1	30505	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:20.832264+00	\N	383
162	1	30511	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:20.832654+00	\N	384
163	1	30500	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:20.833078+00	\N	385
164	1	30503	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:20.836685+00	\N	386
165	1	30501	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:20.837074+00	\N	387
166	1	30499	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:20.837461+00	\N	388
167	1	30497	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:20.837848+00	\N	389
168	1	30498	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:20.838285+00	\N	390
169	1	30494	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:20.838673+00	\N	391
170	1	30496	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:20.839063+00	\N	392
171	1	30491	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:20.839449+00	\N	393
172	1	30594	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:20.839842+00	\N	394
173	1	34081	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:20.840234+00	\N	395
174	1	34048	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:20.841048+00	\N	397
175	1	33895	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:20.845096+00	\N	398
176	1	33844	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:20.845485+00	\N	399
177	1	33878	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:20.845883+00	\N	400
178	1	33880	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:20.846271+00	\N	401
179	1	33876	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:20.846661+00	\N	402
180	1	33821	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:20.847058+00	\N	403
181	1	33816	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:20.847448+00	\N	404
182	1	33812	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:20.847843+00	\N	405
183	1	31536	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:20.848234+00	\N	406
184	1	31534	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:20.848626+00	\N	407
185	1	31279	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:20.849021+00	\N	408
186	1	31269	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:20.84941+00	\N	409
187	1	31262	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:20.849803+00	\N	410
188	1	31225	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:20.850265+00	\N	411
189	1	31250	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:20.850651+00	\N	412
190	1	31217	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:20.851044+00	\N	413
191	1	31213	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:20.851433+00	\N	414
192	1	30732	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:20.851827+00	\N	415
193	1	30724	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:20.852219+00	\N	416
194	1	30718	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:20.85261+00	\N	417
195	1	33990	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:20.853003+00	\N	418
196	1	33988	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:20.853398+00	\N	419
197	1	33840	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:20.853792+00	\N	420
198	1	33839	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:20.85418+00	\N	421
199	1	33836	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:20.854573+00	\N	422
200	1	31380	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:20.854996+00	\N	423
201	1	31284	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:20.861744+00	\N	424
202	1	31341	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:20.862127+00	\N	425
203	1	31350	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:20.862509+00	\N	426
204	1	31229	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:20.86294+00	\N	427
205	1	31261	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:20.863324+00	\N	428
206	1	31208	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:20.863731+00	\N	429
207	1	31209	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:20.864118+00	\N	430
208	1	31216	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:20.864506+00	\N	431
209	1	31030	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:20.864897+00	\N	432
210	1	31031	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:20.86529+00	\N	433
211	1	31045	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:20.865682+00	\N	434
212	1	31190	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:20.866106+00	\N	435
213	1	31204	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:20.870153+00	\N	436
214	1	31017	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:20.870543+00	\N	437
215	1	31025	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:20.870937+00	\N	438
216	1	31004	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:20.871328+00	\N	439
217	1	31007	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:20.871722+00	\N	440
218	1	31010	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:20.872168+00	\N	441
219	1	33848	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:20.872599+00	\N	442
220	1	30998	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:20.872993+00	\N	443
221	1	31003	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:20.873383+00	\N	444
222	1	30996	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:20.873775+00	\N	445
223	1	34097	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:20.874168+00	\N	446
224	1	34044	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:20.874573+00	\N	447
225	1	34036	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:20.874964+00	\N	448
226	1	33980	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:20.878469+00	\N	449
227	1	33975	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:20.878876+00	\N	450
228	1	31491	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:20.87927+00	\N	451
229	1	31481	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:20.879664+00	\N	452
230	1	31418	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:20.880082+00	\N	453
231	1	31372	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:20.880477+00	\N	454
232	1	31404	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:20.880869+00	\N	455
233	1	31087	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:20.881261+00	\N	456
234	1	31094	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:20.881654+00	\N	457
235	1	31369	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:20.882049+00	\N	458
236	1	30650	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:20.882509+00	\N	459
237	1	30533	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:20.882927+00	\N	460
238	1	30620	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:20.886802+00	\N	461
239	1	30467	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:20.887193+00	\N	462
240	1	30635	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:20.88764+00	\N	463
241	1	30627	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:20.88806+00	\N	464
242	1	30433	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:20.88845+00	\N	465
243	1	30434	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:20.888845+00	\N	466
244	1	30439	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:20.889234+00	\N	467
245	1	30431	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:20.889626+00	\N	468
246	1	30432	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:20.89002+00	\N	469
247	1	30429	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:20.89041+00	\N	470
248	1	30414	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:20.890804+00	\N	471
249	1	30425	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:20.891319+00	\N	472
250	1	30427	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:20.891712+00	\N	473
251	1	30413	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:20.892104+00	\N	474
252	1	30397	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:20.892493+00	\N	475
253	1	30399	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:20.892887+00	\N	476
254	1	30395	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:20.893278+00	\N	477
255	1	30393	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:20.893671+00	\N	478
256	1	30390	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:20.894065+00	\N	479
257	1	30384	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:20.894457+00	\N	480
258	1	30385	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:20.894848+00	\N	481
259	1	30379	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:20.895242+00	\N	482
260	1	30381	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:20.895634+00	\N	483
261	1	30334	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:20.896057+00	\N	484
262	1	34012	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:20.903542+00	\N	485
263	1	33711	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:20.903938+00	\N	486
264	1	33712	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:20.904331+00	\N	487
265	1	34011	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:20.904722+00	\N	488
266	1	33710	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:20.905117+00	\N	489
267	1	33706	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:20.905507+00	\N	490
268	1	33707	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:20.905899+00	\N	491
269	1	33708	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:20.906291+00	\N	492
270	1	33705	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:20.906698+00	\N	493
271	1	33462	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:20.907104+00	\N	494
272	1	33704	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:20.907499+00	\N	495
273	1	33459	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:20.907905+00	\N	496
274	1	33455	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:20.91186+00	\N	497
275	1	33453	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:20.912251+00	\N	498
276	1	33452	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:20.91264+00	\N	499
277	1	31324	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:20.913089+00	\N	500
278	1	31335	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:20.913484+00	\N	501
279	1	31349	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:20.913874+00	\N	502
280	1	31320	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:20.914264+00	\N	503
281	1	31313	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:20.914659+00	\N	504
282	1	31307	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:20.915049+00	\N	505
283	1	31310	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:20.915439+00	\N	506
284	1	31312	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:20.915834+00	\N	507
285	1	29576	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:20.916344+00	\N	508
286	1	30380	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:20.916738+00	\N	509
287	1	30966	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:20.917133+00	\N	510
288	1	30443	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:20.917522+00	\N	511
289	1	30929	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:20.917916+00	\N	512
290	1	30394	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:20.918307+00	\N	513
291	1	30383	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:20.918699+00	\N	514
292	1	33922	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:20.919094+00	\N	515
293	1	29570	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:20.919484+00	\N	516
294	1	33919	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:20.919919+00	\N	517
295	1	33920	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:20.92031+00	\N	518
296	1	33827	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:20.920704+00	\N	519
297	1	31540	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:20.921126+00	\N	520
298	1	30719	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:20.928605+00	\N	521
299	1	30720	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:20.928997+00	\N	522
300	1	30729	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:20.92939+00	\N	523
301	1	30714	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:20.929782+00	\N	524
302	1	34056	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:20.930175+00	\N	525
303	1	30353	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:20.930567+00	\N	526
304	1	30360	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:20.93096+00	\N	527
305	1	30371	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:20.931353+00	\N	528
306	1	30327	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:20.931745+00	\N	529
307	1	30338	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:20.932139+00	\N	530
308	1	30300	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:20.932532+00	\N	531
309	1	30256	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:20.932929+00	\N	532
310	1	30275	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:20.936919+00	\N	533
311	1	30299	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:20.937312+00	\N	534
312	1	30241	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:20.937705+00	\N	535
313	1	29611	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:20.938153+00	\N	536
314	1	29618	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:20.938545+00	\N	537
315	1	29623	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:20.938936+00	\N	538
316	1	29629	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:20.939326+00	\N	539
317	1	29629	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:20.93972+00	\N	540
318	1	30229	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:20.940117+00	\N	541
319	1	29607	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:20.940508+00	\N	542
320	1	34153	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.9409+00	\N	543
321	1	34102	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.941358+00	\N	544
322	1	34100	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.941749+00	\N	545
323	1	34099	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.942143+00	\N	546
324	1	34092	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.942535+00	\N	547
325	1	34095	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.942926+00	\N	548
326	1	34090	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.943335+00	\N	549
327	1	34089	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.94373+00	\N	550
328	1	34069	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.944124+00	\N	551
329	1	34065	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.944514+00	\N	552
330	1	34061	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.944906+00	\N	553
331	1	31516	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.945299+00	\N	554
332	1	31461	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.945691+00	\N	555
333	1	31455	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.946095+00	\N	556
334	1	31460	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.953664+00	\N	557
335	1	31448	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.95406+00	\N	558
336	1	31444	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.954451+00	\N	559
337	1	31410	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.954845+00	\N	560
338	1	31436	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.955237+00	\N	561
339	1	31438	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.955629+00	\N	562
340	1	31447	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.956049+00	\N	563
341	1	30623	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.956442+00	\N	564
342	1	30446	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.956834+00	\N	565
343	1	30437	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.957227+00	\N	566
344	1	30417	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.957619+00	\N	567
345	1	30342	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:20.958011+00	\N	568
346	1	33796	1	t	LOCALCIRCLE	\N	16-08-2010	\N	2010-12-02 17:08:20.961979+00	\N	569
347	1	30989	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:20.962371+00	\N	570
348	1	30973	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:20.962781+00	\N	571
349	1	33930	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:20.963327+00	\N	572
350	1	33931	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:20.963772+00	\N	573
351	1	33738	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:20.964169+00	\N	574
352	1	33733	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:20.964559+00	\N	575
353	1	33613	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:20.964951+00	\N	576
354	1	33606	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:20.965344+00	\N	577
355	1	33604	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:20.965737+00	\N	578
356	1	33600	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:20.966203+00	\N	579
357	1	33596	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:20.970387+00	\N	580
358	1	33591	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:20.970783+00	\N	581
359	1	31528	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:20.971182+00	\N	582
360	1	31393	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:20.971575+00	\N	583
361	1	31385	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:20.971989+00	\N	584
362	1	31364	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:20.972383+00	\N	585
363	1	30936	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:20.972777+00	\N	586
364	1	30933	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:20.973172+00	\N	587
365	1	30923	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:20.973565+00	\N	588
366	1	30836	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:20.973957+00	\N	589
367	1	30780	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:20.97435+00	\N	590
368	1	29691	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:20.974742+00	\N	591
369	1	29642	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:20.975166+00	\N	592
370	1	35110	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:20.978721+00	\N	593
371	1	33964	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:20.979128+00	\N	594
372	1	33958	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:20.979523+00	\N	595
373	1	33881	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:20.979917+00	\N	596
374	1	33904	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:20.98031+00	\N	597
375	1	33857	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:20.980703+00	\N	598
376	1	33877	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:20.981095+00	\N	599
377	1	33843	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:20.981488+00	\N	600
378	1	33851	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:20.981881+00	\N	601
379	1	33853	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:20.982278+00	\N	602
380	1	33838	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:20.98267+00	\N	603
381	1	33835	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:20.983064+00	\N	604
382	1	33833	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:20.987053+00	\N	605
383	1	31267	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:20.987499+00	\N	606
384	1	31256	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:20.987893+00	\N	607
385	1	31215	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:20.988285+00	\N	608
386	1	31211	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:20.988679+00	\N	609
387	1	31196	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:20.989071+00	\N	610
388	1	31035	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:20.989463+00	\N	611
389	1	31026	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:20.989856+00	\N	612
390	1	31018	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:20.990248+00	\N	613
391	1	30997	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:20.99064+00	\N	614
392	1	30874	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:20.991031+00	\N	615
393	1	30873	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:20.995462+00	\N	616
394	1	30773	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:20.995857+00	\N	617
395	1	30759	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:20.99625+00	\N	618
396	1	30727	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:20.996642+00	\N	619
397	1	30726	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:20.997034+00	\N	620
398	1	33943	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:20.997426+00	\N	621
399	1	30352	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:20.997823+00	\N	622
400	1	30349	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:20.998217+00	\N	623
401	1	30343	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:20.99861+00	\N	624
402	1	30335	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:20.999001+00	\N	625
403	1	30332	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:20.999394+00	\N	626
404	1	31356	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:20.999787+00	\N	627
405	1	30331	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.000211+00	\N	628
406	1	30326	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.00378+00	\N	629
407	1	30324	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.004191+00	\N	630
408	1	30319	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.004583+00	\N	631
409	1	33677	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.004977+00	\N	632
410	1	30941	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.00537+00	\N	633
411	1	30931	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.005762+00	\N	634
412	1	30920	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.006154+00	\N	635
413	1	30918	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.006546+00	\N	636
414	1	30915	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.006936+00	\N	637
415	1	30910	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.007329+00	\N	638
416	1	33866	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.007722+00	\N	639
417	1	33845	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.008114+00	\N	640
418	1	31390	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.012111+00	\N	641
419	1	31398	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.012559+00	\N	642
420	1	31392	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.012953+00	\N	643
421	1	31366	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.013345+00	\N	644
422	1	31370	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.013738+00	\N	645
423	1	31383	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.014132+00	\N	646
424	1	31351	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.014525+00	\N	647
425	1	31354	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.014916+00	\N	648
426	1	32560	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:21.01531+00	\N	649
427	1	31346	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.015702+00	\N	650
428	1	31339	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.016115+00	\N	651
429	1	31344	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.02052+00	\N	652
430	1	31227	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.020915+00	\N	653
431	1	31218	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.021307+00	\N	654
432	1	31198	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:21.021701+00	\N	655
433	1	31200	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:21.022093+00	\N	656
434	1	31205	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:21.022486+00	\N	657
435	1	31187	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:21.022877+00	\N	658
436	1	31189	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:21.023271+00	\N	659
437	1	31020	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.023663+00	\N	660
438	1	31047	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.024083+00	\N	661
439	1	31009	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:21.02449+00	\N	662
440	1	34082	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.024886+00	\N	663
441	1	34051	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.025414+00	\N	664
442	1	33972	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.025807+00	\N	665
443	1	33974	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.026201+00	\N	666
444	1	33847	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.026593+00	\N	667
445	1	33858	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.026983+00	\N	668
446	1	33860	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.027375+00	\N	669
447	1	30484	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.027768+00	\N	670
448	1	30502	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.028162+00	\N	671
449	1	30512	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.028555+00	\N	672
450	1	33541	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.028952+00	\N	673
451	1	30469	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.029344+00	\N	674
452	1	30295	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.029737+00	\N	675
453	1	30268	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.03013+00	\N	676
454	1	30231	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.037172+00	\N	677
455	1	30177	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.037577+00	\N	678
456	1	30226	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.038019+00	\N	679
457	1	30174	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.038424+00	\N	680
458	1	29634	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.038818+00	\N	681
459	1	29646	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.039212+00	\N	682
460	1	29638	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.039604+00	\N	683
461	1	29630	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.040023+00	\N	684
462	1	29617	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.040417+00	\N	685
463	1	29622	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.04081+00	\N	686
464	1	29626	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.041246+00	\N	687
465	1	29610	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.045578+00	\N	688
466	1	31089	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:21.045973+00	\N	689
467	1	34019	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:21.046365+00	\N	690
468	1	33634	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:21.046758+00	\N	691
469	1	33454	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:21.047151+00	\N	692
470	1	33460	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:21.047543+00	\N	693
471	1	33463	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:21.047936+00	\N	694
472	1	31159	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:21.048327+00	\N	695
473	1	31482	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:21.048719+00	\N	696
474	1	31487	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:21.049112+00	\N	697
475	1	31119	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:21.049507+00	\N	698
476	1	31103	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:21.049938+00	\N	699
477	1	31059	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:21.050443+00	\N	700
478	1	31083	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:21.050835+00	\N	701
479	1	31055	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:21.05123+00	\N	702
480	1	31058	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:21.051625+00	\N	703
481	1	31053	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:21.052041+00	\N	704
482	1	30639	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:21.052437+00	\N	705
483	1	30631	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:21.052828+00	\N	706
484	1	30593	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:21.05322+00	\N	707
485	1	30593	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:21.053612+00	\N	708
486	1	30629	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:21.054003+00	\N	709
487	1	30534	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:21.054395+00	\N	710
488	1	30588	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:21.054788+00	\N	711
489	1	30471	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:21.055212+00	\N	712
490	1	30532	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:21.062228+00	\N	713
491	1	30373	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:21.06262+00	\N	714
492	1	33842	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.063065+00	\N	715
493	1	33837	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.063459+00	\N	716
494	1	33831	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.06385+00	\N	717
495	1	33823	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.064244+00	\N	718
496	1	33801	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.064636+00	\N	719
497	1	33798	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.065034+00	\N	720
498	1	33790	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.065426+00	\N	721
499	1	33773	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.065818+00	\N	722
500	1	33768	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.066265+00	\N	723
501	1	30519	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.070636+00	\N	724
502	1	30516	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.071031+00	\N	725
503	1	30464	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.071423+00	\N	726
504	1	30459	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.071817+00	\N	727
505	1	34027	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:21.072211+00	\N	728
506	1	31023	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.072603+00	\N	729
507	1	34032	1	t	LOCALCIRCLE	\N	30-08-2010	\N	2010-12-02 17:08:21.072994+00	\N	730
508	1	31342	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:21.073386+00	\N	731
509	1	31355	1	t	LOCALCIRCLE	\N	16-08-2010	\N	2010-12-02 17:08:21.073778+00	\N	732
510	1	31361	1	t	LOCALCIRCLE	\N	16-08-2010	\N	2010-12-02 17:08:21.074171+00	\N	733
511	1	33458	1	t	LOCALCIRCLE	\N	16-08-2010	\N	2010-12-02 17:08:21.074575+00	\N	734
512	1	30954	1	t	LOCALCIRCLE	\N	30-08-2010	\N	2010-12-02 17:08:21.074968+00	\N	735
513	1	30958	1	t	LOCALCIRCLE	\N	30-08-2010	\N	2010-12-02 17:08:21.07547+00	\N	736
514	1	30960	1	t	LOCALCIRCLE	\N	16-08-2010	\N	2010-12-02 17:08:21.075863+00	\N	737
515	1	30963	1	t	LOCALCIRCLE	\N	16-08-2010	\N	2010-12-02 17:08:21.076257+00	\N	738
516	1	30967	1	t	LOCALCIRCLE	\N	30-08-2010	\N	2010-12-02 17:08:21.07665+00	\N	739
517	1	30968	1	t	LOCALCIRCLE	\N	16-08-2010	\N	2010-12-02 17:08:21.077042+00	\N	740
518	1	30970	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:21.077433+00	\N	741
519	1	30972	1	t	LOCALCIRCLE	\N	30-08-2010	\N	2010-12-02 17:08:21.077825+00	\N	742
520	1	30675	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:21.078218+00	\N	743
521	1	30948	1	t	LOCALCIRCLE	\N	30-08-2010	\N	2010-12-02 17:08:21.078613+00	\N	744
522	1	30949	1	t	LOCALCIRCLE	\N	16-08-2010	\N	2010-12-02 17:08:21.079002+00	\N	745
523	1	30952	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:21.079394+00	\N	746
524	1	30657	1	t	LOCALCIRCLE	\N	16-08-2010	\N	2010-12-02 17:08:21.079787+00	\N	747
525	1	30661	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:21.080177+00	\N	748
526	1	30664	1	t	LOCALCIRCLE	\N	16-08-2010	\N	2010-12-02 17:08:21.087304+00	\N	749
527	1	30670	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:21.087699+00	\N	750
528	1	30654	1	t	LOCALCIRCLE	\N	16-08-2010	\N	2010-12-02 17:08:21.088118+00	\N	751
529	1	30653	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:21.088574+00	\N	752
530	1	30648	1	t	LOCALCIRCLE	\N	30-08-2010	\N	2010-12-02 17:08:21.088967+00	\N	753
531	1	30636	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:21.089359+00	\N	754
532	1	30640	1	t	LOCALCIRCLE	\N	16-08-2010	\N	2010-12-02 17:08:21.089751+00	\N	755
533	1	30646	1	t	LOCALCIRCLE	\N	16-08-2010	\N	2010-12-02 17:08:21.090144+00	\N	756
534	1	30404	1	t	LOCALCIRCLE	\N	30-08-2010	\N	2010-12-02 17:08:21.090535+00	\N	757
535	1	30407	1	t	LOCALCIRCLE	\N	30-08-2010	\N	2010-12-02 17:08:21.090927+00	\N	758
536	1	34094	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.091354+00	\N	759
537	1	33902	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.095696+00	\N	760
538	1	31430	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.096103+00	\N	761
539	1	31303	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.096509+00	\N	762
540	1	31300	1	t	LOCALCIRCLE	\N	26-08-2010	\N	2010-12-02 17:08:21.096904+00	\N	763
541	1	31299	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.097299+00	\N	764
542	1	31298	1	t	LOCALCIRCLE	\N	26-08-2010	\N	2010-12-02 17:08:21.097691+00	\N	765
543	1	31296	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.098084+00	\N	766
544	1	31293	1	t	LOCALCIRCLE	\N	26-08-2010	\N	2010-12-02 17:08:21.098476+00	\N	767
545	1	31291	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.098867+00	\N	768
546	1	31287	1	t	LOCALCIRCLE	\N	26-08-2010	\N	2010-12-02 17:08:21.099259+00	\N	769
547	1	31278	1	t	LOCALCIRCLE	\N	26-08-2010	\N	2010-12-02 17:08:21.099652+00	\N	770
548	1	31015	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.100072+00	\N	771
549	1	30584	1	t	LOCALCIRCLE	\N	26-08-2010	\N	2010-12-02 17:08:21.100534+00	\N	772
550	1	31005	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.100926+00	\N	773
551	1	34047	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:21.10132+00	\N	774
552	1	31473	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:21.101712+00	\N	775
553	1	34045	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:21.102104+00	\N	776
554	1	31472	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:21.102496+00	\N	777
555	1	31470	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:21.102887+00	\N	778
556	1	31471	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:21.10328+00	\N	779
557	1	31469	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:21.103672+00	\N	780
558	1	31463	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:21.10409+00	\N	781
559	1	31452	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:21.104483+00	\N	782
560	1	31462	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:21.104875+00	\N	783
561	1	31458	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:21.105276+00	\N	784
562	1	31456	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:21.112361+00	\N	785
563	1	31449	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:21.112755+00	\N	786
564	1	31440	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:21.113147+00	\N	787
565	1	31434	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:21.113603+00	\N	788
566	1	31397	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:21.113996+00	\N	789
567	1	31389	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:21.114388+00	\N	790
568	1	33689	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.114781+00	\N	791
569	1	31381	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:21.115174+00	\N	792
570	1	31384	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:21.115567+00	\N	793
571	1	31043	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:21.115984+00	\N	794
572	1	31378	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:21.1165+00	\N	795
573	1	30440	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.116892+00	\N	796
574	1	30436	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:21.117287+00	\N	797
575	1	33794	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.117679+00	\N	798
576	1	33795	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.118072+00	\N	799
577	1	33701	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.118464+00	\N	800
578	1	33735	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.118861+00	\N	801
579	1	31163	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.119253+00	\N	802
580	1	31168	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.119646+00	\N	803
581	1	31391	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.120061+00	\N	804
582	1	31395	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.120454+00	\N	805
583	1	31142	1	t	LOCALCIRCLE	\N	30-08-2010	\N	2010-12-02 17:08:21.120845+00	\N	806
584	1	31134	1	t	LOCALCIRCLE	\N	30-08-2010	\N	2010-12-02 17:08:21.121268+00	\N	807
585	1	31135	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.129086+00	\N	808
586	1	31136	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.12948+00	\N	809
587	1	31130	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.129872+00	\N	810
588	1	31131	1	t	LOCALCIRCLE	\N	30-08-2010	\N	2010-12-02 17:08:21.130269+00	\N	811
589	1	31140	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.130659+00	\N	812
590	1	31117	1	t	LOCALCIRCLE	\N	30-08-2010	\N	2010-12-02 17:08:21.13105+00	\N	813
591	1	31123	1	t	LOCALCIRCLE	\N	30-08-2010	\N	2010-12-02 17:08:21.131442+00	\N	814
592	1	31128	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.131836+00	\N	815
593	1	31109	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.132227+00	\N	816
594	1	31116	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.132619+00	\N	817
595	1	31101	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.133012+00	\N	818
596	1	30492	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:21.133555+00	\N	819
597	1	30531	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.133949+00	\N	820
598	1	29593	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.134344+00	\N	821
599	1	33944	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.134736+00	\N	822
600	1	34139	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.13513+00	\N	823
601	1	33699	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.135522+00	\N	824
602	1	33942	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.13598+00	\N	825
603	1	33696	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.136374+00	\N	826
604	1	33623	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.136765+00	\N	827
605	1	33624	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.137158+00	\N	828
606	1	33687	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.137549+00	\N	829
607	1	33619	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.137941+00	\N	830
608	1	33620	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.138362+00	\N	831
609	1	33602	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.145815+00	\N	832
610	1	33587	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.146206+00	\N	833
611	1	33598	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.146597+00	\N	834
612	1	33594	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.146989+00	\N	835
613	1	30908	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.147383+00	\N	836
614	1	30926	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.147807+00	\N	837
615	1	33582	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.148201+00	\N	838
616	1	30827	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.148594+00	\N	839
617	1	30838	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.148987+00	\N	840
618	1	30797	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.149382+00	\N	841
619	1	30810	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.149779+00	\N	842
620	1	30820	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.150172+00	\N	843
621	1	30794	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.15413+00	\N	844
622	1	30787	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.154538+00	\N	845
623	1	30793	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.154932+00	\N	846
624	1	30556	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.155327+00	\N	847
625	1	30542	1	t	LOCALCIRCLE	\N	21-06-2010	\N	2010-12-02 17:08:21.155721+00	\N	848
626	1	30225	1	t	LOCALCIRCLE	\N	21-06-2010	\N	2010-12-02 17:08:21.156114+00	\N	849
627	1	33672	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:21.156507+00	\N	850
628	1	30219	1	t	LOCALCIRCLE	\N	21-06-2010	\N	2010-12-02 17:08:21.156899+00	\N	851
629	1	29841	1	t	LOCALCIRCLE	\N	19-06-2010	\N	2010-12-02 17:08:21.157293+00	\N	852
630	1	29685	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:21.157687+00	\N	853
631	1	29689	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:21.15808+00	\N	854
632	1	29693	1	t	LOCALCIRCLE	\N	19-06-2010	\N	2010-12-02 17:08:21.158567+00	\N	855
633	1	29677	1	t	LOCALCIRCLE	\N	19-06-2010	\N	2010-12-02 17:08:21.15896+00	\N	856
634	1	29680	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:21.159368+00	\N	857
635	1	29678	1	t	LOCALCIRCLE	\N	21-06-2010	\N	2010-12-02 17:08:21.159764+00	\N	858
636	1	29676	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:21.160157+00	\N	859
637	1	29673	1	t	LOCALCIRCLE	\N	19-06-2010	\N	2010-12-02 17:08:21.16055+00	\N	860
638	1	29672	1	t	LOCALCIRCLE	\N	19-06-2010	\N	2010-12-02 17:08:21.161006+00	\N	861
639	1	29670	1	t	LOCALCIRCLE	\N	19-06-2010	\N	2010-12-02 17:08:21.161401+00	\N	862
640	1	29669	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:21.161794+00	\N	863
641	1	29668	1	t	LOCALCIRCLE	\N	19-06-2010	\N	2010-12-02 17:08:21.162187+00	\N	864
642	1	29665	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:21.16258+00	\N	865
643	1	29661	1	t	LOCALCIRCLE	\N	19-06-2010	\N	2010-12-02 17:08:21.162987+00	\N	866
644	1	29659	1	t	LOCALCIRCLE	\N	21-06-2010	\N	2010-12-02 17:08:21.163417+00	\N	867
645	1	29655	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:21.170872+00	\N	868
646	1	29651	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:21.171267+00	\N	869
647	1	29648	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:21.171661+00	\N	870
648	1	29647	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:21.172081+00	\N	871
649	1	29643	1	t	LOCALCIRCLE	\N	21-06-2010	\N	2010-12-02 17:08:21.172474+00	\N	872
650	1	29639	1	t	LOCALCIRCLE	\N	21-06-2010	\N	2010-12-02 17:08:21.172867+00	\N	873
651	1	29636	1	t	LOCALCIRCLE	\N	21-06-2010	\N	2010-12-02 17:08:21.17326+00	\N	874
652	1	29633	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:21.173653+00	\N	875
653	1	29631	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:21.174047+00	\N	876
654	1	29627	1	t	LOCALCIRCLE	\N	21-06-2010	\N	2010-12-02 17:08:21.174439+00	\N	877
655	1	29624	1	t	LOCALCIRCLE	\N	19-06-2010	\N	2010-12-02 17:08:21.174833+00	\N	878
656	1	30586	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.175227+00	\N	879
657	1	33938	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.179188+00	\N	880
658	1	33901	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.179592+00	\N	881
659	1	33907	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.180025+00	\N	882
660	1	33933	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.180417+00	\N	883
661	1	33887	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.180809+00	\N	884
662	1	33888	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.181201+00	\N	885
663	1	33884	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.181594+00	\N	886
664	1	33800	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.181986+00	\N	887
665	1	33874	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.182382+00	\N	888
666	1	33879	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.182774+00	\N	889
667	1	33883	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.183168+00	\N	890
668	1	31439	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.18752+00	\N	891
669	1	31294	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.188038+00	\N	892
670	1	31317	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.188444+00	\N	893
671	1	31282	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.188837+00	\N	894
672	1	30999	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.189229+00	\N	895
673	1	31001	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.189624+00	\N	896
674	1	30993	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.190017+00	\N	897
675	1	30982	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.190471+00	\N	898
676	1	33936	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:21.190863+00	\N	899
677	1	33937	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:21.191259+00	\N	900
678	1	33841	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:21.191652+00	\N	901
679	1	33825	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:21.192068+00	\N	902
680	1	33829	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:21.192585+00	\N	903
681	1	33834	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.192977+00	\N	904
682	1	33810	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.193371+00	\N	905
683	1	33802	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:21.193767+00	\N	906
684	1	33797	1	t	LOCALCIRCLE	\N	19-07-2010	\N	2010-12-02 17:08:21.194159+00	\N	907
685	1	33787	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.194551+00	\N	908
686	1	33775	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.194942+00	\N	909
687	1	33780	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.195334+00	\N	910
688	1	33766	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:21.195727+00	\N	911
689	1	33762	1	t	LOCALCIRCLE	\N	19-07-2010	\N	2010-12-02 17:08:21.19612+00	\N	912
690	1	30673	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:21.196516+00	\N	913
691	1	30671	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:21.196909+00	\N	914
692	1	30649	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.197331+00	\N	915
693	1	30666	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.204266+00	\N	916
694	1	30577	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.204661+00	\N	917
695	1	30578	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.205053+00	\N	918
696	1	30637	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:21.205446+00	\N	919
697	1	30544	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.205838+00	\N	920
698	1	30572	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.206231+00	\N	921
699	1	30493	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:21.206623+00	\N	922
700	1	30388	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:21.207014+00	\N	923
701	1	30400	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:21.207408+00	\N	924
702	1	29709	1	t	LOCALCIRCLE	\N	19-07-2010	\N	2010-12-02 17:08:21.207826+00	\N	925
703	1	29596	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:21.208223+00	\N	926
704	1	33969	1	t	LOCALCIRCLE	\N	19-07-2010	\N	2010-12-02 17:08:21.212579+00	\N	927
705	1	29563	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:21.212971+00	\N	928
706	1	29572	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.213378+00	\N	929
707	1	29583	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:21.213774+00	\N	930
708	1	31500	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:21.214165+00	\N	931
709	1	31522	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:21.214558+00	\N	932
710	1	33959	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:21.214951+00	\N	933
711	1	33960	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:21.215406+00	\N	934
712	1	33965	1	t	LOCALCIRCLE	\N	19-07-2010	\N	2010-12-02 17:08:21.2158+00	\N	935
713	1	33966	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:21.216218+00	\N	936
714	1	33968	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:21.216612+00	\N	937
715	1	31454	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:21.217071+00	\N	938
716	1	31450	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:21.217605+00	\N	939
717	1	31446	1	t	LOCALCIRCLE	\N	19-07-2010	\N	2010-12-02 17:08:21.217997+00	\N	940
718	1	31443	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:21.218391+00	\N	941
719	1	31429	1	t	LOCALCIRCLE	\N	19-07-2010	\N	2010-12-02 17:08:21.218782+00	\N	942
720	1	31316	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:21.219174+00	\N	943
721	1	31286	1	t	LOCALCIRCLE	\N	19-07-2010	\N	2010-12-02 17:08:21.219567+00	\N	944
722	1	30957	1	t	LOCALCIRCLE	\N	19-07-2010	\N	2010-12-02 17:08:21.219974+00	\N	945
723	1	30969	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:21.220367+00	\N	946
724	1	30662	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:21.220763+00	\N	947
725	1	30669	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:21.221168+00	\N	948
726	1	30687	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:21.221563+00	\N	949
727	1	30656	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:21.221955+00	\N	950
728	1	30589	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:21.222388+00	\N	951
729	1	30541	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:21.229321+00	\N	952
730	1	30408	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:21.229716+00	\N	953
731	1	31388	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.230109+00	\N	954
732	1	30403	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:21.230501+00	\N	955
733	1	29708	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:21.230893+00	\N	956
734	1	29684	1	t	LOCALCIRCLE	\N	19-07-2010	\N	2010-12-02 17:08:21.231286+00	\N	957
735	1	33635	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.231678+00	\N	958
736	1	33793	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.232098+00	\N	959
737	1	33808	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.232491+00	\N	960
738	1	31531	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.232897+00	\N	961
739	1	31403	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.233289+00	\N	962
740	1	31399	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.237637+00	\N	963
741	1	31377	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.23803+00	\N	964
742	1	31371	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.238438+00	\N	965
743	1	31184	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.238832+00	\N	966
744	1	31158	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.239224+00	\N	967
745	1	31154	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.239621+00	\N	968
746	1	31146	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.24004+00	\N	969
747	1	31144	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.240434+00	\N	970
748	1	31139	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.240828+00	\N	971
749	1	31127	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.241245+00	\N	972
750	1	31113	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.24164+00	\N	973
751	1	31100	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.242033+00	\N	974
752	1	31073	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.242457+00	\N	975
753	1	30711	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.246045+00	\N	976
754	1	30703	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.246443+00	\N	977
755	1	30699	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.246836+00	\N	978
756	1	30698	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.247229+00	\N	979
757	1	30692	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.247621+00	\N	980
758	1	30686	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.24804+00	\N	981
759	1	30683	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.248436+00	\N	982
760	1	30525	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.248829+00	\N	983
761	1	33563	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.249221+00	\N	984
762	1	33565	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.249615+00	\N	985
763	1	33561	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.250007+00	\N	986
764	1	33555	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.250424+00	\N	987
765	1	33557	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.254363+00	\N	988
766	1	33559	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.254769+00	\N	989
767	1	33554	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.255165+00	\N	990
768	1	33552	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.255556+00	\N	991
769	1	33551	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.25595+00	\N	992
770	1	33549	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.256343+00	\N	993
771	1	33548	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.256736+00	\N	994
772	1	33544	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.25713+00	\N	995
773	1	33545	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.257521+00	\N	996
774	1	33547	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.25792+00	\N	997
775	1	33543	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.258313+00	\N	998
776	1	33673	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:21.262712+00	\N	999
777	1	30812	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.263104+00	\N	1000
778	1	30814	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.263497+00	\N	1001
779	1	30816	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.26389+00	\N	1002
780	1	30826	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.264283+00	\N	1003
781	1	30806	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.264738+00	\N	1004
782	1	29586	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.265131+00	\N	1005
783	1	33898	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.265523+00	\N	1006
784	1	33875	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:21.265915+00	\N	1007
785	1	31411	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:21.266307+00	\N	1008
786	1	31373	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:21.2667+00	\N	1009
787	1	31221	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:21.267091+00	\N	1010
788	1	31207	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.267514+00	\N	1011
789	1	31191	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:21.271103+00	\N	1012
790	1	31201	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:21.271499+00	\N	1013
791	1	31185	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.271892+00	\N	1014
792	1	31039	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:21.272284+00	\N	1015
793	1	31038	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.272676+00	\N	1016
794	1	31036	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.273068+00	\N	1017
795	1	31034	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:21.273462+00	\N	1018
796	1	31028	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.273853+00	\N	1019
797	1	31016	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.274245+00	\N	1020
798	1	31012	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.27464+00	\N	1021
799	1	31000	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.275033+00	\N	1022
800	1	30535	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.275434+00	\N	1023
801	1	30528	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.279419+00	\N	1024
802	1	30520	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.279812+00	\N	1025
803	1	33962	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.280202+00	\N	1026
804	1	33867	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.280596+00	\N	1027
805	1	31322	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.280986+00	\N	1028
806	1	31464	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.281376+00	\N	1029
807	1	31273	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.281766+00	\N	1030
808	1	31231	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.28216+00	\N	1031
809	1	31228	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.28255+00	\N	1032
810	1	31223	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.282982+00	\N	1033
811	1	30772	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.283376+00	\N	1034
812	1	30770	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.287754+00	\N	1035
813	1	30769	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.288161+00	\N	1036
814	1	30767	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.288555+00	\N	1037
815	1	30766	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.288949+00	\N	1038
816	1	30762	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.289341+00	\N	1039
817	1	30761	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.289798+00	\N	1040
818	1	30760	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.290191+00	\N	1041
819	1	30757	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.290585+00	\N	1042
820	1	30753	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.290978+00	\N	1043
821	1	30751	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.291371+00	\N	1044
822	1	30749	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.291766+00	\N	1045
823	1	30738	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.292159+00	\N	1046
824	1	30734	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.292669+00	\N	1047
825	1	30731	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.293063+00	\N	1048
826	1	30728	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.293458+00	\N	1049
827	1	33581	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.293869+00	\N	1050
828	1	33579	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.294262+00	\N	1051
829	1	33574	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.294655+00	\N	1052
830	1	33572	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.295047+00	\N	1053
831	1	33571	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.29544+00	\N	1054
832	1	33570	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.295833+00	\N	1055
833	1	33568	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.296226+00	\N	1056
834	1	33569	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.296618+00	\N	1057
835	1	33567	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.297012+00	\N	1058
836	1	33566	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.29746+00	\N	1059
837	1	33564	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.304498+00	\N	1060
838	1	33562	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.304891+00	\N	1061
839	1	33553	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.305284+00	\N	1062
840	1	33676	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:21.305677+00	\N	1063
841	1	33556	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.30607+00	\N	1064
842	1	33558	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.306465+00	\N	1065
843	1	33560	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.306858+00	\N	1066
844	1	33550	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.307251+00	\N	1067
845	1	30821	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.307647+00	\N	1068
846	1	30896	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.308059+00	\N	1069
847	1	30817	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.308464+00	\N	1070
848	1	30807	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.312811+00	\N	1071
849	1	30809	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.313205+00	\N	1072
850	1	30815	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.313597+00	\N	1073
851	1	33973	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.31399+00	\N	1074
852	1	33963	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.314383+00	\N	1075
853	1	33702	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:21.314789+00	\N	1076
854	1	33695	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.315231+00	\N	1077
855	1	33698	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.315637+00	\N	1078
856	1	33690	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.316057+00	\N	1079
857	1	33693	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.316452+00	\N	1080
858	1	33683	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.316845+00	\N	1081
859	1	33685	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.317242+00	\N	1082
860	1	33688	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.317718+00	\N	1083
861	1	33679	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.318113+00	\N	1084
862	1	33681	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:21.318507+00	\N	1085
863	1	33647	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.318897+00	\N	1086
864	1	33662	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:21.319289+00	\N	1087
865	1	33646	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:21.319682+00	\N	1088
866	1	33643	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:21.320102+00	\N	1089
867	1	33641	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:21.3205+00	\N	1090
868	1	33637	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:21.320892+00	\N	1091
869	1	33638	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:21.321283+00	\N	1092
870	1	33636	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:21.321675+00	\N	1093
871	1	31357	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.322067+00	\N	1094
872	1	33664	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.322472+00	\N	1095
873	1	33592	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.329556+00	\N	1096
874	1	33588	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.32995+00	\N	1097
875	1	33580	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.330341+00	\N	1098
876	1	33584	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.330734+00	\N	1099
877	1	33575	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.331126+00	\N	1100
878	1	33578	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.33152+00	\N	1101
879	1	31466	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.331914+00	\N	1102
880	1	31396	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.332305+00	\N	1103
881	1	31387	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.332696+00	\N	1104
882	1	31382	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.333087+00	\N	1105
883	1	31379	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.333488+00	\N	1106
884	1	31376	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.337869+00	\N	1107
885	1	31375	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.338265+00	\N	1108
886	1	30790	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.33867+00	\N	1109
887	1	33352	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:21.339065+00	\N	1110
888	1	30788	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.339459+00	\N	1111
889	1	30786	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.339854+00	\N	1112
890	1	30784	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.340308+00	\N	1113
891	1	29581	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.340701+00	\N	1114
892	1	29566	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.341094+00	\N	1115
893	1	29564	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.341486+00	\N	1116
894	1	31252	1	t	LOCALCIRCLE	\N	19-07-2010	\N	2010-12-02 17:08:21.341878+00	\N	1117
895	1	31247	1	t	LOCALCIRCLE	\N	04-09-2010	\N	2010-12-02 17:08:21.342269+00	\N	1118
896	1	31246	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.342747+00	\N	1119
897	1	30752	1	t	LOCALCIRCLE	\N	04-09-2010	\N	2010-12-02 17:08:21.343141+00	\N	1120
898	1	30748	1	t	LOCALCIRCLE	\N	04-09-2010	\N	2010-12-02 17:08:21.343537+00	\N	1121
899	1	30746	1	t	LOCALCIRCLE	\N	04-09-2010	\N	2010-12-02 17:08:21.343929+00	\N	1122
900	1	30485	1	t	LOCALCIRCLE	\N	04-09-2010	\N	2010-12-02 17:08:21.34432+00	\N	1123
901	1	30478	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:21.344711+00	\N	1124
902	1	30477	1	t	LOCALCIRCLE	\N	04-09-2010	\N	2010-12-02 17:08:21.345102+00	\N	1125
903	1	30476	1	t	LOCALCIRCLE	\N	04-09-2010	\N	2010-12-02 17:08:21.345493+00	\N	1126
904	1	34034	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.345886+00	\N	1127
905	1	31084	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.346279+00	\N	1128
906	1	31107	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.346672+00	\N	1129
907	1	31406	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.347063+00	\N	1130
908	1	31078	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.347486+00	\N	1131
909	1	31070	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.354617+00	\N	1132
910	1	31066	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.355013+00	\N	1133
911	1	30713	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.355407+00	\N	1134
912	1	30697	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.355802+00	\N	1135
913	1	30690	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.356212+00	\N	1136
914	1	30682	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.356607+00	\N	1137
915	1	30681	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.357+00	\N	1138
916	1	30674	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.357394+00	\N	1139
917	1	30668	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.357811+00	\N	1140
918	1	30667	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.358208+00	\N	1141
919	1	30543	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.3586+00	\N	1142
920	1	30658	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.358993+00	\N	1143
921	1	30517	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.359386+00	\N	1144
922	1	33760	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.362929+00	\N	1145
923	1	33721	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.363333+00	\N	1146
924	1	33729	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.363733+00	\N	1147
925	1	33756	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.36413+00	\N	1148
926	1	33720	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.364525+00	\N	1149
927	1	33718	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.364974+00	\N	1150
928	1	33717	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.365368+00	\N	1151
929	1	33716	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.36576+00	\N	1152
930	1	33714	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.366178+00	\N	1153
931	1	33715	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.366572+00	\N	1154
932	1	33461	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.366964+00	\N	1155
933	1	33713	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.367355+00	\N	1156
934	1	33451	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.371337+00	\N	1157
935	1	33456	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.371738+00	\N	1158
936	1	33457	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.37213+00	\N	1159
937	1	33448	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.372522+00	\N	1160
938	1	33450	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.372915+00	\N	1161
939	1	31347	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.373307+00	\N	1162
940	1	31517	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.373698+00	\N	1163
941	1	33447	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.374091+00	\N	1164
942	1	31343	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.374485+00	\N	1165
943	1	31326	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.374877+00	\N	1166
944	1	31328	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.37527+00	\N	1167
945	1	31331	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.375779+00	\N	1168
946	1	31333	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.376171+00	\N	1169
947	1	31334	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.376567+00	\N	1170
948	1	31338	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.376959+00	\N	1171
949	1	29568	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.377351+00	\N	1172
950	1	30386	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.377743+00	\N	1173
951	1	30389	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.378135+00	\N	1174
952	1	33815	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:21.378527+00	\N	1175
953	1	29565	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.378918+00	\N	1176
954	1	33783	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:21.37931+00	\N	1177
955	1	33786	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:21.379703+00	\N	1178
956	1	33792	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:21.380156+00	\N	1179
957	1	30663	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:21.380581+00	\N	1180
958	1	30955	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:21.387989+00	\N	1181
959	1	30959	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:21.388396+00	\N	1182
960	1	30964	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:21.388789+00	\N	1183
961	1	31321	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:21.389182+00	\N	1184
962	1	31330	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:21.389576+00	\N	1185
963	1	33747	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:21.390034+00	\N	1186
964	1	33751	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:21.390431+00	\N	1187
965	1	33753	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:21.390845+00	\N	1188
966	1	33761	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:21.391248+00	\N	1189
967	1	33765	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:21.391658+00	\N	1190
968	1	33774	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:21.392082+00	\N	1191
969	1	33777	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:21.392477+00	\N	1192
970	1	30655	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:21.396396+00	\N	1193
971	1	30660	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:21.396793+00	\N	1194
972	1	30651	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:21.397189+00	\N	1195
973	1	30652	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:21.397588+00	\N	1196
974	1	30647	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:21.397995+00	\N	1197
975	1	30645	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:21.39839+00	\N	1198
976	1	29619	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.398785+00	\N	1199
977	1	33826	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.399181+00	\N	1200
978	1	31508	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.399579+00	\N	1201
979	1	31535	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.399992+00	\N	1202
980	1	31537	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.400387+00	\N	1203
981	1	31506	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.404715+00	\N	1204
982	1	31501	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.405123+00	\N	1205
983	1	31499	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.405522+00	\N	1206
984	1	31497	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.405917+00	\N	1207
985	1	31323	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.406314+00	\N	1208
986	1	31319	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.406727+00	\N	1209
987	1	31318	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.407124+00	\N	1210
988	1	31305	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.407522+00	\N	1211
989	1	31258	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.40793+00	\N	1212
990	1	31268	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.408326+00	\N	1213
991	1	31264	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.408722+00	\N	1214
992	1	31254	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.409118+00	\N	1215
993	1	31234	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.409543+00	\N	1216
994	1	31230	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.413046+00	\N	1217
995	1	30845	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.413456+00	\N	1218
996	1	30851	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.413852+00	\N	1219
997	1	30846	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.414249+00	\N	1220
998	1	30840	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.414648+00	\N	1221
999	1	30742	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.415056+00	\N	1222
1000	1	30628	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.415516+00	\N	1223
1001	1	30622	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.41591+00	\N	1224
1002	1	30602	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.416302+00	\N	1225
1003	1	30595	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.416694+00	\N	1226
1004	1	30582	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.417087+00	\N	1227
1005	1	33658	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.417483+00	\N	1228
1006	1	33657	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.421456+00	\N	1229
1007	1	33653	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.421849+00	\N	1230
1008	1	33651	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.422241+00	\N	1231
1009	1	33648	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.422636+00	\N	1232
1010	1	30946	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.423028+00	\N	1233
1011	1	30919	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.423421+00	\N	1234
1012	1	33985	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:21.423814+00	\N	1235
1013	1	33983	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:21.424208+00	\N	1236
1014	1	33982	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:21.424603+00	\N	1237
1015	1	31524	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:21.425007+00	\N	1238
1016	1	31520	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:21.425412+00	\N	1239
1017	1	31518	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:21.429772+00	\N	1240
1018	1	31431	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:21.430182+00	\N	1241
1019	1	31425	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:21.430574+00	\N	1242
1020	1	31353	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:21.430966+00	\N	1243
1021	1	31345	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:21.431359+00	\N	1244
1022	1	31340	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:21.431752+00	\N	1245
1023	1	31337	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:21.432144+00	\N	1246
1024	1	31332	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:21.43254+00	\N	1247
1025	1	31327	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:21.432933+00	\N	1248
1026	1	31315	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:21.433326+00	\N	1249
1027	1	31309	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:21.433718+00	\N	1250
1028	1	31304	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:21.43411+00	\N	1251
1029	1	30951	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:21.434502+00	\N	1252
1030	1	30950	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:21.438104+00	\N	1253
1031	1	30704	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:21.43851+00	\N	1254
1032	1	30676	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:21.438906+00	\N	1255
1033	1	30665	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:21.439299+00	\N	1256
1034	1	30659	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:21.439691+00	\N	1257
1035	1	30642	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:21.440111+00	\N	1258
1036	1	30580	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:21.440571+00	\N	1259
1037	1	30576	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:21.440964+00	\N	1260
1038	1	30540	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:21.441358+00	\N	1261
1039	1	30539	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:21.441749+00	\N	1262
1040	1	29681	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:21.442142+00	\N	1263
1041	1	34016	1	t	LOCALCIRCLE	\N	26-08-2010	\N	2010-12-02 17:08:21.442564+00	\N	1264
1042	1	33806	1	t	LOCALCIRCLE	\N	26-08-2010	\N	2010-12-02 17:08:21.446512+00	\N	1265
1043	1	33645	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.446908+00	\N	1266
1044	1	33639	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.447301+00	\N	1267
1045	1	33642	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.447696+00	\N	1268
1046	1	31274	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.448115+00	\N	1269
1047	1	31220	1	t	LOCALCIRCLE	\N	26-08-2010	\N	2010-12-02 17:08:21.448508+00	\N	1270
1048	1	31224	1	t	LOCALCIRCLE	\N	26-08-2010	\N	2010-12-02 17:08:21.448902+00	\N	1271
1049	1	30863	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.449294+00	\N	1272
1050	1	30862	1	t	LOCALCIRCLE	\N	26-08-2010	\N	2010-12-02 17:08:21.449689+00	\N	1273
1051	1	30856	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.450082+00	\N	1274
1052	1	30854	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.450475+00	\N	1275
1053	1	30844	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.454829+00	\N	1276
1054	1	30850	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.455236+00	\N	1277
1055	1	30841	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.455634+00	\N	1278
1056	1	30834	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.456055+00	\N	1279
1057	1	34026	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.456447+00	\N	1280
1058	1	33811	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.45684+00	\N	1281
1059	1	30452	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.457232+00	\N	1282
1060	1	30238	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.457627+00	\N	1283
1061	1	30235	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.45802+00	\N	1284
1062	1	30228	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.458412+00	\N	1285
1063	1	30227	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.458804+00	\N	1286
1064	1	29558	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.459198+00	\N	1287
1065	1	29549	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.4596+00	\N	1288
1066	1	29548	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.463161+00	\N	1289
1067	1	29546	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.46357+00	\N	1290
1068	1	29543	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.463976+00	\N	1291
1069	1	29542	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.464369+00	\N	1292
1070	1	29540	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.464762+00	\N	1293
1071	1	29538	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.465174+00	\N	1294
1072	1	29539	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.465568+00	\N	1295
1073	1	29537	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.466023+00	\N	1296
1074	1	29535	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.466415+00	\N	1297
1075	1	33890	1	t	LOCALCIRCLE	\N	15-07-2010	\N	2010-12-02 17:08:21.466807+00	\N	1298
1076	1	33889	1	t	LOCALCIRCLE	\N	15-07-2010	\N	2010-12-02 17:08:21.467255+00	\N	1299
1077	1	33871	1	t	LOCALCIRCLE	\N	15-07-2010	\N	2010-12-02 17:08:21.46768+00	\N	1300
1078	1	33870	1	t	LOCALCIRCLE	\N	15-07-2010	\N	2010-12-02 17:08:21.471558+00	\N	1301
1079	1	31503	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.472186+00	\N	1302
1080	1	31504	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.472567+00	\N	1303
1081	1	31532	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.473019+00	\N	1304
1082	1	31538	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.473408+00	\N	1305
1083	1	31493	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.473798+00	\N	1306
1084	1	31495	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.474174+00	\N	1307
1085	1	31498	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.474564+00	\N	1308
1086	1	31496	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.474951+00	\N	1309
1087	1	30825	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.47534+00	\N	1310
1088	1	31492	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.475837+00	\N	1311
1089	1	31275	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.476218+00	\N	1312
1090	1	31283	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.476607+00	\N	1313
1091	1	31281	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.476983+00	\N	1314
1092	1	31276	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.477363+00	\N	1315
1093	1	31271	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.477753+00	\N	1316
1094	1	31251	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.478129+00	\N	1317
1095	1	30886	1	t	LOCALCIRCLE	\N	15-07-2010	\N	2010-12-02 17:08:21.478511+00	\N	1318
1096	1	30881	1	t	LOCALCIRCLE	\N	15-07-2010	\N	2010-12-02 17:08:21.478886+00	\N	1319
1097	1	30870	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.479265+00	\N	1320
1098	1	29712	1	t	LOCALCIRCLE	\N	15-07-2010	\N	2010-12-02 17:08:21.479659+00	\N	1321
1099	1	30855	1	t	LOCALCIRCLE	\N	15-07-2010	\N	2010-12-02 17:08:21.480049+00	\N	1322
1100	1	30866	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.480426+00	\N	1323
1101	1	30858	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.480891+00	\N	1324
1102	1	29710	1	t	LOCALCIRCLE	\N	15-07-2010	\N	2010-12-02 17:08:21.481265+00	\N	1325
1103	1	33955	1	t	LOCALCIRCLE	\N	19-08-2010	\N	2010-12-02 17:08:21.481651+00	\N	1326
1104	1	33956	1	t	LOCALCIRCLE	\N	19-08-2010	\N	2010-12-02 17:08:21.482038+00	\N	1327
1105	1	33957	1	t	LOCALCIRCLE	\N	19-08-2010	\N	2010-12-02 17:08:21.482412+00	\N	1328
1106	1	30392	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:21.483017+00	\N	1329
1107	1	30398	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:21.483404+00	\N	1330
1108	1	33954	1	t	LOCALCIRCLE	\N	19-08-2010	\N	2010-12-02 17:08:21.483796+00	\N	1331
1109	1	33953	1	t	LOCALCIRCLE	\N	23-08-2010	\N	2010-12-02 17:08:21.484187+00	\N	1332
1110	1	33952	1	t	LOCALCIRCLE	\N	19-08-2010	\N	2010-12-02 17:08:21.484578+00	\N	1333
1111	1	33951	1	t	LOCALCIRCLE	\N	19-08-2010	\N	2010-12-02 17:08:21.484954+00	\N	1334
1112	1	33661	1	t	LOCALCIRCLE	\N	23-08-2010	\N	2010-12-02 17:08:21.485334+00	\N	1335
1113	1	33950	1	t	LOCALCIRCLE	\N	23-08-2010	\N	2010-12-02 17:08:21.485848+00	\N	1336
1114	1	33614	1	t	LOCALCIRCLE	\N	23-08-2010	\N	2010-12-02 17:08:21.486237+00	\N	1337
1115	1	33612	1	t	LOCALCIRCLE	\N	23-08-2010	\N	2010-12-02 17:08:21.486612+00	\N	1338
1116	1	33607	1	t	LOCALCIRCLE	\N	23-08-2010	\N	2010-12-02 17:08:21.486994+00	\N	1339
1117	1	33601	1	t	LOCALCIRCLE	\N	19-08-2010	\N	2010-12-02 17:08:21.487384+00	\N	1340
1118	1	33597	1	t	LOCALCIRCLE	\N	19-08-2010	\N	2010-12-02 17:08:21.487763+00	\N	1341
1119	1	33589	1	t	LOCALCIRCLE	\N	19-08-2010	\N	2010-12-02 17:08:21.488144+00	\N	1342
1120	1	33585	1	t	LOCALCIRCLE	\N	19-08-2010	\N	2010-12-02 17:08:21.488536+00	\N	1343
1121	1	33583	1	t	LOCALCIRCLE	\N	19-08-2010	\N	2010-12-02 17:08:21.488925+00	\N	1344
1122	1	33577	1	t	LOCALCIRCLE	\N	19-08-2010	\N	2010-12-02 17:08:21.489302+00	\N	1345
1123	1	33576	1	t	LOCALCIRCLE	\N	19-08-2010	\N	2010-12-02 17:08:21.489683+00	\N	1346
1124	1	33573	1	t	LOCALCIRCLE	\N	19-08-2010	\N	2010-12-02 17:08:21.490072+00	\N	1347
1125	1	31490	1	t	LOCALCIRCLE	\N	23-08-2010	\N	2010-12-02 17:08:21.490448+00	\N	1348
1126	1	31475	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.496616+00	\N	1349
1127	1	30819	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.496993+00	\N	1350
1128	1	31360	1	t	LOCALCIRCLE	\N	23-08-2010	\N	2010-12-02 17:08:21.497379+00	\N	1351
1129	1	30935	1	t	LOCALCIRCLE	\N	23-08-2010	\N	2010-12-02 17:08:21.497769+00	\N	1352
1130	1	30932	1	t	LOCALCIRCLE	\N	23-08-2010	\N	2010-12-02 17:08:21.498146+00	\N	1353
1131	1	33892	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.498527+00	\N	1354
1132	1	31510	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.498916+00	\N	1355
1133	1	33855	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.499292+00	\N	1356
1134	1	33859	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.499679+00	\N	1357
1135	1	31280	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.50007+00	\N	1358
1136	1	31285	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.500461+00	\N	1359
1137	1	31266	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.504943+00	\N	1360
1138	1	31270	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.50532+00	\N	1361
1139	1	31272	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.505712+00	\N	1362
1140	1	31248	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.506088+00	\N	1363
1141	1	30894	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.506467+00	\N	1364
1142	1	30897	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.507075+00	\N	1365
1143	1	30900	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.507463+00	\N	1366
1144	1	31226	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.507869+00	\N	1367
1145	1	30891	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.508251+00	\N	1368
1146	1	30890	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.50864+00	\N	1369
1147	1	30880	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.509016+00	\N	1370
1148	1	30883	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.509396+00	\N	1371
1149	1	30884	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.509879+00	\N	1372
1150	1	30831	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.510268+00	\N	1373
1151	1	30754	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.510645+00	\N	1374
1152	1	30818	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.511026+00	\N	1375
1153	1	32076	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.511401+00	\N	1376
1154	1	32077	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.511783+00	\N	1377
1155	1	32078	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.512173+00	\N	1378
1156	1	32079	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.512563+00	\N	1379
1157	1	32080	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.512939+00	\N	1380
1158	1	32081	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.51332+00	\N	1381
1159	1	32082	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.513712+00	\N	1382
1160	1	32083	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.514088+00	\N	1383
1161	1	32084	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.514468+00	\N	1384
1162	1	32085	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.521687+00	\N	1385
1163	1	32086	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.522076+00	\N	1386
1164	1	32087	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.522465+00	\N	1387
1165	1	32088	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.522842+00	\N	1388
1166	1	32089	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.523225+00	\N	1389
1167	1	32090	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.523619+00	\N	1390
1168	1	32091	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.524013+00	\N	1391
1169	1	32092	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.524403+00	\N	1392
1170	1	33384	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.524791+00	\N	1393
1171	1	33385	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.525167+00	\N	1394
1172	1	33386	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.525547+00	\N	1395
1173	1	33389	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.53+00	\N	1396
1174	1	33390	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:21.530378+00	\N	1397
1175	1	33391	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:21.530755+00	\N	1398
1176	1	33392	1	t	LOCALCIRCLE	\N	19-08-2010	\N	2010-12-02 17:08:21.531133+00	\N	1399
1177	1	32216	1	t	LOCALCIRCLE	\N	19-08-2010	\N	2010-12-02 17:08:21.531509+00	\N	1400
1178	1	32217	1	t	LOCALCIRCLE	\N	23-08-2010	\N	2010-12-02 17:08:21.531891+00	\N	1401
1179	1	32218	1	t	LOCALCIRCLE	\N	23-08-2010	\N	2010-12-02 17:08:21.532501+00	\N	1402
1180	1	32219	1	t	LOCALCIRCLE	\N	23-08-2010	\N	2010-12-02 17:08:21.532892+00	\N	1403
1181	1	32220	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.533277+00	\N	1404
1182	1	32221	1	t	LOCALCIRCLE	\N	23-08-2010	\N	2010-12-02 17:08:21.533652+00	\N	1405
1183	1	32222	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.534031+00	\N	1406
1184	1	32223	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.53442+00	\N	1407
1185	1	32224	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.53489+00	\N	1408
1186	1	32225	1	t	LOCALCIRCLE	\N	23-08-2010	\N	2010-12-02 17:08:21.53527+00	\N	1409
1187	1	32226	1	t	LOCALCIRCLE	\N	23-08-2010	\N	2010-12-02 17:08:21.535661+00	\N	1410
1188	1	32227	1	t	LOCALCIRCLE	\N	23-08-2010	\N	2010-12-02 17:08:21.536054+00	\N	1411
1189	1	32228	1	t	LOCALCIRCLE	\N	23-08-2010	\N	2010-12-02 17:08:21.536446+00	\N	1412
1190	1	32229	1	t	LOCALCIRCLE	\N	19-08-2010	\N	2010-12-02 17:08:21.536822+00	\N	1413
1191	1	32317	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.537201+00	\N	1414
1192	1	32318	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.53759+00	\N	1415
1193	1	32319	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.537966+00	\N	1416
1194	1	32320	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.538348+00	\N	1417
1195	1	32324	1	t	LOCALCIRCLE	\N	31-08-2010	\N	2010-12-02 17:08:21.538739+00	\N	1418
1196	1	32327	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.539166+00	\N	1419
1197	1	32399	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.539556+00	\N	1420
1198	1	32400	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.546744+00	\N	1421
1199	1	32401	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.547134+00	\N	1422
1200	1	32402	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.54751+00	\N	1423
1201	1	32403	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.547907+00	\N	1424
1202	1	32404	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.548286+00	\N	1425
1203	1	32405	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.548674+00	\N	1426
1204	1	32406	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.549064+00	\N	1427
1205	1	32407	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.54946+00	\N	1428
1206	1	32408	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.549852+00	\N	1429
1207	1	32409	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.550241+00	\N	1430
1208	1	32410	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.550624+00	\N	1431
1209	1	32411	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.555059+00	\N	1432
1210	1	32413	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.555444+00	\N	1433
1211	1	32414	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.555832+00	\N	1434
1212	1	32415	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.556224+00	\N	1435
1213	1	32416	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.556613+00	\N	1436
1214	1	32510	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.556989+00	\N	1437
1215	1	32511	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.55759+00	\N	1438
1216	1	32513	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.557973+00	\N	1439
1217	1	32514	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.558362+00	\N	1440
1218	1	32515	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.558741+00	\N	1441
1219	1	32516	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.55912+00	\N	1442
1220	1	32517	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.559509+00	\N	1443
1221	1	32518	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.563468+00	\N	1444
1222	1	32519	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.563861+00	\N	1445
1223	1	32520	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.564253+00	\N	1446
1224	1	32521	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.564644+00	\N	1447
1225	1	32701	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:21.565035+00	\N	1448
1226	1	32522	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.565412+00	\N	1449
1227	1	32523	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.565792+00	\N	1450
1228	1	32524	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.566194+00	\N	1451
1229	1	32525	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.566578+00	\N	1452
1230	1	32526	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.566968+00	\N	1453
1231	1	32527	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.567344+00	\N	1454
1232	1	32528	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.567758+00	\N	1455
1233	1	32529	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.571787+00	\N	1456
1234	1	32530	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.572166+00	\N	1457
1235	1	32531	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.572555+00	\N	1458
1236	1	32532	1	t	LOCALCIRCLE	\N	28-07-2010	\N	2010-12-02 17:08:21.572944+00	\N	1459
1237	1	32913	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.573321+00	\N	1460
1238	1	32914	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.573702+00	\N	1461
1239	1	32915	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.574092+00	\N	1462
1240	1	32916	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.574493+00	\N	1463
1241	1	32917	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.574879+00	\N	1464
1242	1	32918	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.575269+00	\N	1465
1243	1	32919	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.575647+00	\N	1466
1244	1	32920	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.57604+00	\N	1467
1245	1	32921	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.576421+00	\N	1468
1246	1	32862	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.576936+00	\N	1469
1247	1	32922	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.577325+00	\N	1470
1248	1	32923	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.577717+00	\N	1471
1249	1	32801	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.578111+00	\N	1472
1250	1	32802	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.5785+00	\N	1473
1251	1	32803	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.578876+00	\N	1474
1252	1	32805	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.579479+00	\N	1475
1253	1	32806	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.579864+00	\N	1476
1254	1	32807	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.580256+00	\N	1477
1255	1	32808	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.580646+00	\N	1478
1256	1	32811	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.581035+00	\N	1479
1257	1	32812	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.581412+00	\N	1480
1258	1	32813	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:21.581944+00	\N	1481
1259	1	32614	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.582337+00	\N	1482
1260	1	32615	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.582728+00	\N	1483
1261	1	32617	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.583105+00	\N	1484
1262	1	32618	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.583484+00	\N	1485
1263	1	32622	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.583876+00	\N	1486
1264	1	32624	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.584254+00	\N	1487
1265	1	32626	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.584631+00	\N	1488
1266	1	32627	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.585022+00	\N	1489
1267	1	32628	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.585399+00	\N	1490
1268	1	32629	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.585781+00	\N	1491
1269	1	32632	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.58617+00	\N	1492
1270	1	32633	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.586546+00	\N	1493
1271	1	32702	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.588526+00	\N	1494
1272	1	32704	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:21.588916+00	\N	1495
1273	1	32711	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:21.589292+00	\N	1496
1274	1	32712	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:21.589675+00	\N	1497
1275	1	32713	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:21.590063+00	\N	1498
1276	1	33437	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.59044+00	\N	1499
1277	1	33438	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.59101+00	\N	1500
1278	1	33440	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.591394+00	\N	1501
1279	1	33441	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.591788+00	\N	1502
1280	1	33442	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.592179+00	\N	1503
1281	1	33444	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.592568+00	\N	1504
1282	1	33445	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:21.596845+00	\N	1505
1283	1	32851	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.597222+00	\N	1506
1284	1	32853	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.597615+00	\N	1507
1285	1	32854	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.598004+00	\N	1508
1286	1	32855	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.598383+00	\N	1509
1287	1	32856	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.598763+00	\N	1510
1288	1	32857	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.599374+00	\N	1511
1289	1	32858	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.599763+00	\N	1512
1290	1	32858	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.600151+00	\N	1513
1291	1	32859	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.60054+00	\N	1514
1292	1	32860	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.600917+00	\N	1515
1293	1	32861	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.601297+00	\N	1516
1294	1	32863	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.601716+00	\N	1517
1295	1	33361	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.605251+00	\N	1518
1296	1	33362	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:21.605641+00	\N	1519
1297	1	33363	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.606017+00	\N	1520
1298	1	33364	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.606398+00	\N	1521
1299	1	33365	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.60679+00	\N	1522
1300	1	33366	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:21.607166+00	\N	1523
1301	1	33367	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.607546+00	\N	1524
1302	1	33368	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:21.607939+00	\N	1525
1303	1	33369	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.608316+00	\N	1526
1304	1	33370	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:21.608695+00	\N	1527
1305	1	33371	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.609083+00	\N	1528
1306	1	33372	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.609461+00	\N	1529
1307	1	33373	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.609963+00	\N	1530
1308	1	33374	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.610352+00	\N	1531
1309	1	33375	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.610729+00	\N	1532
1310	1	33376	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.611109+00	\N	1533
1311	1	33377	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.611498+00	\N	1534
1312	1	33378	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:21.611878+00	\N	1535
1313	1	33379	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:21.612258+00	\N	1536
1314	1	33380	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.612647+00	\N	1537
1315	1	33381	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:21.613023+00	\N	1538
1316	1	33382	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:21.613435+00	\N	1539
1317	1	33383	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:21.613827+00	\N	1540
1318	1	33393	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.614216+00	\N	1541
1319	1	33394	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.614592+00	\N	1542
1320	1	33395	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.621903+00	\N	1543
1321	1	33396	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.62228+00	\N	1544
1322	1	33397	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.622669+00	\N	1545
1323	1	33398	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.623046+00	\N	1546
1324	1	33399	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.623426+00	\N	1547
1325	1	33400	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.62404+00	\N	1548
1326	1	33401	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.624437+00	\N	1549
1327	1	33403	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.624825+00	\N	1550
1328	1	33407	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.625208+00	\N	1551
1329	1	33411	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.625597+00	\N	1552
1330	1	33412	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.625973+00	\N	1553
1331	1	33413	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.626355+00	\N	1554
1332	1	33414	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.626758+00	\N	1555
1333	1	33415	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.63031+00	\N	1556
1334	1	33416	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.6307+00	\N	1557
1335	1	33417	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.631077+00	\N	1558
1336	1	33223	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.631457+00	\N	1559
1337	1	33418	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.63185+00	\N	1560
1338	1	33419	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.632242+00	\N	1561
1339	1	33420	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.632635+00	\N	1562
1340	1	33421	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.633024+00	\N	1563
1341	1	33422	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.6334+00	\N	1564
1342	1	33423	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.633784+00	\N	1565
1343	1	33424	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.634173+00	\N	1566
1344	1	33425	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.634549+00	\N	1567
1345	1	33426	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.635026+00	\N	1568
1346	1	33427	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.635413+00	\N	1569
1347	1	33428	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.635806+00	\N	1570
1348	1	32944	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:21.636198+00	\N	1571
1349	1	32945	1	t	LOCALCIRCLE	\N	19-08-2010	\N	2010-12-02 17:08:21.636591+00	\N	1572
1350	1	32946	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:21.63698+00	\N	1573
1351	1	32947	1	t	LOCALCIRCLE	\N	19-08-2010	\N	2010-12-02 17:08:21.637356+00	\N	1574
1352	1	32950	1	t	LOCALCIRCLE	\N	19-08-2010	\N	2010-12-02 17:08:21.637738+00	\N	1575
1353	1	32951	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:21.638127+00	\N	1576
1354	1	32952	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:21.638503+00	\N	1577
1355	1	32953	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:21.638893+00	\N	1578
1356	1	32954	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:21.639278+00	\N	1579
1357	1	32955	1	t	LOCALCIRCLE	\N	19-08-2010	\N	2010-12-02 17:08:21.639669+00	\N	1580
1358	1	32956	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:21.646961+00	\N	1581
1359	1	32957	1	t	LOCALCIRCLE	\N	19-08-2010	\N	2010-12-02 17:08:21.647338+00	\N	1582
1360	1	32958	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:21.647733+00	\N	1583
1361	1	32959	1	t	LOCALCIRCLE	\N	19-08-2010	\N	2010-12-02 17:08:21.648343+00	\N	1584
1362	1	32960	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:21.648728+00	\N	1585
1363	1	32961	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:21.649118+00	\N	1586
1364	1	32962	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:21.64952+00	\N	1587
1365	1	32963	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:21.649904+00	\N	1588
1366	1	32018	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.650293+00	\N	1589
1367	1	32020	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.650674+00	\N	1590
1368	1	32022	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.651051+00	\N	1591
1369	1	32150	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.651426+00	\N	1592
1370	1	32153	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.65184+00	\N	1593
1371	1	32154	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.655367+00	\N	1594
1372	1	32156	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.65576+00	\N	1595
1373	1	32157	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:21.656152+00	\N	1596
1374	1	32158	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:21.656528+00	\N	1597
1375	1	32159	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:21.656908+00	\N	1598
1376	1	32271	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:21.657283+00	\N	1599
1377	1	32272	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.657663+00	\N	1600
1378	1	32273	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:21.658052+00	\N	1601
1379	1	32274	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:21.658427+00	\N	1602
1380	1	33891	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:21.658812+00	\N	1603
1381	1	32360	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.6592+00	\N	1604
1382	1	32652	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.659577+00	\N	1605
1383	1	32653	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:21.660052+00	\N	1606
1384	1	32654	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.660442+00	\N	1607
1385	1	32655	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.660833+00	\N	1608
1386	1	32656	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.661222+00	\N	1609
1387	1	32657	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.661609+00	\N	1610
1388	1	32658	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.661985+00	\N	1611
1389	1	32660	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.662372+00	\N	1612
1390	1	32747	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:21.662762+00	\N	1613
1391	1	32748	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:21.663139+00	\N	1614
1392	1	32749	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.66352+00	\N	1615
1393	1	32750	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:21.663913+00	\N	1616
1394	1	32751	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.664303+00	\N	1617
1395	1	32752	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:21.664679+00	\N	1618
1396	1	32753	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.672019+00	\N	1619
1397	1	32754	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.672399+00	\N	1620
1398	1	32755	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.673009+00	\N	1621
1399	1	32756	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.673392+00	\N	1622
1400	1	32757	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.673782+00	\N	1623
1401	1	32758	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:21.674158+00	\N	1624
1402	1	32759	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.674546+00	\N	1625
1403	1	32760	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:21.674932+00	\N	1626
1404	1	32761	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:21.675321+00	\N	1627
1405	1	32762	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.6757+00	\N	1628
1406	1	32763	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.67609+00	\N	1629
1407	1	32764	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.676477+00	\N	1630
1408	1	32765	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:21.676894+00	\N	1631
1409	1	32766	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.680426+00	\N	1632
1410	1	32767	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:21.680816+00	\N	1633
1411	1	33289	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.68119+00	\N	1634
1412	1	33290	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:21.681573+00	\N	1635
1413	1	33291	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:21.681947+00	\N	1636
1414	1	33293	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:21.682327+00	\N	1637
1415	1	33294	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:21.682702+00	\N	1638
1416	1	33295	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:21.683082+00	\N	1639
1417	1	33296	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.683459+00	\N	1640
1418	1	33297	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.683844+00	\N	1641
1419	1	33298	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.684233+00	\N	1642
1420	1	33281	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.684622+00	\N	1643
1421	1	33282	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.688744+00	\N	1644
1422	1	33283	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.689157+00	\N	1645
1423	1	33284	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.689544+00	\N	1646
1424	1	33286	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.689933+00	\N	1647
1425	1	33287	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:21.690309+00	\N	1648
1426	1	33288	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.690692+00	\N	1649
1427	1	33299	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.691111+00	\N	1650
1428	1	33300	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.691487+00	\N	1651
1429	1	33302	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.691874+00	\N	1652
1430	1	33303	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.692263+00	\N	1653
1431	1	33304	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.692652+00	\N	1654
1432	1	33305	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.697076+00	\N	1655
1433	1	33306	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.697454+00	\N	1656
1434	1	33307	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.698068+00	\N	1657
1435	1	33308	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.698451+00	\N	1658
1436	1	33309	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.698881+00	\N	1659
1437	1	33271	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.699266+00	\N	1660
1438	1	33272	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:21.699658+00	\N	1661
1439	1	33273	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.700051+00	\N	1662
1440	1	33274	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:21.700443+00	\N	1663
1441	1	33275	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.700834+00	\N	1664
1442	1	33276	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.70121+00	\N	1665
1443	1	33277	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:21.70159+00	\N	1666
1444	1	33278	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.702074+00	\N	1667
1445	1	33279	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:21.702463+00	\N	1668
1446	1	33280	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:21.702841+00	\N	1669
1447	1	32024	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.703285+00	\N	1670
1448	1	32028	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.703676+00	\N	1671
1449	1	32029	1	t	LOCALCIRCLE	\N	26-08-2010	\N	2010-12-02 17:08:21.704068+00	\N	1672
1450	1	32031	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.704459+00	\N	1673
1451	1	32032	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.70485+00	\N	1674
1452	1	32162	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.705226+00	\N	1675
1453	1	32163	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.705606+00	\N	1676
1454	1	32503	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.705981+00	\N	1677
1455	1	32508	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.706361+00	\N	1678
1456	1	32509	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.706736+00	\N	1679
1457	1	32206	1	t	LOCALCIRCLE	\N	30-08-2010	\N	2010-12-02 17:08:21.71382+00	\N	1680
1458	1	32208	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:21.714209+00	\N	1681
1459	1	32210	1	t	LOCALCIRCLE	\N	16-08-2010	\N	2010-12-02 17:08:21.714585+00	\N	1682
1460	1	33147	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.714965+00	\N	1683
1461	1	33149	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.715341+00	\N	1684
1462	1	33150	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.715722+00	\N	1685
1463	1	33151	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.716115+00	\N	1686
1464	1	33153	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.716507+00	\N	1687
1465	1	33154	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.716898+00	\N	1688
1466	1	33160	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.717287+00	\N	1689
1467	1	33224	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.717663+00	\N	1690
1468	1	33225	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.718749+00	\N	1691
1469	1	33226	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:21.719134+00	\N	1692
1470	1	33227	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.719525+00	\N	1693
1471	1	33228	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.719922+00	\N	1694
1472	1	33229	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.720313+00	\N	1695
1473	1	33230	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:21.720704+00	\N	1696
1474	1	33231	1	t	LOCALCIRCLE	\N	13-07-2010	\N	2010-12-02 17:08:21.721098+00	\N	1697
1475	1	33232	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.721489+00	\N	1698
1476	1	33233	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.721884+00	\N	1699
1477	1	33211	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.722275+00	\N	1700
1478	1	33212	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.722663+00	\N	1701
1479	1	33213	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.723053+00	\N	1702
1480	1	33214	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.723428+00	\N	1703
1481	1	33216	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.723814+00	\N	1704
1482	1	33217	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.724204+00	\N	1705
1483	1	33218	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.724592+00	\N	1706
1484	1	33220	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.724969+00	\N	1707
1485	1	33221	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.72535+00	\N	1708
1486	1	32036	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.725726+00	\N	1709
1487	1	32037	1	t	LOCALCIRCLE	\N	15-07-2010	\N	2010-12-02 17:08:21.72611+00	\N	1710
1488	1	32038	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.726497+00	\N	1711
1489	1	32039	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.726903+00	\N	1712
1490	1	32040	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.730529+00	\N	1713
1491	1	32041	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.730908+00	\N	1714
1492	1	32042	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.731297+00	\N	1715
1493	1	32043	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.731676+00	\N	1716
1494	1	32044	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.732066+00	\N	1717
1495	1	32045	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.732447+00	\N	1718
1496	1	32046	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.732847+00	\N	1719
1497	1	32047	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.733231+00	\N	1720
1498	1	32048	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.733619+00	\N	1721
1499	1	32049	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.733996+00	\N	1722
1500	1	32050	1	t	LOCALCIRCLE	\N	15-07-2010	\N	2010-12-02 17:08:21.734378+00	\N	1723
1501	1	32051	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.734755+00	\N	1724
1502	1	32052	1	t	LOCALCIRCLE	\N	15-07-2010	\N	2010-12-02 17:08:21.73886+00	\N	1725
1503	1	32169	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.739238+00	\N	1726
1504	1	32170	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.739852+00	\N	1727
1505	1	32170	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:21.740237+00	\N	1728
1506	1	32171	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:21.740626+00	\N	1729
1507	1	32174	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.741002+00	\N	1730
1508	1	32177	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.741382+00	\N	1731
1509	1	32179	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.741775+00	\N	1732
1510	1	32180	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.742164+00	\N	1733
1511	1	32181	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.742541+00	\N	1734
1512	1	32184	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.742952+00	\N	1735
1513	1	33252	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.747249+00	\N	1736
1514	1	33253	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.747635+00	\N	1737
1515	1	33254	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.748025+00	\N	1738
1516	1	33255	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.748428+00	\N	1739
1517	1	33256	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.74881+00	\N	1740
1518	1	33257	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.749201+00	\N	1741
1519	1	33258	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.749593+00	\N	1742
1520	1	33259	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:21.74997+00	\N	1743
1521	1	33260	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.75035+00	\N	1744
1522	1	33261	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.750741+00	\N	1745
1523	1	33262	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.751132+00	\N	1746
1524	1	33263	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.75151+00	\N	1747
1525	1	33264	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.751924+00	\N	1748
1526	1	33265	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.755587+00	\N	1749
1527	1	33266	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.755999+00	\N	1750
1528	1	33267	1	t	LOCALCIRCLE	\N	26-08-2010	\N	2010-12-02 17:08:21.756391+00	\N	1751
1529	1	33268	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:21.75678+00	\N	1752
1530	1	32277	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:21.757171+00	\N	1753
1531	1	32278	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.757562+00	\N	1754
1532	1	32279	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.757955+00	\N	1755
1533	1	32280	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.758346+00	\N	1756
1534	1	32281	1	t	LOCALCIRCLE	\N	04-09-2010	\N	2010-12-02 17:08:21.758725+00	\N	1757
1535	1	32282	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.759105+00	\N	1758
1536	1	32283	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.759495+00	\N	1759
1537	1	32284	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:21.759922+00	\N	1760
1538	1	32285	1	t	LOCALCIRCLE	\N	04-09-2010	\N	2010-12-02 17:08:21.763936+00	\N	1761
1539	1	32285	1	t	LOCALCIRCLE	\N	19-07-2010	\N	2010-12-02 17:08:21.76433+00	\N	1762
1540	1	32286	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.764942+00	\N	1763
1541	1	32287	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.765325+00	\N	1764
1542	1	32288	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.765716+00	\N	1765
1543	1	32289	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.766111+00	\N	1766
1544	1	32290	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.766501+00	\N	1767
1545	1	32291	1	t	LOCALCIRCLE	\N	04-09-2010	\N	2010-12-02 17:08:21.766893+00	\N	1768
1546	1	32292	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:21.767283+00	\N	1769
1547	1	32368	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.767663+00	\N	1770
1548	1	32369	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.76814+00	\N	1771
1549	1	32370	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.768525+00	\N	1772
1550	1	32371	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:21.768922+00	\N	1773
1551	1	32373	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:21.76931+00	\N	1774
1552	1	32376	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.7697+00	\N	1775
1553	1	32377	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.770077+00	\N	1776
1554	1	32378	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.770457+00	\N	1777
1555	1	32379	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.770852+00	\N	1778
1556	1	32380	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.771273+00	\N	1779
1557	1	32381	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.771667+00	\N	1780
1558	1	32382	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.772059+00	\N	1781
1559	1	32383	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.772452+00	\N	1782
1560	1	32475	1	t	LOCALCIRCLE	\N	26-08-2010	\N	2010-12-02 17:08:21.772882+00	\N	1783
1561	1	32476	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.780668+00	\N	1784
1562	1	32478	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.781054+00	\N	1785
1563	1	32479	1	t	LOCALCIRCLE	\N	26-08-2010	\N	2010-12-02 17:08:21.781446+00	\N	1786
1564	1	32480	1	t	LOCALCIRCLE	\N	26-08-2010	\N	2010-12-02 17:08:21.781836+00	\N	1787
1565	1	32482	1	t	LOCALCIRCLE	\N	26-08-2010	\N	2010-12-02 17:08:21.782213+00	\N	1788
1566	1	32483	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.782594+00	\N	1789
1567	1	32485	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.782989+00	\N	1790
1568	1	32569	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.783379+00	\N	1791
1569	1	32570	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.783773+00	\N	1792
1570	1	32571	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.784165+00	\N	1793
1571	1	32572	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.78456+00	\N	1794
1572	1	32573	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.78498+00	\N	1795
1573	1	32575	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.788995+00	\N	1796
1574	1	32576	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.789386+00	\N	1797
1575	1	32577	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.789777+00	\N	1798
1576	1	32578	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.790168+00	\N	1799
1577	1	32579	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.790785+00	\N	1800
1578	1	32580	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.79118+00	\N	1801
1579	1	32581	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.791561+00	\N	1802
1580	1	32582	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.792147+00	\N	1803
1581	1	32583	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.792527+00	\N	1804
1582	1	32584	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.792948+00	\N	1805
1583	1	32585	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.797389+00	\N	1806
1584	1	32586	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.797779+00	\N	1807
1585	1	32587	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.79817+00	\N	1808
1586	1	32588	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.798561+00	\N	1809
1587	1	32590	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.798954+00	\N	1810
1588	1	32661	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.799331+00	\N	1811
1589	1	32663	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.799716+00	\N	1812
1590	1	32666	1	t	LOCALCIRCLE	\N	26-08-2010	\N	2010-12-02 17:08:21.800106+00	\N	1813
1591	1	32667	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.800499+00	\N	1814
1592	1	32668	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.800892+00	\N	1815
1593	1	32671	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.801282+00	\N	1816
1594	1	32672	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.801673+00	\N	1817
1595	1	33199	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.802158+00	\N	1818
1596	1	33201	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.802549+00	\N	1819
1597	1	33202	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.802942+00	\N	1820
1598	1	33203	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.803332+00	\N	1821
1599	1	33205	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.803713+00	\N	1822
1600	1	33206	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.804094+00	\N	1823
1601	1	33207	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.804484+00	\N	1824
1602	1	33208	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.804877+00	\N	1825
1603	1	33209	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.805267+00	\N	1826
1604	1	33210	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.805656+00	\N	1827
1605	1	33191	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.806034+00	\N	1828
1606	1	33192	1	t	LOCALCIRCLE	\N	15-07-2010	\N	2010-12-02 17:08:21.806414+00	\N	1829
1607	1	33193	1	t	LOCALCIRCLE	\N	15-07-2010	\N	2010-12-02 17:08:21.806805+00	\N	1830
1608	1	33194	1	t	LOCALCIRCLE	\N	15-07-2010	\N	2010-12-02 17:08:21.814056+00	\N	1831
1609	1	33195	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.814445+00	\N	1832
1610	1	33196	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.814838+00	\N	1833
1611	1	33197	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.815228+00	\N	1834
1612	1	33198	1	t	LOCALCIRCLE	\N	15-07-2010	\N	2010-12-02 17:08:21.81562+00	\N	1835
1613	1	33234	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:21.816238+00	\N	1836
1614	1	33235	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:21.81662+00	\N	1837
1615	1	33236	1	t	LOCALCIRCLE	\N	04-09-2010	\N	2010-12-02 17:08:21.817011+00	\N	1838
1616	1	32930	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.817401+00	\N	1839
1617	1	33237	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:21.817778+00	\N	1840
1618	1	33238	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:21.818158+00	\N	1841
1619	1	33239	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:21.818549+00	\N	1842
1620	1	33240	1	t	LOCALCIRCLE	\N	04-09-2010	\N	2010-12-02 17:08:21.818943+00	\N	1843
1621	1	33242	1	t	LOCALCIRCLE	\N	04-09-2010	\N	2010-12-02 17:08:21.822447+00	\N	1844
1622	1	33243	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:21.822838+00	\N	1845
1623	1	33244	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:21.823229+00	\N	1846
1624	1	33245	1	t	LOCALCIRCLE	\N	04-09-2010	\N	2010-12-02 17:08:21.823606+00	\N	1847
1625	1	33246	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:21.824015+00	\N	1848
1626	1	33247	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:21.824419+00	\N	1849
1627	1	33248	1	t	LOCALCIRCLE	\N	04-09-2010	\N	2010-12-02 17:08:21.8248+00	\N	1850
1628	1	33249	1	t	LOCALCIRCLE	\N	19-07-2010	\N	2010-12-02 17:08:21.825191+00	\N	1851
1629	1	33250	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:21.825568+00	\N	1852
1630	1	33251	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:21.82595+00	\N	1853
1631	1	32769	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.82634+00	\N	1854
1632	1	32770	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.82673+00	\N	1855
1633	1	32775	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.827194+00	\N	1856
1634	1	32777	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.827579+00	\N	1857
1635	1	32778	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.827975+00	\N	1858
1636	1	32780	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.828366+00	\N	1859
1637	1	32781	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:21.828755+00	\N	1860
1638	1	32783	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.829145+00	\N	1861
1639	1	32784	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.829523+00	\N	1862
1640	1	32785	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.829906+00	\N	1863
1641	1	32831	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.830296+00	\N	1864
1642	1	32833	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.830686+00	\N	1865
1643	1	32834	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.831063+00	\N	1866
1644	1	32835	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:21.831443+00	\N	1867
1645	1	32836	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.831836+00	\N	1868
1646	1	32837	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.839115+00	\N	1869
1647	1	32838	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.839504+00	\N	1870
1648	1	32878	1	t	LOCALCIRCLE	\N	31-08-2010	\N	2010-12-02 17:08:21.839901+00	\N	1871
1649	1	32879	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.840291+00	\N	1872
1650	1	32881	1	t	LOCALCIRCLE	\N	31-08-2010	\N	2010-12-02 17:08:21.840917+00	\N	1873
1651	1	32883	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.841297+00	\N	1874
1652	1	32884	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.841678+00	\N	1875
1653	1	32885	1	t	LOCALCIRCLE	\N	31-08-2010	\N	2010-12-02 17:08:21.842069+00	\N	1876
1654	1	32886	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.842459+00	\N	1877
1655	1	32887	1	t	LOCALCIRCLE	\N	31-08-2010	\N	2010-12-02 17:08:21.842836+00	\N	1878
1656	1	32888	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.843217+00	\N	1879
1657	1	32890	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.843607+00	\N	1880
1658	1	32891	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.844035+00	\N	1881
1659	1	32892	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.847504+00	\N	1882
1660	1	32893	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:21.847898+00	\N	1883
1661	1	32931	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:21.84829+00	\N	1884
1662	1	32932	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.84868+00	\N	1885
1663	1	32933	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.849071+00	\N	1886
1664	1	32934	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.849474+00	\N	1887
1665	1	32935	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:21.849859+00	\N	1888
1666	1	32937	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.85025+00	\N	1889
1667	1	32938	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.85064+00	\N	1890
1668	1	32939	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.851019+00	\N	1891
1669	1	32940	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.851398+00	\N	1892
1670	1	32941	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.851791+00	\N	1893
1671	1	32942	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:21.855822+00	\N	1894
1672	1	32943	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.856202+00	\N	1895
1673	1	32337	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.856592+00	\N	1896
1674	1	32339	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.856984+00	\N	1897
1675	1	32340	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:21.857375+00	\N	1898
1676	1	32343	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.857813+00	\N	1899
1677	1	33028	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.858192+00	\N	1900
1678	1	33029	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.858586+00	\N	1901
1679	1	33030	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.858976+00	\N	1902
1680	1	32120	1	t	LOCALCIRCLE	\N	17-07-2010	\N	2010-12-02 17:08:21.859368+00	\N	1903
1681	1	33031	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.859762+00	\N	1904
1682	1	33032	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.860223+00	\N	1905
1683	1	33033	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.860603+00	\N	1906
1684	1	33034	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.860978+00	\N	1907
1685	1	33035	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.861357+00	\N	1908
1686	1	33036	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.86197+00	\N	1909
1687	1	32105	1	t	LOCALCIRCLE	\N	17-07-2010	\N	2010-12-02 17:08:21.862354+00	\N	1910
1688	1	32106	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:21.862732+00	\N	1911
1689	1	32107	1	t	LOCALCIRCLE	\N	17-07-2010	\N	2010-12-02 17:08:21.863108+00	\N	1912
1690	1	32108	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.863481+00	\N	1913
1691	1	32109	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.863869+00	\N	1914
1692	1	32110	1	t	LOCALCIRCLE	\N	17-07-2010	\N	2010-12-02 17:08:21.864261+00	\N	1915
1693	1	32111	1	t	LOCALCIRCLE	\N	17-07-2010	\N	2010-12-02 17:08:21.864651+00	\N	1916
1694	1	32112	1	t	LOCALCIRCLE	\N	17-07-2010	\N	2010-12-02 17:08:21.865071+00	\N	1917
1695	1	32113	1	t	LOCALCIRCLE	\N	17-07-2010	\N	2010-12-02 17:08:21.872562+00	\N	1918
1696	1	32114	1	t	LOCALCIRCLE	\N	17-07-2010	\N	2010-12-02 17:08:21.872956+00	\N	1919
1697	1	32115	1	t	LOCALCIRCLE	\N	17-07-2010	\N	2010-12-02 17:08:21.873346+00	\N	1920
1698	1	32116	1	t	LOCALCIRCLE	\N	17-07-2010	\N	2010-12-02 17:08:21.873736+00	\N	1921
1699	1	32117	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.874112+00	\N	1922
1700	1	32118	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.874506+00	\N	1923
1701	1	32119	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:21.874887+00	\N	1924
1702	1	32121	1	t	LOCALCIRCLE	\N	17-07-2010	\N	2010-12-02 17:08:21.875276+00	\N	1925
1703	1	32740	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.875656+00	\N	1926
1704	1	33037	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.876062+00	\N	1927
1705	1	33038	1	t	LOCALCIRCLE	\N	17-07-2010	\N	2010-12-02 17:08:21.876455+00	\N	1928
1706	1	33039	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.876845+00	\N	1929
1707	1	33040	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.880878+00	\N	1930
1708	1	33042	1	t	LOCALCIRCLE	\N	17-07-2010	\N	2010-12-02 17:08:21.881255+00	\N	1931
1709	1	33043	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.881629+00	\N	1932
1710	1	33045	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.882012+00	\N	1933
1711	1	33046	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.882399+00	\N	1934
1712	1	33047	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.882799+00	\N	1935
1713	1	33048	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.883186+00	\N	1936
1714	1	33049	1	t	LOCALCIRCLE	\N	17-07-2010	\N	2010-12-02 17:08:21.883561+00	\N	1937
1715	1	33050	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.884009+00	\N	1938
1716	1	33051	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.884398+00	\N	1939
1717	1	33052	1	t	LOCALCIRCLE	\N	17-07-2010	\N	2010-12-02 17:08:21.884787+00	\N	1940
1718	1	32714	1	t	LOCALCIRCLE	\N	19-06-2010	\N	2010-12-02 17:08:21.885247+00	\N	1941
1719	1	32715	1	t	LOCALCIRCLE	\N	21-06-2010	\N	2010-12-02 17:08:21.885634+00	\N	1942
1720	1	32716	1	t	LOCALCIRCLE	\N	21-06-2010	\N	2010-12-02 17:08:21.886026+00	\N	1943
1721	1	32717	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:21.886402+00	\N	1944
1722	1	32718	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:21.886782+00	\N	1945
1723	1	32719	1	t	LOCALCIRCLE	\N	21-06-2010	\N	2010-12-02 17:08:21.887395+00	\N	1946
1724	1	32720	1	t	LOCALCIRCLE	\N	21-06-2010	\N	2010-12-02 17:08:21.887781+00	\N	1947
1725	1	32721	1	t	LOCALCIRCLE	\N	21-06-2010	\N	2010-12-02 17:08:21.888173+00	\N	1948
1726	1	32722	1	t	LOCALCIRCLE	\N	21-06-2010	\N	2010-12-02 17:08:21.888563+00	\N	1949
1727	1	32723	1	t	LOCALCIRCLE	\N	21-06-2010	\N	2010-12-02 17:08:21.888957+00	\N	1950
1728	1	32724	1	t	LOCALCIRCLE	\N	21-06-2010	\N	2010-12-02 17:08:21.889351+00	\N	1951
1729	1	32725	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:21.889745+00	\N	1952
1730	1	32726	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:21.890228+00	\N	1953
1731	1	32727	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:21.890622+00	\N	1954
1732	1	32728	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:21.891011+00	\N	1955
1733	1	32729	1	t	LOCALCIRCLE	\N	21-06-2010	\N	2010-12-02 17:08:21.891401+00	\N	1956
1734	1	32730	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:21.891795+00	\N	1957
1735	1	32732	1	t	LOCALCIRCLE	\N	19-06-2010	\N	2010-12-02 17:08:21.892189+00	\N	1958
1736	1	32733	1	t	LOCALCIRCLE	\N	19-06-2010	\N	2010-12-02 17:08:21.892579+00	\N	1959
1737	1	32734	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:21.892972+00	\N	1960
1738	1	32735	1	t	LOCALCIRCLE	\N	19-06-2010	\N	2010-12-02 17:08:21.893363+00	\N	1961
1739	1	32736	1	t	LOCALCIRCLE	\N	21-06-2010	\N	2010-12-02 17:08:21.893755+00	\N	1962
1740	1	32737	1	t	LOCALCIRCLE	\N	19-06-2010	\N	2010-12-02 17:08:21.894147+00	\N	1963
1741	1	32738	1	t	LOCALCIRCLE	\N	19-06-2010	\N	2010-12-02 17:08:21.894539+00	\N	1964
1742	1	32417	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.89493+00	\N	1965
1743	1	32418	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.897625+00	\N	1966
1744	1	32419	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.898013+00	\N	1967
1745	1	32420	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.898405+00	\N	1968
1746	1	32639	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:21.898796+00	\N	1969
1747	1	32421	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.899188+00	\N	1970
1748	1	32422	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.899579+00	\N	1971
1749	1	32423	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.89998+00	\N	1972
1750	1	32424	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.90037+00	\N	1973
1751	1	32425	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.900761+00	\N	1974
1752	1	32426	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.901152+00	\N	1975
1753	1	32427	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.901544+00	\N	1976
1754	1	32428	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.901936+00	\N	1977
1755	1	32429	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.905939+00	\N	1978
1756	1	32430	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.906318+00	\N	1979
1757	1	32432	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.906708+00	\N	1980
1758	1	32433	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.9071+00	\N	1981
1759	1	32434	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.90774+00	\N	1982
1760	1	32435	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.908138+00	\N	1983
1761	1	32436	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:21.908519+00	\N	1984
1762	1	31975	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.908908+00	\N	1985
1763	1	31976	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.909286+00	\N	1986
1764	1	31977	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.909667+00	\N	1987
1765	1	31978	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.910087+00	\N	1988
1766	1	31979	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.914346+00	\N	1989
1767	1	31980	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.937579+00	\N	1990
1768	1	31981	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.938231+00	\N	1991
1769	1	31982	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.9645+00	\N	1992
1770	1	31983	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.965138+00	\N	1993
1771	1	31984	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.988633+00	\N	1994
1772	1	31985	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.989023+00	\N	1995
1773	1	31986	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.989413+00	\N	1996
1774	1	31987	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.989789+00	\N	1997
1775	1	31988	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.990171+00	\N	1998
1776	1	31989	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.990559+00	\N	1999
1777	1	31990	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.990935+00	\N	2000
1778	1	31991	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.991315+00	\N	2001
1779	1	31992	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.991715+00	\N	2002
1780	1	31993	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.992101+00	\N	2003
1781	1	31994	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.992493+00	\N	2004
1782	1	31995	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.992882+00	\N	2005
1783	1	31996	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:21.993371+00	\N	2006
1784	1	32964	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.993759+00	\N	2007
1785	1	32965	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.994151+00	\N	2008
1786	1	32966	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:21.994527+00	\N	2009
1787	1	32968	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.994908+00	\N	2010
1788	1	32970	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:21.995297+00	\N	2011
1789	1	32533	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.995676+00	\N	2012
1790	1	32534	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.99607+00	\N	2013
1791	1	32535	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.99645+00	\N	2014
1792	1	32536	1	t	LOCALCIRCLE	\N	30-08-2010	\N	2010-12-02 17:08:21.996839+00	\N	2015
1793	1	32537	1	t	LOCALCIRCLE	\N	30-08-2010	\N	2010-12-02 17:08:21.997215+00	\N	2016
1794	1	32538	1	t	LOCALCIRCLE	\N	30-08-2010	\N	2010-12-02 17:08:21.997595+00	\N	2017
1795	1	32539	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:21.997971+00	\N	2018
1796	1	32540	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:22.014574+00	\N	2019
1797	1	32541	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:22.014957+00	\N	2020
1798	1	32542	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:22.015344+00	\N	2021
1799	1	32543	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:22.015724+00	\N	2022
1800	1	32544	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:22.016106+00	\N	2023
1801	1	32545	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:22.016497+00	\N	2024
1802	1	32546	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:22.016886+00	\N	2025
1803	1	32547	1	t	LOCALCIRCLE	\N	30-08-2010	\N	2010-12-02 17:08:22.017262+00	\N	2026
1804	1	32549	1	t	LOCALCIRCLE	\N	30-08-2010	\N	2010-12-02 17:08:22.017642+00	\N	2027
1805	1	32634	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:22.018031+00	\N	2028
1806	1	32636	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:22.018407+00	\N	2029
1807	1	32637	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:22.01879+00	\N	2030
1808	1	32638	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:22.019213+00	\N	2031
1809	1	33053	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:22.02273+00	\N	2032
1810	1	33054	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:22.023109+00	\N	2033
1811	1	33055	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:22.023498+00	\N	2034
1812	1	33056	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:22.023891+00	\N	2035
1813	1	33057	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:22.024345+00	\N	2036
1814	1	33058	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:22.024735+00	\N	2037
1815	1	33059	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:22.025127+00	\N	2038
1816	1	33060	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:22.025504+00	\N	2039
1817	1	33061	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:22.025884+00	\N	2040
1818	1	33062	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:22.02626+00	\N	2041
1819	1	33063	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:22.026645+00	\N	2042
1820	1	33064	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:22.027032+00	\N	2043
1821	1	33065	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:22.031078+00	\N	2044
1822	1	33066	1	t	LOCALCIRCLE	\N	31-07-2010	\N	2010-12-02 17:08:22.031467+00	\N	2045
1823	1	33067	1	t	LOCALCIRCLE	\N	30-07-2010	\N	2010-12-02 17:08:22.031848+00	\N	2046
1824	1	32230	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:22.032228+00	\N	2047
1825	1	32231	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:22.032616+00	\N	2048
1826	1	32232	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:22.033006+00	\N	2049
1827	1	32233	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:22.033382+00	\N	2050
1828	1	32234	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:22.033764+00	\N	2051
1829	1	32235	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:22.034377+00	\N	2052
1830	1	32236	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:22.034763+00	\N	2053
1831	1	32237	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:22.03516+00	\N	2054
1832	1	32238	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:22.039455+00	\N	2055
1833	1	32239	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:22.039836+00	\N	2056
1834	1	32240	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:22.040229+00	\N	2057
1835	1	32241	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:22.040617+00	\N	2058
1836	1	32242	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:22.041006+00	\N	2059
1837	1	32243	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:22.041381+00	\N	2060
1838	1	32244	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:22.041764+00	\N	2061
1839	1	32245	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:22.042153+00	\N	2062
1840	1	32246	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:22.042529+00	\N	2063
1841	1	32247	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:22.042911+00	\N	2064
1842	1	32248	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:22.043287+00	\N	2065
1843	1	32249	1	t	LOCALCIRCLE	\N	04-08-2010	\N	2010-12-02 17:08:22.043668+00	\N	2066
1844	1	32929	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:22.044058+00	\N	2067
1845	1	32824	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:22.047786+00	\N	2068
1846	1	32864	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:22.048166+00	\N	2069
1847	1	32865	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:22.048555+00	\N	2070
1848	1	32866	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:22.048932+00	\N	2071
1849	1	32867	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:22.049315+00	\N	2072
1850	1	32869	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:22.049704+00	\N	2073
1851	1	32870	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:22.050079+00	\N	2074
1852	1	32871	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:22.050459+00	\N	2075
1853	1	32872	1	t	LOCALCIRCLE	\N	03-08-2010	\N	2010-12-02 17:08:22.050834+00	\N	2076
1854	1	32873	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:22.051216+00	\N	2077
1855	1	32874	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:22.051605+00	\N	2078
1856	1	32875	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:22.052002+00	\N	2079
1857	1	32876	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:22.056119+00	\N	2080
1858	1	32877	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:22.056498+00	\N	2081
1859	1	32924	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:22.056886+00	\N	2082
1860	1	32925	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:22.057262+00	\N	2083
1861	1	32927	1	t	LOCALCIRCLE	\N	06-08-2010	\N	2010-12-02 17:08:22.057645+00	\N	2084
1862	1	33076	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.058021+00	\N	2085
1863	1	33078	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:22.058404+00	\N	2086
1864	1	33079	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.058792+00	\N	2087
1865	1	33080	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.059406+00	\N	2088
1866	1	33082	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.059791+00	\N	2089
1867	1	33083	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.060187+00	\N	2090
1868	1	33084	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.064513+00	\N	2091
1869	1	33085	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.06489+00	\N	2092
1870	1	31998	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:22.065264+00	\N	2093
1871	1	31999	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.065644+00	\N	2094
1872	1	32000	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.06605+00	\N	2095
1873	1	32001	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:22.066431+00	\N	2096
1874	1	32002	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:22.066983+00	\N	2097
1875	1	32003	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:22.067366+00	\N	2098
1876	1	32004	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.067745+00	\N	2099
1877	1	32122	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.068123+00	\N	2100
1878	1	32123	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:22.068512+00	\N	2101
1879	1	32125	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:22.068888+00	\N	2102
1880	1	32126	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.06942+00	\N	2103
1881	1	32128	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:22.069795+00	\N	2104
1882	1	32129	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:22.070174+00	\N	2105
1883	1	32130	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.070563+00	\N	2106
1884	1	32131	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:22.070938+00	\N	2107
1885	1	32133	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.071321+00	\N	2108
1886	1	32135	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.071699+00	\N	2109
1887	1	33068	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.072089+00	\N	2110
1888	1	33069	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:22.072471+00	\N	2111
1889	1	33070	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:22.072863+00	\N	2112
1890	1	33071	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:22.073254+00	\N	2113
1891	1	33072	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:22.073643+00	\N	2114
1892	1	33073	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:22.074019+00	\N	2115
1893	1	33074	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:22.081181+00	\N	2116
1894	1	33075	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:22.081558+00	\N	2117
1895	1	33088	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:22.081947+00	\N	2118
1896	1	32251	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:22.082323+00	\N	2119
1897	1	32252	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:22.082704+00	\N	2120
1898	1	32253	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:22.083093+00	\N	2121
1899	1	32254	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:22.083469+00	\N	2122
1900	1	32255	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:22.083897+00	\N	2123
1901	1	32438	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.084277+00	\N	2124
1902	1	32439	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:22.084887+00	\N	2125
1903	1	32440	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.085271+00	\N	2126
1904	1	32441	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.085664+00	\N	2127
1905	1	32442	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:22.086053+00	\N	2128
1906	1	32443	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.086429+00	\N	2129
1907	1	32444	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.086969+00	\N	2130
1908	1	32445	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.087353+00	\N	2131
1909	1	32446	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:22.087732+00	\N	2132
1910	1	32447	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:22.08811+00	\N	2133
1911	1	32448	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.097924+00	\N	2134
1912	1	32451	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.098313+00	\N	2135
1913	1	32452	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.098702+00	\N	2136
1914	1	32453	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.09908+00	\N	2137
1915	1	32009	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:22.099472+00	\N	2138
1916	1	32010	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:22.099889+00	\N	2139
1917	1	32011	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:22.100279+00	\N	2140
1918	1	32013	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:22.100667+00	\N	2141
1919	1	32015	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:22.101057+00	\N	2142
1920	1	32017	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:22.101433+00	\N	2143
1921	1	33096	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:22.101815+00	\N	2144
1922	1	33097	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:22.102219+00	\N	2145
1923	1	33098	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:22.10624+00	\N	2146
1924	1	33099	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:22.106623+00	\N	2147
1925	1	33100	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:22.107007+00	\N	2148
1926	1	33101	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:22.107383+00	\N	2149
1927	1	33102	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:22.107768+00	\N	2150
1928	1	33103	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:22.108157+00	\N	2151
1929	1	33104	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:22.10855+00	\N	2152
1930	1	33105	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:22.108943+00	\N	2153
1931	1	33106	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:22.109331+00	\N	2154
1932	1	33124	1	t	LOCALCIRCLE	\N	16-08-2010	\N	2010-12-02 17:08:22.109707+00	\N	2155
1933	1	33125	1	t	LOCALCIRCLE	\N	16-08-2010	\N	2010-12-02 17:08:22.110087+00	\N	2156
1934	1	33127	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:22.114569+00	\N	2157
1935	1	33129	1	t	LOCALCIRCLE	\N	16-08-2010	\N	2010-12-02 17:08:22.114948+00	\N	2158
1936	1	33130	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:22.115336+00	\N	2159
1937	1	33131	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:22.115716+00	\N	2160
1938	1	33133	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:22.116346+00	\N	2161
1939	1	33134	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:22.116733+00	\N	2162
1940	1	32258	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:22.117121+00	\N	2163
1941	1	32259	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:22.117511+00	\N	2164
1942	1	32261	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:22.117889+00	\N	2165
1943	1	32262	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:22.118271+00	\N	2166
1944	1	32263	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:22.11866+00	\N	2167
1945	1	32264	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:22.119037+00	\N	2168
1946	1	32265	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:22.122978+00	\N	2169
1947	1	32266	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:22.123367+00	\N	2170
1948	1	32267	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:22.123747+00	\N	2171
1949	1	32268	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:22.124128+00	\N	2172
1950	1	32269	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:22.12453+00	\N	2173
1951	1	32348	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:22.124911+00	\N	2174
1952	1	32350	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:22.125302+00	\N	2175
1953	1	32352	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:22.125679+00	\N	2176
1954	1	32353	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:22.126057+00	\N	2177
1955	1	32454	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:22.126433+00	\N	2178
1956	1	32460	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:22.126824+00	\N	2179
1957	1	32461	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:22.127235+00	\N	2180
1958	1	33113	1	t	LOCALCIRCLE	\N	11-08-2010	\N	2010-12-02 17:08:22.131297+00	\N	2181
1959	1	32553	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:22.131676+00	\N	2182
1960	1	32554	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:22.132067+00	\N	2183
1961	1	32640	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:22.13246+00	\N	2184
1962	1	32641	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:22.132859+00	\N	2185
1963	1	32642	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:22.133243+00	\N	2186
1964	1	32643	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:22.133619+00	\N	2187
1965	1	32644	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:22.133998+00	\N	2188
1966	1	32645	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:22.134373+00	\N	2189
1967	1	32647	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:22.134753+00	\N	2190
1968	1	32649	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:22.135142+00	\N	2191
1969	1	32053	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:22.139631+00	\N	2192
1970	1	32054	1	t	LOCALCIRCLE	\N	19-07-2010	\N	2010-12-02 17:08:22.140035+00	\N	2193
1971	1	32056	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:22.140427+00	\N	2194
1972	1	32057	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:22.140804+00	\N	2195
1973	1	32058	1	t	LOCALCIRCLE	\N	19-07-2010	\N	2010-12-02 17:08:22.141191+00	\N	2196
1974	1	32059	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:22.141576+00	\N	2197
1975	1	32060	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:22.142191+00	\N	2198
1976	1	32061	1	t	LOCALCIRCLE	\N	19-07-2010	\N	2010-12-02 17:08:22.142572+00	\N	2199
1977	1	32062	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:22.142948+00	\N	2200
1978	1	32063	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:22.143328+00	\N	2201
1979	1	32064	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:22.14372+00	\N	2202
1980	1	32065	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:22.144114+00	\N	2203
1981	1	32066	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:22.148039+00	\N	2204
1982	1	32067	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:22.14843+00	\N	2205
1983	1	33896	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:22.148821+00	\N	2206
1984	1	32185	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:22.149197+00	\N	2207
1985	1	32186	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:22.149576+00	\N	2208
1986	1	32187	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:22.149951+00	\N	2209
1987	1	32188	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:22.150332+00	\N	2210
1988	1	32189	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:22.150721+00	\N	2211
1989	1	32190	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:22.151096+00	\N	2212
1990	1	32191	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:22.151479+00	\N	2213
1991	1	32192	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:22.151875+00	\N	2214
1992	1	32193	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:22.152274+00	\N	2215
1993	1	32194	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:22.15637+00	\N	2216
1994	1	32195	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:22.15676+00	\N	2217
1995	1	32195	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:22.157137+00	\N	2218
1996	1	32196	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:22.157517+00	\N	2219
1997	1	32197	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:22.157893+00	\N	2220
1998	1	32198	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:22.158272+00	\N	2221
1999	1	32199	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:22.158661+00	\N	2222
2000	1	32200	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:22.159037+00	\N	2223
2001	1	32201	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:22.159419+00	\N	2224
2002	1	32293	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:22.159798+00	\N	2225
2003	1	32294	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:22.160176+00	\N	2226
2004	1	32295	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:22.160565+00	\N	2227
2005	1	32296	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:22.160941+00	\N	2228
2006	1	32297	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:22.161351+00	\N	2229
2007	1	32298	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:22.164686+00	\N	2230
2008	1	32299	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:22.165065+00	\N	2231
2009	1	32302	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:22.165457+00	\N	2232
2010	1	32303	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:22.165833+00	\N	2233
2011	1	32304	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:22.166435+00	\N	2234
2012	1	33331	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:22.166829+00	\N	2235
2013	1	33333	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:22.167209+00	\N	2236
2014	1	33334	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:22.1676+00	\N	2237
2015	1	33335	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:22.167996+00	\N	2238
2016	1	33336	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:22.168388+00	\N	2239
2017	1	33338	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:22.168778+00	\N	2240
2018	1	33339	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:22.169168+00	\N	2241
2019	1	33340	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:22.173082+00	\N	2242
2020	1	33341	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:22.17346+00	\N	2243
2021	1	33342	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:22.173851+00	\N	2244
2022	1	33343	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:22.174243+00	\N	2245
2023	1	33344	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:22.174633+00	\N	2246
2024	1	33345	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:22.17501+00	\N	2247
2025	1	33353	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:22.17539+00	\N	2248
2026	1	32384	1	t	LOCALCIRCLE	\N	16-08-2010	\N	2010-12-02 17:08:22.175783+00	\N	2249
2027	1	32385	1	t	LOCALCIRCLE	\N	30-08-2010	\N	2010-12-02 17:08:22.176175+00	\N	2250
2028	1	32386	1	t	LOCALCIRCLE	\N	16-08-2010	\N	2010-12-02 17:08:22.176566+00	\N	2251
2029	1	32387	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:22.176957+00	\N	2252
2030	1	32388	1	t	LOCALCIRCLE	\N	16-08-2010	\N	2010-12-02 17:08:22.177365+00	\N	2253
2031	1	32389	1	t	LOCALCIRCLE	\N	16-08-2010	\N	2010-12-02 17:08:22.181415+00	\N	2254
2032	1	32391	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:22.181794+00	\N	2255
2033	1	32392	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:22.182183+00	\N	2256
2034	1	32393	1	t	LOCALCIRCLE	\N	16-08-2010	\N	2010-12-02 17:08:22.182574+00	\N	2257
2035	1	32394	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:22.18297+00	\N	2258
2036	1	32395	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:22.183391+00	\N	2259
2037	1	32396	1	t	LOCALCIRCLE	\N	16-08-2010	\N	2010-12-02 17:08:22.183786+00	\N	2260
2038	1	32397	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:22.184178+00	\N	2261
2039	1	33346	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:22.184569+00	\N	2262
2040	1	33347	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:22.184959+00	\N	2263
2041	1	33348	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:22.185353+00	\N	2264
2042	1	33349	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:22.185744+00	\N	2265
2043	1	33350	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:22.186121+00	\N	2266
2044	1	33351	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:22.189745+00	\N	2267
2045	1	33354	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:22.19016+00	\N	2268
2046	1	33355	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:22.190546+00	\N	2269
2047	1	33356	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:22.190937+00	\N	2270
2048	1	33357	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:22.191551+00	\N	2271
2049	1	33358	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:22.19194+00	\N	2272
2050	1	33359	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:22.192333+00	\N	2273
2051	1	33360	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:22.21257+00	\N	2274
2052	1	32486	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:22.212949+00	\N	2275
2053	1	32487	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:22.213342+00	\N	2276
2054	1	32488	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:22.213734+00	\N	2277
2055	1	32489	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:22.214126+00	\N	2278
2056	1	32490	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:22.214516+00	\N	2279
2057	1	32491	1	t	LOCALCIRCLE	\N	19-07-2010	\N	2010-12-02 17:08:22.214908+00	\N	2280
2058	1	32492	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:22.2153+00	\N	2281
2059	1	32493	1	t	LOCALCIRCLE	\N	20-07-2010	\N	2010-12-02 17:08:22.21568+00	\N	2282
2060	1	32494	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:22.21609+00	\N	2283
2061	1	32496	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:22.216482+00	\N	2284
2062	1	32498	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:22.216871+00	\N	2285
2063	1	32499	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:22.217247+00	\N	2286
2064	1	32500	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:22.231488+00	\N	2287
2065	1	32502	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:22.231882+00	\N	2288
2066	1	32591	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:22.232273+00	\N	2289
2067	1	32592	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:22.232663+00	\N	2290
2068	1	32593	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:22.233055+00	\N	2291
2069	1	32594	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:22.233447+00	\N	2292
2070	1	32595	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:22.233839+00	\N	2293
2071	1	32596	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:22.23423+00	\N	2294
2072	1	32597	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:22.234613+00	\N	2295
2073	1	32598	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:22.234989+00	\N	2296
2074	1	32600	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:22.23538+00	\N	2297
2075	1	32601	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:22.235773+00	\N	2298
2076	1	32603	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:22.236164+00	\N	2299
2077	1	32604	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:22.239801+00	\N	2300
2078	1	32676	1	t	LOCALCIRCLE	\N	16-08-2010	\N	2010-12-02 17:08:22.240182+00	\N	2301
2079	1	32677	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:22.240576+00	\N	2302
2080	1	32679	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:22.240964+00	\N	2303
2081	1	32681	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:22.241356+00	\N	2304
2082	1	32682	1	t	LOCALCIRCLE	\N	30-08-2010	\N	2010-12-02 17:08:22.241732+00	\N	2305
2083	1	32683	1	t	LOCALCIRCLE	\N	16-08-2010	\N	2010-12-02 17:08:22.242111+00	\N	2306
2084	1	32684	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:22.242725+00	\N	2307
2085	1	32686	1	t	LOCALCIRCLE	\N	30-08-2010	\N	2010-12-02 17:08:22.243108+00	\N	2308
2086	1	33314	1	t	LOCALCIRCLE	\N	30-08-2010	\N	2010-12-02 17:08:22.243497+00	\N	2309
2087	1	33315	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:22.243878+00	\N	2310
2088	1	33316	1	t	LOCALCIRCLE	\N	30-08-2010	\N	2010-12-02 17:08:22.244256+00	\N	2311
2089	1	33317	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:22.248197+00	\N	2312
2090	1	33318	1	t	LOCALCIRCLE	\N	30-08-2010	\N	2010-12-02 17:08:22.248577+00	\N	2313
2091	1	33320	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:22.248965+00	\N	2314
2092	1	33321	1	t	LOCALCIRCLE	\N	19-07-2010	\N	2010-12-02 17:08:22.249354+00	\N	2315
2093	1	33322	1	t	LOCALCIRCLE	\N	19-07-2010	\N	2010-12-02 17:08:22.249732+00	\N	2316
2094	1	33323	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:22.250112+00	\N	2317
2095	1	33326	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:22.250502+00	\N	2318
2096	1	33327	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:22.250877+00	\N	2319
2097	1	33328	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:22.25126+00	\N	2320
2098	1	33329	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:22.251652+00	\N	2321
2099	1	33330	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:22.252045+00	\N	2322
2100	1	32786	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:22.252588+00	\N	2323
2101	1	32787	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:22.252978+00	\N	2324
2102	1	32789	1	t	LOCALCIRCLE	\N	19-07-2010	\N	2010-12-02 17:08:22.253353+00	\N	2325
2103	1	32790	1	t	LOCALCIRCLE	\N	19-07-2010	\N	2010-12-02 17:08:22.253735+00	\N	2326
2104	1	32791	1	t	LOCALCIRCLE	\N	19-07-2010	\N	2010-12-02 17:08:22.254124+00	\N	2327
2105	1	32793	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:22.254501+00	\N	2328
2106	1	32794	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:22.254882+00	\N	2329
2107	1	32795	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:22.255272+00	\N	2330
2108	1	32796	1	t	LOCALCIRCLE	\N	19-07-2010	\N	2010-12-02 17:08:22.255651+00	\N	2331
2109	1	32797	1	t	LOCALCIRCLE	\N	19-07-2010	\N	2010-12-02 17:08:22.256042+00	\N	2332
2110	1	32798	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:22.256426+00	\N	2333
2111	1	32799	1	t	LOCALCIRCLE	\N	19-07-2010	\N	2010-12-02 17:08:22.256815+00	\N	2334
2112	1	32800	1	t	LOCALCIRCLE	\N	19-07-2010	\N	2010-12-02 17:08:22.257204+00	\N	2335
2113	1	32839	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:22.26486+00	\N	2336
2114	1	32840	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:22.265238+00	\N	2337
2115	1	32841	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:22.265628+00	\N	2338
2116	1	32842	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:22.266005+00	\N	2339
2117	1	32843	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:22.266387+00	\N	2340
2118	1	32844	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:22.266777+00	\N	2341
2119	1	32845	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:22.267167+00	\N	2342
2120	1	32846	1	t	LOCALCIRCLE	\N	27-07-2010	\N	2010-12-02 17:08:22.267543+00	\N	2343
2121	1	32847	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:22.268149+00	\N	2344
2122	1	32848	1	t	LOCALCIRCLE	\N	08-07-2010	\N	2010-12-02 17:08:22.268529+00	\N	2345
2123	1	32849	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:22.26892+00	\N	2346
2124	1	32850	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:22.269316+00	\N	2347
2125	1	32896	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:22.273634+00	\N	2349
2126	1	32897	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:22.274024+00	\N	2350
2127	1	32898	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:22.274418+00	\N	2351
2128	1	32899	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:22.274814+00	\N	2352
2129	1	32900	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:22.275205+00	\N	2353
2130	1	32901	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:22.275595+00	\N	2354
2131	1	32902	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:22.276+00	\N	2355
2132	1	32903	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:22.276381+00	\N	2356
2133	1	32904	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:22.276771+00	\N	2357
2134	1	32905	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:22.277161+00	\N	2358
2135	1	32906	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:22.277644+00	\N	2359
2136	1	32907	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:22.278022+00	\N	2360
2137	1	32908	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:22.278403+00	\N	2361
2138	1	32909	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:22.278793+00	\N	2362
2139	1	32910	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:22.279183+00	\N	2363
2140	1	32911	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:22.279578+00	\N	2364
2141	1	29544	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.280366+00	\N	2366
2142	1	29545	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.280757+00	\N	2367
2143	1	29550	1	t	LOCALCIRCLE	\N	10-11-2010	\N	2010-12-02 17:08:22.281148+00	\N	2368
2144	1	29551	1	t	LOCALCIRCLE	\N	03-11-2010	\N	2010-12-02 17:08:22.281539+00	\N	2369
2145	1	29552	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.281917+00	\N	2370
2146	1	29553	1	t	LOCALCIRCLE	\N	03-11-2010	\N	2010-12-02 17:08:22.282296+00	\N	2371
2147	1	29555	1	t	LOCALCIRCLE	\N	25-10-2010	\N	2010-12-02 17:08:22.289923+00	\N	2372
2148	1	29556	1	t	LOCALCIRCLE	\N	03-11-2010	\N	2010-12-02 17:08:22.290299+00	\N	2373
2149	1	29557	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.290687+00	\N	2374
2150	1	29559	1	t	LOCALCIRCLE	\N	03-11-2010	\N	2010-12-02 17:08:22.29108+00	\N	2375
2151	1	29560	1	t	LOCALCIRCLE	\N	03-11-2010	\N	2010-12-02 17:08:22.29147+00	\N	2376
2152	1	29561	1	t	LOCALCIRCLE	\N	25-10-2010	\N	2010-12-02 17:08:22.291851+00	\N	2377
2153	1	29562	1	t	LOCALCIRCLE	\N	08-11-2010	\N	2010-12-02 17:08:22.292231+00	\N	2378
2154	1	29569	1	t	LOCALCIRCLE	\N	03-11-2010	\N	2010-12-02 17:08:22.292652+00	\N	2379
2155	1	29574	1	t	LOCALCIRCLE	\N	25-10-2010	\N	2010-12-02 17:08:22.293265+00	\N	2380
2156	1	29580	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.293647+00	\N	2381
2157	1	29588	1	t	LOCALCIRCLE	\N	10-09-2010	\N	2010-12-02 17:08:22.294039+00	\N	2382
2158	1	29592	1	t	LOCALCIRCLE	\N	10-09-2010	\N	2010-12-02 17:08:22.294459+00	\N	2383
2159	1	29594	1	t	LOCALCIRCLE	\N	08-11-2010	\N	2010-12-02 17:08:22.298312+00	\N	2384
2160	1	29597	1	t	LOCALCIRCLE	\N	03-11-2010	\N	2010-12-02 17:08:22.298691+00	\N	2385
2161	1	29598	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.29908+00	\N	2386
2162	1	29599	1	t	LOCALCIRCLE	\N	25-10-2010	\N	2010-12-02 17:08:22.299484+00	\N	2387
2163	1	29600	1	t	LOCALCIRCLE	\N	26-10-2010	\N	2010-12-02 17:08:22.29987+00	\N	2388
2164	1	29601	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.300261+00	\N	2389
2165	1	29603	1	t	LOCALCIRCLE	\N	25-10-2010	\N	2010-12-02 17:08:22.30065+00	\N	2390
2166	1	29604	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.301026+00	\N	2391
2167	1	29605	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.301407+00	\N	2392
2168	1	29609	1	t	LOCALCIRCLE	\N	08-11-2010	\N	2010-12-02 17:08:22.301786+00	\N	2393
2169	1	29612	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.302162+00	\N	2394
2170	1	29613	1	t	LOCALCIRCLE	\N	08-11-2010	\N	2010-12-02 17:08:22.302656+00	\N	2395
2171	1	29614	1	t	LOCALCIRCLE	\N	25-10-2010	\N	2010-12-02 17:08:22.303037+00	\N	2396
2172	1	29615	1	t	LOCALCIRCLE	\N	08-11-2010	\N	2010-12-02 17:08:22.303428+00	\N	2397
2173	1	29616	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.303807+00	\N	2398
2174	1	29620	1	t	LOCALCIRCLE	\N	03-11-2010	\N	2010-12-02 17:08:22.304187+00	\N	2399
2175	1	29621	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.304576+00	\N	2400
2176	1	29625	1	t	LOCALCIRCLE	\N	25-10-2010	\N	2010-12-02 17:08:22.304951+00	\N	2401
2177	1	29628	1	t	LOCALCIRCLE	\N	15-09-2010	\N	2010-12-02 17:08:22.305392+00	\N	2402
2178	1	29635	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.305782+00	\N	2403
2179	1	29640	1	t	LOCALCIRCLE	\N	19-06-2010	\N	2010-12-02 17:08:22.306159+00	\N	2404
2180	1	29644	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.306539+00	\N	2405
2181	1	29650	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.306914+00	\N	2406
2182	1	29654	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.307294+00	\N	2407
2183	1	29657	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.314978+00	\N	2408
2184	1	29664	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.315355+00	\N	2409
2185	1	29666	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.315747+00	\N	2410
2186	1	29671	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.316151+00	\N	2411
2187	1	29675	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.316533+00	\N	2412
2188	1	29682	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.316922+00	\N	2413
2189	1	29683	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.317328+00	\N	2414
2190	1	29687	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.31771+00	\N	2415
2191	1	29692	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.3181+00	\N	2416
2192	1	29694	1	t	LOCALCIRCLE	\N	28-10-2010	\N	2010-12-02 17:08:22.318496+00	\N	2417
2193	1	29698	1	t	LOCALCIRCLE	\N	17-09-2010	\N	2010-12-02 17:08:22.318888+00	\N	2418
2194	1	29699	1	t	LOCALCIRCLE	\N	02-11-2010	\N	2010-12-02 17:08:22.319278+00	\N	2419
2195	1	29703	1	t	LOCALCIRCLE	\N	02-11-2010	\N	2010-12-02 17:08:22.323449+00	\N	2420
2196	1	29705	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.323842+00	\N	2421
2197	1	30217	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.324234+00	\N	2422
2198	1	30218	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.324623+00	\N	2423
2199	1	30220	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.324999+00	\N	2424
2200	1	30222	1	t	LOCALCIRCLE	\N	16-08-2010	\N	2010-12-02 17:08:22.325381+00	\N	2425
2201	1	30224	1	t	LOCALCIRCLE	\N	25-10-2010	\N	2010-12-02 17:08:22.325771+00	\N	2426
2202	1	30250	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.32616+00	\N	2427
2203	1	30254	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.326535+00	\N	2428
2204	1	30287	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.326919+00	\N	2429
2205	1	32895	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:22.279973+00	\N	2365
2206	1	30292	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.327308+00	\N	2430
2207	1	30296	1	t	LOCALCIRCLE	\N	26-10-2010	\N	2010-12-02 17:08:22.331765+00	\N	2431
2208	1	30298	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.332144+00	\N	2432
2209	1	30302	1	t	LOCALCIRCLE	\N	25-10-2010	\N	2010-12-02 17:08:22.332533+00	\N	2433
2210	1	30303	1	t	LOCALCIRCLE	\N	26-10-2010	\N	2010-12-02 17:08:22.332926+00	\N	2434
2211	1	30304	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.333316+00	\N	2435
2212	1	30307	1	t	LOCALCIRCLE	\N	07-09-2010	\N	2010-12-02 17:08:22.333693+00	\N	2436
2213	1	30310	1	t	LOCALCIRCLE	\N	25-10-2010	\N	2010-12-02 17:08:22.334078+00	\N	2437
2214	1	30311	1	t	LOCALCIRCLE	\N	26-10-2010	\N	2010-12-02 17:08:22.334468+00	\N	2438
2215	1	30313	1	t	LOCALCIRCLE	\N	26-10-2010	\N	2010-12-02 17:08:22.334858+00	\N	2439
2216	1	30316	1	t	LOCALCIRCLE	\N	07-09-2010	\N	2010-12-02 17:08:22.335248+00	\N	2440
2217	1	30317	1	t	LOCALCIRCLE	\N	07-09-2010	\N	2010-12-02 17:08:22.335626+00	\N	2441
2218	1	30318	1	t	LOCALCIRCLE	\N	04-10-2010	\N	2010-12-02 17:08:22.336018+00	\N	2442
2219	1	30320	1	t	LOCALCIRCLE	\N	07-09-2010	\N	2010-12-02 17:08:22.336431+00	\N	2443
2220	1	30321	1	t	LOCALCIRCLE	\N	26-10-2010	\N	2010-12-02 17:08:22.340096+00	\N	2444
2221	1	30322	1	t	LOCALCIRCLE	\N	25-10-2010	\N	2010-12-02 17:08:22.340478+00	\N	2445
2222	1	30323	1	t	LOCALCIRCLE	\N	26-10-2010	\N	2010-12-02 17:08:22.340867+00	\N	2446
2223	1	30325	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.341256+00	\N	2447
2224	1	30328	1	t	LOCALCIRCLE	\N	26-10-2010	\N	2010-12-02 17:08:22.341633+00	\N	2448
2225	1	30329	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.342014+00	\N	2449
2226	1	30330	1	t	LOCALCIRCLE	\N	07-09-2010	\N	2010-12-02 17:08:22.342626+00	\N	2450
2227	1	30333	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.343011+00	\N	2451
2228	1	30336	1	t	LOCALCIRCLE	\N	07-09-2010	\N	2010-12-02 17:08:22.343402+00	\N	2452
2229	1	30337	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.343795+00	\N	2453
2230	1	30340	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.344186+00	\N	2454
2231	1	30345	1	t	LOCALCIRCLE	\N	07-09-2010	\N	2010-12-02 17:08:22.344673+00	\N	2455
2232	1	30346	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:22.345063+00	\N	2456
2233	1	30347	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.345454+00	\N	2457
2234	1	30348	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.345831+00	\N	2458
2235	1	30350	1	t	LOCALCIRCLE	\N	04-11-2010	\N	2010-12-02 17:08:22.34621+00	\N	2459
2236	1	30351	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.346605+00	\N	2460
2237	1	30355	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.346993+00	\N	2461
2238	1	30356	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.347369+00	\N	2462
2239	1	30357	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.347751+00	\N	2463
2240	1	30358	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.348141+00	\N	2464
2241	1	30359	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.348532+00	\N	2465
2242	1	30361	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.348911+00	\N	2466
2243	1	30363	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.349291+00	\N	2467
2244	1	30364	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.356839+00	\N	2468
2245	1	30365	1	t	LOCALCIRCLE	\N	07-09-2010	\N	2010-12-02 17:08:22.35723+00	\N	2469
2246	1	30366	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.357621+00	\N	2470
2247	1	30367	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.357998+00	\N	2471
2248	1	30368	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.358378+00	\N	2472
2249	1	30369	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.358769+00	\N	2473
2250	1	30370	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.359148+00	\N	2474
2251	1	30372	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.359528+00	\N	2475
2252	1	30374	1	t	LOCALCIRCLE	\N	28-10-2010	\N	2010-12-02 17:08:22.359921+00	\N	2476
2253	1	30376	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.360308+00	\N	2477
2254	1	30409	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:22.360681+00	\N	2478
2255	1	30410	1	t	LOCALCIRCLE	\N	29-09-2010	\N	2010-12-02 17:08:22.361061+00	\N	2479
2256	1	30416	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:22.361463+00	\N	2480
2257	1	30419	1	t	LOCALCIRCLE	\N	25-10-2010	\N	2010-12-02 17:08:22.365174+00	\N	2481
2258	1	30438	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:22.365563+00	\N	2482
2259	1	30442	1	t	LOCALCIRCLE	\N	09-09-2010	\N	2010-12-02 17:08:22.365953+00	\N	2483
2260	1	30444	1	t	LOCALCIRCLE	\N	09-09-2010	\N	2010-12-02 17:08:22.366329+00	\N	2484
2261	1	30447	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:22.36671+00	\N	2485
2262	1	30449	1	t	LOCALCIRCLE	\N	18-09-2010	\N	2010-12-02 17:08:22.367323+00	\N	2486
2263	1	30450	1	t	LOCALCIRCLE	\N	04-11-2010	\N	2010-12-02 17:08:22.36771+00	\N	2487
2264	1	30454	1	t	LOCALCIRCLE	\N	08-11-2010	\N	2010-12-02 17:08:22.3681+00	\N	2488
2265	1	30455	1	t	LOCALCIRCLE	\N	18-09-2010	\N	2010-12-02 17:08:22.368494+00	\N	2489
2266	1	30474	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:22.368884+00	\N	2490
2267	1	30475	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:22.369273+00	\N	2491
2268	1	30479	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:22.369729+00	\N	2492
2269	1	30480	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:22.370119+00	\N	2493
2270	1	30482	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:22.370511+00	\N	2494
2271	1	30483	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:22.370887+00	\N	2495
2272	1	30495	1	t	LOCALCIRCLE	\N	02-11-2010	\N	2010-12-02 17:08:22.371269+00	\N	2496
2273	1	30504	1	t	LOCALCIRCLE	\N	29-10-2010	\N	2010-12-02 17:08:22.371661+00	\N	2497
2274	1	30536	1	t	LOCALCIRCLE	\N	27-10-2010	\N	2010-12-02 17:08:22.372054+00	\N	2498
2275	1	30537	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:22.372479+00	\N	2499
2276	1	30538	1	t	LOCALCIRCLE	\N	27-10-2010	\N	2010-12-02 17:08:22.37287+00	\N	2500
2277	1	30579	1	t	LOCALCIRCLE	\N	17-09-2010	\N	2010-12-02 17:08:22.37326+00	\N	2501
2278	1	30581	1	t	LOCALCIRCLE	\N	26-10-2010	\N	2010-12-02 17:08:22.373637+00	\N	2502
2279	1	30585	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.374016+00	\N	2503
2280	1	30587	1	t	LOCALCIRCLE	\N	08-11-2010	\N	2010-12-02 17:08:22.37441+00	\N	2504
2281	1	30591	1	t	LOCALCIRCLE	\N	08-11-2010	\N	2010-12-02 17:08:22.381897+00	\N	2505
2282	1	30592	1	t	LOCALCIRCLE	\N	17-09-2010	\N	2010-12-02 17:08:22.382288+00	\N	2506
2283	1	30596	1	t	LOCALCIRCLE	\N	08-11-2010	\N	2010-12-02 17:08:22.382679+00	\N	2507
2284	1	30597	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.383057+00	\N	2508
2285	1	30621	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.383439+00	\N	2509
2286	1	30624	1	t	LOCALCIRCLE	\N	28-09-2010	\N	2010-12-02 17:08:22.383832+00	\N	2510
2287	1	30626	1	t	LOCALCIRCLE	\N	25-10-2010	\N	2010-12-02 17:08:22.384223+00	\N	2511
2288	1	30632	1	t	LOCALCIRCLE	\N	29-09-2010	\N	2010-12-02 17:08:22.384617+00	\N	2512
2289	1	30638	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.385006+00	\N	2513
2290	1	30684	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.385395+00	\N	2514
2291	1	30688	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.385776+00	\N	2515
2292	1	30694	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.386154+00	\N	2516
2293	1	30696	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.386574+00	\N	2517
2294	1	30701	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.390212+00	\N	2518
2295	1	30709	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.390591+00	\N	2519
2296	1	30715	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.390981+00	\N	2520
2297	1	30723	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.391358+00	\N	2521
2298	1	30733	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.391741+00	\N	2522
2299	1	30745	1	t	LOCALCIRCLE	\N	14-07-2010	\N	2010-12-02 17:08:22.392351+00	\N	2523
2300	1	30765	1	t	LOCALCIRCLE	\N	28-10-2010	\N	2010-12-02 17:08:22.392735+00	\N	2524
2301	1	30774	1	t	LOCALCIRCLE	\N	15-09-2010	\N	2010-12-02 17:08:22.393125+00	\N	2525
2302	1	30778	1	t	LOCALCIRCLE	\N	08-11-2010	\N	2010-12-02 17:08:22.393517+00	\N	2526
2303	1	30779	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.393894+00	\N	2527
2304	1	30795	1	t	LOCALCIRCLE	\N	08-11-2010	\N	2010-12-02 17:08:22.394274+00	\N	2528
2305	1	30808	1	t	LOCALCIRCLE	\N	23-09-2010	\N	2010-12-02 17:08:22.394756+00	\N	2529
2306	1	30811	1	t	LOCALCIRCLE	\N	23-09-2010	\N	2010-12-02 17:08:22.395148+00	\N	2530
2307	1	30813	1	t	LOCALCIRCLE	\N	23-09-2010	\N	2010-12-02 17:08:22.39554+00	\N	2531
2308	1	30822	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:22.39592+00	\N	2532
2309	1	30824	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:22.396303+00	\N	2533
2310	1	30829	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:22.39669+00	\N	2534
2311	1	30830	1	t	LOCALCIRCLE	\N	03-11-2010	\N	2010-12-02 17:08:22.39708+00	\N	2535
2312	1	30832	1	t	LOCALCIRCLE	\N	15-09-2010	\N	2010-12-02 17:08:22.397457+00	\N	2536
2313	1	30833	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:22.397837+00	\N	2537
2314	1	30835	1	t	LOCALCIRCLE	\N	08-11-2010	\N	2010-12-02 17:08:22.398227+00	\N	2538
2315	1	30837	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:22.398609+00	\N	2539
2316	1	30839	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:22.398985+00	\N	2540
2317	1	30849	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.399387+00	\N	2541
2318	1	30852	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:22.406955+00	\N	2542
2319	1	30859	1	t	LOCALCIRCLE	\N	31-08-2010	\N	2010-12-02 17:08:22.407345+00	\N	2543
2320	1	30861	1	t	LOCALCIRCLE	\N	31-08-2010	\N	2010-12-02 17:08:22.407743+00	\N	2544
2321	1	30864	1	t	LOCALCIRCLE	\N	03-11-2010	\N	2010-12-02 17:08:22.408135+00	\N	2545
2322	1	30865	1	t	LOCALCIRCLE	\N	31-08-2010	\N	2010-12-02 17:08:22.408526+00	\N	2546
2323	1	30868	1	t	LOCALCIRCLE	\N	03-11-2010	\N	2010-12-02 17:08:22.408916+00	\N	2547
2324	1	30871	1	t	LOCALCIRCLE	\N	03-11-2010	\N	2010-12-02 17:08:22.409305+00	\N	2548
2325	1	30872	1	t	LOCALCIRCLE	\N	03-11-2010	\N	2010-12-02 17:08:22.409682+00	\N	2549
2326	1	30882	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:22.410064+00	\N	2550
2327	1	30887	1	t	LOCALCIRCLE	\N	27-09-2010	\N	2010-12-02 17:08:22.410454+00	\N	2551
2328	1	30888	1	t	LOCALCIRCLE	\N	24-09-2010	\N	2010-12-02 17:08:22.41083+00	\N	2552
2329	1	30892	1	t	LOCALCIRCLE	\N	24-09-2010	\N	2010-12-02 17:08:22.411211+00	\N	2553
2330	1	30898	1	t	LOCALCIRCLE	\N	24-09-2010	\N	2010-12-02 17:08:22.411737+00	\N	2554
2331	1	30901	1	t	LOCALCIRCLE	\N	23-10-2010	\N	2010-12-02 17:08:22.412122+00	\N	2555
2332	1	30903	1	t	LOCALCIRCLE	\N	24-09-2010	\N	2010-12-02 17:08:22.412509+00	\N	2556
2333	1	30904	1	t	LOCALCIRCLE	\N	23-10-2010	\N	2010-12-02 17:08:22.412899+00	\N	2557
2334	1	30905	1	t	LOCALCIRCLE	\N	24-09-2010	\N	2010-12-02 17:08:22.413275+00	\N	2558
2335	1	30906	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.413908+00	\N	2559
2336	1	30907	1	t	LOCALCIRCLE	\N	23-10-2010	\N	2010-12-02 17:08:22.41429+00	\N	2560
2337	1	30909	1	t	LOCALCIRCLE	\N	27-09-2010	\N	2010-12-02 17:08:22.414679+00	\N	2561
2338	1	30911	1	t	LOCALCIRCLE	\N	24-09-2010	\N	2010-12-02 17:08:22.415056+00	\N	2562
2339	1	30912	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.415438+00	\N	2563
2340	1	30913	1	t	LOCALCIRCLE	\N	23-10-2010	\N	2010-12-02 17:08:22.415836+00	\N	2564
2341	1	30914	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:22.416225+00	\N	2565
2342	1	30916	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.416739+00	\N	2566
2343	1	30922	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.417128+00	\N	2567
2344	1	30925	1	t	LOCALCIRCLE	\N	27-10-2010	\N	2010-12-02 17:08:22.417517+00	\N	2568
2345	1	30928	1	t	LOCALCIRCLE	\N	23-10-2010	\N	2010-12-02 17:08:22.417894+00	\N	2569
2346	1	30930	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.418276+00	\N	2570
2347	1	30934	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.418665+00	\N	2571
2348	1	30937	1	t	LOCALCIRCLE	\N	23-10-2010	\N	2010-12-02 17:08:22.419042+00	\N	2572
2349	1	30938	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.419423+00	\N	2573
2350	1	30939	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.419816+00	\N	2574
2351	1	30940	1	t	LOCALCIRCLE	\N	27-09-2010	\N	2010-12-02 17:08:22.420209+00	\N	2575
2352	1	30942	1	t	LOCALCIRCLE	\N	23-10-2010	\N	2010-12-02 17:08:22.4206+00	\N	2576
2353	1	30945	1	t	LOCALCIRCLE	\N	27-09-2010	\N	2010-12-02 17:08:22.420989+00	\N	2577
2354	1	30956	1	t	LOCALCIRCLE	\N	18-10-2010	\N	2010-12-02 17:08:22.421366+00	\N	2578
2355	1	30961	1	t	LOCALCIRCLE	\N	18-10-2010	\N	2010-12-02 17:08:22.423685+00	\N	2579
2356	1	30962	1	t	LOCALCIRCLE	\N	14-10-2010	\N	2010-12-02 17:08:22.424077+00	\N	2580
2357	1	30971	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.424494+00	\N	2581
2358	1	30974	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.424872+00	\N	2582
2359	1	30977	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.42525+00	\N	2583
2360	1	30984	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:22.42564+00	\N	2584
2361	1	30988	1	t	LOCALCIRCLE	\N	08-11-2010	\N	2010-12-02 17:08:22.426017+00	\N	2585
2362	1	30990	1	t	LOCALCIRCLE	\N	18-10-2010	\N	2010-12-02 17:08:22.426397+00	\N	2586
2363	1	30991	1	t	LOCALCIRCLE	\N	18-10-2010	\N	2010-12-02 17:08:22.426787+00	\N	2587
2364	1	30995	1	t	LOCALCIRCLE	\N	18-10-2010	\N	2010-12-02 17:08:22.427164+00	\N	2588
2365	1	31006	1	t	LOCALCIRCLE	\N	04-11-2010	\N	2010-12-02 17:08:22.427551+00	\N	2589
2366	1	31013	1	t	LOCALCIRCLE	\N	29-10-2010	\N	2010-12-02 17:08:22.42794+00	\N	2590
2367	1	31022	1	t	LOCALCIRCLE	\N	29-10-2010	\N	2010-12-02 17:08:22.428332+00	\N	2591
2368	1	31024	1	t	LOCALCIRCLE	\N	29-10-2010	\N	2010-12-02 17:08:22.428791+00	\N	2592
2369	1	31042	1	t	LOCALCIRCLE	\N	29-10-2010	\N	2010-12-02 17:08:22.429175+00	\N	2593
2370	1	31044	1	t	LOCALCIRCLE	\N	09-09-2010	\N	2010-12-02 17:08:22.429567+00	\N	2594
2371	1	31065	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.429956+00	\N	2595
2372	1	31068	1	t	LOCALCIRCLE	\N	29-09-2010	\N	2010-12-02 17:08:22.430575+00	\N	2596
2373	1	31069	1	t	LOCALCIRCLE	\N	28-09-2010	\N	2010-12-02 17:08:22.430957+00	\N	2597
2374	1	31071	1	t	LOCALCIRCLE	\N	29-09-2010	\N	2010-12-02 17:08:22.431353+00	\N	2598
2375	1	31072	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.431744+00	\N	2599
2376	1	31079	1	t	LOCALCIRCLE	\N	28-09-2010	\N	2010-12-02 17:08:22.432137+00	\N	2600
2377	1	31080	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.432526+00	\N	2601
2378	1	31081	1	t	LOCALCIRCLE	\N	29-09-2010	\N	2010-12-02 17:08:22.432917+00	\N	2602
2379	1	31086	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.433309+00	\N	2603
2380	1	31098	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.433793+00	\N	2604
2381	1	31105	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.434185+00	\N	2605
2382	1	31111	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.434579+00	\N	2606
2383	1	31118	1	t	LOCALCIRCLE	\N	03-09-2010	\N	2010-12-02 17:08:22.43497+00	\N	2607
2384	1	31126	1	t	LOCALCIRCLE	\N	20-09-2010	\N	2010-12-02 17:08:22.435366+00	\N	2608
2385	1	31133	1	t	LOCALCIRCLE	\N	18-09-2010	\N	2010-12-02 17:08:22.43576+00	\N	2609
2386	1	31138	1	t	LOCALCIRCLE	\N	18-09-2010	\N	2010-12-02 17:08:22.436152+00	\N	2610
2387	1	31141	1	t	LOCALCIRCLE	\N	18-09-2010	\N	2010-12-02 17:08:22.436544+00	\N	2611
2388	1	31143	1	t	LOCALCIRCLE	\N	22-06-2010	\N	2010-12-02 17:08:22.436934+00	\N	2612
2389	1	31145	1	t	LOCALCIRCLE	\N	20-09-2010	\N	2010-12-02 17:08:22.437326+00	\N	2613
2390	1	31156	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.437718+00	\N	2614
2391	1	31157	1	t	LOCALCIRCLE	\N	20-09-2010	\N	2010-12-02 17:08:22.43811+00	\N	2615
2392	1	31161	1	t	LOCALCIRCLE	\N	20-09-2010	\N	2010-12-02 17:08:22.438531+00	\N	2616
2393	1	31165	1	t	LOCALCIRCLE	\N	20-09-2010	\N	2010-12-02 17:08:22.440408+00	\N	2617
2394	1	31166	1	t	LOCALCIRCLE	\N	18-09-2010	\N	2010-12-02 17:08:22.440799+00	\N	2618
2395	1	31167	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.441222+00	\N	2619
2396	1	31171	1	t	LOCALCIRCLE	\N	20-09-2010	\N	2010-12-02 17:08:22.441615+00	\N	2620
2397	1	31177	1	t	LOCALCIRCLE	\N	18-09-2010	\N	2010-12-02 17:08:22.442006+00	\N	2621
2398	1	31186	1	t	LOCALCIRCLE	\N	18-09-2010	\N	2010-12-02 17:08:22.442398+00	\N	2622
2399	1	31192	1	t	LOCALCIRCLE	\N	18-09-2010	\N	2010-12-02 17:08:22.44279+00	\N	2623
2400	1	31199	1	t	LOCALCIRCLE	\N	18-09-2010	\N	2010-12-02 17:08:22.443182+00	\N	2624
2401	1	31202	1	t	LOCALCIRCLE	\N	09-09-2010	\N	2010-12-02 17:08:22.443577+00	\N	2625
2402	1	31203	1	t	LOCALCIRCLE	\N	20-09-2010	\N	2010-12-02 17:08:22.443971+00	\N	2626
2403	1	31206	1	t	LOCALCIRCLE	\N	08-11-2010	\N	2010-12-02 17:08:22.444364+00	\N	2627
2404	1	31210	1	t	LOCALCIRCLE	\N	20-09-2010	\N	2010-12-02 17:08:22.448724+00	\N	2628
2405	1	31212	1	t	LOCALCIRCLE	\N	29-10-2010	\N	2010-12-02 17:08:22.449103+00	\N	2629
2406	1	31214	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.449504+00	\N	2630
2407	1	31219	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:22.449886+00	\N	2631
2408	1	31222	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.4505+00	\N	2632
2409	1	31243	1	t	LOCALCIRCLE	\N	31-08-2010	\N	2010-12-02 17:08:22.450886+00	\N	2633
2410	1	31253	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:22.451275+00	\N	2634
2411	1	31255	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:22.451668+00	\N	2635
2412	1	31257	1	t	LOCALCIRCLE	\N	25-06-2010	\N	2010-12-02 17:08:22.452063+00	\N	2636
2413	1	31259	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:22.452454+00	\N	2637
2414	1	31290	1	t	LOCALCIRCLE	\N	18-10-2010	\N	2010-12-02 17:08:22.452843+00	\N	2638
2415	1	31295	1	t	LOCALCIRCLE	\N	08-11-2010	\N	2010-12-02 17:08:22.45322+00	\N	2639
2416	1	31348	1	t	LOCALCIRCLE	\N	14-10-2010	\N	2010-12-02 17:08:22.45363+00	\N	2640
2417	1	31359	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:22.457132+00	\N	2641
2418	1	31363	1	t	LOCALCIRCLE	\N	14-10-2010	\N	2010-12-02 17:08:22.457524+00	\N	2642
2419	1	31367	1	t	LOCALCIRCLE	\N	23-06-2010	\N	2010-12-02 17:08:22.457913+00	\N	2643
2420	1	31368	1	t	LOCALCIRCLE	\N	14-10-2010	\N	2010-12-02 17:08:22.458289+00	\N	2644
2421	1	31400	1	t	LOCALCIRCLE	\N	18-09-2010	\N	2010-12-02 17:08:22.458676+00	\N	2645
2422	1	31407	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.459064+00	\N	2646
2423	1	31409	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.459453+00	\N	2647
2424	1	31412	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.459833+00	\N	2648
2425	1	31413	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.460213+00	\N	2649
2426	1	31415	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:22.460605+00	\N	2650
2427	1	31416	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.460994+00	\N	2651
2428	1	31420	1	t	LOCALCIRCLE	\N	28-10-2010	\N	2010-12-02 17:08:22.461371+00	\N	2652
2429	1	31421	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.465449+00	\N	2653
2430	1	31422	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.465827+00	\N	2654
2431	1	31423	1	t	LOCALCIRCLE	\N	04-11-2010	\N	2010-12-02 17:08:22.466216+00	\N	2655
2432	1	31426	1	t	LOCALCIRCLE	\N	04-11-2010	\N	2010-12-02 17:08:22.466614+00	\N	2656
2433	1	31427	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.467003+00	\N	2657
2434	1	31433	1	t	LOCALCIRCLE	\N	03-09-2010	\N	2010-12-02 17:08:22.467393+00	\N	2658
2435	1	31435	1	t	LOCALCIRCLE	\N	14-10-2010	\N	2010-12-02 17:08:22.467772+00	\N	2659
2436	1	31437	1	t	LOCALCIRCLE	\N	03-09-2010	\N	2010-12-02 17:08:22.468153+00	\N	2660
2437	1	31441	1	t	LOCALCIRCLE	\N	14-10-2010	\N	2010-12-02 17:08:22.468542+00	\N	2661
2438	1	31442	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.468918+00	\N	2662
2439	1	31453	1	t	LOCALCIRCLE	\N	08-11-2010	\N	2010-12-02 17:08:22.469299+00	\N	2663
2440	1	31459	1	t	LOCALCIRCLE	\N	18-09-2010	\N	2010-12-02 17:08:22.46979+00	\N	2664
2441	1	31467	1	t	LOCALCIRCLE	\N	04-11-2010	\N	2010-12-02 17:08:22.470175+00	\N	2665
2442	1	31477	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.470564+00	\N	2666
2443	1	31478	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.470941+00	\N	2667
2444	1	31479	1	t	LOCALCIRCLE	\N	09-09-2010	\N	2010-12-02 17:08:22.471321+00	\N	2668
2445	1	31488	1	t	LOCALCIRCLE	\N	18-09-2010	\N	2010-12-02 17:08:22.471934+00	\N	2669
2446	1	31511	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.47232+00	\N	2670
2447	1	31512	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.472709+00	\N	2671
2448	1	31513	1	t	LOCALCIRCLE	\N	27-10-2010	\N	2010-12-02 17:08:22.473085+00	\N	2672
2449	1	31526	1	t	LOCALCIRCLE	\N	14-10-2010	\N	2010-12-02 17:08:22.473465+00	\N	2673
2450	1	31530	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:22.473854+00	\N	2674
2451	1	31543	1	t	LOCALCIRCLE	\N	24-06-2010	\N	2010-12-02 17:08:22.474231+00	\N	2675
2452	1	33546	1	t	LOCALCIRCLE	\N	29-07-2010	\N	2010-12-02 17:08:22.474643+00	\N	2676
2453	1	33586	1	t	LOCALCIRCLE	\N	18-08-2010	\N	2010-12-02 17:08:22.482199+00	\N	2677
2454	1	33595	1	t	LOCALCIRCLE	\N	23-10-2010	\N	2010-12-02 17:08:22.482585+00	\N	2678
2455	1	33599	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.482973+00	\N	2679
2456	1	33603	1	t	LOCALCIRCLE	\N	19-08-2010	\N	2010-12-02 17:08:22.48335+00	\N	2680
2457	1	33605	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.483732+00	\N	2681
2458	1	33608	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.484122+00	\N	2682
2459	1	33610	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.484514+00	\N	2683
2460	1	33611	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.484904+00	\N	2684
2461	1	33617	1	t	LOCALCIRCLE	\N	23-10-2010	\N	2010-12-02 17:08:22.48528+00	\N	2685
2462	1	33618	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.485664+00	\N	2686
2463	1	33622	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:22.486053+00	\N	2687
2464	1	33625	1	t	LOCALCIRCLE	\N	23-10-2010	\N	2010-12-02 17:08:22.486429+00	\N	2688
2465	1	33626	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.490509+00	\N	2689
2466	1	33628	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:22.490885+00	\N	2690
2467	1	33629	1	t	LOCALCIRCLE	\N	24-09-2010	\N	2010-12-02 17:08:22.491276+00	\N	2691
2468	1	33630	1	t	LOCALCIRCLE	\N	27-09-2010	\N	2010-12-02 17:08:22.49167+00	\N	2692
2469	1	33631	1	t	LOCALCIRCLE	\N	27-09-2010	\N	2010-12-02 17:08:22.492063+00	\N	2693
2470	1	33632	1	t	LOCALCIRCLE	\N	27-09-2010	\N	2010-12-02 17:08:22.492458+00	\N	2694
2471	1	33644	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:22.492847+00	\N	2695
2472	1	33649	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.493237+00	\N	2696
2473	1	33650	1	t	LOCALCIRCLE	\N	23-10-2010	\N	2010-12-02 17:08:22.493629+00	\N	2697
2474	1	33652	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.494006+00	\N	2698
2475	1	33654	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.494388+00	\N	2699
2476	1	33655	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.494853+00	\N	2700
2477	1	33656	1	t	LOCALCIRCLE	\N	23-10-2010	\N	2010-12-02 17:08:22.495233+00	\N	2701
2478	1	33660	1	t	LOCALCIRCLE	\N	23-10-2010	\N	2010-12-02 17:08:22.495628+00	\N	2702
2479	1	33663	1	t	LOCALCIRCLE	\N	23-10-2010	\N	2010-12-02 17:08:22.49602+00	\N	2703
2480	1	33667	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.496412+00	\N	2704
2481	1	33668	1	t	LOCALCIRCLE	\N	27-09-2010	\N	2010-12-02 17:08:22.497023+00	\N	2705
2482	1	33671	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.497407+00	\N	2706
2483	1	33674	1	t	LOCALCIRCLE	\N	24-09-2010	\N	2010-12-02 17:08:22.497798+00	\N	2707
2484	1	33675	1	t	LOCALCIRCLE	\N	23-10-2010	\N	2010-12-02 17:08:22.49819+00	\N	2708
2485	1	33678	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.498581+00	\N	2709
2486	1	33682	1	t	LOCALCIRCLE	\N	23-10-2010	\N	2010-12-02 17:08:22.498959+00	\N	2710
2487	1	33700	1	t	LOCALCIRCLE	\N	23-10-2010	\N	2010-12-02 17:08:22.499338+00	\N	2711
2488	1	33719	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:22.499838+00	\N	2712
2489	1	33722	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.500218+00	\N	2713
2490	1	33723	1	t	LOCALCIRCLE	\N	07-09-2010	\N	2010-12-02 17:08:22.500609+00	\N	2714
2491	1	33724	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.500999+00	\N	2715
2492	1	33726	1	t	LOCALCIRCLE	\N	17-09-2010	\N	2010-12-02 17:08:22.501391+00	\N	2716
2493	1	33727	1	t	LOCALCIRCLE	\N	07-09-2010	\N	2010-12-02 17:08:22.501781+00	\N	2717
2494	1	33728	1	t	LOCALCIRCLE	\N	17-09-2010	\N	2010-12-02 17:08:22.502163+00	\N	2718
2495	1	33805	1	t	LOCALCIRCLE	\N	26-08-2010	\N	2010-12-02 17:08:22.502542+00	\N	2719
2496	1	33809	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:22.502932+00	\N	2720
2497	1	33830	1	t	LOCALCIRCLE	\N	31-08-2010	\N	2010-12-02 17:08:22.503324+00	\N	2721
2498	1	33832	1	t	LOCALCIRCLE	\N	03-11-2010	\N	2010-12-02 17:08:22.503718+00	\N	2722
2499	1	33856	1	t	LOCALCIRCLE	\N	03-11-2010	\N	2010-12-02 17:08:22.50411+00	\N	2723
2500	1	33865	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:22.504502+00	\N	2724
2501	1	33882	1	t	LOCALCIRCLE	\N	04-11-2010	\N	2010-12-02 17:08:22.507246+00	\N	2725
2502	1	33885	1	t	LOCALCIRCLE	\N	03-11-2010	\N	2010-12-02 17:08:22.507642+00	\N	2726
2503	1	33886	1	t	LOCALCIRCLE	\N	04-11-2010	\N	2010-12-02 17:08:22.508037+00	\N	2727
2504	1	33893	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:22.508436+00	\N	2728
2505	1	33894	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:22.50882+00	\N	2729
2506	1	33897	1	t	LOCALCIRCLE	\N	22-07-2010	\N	2010-12-02 17:08:22.509211+00	\N	2730
2507	1	33918	1	t	LOCALCIRCLE	\N	08-11-2010	\N	2010-12-02 17:08:22.509603+00	\N	2731
2508	1	33921	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.509994+00	\N	2732
2509	1	33945	1	t	LOCALCIRCLE	\N	27-10-2010	\N	2010-12-02 17:08:22.510386+00	\N	2733
2510	1	33961	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.510779+00	\N	2734
2511	1	33986	1	t	LOCALCIRCLE	\N	27-10-2010	\N	2010-12-02 17:08:22.51117+00	\N	2735
2512	1	33993	1	t	LOCALCIRCLE	\N	08-11-2010	\N	2010-12-02 17:08:22.511593+00	\N	2736
2513	1	33995	1	t	LOCALCIRCLE	\N	08-11-2010	\N	2010-12-02 17:08:22.515567+00	\N	2737
2514	1	33997	1	t	LOCALCIRCLE	\N	08-11-2010	\N	2010-12-02 17:08:22.515974+00	\N	2738
2515	1	33999	1	t	LOCALCIRCLE	\N	18-09-2010	\N	2010-12-02 17:08:22.5164+00	\N	2739
2516	1	34000	1	t	LOCALCIRCLE	\N	08-11-2010	\N	2010-12-02 17:08:22.51679+00	\N	2740
2517	1	34001	1	t	LOCALCIRCLE	\N	08-11-2010	\N	2010-12-02 17:08:22.517182+00	\N	2741
2518	1	34002	1	t	LOCALCIRCLE	\N	08-11-2010	\N	2010-12-02 17:08:22.517794+00	\N	2742
2519	1	34009	1	t	LOCALCIRCLE	\N	18-10-2010	\N	2010-12-02 17:08:22.518177+00	\N	2743
2520	1	34010	1	t	LOCALCIRCLE	\N	18-10-2010	\N	2010-12-02 17:08:22.518569+00	\N	2744
2521	1	34014	1	t	LOCALCIRCLE	\N	06-07-2010	\N	2010-12-02 17:08:22.51896+00	\N	2745
2522	1	34021	1	t	LOCALCIRCLE	\N	25-10-2010	\N	2010-12-02 17:08:22.519337+00	\N	2746
2523	1	34023	1	t	LOCALCIRCLE	\N	26-10-2010	\N	2010-12-02 17:08:22.519844+00	\N	2747
2524	1	34024	1	t	LOCALCIRCLE	\N	26-10-2010	\N	2010-12-02 17:08:22.520233+00	\N	2748
2525	1	34028	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.520624+00	\N	2749
2526	1	34033	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.521018+00	\N	2750
2527	1	34037	1	t	LOCALCIRCLE	\N	20-09-2010	\N	2010-12-02 17:08:22.521406+00	\N	2751
2528	1	34038	1	t	LOCALCIRCLE	\N	26-10-2010	\N	2010-12-02 17:08:22.521783+00	\N	2752
2529	1	34040	1	t	LOCALCIRCLE	\N	26-10-2010	\N	2010-12-02 17:08:22.522162+00	\N	2753
2530	1	34042	1	t	LOCALCIRCLE	\N	20-09-2010	\N	2010-12-02 17:08:22.522552+00	\N	2754
2531	1	34043	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.522928+00	\N	2755
2532	1	34046	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.52331+00	\N	2756
2533	1	34049	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.523703+00	\N	2757
2534	1	34054	1	t	LOCALCIRCLE	\N	17-09-2010	\N	2010-12-02 17:08:22.524098+00	\N	2758
2535	1	34055	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:22.524497+00	\N	2759
2536	1	34057	1	t	LOCALCIRCLE	\N	17-09-2010	\N	2010-12-02 17:08:22.532308+00	\N	2760
2537	1	34058	1	t	LOCALCIRCLE	\N	25-08-2010	\N	2010-12-02 17:08:22.532727+00	\N	2761
2538	1	34059	1	t	LOCALCIRCLE	\N	04-11-2010	\N	2010-12-02 17:08:22.533103+00	\N	2762
2539	1	34064	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.533484+00	\N	2763
2540	1	34066	1	t	LOCALCIRCLE	\N	29-09-2010	\N	2010-12-02 17:08:22.533874+00	\N	2764
2541	1	34068	1	t	LOCALCIRCLE	\N	23-09-2010	\N	2010-12-02 17:08:22.53425+00	\N	2765
2542	1	34070	1	t	LOCALCIRCLE	\N	27-10-2010	\N	2010-12-02 17:08:22.534634+00	\N	2766
2543	1	34074	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.535024+00	\N	2767
2544	1	34075	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.53546+00	\N	2768
2545	1	34076	1	t	LOCALCIRCLE	\N	20-10-2010	\N	2010-12-02 17:08:22.535842+00	\N	2769
2546	1	34077	1	t	LOCALCIRCLE	\N	01-07-2010	\N	2010-12-02 17:08:22.536234+00	\N	2770
2547	1	34078	1	t	LOCALCIRCLE	\N	04-11-2010	\N	2010-12-02 17:08:22.536634+00	\N	2771
2548	1	34079	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.540625+00	\N	2772
2549	1	34101	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.541002+00	\N	2773
2550	1	34104	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.541391+00	\N	2774
2551	1	34105	1	t	LOCALCIRCLE	\N	04-11-2010	\N	2010-12-02 17:08:22.542007+00	\N	2775
2552	1	34106	1	t	LOCALCIRCLE	\N	29-09-2010	\N	2010-12-02 17:08:22.542391+00	\N	2776
2553	1	34108	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.542782+00	\N	2777
2554	1	34109	1	t	LOCALCIRCLE	\N	29-09-2010	\N	2010-12-02 17:08:22.543174+00	\N	2778
2555	1	34110	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.543565+00	\N	2779
2556	1	34111	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.543963+00	\N	2780
2557	1	34145	1	t	LOCALCIRCLE	\N	17-08-2010	\N	2010-12-02 17:08:22.544359+00	\N	2781
2558	1	34148	1	t	LOCALCIRCLE	\N	14-10-2010	\N	2010-12-02 17:08:22.54487+00	\N	2782
2559	1	34154	1	t	LOCALCIRCLE	\N	02-11-2010	\N	2010-12-02 17:08:22.545259+00	\N	2783
2560	1	34155	1	t	LOCALCIRCLE	\N	27-09-2010	\N	2010-12-02 17:08:22.545653+00	\N	2784
2561	1	34157	1	t	LOCALCIRCLE	\N	29-09-2010	\N	2010-12-02 17:08:22.546044+00	\N	2785
2562	1	34158	1	t	LOCALCIRCLE	\N	20-09-2010	\N	2010-12-02 17:08:22.546435+00	\N	2786
2563	1	35111	1	t	LOCALCIRCLE	\N	20-09-2010	\N	2010-12-02 17:08:22.546829+00	\N	2787
2564	1	32006	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.547221+00	\N	2788
2565	1	32007	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.547614+00	\N	2789
2566	1	32008	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.548007+00	\N	2790
2567	1	32012	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.5484+00	\N	2791
2568	1	32019	1	t	LOCALCIRCLE	\N	29-10-2010	\N	2010-12-02 17:08:22.548789+00	\N	2792
2569	1	32021	1	t	LOCALCIRCLE	\N	29-10-2010	\N	2010-12-02 17:08:22.549183+00	\N	2793
2570	1	32023	1	t	LOCALCIRCLE	\N	29-10-2010	\N	2010-12-02 17:08:22.549574+00	\N	2794
2571	1	32025	1	t	LOCALCIRCLE	\N	10-11-2010	\N	2010-12-02 17:08:22.557368+00	\N	2795
2572	1	32027	1	t	LOCALCIRCLE	\N	10-11-2010	\N	2010-12-02 17:08:22.557771+00	\N	2796
2573	1	32030	1	t	LOCALCIRCLE	\N	30-10-2010	\N	2010-12-02 17:08:22.558151+00	\N	2797
2574	1	32033	1	t	LOCALCIRCLE	\N	30-10-2010	\N	2010-12-02 17:08:22.558542+00	\N	2798
2575	1	32034	1	t	LOCALCIRCLE	\N	30-10-2010	\N	2010-12-02 17:08:22.558937+00	\N	2799
2576	1	32035	1	t	LOCALCIRCLE	\N	30-10-2010	\N	2010-12-02 17:08:22.559328+00	\N	2800
2577	1	32055	1	t	LOCALCIRCLE	\N	09-07-2010	\N	2010-12-02 17:08:22.559724+00	\N	2801
2578	1	32068	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.560115+00	\N	2802
2579	1	32069	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.560506+00	\N	2803
2580	1	32070	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.560897+00	\N	2804
2581	1	32071	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.561289+00	\N	2805
2582	1	32072	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.561712+00	\N	2806
2583	1	32073	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.565699+00	\N	2807
2584	1	32074	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.566104+00	\N	2808
2585	1	32075	1	t	LOCALCIRCLE	\N	17-09-2010	\N	2010-12-02 17:08:22.566483+00	\N	2809
2586	1	32104	1	t	LOCALCIRCLE	\N	25-10-2010	\N	2010-12-02 17:08:22.566874+00	\N	2810
2587	1	32124	1	t	LOCALCIRCLE	\N	10-08-2010	\N	2010-12-02 17:08:22.567488+00	\N	2811
2588	1	32127	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.567875+00	\N	2812
2589	1	32137	1	t	LOCALCIRCLE	\N	28-09-2010	\N	2010-12-02 17:08:22.568266+00	\N	2813
2590	1	32140	1	t	LOCALCIRCLE	\N	28-09-2010	\N	2010-12-02 17:08:22.568656+00	\N	2814
2591	1	32141	1	t	LOCALCIRCLE	\N	28-09-2010	\N	2010-12-02 17:08:22.569046+00	\N	2815
2592	1	32144	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.569423+00	\N	2816
2593	1	32145	1	t	LOCALCIRCLE	\N	29-09-2010	\N	2010-12-02 17:08:22.569898+00	\N	2817
2594	1	32147	1	t	LOCALCIRCLE	\N	29-09-2010	\N	2010-12-02 17:08:22.570287+00	\N	2818
2595	1	32148	1	t	LOCALCIRCLE	\N	29-09-2010	\N	2010-12-02 17:08:22.570678+00	\N	2819
2596	1	32149	1	t	LOCALCIRCLE	\N	07-09-2010	\N	2010-12-02 17:08:22.571055+00	\N	2820
2597	1	32151	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:22.571434+00	\N	2821
2598	1	32152	1	t	LOCALCIRCLE	\N	07-09-2010	\N	2010-12-02 17:08:22.571828+00	\N	2822
2599	1	32155	1	t	LOCALCIRCLE	\N	21-07-2010	\N	2010-12-02 17:08:22.572219+00	\N	2823
2600	1	32161	1	t	LOCALCIRCLE	\N	07-08-2010	\N	2010-12-02 17:08:22.572608+00	\N	2824
2601	1	32166	1	t	LOCALCIRCLE	\N	10-11-2010	\N	2010-12-02 17:08:22.572985+00	\N	2825
2602	1	32167	1	t	LOCALCIRCLE	\N	30-10-2010	\N	2010-12-02 17:08:22.573366+00	\N	2826
2603	1	32168	1	t	LOCALCIRCLE	\N	30-10-2010	\N	2010-12-02 17:08:22.573756+00	\N	2827
2604	1	32172	1	t	LOCALCIRCLE	\N	31-08-2010	\N	2010-12-02 17:08:22.574132+00	\N	2828
2605	1	32173	1	t	LOCALCIRCLE	\N	30-10-2010	\N	2010-12-02 17:08:22.574513+00	\N	2829
2606	1	32175	1	t	LOCALCIRCLE	\N	30-10-2010	\N	2010-12-02 17:08:22.582425+00	\N	2830
2607	1	32176	1	t	LOCALCIRCLE	\N	31-08-2010	\N	2010-12-02 17:08:22.582824+00	\N	2831
2608	1	32178	1	t	LOCALCIRCLE	\N	31-08-2010	\N	2010-12-02 17:08:22.583209+00	\N	2832
2609	1	32182	1	t	LOCALCIRCLE	\N	31-08-2010	\N	2010-12-02 17:08:22.583601+00	\N	2833
2610	1	32202	1	t	LOCALCIRCLE	\N	17-09-2010	\N	2010-12-02 17:08:22.583996+00	\N	2834
2611	1	32203	1	t	LOCALCIRCLE	\N	14-10-2010	\N	2010-12-02 17:08:22.584388+00	\N	2835
2612	1	32204	1	t	LOCALCIRCLE	\N	14-10-2010	\N	2010-12-02 17:08:22.584777+00	\N	2836
2613	1	32205	1	t	LOCALCIRCLE	\N	25-10-2010	\N	2010-12-02 17:08:22.585168+00	\N	2837
2614	1	32209	1	t	LOCALCIRCLE	\N	17-09-2010	\N	2010-12-02 17:08:22.585545+00	\N	2838
2615	1	32211	1	t	LOCALCIRCLE	\N	25-10-2010	\N	2010-12-02 17:08:22.585929+00	\N	2839
2616	1	32212	1	t	LOCALCIRCLE	\N	17-09-2010	\N	2010-12-02 17:08:22.586318+00	\N	2840
2617	1	32213	1	t	LOCALCIRCLE	\N	25-10-2010	\N	2010-12-02 17:08:22.586738+00	\N	2841
2618	1	32214	1	t	LOCALCIRCLE	\N	17-09-2010	\N	2010-12-02 17:08:22.590755+00	\N	2842
2619	1	32215	1	t	LOCALCIRCLE	\N	17-09-2010	\N	2010-12-02 17:08:22.591161+00	\N	2843
2620	1	32256	1	t	LOCALCIRCLE	\N	09-09-2010	\N	2010-12-02 17:08:22.591542+00	\N	2844
2621	1	32257	1	t	LOCALCIRCLE	\N	09-09-2010	\N	2010-12-02 17:08:22.591935+00	\N	2845
2622	1	32260	1	t	LOCALCIRCLE	\N	30-08-2010	\N	2010-12-02 17:08:22.592328+00	\N	2846
2623	1	32270	1	t	LOCALCIRCLE	\N	29-10-2010	\N	2010-12-02 17:08:22.59272+00	\N	2847
2624	1	32275	1	t	LOCALCIRCLE	\N	29-10-2010	\N	2010-12-02 17:08:22.593331+00	\N	2848
2625	1	32276	1	t	LOCALCIRCLE	\N	29-10-2010	\N	2010-12-02 17:08:22.593718+00	\N	2849
2626	1	32300	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:22.594107+00	\N	2850
2627	1	32301	1	t	LOCALCIRCLE	\N	23-07-2010	\N	2010-12-02 17:08:22.594497+00	\N	2851
2628	1	32305	1	t	LOCALCIRCLE	\N	04-10-2010	\N	2010-12-02 17:08:22.594958+00	\N	2852
2629	1	32307	1	t	LOCALCIRCLE	\N	04-10-2010	\N	2010-12-02 17:08:22.595346+00	\N	2853
2630	1	32308	1	t	LOCALCIRCLE	\N	04-10-2010	\N	2010-12-02 17:08:22.595741+00	\N	2854
2631	1	32309	1	t	LOCALCIRCLE	\N	17-09-2010	\N	2010-12-02 17:08:22.596133+00	\N	2855
2632	1	32310	1	t	LOCALCIRCLE	\N	04-10-2010	\N	2010-12-02 17:08:22.596522+00	\N	2856
2633	1	32311	1	t	LOCALCIRCLE	\N	04-10-2010	\N	2010-12-02 17:08:22.596911+00	\N	2857
2634	1	32312	1	t	LOCALCIRCLE	\N	04-10-2010	\N	2010-12-02 17:08:22.597288+00	\N	2858
2635	1	32313	1	t	LOCALCIRCLE	\N	04-10-2010	\N	2010-12-02 17:08:22.597706+00	\N	2859
2636	1	32314	1	t	LOCALCIRCLE	\N	04-10-2010	\N	2010-12-02 17:08:22.598093+00	\N	2860
2637	1	32316	1	t	LOCALCIRCLE	\N	04-10-2010	\N	2010-12-02 17:08:22.598484+00	\N	2861
2638	1	32321	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.598877+00	\N	2862
2639	1	32322	1	t	LOCALCIRCLE	\N	27-09-2010	\N	2010-12-02 17:08:22.599267+00	\N	2863
2640	1	32323	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.599676+00	\N	2864
2641	1	32325	1	t	LOCALCIRCLE	\N	27-09-2010	\N	2010-12-02 17:08:22.607484+00	\N	2865
2642	1	32326	1	t	LOCALCIRCLE	\N	23-10-2010	\N	2010-12-02 17:08:22.607878+00	\N	2866
2643	1	32328	1	t	LOCALCIRCLE	\N	27-09-2010	\N	2010-12-02 17:08:22.608269+00	\N	2867
2644	1	32329	1	t	LOCALCIRCLE	\N	27-09-2010	\N	2010-12-02 17:08:22.608662+00	\N	2868
2645	1	32330	1	t	LOCALCIRCLE	\N	27-09-2010	\N	2010-12-02 17:08:22.609052+00	\N	2869
2646	1	32331	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.609441+00	\N	2870
2647	1	32332	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.609818+00	\N	2871
2648	1	32333	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.610199+00	\N	2872
2649	1	32335	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.610593+00	\N	2873
2650	1	32336	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.610983+00	\N	2874
2651	1	32338	1	t	LOCALCIRCLE	\N	28-09-2010	\N	2010-12-02 17:08:22.61136+00	\N	2875
2652	1	32344	1	t	LOCALCIRCLE	\N	28-09-2010	\N	2010-12-02 17:08:22.611773+00	\N	2876
2653	1	32345	1	t	LOCALCIRCLE	\N	14-09-2010	\N	2010-12-02 17:08:22.615815+00	\N	2877
2654	1	32346	1	t	LOCALCIRCLE	\N	18-09-2010	\N	2010-12-02 17:08:22.616208+00	\N	2878
2655	1	32347	1	t	LOCALCIRCLE	\N	14-09-2010	\N	2010-12-02 17:08:22.616598+00	\N	2879
2656	1	32356	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.616991+00	\N	2880
2657	1	32357	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.617382+00	\N	2881
2658	1	32361	1	t	LOCALCIRCLE	\N	09-09-2010	\N	2010-12-02 17:08:22.617774+00	\N	2882
2659	1	32362	1	t	LOCALCIRCLE	\N	14-09-2010	\N	2010-12-02 17:08:22.618151+00	\N	2883
2660	1	32363	1	t	LOCALCIRCLE	\N	14-09-2010	\N	2010-12-02 17:08:22.618752+00	\N	2884
2661	1	32364	1	t	LOCALCIRCLE	\N	14-09-2010	\N	2010-12-02 17:08:22.619136+00	\N	2885
2662	1	32365	1	t	LOCALCIRCLE	\N	14-09-2010	\N	2010-12-02 17:08:22.619526+00	\N	2886
2663	1	32366	1	t	LOCALCIRCLE	\N	14-09-2010	\N	2010-12-02 17:08:22.61992+00	\N	2887
2664	1	32367	1	t	LOCALCIRCLE	\N	14-09-2010	\N	2010-12-02 17:08:22.620312+00	\N	2888
2665	1	32390	1	t	LOCALCIRCLE	\N	14-10-2010	\N	2010-12-02 17:08:22.620713+00	\N	2889
2666	1	32398	1	t	LOCALCIRCLE	\N	14-10-2010	\N	2010-12-02 17:08:22.624209+00	\N	2890
2667	1	32437	1	t	LOCALCIRCLE	\N	12-08-2010	\N	2010-12-02 17:08:22.624599+00	\N	2891
2668	1	32449	1	t	LOCALCIRCLE	\N	04-11-2010	\N	2010-12-02 17:08:22.624989+00	\N	2892
2669	1	32465	1	t	LOCALCIRCLE	\N	08-09-2010	\N	2010-12-02 17:08:22.625366+00	\N	2893
2670	1	32466	1	t	LOCALCIRCLE	\N	08-09-2010	\N	2010-12-02 17:08:22.62575+00	\N	2894
2671	1	32467	1	t	LOCALCIRCLE	\N	08-09-2010	\N	2010-12-02 17:08:22.626143+00	\N	2895
2672	1	32468	1	t	LOCALCIRCLE	\N	18-09-2010	\N	2010-12-02 17:08:22.626533+00	\N	2896
2673	1	32469	1	t	LOCALCIRCLE	\N	20-09-2010	\N	2010-12-02 17:08:22.626922+00	\N	2897
2674	1	32470	1	t	LOCALCIRCLE	\N	14-09-2010	\N	2010-12-02 17:08:22.627298+00	\N	2898
2675	1	32471	1	t	LOCALCIRCLE	\N	14-09-2010	\N	2010-12-02 17:08:22.627684+00	\N	2899
2676	1	32472	1	t	LOCALCIRCLE	\N	14-09-2010	\N	2010-12-02 17:08:22.628075+00	\N	2900
2677	1	32473	1	t	LOCALCIRCLE	\N	14-09-2010	\N	2010-12-02 17:08:22.628467+00	\N	2901
2678	1	32474	1	t	LOCALCIRCLE	\N	03-11-2010	\N	2010-12-02 17:08:22.62896+00	\N	2902
2679	1	32477	1	t	LOCALCIRCLE	\N	03-11-2010	\N	2010-12-02 17:08:22.629341+00	\N	2903
2680	1	32481	1	t	LOCALCIRCLE	\N	26-08-2010	\N	2010-12-02 17:08:22.629732+00	\N	2904
2681	1	32495	1	t	LOCALCIRCLE	\N	26-10-2010	\N	2010-12-02 17:08:22.630122+00	\N	2905
2682	1	32501	1	t	LOCALCIRCLE	\N	26-10-2010	\N	2010-12-02 17:08:22.630499+00	\N	2906
2683	1	32504	1	t	LOCALCIRCLE	\N	04-11-2010	\N	2010-12-02 17:08:22.63088+00	\N	2907
2684	1	32505	1	t	LOCALCIRCLE	\N	04-11-2010	\N	2010-12-02 17:08:22.63127+00	\N	2908
2685	1	32506	1	t	LOCALCIRCLE	\N	04-11-2010	\N	2010-12-02 17:08:22.63165+00	\N	2909
2686	1	32507	1	t	LOCALCIRCLE	\N	25-10-2010	\N	2010-12-02 17:08:22.632054+00	\N	2910
2687	1	32550	1	t	LOCALCIRCLE	\N	20-10-2010	\N	2010-12-02 17:08:22.632434+00	\N	2911
2688	1	32551	1	t	LOCALCIRCLE	\N	20-10-2010	\N	2010-12-02 17:08:22.632818+00	\N	2912
2689	1	32552	1	t	LOCALCIRCLE	\N	29-09-2010	\N	2010-12-02 17:08:22.633206+00	\N	2913
2690	1	32555	1	t	LOCALCIRCLE	\N	20-10-2010	\N	2010-12-02 17:08:22.633595+00	\N	2914
2691	1	32556	1	t	LOCALCIRCLE	\N	29-09-2010	\N	2010-12-02 17:08:22.640874+00	\N	2915
2692	1	32557	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.641265+00	\N	2916
2693	1	32558	1	t	LOCALCIRCLE	\N	20-10-2010	\N	2010-12-02 17:08:22.641659+00	\N	2917
2694	1	32559	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.642049+00	\N	2918
2695	1	32561	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.64244+00	\N	2919
2696	1	32562	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.64282+00	\N	2920
2697	1	32563	1	t	LOCALCIRCLE	\N	08-09-2010	\N	2010-12-02 17:08:22.643418+00	\N	2921
2698	1	32564	1	t	LOCALCIRCLE	\N	20-09-2010	\N	2010-12-02 17:08:22.643806+00	\N	2922
2699	1	32565	1	t	LOCALCIRCLE	\N	10-09-2010	\N	2010-12-02 17:08:22.644197+00	\N	2923
2700	1	32566	1	t	LOCALCIRCLE	\N	10-09-2010	\N	2010-12-02 17:08:22.644587+00	\N	2924
2701	1	32567	1	t	LOCALCIRCLE	\N	10-09-2010	\N	2010-12-02 17:08:22.644977+00	\N	2925
2702	1	32568	1	t	LOCALCIRCLE	\N	08-09-2010	\N	2010-12-02 17:08:22.645353+00	\N	2926
2703	1	32574	1	t	LOCALCIRCLE	\N	27-09-2010	\N	2010-12-02 17:08:22.645739+00	\N	2927
2704	1	32589	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.649267+00	\N	2928
2705	1	32599	1	t	LOCALCIRCLE	\N	04-11-2010	\N	2010-12-02 17:08:22.649657+00	\N	2929
2706	1	32602	1	t	LOCALCIRCLE	\N	04-11-2010	\N	2010-12-02 17:08:22.650048+00	\N	2930
2707	1	32605	1	t	LOCALCIRCLE	\N	16-07-2010	\N	2010-12-02 17:08:22.650426+00	\N	2931
2708	1	32606	1	t	LOCALCIRCLE	\N	16-09-2010	\N	2010-12-02 17:08:22.650814+00	\N	2932
2709	1	32607	1	t	LOCALCIRCLE	\N	16-09-2010	\N	2010-12-02 17:08:22.651199+00	\N	2933
2710	1	32608	1	t	LOCALCIRCLE	\N	25-10-2010	\N	2010-12-02 17:08:22.651589+00	\N	2934
2711	1	32609	1	t	LOCALCIRCLE	\N	25-10-2010	\N	2010-12-02 17:08:22.651986+00	\N	2935
2712	1	32610	1	t	LOCALCIRCLE	\N	25-10-2010	\N	2010-12-02 17:08:22.652378+00	\N	2936
2713	1	32611	1	t	LOCALCIRCLE	\N	25-10-2010	\N	2010-12-02 17:08:22.65277+00	\N	2937
2714	1	32612	1	t	LOCALCIRCLE	\N	25-10-2010	\N	2010-12-02 17:08:22.653159+00	\N	2938
2715	1	32613	1	t	LOCALCIRCLE	\N	25-10-2010	\N	2010-12-02 17:08:22.653549+00	\N	2939
2716	1	32616	1	t	LOCALCIRCLE	\N	27-10-2010	\N	2010-12-02 17:08:22.654012+00	\N	2940
2717	1	32619	1	t	LOCALCIRCLE	\N	27-10-2010	\N	2010-12-02 17:08:22.654399+00	\N	2941
2718	1	32620	1	t	LOCALCIRCLE	\N	27-10-2010	\N	2010-12-02 17:08:22.654792+00	\N	2942
2719	1	32621	1	t	LOCALCIRCLE	\N	27-10-2010	\N	2010-12-02 17:08:22.655182+00	\N	2943
2720	1	32625	1	t	LOCALCIRCLE	\N	27-10-2010	\N	2010-12-02 17:08:22.655572+00	\N	2944
2721	1	32631	1	t	LOCALCIRCLE	\N	27-10-2010	\N	2010-12-02 17:08:22.655971+00	\N	2945
2722	1	32648	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.656363+00	\N	2946
2723	1	32650	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.656755+00	\N	2947
2724	1	32651	1	t	LOCALCIRCLE	\N	09-08-2010	\N	2010-12-02 17:08:22.657144+00	\N	2948
2725	1	32662	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.65752+00	\N	2949
2726	1	32664	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.657901+00	\N	2950
2727	1	32665	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.65829+00	\N	2951
2728	1	32669	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.658667+00	\N	2952
2729	1	32670	1	t	LOCALCIRCLE	\N	04-09-2010	\N	2010-12-02 17:08:22.665918+00	\N	2953
2730	1	32673	1	t	LOCALCIRCLE	\N	05-08-2010	\N	2010-12-02 17:08:22.666295+00	\N	2954
2731	1	32674	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.666684+00	\N	2955
2732	1	32675	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.667061+00	\N	2956
2733	1	32678	1	t	LOCALCIRCLE	\N	18-10-2010	\N	2010-12-02 17:08:22.667694+00	\N	2957
2734	1	32680	1	t	LOCALCIRCLE	\N	18-10-2010	\N	2010-12-02 17:08:22.668087+00	\N	2958
2735	1	32685	1	t	LOCALCIRCLE	\N	18-10-2010	\N	2010-12-02 17:08:22.66847+00	\N	2959
2736	1	32687	1	t	LOCALCIRCLE	\N	18-10-2010	\N	2010-12-02 17:08:22.668859+00	\N	2960
2737	1	32689	1	t	LOCALCIRCLE	\N	17-09-2010	\N	2010-12-02 17:08:22.669251+00	\N	2961
2738	1	32690	1	t	LOCALCIRCLE	\N	17-09-2010	\N	2010-12-02 17:08:22.669627+00	\N	2962
2739	1	32691	1	t	LOCALCIRCLE	\N	17-09-2010	\N	2010-12-02 17:08:22.670007+00	\N	2963
2740	1	32693	1	t	LOCALCIRCLE	\N	17-09-2010	\N	2010-12-02 17:08:22.670396+00	\N	2964
2741	1	32694	1	t	LOCALCIRCLE	\N	17-09-2010	\N	2010-12-02 17:08:22.670804+00	\N	2965
2742	1	32695	1	t	LOCALCIRCLE	\N	28-10-2010	\N	2010-12-02 17:08:22.674325+00	\N	2966
2743	1	32696	1	t	LOCALCIRCLE	\N	17-09-2010	\N	2010-12-02 17:08:22.674717+00	\N	2967
2744	1	32697	1	t	LOCALCIRCLE	\N	28-10-2010	\N	2010-12-02 17:08:22.675107+00	\N	2968
2745	1	32698	1	t	LOCALCIRCLE	\N	28-10-2010	\N	2010-12-02 17:08:22.675484+00	\N	2969
2746	1	32699	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.675867+00	\N	2970
2747	1	32700	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.676258+00	\N	2971
2748	1	32703	1	t	LOCALCIRCLE	\N	23-10-2010	\N	2010-12-02 17:08:22.676647+00	\N	2972
2749	1	32705	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.677024+00	\N	2973
2750	1	32706	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.677404+00	\N	2974
2751	1	32707	1	t	LOCALCIRCLE	\N	23-10-2010	\N	2010-12-02 17:08:22.677795+00	\N	2975
2752	1	32708	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.678185+00	\N	2976
2753	1	32710	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.678561+00	\N	2977
2754	1	32731	1	t	LOCALCIRCLE	\N	19-06-2010	\N	2010-12-02 17:08:22.679013+00	\N	2978
2755	1	32739	1	t	LOCALCIRCLE	\N	23-09-2010	\N	2010-12-02 17:08:22.679427+00	\N	2979
2756	1	32741	1	t	LOCALCIRCLE	\N	23-09-2010	\N	2010-12-02 17:08:22.679823+00	\N	2980
2757	1	32742	1	t	LOCALCIRCLE	\N	23-09-2010	\N	2010-12-02 17:08:22.680214+00	\N	2981
2758	1	32743	1	t	LOCALCIRCLE	\N	23-09-2010	\N	2010-12-02 17:08:22.680608+00	\N	2982
2759	1	32744	1	t	LOCALCIRCLE	\N	23-09-2010	\N	2010-12-02 17:08:22.680997+00	\N	2983
2760	1	32745	1	t	LOCALCIRCLE	\N	23-09-2010	\N	2010-12-02 17:08:22.681386+00	\N	2984
2761	1	32746	1	t	LOCALCIRCLE	\N	23-09-2010	\N	2010-12-02 17:08:22.681778+00	\N	2985
2762	1	32768	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.682154+00	\N	2986
2763	1	32771	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.682536+00	\N	2987
2764	1	32772	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.682924+00	\N	2988
2765	1	32773	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.683301+00	\N	2989
2766	1	32779	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.683686+00	\N	2990
2767	1	32782	1	t	LOCALCIRCLE	\N	27-08-2010	\N	2010-12-02 17:08:22.690978+00	\N	2991
2768	1	32788	1	t	LOCALCIRCLE	\N	26-10-2010	\N	2010-12-02 17:08:22.691391+00	\N	2992
2769	1	32792	1	t	LOCALCIRCLE	\N	26-10-2010	\N	2010-12-02 17:08:22.691777+00	\N	2993
2770	1	32804	1	t	LOCALCIRCLE	\N	27-09-2010	\N	2010-12-02 17:08:22.692388+00	\N	2994
2771	1	32809	1	t	LOCALCIRCLE	\N	27-09-2010	\N	2010-12-02 17:08:22.692771+00	\N	2995
2772	1	32814	1	t	LOCALCIRCLE	\N	27-09-2010	\N	2010-12-02 17:08:22.69316+00	\N	2996
2773	1	32815	1	t	LOCALCIRCLE	\N	27-09-2010	\N	2010-12-02 17:08:22.693537+00	\N	2997
2774	1	32825	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.693918+00	\N	2998
2775	1	32827	1	t	LOCALCIRCLE	\N	10-09-2010	\N	2010-12-02 17:08:22.694308+00	\N	2999
2776	1	32828	1	t	LOCALCIRCLE	\N	13-09-2010	\N	2010-12-02 17:08:22.694684+00	\N	3000
2777	1	32829	1	t	LOCALCIRCLE	\N	10-09-2010	\N	2010-12-02 17:08:22.695069+00	\N	3001
2778	1	32830	1	t	LOCALCIRCLE	\N	10-09-2010	\N	2010-12-02 17:08:22.695458+00	\N	3002
2779	1	32852	1	t	LOCALCIRCLE	\N	07-07-2010	\N	2010-12-02 17:08:22.696002+00	\N	3003
2780	1	32889	1	t	LOCALCIRCLE	\N	31-08-2010	\N	2010-12-02 17:08:22.696394+00	\N	3004
2781	1	32928	1	t	LOCALCIRCLE	\N	23-09-2010	\N	2010-12-02 17:08:22.696784+00	\N	3005
2782	1	32971	1	t	LOCALCIRCLE	\N	13-09-2010	\N	2010-12-02 17:08:22.69716+00	\N	3006
2783	1	32972	1	t	LOCALCIRCLE	\N	13-09-2010	\N	2010-12-02 17:08:22.697541+00	\N	3007
2784	1	32973	1	t	LOCALCIRCLE	\N	13-09-2010	\N	2010-12-02 17:08:22.69793+00	\N	3008
2785	1	32974	1	t	LOCALCIRCLE	\N	13-09-2010	\N	2010-12-02 17:08:22.698306+00	\N	3009
2786	1	32975	1	t	LOCALCIRCLE	\N	03-09-2010	\N	2010-12-02 17:08:22.698689+00	\N	3010
2787	1	32976	1	t	LOCALCIRCLE	\N	03-09-2010	\N	2010-12-02 17:08:22.699078+00	\N	3011
2788	1	32977	1	t	LOCALCIRCLE	\N	13-09-2010	\N	2010-12-02 17:08:22.699479+00	\N	3012
2789	1	32978	1	t	LOCALCIRCLE	\N	03-09-2010	\N	2010-12-02 17:08:22.69987+00	\N	3013
2790	1	32979	1	t	LOCALCIRCLE	\N	13-09-2010	\N	2010-12-02 17:08:22.70026+00	\N	3014
2791	1	33077	1	t	LOCALCIRCLE	\N	09-09-2010	\N	2010-12-02 17:08:22.700649+00	\N	3015
2792	1	33081	1	t	LOCALCIRCLE	\N	09-09-2010	\N	2010-12-02 17:08:22.70772+00	\N	3016
2793	1	33086	1	t	LOCALCIRCLE	\N	09-09-2010	\N	2010-12-02 17:08:22.708111+00	\N	3017
2794	1	33087	1	t	LOCALCIRCLE	\N	25-09-2010	\N	2010-12-02 17:08:22.7085+00	\N	3018
2795	1	33089	1	t	LOCALCIRCLE	\N	09-09-2010	\N	2010-12-02 17:08:22.70889+00	\N	3019
2796	1	33090	1	t	LOCALCIRCLE	\N	25-09-2010	\N	2010-12-02 17:08:22.709267+00	\N	3020
2797	1	33091	1	t	LOCALCIRCLE	\N	09-09-2010	\N	2010-12-02 17:08:22.709647+00	\N	3021
2798	1	33107	1	t	LOCALCIRCLE	\N	23-09-2010	\N	2010-12-02 17:08:22.710037+00	\N	3022
2799	1	33108	1	t	LOCALCIRCLE	\N	23-09-2010	\N	2010-12-02 17:08:22.710414+00	\N	3023
2800	1	33109	1	t	LOCALCIRCLE	\N	23-09-2010	\N	2010-12-02 17:08:22.710984+00	\N	3024
2801	1	33110	1	t	LOCALCIRCLE	\N	23-09-2010	\N	2010-12-02 17:08:22.711369+00	\N	3025
2802	1	33111	1	t	LOCALCIRCLE	\N	23-09-2010	\N	2010-12-02 17:08:22.711796+00	\N	3026
2803	1	33112	1	t	LOCALCIRCLE	\N	29-09-2010	\N	2010-12-02 17:08:22.716052+00	\N	3027
2804	1	33114	1	t	LOCALCIRCLE	\N	29-09-2010	\N	2010-12-02 17:08:22.716443+00	\N	3028
2805	1	33115	1	t	LOCALCIRCLE	\N	28-09-2010	\N	2010-12-02 17:08:22.716834+00	\N	3029
2806	1	33116	1	t	LOCALCIRCLE	\N	21-10-2010	\N	2010-12-02 17:08:22.717446+00	\N	3030
2807	1	33117	1	t	LOCALCIRCLE	\N	28-09-2010	\N	2010-12-02 17:08:22.717832+00	\N	3031
2808	1	33118	1	t	LOCALCIRCLE	\N	29-09-2010	\N	2010-12-02 17:08:22.718221+00	\N	3032
2809	1	33119	1	t	LOCALCIRCLE	\N	28-09-2010	\N	2010-12-02 17:08:22.718616+00	\N	3033
2810	1	33120	1	t	LOCALCIRCLE	\N	28-09-2010	\N	2010-12-02 17:08:22.719007+00	\N	3034
2811	1	33121	1	t	LOCALCIRCLE	\N	28-09-2010	\N	2010-12-02 17:08:22.719397+00	\N	3035
2812	1	33122	1	t	LOCALCIRCLE	\N	29-09-2010	\N	2010-12-02 17:08:22.719779+00	\N	3036
2813	1	33126	1	t	LOCALCIRCLE	\N	18-10-2010	\N	2010-12-02 17:08:22.720162+00	\N	3037
2814	1	33132	1	t	LOCALCIRCLE	\N	18-10-2010	\N	2010-12-02 17:08:22.720547+00	\N	3038
2815	1	33135	1	t	LOCALCIRCLE	\N	18-10-2010	\N	2010-12-02 17:08:22.721032+00	\N	3039
2816	1	33136	1	t	LOCALCIRCLE	\N	18-10-2010	\N	2010-12-02 17:08:22.721421+00	\N	3040
2817	1	33137	1	t	LOCALCIRCLE	\N	13-08-2010	\N	2010-12-02 17:08:22.721812+00	\N	3041
2818	1	33139	1	t	LOCALCIRCLE	\N	16-09-2010	\N	2010-12-02 17:08:22.722192+00	\N	3042
2819	1	33140	1	t	LOCALCIRCLE	\N	16-09-2010	\N	2010-12-02 17:08:22.722569+00	\N	3043
2820	1	33141	1	t	LOCALCIRCLE	\N	28-10-2010	\N	2010-12-02 17:08:22.722957+00	\N	3044
2821	1	33142	1	t	LOCALCIRCLE	\N	16-09-2010	\N	2010-12-02 17:08:22.723334+00	\N	3045
2822	1	33143	1	t	LOCALCIRCLE	\N	16-09-2010	\N	2010-12-02 17:08:22.72372+00	\N	3046
2823	1	33144	1	t	LOCALCIRCLE	\N	16-09-2010	\N	2010-12-02 17:08:22.724111+00	\N	3047
2824	1	33145	1	t	LOCALCIRCLE	\N	16-09-2010	\N	2010-12-02 17:08:22.7245+00	\N	3048
2825	1	33146	1	t	LOCALCIRCLE	\N	16-09-2010	\N	2010-12-02 17:08:22.724892+00	\N	3049
2826	1	33148	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.725268+00	\N	3050
2827	1	33152	1	t	LOCALCIRCLE	\N	26-08-2010	\N	2010-12-02 17:08:22.725648+00	\N	3051
2828	1	33155	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.732789+00	\N	3052
2829	1	33156	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.733167+00	\N	3053
2830	1	33157	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.733556+00	\N	3054
2831	1	33159	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.733933+00	\N	3055
2832	1	33161	1	t	LOCALCIRCLE	\N	22-10-2010	\N	2010-12-02 17:08:22.734313+00	\N	3056
2833	1	33162	1	t	LOCALCIRCLE	\N	14-09-2010	\N	2010-12-02 17:08:22.734703+00	\N	3057
2834	1	33163	1	t	LOCALCIRCLE	\N	14-09-2010	\N	2010-12-02 17:08:22.73508+00	\N	3058
2835	1	33164	1	t	LOCALCIRCLE	\N	15-09-2010	\N	2010-12-02 17:08:22.735461+00	\N	3059
2836	1	33165	1	t	LOCALCIRCLE	\N	14-09-2010	\N	2010-12-02 17:08:22.735856+00	\N	3060
2837	1	33166	1	t	LOCALCIRCLE	\N	14-09-2010	\N	2010-12-02 17:08:22.736247+00	\N	3061
2838	1	33167	1	t	LOCALCIRCLE	\N	15-09-2010	\N	2010-12-02 17:08:22.736636+00	\N	3062
2839	1	33168	1	t	LOCALCIRCLE	\N	14-09-2010	\N	2010-12-02 17:08:22.741117+00	\N	3063
2840	1	33169	1	t	LOCALCIRCLE	\N	03-11-2010	\N	2010-12-02 17:08:22.741499+00	\N	3064
2841	1	33170	1	t	LOCALCIRCLE	\N	15-09-2010	\N	2010-12-02 17:08:22.741891+00	\N	3065
2842	1	33171	1	t	LOCALCIRCLE	\N	15-09-2010	\N	2010-12-02 17:08:22.742282+00	\N	3066
2843	1	33173	1	t	LOCALCIRCLE	\N	15-09-2010	\N	2010-12-02 17:08:22.742896+00	\N	3067
2844	1	33174	1	t	LOCALCIRCLE	\N	14-09-2010	\N	2010-12-02 17:08:22.74328+00	\N	3068
2845	1	33175	1	t	LOCALCIRCLE	\N	15-09-2010	\N	2010-12-02 17:08:22.743672+00	\N	3069
2846	1	33176	1	t	LOCALCIRCLE	\N	14-09-2010	\N	2010-12-02 17:08:22.744065+00	\N	3070
2847	1	33177	1	t	LOCALCIRCLE	\N	02-11-2010	\N	2010-12-02 17:08:22.744456+00	\N	3071
2848	1	33178	1	t	LOCALCIRCLE	\N	15-10-2010	\N	2010-12-02 17:08:22.744849+00	\N	3072
2849	1	33180	1	t	LOCALCIRCLE	\N	03-11-2010	\N	2010-12-02 17:08:22.745226+00	\N	3073
2850	1	33181	1	t	LOCALCIRCLE	\N	03-11-2010	\N	2010-12-02 17:08:22.745605+00	\N	3074
2851	1	33182	1	t	LOCALCIRCLE	\N	15-09-2010	\N	2010-12-02 17:08:22.746087+00	\N	3075
2852	1	33183	1	t	LOCALCIRCLE	\N	03-11-2010	\N	2010-12-02 17:08:22.746463+00	\N	3076
2853	1	33184	1	t	LOCALCIRCLE	\N	15-09-2010	\N	2010-12-02 17:08:22.746845+00	\N	3077
2854	1	33185	1	t	LOCALCIRCLE	\N	15-09-2010	\N	2010-12-02 17:08:22.747234+00	\N	3078
2855	1	33186	1	t	LOCALCIRCLE	\N	13-09-2010	\N	2010-12-02 17:08:22.747626+00	\N	3079
2856	1	33187	1	t	LOCALCIRCLE	\N	13-09-2010	\N	2010-12-02 17:08:22.748019+00	\N	3080
2857	1	33188	1	t	LOCALCIRCLE	\N	13-09-2010	\N	2010-12-02 17:08:22.748409+00	\N	3081
2858	1	33189	1	t	LOCALCIRCLE	\N	13-09-2010	\N	2010-12-02 17:08:22.748786+00	\N	3082
2859	1	33190	1	t	LOCALCIRCLE	\N	13-09-2010	\N	2010-12-02 17:08:22.749169+00	\N	3083
2860	1	33215	1	t	LOCALCIRCLE	\N	31-08-2010	\N	2010-12-02 17:08:22.749571+00	\N	3084
2861	1	33219	1	t	LOCALCIRCLE	\N	31-08-2010	\N	2010-12-02 17:08:22.749953+00	\N	3085
2862	1	33222	1	t	LOCALCIRCLE	\N	31-08-2010	\N	2010-12-02 17:08:22.750344+00	\N	3086
2863	1	33241	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.750739+00	\N	3087
2864	1	33285	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-02 17:08:22.757848+00	\N	3088
2865	1	33301	1	t	LOCALCIRCLE	\N	24-08-2010	\N	2010-12-02 17:08:22.758229+00	\N	3089
2866	1	33310	1	t	LOCALCIRCLE	\N	08-09-2010	\N	2010-12-02 17:08:22.758622+00	\N	3090
2867	1	33311	1	t	LOCALCIRCLE	\N	08-09-2010	\N	2010-12-02 17:08:22.759011+00	\N	3091
2868	1	33312	1	t	LOCALCIRCLE	\N	08-09-2010	\N	2010-12-02 17:08:22.759401+00	\N	3092
2869	1	33313	1	t	LOCALCIRCLE	\N	17-09-2010	\N	2010-12-02 17:08:22.759797+00	\N	3093
2870	1	33319	1	t	LOCALCIRCLE	\N	17-09-2010	\N	2010-12-02 17:08:22.76019+00	\N	3094
2871	1	33324	1	t	LOCALCIRCLE	\N	26-10-2010	\N	2010-12-02 17:08:22.76058+00	\N	3095
2872	1	33325	1	t	LOCALCIRCLE	\N	26-10-2010	\N	2010-12-02 17:08:22.76097+00	\N	3096
2873	1	33332	1	t	LOCALCIRCLE	\N	12-07-2010	\N	2010-12-02 17:08:22.761347+00	\N	3097
2874	1	30952	1	t	Deb Bauer	\N	\N	\N	2011-01-20 07:32:15.384356+00	\N	2
2875	1	33310	1	t	test	test@something	\N	\N	2011-02-21 13:16:22.540443+00	\N	3117
2876	1	33147	1	t	Kaleem	\N	\N	\N	2011-04-19 09:05:43.640252+00	\N	3119
2877	1	32393	1	t	sanchita	sancchak@in.ibm.com	25-6-2011	9945111865	2011-06-27 07:50:18.550837+00	\N	3123
2878	1	33759	1	t	\N	\N	09-07-2010	\N	2011-09-26 07:14:31.736233+00	\N	3133
2879	1	29704	1	t	sandip sanam rath	sandip_sanam_rath@dell.com	16.9.2011	9844923326	2011-09-26 08:31:08.32384+00	\N	3139
2880	1	31314	1	t	Aditi Sarkar	aditi_sarkar@dell.com	16th sep 2011	\N	2011-09-26 17:32:50.208655+00	\N	3143
2881	1	31314	1	t	Aditi Sarkar	\N	16-9-2011	\N	2011-09-26 17:35:59.260783+00	\N	3145
2882	1	29704	1	t	Karthik	karthik_n1@dell.com	16-9-2011	9964220321	2011-09-27 04:16:42.796552+00	\N	3149
2883	1	30712	1	t	balaji	balaji_a1@dell.com	16-9-2011	9900449284	2011-09-27 04:21:13.275736+00	\N	3151
2884	1	33755	1	t	guruprasad	guruprasad_s1@dell.com	9-9-2011	9481191032	2011-09-28 04:29:25.791114+00	\N	3161
2885	1	30631	1	t	Harsha Lewis	harsha_lewis@dell.com	14-11-2011	9945274534	2011-11-15 16:27:52.832929+00	\N	3167
2886	1	30631	1	t	Vijay kumar	vijayakumar_m2@dell.com	14-11-2011	9986486498	2011-11-30 15:15:15.642346+00	\N	3171
2887	1	30639	1	t	Abhishek Angadi	abhishek_angadi@dell.com	31-12-2011	9632008857	2012-01-02 04:57:08.368704+00	\N	3175
2888	1	30639	1	t	Vasavi P	vasavi_p@dell.com	31-12-2011	8147771147	2012-01-02 06:17:57.514146+00	There were broken toys with nails, it may harm the children while playing.  	3177
2889	1	32008	1	t	Mary	findmary@gmail.com	16/07/2011	\N	2011-07-16 11:15:37.582626+00	We visited the school as part of the Aksaya Patra and IBM collaboration. It was a wonderful experience.\r\nThe school was very well kept and the teachers are very dedicated.\r\nThe students are very eager to learn and intelligent children.\r\nOne thing I was not happy about was the condition of the toilet ! The girls toilet is not usable at all !	3127
2890	1	32008	1	t	Sundar Madhava Rao	msundarrao@in.ibm.com	9-7-2011	+919663375956	2011-07-15 08:24:22.853097+00	The school has about 300 children and we found the teachers & the principal to be very sincere.  The school's computer lab has not been in use for an year now, as they have not had a computer teacher.  The computers are not working and the UPS / Batteries are dead.  They mentioned that the Government does supply the books, but they are looking for donors for notebooks, white uniforms, bags and English copyrighting books.  We are planning to provide help to teach spoken English for children.  	3125
2891	1	29704	1	t	Adil Mateen Khan	adil_mateen_khan@dell.com	16-9-2011	9902775216	2011-09-26 07:55:56.991791+00	Need to focus on hygiene and room conditions.	3137
2892	1	33755	1	t	Vibhu Chowgi	vibhuchowgi@gmail.com	9-9-2011	\N	2011-09-26 17:19:23.920426+00	it was nice to spend time wit kids.. if the requirements are met in a right way at right time, it has chance to give kids a better way of living wit good knowledge and education..i request it to happen as soon as possible	3141
2893	1	31314	1	t	ravish raj	ravish_raj_sinha@dell.com	16-9-2011	9972545723	2011-09-26 18:20:23.58509+00	It was a new experience.	3147
2894	1	32551	1	t	Ravi SB	Ravi.SB@in.bosch.com	7-9-2011	9740802620	2011-10-12 08:30:46.219048+00	It was an fruitful experience of communication, with good cultured students. The class room was well organized.	3163
2895	1	30409	1	t	Nandini.M	nandini_m@dell.com	16-9-2011	9916450214	2011-09-27 04:32:24.024924+00	This Anganwadi is facing a threat of being demolished for constructing a kalyan mantap and so they are not sure what alternate will be provided. Please make sure a better alternate is provided. One more issue is that there is no TOILET facility for the kids which has to be considered seriously.\r\nThe kids here are well mannered and active enough to learn things.The teacher seemed to be good enough to take care of the kids.	3157
2896	1	30409	1	t	Ranjani.R	ranjani_r1@dell.com	16-09-2011	9743766301	2011-09-27 04:27:24.4957+00	This anganwadi building will be demolished in a short period and they do not have a building of their own and they are supposed to vacate the place.The children sat on the bare floor which was pretty cold,since there were no mats.One kid was made to sit on newspaper as he was suffering from bad cold.There are no toilets for both pre-school and high-school children and the open road is their place. 	3155
2897	1	31314	1	f	Patel Chintal Hemantkumar	chintal_hemant_kumar@dell.com	16/09/2011	9035842730	2011-09-27 08:07:15.675772+00	 	3159
2898	1	30409	1	t	Anila	Anila_Mol_P@dell.com	16-9-2011	8147393343	2011-09-27 04:22:54.593661+00	The major problem d kids and d teacher in dis anganwadi r facin s tat thy dont hv a buidin of their own. The kids r forced 2 sit under trees during election or other government events. One immediate facility tat has to b provided s a toilet, kids there r forced to use d roads nd surroundings of d anganwadi for same....	3153
2899	1	30631	1	t	Harsha Lewis	harsha_lewis@dell.com	14-11-2011	9945274534	2011-11-15 16:28:32.388216+00	It was a wonderful experience to be among the children. They were so excited with our presence.\r\nThe children enjoyed tattoos on their little hands and overwhelmed with drawing, painting, frog race, singing rhymes and dancing. \r\nIt was a special moment! \r\nIt gave me immense pleasure to see those tiny little happy faces. \r\n	3169
2900	1	30987	1	t	Nandini.M	nandini_m@dell.com	30-9-2011	\N	2011-10-15 17:26:26.204458+00	This preschool seemed to be in a very poor condition especially the premises is dirty and unhygienic due to  garbage dumped by bbmp, the place  stinks all the time so please take action ASAP.\r\nAlso the preschool is not spacious enough to accommodate the kids enrolled.\r\n	3165
2901	1	32129	1	t	santosh	santoshkumar1370@gmail.com	12-2-2011	9738341610	2011-02-12 07:08:49.284143+00	It was my first visit. I liked this program. I have enjoyed a lot with interacting with kids they are very charming and sporty.\r\n Thanks for giving me this opportunity. 	6
2902	1	30629	1	t	venugopal munnur	venugopal_munnur@dell.com	17-12-2011	9591916364	2011-12-21 05:02:58.902604+00	1. Problem with LPG connection(Purchasing kerosene from the teacher's personal ration card).\r\n2. Water facility(Need a water purifier).\r\n3. Restrooms are not hygenic.\r\n4. The cement sheets leak, when it rains.\r\n5. No proper storage facility for preserving the food.\r\n6. No Health checkup being done in past 8 months.\r\n7.Inadequate no. of toys and learning equipment.\r\n8. Inadequate number of mattresses for the kids to sit.	3173
2903	1	33759	1	f	Anil Kumar	anil_kumar_gupta@dell.com	09-07-2010	\N	2011-09-26 07:25:10.030011+00	I can do it, we can do it then INDIA will do	3135
2904	1	32551	1	t	Vinay Venkateswaran	vinay.venkateswaran@gmail.com	26-8-2011	9886055847	2011-08-30 04:51:46.658137+00	The school was housed in a pukka building that was fairly well-maintained with due attention to cleanliness. The classrooms were spacious and well-lit but the quality of benches was sub-standard. We only got to meet with the headmaster, librarian and one teacher. None of the teaching staff was adequately aware of using the desktops and the various applications available on them as provided by Akshara.	3131
2905	1	33115	1	t	Maya	maya@prathambooks.org	18-08-2010	\N	2010-08-25 07:09:12.227232+00	The school needs more books. More Pratham Books!!!	1
2906	1	32613	1	t	Yasmeen Taj	\N	28-08-2010	9741390773	2010-08-31 06:06:25.423901+00	place problam	130
2907	1	32566	1	t	Sowbhagya R	\N	25-08-2010	9591991710	2010-08-31 06:57:18.813476+00	This school was Awarded 3 times As Best School award. This schools have good Teachers and HM and also Good SDMC.	136
2908	1	31431	1	t	MURTHY	murthy50644@gmail.com	08-07-2010	9141450264	2010-08-25 07:09:12.227232+00	anganwadi teacher was interested to give data's...	24
2909	1	33202	1	t	Rajeev G	r_govardhanam@yahoo.com	25/07/2011	9945664782	2011-07-26 07:08:56.765376+00	There is no arts/PT teacher. Safe drinking water may be a concern. There are some badminton rackets, volley ball and football. But, nobody to train. All the teachers are females. Headmistress is really dedicated and wanted to see the school progress. She is very cooperative to volunteer programs. The school is served with lunch by Akshaya Patra. Last Saturday, they didn't serve lunch. I do not know how many children are depended on this afternoon meal. The computer lab is Ok and functional	3129
2998	1	33408	1	t	LOCALCIRCLE	\N	23-10-2010	\N	2010-12-02 17:08:22.768341+00	\N	3104
2999	1	33409	1	t	LOCALCIRCLE	\N	23-10-2010	\N	2010-12-02 17:08:22.768732+00	\N	3105
2910	1	33757	1	t	Ravi Kant	ravi_kant_kashyap@dell.com	21/01/11	9886146873	2011-01-31 13:33:38.590576+00	My write-up and the pictures I took can be accessed from following link:\r\n\r\nhttp://rockinrav.wordpress.com/2011/01/21/interacting-with-kids-at-one-of-the-akshara-foundation-funded-schools-in-bangalore/	4
2911	1	32912	1	t	LOCALCIRCLE	\N	26-07-2010	\N	2010-12-02 17:08:22.273256+00	\N	2348
2912	1	30664	1	t	Rudresh	rudresh_mahesh@dell.com	07/09/2012	\N	2012-09-14 09:18:35.896049+00	<em>Major concerns: Better toilets and drinking water facility should be provided. Cooking is done in the classroom- not safe..different place to be allocated for cooking.</em>	3275
2913	1	32441	1	t	NASEEM TAJ	tajnaseem@yahoo.com	09-07-2010	9901091761	2010-08-25 07:09:12.227232+00	In GKLPS KEMMANGUNDI School HM had not co operated properly, they are lazy to give the information to our foundation Because they had to take some rest after their lunch.  Our foundation are not living them to take rest.  And also told they will not give the data today and they told to come other day , if we call B.O also they will not give the data today.  They give the data other day only.	58
2914	1	32011	1	t	reshma	bhagya@akshara.org.in	21-08-2010	9741390804	2010-08-27 07:44:13.843769+00	ಈ ಶಾಲೆ ಯಲ್ಲಿ ಆಟದ ಮೈದಾನವಿಲ್ಲದೆ ಮಕ್ಕಳು ರಸ್ತೆಯ ಬದಿಯಲ್ಲಿ  ಆಡವಾಡುತ್ತಿದ್ದರು.	116
2915	1	33053	1	t	Bhagya	bhagya@akshara.org.in	23-08-2010	9741390704	2010-08-27 08:06:21.971545+00	ಈ ಶಾಲೆಯಲ್ಲಿ  ಉತ್ತಮವಾದ ವಾತಾವರಣವಿದೆ ಅಕ್ಕ ಪಕ್ಕದಲ್ಲಿ ಮರ ಗಿಡಗಳು ತಂಪಾದ ಗಾಳಿ ತುಂಬಾ ಚೆನ್ನಾಗಿದೆ ಚನ್ನೆನಹಳ್ಳಿ ಶಾಲೆ .ಮತ್ತು ಈ ಶಾಲೆಯಲ್ಲಿ DAILY DUMP COMPOST AT HOME  ನಿಂದ ದಿನ ನಿತ್ಯ ವ್ಯರ್ಥವಾಗುವ ಕಸವನ್ನು ಹಾಕಿ ಗೊಬ್ಬರ ಮಾಡುವ ಮಡಿಕೆಗಳು ಈ ಶಾಲೆಯಲ್ಲಿ ಇದೆ ಇದರಿಂದ ಶಾಲೆ ಸ್ವಚ್ಛವಾಗಿದೆ.	118
2916	1	32530	1	t	GOPAL	\N	28-08-2010	\N	2010-09-10 03:04:56.521156+00	Computer Training Needed. Toilet needed for staff 	178
2917	1	30639	1	t	RamyaShree C	ramya_shree_c@dell.com	31-12-2011	9591818892	2012-01-02 06:32:49.922826+00	The preschool premises was not clean and affect the kids health a lot.\r\nTeacher should teach hygine to the kids and their parents.\r\nteacher does not engage kids well with activities .	3179
2918	1	30588	1	t	ritu bhatia	ritu_bhatia@dell.com	31-Dec-2011	9980772684	2012-01-04 06:43:50.052112+00	1. Floor was not clean and lower than the ground level.\r\n2. No mattresses for kids to sit.\r\n3. No storage facility for food and utensils to cook.\r\n4. The cement sheets are cracked up and it leaks when it rains.\r\n5. No washroom for kids.\r\n6. Insufficient toys and books.\r\n7. No medical checkup being done in past 4 months.\r\n8. Problem with drinking water facility.\r\n9. The area outside the anaganavadi is not clean and hygienic as there is a dumping yard nearby.\r\n	3185
2919	1	32068	1	t	testing	\N	\N	\N	2010-08-25 07:09:12.227232+00	\N	60
2920	1	30662	1	t	Ramesh Chandran R	ramesh_chandran_r@dell.com	21-1-2012	9620389269	2012-01-22 02:22:10.047746+00	Even though play materials are available, those are not organised well due to lack of space. Two toilets are available. One is locked and the other one was not hygienic.  There is no water connection in the toilets. No milk or eggs given to children. No power connection. It can be painted well and kept lively. Teacher was complaining about the quality of the food given to the children. 	3187
2921	1	30639	1	t	Deepak Sharma	sharma_deep@aol.in	31-12-2011	9945176149	2012-01-02 09:51:32.808286+00	1.The area outside the anganavadi is not clean and hygenic.\r\n2. Problem with buying kerosene.\r\n3. No Health checkup being done in past 6 months.\r\n4.Inadequate no. of toys and learning equipment.\r\n5. Inadequate number of carpets for the kids to sit.\r\n6. Mid day food not being served on saturdays.	3181
2922	1	30639	1	t	Srujana Deva	srujana_deva_d@dell.com	31-12-2011	9538749739	2012-01-03 06:11:37.240242+00	Cleanliness outside the preschool has to be maintained. Inadequate number of mats for the kids to sit on the floor.	3183
2923	1	33169	1	f	Gautam John	gkjohn@gmail.com	08/03/2012	09886042017	2012-03-07 06:32:27.183543+00	Seems okay.	3229
2924	1	32415	1	t	venkatesh	\N	31-08-2010	\N	2010-09-10 02:36:49.617538+00	\N	142
2925	1	32620	1	t	Arvind Venkatadri	arvind@akshara.org.in	11/07/2012	97413-90757	2012-07-12 13:04:47.600129+00	A brand new building is coming up ( final stages); apparently it is being constructed by a local builder ( Pride Constructions). It is to be inaugurated next month as this is not the auspicious month ( sic). We did not inspect the new building but were assured it has all facilities. School runs in the temple opposite; all school materials are stored around the temple sanctum sanctorum; classes are conducted there in the temple. HeadMistress was present and is very keen.	3242
2926	1	32454	1	t	Jayamala	b	\N	\N	2010-08-26 08:25:05.838478+00	\N	70
2927	1	33325	1	t	Yasmeen Taj	jasmeeny2u@rediffmail.com	23-08-2010	9741390773	2010-08-26 08:38:04.040985+00	\N	74
2928	1	32460	1	t	ಜಯಮಾಲಾ	\N	\N	\N	2010-08-26 11:17:47.781392+00	\N	80
2929	1	32857	1	t	RESHMA	\N	25-08-2010	\N	2010-08-26 15:31:04.246656+00	\N	88
2930	1	32858	1	t	RESHMA	\N	23-08-2010	\N	2010-08-26 15:38:26.411301+00	\N	92
2931	1	32076	1	t	Vijayalakshmi	\N	26-08-2010	\N	2010-09-10 03:47:31.594108+00	\N	254
2932	1	32204	1	t	Ayesha	\N	27-08-2010	9591991701	2010-08-31 05:42:57.799254+00	\N	122
2933	1	32612	1	t	\N	\N	31-08-2010	\N	2010-08-31 06:08:16.374411+00	\N	132
2934	1	32949	1	t	Arvind Venkatadri	arvind@akshara.org.in	11/07/2012	97413-90757	2012-07-12 13:54:04.581287+00	Additional classrooms being built. Volleyball court with net in the front playground.  Met HM and her two teachers; did not appear to be terribly busy. Nali-Kali class was unsupervised; though all teachers participated in the Library class that was being conducted by the Akshara Librarian !!	3249
2935	1	32951	1	t	Arvind Venkatadri	arvind@akshara.org.in	11/07/2012	97413-90757	2012-07-12 13:47:50.187545+00	Single teacher / HM school; Shri Lakshmipati has been working here for 10 years. Has good rapport with village residents. In May June 2012, he printed handbills advertising the school and its facilities to the local population, at his own expense.   He has requested for Sports Equipment.	3248
2936	1	31144	1	t	Ashok Kamath	ashok@prathambooks.org	17/04/2012	08028568137	2012-04-19 07:16:09.510375+00	I visited this anganwadi on a day when the anganwadi worker was doing pulse polio drops to children in the area and this is why I think the attendance was low. The helper was also in the centre when we visited. This is a good centre and the anganwadi worker appears to be enthusiastic.	3235
2937	1	32615	1	t	Arvind Venkatadri	arvind@akshara.org.in	11/07/2012	97413-90757	2012-07-12 13:10:21.745136+00	Half of the building has an asbestos roof; local ZP official has ordered that it be replaced with a concrete-roofed one. Grant is also forthcoming, apparently.	3243
2938	1	32628	1	t	Arvind Venkatadri	arvind@akshara.org.in	10/07/2012	97413-90757	2012-07-12 12:56:24.441749+00	The only teacher in sight was the Akshara-paid Librarian; there were 6 children in the single room school. HM was absent that day. There are no other teachers.	3241
3000	1	33410	1	t	LOCALCIRCLE	\N	23-10-2010	\N	2010-12-02 17:08:22.769122+00	\N	3106
2939	1	33443	1	t	Arvind Venkatadri	arvind@akshara.org.in	12/07/2012	97413-90757	2012-07-12 12:51:20.097964+00	School is housed in an old but robust looking stone building; all children sit in one large hall which has two blackboards. HM was present; there are two ladies who do the cooking of the mid-day meal in a room that leads off from the main hall.	3240
2940	1	32852	1	t	Arvind Venkatadri	arvind@akshara.org.in	09/07/2012	97413-90757	2012-07-12 13:41:26.850209+00	HM requests earnestly for Volunteers to come and teach English. Should be possible to get volunteers from the ECity crowd close by.	3247
2941	1	34009	1	f	Megha	megha@klp.org.in	17/09/2012	\N	2012-09-17 06:37:47.805896+00	test	3276
2942	1	20272	1	t	GOVINDAPPA L.K	rathod11990@gmail.com	20/4/2013	9900045527	2013-10-01 06:07:40.404241+00	Everything is fine	3663
2943	1	32861	1	t	Arvind Venkatadri	arvind@akshara.org.in	09/07/2012	97413-90757	2012-07-12 13:35:41.405944+00	Working Computer Lab with Linux and Server-Client configuration. ( I installed Edubuntu and LTSP on the server while I was there) Atleast one teacher was tech-savvy. HM Srinivas Murthy is energetic and keen. Large Library Room on the first floor with old IBM KidSmart computers and also some science material. Play ground is across the village street, large area with trees. Perfect place for a educational habba or festival / event.  Well connected to the Hosur Road.	3246
2944	1	32321	1	t	Arvind Venkatadri	arvind@akshara.org.in	12/07/2012	97413-90757	2012-07-12 13:26:53.587714+00	SDMC President Venkatappa lives across the street from the school. He is supervising the construction of a new building with additional classrooms which looks to be ready in about a month. Power connections have been taken. Separate toilets and kitchen block. Clean fresh air, trees and miles and miles of  a view towards Kanakapura Road.  Local SHG has an office next to school.  Could use some sports equipment in the ground	3245
2945	1	32627	1	t	Arvind Venkatadri	arvind@akshara.org.in	10/07/2012	97413-90757	2012-07-12 13:18:01.339457+00	There is one toilet, shared by all children and presumably staff also.  The youngest teacher travels to this school from NELAMANGALA, a commute of some 50 kms ( she uses the NICE Road). Why she could not be posted in N1 Block beats me. Apparently remote postings are given to teachers starting their career. ZP official has ordered the building to be replaced by one with concrete roof and has promised funds.  School is on the village main street. 	3244
2946	1	29552	1	t	Meera	snehal.anvekar@yahoo.com	20/06/2012	9945533106	2012-06-24 21:04:14.324296+00	Dear Sir /Mam I stay is kodichikanhalli from past 6 years and I have never found that anganwadi open.I don't think regular classes would be conducted there.I have not visited the school personally but have a regular watch on the school. I have no idea as to how and whom we have to approach and how this volunteering works. I would be happy if any one would take an initiative to see that the school runs effectively and the children near my location get the basic education. I have been a teacher.	3237
2947	1	34046	1	f	Megha	megha@klp.org.in	25/07/2012	\N	2012-07-25 06:30:26.680339+00	testing out the SYS - 34046	3251
2948	1	34046	1	f	Megha	megha@klp.org.in	25/07/2012	\N	2012-07-25 07:47:51.204558+00	testing SYS again	3253
2949	1	32406	1	t	VENKATESH. R	\N	31-08-2010	\N	2010-09-10 02:31:47.939471+00	\N	138
2950	1	32407	1	t	VENKATESH. R	\N	31-08-2010	\N	2010-09-10 02:42:37.344602+00	\N	150
2951	1	32525	1	t	GOPAL	\N	27-08-2040	\N	2010-09-10 03:01:48.575639+00	\N	174
2952	1	32524	1	t	GOPAL	\N	28-08-2010	\N	2010-09-10 03:06:04.319512+00	\N	180
2953	1	32515	1	t	Parvathamma	\N	25-08-2010	\N	2010-09-10 03:08:04.715669+00	\N	182
2954	1	32510	1	t	Parvathamma	\N	27-08-2010	\N	2010-09-10 03:09:14.45575+00	\N	184
2955	1	32802	1	t	Chandrakala	\N	26-08-2010	\N	2010-09-10 03:10:18.87814+00	\N	186
2956	1	32519	1	t	Parvathamma	\N	26-08-2010	\N	2010-09-10 03:11:38.171498+00	\N	188
2957	1	32522	1	t	Parvathamma	\N	27-08-2010	\N	2010-09-10 03:13:07.884231+00	\N	190
2958	1	33428	1	t	Shwetha	\N	30-08-2010	\N	2010-09-10 03:21:25.358422+00	\N	202
2959	1	33428	1	t	Shwetha	\N	30-08-2010	\N	2010-09-10 03:21:34.438599+00	\N	204
2960	1	33428	1	t	Shwetha	\N	30-08-2010	\N	2010-09-10 03:21:49.378428+00	\N	206
2961	1	33428	1	t	Shwetha	\N	30-08-2010	\N	2010-09-10 03:22:21.037003+00	\N	208
2962	1	32223	1	t	Shwetha	\N	30-08-2010	\N	2010-09-10 03:23:53.895309+00	\N	210
2963	1	32224	1	t	Shwetha	\N	30-08-2010	\N	2010-09-10 03:24:37.99416+00	\N	212
2964	1	32222	1	t	Shwetha	\N	30-08-2010	\N	2010-09-10 03:25:35.036917+00	\N	214
2965	1	32410	1	t	Shwetha	\N	30-08-2010	\N	2010-09-10 03:26:44.79302+00	\N	216
2966	1	32409	1	t	Shwetha	\N	30-08-2010	\N	2010-09-10 03:27:32.65431+00	\N	218
2967	1	32411	1	t	Shwetha	\N	30-08-2010	\N	2010-09-10 03:28:22.573677+00	\N	220
2968	1	32404	1	t	Shwetha	\N	30-08-2010	\N	2010-09-10 03:29:10.712076+00	\N	222
2969	1	32228	1	t	Mala	\N	30-08-2010	\N	2010-09-10 03:32:55.193247+00	\N	228
2970	1	32225	1	t	Mala	\N	30-08-2010	\N	2010-09-10 03:34:42.370019+00	\N	232
2971	1	32226	1	t	Mala	\N	30-08-2010	\N	2010-09-10 03:35:21.429422+00	\N	234
2972	1	32950	1	t	Mala	\N	30-08-2010	\N	2010-09-10 03:36:40.527347+00	\N	236
2973	1	32945	1	t	Mala	\N	30-08-2010	\N	2010-09-10 03:38:40.645105+00	\N	240
2974	1	32957	1	t	Mala	\N	30-08-2010	\N	2010-09-10 03:39:27.205566+00	\N	242
2975	1	32955	1	t	Mala	\N	30-08-2010	\N	2010-09-10 03:40:56.742632+00	\N	244
2976	1	33422	1	t	Nagesh	\N	27-08-2010	\N	2010-09-10 03:44:48.797266+00	\N	248
2977	1	33414	1	t	Nagesh	\N	26-08-2010	\N	2010-09-10 03:45:38.116183+00	\N	250
2978	1	33421	1	t	Nagesh	\N	27-08-2010	\N	2010-09-10 03:46:30.314679+00	\N	252
2979	1	33415	1	t	Muniraju	\N	25-08-2010	\N	2010-09-10 03:54:58.403193+00	\N	264
2980	1	32091	1	t	Narayan	\N	26-08-2010	\N	2010-09-10 03:56:19.821841+00	\N	266
2981	1	32084	1	t	Narayan	\N	26-08-2010	\N	2010-09-10 03:57:29.519867+00	\N	268
2982	1	32092	1	t	Narayan	\N	26-08-2010	\N	2010-09-10 03:58:20.839617+00	\N	270
2983	1	32092	1	t	Narayan	\N	\N	\N	2010-09-10 03:58:56.578323+00	\N	272
2984	1	32092	1	t	Narayan	\N	\N	\N	2010-09-10 03:59:13.663193+00	\N	274
2985	1	32088	1	t	Narayan	\N	26-08-2010	\N	2010-09-10 03:59:58.277114+00	\N	276
2986	1	32085	1	t	Narayan	\N	25-08-2010	\N	2010-09-10 04:00:44.056143+00	\N	278
2987	1	33183	1	t	Megha	megha@klp.org.in	07/03/2012	\N	2012-03-07 17:04:30.628966+00	\N	3230
2988	1	32851	1	t	Arvind Venkatadri	arvind@akshara.org.in	09/07/2012	97413-90757	2012-07-12 14:04:41.896879+00	Spoke with In-charge HM and requested her to participate and oversee the Akshara Librarian's work.	3250
2989	1	20011	1	t	LOCALCIRCLE	\N	18-10-2010	\N	2010-12-02 17:08:20.777043+00	\N	301
2990	1	33948	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:20.777532+00	\N	302
2991	1	33939	1	t	LOCALCIRCLE	\N	28-06-2010	\N	2010-12-02 17:08:20.777922+00	\N	303
2992	1	33387	1	t	LOCALCIRCLE	\N	23-09-2010	\N	2010-12-02 17:08:22.761728+00	\N	3098
2993	1	33388	1	t	LOCALCIRCLE	\N	27-09-2010	\N	2010-12-02 17:08:22.766178+00	\N	3099
2994	1	33402	1	t	LOCALCIRCLE	\N	23-10-2010	\N	2010-12-02 17:08:22.766569+00	\N	3100
2995	1	33404	1	t	LOCALCIRCLE	\N	23-10-2010	\N	2010-12-02 17:08:22.766951+00	\N	3101
2996	1	33405	1	t	LOCALCIRCLE	\N	23-10-2010	\N	2010-12-02 17:08:22.767342+00	\N	3102
2997	1	33406	1	t	LOCALCIRCLE	\N	23-10-2010	\N	2010-12-02 17:08:22.767957+00	\N	3103
3001	1	33429	1	t	LOCALCIRCLE	\N	24-09-2010	\N	2010-12-02 17:08:22.769513+00	\N	3107
3002	1	33430	1	t	LOCALCIRCLE	\N	24-09-2010	\N	2010-12-02 17:08:22.769906+00	\N	3108
3003	1	33431	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.7703+00	\N	3109
3004	1	33432	1	t	LOCALCIRCLE	\N	12-10-2010	\N	2010-12-02 17:08:22.770692+00	\N	3110
3005	1	33433	1	t	LOCALCIRCLE	\N	23-09-2010	\N	2010-12-02 17:08:22.774568+00	\N	3111
3006	1	33434	1	t	LOCALCIRCLE	\N	23-09-2010	\N	2010-12-02 17:08:22.774952+00	\N	3112
3007	1	33435	1	t	LOCALCIRCLE	\N	24-09-2010	\N	2010-12-02 17:08:22.775343+00	\N	3113
3008	1	33436	1	t	LOCALCIRCLE	\N	24-09-2010	\N	2010-12-02 17:08:22.775736+00	\N	3114
3009	1	33443	1	t	LOCALCIRCLE	\N	27-09-2010	\N	2010-12-02 17:08:22.776129+00	\N	3115
3010	1	33924	1	t	LOCALCIRCLE	\N	06-09-2010	\N	2010-12-03 07:57:03.192863+00	\N	3116
3011	1	32639	1	t	KLP Admin	team@klp.org.in	03/09/2012	\N	2012-09-03 06:52:53.040638+00	<div>Rajinikanth, the most famous alumnus of the school, has not donated anything so far<br><div>DNA Correspondent l BANGALORE<br><div>Superstar Rajinikanth’s childhood school Government Model Primary School in Gavipuram will get a massive facelift, thanks to the efforts of Karnataka State Rajiniji Seva Samithi (KSRSS) and the education department.<div>The bhoomi puja on Sunday flagged off the construction work for a new building for the school which currently has students studying till Class 7.<div>The renovation, which is expected to cost `1.53 crore, is partially funded by the education department which has put in `81.5 lakh. About `20 lakh came from the MLA fund and `25 lakh came from the MP fund, with `27 lakh coming from donors.<div>Surprisingly, . “The star attended the school from 1954 to 1959. Currently, students can study only till Class 7, but in six months, it will have a high school section,” said G Murugan of KSRSS.<div>“This is not about making the school better just because Rajinikanth studied here. We were moved by the plight of these students, most of whom come from underprivileged backgrounds. Though the actor has not donated anything yet, we may go to him for funding at a later date,” he said.<div>The event was attended by the deputy chief minister R Ashoka, MP Anantkumar and Basavanagudi MLA Ravi Subramanya. Block education officer Kempiah, who was present at the event, said the new building will be completed in six months. “Currently the school has 156 students and during the time of renovation they will be shifted to a nearby corporation school. The new building will have 17 new classrooms.&nbsp;<div>inbox@dnaindia.net<br><div>Published Date: &nbsp;Sep 03, 2012<br><div>http://epaper.dnaindia.com/story.aspx?id=8920&boxid=31049716&ed_date=2012-09-03&ed_code=860009&ed_page=3	3262
3012	1	32973	1	t	Pavanesh	pavanesh@gmail.com	09/06/2012	9901844325	2012-06-09 18:34:53.60914+00	Dear Sir/Madam I regularly visit this school whenever Possible. I spent some time discussing the issues with the teachers. The issues mainly revolve around  toilets/computer rooms and about keeping the school clean. Usually the students who study here are from poor families who can afford only daily wages. Even though its a government school I can see lot of imp needed.  They badly need a a computer teacher who can spend some time with the teacher to teach computer to them. Thanks  -Pavanesh	3236
3013	1	32321	1	t	Arvind Venkatadri	arvind@akshara.org.in	10/08/2012	\N	2012-09-10 12:06:55.341948+00	\N	3269
3014	1	33439	1	t	Arvind Venkatadri	arvind@akshara.org.in	13/08/2011	\N	2012-09-10 11:57:53.040766+00	School has a new building, photo attached.	3268
3015	1	30664	1	t	Asha Sharath	asha@akshara.org.in	08/09/2012	9886041098	2012-09-10 13:23:09.841684+00	The Anganwadi is inside the GKHPS Kodihalli premises and has 35 children. Few things which I noticed are:<br><br>1. Though there are two toilets, Both do not have doors and are not clean. Children have to use these.<br>2. The room is divided into two portions with a curtain. The larger portion (80% of the room) is used to accommodate the children,. The smaller portion is used for cooking. The stove is not in a safe enough place for the children.<br>3. On a positive note, the TLM is all over the place and is accessible to children. The worker is cooperative and concerned.<br>	3270
3016	1	32094	1	t	Swaminathan	swaminathan.balaraman@bosch.com	17/11/2012	\N	2012-11-20 11:29:26.98974+00	Hello, the school infrastructure is in dilapidated condition. The hygiene is abyss. near to the school compound or confined areas, could see something vomited or spilled and left it to dry. Children complained of non nutritious and unhealthy food being served and hence many are following alternative. Knowledge on general affairs is low where Children doesn't know the present chief minister. They can't converse in English even the basics. Their reading schools skills needs attention. 	3291
3017	1	36403	1	t	Asha Sharath	asha@akshara.org.in	30/11/2012	\N	2012-12-03 11:26:54.061795+00	The Anganwadi is housed in a small room, very congested to even accommodate 10 children. The center has a toilet which does not have a door. Also, the center opens up to a large open area, which looks like a construction site. This place looked a little unsafe for children. The Anganwadi worker is very active and this reflects in the children.	3294
3018	1	30584	1	f	Megha	megha@klp.org.in	24/12/2012	\N	2012-12-24 07:02:47.90467+00	Adding pictures against trac ticket 524, will moderate the pics and soft delete the story	3296
3019	1	32393	1	t	Asha Sharath	asha@akshara.org.in	08/09/2012	9886041098	2012-09-10 14:25:29.408333+00	This school is fairly well equipped. They have 3 teachers and a HM managing around 198 children. So they clearly have a shortage of teachers. 2 buildings, on the left and the right side are new. The school also has a new compound. Through the MLA, the school has received a grant on INR 75 Lac for the center building renovation.<br><br>Mid-Day meals are served in the school. I noticed that the children dump the left-over food on the ground and there is no dust-bin facility. They also wash their hands in the ground though there is a washing area with 4 taps. The toilets are recently constructed and are in good shape and clean.<br><br>The school has a few computers donated by Akshara as well as Intel. Computers and the library is in the single room. One teacher is assigned to manage the library and she conducts the library session once in a fortnight. The school also has a LEGO box which is sometimes used by the children to make models.<br><br>The HM is in need of volunteers for:<br>1. Teaching computers on a regular basis.<br>2. Painting the Compound Walls.	3272
3020	1	30664	1	t	Rama Subba  Reddy	misperson@gmail.com	07/09/2012	9972622954	2012-09-13 16:07:07.686917+00	\N	3274
3021	1	30664	1	t	Mahesh Kumar	kumarsmahesh@gmail.com	07/09/2012	\N	2012-09-13 14:14:04.56189+00	Need some more place for the kids to play and big class rooms.	3273
3022	1	32630	1	t	Arvind Venkatadri	arvind@akshara.org.in	21/09/2012	97413-90757	2012-09-21 09:11:09.543705+00	School population is 9 ( nine). The Akshara Librarian was present, as was the one teacher. Apparently the children from this village all head to the Ramakrishna Mission School ( RKMS) about a kilometer down the road. The good thing is that the teacher is a local man and lives closeby, near the RKMS in fact.  School has power and radio was working. Compared to other dwellings in the village, the school looked the best maintained. 	3277
3023	1	32614	1	t	Arvind Venkatadri	arvind@akshara.org.in	10/09/2012	\N	2012-09-21 09:30:18.096364+00	The Teachers are getting involved with the Lego activity in the Library.	3279
3205	1	36013	1	t	MANJUNATHA C	manjunath85c@gmail.com	10/04/13	8861303203	2013-07-24 06:23:23.579909+00	NO Play ground .	3524
3024	1	32628	1	t	Arvind Venkatadri	arvind@akshara.org.in	21/09/2012	\N	2012-09-21 09:18:45.604687+00	My third visit to this school and I have yet to clap my eyes on the HM / Teacher. This time however, I noticed the toilets had been cleaned up and were looking usable; there was no sign of water or a water tank yet, but I think that may happen.  Several officials of the Excise Dept drew up in 4 jeeps as we were there. I spoke to one of them: it seems they come there every week (!) to check on illegal drugs. 	3278
3025	1	32627	1	t	Arvind Venkatadri	arvind@akshara.org.in	21/09/2012	\N	2012-09-21 09:32:14.628595+00	School building has been demolished. A new building is to be constructed in its place; could see no sign of activity as we drove by. Children are attending class at the local Panchayat office, I was told.	3280
3026	1	33141	1	t	KLP Admin	team@klp.org.in	30/09/2012	\N	2012-10-01 12:37:31.840369+00	Going to this govt school is a marathon task. Literally | 40-odd children have to travel more than 40 km to attend their school on Raj Bhavan premises ByY Maheswara Reddy Though many students travel long distances every day to attend private schools in the city, children attending a government primary school situated more than 20 km away from their homes is uncommon. Full story http://epaper.dnaindia.com/story.aspx?id=9622&boxid=20300048&ed_date=2012-10-01&ed_code=860009&ed_page=5 	3281
3027	1	35874	1	t	Randa Grob	rgz@lego.com	05/10/2012	4552159829	2012-10-05 07:30:42.203644+00	Children actively playing and engaged with one another. However, likely due to large number of children, little interaction with teacher was observed. Teacher had a very professional in her way of treating children, creating a nice atmosphere, where play and interaction among children was possible.	3282
3028	1	32393	1	t	Samir Rakshit	samirkumar_rakshit@symantec.com	08/09/2012	9620011809	2012-10-21 09:33:00.3456+00	It is a pretty well equipped Govt. school. They have most of required facilities as compared to other Govt. schools. Still this school needs some volunteers to teach English or Computer courses like MS Office/Excel. For me it was an enlightening experience to spend some time with the kids and learn few lessons of giving back to the society.	3283
3029	1	36241	1	t	Suma C N	suma.chandrasekhar.nirmala@oracle.com	21/10/2012	080-40299399	2012-10-29 08:38:58.658349+00	We had organized a Painting activity at the School as suggested by the Head Master. The school walls were not painted for years and looked unclean for kids to study there. A team of volunteers from my organization visited and painted the campus. Thanks to the NGO for providing us this opportunity.	3285
3030	1	36219	1	t	Asha Sharath	asha@akshara.org.in	17/09/2012	\N	2012-10-29 07:07:58.49169+00	The primary and secondary schools co-exist in the same premises. The school has a huge playground, has a science lab, has a well-stocked computer lab. On the day of the visit, Target volunteers did a science-lab makeover and a library- makeover and donated books to the library. One of the school teacher had agreed to maintain the library and facilitate the library period for children.	3284
3031	1	32554	1	t	Prerana	prerana7390@gmail.com	10/11/2012	\N	2012-11-14 08:20:09.453297+00	\N	3287
3032	1	32556	1	t	Darshini	darshini.ks@in.bosch.com	10/11/2012	\N	2012-11-14 08:17:16.080842+00	I had volunteered for LEGO Habba on, 10th November 2012 at GKHPS M.R.P. Adugodi, it was a great experience. Nice to see the creative ideas from students. Because of festive season the parents participation was less, but overall a wonderful event.	3286
3033	1	32554	1	t	Asha Sharath	asha@akshara.org.in	10/11/2012	\N	2012-11-14 09:44:23.503336+00	\N	3288
3034	1	33137	1	t	Pradeep Kumar	chinna.pradeep@gmail.com	17/11/2012	\N	2012-11-20 04:09:03.859204+00	\N	3290
3035	1	33137	1	t	Sameer	muhammed.sameer@in.bosch.com	17/11/2012	8095484948	2012-11-19 11:20:08.66293+00	1. The building look fearingly old and the concrete (May be the lime sand which was used in the older days) from the roof started falling off. 2. Insufficient play ground area 3. Toilets need to be improved 4. Seriousness for the kids about the need of education looks very poor. 5. Teachers have less control on the children. 	3289
3036	1	33137	1	t	Asha Sharath	asha@akshara.org.in	17/11/2012	\N	2012-11-22 07:05:17.282088+00	\N	3292
3037	1	30789	1	t	Asha Sharath	asha@akshara.org.in	30/11/2012	\N	2012-12-03 11:21:40.205273+00	The Anganwadi does not have a toilet. Though there are community toilets next to the Agnawadi, children are not allowed to use that.	3293
3038	1	30352	1	f	Megha	megha@klp.org.in	24/12/2012	\N	2012-12-24 07:00:33.782839+00	Adding pictures for fixing trac ticket  524, will keep the pictures during moderation and soft delete the story	3295
3039	1	32861	1	t	Pankaj Dixit	pankaj_dixit@hotmail.com	08/12/2012	919845748812	2013-01-14 08:54:57.254722+00	I visited the school as part of Lego hebba on 8th Dec, as part of CGI team. The enthusiasm of the teachers, students and head master was noticeable. I have talks with head master. This school is already supported by some corporates. The current roof is a tilted tiled roof which leaks in the rains. This will be replaced by RCC roof shortly with support from Biocon. The head master expressed the need of a large table in the library. The standard of school looked good. 	3299
3040	1	31494	1	t	Sandhya Kumar	kumar.sandhya@gmail.com	16/01/2013	9845717350	2013-01-17 09:37:01.239927+00	I really enjoyed the visit to the anganwadi in Sampigehalli. I was most impressed with the enthusiasm of the teacher and her students. There must have been about 20 students. They were all looked happy and engaged. They enthusiastically sung rhymes in English and Kannada, showed us how they played with some of the learning materilas, and even put up a skit on Krishna before we left. The teacher's sincerity and dedication was impeccable.	3300
3041	1	31494	1	t	Ashok Kamath	ashokrkamath@gmail.com	16/01/2013	\N	2013-01-17 15:05:45.365883+00	The teacher at this anganwadi was very enthusiastic and it shows when the children respond so well. The BVS is not at all active and parents also do not seem to be interested. However, a local resident Ms. Annapurna Kamath has contributed significantly to this anganwadi. The teacher herself takes a lot of trouble and needs to be recognized.	3301
3042	1	32507	1	t	Salil Pillai	salil.pillai@accenture.com	12/01/2013	\N	2013-01-18 13:28:59.624585+00	Well to answer all the questions above is not possible because we dint went to each and every corner of the school.. But while being to the school and seeing the charm and enthusiasm it was a better experience.\r\nStudents were very enthusiastic very energitic too.	3308
3043	1	32507	1	t	Sandeep Pal	sandeep.kumar.pal@accenture.com	12/01/2013	\N	2013-01-21 12:37:21.493352+00	It was really a very nice experience having some time with school kids. Most interesting thing was the smile of children while participating in various fun activities organised by volunteers.	3309
3044	1	35993	1	t	v. Srinivasa	srinivasapy@gmail.com	09/04/13	8861303212	2013-07-24 06:23:20.444727+00	All facility is their 4 teachers are working and 43 children is their.	3352
3045	1	35986	1	t	v. Srinivasa	srinivasapy@gmail.com	09/04/13	8861303212	2013-07-24 06:23:20.463512+00	In this school shortage of teacher and rooms.	3353
3083	1	36206	1	t	Krishnappa	krishnappanm1431@gmail.com	04/16/13	8861303204	2013-07-24 06:23:21.001851+00	shortage of the class rooms, disable children  has no ram facility.	3383
3116	1	35928	1	t	MANJUNATH N	manju2mm143@gmail.com	10/04/13	8861303207	2013-07-24 06:23:21.426007+00	This school having one class room all class students sitting in this room only.	3408
3046	1	32507	1	t	Hari Mohan Aggarwal	hari.mohan.aggarwal@accenture.com	12/01/2013	\N	2013-01-18 10:18:57.487546+00	There were many poor children present in the school who did not had even slippers to wear. Kindly provide them with a pair of slippers atleast.\r\nFor the junior classes there was no arrangement of chairs and desk and they were sitting on the ground just over floor mats even in this winter season. Kindly provide sitting arrangement for these children.	3307
3047	1	32507	1	t	Manoj Madhavan	manoj.madhavan@accenture.com	12/01/2013	9886004907	2013-01-18 08:48:43.810024+00	The basic needs like toilets and stationeries are far better than which I had got in my schooling.  Compare to other private schools, Here the “wealth” is education and education is the “wealth”. Please create an atmosphere or try to change the attitude of the teachers towards the facilities. Or lack of facilities and the indulging the brand name “Govt School”. There is no need of comparison with Private schools. Dr BR Ambedkar has already proved that facilities are not a matter for great success.  Modestly I can tell you that I am one among the role model of success from nothing.  A son of a coolie then ,  now working as Team Lead in Accenture.	3304
3048	1	35995	1	t	v. Srinivasa	srinivasapy@gmail.com	09/04/13	8861303212	2013-07-24 06:23:20.369045+00	Compound construction work was proses, children read the library books. Teachers prepared the progress cards.	3349
3049	1	35996	1	t	v. Srinivasa	srinivasapy@gmail.com	09/04/13	8861303212	2013-07-24 06:23:20.399944+00	In this school shortage of teacher and rooms, not in play gound.	3350
3050	1	35987	1	t	v. Srinivasa	srinivasapy@gmail.com	09/04/13	8861303212	2013-07-24 06:23:20.425986+00	Compound and play ground construction work was prosses from SSA,	3351
3051	1	36000	1	t	v. Srinivasa	srinivasapy@gmail.com	09/04/13	8861303212	2013-07-24 06:23:20.482207+00	here school compound construction work  prosses.	3354
3052	1	36048	1	t	Krishnappa	krishnappanm1431@gmail.com	18/04/13	8861303204	2013-07-24 06:23:20.500796+00	In this school only 2 rooms is there.	3355
3053	1	36189	1	t	Krishnappa	krishnappanm1431@gmail.com	18/04/13	8861303204	2013-07-24 06:23:20.519465+00	in this school each one class separate rooms is their, two rooms is spiel.	3356
3054	1	36056	1	t	Krishnappa	krishnappanm1431@gmail.com	17/04/13	8861303204	2013-07-24 06:23:20.537978+00	in this school shortage of the rooms, somebody given the playing materials kept around the school.	3357
3055	1	36047	1	t	Krishnappa	krishnappanm1431@gmail.com	17/04/13	8861303204	2013-07-24 06:23:20.556884+00	In this school only 1 teacher and 2 class rooms is their,	3358
3056	1	36053	1	t	Krishnappa	krishnappanm1431@gmail.com	18/04/13	8861303204	2013-07-24 06:23:20.575337+00	in this school shortage of the classrooms, no compound here.	3359
3057	1	35945	1	t	Krishnappa	krishnappanm1431@gmail.com	11/04/13	8861303204	2013-07-24 06:23:20.852591+00	In this school no school board name here, no time-table to library.	3375
3058	1	33823	1	t	Ashok Kamath	ashokrkamath@gmail.com	05/02/2013	\N	2013-02-06 10:33:44.319653+00	I believe the name of the teacher is Sunanda and she is doing a very nice job of managing this anganwadi along with her helper.	3318
3059	1	20155	1	t	SHIVAPPA .B	shivappa26@gmail.com	15/4/2013	9900045526	2013-10-01 06:07:41.154285+00	There was no playground.	3721
3060	1	36210	1	t	Krishnappa	krishnappanm1431@gmail.com	11/04/13	8861303204	2013-07-24 06:23:20.871604+00	In this school shortage of the classrooms, not in here any playing materials.	3376
3061	1	32507	1	t	Salil Pillai	salil.pillai@accenture.com	12/01/2013	\N	2013-01-21 13:37:46.028907+00	I have not full idea to comment about the campus as we dint went every corner of the school.\r\nWorking with the little champions was however a good experience, every one looked enthusiastic or energised when told to show there talent.	3312
3062	1	36051	1	t	Krishnappa	krishnappanm1431@gmail.com	15/04/13	8861303204	2013-07-24 06:23:20.593825+00	in this school shortage of the classrooms, I went afternoon not observed the childrens attendance.	3360
3063	1	36050	1	t	Krishnappa	krishnappanm1431@gmail.com	16/04/13	8861303204	2013-07-24 06:23:20.612546+00	In this school only 2 rooms is their, teacher not given the library books to children.	3361
3064	1	36048	1	t	Krishnappa	krishnappanm1431@gmail.com	16/04/13	8861303204	2013-07-24 06:23:20.631138+00	in this school only 2 rooms is their, library books is given to children to read.	3362
3065	1	36044	1	t	Krishnappa	krishnappanm1431@gmail.com	18/04/13	8861303204	2013-07-24 06:23:20.649763+00	in this school no office room, not put the time-table to library class.	3363
3066	1	36043	1	t	Krishnappa	krishnappanm1431@gmail.com	19/04/13	8861303204	2013-07-24 06:23:20.668313+00	In this school shortage of classrooms.	3364
3067	1	36052	1	t	Krishnappa	krishnappanm1431@gmail.com	08/04/13	8861303204	2013-07-24 06:23:20.687332+00	In this school no separate office room only 2 rooms is their.	3365
3068	1	36040	1	t	Krishnappa	krishnappanm1431@gmail.com	04/19/13	8861303204	2013-07-24 06:23:20.705824+00	In this school shortage of rooms. No play ground.	3366
3069	1	36041	1	t	Krishnappa	krishnappanm1431@gmail.com	04/19/13	8861303204	2013-07-24 06:23:20.724535+00	In this school shortage of rooms. No play ground.	3367
3070	1	36046	1	t	Krishnappa	krishnappanm1431@gmail.com	11/04/13	8861303204	2013-07-24 06:23:20.743254+00	In this school shortage of rooms.	3368
3071	1	36045	1	t	Krishnappa	krishnappanm1431@gmail.com	11/04/13	8861303204	2013-07-24 06:23:20.761813+00	In this school shortage of rooms, no separate office room.	3369
3072	1	36200	1	t	Krishnappa	krishnappanm1431@gmail.com	04/15/13	8861303204	2013-07-24 06:23:20.780379+00	In this school shortage of rooms, no separate office room. Only 4 rooms is there.	3370
3073	1	36213	1	t	Krishnappa	krishnappanm1431@gmail.com	08/04/13	8861303204	2013-07-24 06:23:20.797547+00	In this school shortage of rooms,  Only 2 rooms is there	3371
3074	1	36220	1	t	Krishnappa	krishnappanm1431@gmail.com	09/04/13	8861303204	2013-07-24 06:23:20.809737+00	In this school shortage of rooms. No play ground.	3372
3075	1	36063	1	t	Krishnappa	krishnappanm1431@gmail.com	09/04/13	8861303204	2013-07-24 06:23:20.82199+00	any facility not in this school, only 11 children and 3 teachers is there.	3373
3076	1	36223	1	t	Krishnappa	krishnappanm1431@gmail.com	11/04/13	8861303204	2013-07-24 06:23:20.83424+00	In this school only 2 rooms is there. no time- table to library.	3374
3077	1	36222	1	t	Krishnappa	krishnappanm1431@gmail.com	12/04/13	8861303204	2013-07-24 06:23:20.890356+00	in this school shortage of classrooms and no separate office room.	3377
3078	1	36061	1	t	Krishnappa	krishnappanm1431@gmail.com	12/04/13	8861303204	2013-07-24 06:23:20.909+00	Only 2 room is there in this school, 1,2,3 class children sitting on one room, 4,5 class children sitting on another room.	3378
3079	1	35943	1	t	Krishnappa	krishnappanm1431@gmail.com	11/04/13	8861303204	2013-07-24 06:23:20.927851+00	In this school only 2 rooms is there. No playing materials and teaching materials.	3379
3080	1	36224	1	t	Krishnappa	krishnappanm1431@gmail.com	09/04/13	8861303204	2013-07-24 06:23:20.946755+00	One of the center school, no play ground and compound.	3380
3081	1	36058	1	t	Krishnappa	krishnappanm1431@gmail.com	04/19/13	8861303204	2013-07-24 06:23:20.965341+00	Shortage of the class rooms, no playing materials,	3381
3082	1	36193	1	t	Krishnappa	krishnappanm1431@gmail.com	04/16/13	8861303204	2013-07-24 06:23:20.984107+00	NA	3382
3084	1	32507	1	t	Mohammed zubair	mohammed.zubair.mk@accenture.com	12/01/2013	9739658579	2013-01-18 06:47:45.950878+00	1)Building was really good and classroom were really decorative with learning stuff\r\n2)Spacoius platground\r\n3)HM has separate room which is nice\r\n4)Overall students performance was good . One student named Manju who is studying in 2 or 3rd Class who is affected by polio from his childhood and he has no mother to take care of him. He is really good in his studies and brilliant too. Govt or learning patnership has to do some welfare to that Manju as he has financialy to weak family. It is my kind request to KLP to give great path to that physically challenged intelligent Guy \r\n\r\n\r\n5)Library was good but still it needs some attention to make more good.\r\n6)Really the students are lucky to have a such great teaching staff who coordinated in a good manner to make the whole event a huge success. 	3302
3085	1	36137	1	t	srikanth	srikanth.bhathk@gmail.com	15/02/2013	9741390792	2013-02-21 05:55:41.276014+00	The school was very nice. In this school 3 teachers are there.  Total student strength in this 1to 7 76 	3319
3086	1	35876	1	t	srikanth	srikanth.bhathk@gmail.com	15/02/2013	9844379475	2013-02-21 06:13:22.621031+00	GKHPS Kurubarapet school is very nice. In this school total 69 student are there. 	3320
3087	1	32554	1	t	Charles Nailen	CCN@georgetown.edu	22/02/2013	\N	2013-02-24 18:55:41.775321+00	\N	3321
3088	1	32094	1	t	Divya Sanath	divya.sanath@hdfcbank.com	09/02/2013	9886084916	2013-02-25 05:27:05.959024+00	Observed more than 80% of children (enrolled) being served food and enjoying their food.	3322
3089	1	32094	1	t	Deepa Agarwal	deepa.agarwal@hdfcbank.com	09/02/2013	9535200548	2013-02-25 05:35:13.079398+00	Food was not wasted. As per our observation, class teachers were sitting in their respective classes. One major concern is the current situation of the school building. As understood from the staff it is a 100 (or more) year old structure that is being used by the school. I feel that immediate action (repair and maintenance) should be carried out to safeguard the lives of the children. Building seems very weak and may not withstand the capacity for a long time. Kindly take this as a suggestion.	3323
3090	1	36113	1	t	V. Srinivasa	srinivasapy@gmail.com	08/04/13	8861303212	2013-07-24 06:23:19.769531+00	We visit 8/4/2013 that day 18 childrens attend the school. New two rooms is good. Prepare the food in kitchen room. Separate toilet girls and boys.	3327
3091	1	36114	1	t	v. Srinivasa	srinivasapy@gmail.com	08/04/13	8861303212	2013-07-24 06:23:19.990928+00	I visit 8/4/2013  Head Master Gangaraju and staff teacher I get the school  information,	3328
3092	1	36115	1	t	v. Srinivasa	srinivasapy@gmail.com	08/04/13	8861303212	2013-07-24 06:23:20.009116+00	Compound construction work was prosses, children read the library books. Teachers prepared the progress cards.	3329
3093	1	36118	1	t	v. Srinivasa	srinivasapy@gmail.com	08/04/13	8861303212	2013-07-24 06:23:20.026299+00	Here classrooms problem is there . School compound is not here.	3330
3094	1	35929	1	t	v. Srinivasa	srinivasapy@gmail.com	06/04/13	8861303212	2013-07-24 06:23:20.043475+00	In this school all facility is there . 2 teacher teach the lesson. SDMC members observed the class and sher with opinion.	3331
3095	1	36116	1	t	v. Srinivasa	srinivasapy@gmail.com	06/04/13	8861303212	2013-07-24 06:23:20.060483+00	Here shortage classrooms  is there. Rooms construction work was prosses, school all responsibility taking the Kantharaju teacher.	3332
3096	1	36001	1	t	v. Srinivasa	srinivasapy@gmail.com	06/04/13	8861303212	2013-07-24 06:23:20.07754+00	compound is not here. Toilet problem, one room is sheet and another room is RCC.	3333
3097	1	36109	1	t	v. Srinivasa	srinivasapy@gmail.com	08/04/13	8861303212	2013-07-24 06:23:20.09437+00	Rathnamma nali-kali class, nagaraj and manjunatha 4,5,6 and prameela 6,7th class teach the lesson. Big compound is their. Working are 4 teacher and chiLdrens is 56.	3334
3098	1	36108	1	t	v. Srinivasa	srinivasapy@gmail.com	09/04/13	8861303212	2013-07-24 06:23:20.11153+00	Signal teacher is there, compound is not here. Children learning level is low.	3335
3099	1	36111	1	t	v. Srinivasa	srinivasapy@gmail.com	09/04/13	8861303212	2013-07-24 06:23:20.12851+00	In this school all facility  is there, AB Prabakar grama panchayit member, He has a good support to the school. Learning level is good.	3336
3100	1	36119	1	t	v. Srinivasa	srinivasapy@gmail.com	08/04/13	8861303212	2013-07-24 06:23:20.145703+00	Compound has been constructed. 2012-13 year closed the urdu school because no children. Not good in learning level. Most of the childrens went to private school.	3337
3101	1	36110	1	t	v. Srinivasa	srinivasapy@gmail.com	08/04/13	8861303212	2013-07-24 06:23:20.172895+00	In this school all facility  is there . Compound has been constructed.	3338
3102	1	36112	1	t	v. Srinivasa	srinivasapy@gmail.com	10/04/13	8861303212	2013-07-24 06:23:20.190116+00	Compound has been constructed. Learning level is good, each one children keep the individual file. School compound is good.	3339
3103	1	36117	1	t	v. Srinivasa	srinivasapy@gmail.com	09/04/13	8861303212	2013-07-24 06:23:20.207492+00	I visit time Krishnappa teacher is attend the school, SDMC members coordination is good.	3340
3104	1	35991	1	t	v. Srinivasa	srinivasapy@gmail.com	09/04/13	8861303212	2013-07-24 06:23:20.22453+00	1to7th class childrens sitting in one room. Shortage of the teachers, 3 room is sheet.	3341
3105	1	35994	1	t	v. Srinivasa	srinivasapy@gmail.com	09/04/13	8861303212	2013-07-24 06:23:20.242982+00	100 years history in this school. School ground and compound is there. 4 rooms is their include the kitchen room. Shortage of the teachers.	3342
3106	1	35988	1	t	v. Srinivasa	srinivasapy@gmail.com	09/04/13	8861303212	2013-07-24 06:23:20.261666+00	Compound construction work was prosses from SSA. In this school all facility is there. Shivananda teacher took the traning english and maths  from akshara foundation.	3343
3107	1	35992	1	t	v. Srinivasa	srinivasapy@gmail.com	06/04/13	8861303212	2013-07-24 06:23:20.278534+00	in this school only one teacher is there. Toilet, kitchen room, compound is there. But shortage of room and teachers.	3344
3108	1	35990	1	t	v. Srinivasa	srinivasapy@gmail.com	09/04/13	8861303212	2013-07-24 06:23:20.295206+00	Where one side of each room. Here is the other side of teaching.	3345
3109	1	35997	1	t	v. Srinivasa	srinivasapy@gmail.com	09/04/13	8861303212	2013-07-24 06:23:20.312741+00	in this school all facility  is there,	3346
3110	1	35998	1	t	v. Srinivasa	srinivasapy@gmail.com	09/04/13	8861303212	2013-07-24 06:23:20.331502+00	Any facility not in this school. 3 new rooms is there but not condated the class	3347
3111	1	35999	1	t	v. Srinivasa	srinivasapy@gmail.com	09/04/13	8861303212	2013-07-24 06:23:20.35031+00	here shortage classrooms and teachers. Not in here play ground.	3348
3112	1	32554	1	t	Ankit Anubhav	ankit@prathambooks.org	12/07/2013	8971936444	2013-07-16 04:29:03.853785+00	Pratham Books did an event with Cisco volunteers and it was a wonderful experience for them. The teachers cooperated well & helped us in conducting the book reading session and the activity. 	3326
3113	1	36072	1	t	MANJUNATH N	manju2mm143@gmail.com	10/04/13	8861303207	2013-07-24 06:23:21.37526+00	This school have two rooms. The school having good atmosphere.	3405
3114	1	36073	1	t	MANJUNATH N	manju2mm143@gmail.com	10/04/13	8861303207	2013-07-24 06:23:21.392257+00	This having four rooms along with the office room.	3406
3115	1	35906	1	t	MANJUNATH N	manju2mm143@gmail.com	10/04/13	8861303207	2013-07-24 06:23:21.409127+00	This school having two class rooms and two teachers, playing ground also is there in school.	3407
3117	1	35916	1	t	MANJUNATH N	manju2mm143@gmail.com	10/04/13	8861303207	2013-07-24 06:23:21.442914+00	This school having two class rooms, NALI KALI one room and 4,5,6,7 one room.	3409
3118	1	36196	1	t	MANJUNATH N	manju2mm143@gmail.com	08/04/13	8861303207	2013-07-24 06:23:21.459831+00	This school having two class rooms and two teachers, playing ground also is there in this school.	3410
3119	1	35922	1	t	MANJUNATH N	manju2mm143@gmail.com	08/04/13	8861303207	2013-07-24 06:23:21.476971+00	This school having basic facilities good class rooms.	3411
3120	1	35925	1	t	MANJUNATH N	manju2mm143@gmail.com	08/04/13	8861303207	2013-07-24 06:23:21.493721+00	This school having one class room all class students sitting in this class room only.	3412
3121	1	35938	1	t	SRINIVAS P	Srinivasa.p.06@gmail.com	18/04/13	9741390731	2013-07-24 06:23:21.51096+00	Building is pucca but damage.	3413
3122	1	35942	1	t	SRINIVAS P	Srinivasa.p.06@gmail.com	18/04/13	9741390731	2013-07-24 06:23:21.527681+00	NA	3414
3123	1	35937	1	t	SRINIVAS P	Srinivasa.p.06@gmail.com	17/04/13	9741390731	2013-07-24 06:23:21.544652+00	One classroom is good. Anther class do the repair	3415
3124	1	36273	1	t	SRINIVAS P	Srinivasa.p.06@gmail.com	17/04/13	9741390731	2013-07-24 06:23:21.561367+00	NA	3416
3125	1	35940	1	t	SRINIVAS P	Srinivasa.p.06@gmail.com	16/04/13	9741390731	2013-07-24 06:23:21.578075+00	Pukka rooms there but rains come  leakage of the water..	3417
3126	1	35939	1	t	SRINIVAS P	Srinivasa.p.06@gmail.com	17/04/13	9741390731	2013-07-24 06:23:21.594795+00	Play ground is so far.	3418
3127	1	35941	1	t	SRINIVAS P	Srinivasa.p.06@gmail.com	16/04/13	9741390731	2013-07-24 06:23:21.611695+00	One teacher has going to SSLC exam duty.	3419
3128	1	35935	1	t	SRINIVAS P	Srinivasa.p.06@gmail.com	16/04/13	9741390731	2013-07-24 06:23:21.628632+00	Library books are there but due to election so shifted the books.	3420
3129	1	35936	1	t	SRINIVAS P	Srinivasa.p.06@gmail.com	16/04/13	9741390731	2013-07-24 06:23:21.662404+00	I observe the prepare for midday meals, Ramp facility is not good.	3422
3130	1	35932	1	t	SRINIVAS P	Srinivasa.p.06@gmail.com	15/04/13	9741390731	2013-07-24 06:23:21.679344+00	Boys toilet is there but Girls toilet is not there.	3423
3131	1	35931	1	t	SRINIVAS P	Srinivasa.p.06@gmail.com	15/04/13	9731390731	2013-07-24 06:23:21.697822+00	Only one teacher in this school, so all classes maintenance in one classroom.	3424
3132	1	35933	1	t	SRINIVAS P	Srinivasa.p.06@gmail.com	15/04/13	9741390731	2013-07-24 06:23:21.83485+00	Only one teacher in this school, so all classes maintenance in one classroom.	3425
3133	1	35949	1	t	SRINIVAS P	Srinivasa.p.06@gmail.com	15/04/13	9741390731	2013-07-24 06:23:21.85203+00	Ration has finished so not prepare the midday meals that day.	3426
3134	1	36235	1	t	SRINIVAS P	Srinivasa.p.06@gmail.com	12/04/13	9741390731	2013-07-24 06:23:21.869105+00	Not finished compound work. Little bit place for the playground.	3427
3135	1	35950	1	t	SRINIVAS P	Srinivasa.p.06@gmail.com	12/04/13	9741390731	2013-07-24 06:23:21.885885+00	NA	3428
3136	1	35944	1	t	SRINIVAS P	Srinivasa.p.06@gmail.com	10/04/13	9741390731	2013-07-24 06:23:21.90282+00	Playground is there.	3429
3137	1	36237	1	t	SRINIVAS P	Srinivasa.p.06@gmail.com	10/04/13	9741390731	2013-07-24 06:23:21.919695+00	NA	3430
3138	1	35952	1	t	SRINIVAS P	Srinivasa.p.06@gmail.com	10/04/13	9741390731	2013-07-24 06:23:21.936543+00	Childrens have a taken a lunch i will see. One teacher gone to the SSLC exam duty. Teacher maimntenece the Library.	3431
3139	1	35953	1	t	SRINIVAS P	Srinivasa.p.06@gmail.com	10/04/13	9741390731	2013-07-24 06:23:21.953379+00	One teacher has gone to the office work so another one teacher combined the all classes.	3432
3140	1	36236	1	t	SRINIVAS P	Srinivasa.p.06@gmail.com	09/04/13	9741390731	2013-07-24 06:23:21.970043+00	Library teacher is not there, not anyone room pucca.	3433
3141	1	36204	1	t	SRINIVAS P	Srinivasa.p.06@gmail.com	09/04/13	9741390731	2013-07-24 06:23:22.004107+00	One teacher has gone to the SSLC exam duty so another one teacher combined the all classes. Two classroom not in one compound	3435
3142	1	35954	1	t	SRINIVAS P	Srinivasa.p.06@gmail.com	08/04/13	9741390731	2013-07-24 06:23:22.020869+00	Drinking water facility is not there. They brought bore-well water. Observe the preparing the good.	3436
3143	1	35959	1	t	SRINIVAS P	Srinivasa.p.06@gmail.com	08/04/13	9741390731	2013-07-24 06:23:22.037561+00	For agricultural fare day 20 childrens send.	3437
3144	1	36247	1	t	SRINIVAS P	Srinivasa.p.06@gmail.com	08/04/13	9741390731	2013-07-24 06:23:22.054453+00	Teacher went to exam duty.	3438
3145	1	36233	1	t	SRINIVAS P	Srinivasa.p.06@gmail.com	08/04/13	9741390731	2013-07-24 06:23:22.071172+00	NA	3439
3146	1	35921	1	t	MANJUNATH N	manju2mm143@gmail.com	09/04/13	8861303207	2013-07-24 06:23:22.551332+00	all classes separate  rooms. Above 50 percent childrens attendance.	3467
3147	1	36194	1	t	MANJUNATH N	manju2mm143@gmail.com	09/04/13	8861303207	2013-07-24 06:23:22.56794+00	All classes separate room but 4th std sitting outside.	3468
3148	1	35915	1	t	MANJUNATH N	manju2mm143@gmail.com	13/04/13	8861303207	2013-07-24 06:23:22.58479+00	All classes separate room but not separate HM room.	3469
3149	1	35911	1	t	MANJUNATH N	manju2mm143@gmail.com	13/04/13	8861303207	2013-07-24 06:23:22.601408+00	Sports materials is not there. No separate room for HM & childrens	3470
3150	1	35909	1	t	MANJUNATH N	manju2mm143@gmail.com	13/04/13	8861303207	2013-07-24 06:23:22.618508+00	Teacher shortage in this school.	3471
3151	1	35910	1	t	MANJUNATH N	manju2mm143@gmail.com	13/04/13	8861303207	2013-07-24 06:23:22.635416+00	There is water sump but no water facility, water collection pipe repair	3472
3152	1	36229	1	t	MANJUNATH N	manju2mm143@gmail.com	15/04/13	8861303207	2013-07-24 06:23:22.652163+00	Single teacher is there & above 85 percent attendance is in this school.	3473
3153	1	36230	1	t	MANJUNATH N	manju2mm143@gmail.com	15/04/13	8861303207	2013-07-24 06:23:22.668901+00	For in this childrens attendance is more, no playground is there & no separate HM room.	3474
3154	1	36228	1	t	Thimmarayappa m	Thimmarayappa81@gmail.com	08/04/13	9902500422	2013-07-24 06:23:22.685617+00	School teachers are taken the in charge for the library.one techer is absent,children strength is  very less in the school.	3475
3155	1	36226	1	t	Thimmarayappa m	Thimmarayappa81@gmail.com	08/04/13	9902500422	2013-07-24 06:23:22.702309+00	No play ground , teacher are look after the library and one teacher was absent that day.	3476
3156	1	36003	1	t	Thimmarayappa m	Thimmarayappa81@gmail.com	08/04/13	9902500422	2013-07-24 06:23:22.719202+00	NA	3477
3157	1	36094	1	t	Thimmarayappa m	Thimmarayappa81@gmail.com	08/04/13	9902500422	2013-07-24 06:23:22.735845+00	Clasrooms are combained	3478
3158	1	35974	1	t	Thimmarayappa m	Thimmarayappa81@gmail.com	09/04/13	9902500422	2013-07-24 06:23:22.752648+00	In this school nalikali childrens are more but teachers not maintaining the discipline .	3479
3159	1	36207	1	t	Thimmarayappa m	Thimmarayappa81@gmail.com	09/04/13	9902500422	2013-07-24 06:23:22.769354+00	Here 2 classrooms 3 teacher side flour level building floor level equal.	3480
3160	1	36248	1	t	MANJUNATHA C	manjunath85c@gmail.com	08/04/13	8861303203	2013-07-24 06:23:23.619629+00	They done the some rooms demalation and construction the new rooms	3526
3161	1	35974	1	t	Thimmarayappa m	Thimmarayappa81@gmail.com	09/04/13	9902500422	2013-07-24 06:23:22.78616+00	In this school have a good sufficient 6+1 rooms and good playground compound separate toilet kitchen library and good playing thing also.	3481
3162	1	36097	1	t	Thimmarayappa m	Thimmarayappa81@gmail.com	09/04/13	9902500422	2013-07-24 06:23:22.803883+00	Pucca building but not in a good condition. Toilet condition is not good to use	3482
3163	1	35975	1	t	Thimmarayappa m	Thimmarayappa81@gmail.com	09/04/13	9902500422	2013-07-24 06:23:22.820907+00	In this school have 3 rooms , play ground compound drinkingwater separate toilet and good plaything and learning materials have.	3483
3164	1	35973	1	t	Thimmarayappa m	Thimmarayappa81@gmail.com	10/04/13	9902500422	2013-07-24 06:23:22.838797+00	3rooms and four teachers is there. Akshaya pathra foundation providing for the food for this school.	3484
3165	1	35980	1	t	Thimmarayappa m	Thimmarayappa81@gmail.com	10/04/13	9902500422	2013-07-24 06:23:22.857308+00	IN this school have 2 rooms , play ground compound drinkingwater separate toilet and good plaything and learning materials have.	3485
3166	1	35981	1	t	Thimmarayappa m	Thimmarayappa81@gmail.com	10/04/13	9902500422	2013-07-24 06:23:22.87422+00	2 techers 2classroom.1,2,3one room 4,5one room.	3486
3167	1	35983	1	t	Thimmarayappa m	Thimmarayappa81@gmail.com	10/04/13	9902500422	2013-07-24 06:23:22.890962+00	IN this school have 7 rooms , play ground compound drinkingwater separate toilet and good plaything and learning materials have.	3487
3168	1	35982	1	t	Thimmarayappa m	Thimmarayappa81@gmail.com	12/04/13	9902500422	2013-07-24 06:23:22.907796+00	This school look like as home.	3488
3169	1	35979	1	t	Thimmarayappa m	Thimmarayappa81@gmail.com	13/04/13	9902500422	2013-07-24 06:23:22.924814+00	2 techers 2classroom.1,2,3one room 4,5one room.	3489
3170	1	35984	1	t	Thimmarayappa m	Thimmarayappa81@gmail.com	13/04/13	9902500422	2013-07-24 06:23:22.941569+00	3rooms and 2 teachers is there.	3490
3171	1	35977	1	t	Thimmarayappa m	Thimmarayappa81@gmail.com	15/04/13	9902500422	2013-07-24 06:23:22.958253+00	This not facing the any problem. Every thing is good there.	3491
3172	1	35976	1	t	Thimmarayappa m	Thimmarayappa81@gmail.com	15/04/13	9902500422	2013-07-24 06:23:22.975472+00	IN this school have 6 rooms , play ground compound drinkingwater separate toilet and good plaything and learning materials have.	3492
3173	1	36093	1	t	Muniraja M		15/04/13	8861303209	2013-07-24 06:23:25.186283+00	There is no play ground for this school no separate office room also	3622
3174	1	36209	1	t	Thimmarayappa m	Thimmarayappa81@gmail.com	15/03/13	9902500422	2013-07-24 06:23:22.993984+00	IN this school have 2pucca  rooms&half puccaroom , play ground compound drinkingwater separate toilet and good plaything and learning materials have.	3493
3175	1	36211	1	t	Thimmarayappa m	Thimmarayappa81@gmail.com	16/04/13	9902500422	2013-07-24 06:23:23.012571+00	If rain comes building liq age and this school have a good playground compound library.	3494
3176	1	36221	1	t	Thimmarayappa m	Thimmarayappa81@gmail.com	16/04/13	9902500422	2013-07-24 06:23:23.031211+00	IN this school have 6 rooms , play ground compound drinkingwater separate toilet and good plaything and learning materials have.	3495
3177	1	36208	1	t	Thimmarayappa m	Thimmarayappa81@gmail.com	17/04/13	9902500422	2013-07-24 06:23:23.050894+00	In this school have a 3 rooms. This not have a compound and no separate hm room.	3496
3178	1	36007	1	t	Thimmarayappa m	Thimmarayappa81@gmail.com	17/04/13	9902500422	2013-07-24 06:23:23.069928+00	This school not for full pucca. There is no separate hm rooms . And there is a good library and drink water fecility .	3497
3179	1	36192	1	t	Thimmarayappa m	Thimmarayappa81@gmail.com	17/04/13	9902500422	2013-07-24 06:23:23.088717+00	IN this school have 6 rooms , play ground compound drinkingwater separate toilet and good plaything and learning materials have.	3498
3180	1	36649	1	t	Thimmarayappa m	Thimmarayappa81@gmail.com	06/04/13	9902500422	2013-07-24 06:23:23.107521+00	No compound for this school.	3499
3181	1	36227	1	t	Thimmarayappa m	Thimmarayappa81@gmail.com	04/06/13	9902500422	2013-07-24 06:23:23.126144+00	Subject teacher are the library in charge.	3500
3182	1	36133	1	t	MANJUNATHA C	manjunath85c@gmail.com	09/04/13	8861303203	2013-07-24 06:23:23.144841+00	2 techers 2classroom.1,2,3one room 4,5one room.	3501
3183	1	36131	1	t	MANJUNATHA C	manjunath85c@gmail.com	09/04/13	8861303203	2013-07-24 06:23:23.163701+00	2 techers 2classroom.1,2,3one room 4,5one room.	3502
3184	1	36126	1	t	MANJUNATHA C	manjunath85c@gmail.com	09/04/13	8861303203	2013-07-24 06:23:23.18226+00	in this school no for boys toilet.	3503
3185	1	36127	1	t	MANJUNATHA C	manjunath85c@gmail.com	09/04/13	8861303203	2013-07-24 06:23:23.201114+00	2 techers 2classroom.1,2,3one room 4,5one room.	3504
3186	1	36129	1	t	MANJUNATHA C	manjunath85c@gmail.com	10/04/13	8861303203	2013-07-24 06:23:23.219706+00	in this school including crc center and anganwadi aslo.	3505
3187	1	36125	1	t	MANJUNATHA C	manjunath85c@gmail.com	09/04/13	8861303203	2013-07-24 06:23:23.238413+00	In this have a rooms shortage . 5&6 sit in combained class	3506
3188	1	36134	1	t	MANJUNATHA C	manjunath85c@gmail.com	10/04/13	8861303203	2013-07-24 06:23:23.257004+00	No compound for this school.	3507
3189	1	36128	1	t	MANJUNATHA C	manjunath85c@gmail.com	10/04/13	8861303203	2013-07-24 06:23:23.275801+00	Classrooms shortage is this school.	3508
3190	1	36121	1	t	MANJUNATHA C	manjunath85c@gmail.com	09/04/13	8861303203	2013-07-24 06:23:23.294463+00	Only two teachers is there.	3509
3191	1	36122	1	t	MANJUNATHA C	manjunath85c@gmail.com	09/04/13	8861303203	2013-07-24 06:23:23.313262+00	Drinking water problem is there.	3510
3192	1	36132	1	t	MANJUNATHA C	manjunath85c@gmail.com	09/04/13	8861303203	2013-07-24 06:23:23.3319+00	In this school have a good felicities.	3511
3193	1	36130	1	t	MANJUNATHA C	manjunath85c@gmail.com	09/04/13	8861303203	2013-07-24 06:23:23.350729+00	In this school have a good felicities.	3512
3194	1	36126	1	t	MANJUNATHA C	manjunath85c@gmail.com	09/04/13	8861303203	2013-07-24 06:23:23.36925+00	Compound not completed	3513
3195	1	36124	1	t	MANJUNATHA C	manjunath85c@gmail.com	09/04/13	8861303203	2013-07-24 06:23:23.388156+00	Rooms are in good condition.	3514
3196	1	36024	1	t	MANJUNATHA C	manjunath85c@gmail.com	08/04/13	8861303203	2013-07-24 06:23:23.406874+00	In this school had a good condition is good.	3515
3197	1	36017	1	t	MANJUNATHA C	manjunath85c@gmail.com	08/04/13	8861303203	2013-07-24 06:23:23.425553+00	for this school no kitchen room but kannda school suppling the lunch for this school.	3516
3198	1	36014	1	t	MANJUNATHA C	manjunath85c@gmail.com	08/04/13	8861303203	2013-07-24 06:23:23.444009+00	in this school no for boys toilet.	3517
3199	1	36016	1	t	MANJUNATHA C	manjunath85c@gmail.com	08/04/13	8861303203	2013-07-24 06:23:23.46269+00	No own building for this school and there is no boys toilet	3518
3200	1	36023	1	t	MANJUNATHA C	manjunath85c@gmail.com	08/04/13	8861303203	2013-07-24 06:23:23.48403+00	Toilet facility only for the girls not for the boys.	3519
3201	1	36020	1	t	MANJUNATHA C	manjunath85c@gmail.com	06/04/13	8861303203	2013-07-24 06:23:23.502864+00	Toilet facility only for the girls not for the boys.	3520
3202	1	36022	1	t	MANJUNATHA C	manjunath85c@gmail.com	10/04/13	8861303203	2013-07-24 06:23:23.521692+00	Toilet facility only for the girls not for the boys.	3521
3203	1	36015	1	t	MANJUNATHA C	manjunath85c@gmail.com	10/04/13	8861303203	2013-07-24 06:23:23.541275+00	NO separate room for the hm. And 4&5 combined class.	3522
3204	1	36029	1	t	MANJUNATHA C	manjunath85c@gmail.com	06/04/13	8861303203	2013-07-24 06:23:23.56092+00	Construction on runnings is there	3523
3206	1	36021	1	t	MANJUNATHA C	manjunath85c@gmail.com	08/04/13	8861303203	2013-07-24 06:23:23.59964+00	NO Play ground .	3525
3207	1	36025	1	t	SHIVANNA P.L	shivannapl1993@gmail.com	06/04/13	8861303211	2013-07-24 06:23:23.64052+00	2room pucca and no play ground	3527
3208	1	36029	1	t	SHIVANNA P.L	shivannapl1993@gmail.com	06/04/13	8861303211	2013-07-24 06:23:23.658658+00	5rooms pucca and separate room for the teachers and library fecility is there.	3528
3209	1	36026	1	t	SHIVANNA P.L	shivannapl1993@gmail.com	06/04/13	8861303211	2013-07-24 06:23:23.677034+00	Childrens strenght is so less. Not toilet is there.	3529
3210	1	36185	1	t	SHIVANNA P.L	shivannapl1993@gmail.com	06/04/13	8861303211	2013-07-24 06:23:23.695149+00	NO separate room for the hm. And toilet for boys and girls.	3530
3211	1	36129	1	t	SHIVANNA P.L	shivannapl1993@gmail.com	07/04/13	8861303211	2013-07-24 06:23:23.713394+00	Kannada and urdu school have in one compound not separate rooms for boys and girls.	3531
3212	1	35875	1	t	SHIVANNA P.L	shivannapl1993@gmail.com	07/04/13	8861303211	2013-07-24 06:23:23.731615+00	Every classroom had a separate classroom	3532
3213	1	35879	1	t	SHIVANNA P.L	shivannapl1993@gmail.com	08/04/13	8861303211	2013-07-24 06:23:23.75004+00	Rooms shortage for in this school.	3533
3214	1	35880	1	t	SHIVANNA P.L	shivannapl1993@gmail.com	08/04/13	8861303211	2013-07-24 06:23:23.76801+00	Rooms shortage for in this school.	3534
3215	1	36070	1	t	SHIVANNA P.L	shivannapl1993@gmail.com	08/04/13	8861303211	2013-07-24 06:23:23.786088+00	6rooms is there both chilren are using the same toilet no separate	3535
3216	1	36187	1	t	SHIVANNA P.L	shivannapl1993@gmail.com	08/04/13	8861303211	2013-07-24 06:23:23.803991+00	2 techers is there but classes are running in the same room separate toilets is there but not in clean.	3536
3217	1	36186	1	t	SHIVANNA P.L	shivannapl1993@gmail.com	05/04/13	8861303211	2013-07-24 06:23:23.821896+00	All facilities is there but not separate room for teachers.	3537
3218	1	36028	1	t	SHIVANNA P.L	shivannapl1993@gmail.com	05/04/13	8861303211	2013-07-24 06:23:23.839966+00	Only one room in this school. No compound	3538
3219	1	35884	1	t	SHIVANNA P.L	shivannapl1993@gmail.com	10/04/13	8861303211	2013-07-24 06:23:23.858504+00	2 techers 2classroom.1,2,3one room 4,5one room.	3539
3220	1	35883	1	t	SHIVANNA P.L	shivannapl1993@gmail.com	10/04/13	8861303211	2013-07-24 06:23:23.876484+00	In this school 5rooms separate kitchen and teachers separate also is there.	3540
3221	1	35881	1	t	SHIVANNA P.L	shivannapl1993@gmail.com	NA	8861303211	2013-07-24 06:23:23.894671+00	NO Play ground & not water facility also there .	3541
3222	1	35882	1	t	SHIVANNA P.L	Shivannapl1993@gmail.com	13/04/13	8861303211	2013-07-24 06:23:23.912594+00	NO compound for this school. there is a teachers separate room&library , computer training also.	3542
3223	1	36129	1	t	SHIVANNA P.L	Shivannapl1993@gmail.com	15/04/13	8861303211	2013-07-24 06:23:23.930737+00	Same compound for the urdu and medium both no separate toilet for boys &girls.	3543
3224	1	36137	1	t	SHIVANNA P.L	Shivannapl1993@gmail.com	15/04/13	8861303211	2013-07-24 06:23:23.948579+00	No water facility in the toilet in that school no separate room for the hms.	3544
3225	1	35875	1	t	SHIVANNA P.L	Shivannapl1993@gmail.com	10/04/13	8861303211	2013-07-24 06:23:23.966565+00	No library facility in that school. No separate toilet for the boys and girls.	3545
3226	1	36030	1	t	SHIVANNA P.L	Shivannapl1993@gmail.com	10/04/13	8861303211	2013-07-24 06:23:23.984511+00	Only one room in this school. No compound, No toilet no water feclities.	3546
3227	1	36028	1	t	SHIVANNA P.L	Shivannapl1993@gmail.com	05/04/13	8861303211	2013-07-24 06:23:24.002443+00	2  Teachers is there but only one room is there no toilet	3547
3228	1	36190	1	t	SHIVANNA P.L	Shivannapl1993@gmail.com	05/04/13	8861303211	2013-07-24 06:23:24.020546+00	In this separate toilet for boys&girls.	3548
3229	1	36138	1	t	SHIVANNA P.L	Shivannapl1993@gmail.com	09/04/13	8861303211	2013-07-24 06:23:24.038559+00	For in this school no compound and toilet facility. 1To 5th class running in the one room.	3549
3230	1	35876	1	t	SHIVANNA P.L	Shivannapl1993@gmail.com	09/04/13	8861303211	2013-07-24 06:23:24.056623+00	Library computer, toilet facilities are that school.	3550
3231	1	36087	1	t	SHIVARAJA. R	shivaraja10488@gmail.com	15/04/13	9902644822	2013-07-24 06:23:24.074873+00	For in this school only one room and two teachers is there. But playground place is very sufficient is there./	3551
3232	1	36067	1	t	SHIVARAJA. R	shivaraja10488@gmail.com	15/04/13	9902644822	2013-07-24 06:23:24.093032+00	Single teacher is there . And playground place is very big.	3552
3233	1	36076	1	t	SHIVARAJA. R	shivaraja10488@gmail.com	09/04/13	9902644822	2013-07-24 06:23:24.111081+00	11Rooms and 9 teachers is there.	3553
3234	1	36077	1	t	SHIVARAJA. R	shivaraja10488@gmail.com	09/04/13	9902644822	2013-07-24 06:23:24.129197+00	Kannada and urdu school have in one compound.	3554
3235	1	36084	1	t	SHIVARAJA. R	shivaraja10488@gmail.com	09/04/13	9902644822	2013-07-24 06:23:24.147384+00	2Teachers and 2rooms is there.	3555
3236	1	36074	1	t	SHIVARAJA. R	shivaraja10488@gmail.com	09/04/13	9902644822	2013-07-24 06:23:24.165429+00	Only 7 childrens is there. All classes are running in the one room.	3556
3237	1	36079	1	t	SHIVARAJA. R	shivaraja10488@gmail.com	12/04/13	9902644822	2013-07-24 06:23:24.183576+00	This school is a new building but toilet are not ready there.	3557
3238	1	36080	1	t	SHIVARAJA. R	shivaraja10488@gmail.com	10/04/13	9902644822	2013-07-24 06:23:24.201523+00	Single teacher is there .	3558
3239	1	36078	1	t	SHIVARAJA. R	shivaraja10488@gmail.com	10/04/13	9902644822	2013-07-24 06:23:24.219372+00	3rooms and 3 teachers is there.	3559
3240	1	36068	1	t	SHIVARAJA. R	shivaraja10488@gmail.com	NA	9902644822	2013-07-24 06:23:24.237711+00	This school is a single teacher school. Good learning atmosphere is there.	3560
3241	1	36086	1	t	SHIVARAJA. R	shivaraja10488@gmail.com	08/04/13	9902644822	2013-07-24 06:23:24.2558+00	for in this school only one room and 2 teacher is there.	3561
3242	1	36085	1	t	SHIVARAJA. R	shivaraja10488@gmail.com	08/04/13	9902644822	2013-07-24 06:23:24.273808+00	3rooms and 2 teachers is there.	3562
3243	1	36087	1	t	SHIVARAJA. R	shivaraja10488@gmail.com	08/04/13	9902644822	2013-07-24 06:23:24.291531+00	3rooms  is there.	3563
3244	1	36241	1	t	SHIVARAJA. R	shivaraja10488@gmail.com	15/04/13	9902644822	2013-07-24 06:23:24.309852+00	For in this school 4teachers and 4 rooms is there.	3564
3245	1	36245	1	t	SHIVARAJA. R	shivaraja10488@gmail.com	15/04/13	9902644822	2013-07-24 06:23:24.328179+00	SIngle teacher is there .	3565
3246	1	36240	1	t	SHIVARAJA. R	shivaraja10488@gmail.com	15/04/13	9902644822	2013-07-24 06:23:24.346113+00	Each class have a individual room. And 4 teacher is there.very large playground is there.	3566
3247	1	36239	1	t	SHIVARAJA. R	shivaraja10488@gmail.com	15/04/13	9902644822	2013-07-24 06:23:24.363839+00	2 teacher and 2rooms is there. Drinking water problem is there.	3567
3248	1	36246	1	t	SHIVARAJA. R	shivaraja10488@gmail.com	15/04/13	9902644822	2013-07-24 06:23:24.382095+00	For in this have 4 rooms and good atmosphere is there.	3568
3249	1	36242	1	t	SHIVARAJA. R	shivaraja10488@gmail.com	15/04/13	9902644822	2013-07-24 06:23:24.399953+00	SIngle teacher is there .	3569
3250	1	35877	1	t	SHIVARAJA. R	shivaraja10488@gmail.com	16/04/13	9902644822	2013-07-24 06:23:24.418269+00	No compound for this school.	3570
3369	1	20246	1	t	SHAILA K.H	shailakh1080@gmail.com	18/4/2013	9900045528	2013-10-01 06:07:40.777191+00	None	3693
3251	1	36031	1	t	SHIVARAJA. R	shivaraja10488@gmail.com	16/04/13	9902644822	2013-07-24 06:23:24.436417+00	In this school combined classes. And 3 teachers is there.	3571
3252	1	35878	1	t	SHIVARAJA. R	shivaraja10488@gmail.com	16/04/13	9902644822	2013-07-24 06:23:24.454668+00	In this school 1to 7th class but only five rooms is there and 4 teachers.	3572
3253	1	36244	1	t	SHIVARAJA. R	shivaraja10488@gmail.com	16/04/13	9902644822	2013-07-24 06:23:24.474881+00	Each class have a seprate room. Good atmosphere is there.	3573
3254	1	33436	1	t	Kriti Chawla	kjhfgfdsafg	01/11/2013	0987654	2013-11-08 13:03:32.974455+00	\N	3962
3255	1	36219	1	t	Harish Babu	003hari007babu@gmail.com	16/04/13	9901900322	2013-07-24 06:23:24.493168+00	In this school have a 6 pucca rooms.Good compound and play ground. Separate toilet  drinking water facility is there	3574
3256	1	36201	1	t	Harish Babu	003hari007babu@gmail.com	16/04/13	9901900322	2013-07-24 06:23:24.511371+00	In this school have a 4 rooms  separate toilets is there.library books all so is there	3575
3257	1	36195	1	t	Harish Babu	003hari007babu@gmail.com	09/04/13	9901900322	2013-07-24 06:23:24.529561+00	In this school 4 rooms in center of the village and 4 rooms is out side of the village this school library all so there	3576
3258	1	36225	1	t	Harish Babu	003hari007babu@gmail.com	09/04/13	9901900322	2013-07-24 06:23:24.547776+00	In this school have a 7 rooms play ground compound  and separate toilets.  Library also is there.	3577
3259	1	36198	1	t	Harish Babu	003hari007babu@gmail.com	08/04/13	9901900322	2013-07-24 06:23:24.566116+00	In this school 2 rooms in pucca and one room is half pucca. Play ground Compound  &separate toilet and drinking water library  facility is there	3578
3260	1	36202	1	t	Harish Babu	003hari007babu@gmail.com	08/04/13	9901900322	2013-07-24 06:23:24.580099+00	In this school 3 rooms in pucca one rooms is half pucca  compound play ground separte toiler for  boys girls . Good play thing is there.	3579
3261	1	36214	1	t	Harish Babu	003hari007babu@gmail.com	08/04/13	9901900322	2013-07-24 06:23:24.592603+00	In this school have a 3 rooms play ground compound separate library. Toilet drinking  water good facility is there.	3580
3262	1	36197	1	t	Harish Babu	003hari007babu@gmail.com	08/04/13	9901900322	2013-07-24 06:23:24.636705+00	In this school have a 2 rooms library, play ground, compound. separate Toilet drinking water good facility is there.	3581
3263	1	36199	1	t	Harish Babu	003hari007babu@gmail.com	06/04/13	9901900322	2013-07-24 06:23:24.649815+00	In this school have a 2 rooms. library play ground compound  and 3 teacher is there. Toilet drinking water good facility is there.	3582
3264	1	36231	1	t	Harish Babu	003hari007babu@gmail.com	06/04/13	9901900322	2013-07-24 06:23:24.662977+00	In this school 2 rooms 2 all so pucca. Library Play ground compound separat Toilet drinking water good facility is there.	3583
3265	1	36203	1	t	Harish Babu	003hari007babu@gmail.com	09/04/13	9901900322	2013-07-24 06:23:24.676286+00	In this school 6 pucca rooms 2 semi pucca.  Play ground compound separate Toilet Drinking water facility is there.	3584
3266	1	35891	1	t	Harish Babu	003hari007babu@gmail.com	10/04/13	9901900322	2013-07-24 06:23:24.689693+00	In this school 6 pucca library Play ground compound separate-toilet Drinking water facility is there.	3585
3267	1	35892	1	t	Harish Babu	003hari007babu@gmail.com	10/04/13	9901900322	2013-07-24 06:23:24.703149+00	In this school 2 rooms in pucca. Library Playground Compound  separate toilet and drinking water facility is there.	3586
3268	1	35889	1	t	Harish Babu	003hari007babu@gmail.com	16/01/13	9901900322	2013-07-24 06:23:24.715996+00	In this school 2 rooms in pucca. LibraryPlay  ground Compound  separate toilet and drinking water  facility is there and library is there not have in this school handicapped ramp.	3587
3269	1	36188	1	t	Harish Babu	003hari007babu@gmail.com	16/01/13	9901900322	2013-07-24 06:23:24.727919+00	In this school 3 rooms in pucca. Library Play  ground Compound  separate toilet and drinking water facility is there.	3588
3270	1	35887	1	t	Harish Babu	003hari007babu@gmail.com	15/04/13	9901900322	2013-07-24 06:23:24.739789+00	In this school 2 rooms in pucca. Libary Play  ground Compond  separte toilet and drinking water facility is there. This school kitchen combained with kannada school./	3589
3271	1	35888	1	t	Harish Babu	003hari007babu@gmail.com	15/04/13	9901900322	2013-07-24 06:23:24.751738+00	In this school 4 rooms in pucca. Libary Play  ground Compond  separte toilet and drinking water facility is there	3590
3272	1	35886	1	t	Harish Babu	003hari007babu@gmail.com	15/04/13	9901900322	2013-07-24 06:23:24.763713+00	In this school 5 rooms in pucca.  LibraryPlayground Compound  separate toilet and drinking water facility is there.	3591
3273	1	35885	1	t	Harish Babu	003hari007babu@gmail.com	15/04/13	9901900322	2013-07-24 06:23:24.775528+00	In this school  4 rooms in pucca. Library Play  ground Compound  separate toilet and drinking water facility is there library all facility is there.s	3592
3274	1	35893	1	t	Harish Babu	003hari007babu@gmail.com	10/04/13	9901900322	2013-07-24 06:23:24.788583+00	In this school  1 rooms in pucca. Library Play  ground Compound  separate toilet and drinking water facility is there library all facility is there	3593
3275	1	35894	1	t	Harish Babu	003hari007babu@gmail.com	10/04/13	9901900322	2013-07-24 06:23:24.801733+00	In this school  3 rooms in pucca. Library Play  ground Compound  separate toilet and drinking water facility is there library all facility is there.	3594
3276	1	35902	1	t	Harish Babu	003hari007babu@gmail.com	09/04/13	9901900322	2013-07-24 06:23:24.815053+00	In this school  6 rooms in pucca. Library Play  ground Compound  separate toilet and drinking water facility is there library all facility is there.	3595
3277	1	35963	1	t	Muniraja M		16/04/82013	8861303209	2013-07-24 06:23:24.828014+00	There are only few childrens attended today more childrens are attended. Lunch home after lunch they went tohome.	3596
3278	1	35964	1	t	Muniraja M		16/04/13	8861303209	2013-07-24 06:23:24.841072+00	Mid day meal is prepared in one kitchen for two school Kannada and urdu school became kannada school H.M only attend the school	3597
3279	1	35965	1	t	Muniraja M		16/04/13	8861303209	2013-07-24 06:23:24.854138+00	In this school 4 & 5th std class students learning at anganwadi building one room is constuction newly so 4 & 5 students are sitting in anganwadi building.	3598
3280	1	35966	1	t	Muniraja M		17/04/13	8861303209	2013-07-24 06:23:24.867287+00	CRC  Center is used as head master room seperaty. OLd building is not using new building is used for class ooms.	3599
3281	1	35970	1	t	Muniraja M		16/04/13	8861303209	2013-07-24 06:23:24.880396+00	Samlaiah the head master in the school all the students attend the school and playing games.	3600
3282	1	35969	1	t	Muniraja M		16/04/13	8861303209	2013-07-24 06:23:24.893447+00	Taluk panchayath member manjuntha provided the “Ranga Mardira” for this school newly contracted building is also contracted by are manjuntha.	3601
3283	1	36297	1	t	Muniraja M		08/04/13	8861303209	2013-07-24 06:23:24.912007+00	One single room is pucca building remaining 4 class rooms are pucca building. Mid day meal prepared in GUHPS in same compound (Attatched)	3602
3284	1	36091	1	t	Muniraja M		08/04/13	8861303209	2013-07-24 06:23:24.924863+00	There is on sufficent class room in this school. Head master has a separate room for office that is mid day meal store room.	3603
3285	1	36089	1	t	Muniraja M		08/04/13	8861303209	2013-07-24 06:23:24.937615+00	Head miss told me that mid day meal is pepared for two school (Kannada school and Urdu school) in one kitchen	3604
3286	1	36107	1	t	Muniraja M		08/04/13	8861303209	2013-07-24 06:23:24.950412+00	Almost all students are attend the school this day single teacher in there in this school.	3605
3287	1	35967	1	t	Muniraja M		17/04/13	8861303209	2013-07-24 06:23:24.96308+00	One room Has stone roofing. Another room has sheet roofing. Only two rooms are there. Head master attending the school.	3606
3288	1	35958	1	t	Muniraja M		17/04/13	8861303209	2013-07-24 06:23:24.975947+00	Head master nataraj k.m is in school childrens playing cricket. Games after afternoon mid day meals let up the school.	3607
3289	1	35971	1	t	Muniraja M		17/04/13	8861303209	2013-07-24 06:23:24.988297+00	I observed the kitchen room cooking mid day meal there is on any waste i observed students sat with disciline playing games.	3608
3290	1	35957	1	t	Muniraja M		17/04/13	8861303209	2013-07-24 06:23:25.000798+00	There is big play ground in school compound but there is separate class room for every class.	3609
3291	1	35985	1	t	Muniraja M		09/04/13	8861303209	2013-07-24 06:23:25.013225+00	There are two separate building for this school one room has compound another building has not compound.	3610
3292	1	36104	1	t	Muniraja M		09/04/13	8861303209	2013-07-24 06:23:25.026151+00	There is one sufficient toilets for childrens There are only 2 toilets 1 for girls and 1 for boys students number is more so toilets are less school compound is good and play ground is all available also.	3611
3293	1	36088	1	t	Muniraja M		09/04/13	8861303209	2013-07-24 06:23:25.038872+00	Four classroom are pucca building one room sami pucca roofing sheet building.	3612
3294	1	36103	1	t	Muniraja M		09/04/13	8861303209	2013-07-24 06:23:25.051816+00	One room pucca building nali kali and kitchen room are semi pucca building.	3613
3295	1	36102	1	t	Muniraja M		10/04/13	8861303209	2013-07-24 06:23:25.064547+00	There is a very attractive flower garden in front of the classroom. Teacher maintained the garden when i visit this school childrens playing carrom board games.	3614
3296	1	36099	1	t	Muniraja M		10/04/13	8861303209	2013-07-24 06:23:25.077527+00	There is only one toilet for all students no separate toilets for boys and girls. Temple also is there in compound	3615
3297	1	36098	1	t	Muniraja M		10/04/13	8861303209	2013-07-24 06:23:25.09027+00	In this school toilets are not cleaned the way to toilets is look like forest some plants ae there in front of the toilets.	3616
3298	1	36100	1	t	Muniraja M			8861303209	2013-07-24 06:23:25.102995+00	One room roof with sheets (R C )another room is newly construction new building very neat and attractive.	3617
3299	1	36101	1	t	Muniraja M		15/04/13	8861303209	2013-07-24 06:23:25.116529+00	Compound construction is going on yet not complete . In front side road is there so compound is not so good.	3618
3300	1	36092	1	t	Muniraja M		15/04/13	8861303209	2013-07-24 06:23:25.134559+00	One classroom roof of tiles. One classroom roof of sheets remaining newly constraction building.	3619
3301	1	36105	1	t	Muniraja M		15/04/13	8861303209	2013-07-24 06:23:25.152025+00	There is on sufficient classroom in this school but students number is less so 3 room are used as class rooms. One room for computer room.	3620
3302	1	36106	1	t	Muniraja M		15/04/13	8861303209	2013-07-24 06:23:25.169208+00	Before Nov 2012 this school has not compound. Now school compound is constructed Only two rooms are there.	3621
3303	1	35913	1	t	Manjunatha N	manjuzmm143@gmail.com	09/04/13	8861303207	2013-07-24 06:23:25.203436+00	In this school 1 to 3 one room 4 & 5 one room 6 & 7 one room. The considered class room has a H.M room.	3623
3304	1	35918	1	t	Manjunatha N	manjuzmm143@gmail.com	09/04/13	8861303207	2013-07-24 06:23:25.220344+00	In this school1 to 3 one room 4 to 5 one room and compound not finished  because finance problem .	3624
3305	1	35914	1	t	Manjunatha N	manjuzmm143@gmail.com	09/04/13	8861303207	2013-07-24 06:23:25.237409+00	In this school only one room is there and 2 teachers	3625
3306	1	35927	1	t	Manjunatha N	manjuzmm143@gmail.com	15/04/13	8861303207	2013-07-24 06:23:25.27136+00	Regularly parents give visited in this school.	3627
3307	1	35926	1	t	Manjunatha N	manjuzmm143@gmail.com	15/04/13	8861303207	2013-07-24 06:23:25.287343+00	In this school rooms shortage 1 to 3 one room 4 & 5 one room.	3628
3308	1	35908	1	t	Manjunatha N	manjuzmm143@gmail.com	10/04/13	8861303207	2013-07-24 06:23:25.3048+00	Rooms shortage for in this school.	3629
3309	1	35912	1	t	Manjunatha N	manjuzmm143@gmail.com	10/04/13	8861303207	2013-07-24 06:23:25.322811+00	In this school no play ground.	3630
3310	1	33823	1	t	P.ARUNSATHYASEELAN	arunsathyaseelan.p@iimb.ernet.in	03/08/2013	8884400675	2013-08-05 07:54:28.506648+00	\N	3632
3311	1	32554	1	t	P.ARUNSATHYASEELAN	arunsathyaseelan.p@iimb.ernet.in	02/08/2013	8884400675	2013-08-05 07:55:47.928984+00	\N	3633
3312	1	32554	1	t	Venkata Rakesh kolli	kollirakesh579@gmail.com	02/08/2013	8095074847	2013-08-05 21:33:08.330418+00	It was a wonderful experience to visit the school, especially the contribution of Akshara towards empowering the school and children is really wonderful. There is no denial of the fact that Akshara programs brought all-round development in the lives of these children. I was surprised to see the enthusiasm of the students to speak and share their experiences with a complete stranger like me.	3634
3313	1	32462	1	t	Arvind V	arvind.venkatadri@gmail.com	01/06/2013	+91-98452-80427	2013-06-02 03:36:15.723553+00	1) Classes 6 and 7 also have an ENGLISH medium class. They are expanding to offer ENGLISH medium in higher classes from next year. ( I helped one of the maidservants who works in our apartment to get her kids admitted here)  2) Volunteering by a group called SHLOK, lead by an IBM-er called Ashwin Venkatesh. ( +91-9902577107) They do English and computers for the younger ones.  3) HM of the High school requested for donations of assets: benches, furniture etc.	3325
3314	1	32552	1	t	Medha Bhattacharya	medha.b95@gmail.com	15/07/2013	\N	2013-08-03 09:10:33.499295+00	I only spent one hour in the afternoons so I am not in a position to answer all these questions. I have put these tick marks based on my observations. 	3631
3315	1	29619	1	t	Asha Sharath	asha@akshara.org.in	28/08/2013	\N	2013-08-28 09:25:34.732229+00	The Anganwadi is quite small. The TLM, children, gas stove, food supplies and utensils occupy the room completely,  leaving no space to walk. Cooking happens in the same room, which is quite dangerous. There is another closed room in the same building that belongs to the MLA. If the MLA can be convinced to give that room to the Anganwadi, it will be quite helpful.	3635
3316	1	32696	1	t	Nirupama.G	nirupama@akshara.org.in	16/09/2013	9741390787	2013-09-19 09:43:31.116235+00	\N	3639
3317	1	32507	1	t	Asha Sharath	asha@akshara.org.in	28/08/2013	\N	2013-08-28 09:31:19.218653+00	More than 50% of the teachers were absent as they had to participate in a Government training. 	3636
3318	1	33158	1	t	Nirupama.G	nirupama@akshara.org.in	18/09/2013	9741390787	2013-09-19 09:10:09.067366+00	In this School,there is no playground. Children can't play and hence there are no physical activities and games .HM & Teachers are very active & supportive,children are also very active.     	3637
3368	1	20245	1	t	SHAILA K.H	shailakh1080@gmail.com	20/4/2013	9900045528	2013-10-01 06:07:40.752685+00	Toilets are not usable.	3691
3319	1	33147	1	t	Nirupama.G	nirupama@akshara.org.in	18/09/2013	9741390787	2013-09-19 09:17:25.416577+00	There is no playground.In one Hall they were 2 Classes being conducted.In front of the HM's table,Nali - Kali ( 1st & 2nd) Classes were taken,they are unable to display any study materials,because the school runs from from morning to afternoon,in the evening it is a Marriage Hall.The school is located in a residential area.         	3638
3320	1	33150	1	t	Nirupama.G	nirupama@akshara.org.in	20/09/2013	9741390787	2013-09-21 09:38:08.546371+00	\N	3640
3321	1	33153	1	t	\N	nirupama@akshara.org.in	20/09/2013	\N	2013-09-21 09:40:31.382144+00	\N	3641
3322	1	32503	1	t	\N	nirupama@akshara.org.in	12/08/2013	\N	2013-09-27 09:07:34.081904+00	\N	3643
3323	1	33157	1	t	\N	nirupama@akshara.org.in	13/08/2013	\N	2013-09-27 09:43:21.175615+00	\N	3644
3324	1	32504	1	t	\N	nirupama@akshara.org.in	21/08/2013	\N	2013-09-27 09:02:58.764619+00	In this School there is no playground,toilets are not clean and the school has a very small compound.Children are unable to play.The main road is just opposite the school making it unsafe for the students.	3642
3325	1	20273	1	t	GOVINDAPPA L.K	rathod11990@gmail.com	15/4/2013	9900045527	2013-10-01 06:07:39.966903+00	Separate room is needed for library.	3645
3326	1	20274	1	t	GOVINDAPPA L.K	rathod11990@gmail.com	15/4/2013	9900045527	2013-10-01 06:07:40.158776+00	School doesn’t have compound wall	3646
3327	1	20149	1	t	GOVINDAPPA L.K	rathod11990@gmail.com	15/4/2013	9900045527	2013-10-01 06:07:40.171294+00	Toilets are not usable	3647
3328	1	20284	1	t	GOVINDAPPA L.K	rathod11990@gmail.com	15/4/2013	9900045527	2013-10-01 06:07:40.184209+00	Toilets are not usable	3648
3329	1	20148	1	t	GOVINDAPPA L.K	rathod11990@gmail.com	16/4/2013	9900045527	2013-10-01 06:07:40.196907+00	Toilets are not usable	3649
3330	1	20159	1	t	GOVINDAPPA L.K	rathod11990@gmail.com	16/4/2013	9900045527	2013-10-01 06:07:40.213978+00	Toilets are not usable  and class room construction is under progress.	3650
3331	1	20158	1	t	GOVINDAPPA L.K	rathod11990@gmail.com	16/4/2013	9900045527	2013-10-01 06:07:40.244857+00	School doesn’t have playground and usable toilets.	3651
3332	1	20153	1	t	GOVINDAPPA L.K	rathod11990@gmail.com	16/4/2013	9900045527	2013-10-01 06:07:40.261993+00	Water tank maintenance is poor.	3652
3333	1	20145	1	t	GOVINDAPPA L.K	rathod11990@gmail.com	17/4/2013	9900045527	2013-10-01 06:07:40.278962+00	Toilets are not usable  and class room construction is under progress.	3653
3334	1	20146	1	t	GOVINDAPPA L.K	rathod11990@gmail.com	17/4/2013	9900045527	2013-10-01 06:07:40.292261+00	Toilets are not usable.	3654
3335	1	20152	1	t	GOVINDAPPA L.K	rathod11990@gmail.com	17/4/2013	9900045527	2013-10-01 06:07:40.304707+00	Class room construction is under progress.	3655
3336	1	20147	1	t	GOVINDAPPA L.K	rathod11990@gmail.com	17/4/2013	9900045527	2013-10-01 06:07:40.316935+00	Toilets are not usable and water tank maintenance is poor.	3656
3337	1	20151	1	t	GOVINDAPPA L.K	rathod11990@gmail.com	18/4/2013	9900045527	2013-10-01 06:07:40.329455+00	Toilets are not usable and water tank maintenance is poor.	3657
3338	1	20157	1	t	GOVINDAPPA L.K	rathod11990@gmail.com	18/4/2013	9900045527	2013-10-01 06:07:40.34202+00	Toilets are not usable and water tank maintenance is poor.	3658
3339	1	20150	1	t	GOVINDAPPA L.K	rathod11990@gmail.com	18/4/2013	9900045527	2013-10-01 06:07:40.354428+00	Two more class rooms are needed for the school.	3659
3340	1	20154	1	t	GOVINDAPPA L.K	rathod11990@gmail.com	18/4/2013	9900045527	2013-10-01 06:07:40.366894+00	Water tank maintenance is poor.	3660
3341	1	20293	1	t	GOVINDAPPA L.K	rathod11990@gmail.com	19/4/2013	9900045527	2013-10-01 06:07:40.379273+00	Everything is fine, this is the model school in the cluster.	3661
3342	1	20286	1	t	GOVINDAPPA L.K	rathod11990@gmail.com	19/4/2013	9900045527	2013-10-01 06:07:40.391632+00	Toilets are not usable.	3662
3343	1	20276	1	t	GOVINDAPPA L.K	rathod11990@gmail.com	20/4/2013	9900045527	2013-10-01 06:07:40.416723+00	There was no drinking water resource at school premises, some one should bring from well.	3664
3344	1	20294	1	t	GOVINDAPPA L.K	rathod11990@gmail.com	20/4/2013	9900045527	2013-10-01 06:07:40.429266+00	Maintenance is not good in the school.	3665
3345	1	20283	1	t	GOVINDAPPA L.K	rathod11990@gmail.com	20/4/2013	9900045527	2013-10-01 06:07:40.441674+00	School has water well in the playground.	3666
3346	1	20292	1	t	GOVINDAPPA L.K	rathod11990@gmail.com	19/4/2013	9900045527	2013-10-01 06:07:40.45423+00	Toilets are not usable.	3667
3347	1	20334	1	t	SHAILA K.H	shailakh1080@gmail.com	17/4/2013	9900045528	2013-10-01 06:07:40.479314+00	There was no toilets and compound wall.	3669
3348	1	20337	1	t	SHAILA K.H	shailakh1080@gmail.com	16/4/2013	9900045528	2013-10-01 06:07:40.491778+00	Toilets are not usable.	3670
3349	1	20335	1	t	SHAILA K.H	shailakh1080@gmail.com	16/4/2013	9900045528	2013-10-01 06:07:40.504373+00	None	3671
3350	1	20339	1	t	SHAILA K.H	shailakh1080@gmail.com	16/4/2013	9900045528	2013-10-01 06:07:40.516812+00	Teachers and children were cleaning the school premises	3672
3351	1	20336	1	t	SHAILA K.H	shailakh1080@gmail.com	17/4/2013	9900045528	2013-10-01 06:07:40.529363+00	I visited at 11AM but school was locked and teacher was going to home.	3673
3352	1	20332	1	t	SHAILA K.H	shailakh1080@gmail.com	17/4/2013	9900045528	2013-10-01 06:07:40.542025+00	Toilets are not usable.	3674
3353	1	20328	1	t	SHAILA K.H	shailakh1080@gmail.com	17/4/2013	9900045528	2013-10-01 06:07:40.554467+00	There was no toilets and drinking water facility in the  school.	3675
3354	1	20333	1	t	SHAILA K.H	shailakh1080@gmail.com	17/4/2013	9900045528	2013-10-01 06:07:40.566633+00	None	3676
3355	1	20330	1	t	SHAILA K.H	shailakh1080@gmail.com	16/4/2013	9900045528	2013-10-01 06:07:40.578842+00	School has beautiful garden.	3677
3356	1	20340	1	t	SHAILA K.H	shailakh1080@gmail.com	18/4/2013	9900045528	2013-10-01 06:07:40.591007+00	School has been lacked at the time of visit.	3678
3357	1	20338	1	t	SHAILA K.H	shailakh1080@gmail.com	19/4/2013	9900045528	2013-10-01 06:07:40.603294+00	There was no MDM at the time of school.	3679
3358	1	20329	1	t	SHAILA K.H	shailakh1080@gmail.com	20/4/2013	9900045528	2013-10-01 06:07:40.616087+00	None	3680
3359	1	20331	1	t	SHAILA K.H	shailakh1080@gmail.com	20/4/2013	9900045528	2013-10-01 06:07:40.628419+00	Children were playing in the school ground.	3681
3360	1	20341	1	t	SHAILA K.H	shailakh1080@gmail.com	18/4/2013	9900045528	2013-10-01 06:07:40.640917+00	School has been lacked at the time of visit.	3682
3361	1	20140	1	t	SHAILA K.H	shailakh1080@gmail.com	19/4/2013	9900045528	2013-10-01 06:07:40.653244+00	None	3683
3362	1	20238	1	t	SHAILA K.H	shailakh1080@gmail.com	17/4/2013	9900045528	2013-10-01 06:07:40.665755+00	There was no compound wall for school.	3684
3363	1	20242	1	t	SHAILA K.H	shailakh1080@gmail.com	15/4/2013	9900045528	2013-10-01 06:07:40.678016+00	Toilets are not usable.	3685
3364	1	20247	1	t	SHAILA K.H	shailakh1080@gmail.com	18/4/2013	9900045528	2013-10-01 06:07:40.690473+00	None	3686
3365	1	20240	1	t	SHAILA K.H	shailakh1080@gmail.com	15/4/2013	9900045528	2013-10-01 06:07:40.715797+00	None	3688
3366	1	20237	1	t	SHAILA K.H	shailakh1080@gmail.com	15/4/2013	9900045528	2013-10-01 06:07:40.728195+00	Construction work is under progress.	3689
3367	1	20243	1	t	SHAILA K.H	shailakh1080@gmail.com	16/4/2013	9900045528	2013-10-01 06:07:40.74051+00	There was no compound wall for school.	3690
3370	1	20239	1	t	SHAILA K.H	shailakh1080@gmail.com	18/4/2013	9900045528	2013-10-01 06:07:40.789651+00	Meeting was held at the time of visit.	3694
3371	1	20241	1	t	SHAILA K.H	shailakh1080@gmail.com	16/4/2013	9900045528	2013-10-01 06:07:40.801778+00	None	3695
3372	1	20244	1	t	SHAILA K.H	shailakh1080@gmail.com	20/4/2013	9900045528	2013-10-01 06:07:40.82614+00	None	3697
3373	1	20287	1	t	SHAILA K.H	shailakh1080@gmail.com	18/4/2013	9900045528	2013-10-01 06:07:40.838442+00	No drinking water facility in the school.	3698
3374	1	20291	1	t	SHAILA K.H	shailakh1080@gmail.com	18/4/2013	9900045528	2013-10-01 06:07:40.878281+00	Toilets are not usable.	3699
3375	1	20165	1	t	VIDHYADHAR	vidhyadharayyars@gmail.com	17/4/2013	9900045530	2013-10-01 06:07:40.891008+00	Construction work is under  progress of compound wall.	3700
3376	1	20193	1	t	VIDHYADHAR	vidhyadharayyars@gmail.com	17/4/2013	9900045530	2013-10-01 06:07:40.903224+00	There was no playground	3701
3377	1	20308	1	t	VIDHYADHAR	vidhyadharayyars@gmail.com	16/4/2013	9900045530	2013-10-01 06:07:40.915543+00	None	3702
3378	1	20164	1	t	VIDHYADHAR	vidhyadharayyars@gmail.com	16/4/2013	9900045530	2013-10-01 06:07:40.928161+00	There was no separate room for HM.	3703
3379	1	20175	1	t	VIDHYADHAR	vidhyadharayyars@gmail.com	16/4/2013	9900045530	2013-10-01 06:07:40.940584+00	None	3704
3380	1	20171	1	t	VIDHYADHAR	vidhyadharayyars@gmail.com	16/4/2013	9900045530	2013-10-01 06:07:40.953336+00	There was no separate room for HM.	3705
3381	1	20301	1	t	VIDHYADHAR	vidhyadharayyars@gmail.com	17/4/2013	9900045530	2013-10-01 06:07:40.965611+00	Need two more class rooms.	3706
3382	1	20163	1	t	VIDHYADHAR	vidhyadharayyars@gmail.com	16/4/2013	9900045530	2013-10-01 06:07:40.978039+00	Need two more class rooms.	3707
3383	1	20166	1	t	VIDHYADHAR	vidhyadharayyars@gmail.com	19/3/2013	9900045530	2013-10-01 06:07:41.002919+00	Need two more class rooms.	3709
3384	1	20160	1	t	VIDHYADHAR	vidhyadharayyars@gmail.com	19/3/2013	9900045530	2013-10-01 06:07:41.015419+00	There was no playground for children.	3710
3385	1	20174	1	t	VIDHYADHAR	vidhyadharayyars@gmail.com	19/3/2013	9900045530	2013-10-01 06:07:41.027864+00	Needed some more sports materials.	3711
3386	1	20162	1	t	VIDHYADHAR	vidhyadharayyars@gmail.com	19/3/2013	9900045530	2013-10-01 06:07:41.040434+00	Need two more class rooms.	3712
3387	1	20176	1	t	VIDHYADHAR	vidhyadharayyars@gmail.com	19/3/2013	9900045530	2013-10-01 06:07:41.052951+00	None	3713
3388	1	20172	1	t	VIDHYADHAR	vidhyadharayyars@gmail.com	19/3/2013	9900045530	2013-10-01 06:07:41.065372+00	None	3714
3389	1	20170	1	t	VIDHYADHAR	vidhyadharayyars@gmail.com	19/3/2013	9900045530	2013-10-01 06:07:41.077965+00	Need two more class rooms.	3715
3390	1	20170	1	t	VIDHYADHAR	vidhyadharayyars@gmail.com	18/4/2013	9900045530	2013-10-01 06:07:41.090585+00	None	3716
3391	1	20161	1	t	VIDHYADHAR	vidhyadharayyars@gmail.com	18/3/2013	9900045530	2013-10-01 06:07:41.103427+00	Need two more class rooms.	3717
3392	1	20168	1	t	VIDHYADHAR	vidhyadharayyars@gmail.com	17/4/2013	9900045530	2013-10-01 06:07:41.116115+00	Toilets are not usable	3718
3393	1	20169	1	t	VIDHYADHAR	vidhyadharayyars@gmail.com	17/4/2013	9900045530	2013-10-01 06:07:41.128923+00	Need two more class rooms.	3719
3394	1	20156	1	t	SHIVAPPA .B	shivappa26@gmail.com	15/4/2013	9900045526	2013-10-01 06:07:41.141563+00	Needed two more class rooms and playground for children.	3720
3395	1	20130	1	t	SHIVAPPA .B	shivappa26@gmail.com	15/4/2013	9900045526	2013-10-01 06:07:41.166541+00	There was no playground.	3722
3396	1	20129	1	t	SHIVAPPA .B	shivappa26@gmail.com	15/4/2014	9900045526	2013-10-01 06:07:41.179387+00	Needed two more class rooms and playground for children.	3723
3397	1	20137	1	t	SHIVAPPA .B	shivappa26@gmail.com	16/4/2013	9900045526	2013-10-01 06:07:41.191752+00	Needed two more class rooms and playground for children.	3724
3398	1	20131	1	t	SHIVAPPA .B	shivappa26@gmail.com	16/4/2013	9900045526	2013-10-01 06:07:41.204297+00	Needed two more class rooms and playground for children.	3725
3399	1	20139	1	t	SHIVAPPA .B	shivappa26@gmail.com	16/4/2013	9900045526	2013-10-01 06:07:41.22322+00	Need two more class rooms.	3726
3400	1	20132	1	t	SHIVAPPA .B	shivappa26@gmail.com	16/4/2013	9900045526	2013-10-01 06:07:41.242491+00	Needed some more sports materials.	3727
3401	1	20126	1	t	SHIVAPPA .B	shivappa26@gmail.com	17/4/2013	9900045526	2013-10-01 06:07:41.261542+00	There was not enough playground for children.	3728
3402	1	20138	1	t	SHIVAPPA .B	shivappa26@gmail.com	16/4/2013	9900045526	2013-10-01 06:07:41.280306+00	Needed some more sports materials.	3729
3403	1	20134	1	t	SHIVAPPA .B	shivappa26@gmail.com	17/4/2013	9900045526	2013-10-01 06:07:41.2994+00	Needed some more sports materials  and playground for children.	3730
3404	1	20142	1	t	SHIVAPPA .B	shivappa26@gmail.com	17/4/2013	9900045526	2013-10-01 06:07:41.318478+00	There was no drinking water facility.	3731
3405	1	20194	1	t	SHIVAPPA .B	shivappa26@gmail.com	18/4/2013	9900045526	2013-10-01 06:07:41.337551+00	Needed some more sports materials  and playground for children.	3732
3406	1	20136	1	t	SHIVAPPA .B	shivappa26@gmail.com	18/4/2013	9900045526	2013-10-01 06:07:41.356514+00	Needed some more sports materials.	3733
3407	1	20127	1	t	SHIVAPPA .B	shivappa26@gmail.com	18/4/2013	9900045526	2013-10-01 06:07:41.375616+00	Everything is fine.	3734
3408	1	20128	1	t	SHIVAPPA .B	shivappa26@gmail.com	18/4/2013	9900045526	2013-10-01 06:07:41.394481+00	children and head master were not in the school at the time of visit.	3735
3409	1	20138	1	t	SHIVAPPA .B	shivappa26@gmail.com	18/4/2013	9900045526	2013-10-01 06:07:41.413353+00	Needed some more sports materials.	3736
3410	1	20135	1	t	SHIVAPPA .B	shivappa26@gmail.com	19/4/2013	9900045526	2013-10-01 06:07:41.432285+00	Needed some more sports materials. Everyone in the school at the time of visit.	3737
3411	1	20144	1	t	SHIVAPPA .B	shivappa26@gmail.com	19/4/2013	9900045526	2013-10-01 06:07:41.451422+00	No toilet facility in the school. No HM in the school at the time of visit.	3738
3412	1	20178	1	t	SHIVAPPA .B	shivappa26@gmail.com	19/4/2013	9900045526	2013-10-01 06:07:41.470176+00	No toilet facility in the school. No HM in the school at the time of visit.	3739
3413	1	20190	1	t	SHIVAPPA .B	shivappa26@gmail.com	19/4/2013	9900045526	2013-10-01 06:07:41.489379+00	School don’t have enough play ground for children.	3740
3414	1	20143	1	t	SHIVAPPA .B	shivappa26@gmail.com	19/4/2013	9900045526	2013-10-01 06:07:41.508393+00	School was locked at the time of visit.	3741
3415	1	20127	1	t	UMESH MELI	umesh@akshara.org.in	18/4/2013	9900045524	2013-10-01 06:07:41.527498+00	Need two more class rooms.	3742
3416	1	20218	1	t	UMESH MELI	umesh@akshara.org.in	18/4/2013	9900045524	2013-10-01 06:07:41.546561+00	Due to local fair school has been declared holiday.	3743
3417	1	20219	1	t	UMESH MELI	umesh@akshara.org.in	18/4/2013	9900045524	2013-10-01 06:07:41.565396+00	HM went for attending meeting in Kustagi at the time of visit. Everything is fine.	3744
3418	1	20220	1	t	UMESH MELI	umesh@akshara.org.in	18/4/2013	9900045524	2013-10-01 06:07:41.584429+00	Two more class rooms is needed for the school.	3745
3419	1	20221	1	t	UMESH MELI	umesh@akshara.org.in	18/4/2013	9900045524	2013-10-01 06:07:41.603444+00	There was no teachers in the school at the time of visit. But MDM preparation was going at the time of visit.	3746
3420	1	20222	1	t	UMESH MELI	umesh@akshara.org.in	18/4/2013	9900045524	2013-10-01 06:07:41.622883+00	There was no teachers in the school at the time of visit. But MDM preparation was going at the time of visit.	3747
3421	1	20223	1	t	UMESH MELI	umesh@akshara.org.in	18/4/2013	9900045524	2013-10-01 06:07:41.642004+00	There was no teacher in the school at the time of visit.	3748
3422	1	20224	1	t	UMESH MELI	umesh@akshara.org.in	18/4/2013	9900045524	2013-10-01 06:07:41.660892+00	There was shortage of play ground and class rooms for children.	3749
3423	1	20225	1	t	UMESH MELI	umesh@akshara.org.in	18/4/2013	9900045524	2013-10-01 06:07:41.678531+00	There was shortage of play ground and class rooms for children.	3750
3424	1	20235	1	t	UMESH MELI	umesh@akshara.org.in	18/4/2013	9900045524	2013-10-01 06:07:41.695773+00	There was no teacher in the school at the time of visit.	3751
3425	1	20280	1	t	KOTRESH TIGARI	akshreddy007@gmail.com	19/4/2013	9900045525	2013-10-01 06:07:41.729707+00	School doesn’t have playground.	3753
3426	1	20290	1	t	KOTRESH TIGARI	akshreddy007@gmail.com	19/4/2013	9900045525	2013-10-01 06:07:41.746979+00	There was no drinking water facility and playground in the school for children.	3754
3427	1	20275	1	t	KOTRESH TIGARI	akshreddy007@gmail.com	18/4/2013	9900045525	2013-10-01 06:07:41.763801+00	This is the best school in the cluster.	3755
3428	1	20278	1	t	KOTRESH TIGARI	akshreddy007@gmail.com	17/4/2013	9900045525	2013-10-01 06:07:41.780721+00	There was no drinking water facility and playground in the school for children.	3756
3429	1	20279	1	t	KOTRESH TIGARI	akshreddy007@gmail.com	19/4/2013	9900045525	2013-10-01 06:07:41.797875+00	There was no drinking water facility.	3757
3430	1	20281	1	t	KOTRESH TIGARI	akshreddy007@gmail.com	19/4/2013	9900045525	2013-10-01 06:07:41.815004+00	There was no drinking water facility.	3758
3431	1	20277	1	t	KOTRESH TIGARI	akshreddy007@gmail.com	20/4/2013	9900045525	2013-10-01 06:07:41.831953+00	Time table was not display in the school.	3759
3432	1	20289	1	t	KOTRESH TIGARI	akshreddy007@gmail.com	20/4/2013	9900045525	2013-10-01 06:07:41.848721+00	This school class rooms divided in two premises but facilities provided only one premises.	3760
3433	1	20282	1	t	KOTRESH TIGARI	akshreddy007@gmail.com	20/4/2013	9900045525	2013-10-01 06:07:41.865881+00	This school is 3 KMs away from the village.	3761
3434	1	20288	1	t	KOTRESH TIGARI	akshreddy007@gmail.com	20/4/2013	9900045525	2013-10-01 06:07:41.882829+00	There was no play ground for children.	3762
3435	1	20285	1	t	KOTRESH TIGARI	akshreddy007@gmail.com	20/4/2013	9900045525	2013-10-01 06:07:41.899624+00	This school has rich facilities but maintenance is very poor.	3763
3436	1	20264	1	t	KOTRESH TIGARI	akshreddy007@gmail.com	16/4/2013	9900045525	2013-10-01 06:07:41.916636+00	Toilets are not usable.	3764
3437	1	20256	1	t	KOTRESH TIGARI	akshreddy007@gmail.com	16/4/2013	9900045525	2013-10-01 06:07:41.933602+00	Toilets are not usable. Class room construction is under progress.	3765
3438	1	20268	1	t	KOTRESH TIGARI	akshreddy007@gmail.com	16/4/2013	9900045525	2013-10-01 06:07:41.950646+00	Toilets are not usable. Class room construction is under progress.	3766
3439	1	20251	1	t	KOTRESH TIGARI	akshreddy007@gmail.com	16/4/2013	9900045525	2013-10-01 06:07:41.967481+00	There was not enough class rooms and no playground for children.	3767
3440	1	20250	1	t	KOTRESH TIGARI	akshreddy007@gmail.com	17/4/2013	9900045525	2013-10-01 06:07:41.98426+00	There was no basic facilities in the village.	3768
3441	1	20249	1	t	KOTRESH TIGARI	akshreddy007@gmail.com	17/4/2013	9900045525	2013-10-01 06:07:42.00095+00	There was not enough playground for children.	3769
3442	1	20261	1	t	KOTRESH TIGARI	akshreddy007@gmail.com	17/4/2013	9900045525	2013-10-01 06:07:42.017763+00	Toilets are not usable.	3770
3443	1	20265	1	t	KOTRESH TIGARI	akshreddy007@gmail.com	17/4/2013	9900045525	2013-10-01 06:07:42.034912+00	Std 1 to 5th classes were running in the one class room.	3771
3444	1	20260	1	t	KOTRESH TIGARI	akshreddy007@gmail.com	18/4/2013	9900045525	2013-10-01 06:07:42.051878+00	This school has two premises, Hence children are getting finding difficulty	3772
3445	1	20263	1	t	KOTRESH TIGARI	akshreddy007@gmail.com	18/4/2013	9900045525	2013-10-01 06:07:42.068775+00	Not enough playground for children.	3773
3446	1	20254	1	t	KOTRESH TIGARI	akshreddy007@gmail.com	18/4/2013	9900045525	2013-10-01 06:07:42.085839+00	No playground for children.	3774
3447	1	20253	1	t	KOTRESH TIGARI	akshreddy007@gmail.com	18/4/2013	9900045525	2013-10-01 06:07:42.103312+00	No playground and compound wall.	3775
3448	1	20202	1	t	MANJUNATH .B	manjunathbijakal8@gmail.com	15/4/2013	9900045531	2013-10-01 06:07:42.120747+00	HM was not in the school at the time of visit. Summer camp was conducted in the school.	3776
3449	1	20213	1	t	MANJUNATH .B	manjunathbijakal8@gmail.com	15/4/2013	9900045531	2013-10-01 06:07:42.138469+00	No toilets for children. HM was not in the school at the time of school.	3777
3450	1	20215	1	t	MANJUNATH .B	manjunathbijakal8@gmail.com	15/4/2013	9900045531	2013-10-01 06:07:42.15577+00	None	3778
3451	1	20191	1	t	MANJUNATH .B	manjunathbijakal8@gmail.com	15/4/2013	9900045531	2013-10-01 06:07:42.173464+00	School doesn’t have compound wall.	3779
3452	1	20206	1	t	MANJUNATH .B	manjunathbijakal8@gmail.com	16/4/2013	9900045531	2013-10-01 06:07:42.190767+00	HM and teacher were not in the school at the time of visit.	3780
3453	1	20198	1	t	MANJUNATH .B	manjunathbijakal8@gmail.com	16/4/2013	9900045531	2013-10-01 06:07:42.20803+00	HM was not in the school at the time of visit. No playground for children.	3781
3454	1	20208	1	t	MANJUNATH .B	manjunathbijakal8@gmail.com	16/4/2013	9900045531	2013-10-01 06:07:42.225435+00	Teachers were not in the school at the time of visit.	3782
3455	1	20199	1	t	MANJUNATH .B	manjunathbijakal8@gmail.com	16/4/2013	9900045531	2013-10-01 06:07:42.243005+00	Teachers were not in the school at the time of visit.	3783
3456	1	20204	1	t	MANJUNATH .B	manjunathbijakal8@gmail.com	17/4/2013	9900045531	2013-10-01 06:07:42.260596+00	No playground and drinking water facility in the school.	3784
3457	1	20216	1	t	MANJUNATH .B	manjunathbijakal8@gmail.com	17/4/2013	9900045531	2013-10-01 06:07:42.278093+00	Teachers were not in the school at the time of visit.	3785
3458	1	20205	1	t	MANJUNATH .B	manjunathbijakal8@gmail.com	17/4/2013	9900045531	2013-10-01 06:07:42.295894+00	Teachers were not in the school at the time of visit.	3786
3459	1	20212	1	t	MANJUNATH .B	manjunathbijakal8@gmail.com	17/4/2013	9900045531	2013-10-01 06:07:42.313721+00	No drinking water facility in the school.	3787
3460	1	20203	1	t	MANJUNATH .B	manjunathbijakal8@gmail.com	17/4/2013	9900045531	2013-10-01 06:07:42.331292+00	Teachers were not in the school at the time of visit.	3788
3461	1	20214	1	t	MANJUNATH .B	manjunathbijakal8@gmail.com	18/4/2013	9900045531	2013-10-01 06:07:42.348073+00	Teachers were not in the school at the time of visit.	3789
3462	1	20196	1	t	MANJUNATH .B	manjunathbijakal8@gmail.com	18/4/2013	9900045531	2013-10-01 06:07:42.365003+00	Teachers were not in the school at the time of visit.	3790
3463	1	20201	1	t	MANJUNATH .B	manjunathbijakal8@gmail.com	18/4/2013	9900045531	2013-10-01 06:07:42.382086+00	Teachers were not in the school at the time of visit. Compound wall not yet completed.	3791
3464	1	20200	1	t	MANJUNATH .B	manjunathbijakal8@gmail.com	18/4/2013	9900045531	2013-10-01 06:07:42.394821+00	No separate toilets for Girls and Boys.	3792
3465	1	20207	1	t	MANJUNATH .B	manjunathbijakal8@gmail.com	19/4/2013	9900045531	2013-10-01 06:07:42.407504+00	No playground in the school.	3793
3466	1	20210	1	t	MANJUNATH .B	manjunathbijakal8@gmail.com	19/4/2013	9900045531	2013-10-01 06:07:42.419964+00	No compound wall for school.	3794
3467	1	20209	1	t	MANJUNATH .B	manjunathbijakal8@gmail.com	19/4/2013	9900045531	2013-10-01 06:07:42.432198+00	No playground in the school. No separate toilets for Girls and Boys.	3795
3468	1	20211	1	t	MANJUNATH .B	manjunathbijakal8@gmail.com	20/4/2013	9900045531	2013-10-01 06:07:42.444693+00	No drinking water facility in the school.	3796
3469	1	20269	1	t	DODDANAGOUDA	dgoudanaganur@gmail.com	16/4/2013	9900045533	2013-10-01 06:07:42.456826+00	Teachers were present in the school at the time of visit.	3797
3470	1	20266	1	t	DODDANAGOUDA	dgoudanaganur@gmail.com	16/4/2013	9900045533	2013-10-01 06:07:42.469039+00	There was less attendance in the school.	3798
3471	1	20262	1	t	DODDANAGOUDA	dgoudanaganur@gmail.com	16/4/2013	9900045533	2013-10-01 06:07:42.481196+00	Class room construction is under progress.	3799
3472	1	20257	1	t	DODDANAGOUDA	dgoudanaganur@gmail.com	17/4/2013	9900045533	2013-10-01 06:07:42.493514+00	Teachers were present in the school at the time of visit.	3800
3473	1	20252	1	t	DODDANAGOUDA	dgoudanaganur@gmail.com	17/4/2013	9900045533	2013-10-01 06:07:42.505955+00	There was less attendance in the school.	3801
3474	1	20271	1	t	DODDANAGOUDA	dgoudanaganur@gmail.com	18/4/2013	9900045533	2013-10-01 06:07:42.51843+00	There was less attendance in the school.	3802
3475	1	20258	1	t	DODDANAGOUDA	dgoudanaganur@gmail.com	18/4/2013	9900045533	2013-10-01 06:07:42.53067+00	No HM in the school at the time of visit.	3803
3476	1	20259	1	t	DODDANAGOUDA	dgoudanaganur@gmail.com	18/4/2013	9900045533	2013-10-01 06:07:42.542928+00	None	3804
3477	1	20270	1	t	DODDANAGOUDA	dgoudanaganur@gmail.com	18/4/2013	9900045533	2013-10-01 06:07:42.555116+00	No HM in the school at the time of visit.	3805
3478	1	20255	1	t	DODDANAGOUDA	dgoudanaganur@gmail.com	18/4/2013	9900045533	2013-10-01 06:07:42.567244+00	No HM in the school at the time of visit.	3806
3479	1	20267	1	t	DODDANAGOUDA	dgoudanaganur@gmail.com	19/4/2013	9900045533	2013-10-01 06:07:42.579471+00	Teachers were present in the school at the time of visit.	3807
3480	1	20232	1	t	DODDANAGOUDA	dgoudanaganur@gmail.com	19/4/2013	9900045533	2013-10-01 06:07:42.591727+00	There was less attendance in the school.	3808
3481	1	20231	1	t	DODDANAGOUDA	dgoudanaganur@gmail.com	20/4/2013	9900045533	2013-10-01 06:07:42.603995+00	None	3809
3482	1	20236	1	t	DODDANAGOUDA	dgoudanaganur@gmail.com	20/4/2013	9900045533	2013-10-01 06:07:42.616347+00	Teachers were present in the school at the time of visit. MDM was in school	3810
3483	1	20233	1	t	DODDANAGOUDA	dgoudanaganur@gmail.com	20/4/2013	9900045533	2013-10-01 06:07:42.628943+00	Teachers were present in the school at the time of visit. MDM was in school	3811
3484	1	20234	1	t	DODDANAGOUDA	dgoudanaganur@gmail.com	20/4/2013	9900045533	2013-10-01 06:07:42.653699+00	Teachers were present in the school at the time of visit. MDM was in school	3813
3485	1	20230	1	t	DODDANAGOUDA	dgoudanaganur@gmail.com	20/4/2013	9900045533	2013-10-01 06:07:42.666049+00	Teachers were present in the school at the time of visit. MDM was in school	3814
3486	1	20229	1	t	DODDANAGOUDA	dgoudanaganur@gmail.com	20/4/2013	9900045533	2013-10-01 06:07:42.678599+00	Teachers were present in the school at the time of visit. MDM was in school	3815
3487	1	20226	1	t	DODDANAGOUDA	dgoudanaganur@gmail.com	20/4/2013	9900045533	2013-10-01 06:07:42.69077+00	Teachers were present in the school at the time of visit. MDM was in school	3816
3488	1	20227	1	t	DODDANAGOUDA	dgoudanaganur@gmail.com	15/4/2013	9900045533	2013-10-01 06:07:42.703024+00	Teachers were present in the school at the time of visit. MDM was in school	3817
3489	1	20228	1	t	DODDANAGOUDA	dgoudanaganur@gmail.com	15/4/2013	9900045533	2013-10-01 06:07:42.715317+00	Teachers were present in the school at the time of visit. MDM was in school	3818
3490	1	20229	1	t	S.U.SOBARAD	sharanu.u29@gmail.com	17/4/2013	9900045529	2013-10-01 06:07:42.728401+00	There was not enough play ground for children.	3819
3491	1	20295	1	t	S.U.SOBARAD	sharanu.u29@gmail.com	17/4/2013	9900045529	2013-10-01 06:07:42.741421+00	There was not enough play ground for children.	3820
3492	1	20304	1	t	S.U.SOBARAD	sharanu.u29@gmail.com	17/4/2013	9900045529	2013-10-01 06:07:42.754273+00	Everything is fine except library.	3821
3493	1	20296	1	t	S.U.SOBARAD	sharanu.u29@gmail.com	20/4/2013	9900045529	2013-10-01 06:07:42.766694+00	None	3822
3494	1	20298	1	t	S.U.SOBARAD	sharanu.u29@gmail.com	19/4/2013	9900045529	2013-10-01 06:07:42.778773+00	Toilets are not usable	3823
3495	1	20304	1	t	S.U.SOBARAD	sharanu.u29@gmail.com	19/4/2013	9900045529	2013-10-01 06:07:42.79077+00	Playground was not maintained properly.	3824
3496	1	20306	1	t	S.U.SOBARAD	sharanu.u29@gmail.com	19/4/2013	9900045529	2013-10-01 06:07:42.80288+00	Proper drinking water facility is needed.	3825
3497	1	20189	1	t	S.U.SOBARAD	sharanu.u29@gmail.com	18/4/2013	9900045529	2013-10-01 06:07:42.814911+00	Toilets are not usable	3826
3498	1	20310	1	t	S.U.SOBARAD	sharanu.u29@gmail.com	18/4/2013	9900045529	2013-10-01 06:07:42.827197+00	Playground was not maintained properly.	3827
3499	1	20297	1	t	S.U.SOBARAD	sharanu.u29@gmail.com	18/4/2013	9900045529	2013-10-01 06:07:42.839722+00	Toilets are not usable	3828
3500	1	20300	1	t	S.U.SOBARAD	sharanu.u29@gmail.com	17/4/2013	9900045529	2013-10-01 06:07:42.852014+00	Some more books are needed for library.	3829
3501	1	20303	1	t	S.U.SOBARAD	sharanu.u29@gmail.com	16/4/2013	9900045529	2013-10-01 06:07:42.864012+00	Toilets are not usable	3830
3502	1	20180	1	t	S.U.SOBARAD	sharanu.u29@gmail.com	16/4/2013	9900045529	2013-10-01 06:07:42.876244+00	There was not enough play ground for children.	3831
3503	1	20309	1	t	S.U.SOBARAD	sharanu.u29@gmail.com	16/4/2013	9900045529	2013-10-01 06:07:42.888399+00	School has two premises but toilet facility is available only one premises.	3832
3504	1	20302	1	t	S.U.SOBARAD	sharanu.u29@gmail.com	16/4/2013	9900045529	2013-10-01 06:07:42.900596+00	No playground for children.	3833
3505	1	20312	1	t	S.U.SOBARAD	sharanu.u29@gmail.com	15/4/2013	9900045529	2013-10-01 06:07:42.912851+00	No proper drinking water facility is provided. .	3834
3506	1	20311	1	t	S.U.SOBARAD	sharanu.u29@gmail.com	15/4/2013	9900045529	2013-10-01 06:07:42.925308+00	Compound wall not yet completed so for.	3835
3507	1	20307	1	t	S.U.SOBARAD	sharanu.u29@gmail.com	15/4/2013	9900045529	2013-10-01 06:07:42.938007+00	Two more class rooms is needed for the school.	3836
3508	1	20193	1	t	S.U.SOBARAD	sharanu.u29@gmail.com	15/4/2013	9900045529	2013-10-01 06:07:42.950212+00	Toilets are not usable	3837
3509	1	20320	1	t	AKKAMAHADEVI	akkamahadevi48@gmail.com	15/4/2013	9900045532	2013-10-01 06:07:42.962793+00	No children and MDM at the time of visit.	3838
3510	1	20321	1	t	AKKAMAHADEVI	akkamahadevi48@gmail.com	15/4/2013	9900045532	2013-10-01 06:07:42.975097+00	School locked at the time of visit.	3839
3511	1	20327	1	t	AKKAMAHADEVI	akkamahadevi48@gmail.com	15/4/2013	9900045532	2013-10-01 06:07:42.987699+00	There was no play ground for children.	3840
3512	1	20315	1	t	AKKAMAHADEVI	akkamahadevi48@gmail.com	15/4/2013	9900045532	2013-10-01 06:07:43.000187+00	No toilets for children.	3841
3513	1	20177	1	t	AKKAMAHADEVI	akkamahadevi48@gmail.com	16/4/2013	9900045532	2013-10-01 06:07:43.012507+00	No playground in the school and toilets are not usable	3842
3514	1	20319	1	t	AKKAMAHADEVI	akkamahadevi48@gmail.com	16/4/2013	9900045532	2013-10-01 06:07:43.024878+00	Children are well know about Akshara programs, they shared with me.	3843
3515	1	20326	1	t	AKKAMAHADEVI	akkamahadevi48@gmail.com	18/4/2013	9900045532	2013-10-01 06:07:43.037557+00	HM and Children were discussed about summer camp.	3844
3516	1	20325	1	t	AKKAMAHADEVI	akkamahadevi48@gmail.com	16/4/2013	9900045532	2013-10-01 06:07:43.051771+00	playground, toilets and compound wall were needed for this school.	3845
3517	1	20313	1	t	AKKAMAHADEVI	akkamahadevi48@gmail.com	16/4/2013	9900045532	2013-10-01 06:07:43.069114+00	Everything is file. One of the best school.	3846
3518	1	20322	1	t	AKKAMAHADEVI	akkamahadevi48@gmail.com	17/4/2013	9900045532	2013-10-01 06:07:43.086298+00	Everything is fine. One of the best school. Good co-ordination with community.	3847
3519	1	20323	1	t	AKKAMAHADEVI	akkamahadevi48@gmail.com	17/4/2013	9900045532	2013-10-01 06:07:43.103716+00	No teachers in the school at the time of visit. No basic facilities in the school.	3848
3520	1	20326	1	t	AKKAMAHADEVI	akkamahadevi48@gmail.com	17/4/2013	9900045532	2013-10-01 06:07:43.120942+00	Everything is file. One of the best school. Good co-ordination with community.	3849
3521	1	32167	1	t	vishnu	vishnuvardhan061@gmail.com	23/11/2013	7795517061	2013-11-25 11:49:00.426774+00	\N	3963
3522	1	20183	1	t	AKKAMAHADEVI	akkamahadevi48@gmail.com	17/4/2013	9900045532	2013-10-01 06:07:43.138277+00	playground, toilets and compound wall were needed for this school.	3850
3523	1	20314	1	t	AKKAMAHADEVI	akkamahadevi48@gmail.com	17/4/2013	9900045532	2013-10-01 06:07:43.155486+00	Everything is fine	3851
3524	1	20316	1	t	AKKAMAHADEVI	akkamahadevi48@gmail.com	18/4/2013	9900045532	2013-10-01 06:07:43.173989+00	There was less attendance in the school.	3852
3525	1	20137	1	t	AKKAMAHADEVI	akkamahadevi48@gmail.com	18/4/2013	9900045532	2013-10-01 06:07:43.193127+00	Due to local fair no children were in the school.	3853
3526	1	20188	1	t	AKKAMAHADEVI	akkamahadevi48@gmail.com	18/4/2013	9900045532	2013-10-01 06:07:43.212143+00	MDM was arranged from the another school.	3854
3527	1	20318	1	t	AKKAMAHADEVI	akkamahadevi48@gmail.com	18/4/2013	9900045532	2013-10-01 06:07:43.231114+00	playground, toilets and compound wall were needed for this school.	3855
3528	1	20182	1	t	AKKAMAHADEVI	akkamahadevi48@gmail.com	19/4/2013	9900045532	2013-10-01 06:07:43.250305+00	playground, toilets and sports materials were needed for this school.	3856
3529	1	20184	1	t	AKKAMAHADEVI	akkamahadevi48@gmail.com	19/4/2013	9900045532	2013-10-01 06:07:43.269411+00	No teachers in the school at the time of visit.	3857
3530	1	20186	1	t	AKKAMAHADEVI	akkamahadevi48@gmail.com	19/4/2013	9900045532	2013-10-01 06:07:43.288534+00	Everything is fine	3858
3531	1	20185	1	t	AKKAMAHADEVI	akkamahadevi48@gmail.com	19/4/2013	9900045532	2013-10-01 06:07:43.307315+00	Everything is fine	3859
3532	1	20181	1	t	AKKAMAHADEVI	akkamahadevi48@gmail.com	19/4/2013	9900045532	2013-10-01 06:07:43.32643+00	There was no children at the time of visit in the school.	3860
3533	1	20191	1	t	AKKAMAHADEVI	akkamahadevi48@gmail.com	19/4/2013	9900045532	2013-10-01 06:07:43.345376+00	There was no teacher at the time of visit in the school.	3861
3534	1	20195	1	t	AKKAMAHADEVI	akkamahadevi48@gmail.com	19/4/2013	9900045532	2013-10-01 06:07:43.364682+00	There was not enough facilities in the school.	3862
3535	1	20179	1	t	AKKAMAHADEVI	akkamahadevi48@gmail.com	20/4/2013	9900045532	2013-10-01 06:07:43.383895+00	There was no teacher at the time of visit in the school.	3863
3536	1	20192	1	t	AKKAMAHADEVI	akkamahadevi48@gmail.com	20/4/2013	9900045532	2013-10-01 06:07:43.405012+00	Everything is fine	3864
3537	1	32175	1	t	Archana	archana.patel@hp.com	23/11/2013	\N	2013-11-25 12:03:48.513544+00	\N	3964
3538	1	32167	1	t	Rachana Yadav	rachana.yadav@cgi.com	23/11/2013	9620077671	2013-11-26 10:33:34.755505+00	\N	3965
3539	1	32167	1	t	Vijaya Kumar	vijay.mrk@gmail.com	23/11/2013	7760546546	2013-11-26 12:59:01.770172+00	\N	3970
3540	1	32167	1	t	Sebastian S Vempeny	seby_v@hotmail.com	23/11/2013	66421583	2013-11-26 13:07:56.778062+00	\N	3974
3541	1	32555	1	t	Rajesh S	raj.5729@gmail.com	30/11/2013	\N	2013-12-06 03:15:42.631107+00	\N	3981
3542	1	32697	1	t	Ashok Kamath	ashokrkamath@gmail.com	28/11/2013	\N	2013-11-28 08:07:11.183966+00	This is a well run school. A local community trust is very supportive of the school and this has made a tremendous difference. I went to a Class 7 classroom where the library period was going on and the children were able to borrow books, the teacher was able to engage them effectively and also children were able to read and comprehend what they read.	3980
3543	1	32258	1	t	Neetha	neetha.manojk@gmail.com	30/11/2013	\N	2013-12-06 10:01:19.147173+00	i was part of the makkala habba event conducted in the school by Akshara foundation. Children participated with great enthusiasm with amazing creativity. After being part of Makkala Habba I felt: children at govt schools have equal potential, grasping power etc etc as children studying in private school, they just need a proper channel to bring out the best in them.  Better facilities, better education model will certainly help improve them. 	3982
3544	1	32167	1	t	Prathima Kotian	prathima.kotian@cgi.com	23/11/2013	9535523618	2013-11-26 12:34:58.279139+00	Had a wonderful experience at Makkala habba organized by Akshara foundation. Looking for more such events. We had a back to school experience. Really good. Children were very innovative and talented. Could see future civil engineers who could construct big buildings. Really loved the program. Thanks Akshara foundation for providing such a wonderful opportunity.	3969
3545	1	29600	1	t	Tasmiya	tasmiya@akshara.org.in	21/02/2014	\N	2014-02-21 16:39:39.68803+00	\N	3983
3546	1	36013	1	t	Ashok Kamath	ashokrkamath@gmail.com	04/03/2014	+91 9844007560	2014-03-04 15:24:26.497839+00	This is a well run school. There seem to be several donors who have made significant contributions to the school and they are not lacking for anything. The HM is very proud (rightfully so) and she has provided excellent leadership to the school. If we have missed commenting on some of the items above it is because we did not pay attention - the school is a great example of how public schooling can work.	3984
3547	1	35882	1	t	Ashok Kamath	ashokrkamath@gmail.com	04/03/2014	+91 9844007560	2014-03-04 15:32:53.718757+00	This school has enthusiastic teachers. Infrastructure could be improved but it is by no means shabby. The enthusiasm of the teachers is clearly reflected in the performance of the children.	3985
3548	1	32168	1	t	Sridevi HP	sridevihp.26@gmail.com	23/11/2013	9738483169	2013-11-27 03:31:01.129891+00	Children were made to clean the school premises. This has to be avoided by having a designated servants for such work.	3978
3549	1	32167	1	t	Sebastian S Vempeny	sebastians.vempeny@cgi.com	23/11/2013	66421583	2013-11-26 11:09:23.580565+00	The school was well maintained.	3967
3550	1	36137	1	t	Ashok Kamath	ashokrkamath@gmail.com	04/03/2014	+91 9844007560	2014-03-04 15:38:03.36836+00	\N	3986
\.


--
-- Name: stories_story_id_seq; Type: SEQUENCE SET; Schema: public; Owner: klp
--

SELECT pg_catalog.setval('stories_story_id_seq', 3550, true);


--
-- Data for Name: stories_storyimage; Type: TABLE DATA; Schema: public; Owner: klp
--

COPY stories_storyimage (id, story_id, image, is_verified, filename) FROM stdin;
1	2990	9af81f921337b76668f9aca2c600ea46.jpg	t	20340.jpg
2	2990	1cd577cdb8e83e70e8440a15e4bf0c91.jpg	t	20341.jpg
3	2991	d83db7de6266bf03d2c1a3fe75c8d3fd.jpg	t	20332.jpg
4	2991	78f8879c0848bc332878651214ab7e9b.jpg	t	20333.jpg
5	60	16377e4ad071e048771db4f694d9e00d.jpg	t	20324.jpg
6	60	bfcc6ba87e8db0c769deb0bd987bc666.jpg	t	20325.jpg
7	92	dbdfefec7840062a4509b27ce2e57e7e.jpg	t	20306.jpg
8	92	252bfcd892152468b73fc2d802d7c387.jpg	t	20307.jpg
9	93	d056c2381f0a9064be4617c87602ae06.jpg	t	20312.jpg
10	93	b51764b653a77009f8201aba67f58123.jpg	t	20313.jpg
11	94	9a7a5c873730d1b5ae2bb7ded3707e71.jpg	t	30776.jpg
12	94	4f0b7828997a98c23848a2e15f8d0a47.jpg	t	30777.jpg
13	95	102ac4b29cfbfe1dc9746c265f399b54.jpg	t	30754.jpg
14	95	25d66f3870d194711f7209d7565c5659.jpg	t	30755.jpg
15	96	dac6ca0b8a4b41a9eaea46df6a777c95.jpg	t	20338.jpg
16	96	db0974389aec7edd0b847b86c8da6599.jpg	t	20339.jpg
17	97	2523b633bda27ac3b81254c598db4fa2.jpg	t	20322.jpg
18	97	23c88d75e8870e9567448e69414270fe.jpg	t	20323.jpg
19	98	447413cafe1d5e817917a3ce4c03399f.jpg	t	30760.jpg
20	98	65b896bd927e6ea4f8e4294d70802526.jpg	t	30761.jpg
21	99	c0fdf46e93ae81669478dea779153ec9.jpg	t	30752.jpg
22	99	3a13f3e5ec775573744aedb56ae87a36.jpg	t	30753.jpg
23	100	90095221e022a8cac133d770695a1ee8.jpg	t	20298.jpg
24	100	088618d4ae7c3665b63b8cb2e99832ee.jpg	t	20299.jpg
25	101	b4bc988e3989e92abc0a7a96aaadd43a.jpg	t	20344.jpg
26	101	cf63f5d7c27fee69066dd0ffa980b676.jpg	t	20345.jpg
27	102	a5f6cfeb8765835ae9589482e0828f23.jpg	t	30768.jpg
28	102	dddd8461d44bacb3da539cb23f9ffd75.jpg	t	30769.jpg
29	103	885d19002ea77a834395a027a4bef267.jpg	t	20302.jpg
30	103	64782cbcca0bee2a5694abeb9cc5fac2.jpg	t	20303.jpg
31	104	88b0cf57e477fb0af5952e2701c294a9.jpg	t	30770.jpg
32	104	0454ee6806be5d72e9c865befd5d8862.jpg	t	30771.jpg
33	105	5264ee1d06bef03f798b239581a865d1.jpg	t	20350.jpg
34	105	ef6253d96309d813f9702205cff0a1ba.jpg	t	20351.jpg
35	106	42b455bc758f87da3f385a0ef031b264.jpg	t	20326.jpg
36	106	018e0c834bde3d9e9ecc4a546b086b4e.jpg	t	20327.jpg
37	107	bb88cf3678589e83737d4cf8e9bca403.jpg	t	10649.jpg
38	107	3afdd94e19d73a9f45cf4e28cfd014a8.jpg	t	10650.jpg
39	108	7c0be274a4b763b8ae3f5038dee9dd83.jpg	t	10645.jpg
40	108	5cac174f38298df81c1933845b8104da.jpg	t	10646.jpg
41	109	846bdcc88bf4e488493dfdbe55b4606c.jpg	t	10581.jpg
42	109	b79d0fe5100825e26f2b425ef8bf508c.jpg	t	10582.jpg
43	110	f813723b8ae626920806e6644ec2f23c.jpg	t	10639.jpg
44	110	249a93322e2bdfc9e83f204bcf463d18.jpg	t	10640.jpg
45	111	22eee3740a554a7e25be5aa74ab3576f.jpg	t	10570.jpg
46	111	49b7166e048824fdbc8dac0b89c434c0.jpg	t	10571.jpg
47	112	3c721485859d55f89bcb3361ff4cfb5a.jpg	t	10623.jpg
48	112	d6ece36094ff44b2b50742d2fec2562d.jpg	t	10624.jpg
49	113	5fc15169cf6fbe8cbe35e38f0c1101e4.jpg	t	21452.jpg
50	113	9965ed1dc2d05d03ae9e1aca64a2622b.jpg	t	21453.jpg
51	114	484f7ae9e8fe3f4dbb79fa8e72b269aa.jpg	t	10587.jpg
52	114	d5a53a2550ddf58bcfa0a4013875bfd9.jpg	t	10588.jpg
53	115	e3721f5c5e85ee653070bf6f5afd0c19.jpg	t	10660.jpg
54	115	9be99cd053b5b8fdf480e3c8e0ae4409.jpg	t	10661.jpg
55	116	f23fb9ee067a1b67030e78c727a95b9f.jpg	t	10589.jpg
56	116	eb2f378027b6e17bd2749d227bf1cfec.jpg	t	10590.jpg
57	117	a4bf117dfdbff35446e7441f78492d5d.jpg	t	10575.jpg
58	117	31dd88eac068750830f6d36e81407ec9.jpg	t	10576.jpg
59	118	2f1850f26ea11f53845a75b3a0b6d063.jpg	t	21454.jpg
60	118	2633433a9621e1071c99ce4fabb21bd2.jpg	t	21455.jpg
61	119	c2dac99095d718b57fc9bb306c43d84b.jpg	t	10365.jpg
62	119	19a033c0a77ab2c70cd5a024ec909b36.jpg	t	10366.jpg
63	120	406f22255a14080af4ff363944c430c7.jpg	t	10539.jpg
64	121	b0433bec0f5455c8db32633ff1deaeb7.jpg	t	10594.jpg
65	122	f3369fa20cd984f31a2183dc5bf0d5ba.jpg	t	10603.jpg
66	122	7185ea92f6bbf3ede574f6547165a9fb.jpg	t	10604.jpg
67	123	4c7bd11f885149e4f17c8e8504e814e5.jpg	t	10871.jpg
68	123	7309b60c4f72ca83dd1fe5181a47f2c9.jpg	t	10872.jpg
69	124	7b6fea7bb9c49e459c4548025d60d926.jpg	t	10613.jpg
70	124	af0ed831186c0eaae9e12aa6fb34bb44.jpg	t	10614.jpg
71	125	454dae140847629bac22244056040393.jpg	t	10619.jpg
72	125	44477e5dd7bb1b5b35c4af61ed044564.jpg	t	10620.jpg
73	126	683fa586132587ae3da555f86ddc07ff.jpg	t	10599.jpg
74	126	e41f6863cd212a75678eb4b67c4e7b4d.jpg	t	10600.jpg
75	127	cc7943477da74d454466c75849bd564a.jpg	t	10609.jpg
76	127	2197bf49f68bd00d47d554ec49146b4e.jpg	t	10610.jpg
77	128	deb9e5b9510cdee6f3abc8580224340c.jpg	t	10030.jpg
78	128	779127fc70037ecc782f6586e0cbf92a.jpg	t	10031.jpg
79	129	880018c19a3e6448576d184f35825961.jpg	t	10014.jpg
80	129	2b17a992cef1a839611515caa50de229.jpg	t	10015.jpg
81	130	eae56cbe6911443bfbbf1d61274d6621.jpg	t	10053.jpg
82	130	b73cc2fe44daead74ef0b07e37f8449f.jpg	t	10054.jpg
83	131	08d0b94c4c855d3c1a7c5ee3f33a4a3d.jpg	t	10047.jpg
84	131	b5658787f97f336a00a42f2631bef786.jpg	t	10048.jpg
85	132	9e71ce736821170d98cbd09ff672de90.jpg	t	10032.jpg
86	132	c04e3bf9240ec2c309c0114139015e95.jpg	t	10033.jpg
87	133	2b10adde6e7776515b5baca6622764a9.jpg	t	10201.jpg
88	133	ca8cde5e280d45efd41c13954d50bcb4.jpg	t	10202.jpg
89	134	9e71ce736821170d98cbd09ff672de90.jpg	t	10032.jpg
90	134	c04e3bf9240ec2c309c0114139015e95.jpg	t	10033.jpg
91	135	ac98c3b1de00fb549ba301d8dc3d8f82.jpg	t	10057.jpg
92	135	353c7c5db5fb5221f458ca3c911309d6.jpg	t	10058.jpg
93	136	636893c741a00c3b83a19eddd811c535.jpg	t	10018.jpg
94	136	1532406fa68fdea75cc9c8b156df2ea6.jpg	t	10019.jpg
95	137	70ba4faee1157eb98b82d5f33540f3bb.jpg	t	10038.jpg
96	137	5dfa52255a82d086d0b23d264a9dec06.jpg	t	10039.jpg
97	137	609412b413aa0682b3782d7e2e978f72.jpg	t	10040.jpg
98	138	0743a8f1ceae8f06949696779c1d13fd.jpg	t	10049.jpg
99	138	7287e71ec1ad2a7f4ea656ec0c11ce5c.jpg	t	10050.jpg
100	139	5733a7f048bc66d8f0fad8613eb9c91e.jpg	t	10028.jpg
101	139	7465973034d650f8476bc8e008bc6ebd.jpg	t	10029.jpg
102	140	eee5db4361a95df6f76e4e5356d6ce61.jpg	t	10011.jpg
103	140	db5a24ff3f397e5b39c27d2e952e27cb.jpg	t	10012.jpg
104	141	126c266fab37a31a6dba0e9d1c98a8a6.jpg	t	10009.jpg
105	141	0d7557faa3ffaf78bdee8d9ea55faaf6.jpg	t	10010.jpg
106	142	0353759e79b0c92d6b4bf8b40488fd0b.jpg	t	10013.jpg
107	143	15cbc52277f278266f601825165d1fff.jpg	t	10043.jpg
108	143	a416d5f2e055e9de4081a38a7b63a5c0.jpg	t	10044.jpg
109	144	9c928bca86774762307f3f9b54ec2bf7.jpg	t	10023.jpg
110	144	81f00dd0774493a160b8de3e83798764.jpg	t	10022.jpg
111	145	3b8933ba17b6d368ab86a7b8c624a69e.jpg	t	10005.jpg
112	145	8db762baad247d58e09cfad21911aeee.jpg	t	10006.jpg
113	146	cc547506426349b5dbc70af00fe11689.jpg	t	10003.jpg
114	146	b6ecfbe3e1c4b9b230b8f30a711af360.jpg	t	10004.jpg
115	147	a0df9b567aaa9fd67c470c13d27c46bd.jpg	t	10409.jpg
116	147	f53be74736527c98cb14847ada9b7a1e.jpg	t	10410.jpg
117	148	5812081a5ae8bcf3a95962e4c5a87467.jpg	t	21360.jpg
118	148	9b65e21217017d599160ff39c25c5298.jpg	t	21361.jpg
119	149	69b380068c31d85f0c280f6b1d415607.jpg	t	20708.jpg
120	149	d438403148bdabf6e520a40fc64fb8c0.jpg	t	20709.jpg
121	150	062fe2b292d98ceb4b9302fcb5585571.jpg	t	10440.jpg
122	150	9d1acef431dfbcf65aee27dd15b8a4da.jpg	t	10441.jpg
123	151	96d5c2c3943f3ad360e7d3de103a76d6.jpg	t	10435.jpg
124	151	915b421fafdedbfde6d3fac6cf1b2f06.jpg	t	10436.jpg
125	152	893b9776bb9882adb70d5c1608c2ea89.jpg	t	10442.jpg
126	152	02e717aa4c2505ae7fb963e2531f3daf.jpg	t	10443.jpg
127	153	271910008d28ced73553f22e2fbbabdf.jpg	t	10452.jpg
128	153	dfdbf8b67ffbe0bbd792274f43a8b48c.jpg	t	10453.jpg
129	154	e0b4a14cf358a34da9905080fb23554d.jpg	t	10468.jpg
130	154	0bfb58e825e6af156e91aaf68aa399c2.jpg	t	10469.jpg
131	155	1f0aae92ce65966795714b89fa999f35.jpg	t	20747.jpg
132	155	4561cba554323ef85c435a28a2d3af01.jpg	t	20748.jpg
133	156	c842e8f4b7b059ad37819cc1563cb79c.jpg	t	20737.jpg
134	156	fdc11deb0d2e1689a65cec8afed93860.jpg	t	20738.jpg
135	157	8a2a7fc04cd94cba85cdeacf57c48fc2.jpg	t	10413.jpg
136	157	fef552a30c0108cf74e5246206f60446.jpg	t	10414.jpg
137	158	4d76a8ec853270ba324f3c175f2b8b92.jpg	t	10429.jpg
138	158	d3f0d22ece88129936aaa64bc2cce2a3.jpg	t	10430.jpg
139	159	28c31e087aa578bdb9a6a50693ffa76d.jpg	t	20745.jpg
140	159	d210d23510a4dae9f78c5ac3d42fae5d.jpg	t	20746.jpg
141	51	5404cb3f4fcccb11eae43e037337cc38.jpg	t	10419.jpg
142	51	4345cced335cebe0fd400da673365479.jpg	t	10420.jpg
143	52	db2a9345b772118af1b9dcb2e64a9703.jpg	t	20712.jpg
144	52	3980106594f2185019c03351ec445179.jpg	t	20713.jpg
145	53	20f66d98df22c88e23979cf5645f0175.jpg	t	21364.jpg
146	53	bb3253fc7d02331e1e2359ac795b7035.jpg	t	21365.jpg
147	54	dfd847bf88084fb82b7378f5e519c879.jpg	t	20720.jpg
148	54	7f8392389edf0cee1c708eeb9628ec4e.jpg	t	20721.jpg
149	54	fd389a8854f99007280fdb34d3299934.jpg	t	20722.jpg
150	55	3e8772df30bc8265a233bc9541da8ca4.jpg	t	10423.jpg
151	55	20a834ff446e647095725d38cc2073d6.jpg	t	10424.jpg
152	56	afe1ce7fbe99d52221b37564133f683c.jpg	t	10466.jpg
153	56	aaf6acd89985c621ab7a0371eb85f96c.jpg	t	10467.jpg
154	57	eb652f6e978c5a0fa6488c841092b4dc.jpg	t	21368.jpg
155	57	9f1b900299ab0fbc4d899d31b685ea93.jpg	t	21369.jpg
156	58	1fe8e28139e3de7c9587b6a4164d0931.jpg	t	10475.jpg
157	58	69b474e9bcf490eac6b90e2167455d30.jpg	t	10476.jpg
158	59	d068ab8ee04e009435270f81d38bee83.jpg	t	21246.jpg
159	59	50a4bd242a1f31e0a0b4de3c08bf86b4.jpg	t	21247.jpg
160	160	030f7ac46575ae689b474aaffb96edce.jpg	t	21258.jpg
161	160	be9bb076f7899f681fd8f660a6c37317.jpg	t	21259.jpg
162	161	a6fae68614c5fa8bfe4e5ac20c392806.jpg	t	21242.jpg
163	161	9b8170a4b7261a09286bae5e8eb490ea.jpg	t	21243.jpg
164	162	a6b5109d598e7bc67b2b4b1e28b003dd.jpg	t	21284.jpg
165	162	49264bef6bfe96f120d327c785e82571.jpg	t	21285.jpg
166	163	a22855a8924590e25b62941ca8eff8af.jpg	t	21254.jpg
167	163	749b2ebeda166e3efe13a3edacb74720.jpg	t	21255.jpg
168	164	f800a23da78134ef05b966e643c2eb4b.jpg	t	21216.jpg
169	164	19a941f393a467397e0cd39352669c33.jpg	t	21217.jpg
170	165	58178c07022982c278734b4526006e5a.jpg	t	21372.jpg
171	165	ce9167d85d470e6985c817be18dc45ac.jpg	t	21373.jpg
172	166	00fea0040528cf7e443dcc8add6d3771.jpg	t	21220.jpg
173	166	6b0fa1dbceb859075bfa8c378ca9387e.jpg	t	21221.jpg
174	167	ae8336850a97d62c9d4ccba4e9b229b2.jpg	t	21262.jpg
175	167	fdc0222d2e4008cb0c1cdda3217f6c59.jpg	t	21263.jpg
176	168	2584e9a95198aa3041f9144c334a66d3.jpg	t	21384.jpg
177	168	b763b032a842dacd76c4f0ad0c8e66f4.jpg	t	21385.jpg
178	169	4cc3c8765ed9f08f8578131be0374ad5.jpg	t	21231.jpg
179	169	059c8f8b0ceab4741298188eceaf9913.jpg	t	21232.jpg
180	170	ee92863d5c6140c6beb23a308524c991.jpg	t	21250.jpg
181	170	4785fbf96351cee5a6e35ffa88a807bc.jpg	t	21251.jpg
182	171	58e08cdaa5d2d78902b40b2309933208.jpg	t	21227.jpg
183	171	43ce47472a7817d0baab80e574b3d0a1.jpg	t	21228.jpg
184	172	4bdc905704a8077c0c970a7b263a5143.jpg	t	20172.jpg
185	172	5ba85827c9d07b256e8ced6ec96e08fc.jpg	t	20173.jpg
186	173	59f073807eb2355a8cb3770b02927ed1.jpg	t	10293.jpg
187	173	9d474f6791c413b49c2b08995fab0afb.jpg	t	10294.jpg
188	33	a0da9eb561873ef0d93725a6fc9eeb88.jpg	t	10154.jpg
189	33	53416bf71195e26c8f9ce6b57fd4e722.jpg	t	10155.jpg
190	174	fff8010b5796ae036ad28cea06ba1e55.jpg	t	10249.jpg
191	174	d1e130982b9bac8ea63ec000984f3a5c.jpg	t	10250.jpg
192	175	d8ecf0976f15dec58f4db3f9c6aab40a.jpg	t	10276.jpg
193	175	555066453b6c65638b6eb638b87ffbff.jpg	t	10277.jpg
194	176	f3c6939fabeedae78de24feb5d985b20.jpg	t	10195.jpg
195	176	51169422cf3a22aadd7e1640ce376c6f.jpg	t	10196.jpg
196	177	76418c05a934c61f8954f2d804e5a314.jpg	t	10285.jpg
197	177	9b90f2686e45c845b9ef6431257df117.jpg	t	10286.jpg
198	178	fbdda6de80f2ec54f8543ae07e33db12.jpg	t	10281.jpg
199	178	09382e400ac3f461c0e6a3490d6d4ad2.jpg	t	10282.jpg
200	179	f1ad1f11365a39f1426023f67d0b991b.jpg	t	10289.jpg
201	179	d35783fab324f542c39c5dae5b20d0aa.jpg	t	10290.jpg
202	180	dc52940d6d30ec43573fb2c564767d00.jpg	t	10251.jpg
203	180	573020a8df3a029579c6ecab04a62b99.jpg	t	10252.jpg
204	181	0bf4a1d81644b8d545a8cd220c54c287.jpg	t	10233.jpg
205	181	cb43e9bac7883111e553431c0fde58bf.jpg	t	10234.jpg
206	182	985f601afbcd7a70bb7607e01ec80d64.jpg	t	10258.jpg
207	182	3a2719c4e5f45490121162e8a1899a5b.jpg	t	10259.jpg
208	182	0bfad0789aabd7f8436dd99cd78d6f0d.jpg	t	10260.jpg
209	183	03b74320da9bcdbabb8c8dbe46ae12c0.jpg	t	10979.jpg
210	183	c5274f5cd08ed68a82519170ecf087e2.jpg	t	10980.jpg
211	183	fa5ce592be1403f8502eaf0b0a0b2530.jpg	t	10981.jpg
212	184	34f5b5b9d3c740eebbc2f8b9253fed48.jpg	t	10237.jpg
213	184	98ef9f035ad30479b8de05bfb88dad5f.jpg	t	10238.jpg
214	185	6c2148579fa7da34fc3693fb92b71e59.jpg	t	10205.jpg
215	185	956500c26097a0b8efcb654f47b4c606.jpg	t	10206.jpg
216	186	9bc743d90341ae36251c5308a840165a.jpg	t	10219.jpg
217	186	b2df722bc88d996a982a5af01d22a4b8.jpg	t	10220.jpg
218	187	d2cce0e268436dd864f1b0a77b2dcbb6.jpg	t	10267.jpg
219	187	672c6b701fac123353a95688b136e991.jpg	t	10268.jpg
220	188	ad583aebaea130128cbe745f20fd7717.jpg	t	10229.jpg
221	188	3091e7dcb3c8e6868ecbbd7b337afcf5.jpg	t	10230.jpg
222	189	cc5d1a4bd87400de5e473c70a7a22c96.jpg	t	10227.jpg
223	189	84f9a0daa59b331636027aa3368738c1.jpg	t	10228.jpg
224	190	abe05b03fd1592109b2b691f0487bc71.jpg	t	10217.jpg
225	190	99d65f2571e415c7cb1daa8c6d46cacd.jpg	t	10218.jpg
226	191	5b5984e8dfefe9fe2babcd8f4a6dd94d.jpg	t	10207.jpg
227	191	bb06d0616a4462ad5290ca665cbda517.jpg	t	10208.jpg
228	192	ad3a8b8536ee71837aa7a3deb60ccb0c.jpg	t	10269.jpg
229	192	f520a89079719c50c5baa98985eec6cc.jpg	t	10270.jpg
230	193	34f5b5b9d3c740eebbc2f8b9253fed48.jpg	t	10237.jpg
231	193	98ef9f035ad30479b8de05bfb88dad5f.jpg	t	10238.jpg
232	194	f187a20af2197c5fe0309efa42a07f37.jpg	t	10245.jpg
233	194	03b1a3cffe071c4a25645fd6eeab8046.jpg	t	10246.jpg
234	195	509e1cbcbf4623b270d1b08661f5ea8f.jpg	t	11359.jpg
235	195	a75822872b075dcaddd6345264e7bf99.jpg	t	11360.jpg
236	196	a07d6b8f7e1837d38de49a31fe6cf3f7.jpg	t	11280.jpg
237	196	71606933196a782f0dbf01075b67b887.jpg	t	11281.jpg
238	197	921cd7aac08838f0d2e41127dd81d7f4.jpg	t	11336.jpg
239	197	07f32421b8a2ab6e9ca98f287d4a0611.jpg	t	11337.jpg
240	198	470c1f537af931a1231a83f720681db7.jpg	t	11327.jpg
241	198	7e630e2cf925ce67143e92bec7e56a95.jpg	t	11328.jpg
242	199	c28dfa45aa241402fc91e12da8bc670b.jpg	t	11355.jpg
243	199	11415e9484a2139d441e5f1f3814f8ab.jpg	t	11356.jpg
244	200	8110ba26ba928add839b0ac19d53e86e.jpg	t	11302.jpg
245	200	b2811da2e208109b96466ec56670a04b.jpg	t	11303.jpg
246	201	1b3eba32d1b7409819548fd6d45ab929.jpg	t	11349.jpg
247	201	3ccc9b75e32b25a8947a622342cce0bd.jpg	t	11350.jpg
248	202	2cd5f3bcd328e442f7271f5ecfcb01ce.jpg	t	11323.jpg
249	202	1d73e22109e3e1b8042b175678c61759.jpg	t	11324.jpg
250	203	24c271151fc402d64f10187310e076ef.jpg	t	11342.jpg
251	203	37a3647d6faec7f26c452110e42bd4b8.jpg	t	11343.jpg
252	204	5327091d8f4d207fd3a00844d6037521.jpg	t	11332.jpg
253	204	47306df8bc5f0f2881b0c9f404b73511.jpg	t	11333.jpg
254	205	6a7c98fae3d0fbb543fafff86ca2f0a7.jpg	t	11340.jpg
255	205	04d0543477dbbcfb6caa14cdfb9a7a0f.jpg	t	11341.jpg
256	206	61376abe38ebc6533277b9c7ede3b181.jpg	t	11321.jpg
257	206	ab3bc67feb5de7d016c1533ba5eff26f.jpg	t	11322.jpg
258	207	757d842579d934a1c9054303a0cf9c7b.jpg	t	11344.jpg
259	207	972a698b96394281c31796071f20d4d1.jpg	t	11345.jpg
260	208	87656f523eda93700067e024018cdf6e.jpg	t	11318.jpg
261	208	7f2e5b163466531eea760d6269794866.jpg	t	11319.jpg
262	209	ffe9cd84c67511b73a1c37996317932d.jpg	t	11308.jpg
263	209	f8d599ed480260aad91da571c065d5af.jpg	t	11309.jpg
264	210	4ffe8d221dd3d65d930d46e290b7d112.jpg	t	11310.jpg
265	210	c14092f6f753ffc269114831b2ee97dd.jpg	t	11311.jpg
266	211	c50f9c5cbb7f3764b70e67aa1ddcb35b.jpg	t	11287.jpg
267	211	38e53bc3b7bc537cad91b96f7a6768b0.jpg	t	11288.jpg
268	212	03d028c91ed9942e0efb31735ebaea7d.jpg	t	11363.jpg
269	212	b27f7475fdf90f9f5e6f9b23cf412521.jpg	t	11364.jpg
270	213	565a94125532ddd910c6b0913d0826ac.jpg	t	11353.jpg
271	213	da635b6cc38375c450831d99b59849df.jpg	t	11354.jpg
272	214	c57aa7b327883cb1fadcf9197d13a709.jpg	t	11285.jpg
273	214	c55433464edbba2ba0a4dc14c6a2f67b.jpg	t	11286.jpg
274	215	c2103964e3d22d804d0cc3a8b7904d79.jpg	t	11304.jpg
275	215	0edbfa1ed41154fcacf40df0ae7a48d0.jpg	t	11305.jpg
276	216	ebdc5678ea415fb295eeb0729ad341ff.jpg	t	11365.jpg
277	216	18875acefd8eb54babfbe74fd25d5209.jpg	t	11366.jpg
278	217	c0a86faf518343726df3e2a96df63e72.jpg	t	11291.jpg
279	217	6ba51f550c2e7b81b5f0bd1c3a01401a.jpg	t	11292.jpg
280	218	8ed7a480eb71b5b574bb4aa527eec726.jpg	t	11293.jpg
281	218	8e8a0b8e9627b6fb6342d6b4c44ef847.jpg	t	11294.jpg
282	219	0415da550380ca0de791133cfcac2284.jpg	t	10164.jpg
283	219	0e03d1bd4735607bc65d4c8630470f8c.jpg	t	10165.jpg
284	220	3c2bba3c979aec514befc308c5130e1e.jpg	t	11278.jpg
285	220	5c23a2862cc3217276b567b064dca543.jpg	t	11279.jpg
286	221	68d1261b2e177fc126e5d4a12351a527.jpg	t	11274.jpg
287	221	7e2f937021480894571d49e390106ced.jpg	t	11275.jpg
288	222	4f3c7f0ffa9ff509f4cf5421e07ced48.jpg	t	10867.jpg
289	222	a7e7433b257b766fefbabbf342b7a9ec.jpg	t	10868.jpg
290	223	8fc8ad8e03ad1f0875a1f0d808690284.jpg	t	40017.jpg
291	223	887841239a869889f20e8c6cc80596e3.jpg	t	40018.jpg
292	224	931d6959fddd8c3d4330c984eda3c377.jpg	t	40113.jpg
293	224	a8cd0045f916676ffc4d45f185184f18.jpg	t	40114.jpg
294	225	56969b4337a52ddc18f868486a443ba1.jpg	t	40111.jpg
295	225	f58fe5f678982e8458b4a723ee6d86b0.jpg	t	40112.jpg
296	226	6245caec9d38a6ac427e66eb7ffd4f48.jpg	t	40005.jpg
297	226	8f68bd3402a592b0dcc04ce532a2f361.jpg	t	40006.jpg
298	227	05affd6e0e1f5458b2e83a0e86308222.jpg	t	40085.jpg
299	227	e1764282962c29f5dabd7ed25cb78d54.jpg	t	40086.jpg
300	228	525ce0572e7fd7c6d7fe8983bee1b8d0.jpg	t	40071.jpg
301	228	b21b3e917fa4a41a012ca0930864bd52.jpg	t	40072.jpg
302	229	2e64d20f5b4a2a858b361f2449a7f132.jpg	t	40077.jpg
303	229	10762631660f25f3f946d3d7d5876943.jpg	t	40078.jpg
304	230	38623faa6d68a0f00c30b54b03449755.jpg	t	40013.jpg
305	230	7bea3226e5ae84a9a5db6af7e9038e5b.jpg	t	40014.jpg
306	231	4e2adfffd9a3a76301a40e3850fd322d.jpg	t	40065.jpg
307	231	438b9e49a12a274bc0813f02eca4cd36.jpg	t	40066.jpg
308	232	5f2cadc853c0f8eec87e2cb5a943957d.jpg	t	40035.jpg
309	232	2d93b0c44af04648fd99e680c20409f8.jpg	t	40036.jpg
310	233	de9b2cf49a75a19bc818c4adb3c1b07c.jpg	t	40029.jpg
311	233	5ca49a00300bf9f9ee4854c14a807351.jpg	t	40030.jpg
312	234	f411411e9b8eabd480986a10193c1875.jpg	t	40033.jpg
313	234	1335e1c105a1f11fab4d2f1e9638b83e.jpg	t	40034.jpg
314	235	9676f25750f9e70bfdb0ae0b388e27be.jpg	t	40063.jpg
315	235	43fdbff6d53f5a0beafd9d82817ec0fc.jpg	t	40064.jpg
316	236	7e288a2c9f3132dcd46d282bbd5af60c.jpg	t	40093.jpg
317	236	46dd3c168849a827ae66acb3c7a10dd5.jpg	t	40094.jpg
318	237	ac939d705d7aefc841dc8a90419f5215.jpg	t	40091.jpg
319	237	b8a7e4f96e2b6ac931876f06533134f5.jpg	t	40092.jpg
320	238	bf8748fc6406c6a2dde7eea934e38cbd.jpg	t	40095.jpg
321	238	045ae6bf3f07792eab78962443ef1d93.jpg	t	40096.jpg
322	239	db62015817008feb4a9d6dad1984b2c0.jpg	t	40021.jpg
323	239	77f11d243903682df59c63c458fd12f9.jpg	t	40022.jpg
324	240	f3078beba25aaa13642ded44c6c3b2f7.jpg	t	40041.jpg
325	240	ae7ff0a35c4008b33cb40dd3fa8b676c.jpg	t	40042.jpg
326	241	85c5e94bb853ed3e38e1e5ed6082ec04.jpg	t	40089.jpg
327	241	4bbdcc3dc53a95f4e259f1701e7905ce.jpg	t	40090.jpg
328	242	62ba972692d850b7067bbfee72cf76d5.jpg	t	40027.jpg
329	242	9cfeb4ee875dbb5e9696f2a9e4dc560f.jpg	t	40028.jpg
330	243	eac9db1044dae2b6af103bc56023eb45.jpg	t	40103.jpg
331	243	5fc783190cf25ae3c0f6d264018d22e8.jpg	t	40104.jpg
332	244	7acef1cb4c382e3c6dca405507c4dc2f.jpg	t	40107.jpg
333	244	83d9df27d43ebee5f64b2588bc461e22.jpg	t	40108.jpg
334	245	f9c80c677c00a23903e6825eb92a379e.jpg	t	40023.jpg
335	245	32128c5f035cad7b372baef4c7229c8b.jpg	t	40024.jpg
336	246	2e98310407fc19c874af144550d0aacb.jpg	t	40061.jpg
337	246	6e22217584a0c1ddac1d165522bef44a.jpg	t	40062.jpg
338	247	c717d80202be5875730f1009866ed041.jpg	t	40101.jpg
339	247	3290fe4a185e2acbd46b3d157e9d9bed.jpg	t	40102.jpg
340	248	52912e2740fb753b479d219ea993314a.jpg	t	40001.jpg
341	248	a1c08557f864184936589b85097d8277.jpg	t	40002.jpg
342	249	5af58a5a40201a2777f305222b8531be.jpg	t	40105.jpg
343	249	04b5ef43c70415c00f1d38fed44557ff.jpg	t	40106.jpg
344	250	155b367b60fbd890d9706b553b6e8e24.jpg	t	40059.jpg
345	250	25c4823df08720cb4f4488bbc0d87266.jpg	t	40060.jpg
346	251	79bb1dee103379777df886ffa0b87651.jpg	t	40009.jpg
347	251	414b01f441aa4ffa89fa4e54e44e5d2f.jpg	t	40010.jpg
348	252	8904fd3190298c6bb660fd106136331d.jpg	t	40075.jpg
349	252	e86a622d7e531abc5b1d9708bb841330.jpg	t	40076.jpg
350	253	4cdc2b856d7efe4cfc6459948273001a.jpg	t	40081.jpg
351	253	d1e8e9b97d1da336f1ee61fee67f3eac.jpg	t	40082.jpg
352	254	5c62c77264a2837901272cc9843240d8.jpg	t	40057.jpg
353	254	b3624980775752eeae40faaff10b8a5b.jpg	t	40058.jpg
354	255	cbaa9d18bbc84b7ecda675f2e0498040.jpg	t	40048.jpg
355	255	ef11132529b5933b6e047bba5a0eee1c.jpg	t	40049.jpg
356	256	a32bc54a9c9e7ea435883a088353073f.jpg	t	40069.jpg
357	256	63c0e50948ba16487e29fdb5c37fd995.jpg	t	40070.jpg
358	257	e2e66c59e3dfd1d1fb82b0ed73cc7de7.jpg	t	40073.jpg
359	257	123b53cc3350527a4f68335c41afcfce.jpg	t	40074.jpg
360	258	fc6e8789c0e1307da2099cf3ff12dac2.jpg	t	40083.jpg
361	258	05df48f810567989bfd0362f079d4401.jpg	t	40084.jpg
362	259	d9a7a3582d72f61c4f69e8dfa63b8931.jpg	t	40045.jpg
363	259	59fc14b60ef337d20e902e87d940c844.jpg	t	40046.jpg
364	259	20de7f5f2918ea34421b2a37a7f320ec.jpg	t	40047.jpg
365	260	7391bfe245cc1aac0125538b58f8c5ff.jpg	t	40053.jpg
366	260	2cba5e2aaae6fb882273a7742e8c8e9e.jpg	t	40054.jpg
367	261	b7c03ac9c769e1e530d08e82cdf64fff.jpg	t	40055.jpg
368	261	86678283eeee01fa2174b3eaa508a259.jpg	t	40056.jpg
369	262	78667386f916af0c37263bf9938919bc.jpg	t	11149.jpg
370	262	5a97983b8f7b1f8a40019c332455cdd7.jpg	t	11150.jpg
371	263	33612390f9c364752421af3878053b01.jpg	t	11140.jpg
372	263	222acf8b92015923efe98e0d07fce9e0.jpg	t	11141.jpg
373	264	e977b023a14803a8e4cf6289f48150bc.jpg	t	11155.jpg
374	264	a0c7abc17642bde407e354be1e0c51e6.jpg	t	11156.jpg
375	265	9fc4f8487973961cd67ab65d80a8cb66.jpg	t	11159.jpg
376	265	06c867d3d9e10ec208dd00afce7a94b8.jpg	t	11160.jpg
377	266	b01acfd2ac30cdf1b3e935516e24c009.jpg	t	11136.jpg
378	266	d990856721459d93452592840af584c4.jpg	t	11137.jpg
379	267	51a3ef3868e226f956cd55412c2f1b66.jpg	t	11127.jpg
380	267	3182e03787c06a384797ad650d57bee4.jpg	t	11128.jpg
381	268	25442d9cd08ea024ed0c5a2412dc4fa1.jpg	t	11173.jpg
382	268	10b30633cef559fff80106d70a6c442a.jpg	t	11174.jpg
383	269	5074131370b62a8358d9368a28823fc3.jpg	t	11123.jpg
384	269	ac61431023421aa78eb68a2b366641c0.jpg	t	11124.jpg
385	270	ef611987bc7ced43c27a51ffffcea7e6.jpg	t	11144.jpg
386	270	f65cf8c6ed2e832d7e3a0499f435e523.jpg	t	11145.jpg
387	271	6c035a60f40b31e502c4609711b3c559.jpg	t	11151.jpg
388	271	bf9d43b7872ab56d8c37c64fd002e1bc.jpg	t	11152.jpg
389	272	807273760cf6f791873d684a703b3d1e.jpg	t	10796.jpg
390	272	7c43da6cb65d3b4d25e101f1822201e1.jpg	t	10797.jpg
391	273	c3f0f6f31dc444a7e061b6200e3a911d.jpg	t	10798.jpg
392	273	7d1bdadad5e4e1a8e4f098d16c659179.jpg	t	10799.jpg
393	274	b4a7d7f16f9e1ecb3d09c2d83064c03b.jpg	t	30315.jpg
394	274	112860aa503c7abb310f0e9e572237e1.jpg	t	30316.jpg
395	275	e17e2d7198d6af38029eb026c685f312.jpg	t	11157.jpg
396	275	511dc07be9482197c789a83aef9cb0ef.jpg	t	11158.jpg
397	276	ae773de1d138d80f20a46a61b95f9f52.jpg	t	11161.jpg
398	276	07610d69eb6fee564b2e284152915c8e.jpg	t	11162.jpg
399	277	c95eb19e24c16157b3003507c39069b2.jpg	t	30292.jpg
400	277	7f94a58e858d75979dc84c0dcbade33f.jpg	t	30293.jpg
401	278	dea99bce8dc3d71eedad2368e2de5e8f.jpg	t	30278.jpg
402	278	515285f0e86870c335cb42cd07c0e304.jpg	t	30279.jpg
403	279	2d08a2fe08c49902b20ba92e1e4f9e42.jpg	t	30288.jpg
404	279	d3d375c7515937aa6b959e163c6f21ea.jpg	t	30289.jpg
405	280	599e8dd059239e1ddcc562f730940955.jpg	t	30296.jpg
406	280	eff9101dba3566233ae9b7a5dcc114a7.jpg	t	30297.jpg
407	281	3f6173b3a4655a7e9e2a2f7e14dca0cf.jpg	t	11113.jpg
408	281	e94c00833306203b111847401c51c42f.jpg	t	11114.jpg
409	282	36141616919ab7d2ea1a281461ef88dc.jpg	t	30298.jpg
410	282	4228c30d9feb68cd53f70fb76647ee0a.jpg	t	30299.jpg
411	283	88ee5ceead5ae97f444d5bf628c57f01.jpg	t	11103.jpg
412	283	ecb76e82d48da234f11842da0d561824.jpg	t	11104.jpg
413	283	3737064f502c3aea13bc9ad422d7560f.jpg	t	11105.jpg
414	284	cca95b380626404d70dae38960f42f7f.jpg	t	30307.jpg
415	284	ccbebc8ff9fe0efcccec6fdf828d9e96.jpg	t	30308.jpg
416	285	f05ad1dd81353be8facc0d1a8297cf3a.jpg	t	30282.jpg
417	285	e3c6edea15848a945de25121552fefd5.jpg	t	30283.jpg
418	286	200bb92c174c5a40261fc8ec2078850b.jpg	t	10744.jpg
419	286	4c91052dfde60bb37c541514e1fbb67c.jpg	t	10745.jpg
420	287	795d1e112e3c6c279d87a874eca101e4.jpg	t	10790.jpg
421	287	d47b56b501d1dfee52a72d8ecb8b8af4.jpg	t	10791.jpg
422	288	058e62b75bd90b9196636184f24c14d0.jpg	t	11119.jpg
423	288	cb2fa55e5fb404d35ec4fcbe0b4fe8cd.jpg	t	11118.jpg
424	289	f103d3dab799fa969f673666cccfb753.jpg	t	11131.jpg
425	289	d9eb0b3bb351af805c858b1cc466bcae.jpg	t	11132.jpg
426	290	a1b26840ce14b0c15aa6517c2daea67c.jpg	t	10792.jpg
427	290	9ac4e620557654d65953720ad9380bf0.jpg	t	10793.jpg
428	291	eb4fc6623dc66165fb3a2490b29d9eae.jpg	t	30311.jpg
429	291	0d5e8f78411307d29fa13def8c3dea44.jpg	t	30312.jpg
430	292	20b5c07d39ba83655b7197d0541d02c6.jpg	t	10178.jpg
431	292	2d34fda49be84073e74859821a1217c8.jpg	t	10179.jpg
432	293	cd7c4a0755868c7b0aa84ee174d0bad2.jpg	t	30302.jpg
433	293	cd7c4a0755868c7b0aa84ee174d0bad2.jpg	t	30302.jpg
434	294	a3e3b8e930ba35cc82d0de2bbf6e2971.jpg	t	40529.jpg
435	294	7cd8248a30a4db87ba90cb97c13a1265.jpg	t	40530.jpg
436	295	e64c6de04e39e3cd2222f04dd35b7690.jpg	t	10180.jpg
437	295	5f08212443c71023a5a102b6b53000e9.jpg	t	10181.jpg
438	296	3b7e91b8fd53fae9c0dedfccbfb158d3.jpg	t	40531.jpg
439	296	04a819331784963ad113be6ec00106a5.jpg	t	40532.jpg
440	297	9119944ff55503e456f46d1c9cf1db9d.jpg	t	10185.jpg
441	297	1727e04fbae10a5c5b706d194c96035e.jpg	t	10186.jpg
442	298	0e61123503c12c6b1a36cf0a3d5180eb.jpg	t	10191.jpg
443	298	33aa3674990da6a05295c56d50bc6afe.jpg	t	10192.jpg
444	299	a3bae7c054f174ddc3b396be2a86b661.jpg	t	10166.jpg
445	299	8b1e1753ff0b96d6eb50fdfc7af6727d.jpg	t	10167.jpg
446	300	f56df925be35c10056dacc09cd57b1fb.jpg	t	10172.jpg
447	300	0012b14bda8a15e3f46d8fef6e2f5c3c.jpg	t	10173.jpg
448	301	446b242464967982a6376371b86bab38.jpg	t	10189.jpg
449	301	67c798dcfa5d68a6a888f4ddfda41adf.jpg	t	10190.jpg
450	302	a6387164bcd5f6fa9230e5d74fdb8c08.jpg	t	21536.jpg
451	302	e09792e44675ccc905411b0be27c6f3d.jpg	t	21537.jpg
452	303	bd993447a3c7181210b8c89ef977fd86.jpg	t	21518.jpg
453	303	29972b0db51cb0103019922f92d8e9a1.jpg	t	21519.jpg
454	304	16d0010b023a1452f36dabcf2a70e240.jpg	t	21548.jpg
455	304	008c73bba545ca2be65378f6e6bfb817.jpg	t	21549.jpg
456	305	09023a59a9247cfbc2295d5d997c05bd.jpg	t	21538.jpg
457	305	891e027497ab9c707c0bf37bc4ec9796.jpg	t	21539.jpg
458	306	5c78528a3aad9c9faa608522ca44fc6a.jpg	t	21528.jpg
459	306	e3f818cee027c830dde2046e9c7bc969.jpg	t	21529.jpg
460	307	7580bc43501a64c340a849bbe0d08718.jpg	t	21526.jpg
461	307	0c7b9428333b34ca66fc1abff5f82d20.jpg	t	21527.jpg
462	308	1bd89954f89ca6a29d029d0a92d41b76.jpg	t	21512.jpg
463	308	6c6661aced7d1e5e1784b0a27c75146f.jpg	t	21513.jpg
464	309	ee7487f8fd0977fadd0d89de383922de.jpg	t	21510.jpg
465	309	24040cbc3be861cc127a91c33679124d.jpg	t	21511.jpg
466	310	765bc2c6f9eb94eb14e7492f18d8f9c9.jpg	t	21532.jpg
467	310	5a12006b5a8d2f5f24a36f6d37cd6f2a.jpg	t	21533.jpg
468	311	bf29fda5c3fa6861619e746efa214fa9.jpg	t	21504.jpg
469	311	88c7d8915ccd264c2b779fba24621ed8.jpg	t	21505.jpg
470	312	5890d59cbff4897e1b77df81499230da.jpg	t	21530.jpg
471	312	74203237e60090ac99ff8f75acc16696.jpg	t	21531.jpg
472	313	746c251742cc402356193e821bc511fb.jpg	t	21500.jpg
473	313	4ae6aed7c89e5978d9fc8e72f5c87d79.jpg	t	21501.jpg
474	314	70eb4319633d3bf4cfa8cff4c6fe685d.jpg	t	21506.jpg
475	314	c87a6089d26e91b4da9c16f2c159fab0.jpg	t	21507.jpg
476	315	d7d97a27d1418235ea33cf060de64fe8.jpg	t	21498.jpg
477	315	36f5f15e96dd546f252f99720f0bf6a5.jpg	t	21499.jpg
478	316	4362cbd7b71a09b6b077deb18fc1cf34.jpg	t	21402.jpg
479	317	846bf0a2cab628f370efb3e486a5cc0c.jpg	t	21503.jpg
480	318	1cc15bb908324d6554712f10200554ab.jpg	t	21534.jpg
481	318	1944dd6c00b54b4fa246085a41d6eb19.jpg	t	21535.jpg
482	319	daaa2d8267740243ad1e9154ef9806fb.jpg	t	21514.jpg
483	319	32ca1b955dfa0ead1f776bf94032af3c.jpg	t	21515.jpg
484	320	17f8f8d7ac0a3394a5a1c7c63d5fefa6.jpg	t	30274.jpg
485	320	0b54c3e67ba54119fd7f38c20169c5a8.jpg	t	30275.jpg
486	321	5cafabbca0a459d92cbd0ddd4e4a342f.jpg	t	30262.jpg
487	321	e61016104919c894bffc8629ea6f964f.jpg	t	30263.jpg
488	322	82d83bdc7628c6f139dc0d6aad27623e.jpg	t	30248.jpg
489	322	e1249caca69659c07b3da0c068fbe896.jpg	t	30249.jpg
490	323	952d09ef9551ded162ee902aa439376e.jpg	t	30230.jpg
491	323	b9a8fcefb31861fd1d8bc58f66b52a89.jpg	t	30231.jpg
492	324	f91ea999e7fbdbab1c2c9301075efa4f.jpg	t	30209.jpg
493	324	be51d7cb7d35480b49a24ff61d883399.jpg	t	30210.jpg
494	325	d4debf49fc730d2fd06f9484add346de.jpg	t	30252.jpg
495	325	0af7162320c6068f6fb0e9ce7f889229.jpg	t	30253.jpg
496	326	5d456594cf70ddaf73895fce90d5fab4.jpg	t	30256.jpg
497	326	1f87906b6e4316fe43202c9e392269c0.jpg	t	30257.jpg
498	327	38722a5b29794d75102451669f7e96ff.jpg	t	30258.jpg
499	327	6dfe272f589e0d95564055c78f85a182.jpg	t	30259.jpg
500	328	c161b96fedb560248d623b104e1fac99.jpg	t	30250.jpg
501	328	1e294666508a344096576f991b4c9173.jpg	t	30251.jpg
502	329	dc96ea17b841630a64e5e72d5e52bd43.jpg	t	30268.jpg
503	329	efc17ceee6269e7b4661bc86f491190b.jpg	t	30269.jpg
504	330	42f702bae5ac29446806654b8d8c53d9.jpg	t	30211.jpg
505	330	be6946c3cb00ff915a1c2e484ba8f9c6.jpg	t	30213.jpg
506	331	77c45261c13e4e103d458b523bf6a1f4.jpg	t	30242.jpg
507	331	c43883e55cf9249b1dbb156b79fc5580.jpg	t	30243.jpg
508	332	4a8059b2ce516525adc73e50788c5f27.jpg	t	30244.jpg
509	332	a3741f03a0606e7d77accaf237527d41.jpg	t	30245.jpg
510	333	a1d7f3e5438006f00e411bcca045f26f.jpg	t	30246.jpg
511	333	d265899eecd54a42f22dae3ac8244e3e.jpg	t	30247.jpg
512	334	77c45261c13e4e103d458b523bf6a1f4.jpg	t	30242.jpg
513	334	c43883e55cf9249b1dbb156b79fc5580.jpg	t	30243.jpg
514	335	2f406a9cc69314d2aed621d6ad5582dc.jpg	t	30276.jpg
515	335	bb7cb44751b3ef71f734a756ec25cfcf.jpg	t	30277.jpg
516	336	9585d33aa49eedfb09b10b5b50a96035.jpg	t	30228.jpg
517	336	b9a8fcefb31861fd1d8bc58f66b52a89.jpg	t	30231.jpg
518	337	43b8192d71200abb2b605c7bb09811a0.jpg	t	30270.jpg
519	337	f58a0f37fed199b63b58acc2a222e4e9.jpg	t	30271.jpg
520	338	1418c55cb0edba7bb09a9e2fd31d9d4b.jpg	t	30235.jpg
521	338	ef7f606545fa1c7306a7d2cf294681ac.jpg	t	30237.jpg
522	339	23a75ca2ca1b9d50b31f11867cd9d7f7.jpg	t	30229.jpg
523	339	952d09ef9551ded162ee902aa439376e.jpg	t	30230.jpg
524	340	84d2d92f9492a4fefd1bdea9b3601267.jpg	t	30222.jpg
525	340	73f63ff19fc790c932dd6e6f051e782e.jpg	t	30223.jpg
526	341	8e85aab4d401704959332b62b35204d0.jpg	t	30220.jpg
527	341	5245748629cbe320ea5df35daa22d3e8.jpg	t	30221.jpg
528	342	7246e2ba91049c2a0d74cb9b1be74ec1.jpg	t	30212.jpg
529	342	be6946c3cb00ff915a1c2e484ba8f9c6.jpg	t	30213.jpg
530	343	08e3eea8ce167f053a49f57a88f1ddf2.jpg	t	30214.jpg
531	343	ea9870831f282793a76b6481b951d526.jpg	t	30215.jpg
532	344	ca63f0bcf548a97265b1e1d6994b11cd.jpg	t	30266.jpg
533	344	48eeebd81651294ea929862e3e86946a.jpg	t	30267.jpg
534	345	9cff92b26f971ad06c8229b2158a8b39.jpg	t	30234.jpg
535	345	e36c072943c8a7a1abb5167eae2f5ddb.jpg	t	30236.jpg
536	346	1323b49e3d39a184e2726b45b5ece900.jpg	t	40135.jpg
537	346	ec7619447f38f34372f3c229c1aa8e4d.jpg	t	40136.jpg
538	347	5676c94648ca6d74a4ddfdb7d6cc62c2.jpg	t	40187.jpg
539	347	367b2116f7cdbcc9e76c2794f638e9f0.jpg	t	40188.jpg
540	348	3d0e58207b2d779f9424613447d0dfca.jpg	t	40185.jpg
541	348	37325dbac5184fd65ee3cc4ee6d2cf33.jpg	t	40186.jpg
542	349	542b97ebb265fbed87599e0018924469.jpg	t	40271.jpg
543	349	a7b2b37b18858f63085efda46354a964.jpg	t	40272.jpg
544	350	4361cbe47b69c7bc42520d46823e6f0c.jpg	t	40289.jpg
545	350	788b1dce0d3829e02db0a548c5cf5764.jpg	t	40290.jpg
546	351	2f318808cd66e51422ab9351910d1097.jpg	t	40267.jpg
547	351	66d07476c8e8f37cad25768e9f739f1d.jpg	t	40268.jpg
548	352	74718bfa1405f44d5aa136ab8c176fd2.jpg	t	40253.jpg
549	352	e953a86a967bcb79673e1cf6408d9c4d.jpg	t	40254.jpg
550	353	20e609417b3ef7f3f1bfa887ff5e569c.jpg	t	40291.jpg
551	353	db5cb567e6b0e2619093e37cae500453.jpg	t	40292.jpg
552	354	c909ebe938c838e2c556ed79c627d783.jpg	t	40225.jpg
553	354	a5668bc7e90cc58ef78a3cf8d042602c.jpg	t	40226.jpg
554	355	98f3a33b2caf16e005ab088c3d71f3c4.jpg	t	40239.jpg
555	355	5b07fc2ab4c5f94a5845165065c5e0f4.jpg	t	40240.jpg
556	356	02c621bde92d99a849b157822e67f644.jpg	t	40227.jpg
557	356	1f00b3b83edd1ca6c1d26e6a7a3146ce.jpg	t	40228.jpg
558	357	3b8a9128b8d5adca62f820fc7332ef77.jpg	t	40233.jpg
559	357	f460bef36769ec211d6c81bd500c0c05.jpg	t	40234.jpg
560	358	1940a93f8bc1c9455be293ab6710ff8e.jpg	t	40229.jpg
561	358	a5cbf3042e0033e44e60f85b4603a095.jpg	t	40230.jpg
562	359	4361cbe47b69c7bc42520d46823e6f0c.jpg	t	40289.jpg
563	359	788b1dce0d3829e02db0a548c5cf5764.jpg	t	40290.jpg
564	360	9097b747e5f6918b6b7bd4288bac4dd2.jpg	t	40273.jpg
565	360	de3a01fc476f0c6a3a049396123d23d6.jpg	t	40274.jpg
566	361	b03a03fb2d2108c22046a2338066e3cd.jpg	t	30081.jpg
567	361	4e18dc5f6f7f6708d2194a75c4a348f1.jpg	t	30082.jpg
568	362	b20b12cca89afd8b6903409ff44b8748.jpg	t	40257.jpg
569	362	c420e4f14c7f76de04d9181b9cbc60e9.jpg	t	40248.jpg
570	363	70e75a7107a585d942baa8466c405dee.jpg	t	40263.jpg
571	363	f5383a232d783632f940c32ed59dc6fb.jpg	t	40264.jpg
572	364	f7f9c529636440cd4521089474cc5251.jpg	t	40261.jpg
573	364	2cac48a62a41cefc4cf6f16dc316889e.jpg	t	40262.jpg
574	365	b20b12cca89afd8b6903409ff44b8748.jpg	t	40257.jpg
575	365	94e1e7c73eb6e26ae0004d686d0153ee.jpg	t	40258.jpg
576	366	d7b7e5714e58f6fd98584eb27fc8b262.jpg	t	40295.jpg
577	366	41bf2ff55478af60b7473c6ab3e36ba6.jpg	t	40296.jpg
578	367	9e937c24f63e24d21df711a5d7494bea.jpg	t	40243.jpg
579	367	19e9fdcd70603a05ad0321007d05e09a.jpg	t	40244.jpg
580	368	96369f8c31fa547ea67e93fec2c7a9c8.jpg	t	40281.jpg
581	368	d80d52a40726fb0bc0ccf58c7a77e273.jpg	t	40282.jpg
582	369	b79704962702fcedaf8214ddfd9080fb.jpg	t	40277.jpg
583	369	a8cee8453f46a8cb9b9b0058d2e6ce27.jpg	t	40278.jpg
584	370	ef4b43feb2c4ed9f6e76ef6d6063922c.jpg	t	30133.jpg
585	370	b7bd889e19a3727aecf29304eda8f079.jpg	t	30134.jpg
586	371	fa425fdca5d2bf1852f716a994aca92c.jpg	t	30105.jpg
587	371	21456c56453cb2da3f92038bd11c71e6.jpg	t	30106.jpg
588	372	27ab6ce9f388d70ba67563f241a9f733.jpg	t	30071.jpg
589	372	ccf41fa71b7ec5cf97f17ce62e58f763.jpg	t	30072.jpg
590	373	d8712566854b2bd07887b0d56427953b.jpg	t	30141.jpg
591	373	df0bbdc086aaa239f80acaf173e887ed.jpg	t	30142.jpg
592	374	43d6a737e92bc5e87cd9e487c85125b1.jpg	t	30151.jpg
593	374	3f16f2fb036cfd6dd6b3e014e4ca3ac8.jpg	t	30152.jpg
594	375	c8c1db06c7a4f93b8bfc7c5c845958b1.jpg	t	30157.jpg
595	375	952715fd7c04cfd427f0375441d953cd.jpg	t	30158.jpg
596	376	355ca7deaa362de69e564cc3c4b08a6f.jpg	t	30101.jpg
597	376	ada06909650c4d4849567c825ba0fc5b.jpg	t	30102.jpg
598	377	13076184cc1ad260ec43ef5c73c9782e.jpg	t	30091.jpg
599	377	2bec0d874e73a24608cc109c1f873889.jpg	t	30092.jpg
600	378	5c19f698eba2349e555daacd369e9ec3.jpg	t	30077.jpg
601	378	fa9e883c35b510d8dc39f8660766d0b4.jpg	t	30078.jpg
602	379	5904a7ee518d90e235c88b9fd40d61ea.jpg	t	30097.jpg
603	379	6bb25f705665bc5253b7c8fc8a1b0623.jpg	t	30098.jpg
604	380	38ae527ac7ef8c3ebf5c8f2bcca031e9.jpg	t	30129.jpg
605	380	45fe32c3b8f0b535a0d6336cd3beb137.jpg	t	30130.jpg
606	381	33c30c25a46e1fd93102b3b395c55b1b.jpg	t	30073.jpg
607	381	fa82bad7c5c12e059313c1a0d4633450.jpg	t	30074.jpg
608	382	540da985006e0e22a027dadc5d5b729d.jpg	t	30065.jpg
609	382	4d57b6682ff93aac5eda353d019a3646.jpg	t	30066.jpg
610	383	40e8c947f232b4849e3687da152e1399.jpg	t	30139.jpg
611	383	cec7838028bb000f9a44e47dc8e50abc.jpg	t	30140.jpg
612	384	23d6b1a831753cd68217cd9422609d5c.jpg	t	30137.jpg
613	384	fd43c50a2534bcc348580acf9c1f2cb3.jpg	t	30138.jpg
614	385	cd88eb717ded391383b863732c8225b5.jpg	t	30085.jpg
615	385	f2792fa87ac9e2342a1518d5a0a6652e.jpg	t	30086.jpg
616	386	31dcc583905bf5f4d9e20069412b32d8.jpg	t	30087.jpg
617	386	050499de74e5fbcec00e92930b3cb47e.jpg	t	30088.jpg
618	387	97245baffb4b8d05d70053666ab923f8.jpg	t	30095.jpg
619	387	cf23e634a4b784b1085cc3dda306d7c2.jpg	t	30096.jpg
620	388	432ee0127f2dc10febdd8025380e6e9a.jpg	t	30117.jpg
621	388	2198b5860d209146af1ab24062013567.jpg	t	30118.jpg
622	389	6ffc6ae9db78654769ab7a6e23797d57.jpg	t	30116.jpg
623	389	feeee181e0385c29071ae473842a1d77.jpg	t	30115.jpg
624	390	a7332eae68e3c7b3e91a4e810590e440.jpg	t	30125.jpg
625	390	0b9c9bfb5afe141dd19a920e72119740.jpg	t	30126.jpg
626	391	545e45623a9a7f5c323287c4bc7a406c.jpg	t	30119.jpg
627	391	a3c78df68ee08663b0b32fe647aaeb91.jpg	t	30120.jpg
628	392	6bfe3f5fff18e51c38d069ba90aa5a2a.jpg	t	30147.jpg
629	392	0423a8f3ab0b3d0b73cbcaf0bd232c99.jpg	t	30148.jpg
630	393	5001bbeb60cf80e36897eeb2aab7fddb.jpg	t	10986.jpg
631	393	a1ad3e0b23fea2cee848a0c5d36d9902.jpg	t	10987.jpg
632	394	6597acc64b8aea6dc83c6442e355ded3.jpg	t	30127.jpg
633	394	1e3d4a12aa2893a19769c0cfdb00df03.jpg	t	30128.jpg
634	395	3f0014bf36587b49b16d1434ff283b5d.jpg	t	30143.jpg
635	395	913d08be91508888e7b838e260df5987.jpg	t	30144.jpg
636	396	ae1c5c21b1f4764d267657408afe1c07.jpg	t	10254.jpg
637	396	7353580a04383688c15cc76b201677fe.jpg	t	10255.jpg
638	397	78898482ab86ae0fc1821af6306205bf.jpg	t	10982.jpg
639	397	048ce080c39a5cec3b78e1ae836c4c73.jpg	t	10983.jpg
640	398	dc79f15917e92b04a962810581417817.jpg	t	20607.jpg
641	398	9c8b4260c63d07674ef9cef9e39c56ed.jpg	t	20608.jpg
642	399	aea377dfb710e0e1d5fecdfd2d9cb2ab.jpg	t	20603.jpg
643	399	0a3ffa49202b59ceedabf2474e428187.jpg	t	20604.jpg
644	400	4adfa62288d6f00f79892b53cd225f76.jpg	t	20587.jpg
645	400	3ad4ddc07b40ddf5236b1b20d1662e34.jpg	t	20588.jpg
646	401	f55c55bc5c85fba1b1f95a637bf83ab0.jpg	t	20617.jpg
647	401	28c3d92ede93f263825f1e0c9b3ad3ca.jpg	t	20618.jpg
648	402	4dc8b0f833c0b801bf329665a455a06b.jpg	t	20585.jpg
649	402	8968404bfb51c010912565ee4fad8b6f.jpg	t	20586.jpg
650	403	41e945166506d9bfc8a67a5369c51dae.jpg	t	20599.jpg
651	403	f472aad80fbb4d8fcfb66ffb41843251.jpg	t	20600.jpg
652	404	ae29ab9af18a4e6dca276fcfb22022fe.jpg	t	10861.jpg
653	404	c7f56b3a27cafc437fbb47bdc4fb8a69.jpg	t	10862.jpg
654	405	93a190456978597431c9f8ca78f294a4.jpg	t	20591.jpg
655	405	bbcb9393ed4c4aefd44bce97e73ef7a2.jpg	t	20592.jpg
656	406	9d59c0a7983fbd783b57109224630694.jpg	t	20611.jpg
657	406	e9e1f7f594551b8bb4364a5f72a0ab7d.jpg	t	20612.jpg
658	407	c5aefba4213159b54991e1118e7131fc.jpg	t	20613.jpg
659	407	b72762693c5b4ea8cfac8f44c19376e8.jpg	t	20614.jpg
660	408	3cb9709fbba35bc6766c19f97a63f7e1.jpg	t	20595.jpg
661	408	0e985417c0a23bdc962cc917a43cc363.jpg	t	20596.jpg
662	409	adcc1f19c842413d55ebfc19e6658959.jpg	t	30537.jpg
663	409	42f61f509e0a5be267993ede7ec2c871.jpg	t	30538.jpg
664	410	e7152fe60660f40a93e1d1601decaa0b.jpg	t	30559.jpg
665	410	e7bcd4a20534bb2f73f8384aead3c6e7.jpg	t	30560.jpg
666	411	88d7b3286f4418993a1e526a7c5765be.jpg	t	30526.jpg
667	411	313f01907666a5b7caebeb0f393c2762.jpg	t	30527.jpg
668	412	2c26d4d5da77d6a13bf791f2f770c9df.jpg	t	30688.jpg
669	412	56b81f6109850264c9f6535235d354a8.jpg	t	30689.jpg
670	413	491453798406f889fdcc0c6356956368.jpg	t	30678.jpg
671	413	8f8b32cc7597b315b301769b104422a9.jpg	t	30679.jpg
672	414	8f92d2884e14a4f09fd8e5d9667d0ef2.jpg	t	30555.jpg
673	414	1c8a0f2b93141d5087c41963636534cf.jpg	t	30556.jpg
674	415	9c80092fcad1cf62b5bd95680969147d.jpg	t	30684.jpg
675	415	bc5766088b8737ea53f98e6f053088ad.jpg	t	30685.jpg
676	416	13a640cbdcb78c4d57287bfe73d2fa68.jpg	t	10945.jpg
677	416	e3e6c04fc19275af65270ae66dea5d55.jpg	t	10948.jpg
678	417	4ea8b450406b857ca179cfa03e8b9fe9.jpg	t	10883.jpg
679	417	eb5743211967c0957dbd9f4854245838.jpg	t	10884.jpg
680	418	aaf1d2e4650318d4ee5bb2d4de9c3022.jpg	t	10899.jpg
681	418	509ea2001cbebaea20dc67133d9af5fc.jpg	t	10900.jpg
682	419	443eca5c6c72066f8e048c83cfe35ff2.jpg	t	10895.jpg
683	419	91e8d86d0574ddeddcd788894fdb9fc7.jpg	t	10896.jpg
684	420	8934be3b12a7cb9154440bf11b8dbfa4.jpg	t	10905.jpg
685	420	8f2c9ae5b3f93684c2f1740237148cdb.jpg	t	10906.jpg
686	421	601011a693f9d79cb1afd41dffa26cbe.jpg	t	10923.jpg
687	421	f04ef13d139f91252c0230cdfb07c309.jpg	t	10924.jpg
688	422	601011a693f9d79cb1afd41dffa26cbe.jpg	t	10923.jpg
689	422	f04ef13d139f91252c0230cdfb07c309.jpg	t	10924.jpg
690	423	a0dd24f5b1e03eb1cb13d94def385335.jpg	t	10891.jpg
691	423	77c880a68aa4e16a934441bfa7d87e30.jpg	t	10892.jpg
692	424	b97098ff3d0faaefcb1b489fff615d7b.jpg	t	10911.jpg
693	424	6060eb739d94e07c533f3ba444212dd9.jpg	t	10912.jpg
694	425	879f0f853609a40408c1bdc2fa79e3b4.jpg	t	10907.jpg
695	425	8be8540ed376da2c116c94431b621383.jpg	t	10908.jpg
696	426	fb7f1b61120101d4075128aec9948415.jpg	t	30403.jpg
697	426	802eb26ff8d1ade666eecee0c340e0f8.jpg	t	30404.jpg
698	427	e5585b95358bd1d044883ee4332a1689.jpg	t	10921.jpg
699	427	d5e32baa7b7c12887fcaa29af1c9d9db.jpg	t	10922.jpg
700	428	4b1f36da80ed3ef54483c5f63e8ef105.jpg	t	10935.jpg
701	428	97955b2bcd261306945e9503ab47e4b0.jpg	t	10936.jpg
702	429	a0ee2d233ef063e31f58a7d8c6b98428.jpg	t	10937.jpg
703	429	1fcc91221f843bf38f9e4abe0e9f0313.jpg	t	10938.jpg
704	430	83cf7b221abeae64b9c46ab2a6a8e8c0.jpg	t	10889.jpg
705	430	aef5b8821d21afddf1877aa0ef06698d.jpg	t	10890.jpg
706	431	92b62979dbee5ec99816defd885306e9.jpg	t	10885.jpg
707	431	9cb6445e19157e2b4356627b8dae8c8b.jpg	t	10886.jpg
708	432	e3c4868c97f7648692190db414adc738.jpg	t	10853.jpg
709	432	fbb705010c585e7ec3e6e94fe1c4daf1.jpg	t	10854.jpg
710	433	7a3946295952195a51bd9dbea9e64843.jpg	t	10849.jpg
711	433	6269e2d83c64850dea9e52a60112fd5c.jpg	t	10850.jpg
712	434	27d01250e0673cf29a03fefba451fc85.jpg	t	10845.jpg
713	434	9e35a1e6c02c76dbd2f8642d09541b6d.jpg	t	10846.jpg
714	435	b2cc411ab1a20bf38dbb989d298f25a6.jpg	t	10859.jpg
715	435	446a4427dce184faff083be8c68dfcd0.jpg	t	10860.jpg
716	436	4e9f22f0e2d9787c98c44852fbda0062.jpg	t	10851.jpg
717	436	2cf4bd65960adcdaa16c362c14363cde.jpg	t	10852.jpg
718	437	e12302f2c6b41b333173d74161e7da7b.jpg	t	10927.jpg
719	437	41f58a27032c381f42abe626a5cfcbe4.jpg	t	10928.jpg
720	438	ca5894aca96a0245a3ad08c8c196b058.jpg	t	10943.jpg
721	438	4a91c90b24c430e7fa3832519a7d552c.jpg	t	10944.jpg
722	439	a9768a1a83a0fae4306c5244bb14dc6a.jpg	t	10875.jpg
723	439	17170987f5e24c476726255693bd5e82.jpg	t	10876.jpg
724	440	d1f529412fcdcfcc16916356ec19b6ea.jpg	t	30577.jpg
725	440	2415403075a4a323498cbe9ef25bd1c5.jpg	t	30578.jpg
726	441	d31da9460e7e75079f4b6271882c4f04.jpg	t	30599.jpg
727	441	ade0ac60cf01119795d2ab6141984efc.jpg	t	30600.jpg
728	442	3804b868a521888ce7f5333f7c3ed9ea.jpg	t	30608.jpg
729	442	b7e1a8a417f34dd2fa29323d9a7e98a0.jpg	t	30609.jpg
730	443	6438975d416fc97546bd494263e0bc14.jpg	t	30643.jpg
731	443	46f14c9b4f82267b0bd652c28eb6391e.jpg	t	30644.jpg
732	444	9d55e4a329c6051351564798085f24af.jpg	t	30589.jpg
733	444	0889ed1ce344a3fc24a2b61b808d6827.jpg	t	30590.jpg
734	445	72e7867e1eb1e9cb56e15361784b6649.jpg	t	30638.jpg
735	445	d5b0f19c1919eb4d32c7ddee90323f8e.jpg	t	30639.jpg
736	446	084169d8c543c51b24569bf18eae7a9d.jpg	t	30640.jpg
737	446	179df930e8decd299d74d27402925f1c.jpg	t	30642.jpg
738	447	c007912ff2283389479f6fee9e2e408b.jpg	t	30610.jpg
739	447	cb9c2c5418782e0b3179ca599790c825.jpg	t	30611.jpg
740	448	723e2cab39c273707fc02b01312de055.jpg	t	30571.jpg
741	448	88d3eb2d3d24bf8fdd49e070d14f4996.jpg	t	30572.jpg
742	449	57f644e45e5f7f7a8107199782cf6157.jpg	t	30583.jpg
743	449	10996b5dc23a5fb5c1203d61aecf2c3c.jpg	t	30584.jpg
744	450	bbc1796fa74a8e54ab2cf172a21101bb.jpg	t	30630.jpg
745	450	5844ade699abad2cd669896f9d5c08bf.jpg	t	30631.jpg
746	451	317ec6f3dd45b8ff05cdbb5b4da3b07d.jpg	t	30624.jpg
747	451	055ff620adf0e1e8aefa7f5ed055f4f1.jpg	t	30625.jpg
748	452	9185dcfaf379261fec292fb6b1106234.jpg	t	30601.jpg
749	452	b5e9354584cb822f3a55a1fb55b68970.jpg	t	30603.jpg
750	453	a05011aaee75e33cac7f9f3c9e0881ef.jpg	t	30585.jpg
751	453	9df445ab61ce1966644f9f89a22a8446.jpg	t	30586.jpg
752	454	69e9bb2b2727b81faca40e4b23907914.jpg	t	30528.jpg
753	454	28cc9e90ce4b08edaa482e8f244e0992.jpg	t	30529.jpg
754	455	32214a32f563adb559fcb17a86337178.jpg	t	30618.jpg
755	455	f5593310d9310a4f48ca7385e35e3af5.jpg	t	30619.jpg
756	456	dc8ec90127bf688a43e329d93959be9f.jpg	t	30593.jpg
757	456	dadf280c94ba3a9b189dc788c9ec85bb.jpg	t	30594.jpg
758	457	6b22b8ef36314dd04d576817fe464672.jpg	t	30634.jpg
759	457	9a589ac357df564046a27e4631433255.jpg	t	30635.jpg
760	458	02e7ee14b37c2896ef90bed52df13b13.jpg	t	30579.jpg
761	458	39bf26a8c9fd719a5439509782038982.jpg	t	30580.jpg
762	459	291e1b8eaa7e95e8ae2800e2b452c01e.jpg	t	30612.jpg
763	459	6d59480a55855f2d5e173d8c3c103287.jpg	t	30613.jpg
764	460	13a534411c047cd53647bba4d30394f0.jpg	t	30606.jpg
765	460	b37ac8479af27b90d360312132770d50.jpg	t	30607.jpg
766	461	b8b4e042cced7abc655943c9eb5fcb80.jpg	t	30573.jpg
767	461	4d2dcb5c48baf0a7361355c454bbc8a6.jpg	t	30574.jpg
768	462	dc8ec90127bf688a43e329d93959be9f.jpg	t	30593.jpg
769	462	dadf280c94ba3a9b189dc788c9ec85bb.jpg	t	30594.jpg
770	463	b1209855efed3feeaf2bde82577ef577.jpg	t	30587.jpg
771	463	c82e3b0433a3e3a28223947eb3cefd21.jpg	t	30588.jpg
772	464	fb8af538c62683638b89d6638da29510.jpg	t	30632.jpg
773	464	1abdf6df704bcb35d9cb730df5cc0d9e.jpg	t	30633.jpg
774	465	d91c79b84c642b93c63beb9d743a38cc.jpg	t	30602.jpg
775	465	b5e9354584cb822f3a55a1fb55b68970.jpg	t	30603.jpg
776	466	736a5edbaff869252ae23266ff5f2e41.jpg	t	40099.jpg
777	466	1e62bb77f021bc08cccaa200e42bbf6c.jpg	t	40100.jpg
778	467	9b8c0b1c0e993afd2c8416c6803306a5.jpg	t	30411.jpg
779	467	9526e441c35e69a6fbaae17ee9453bdc.jpg	t	30412.jpg
780	468	1d074307fea37229c1c8124d4c37d742.jpg	t	30522.jpg
781	468	b7883da65682fab1fdbc1c9c488d33c1.jpg	t	30523.jpg
782	469	37e1b124446ee0bb5a51097d3bde0b51.jpg	t	30518.jpg
783	469	3039b97d448fd42b593bec7c5a2177ae.jpg	t	30519.jpg
784	470	e08dcae3a04adafe0d3f7a0afbb6c7fa.jpg	t	30502.jpg
785	470	ecd23a37cc66d4114b8ee76b8823a4e2.jpg	t	30503.jpg
786	471	3bbc1f6bd2688cdd0e494d65c986dd31.jpg	t	30520.jpg
787	471	8591fb0f616524e57286d4e15bd18288.jpg	t	30521.jpg
788	472	831dfd4aba1a04a29c36ebd2f543d1b2.jpg	t	30516.jpg
789	472	cca5dabb70768741245926305a0b02c8.jpg	t	30517.jpg
790	473	4a873bae1f73293e156dfa3362005f76.jpg	t	30481.jpg
791	473	b0659cdb33c59cd53249e33c1960bc13.jpg	t	30482.jpg
792	474	629eed271c28a4c541194adeb1b496b4.jpg	t	30492.jpg
793	474	23ac6bb3d753208dca91142c869a1187.jpg	t	30493.jpg
794	475	9dccb13e6fe95c59699331ff2f45dbd2.jpg	t	30389.jpg
795	475	e0adb7eedda16e9314983907bb58677a.jpg	t	30390.jpg
796	476	c870f1eb87a03be3c475bbf00cdcea61.jpg	t	30423.jpg
797	476	6b0378cfedc8684eb1710f95f79ae9d8.jpg	t	30424.jpg
798	477	6488b98982678cfcdff5e8f191e1b0fb.jpg	t	30409.jpg
799	477	f442a4a391c4b7119784ae0dbdcc1e73.jpg	t	30410.jpg
800	478	3a37097cea7f23f4d1c7171dd2e884e3.jpg	t	30435.jpg
801	478	5e0c3fee9730862aef9ea8de9fb5985b.jpg	t	30436.jpg
802	479	ecc67db7ec51abdea2cdfcbcb1c6ff6b.jpg	t	30405.jpg
803	479	18a4e8371a796553e6750252fd51d414.jpg	t	30406.jpg
804	480	00012e559d33b961463f1d86f315be8e.jpg	t	30401.jpg
805	480	e1aa7a90411709170ac465e01d09198f.jpg	t	30402.jpg
806	481	e52dd848bbd5a82a1846d1d5cbd5ae5d.jpg	t	30500.jpg
807	481	f6ade54e4d9708c4235847687d3cec4d.jpg	t	30501.jpg
808	482	753d94e7a9c5dcf40a4e170c25f0ae19.jpg	t	30391.jpg
809	482	6cbe0e342b843c2426ec555103ba545c.jpg	t	30392.jpg
810	483	eab2c401ce6519c0f3f2d1ff8ff99354.jpg	t	30441.jpg
811	483	97de5b3cf0a5cc2919e1678bb1727e1b.jpg	t	30442.jpg
812	484	dc6935a2daa92f6f85d0f4ecebdf31de.jpg	t	30399.jpg
813	485	394c1a744b6f56181cf3a8fdf76b985a.jpg	t	30340.jpg
814	486	44400ba279ce4ce881b9bd8bffea861f.jpg	t	30413.jpg
815	486	6ee98fd445a10bc77ad8bec7b420f717.jpg	t	30414.jpg
816	487	00ebf4195a41d340f634a8cfe0c117a2.jpg	t	30524.jpg
817	487	b7883da65682fab1fdbc1c9c488d33c1.jpg	t	30523.jpg
818	488	10861ac54bab713e5a44939022fd0274.jpg	t	30395.jpg
819	488	84909cff79977349135b0f0df063f0ce.jpg	t	30396.jpg
820	489	e5c197acf4aa0c410e5856acc616222d.jpg	t	30417.jpg
821	489	d4c73f2c83209548b6760b83481260dd.jpg	t	30418.jpg
822	490	108ba200fe528bce6ef365e2749b55d0.jpg	t	30514.jpg
823	490	d713ab53c4e8d02438e579e8abcb2f8e.jpg	t	30515.jpg
824	491	829367c83b3b5e7b858aebe07d330d5e.jpg	t	30397.jpg
825	491	ac3b88702b018e2574273b38815561cf.jpg	t	30398.jpg
826	492	57429b0c673ee671f245618e93851ece.jpg	t	20158.jpg
827	492	4a4b8d4019672f43d0a3f32df5533369.jpg	t	20159.jpg
828	493	3a4ff873d63f1c33da7595d4303ca49b.jpg	t	20160.jpg
829	493	db86dd40ee610ad066792430fdd0305d.jpg	t	20161.jpg
830	494	73d871d94240231cfeb35eb26e57606a.jpg	t	20121.jpg
831	494	e4a00734ba33b1665a1f5c7901ef8592.jpg	t	20122.jpg
832	495	6794bf8f2c4e66ef5e6121ff6fc6a77a.jpg	t	20150.jpg
833	495	1b533363e1e5665503e663e8d1e03db2.jpg	t	20151.jpg
834	496	fb5ed6e37890afd478d6768ebccbacfd.jpg	t	20143.jpg
835	496	481aed55789eeb14ec4c47b924d06efe.jpg	t	20144.jpg
836	497	76d36d9da2f8eacb450485d1ab8facaa.jpg	t	20162.jpg
837	497	e11890a6eba04724127bc318814cdb3f.jpg	t	20163.jpg
838	498	0cb7140337b87ed3f48148ebf03d85ad.jpg	t	20125.jpg
839	498	b4e563badb073d1ed9c102a1605bbab4.jpg	t	20126.jpg
840	499	533735c5126e7971de9d3ffc4ea922a4.jpg	t	20137.jpg
841	499	becffd2d69fa460a17f340cdd59e81aa.jpg	t	20138.jpg
842	500	fc11bf2e63c938e8e24aec4c20d01a54.jpg	t	20127.jpg
843	500	ea2f9e9dc94e4116bd41f8ffa8121344.jpg	t	20128.jpg
844	501	5a4dfc456544f87444737020e5a9a221.jpg	t	20131.jpg
845	501	42674811d66c10e0daa0066c74f3b68f.jpg	t	20132.jpg
846	502	b93f8154ddaaa7f510ca2d13583db881.jpg	t	20135.jpg
847	502	10b694ab83cb9223b4664dca21fc3bce.jpg	t	20136.jpg
848	503	f8fc2201315af33f1b22009d36c890c1.jpg	t	20152.jpg
849	503	a39a0f4673bfc8681713c258b621ad40.jpg	t	20153.jpg
850	504	befee3834e58bb0e9f82607a91fe63e2.jpg	t	20156.jpg
851	504	9f57f0571fe676faff68985900980557.jpg	t	20157.jpg
852	505	752eadc489e8b2a72a24d6d24f1ed439.jpg	t	40203.jpg
853	505	2fb5136e99183ebd3d20f21461010974.jpg	t	40204.jpg
854	506	afc92ab4aeb190ec0969c9cb48047d52.jpg	t	10317.jpg
855	506	6e7e5ed3d837b12b6d54ad6dd7a3221d.jpg	t	10318.jpg
856	507	d78836756f446f8d50f91f5bc6b7ec87.jpg	t	30706.jpg
857	507	d160788b8605ca323952dac29c425872.jpg	t	30707.jpg
858	508	cce9eff7a44ee5452f4abd8fbd7ea6b1.jpg	t	40193.jpg
859	508	4f9983f6773c6ddf5fa338efd9cec791.jpg	t	40194.jpg
860	509	547d153d70237ecf1f77cd7411d05868.jpg	t	40165.jpg
861	509	ed7a65d53b2f783f264e15721e8acb85.jpg	t	40166.jpg
862	510	3e59fa2070aaca1f458ae7a2a3f32381.jpg	t	40169.jpg
863	510	1d02e5602d9b5874cb2314dc35204906.jpg	t	40170.jpg
864	511	271d67838404778da638911dfbb5e6e7.jpg	t	40147.jpg
865	511	f6912bdd82e17d5f67604198a8be58a3.jpg	t	40148.jpg
866	512	8e1711cb91e647be7c8658759c38d38a.jpg	t	30714.jpg
867	512	8e2c55237475b6d262a9650b9611f222.jpg	t	30715.jpg
868	513	d78836756f446f8d50f91f5bc6b7ec87.jpg	t	30706.jpg
869	513	d160788b8605ca323952dac29c425872.jpg	t	30707.jpg
870	514	6c7b8e248b0868800097999338af0598.jpg	t	40141.jpg
871	514	246bcadef646501e8ca89c67d01873aa.jpg	t	40142.jpg
872	515	4f02d6cadd1546dcacdbe311213b46a9.jpg	t	40139.jpg
873	515	e730101580d7fc6a59f33d36d9817005.jpg	t	40140.jpg
874	516	dbb6441a77277d56cabfcfde2ac99902.jpg	t	30710.jpg
875	516	5767aa4a24666720610f5b81450403d7.jpg	t	30711.jpg
876	517	39d32482cb947a1628b74b59445b36fd.jpg	t	40131.jpg
877	517	0565ef75989d9c0f79a4337538fdad96.jpg	t	40132.jpg
878	518	7a6daa1ffee0cbcc8781b7b2d084fe8a.jpg	t	40195.jpg
879	518	4da80062c964bd7c22c0ae6d60b199f0.jpg	t	40196.jpg
880	519	a5d0dbabfa615c513cfcd930fb665ef7.jpg	t	30696.jpg
881	519	d34f4ac5c99387622886ec9e77864949.jpg	t	30697.jpg
882	520	bfc1f89e04181efad5d8c1aa34cef1b3.jpg	t	40207.jpg
883	520	b917c6ec2d12ba7436e21c15f47a993b.jpg	t	40208.jpg
884	521	4aa76d750099457ff338be1b16068bd0.jpg	t	30716.jpg
885	521	fb7786587cba37cbfeb2d74be3838617.jpg	t	30717.jpg
886	522	cb40da140d73cefbfca639c149558f0b.jpg	t	40161.jpg
887	522	8baa2983fd75127f00fc47a36fe3a380.jpg	t	40162.jpg
888	523	64b0f0e69b641a5b65f671c0caf1b539.jpg	t	40218.jpg
889	523	dd6860105753662c95f66fdf06c01c20.jpg	t	40219.jpg
890	524	6491a1da7be5710735c93bbc210bbfeb.jpg	t	40155.jpg
891	524	b7e014bfbbc12e1b489580b57b1042b9.jpg	t	40156.jpg
892	525	26e1c75f23380ae88a7bffb4c315f88d.jpg	t	40181.jpg
893	525	c11d9c57cb4c2fc13194c8c8ccca5366.jpg	t	40182.jpg
894	526	4f8ca825378c3cde649516087819ed8c.jpg	t	40145.jpg
895	526	18be5dcc39fe82c14f1a9eb3bde851a2.jpg	t	40146.jpg
896	527	a308d70b256c3423e91eac0c40574831.jpg	t	40209.jpg
897	527	e347e3dff8f561eb277a242756a3af83.jpg	t	40210.jpg
898	528	b17a60393f3332b654c8effdf68ff480.jpg	t	40153.jpg
899	528	aaa9f020a23870abda2c456eabb5a0f9.jpg	t	40154.jpg
900	529	0053bbe962591aa8d46b0bb317bd9f4e.jpg	t	40179.jpg
901	529	561cb5a733f526b09b70ea688412858c.jpg	t	40180.jpg
902	530	91ef17a2544abf21964ee331053da787.jpg	t	30702.jpg
903	530	7d7b647255982a73e82e4be202efdd17.jpg	t	30703.jpg
904	531	15d0242274437717fd91833bf755e0f3.jpg	t	40213.jpg
905	531	765c8d729db4bee3060a70762566b04d.jpg	t	40214.jpg
906	532	600a713fc9f6ed4a8534e3c34b383fb8.jpg	t	40173.jpg
907	532	a9846da31ca68c427519f7f90956fd1a.jpg	t	40174.jpg
908	533	5ee0bcf18165c55a9502e31ccd9f56d4.jpg	t	40175.jpg
909	533	83989f9a77d61e8c476a7868061641fe.jpg	t	40176.jpg
910	534	c3a6533d06d2ec1bf7d52021522a9ba1.jpg	t	30692.jpg
911	534	8d45126391ca45c8b40cf6ca62f45c67.jpg	t	30693.jpg
912	535	c4c3db49fdb5f5e22a761ffab9be5138.jpg	t	30694.jpg
913	535	85ef8d4f7835dd336b7cffbfa4802c37.jpg	t	30695.jpg
914	536	4a35057dfe7780b8a0e8a157cfe9cc22.jpg	t	10310.jpg
915	536	544a7fbd8468cd429a18b60afc2b9a94.jpg	t	10311.jpg
916	537	11a781ff1a065503a815e999940bee28.jpg	t	10324.jpg
917	537	a58e51725cf19c058fe2b3fc36f150b0.jpg	t	10326.jpg
918	538	c047a3e111250b4e61cfd3cff1671d3f.jpg	t	10302.jpg
919	538	a71742b2a08107596bb5898b9c16d297.jpg	t	10303.jpg
920	539	0655c7220f259479388d6914f357895d.jpg	t	10331.jpg
921	539	997df6057652cd8546b3792cdd44670d.jpg	t	10332.jpg
922	540	f485602ceb5fe4b4d9022ea3c39daeba.jpg	t	40507.jpg
923	540	5e779565ccf86e6c83cf165b4e85b506.jpg	t	40508.jpg
924	541	424cf214c2a99a877c54982f7239b99d.jpg	t	10304.jpg
925	541	a5058b947ac325bbcbbb52ff27a93ad8.jpg	t	10305.jpg
926	542	88b9b8065c828f7539c07eaa79167aaf.jpg	t	40501.jpg
927	542	2710558189cb7f9fb20ddb70c3868d83.jpg	t	40502.jpg
928	543	e0f3aa196f8d2ce8f0611928d3d8ff1d.jpg	t	20690.jpg
929	543	6f895fe616607f5a14141c43032e8626.jpg	t	20691.jpg
930	544	4b2f7b32a2228a7aa823b662f7ffb1bd.jpg	t	40505.jpg
931	544	0100ac539c61ca9b8c205e624c65bc1f.jpg	t	40506.jpg
932	545	c520e58f1e66c9c2b0f21e2238b6a8a1.jpg	t	10308.jpg
933	545	0c6a04681aac6b9e0366753af40839b1.jpg	t	10309.jpg
934	546	51e6ea6c2cc21e92cf7dcb62648b86de.jpg	t	40503.jpg
935	546	ee22ee85d26457ae5f333151506ea0fa.jpg	t	40504.jpg
936	547	790232e599d0a639a1367788ccc02f0f.jpg	t	40509.jpg
937	547	ef98bda418d53b08af0afa960b98a234.jpg	t	40510.jpg
938	548	a26790a24dbd6e6c47af0ea61cdfda88.jpg	t	10321.jpg
939	548	dd197dc47ec36e43e8c3bb6b3850b6a9.jpg	t	10322.jpg
940	549	981603d2242d3e2f7dbad97f051c09f7.jpg	t	40497.jpg
941	549	cebc7ec2c3457998de6936d4694c0efd.jpg	t	40498.jpg
942	550	72b75964fba2e1c255585ae16c01f78e.jpg	t	10315.jpg
943	550	785c493c58d1b242100fb789f8f2e779.jpg	t	10316.jpg
944	551	d0cc652f1af221bf03ddb4f97f8a636c.jpg	t	30319.jpg
945	551	f8cea8beec3fe82be7da4759c564bd33.jpg	t	30322.jpg
946	552	b1016db3e1cc87bfd8d8f36ba81b72e1.jpg	t	30341.jpg
947	552	c956714117e2c302085ac8a12159fb00.jpg	t	30342.jpg
948	553	d6f58a60468f4418320a6a9e8a36956b.jpg	t	30351.jpg
949	553	37700376908a54ad4ad23c6f97d42d3e.jpg	t	30352.jpg
950	554	521cec56c8600692245f722482674b66.jpg	t	30347.jpg
951	554	c60ad2ea25aa566a30df75673890d22a.jpg	t	30348.jpg
952	555	8eade95859468c78431ce6551446e054.jpg	t	30339.jpg
953	555	394c1a744b6f56181cf3a8fdf76b985a.jpg	t	30340.jpg
954	556	3198f668f7176b3779c5cf60b58434fc.jpg	t	30336.jpg
955	556	d3ec3392ff3354b88e046587d08dd72a.jpg	t	30337.jpg
956	557	d3ec3392ff3354b88e046587d08dd72a.jpg	t	30337.jpg
957	557	6c8b666cfffe689be3b31f80c984494e.jpg	t	30338.jpg
958	558	d6f58a60468f4418320a6a9e8a36956b.jpg	t	30351.jpg
959	558	37700376908a54ad4ad23c6f97d42d3e.jpg	t	30352.jpg
960	559	3b96cbb0cb2539b99ed0c39780faa025.jpg	t	30321.jpg
961	559	f8cea8beec3fe82be7da4759c564bd33.jpg	t	30322.jpg
962	560	d6f58a60468f4418320a6a9e8a36956b.jpg	t	30351.jpg
963	560	37700376908a54ad4ad23c6f97d42d3e.jpg	t	30352.jpg
964	561	6e068361f054307b0ccf425a91dc44ce.jpg	t	30325.jpg
965	561	5b2a5b393fac26299989b765081911d0.jpg	t	30326.jpg
966	562	6e462477e4206710499954491f1b4ae0.jpg	t	30323.jpg
967	562	00a2d9bcaa2da504c17db00a151770e5.jpg	t	30324.jpg
968	563	e96a5cc2dcf341635824085adaa1562e.jpg	t	30320.jpg
969	563	f8cea8beec3fe82be7da4759c564bd33.jpg	t	30322.jpg
970	564	521cec56c8600692245f722482674b66.jpg	t	30347.jpg
971	564	c60ad2ea25aa566a30df75673890d22a.jpg	t	30348.jpg
972	565	521cec56c8600692245f722482674b66.jpg	t	30347.jpg
973	565	c60ad2ea25aa566a30df75673890d22a.jpg	t	30348.jpg
974	566	a2820e7c5178fbca98a4791f403a5fec.jpg	t	30362.jpg
975	566	4645ea8ec68e47dd0f6484c483249049.jpg	t	30363.jpg
976	567	d479274e89c53c10ab6d1864d69b43c2.jpg	t	30343.jpg
977	567	6ef74cd01b8d1ca7b3bb3e7d96cc99c1.jpg	t	30344.jpg
978	568	08696a92bb00d376770cf15cd8eda4fd.jpg	t	20903.jpg
979	568	93efb1eb772a14498386864476d6f05d.jpg	t	20904.jpg
980	569	a2820e7c5178fbca98a4791f403a5fec.jpg	t	30362.jpg
981	569	4645ea8ec68e47dd0f6484c483249049.jpg	t	30363.jpg
982	570	915f37278c471406f7862f1e8845643d.jpg	t	30364.jpg
983	570	a72f4fb5b316dbb9efb240d5d79f4e18.jpg	t	30365.jpg
984	571	a7c11a5e3b405919816e65a5c6b01bf5.jpg	t	30366.jpg
985	571	686d4469567f9186812ae2f61223b408.jpg	t	30367.jpg
986	572	a2820e7c5178fbca98a4791f403a5fec.jpg	t	30362.jpg
987	572	4645ea8ec68e47dd0f6484c483249049.jpg	t	30363.jpg
988	573	d55c2baa7b62522dfd5630288caabdd0.jpg	t	30565.jpg
989	573	2592284686128f4272e68e10310b7dbe.jpg	t	30566.jpg
990	574	915f37278c471406f7862f1e8845643d.jpg	t	30364.jpg
991	574	a72f4fb5b316dbb9efb240d5d79f4e18.jpg	t	30365.jpg
992	575	6d397de3b2a8f0b285d1bf7683b88d3a.jpg	t	21386.jpg
993	575	42c03f1b2b02a0b980a1dbe23f89e169.jpg	t	21387.jpg
994	576	74f6396ccc46f740cd7bdb4249556442.jpg	t	21338.jpg
995	576	76a33a5a3ae27bb953cd39c257919ab2.jpg	t	21339.jpg
996	577	1c178f799ceff27b90c359ccccc342e3.jpg	t	21318.jpg
997	577	b2da3469bb1dd94f717e274a2b54b2ca.jpg	t	21319.jpg
998	578	1f0091d0bce7a61d0ac35e9181813a16.jpg	t	21420.jpg
999	578	3b36267f6075c3cd22401e41c523fb28.jpg	t	21421.jpg
1000	579	c51fad28552e169c9d1a308b4397085d.jpg	t	21310.jpg
1001	579	07b6992c0af1dd468f155bb0524560e2.jpg	t	21311.jpg
1002	580	aead3638b66932e4d88d8fcea37ed276.jpg	t	21400.jpg
1003	580	fdc9228df31400fc9ab25f89dc4bbb97.jpg	t	21401.jpg
1004	581	edac0c38faf9eeb17cfb4538a54fc550.jpg	t	21388.jpg
1005	581	cceb84881d1b8f05bfd20a81e04cdc21.jpg	t	21389.jpg
1006	582	9a3494ebdf6c5f13c74b80b8c639f00d.jpg	t	21430.jpg
1007	582	33ed0ed825c217715eda790fac8398bb.jpg	t	21431.jpg
1008	583	1f8a81a898953562308ac189daf6082e.jpg	t	40577.jpg
1009	583	cd8dc61f2525766aeb77910be2f8537d.jpg	t	40578.jpg
1010	584	a904c34d653edb293d5774ebf3c25502.jpg	t	40579.jpg
1011	584	21c1c9bc4433eaf2f5f87f0157b592e7.jpg	t	40580.jpg
1012	585	32c857dc11072707f34a716acd39d7db.jpg	t	21332.jpg
1013	585	b00bb0b5da755884fab8e9a8d8aef0e4.jpg	t	21333.jpg
1014	586	e1f01f791f36efdd1910db09651d0745.jpg	t	21394.jpg
1015	586	28df3ca1f80a3576c34986e3f7f1655d.jpg	t	21395.jpg
1016	587	ea95f533c57f5048f14ffa1c3a903033.jpg	t	21412.jpg
1017	587	394fd41e5dea417a06c1f705cb114c36.jpg	t	21413.jpg
1018	588	3e0750d375f01f72cd4f89d155128a3f.jpg	t	40571.jpg
1019	588	9f976dfc90dae420622b15b3ed591ed5.jpg	t	40572.jpg
1020	589	8f21611c8865757b06342fa271becd3e.jpg	t	21348.jpg
1021	589	6915814d0bfbc4baa304b58ba5e90c75.jpg	t	21349.jpg
1022	590	c618de67a23bff37f4c2b65c9d1f711d.jpg	t	40573.jpg
1023	590	a52c5d7d784e13f4f9afc16fe15d10d4.jpg	t	40574.jpg
1024	591	7b6688e60046e76941a6344163662535.jpg	t	40563.jpg
1025	591	0ceafc7fee794b9dad40066f1a872a7c.jpg	t	40564.jpg
1026	592	6790e8a59e4d8591c6ce7946274e7781.jpg	t	21326.jpg
1027	592	eeefe6da5a3fd00f19f220cc9498c209.jpg	t	21327.jpg
1028	593	ca20b97696c391ff5f57c1b4b669cf4a.jpg	t	21404.jpg
1029	593	e099f3f6ca86460eb33571fcf71b9cf9.jpg	t	21405.jpg
1030	594	02452ee2cf56e1e8577ce91effa4da08.jpg	t	21398.jpg
1031	594	a02fc3ebddcc46b9c47087ccad4b016d.jpg	t	21399.jpg
1032	595	4362cbd7b71a09b6b077deb18fc1cf34.jpg	t	21402.jpg
1033	595	1527bd8c2f6778db5ce00c12fadfcce5.jpg	t	21403.jpg
1034	596	a66259ad033b7c807af6ce1c0527f5c1.jpg	t	21278.jpg
1035	596	bb90b5f1a322dc4657157fd4ccdbde22.jpg	t	21279.jpg
1036	597	79eab098af0048ad76d61adbe85ef2aa.jpg	t	21320.jpg
1037	597	8f3aba281626b077cc93917e48f52b82.jpg	t	21321.jpg
1038	598	4e32154c398240d11021948d3b2c0701.jpg	t	21312.jpg
1039	598	c60ebf37e391b868d02adbe47761391c.jpg	t	21313.jpg
1040	599	b81dfe715b1e8e5c6ddc15c37b3ac4da.jpg	t	20893.jpg
1041	599	793e26963e039968f0322c15657bb1b7.jpg	t	20894.jpg
1042	600	d8b277bd357f08e82a2fe1c9c27513ad.jpg	t	20897.jpg
1043	600	c5bdadbaa6065bc24910c987fd0c0dab.jpg	t	20898.jpg
1044	601	0bbdcea7e163067e12e8ab926cdc6495.jpg	t	20879.jpg
1045	601	2784fcacb2f5171608db74e041204228.jpg	t	20880.jpg
1046	602	99497b1f24cf5819f06eb424c207522e.jpg	t	20899.jpg
1047	602	15329af147373df13365fc5e6f800574.jpg	t	20900.jpg
1048	603	54241db5176e3a395e9b0dd81bfe5947.jpg	t	20877.jpg
1049	603	76763ff4d07af27b014996a0ee451cac.jpg	t	20878.jpg
1050	604	cd774043b6f782cc24619c645c88823b.jpg	t	20809.jpg
1051	604	9941e72d09638efacf0e847bc71288f2.jpg	t	20810.jpg
1052	605	dac315f20799fb1bb928aed304e644a4.jpg	t	20817.jpg
1053	605	a8fb2602a7ea7beab436bcaeb90af1ed.jpg	t	20818.jpg
1054	606	fa59e3eab3634f853d15581f71671bf4.jpg	t	20867.jpg
1055	606	30c63c5ce7882b00b2022179d314f1f3.jpg	t	20868.jpg
1056	607	6b2db4f721d08c4629c3d3b397604f6c.jpg	t	20825.jpg
1057	607	e047966ce474020ab8e8255be59a9d52.jpg	t	20826.jpg
1058	608	369992d900cedb073b578893925fdd7a.jpg	t	20869.jpg
1059	608	af756c7f527d429c1e625fd118a0f19a.jpg	t	20870.jpg
1060	609	7a8b6229e6f89eed635f5a675444c2be.jpg	t	20861.jpg
1061	609	ca1302da16ba8682db2828991b194e8f.jpg	t	20862.jpg
1062	610	ec31833aad95167102d7f4e187c90007.jpg	t	20863.jpg
1063	610	faccb72b9e4143240035ac87061ba948.jpg	t	20864.jpg
1064	611	cfe63dae69caf99565f0ffcef5d92a09.jpg	t	20853.jpg
1065	611	da6125a1b51d1e838ab4e8687f05192e.jpg	t	20854.jpg
1066	612	0e4cabab8b60401da7881c563063b31b.jpg	t	20901.jpg
1067	612	912a91974d80c27bf8dba73f780018ce.jpg	t	20902.jpg
1068	613	e12e5cbb94cc7d8f66aaed5fc83199fe.jpg	t	20813.jpg
1069	613	21cb37281864fe0dd033b038836c23c2.jpg	t	20814.jpg
1070	614	f4727cb45f355070f5d4c707600754c2.jpg	t	20839.jpg
1071	614	08782ef3d8b8a0751a9e6845f0459b19.jpg	t	20840.jpg
1072	615	e040aef5f8c49da54c27079bb9394bd2.jpg	t	20891.jpg
1073	615	f1d289a5e93420a0bd92a445ba490509.jpg	t	20892.jpg
1074	616	15cee0476d87fb4420fca6f9e312b563.jpg	t	20857.jpg
1075	616	0d85d08296190a2f47b702229a9a8ac4.jpg	t	20858.jpg
1076	617	77b40f1da3d24a50b8ede6315e74bb35.jpg	t	20847.jpg
1077	617	d64e3c7eb852a7a75dd95e165548d2c6.jpg	t	20848.jpg
1078	618	e0f14b949e02715453e97bc516906833.jpg	t	20851.jpg
1079	618	e57f41718fb30799a3c006dc0ede039b.jpg	t	20852.jpg
1080	619	cbe47107099c7ba3bd1b4f515943252f.jpg	t	20843.jpg
1081	619	b0d3fea8152defd71dac44c5389efaf2.jpg	t	20844.jpg
1082	620	6d03fd1cd872db837aa07c22969ebd89.jpg	t	20845.jpg
1083	620	19e1c7ff2c7bfb2d1b8bee07a8e1d2cc.jpg	t	20846.jpg
1084	621	c9d5631b83638ad697ba35de7a0bd927.jpg	t	20881.jpg
1085	621	16e6c996a1626d0a00ea087b92ba7628.jpg	t	20882.jpg
1086	622	ceb01a7c0af789a12a65fe053bc515e3.jpg	t	20873.jpg
1087	622	9b2206a48b0daa2f5f2894a25ab431f9.jpg	t	20874.jpg
1088	623	2caea616cd45d5444030ba52ed2c3f60.jpg	t	20909.jpg
1089	623	ff246481d958711915fbc0b268c78152.jpg	t	20910.jpg
1090	624	bae467389b277e4738145a6e405612f1.jpg	t	20805.jpg
1091	624	6a19d6ba989dc3f966a20ad85c69d654.jpg	t	20806.jpg
1092	625	773473a91163a0f08ac561e0f2116cbb.jpg	t	20060.jpg
1093	625	21bc671d3c55558f7237d91198b77b50.jpg	t	20061.jpg
1094	626	102fc300a6e2e280f75167d89039c6fc.jpg	t	20054.jpg
1095	626	c6b7e38c782a24629c2a800caf94529f.jpg	t	20055.jpg
1096	627	3b4bc950e3ee4846afbd851334931958.jpg	t	10567.jpg
1097	627	d20a69d846c379a7df0e1b86305d7abd.jpg	t	10568.jpg
1098	628	f119a3ffb234db654ae52a05b969eb66.jpg	t	20070.jpg
1099	628	f969c0d31bd36d1fe4dec44f5621aede.jpg	t	20071.jpg
1100	629	897ce198807dbedad36d3ccca5c316f3.jpg	t	20002.jpg
1101	629	4f3713701dd845b1d31b7626fb342545.jpg	t	20003.jpg
1102	630	169332fcc92dea1534c2c9a26e79da78.jpg	t	20108.jpg
1103	630	f62c830ba992880b4b6d78263667c0f7.jpg	t	20109.jpg
1104	631	73419623d1474bdd02f5e342e3a483e1.jpg	t	20104.jpg
1105	631	56e334751af762691ec201afc5a9dde1.jpg	t	20105.jpg
1106	632	6ec7aca79ea74b0aaeb2eddbb1f966b4.jpg	t	20036.jpg
1107	632	d0be7a8c63fc0d8b24a2f27977b2df01.jpg	t	20037.jpg
1108	633	08f3aa822e7cdc2486db9530f33ba1be.jpg	t	20012.jpg
1109	633	fdcdb0cdf9033253f1aa470b56e18d5a.jpg	t	20013.jpg
1110	634	1931d2130a18b03e8c622dd2904f2b06.jpg	t	20078.jpg
1111	634	52843e60590bcbd5550949fdd9ac3475.jpg	t	20079.jpg
1112	635	e5aeb1adc329a43a42e533ce28cb0885.jpg	t	20076.jpg
1113	635	48d85642276e713a1be51b9bd464c645.jpg	t	20077.jpg
1114	636	c9aeb59b8f1ec90073ecbeefc7b71739.jpg	t	20116.jpg
1115	636	030773f5f02b6b7f769ef04a6a22a8c0.jpg	t	20117.jpg
1116	637	721f59def8641c549bda865671574140.jpg	t	20016.jpg
1117	637	72440d580cce1bdcc7189f759d17d98a.jpg	t	20017.jpg
1118	638	e560fd19b9ba97e3dbfe50b76acf2bcf.jpg	t	20018.jpg
1119	638	ed9dd21dafcbce015c071f2c59a24ad8.jpg	t	20019.jpg
1120	639	bf1f6ec1dd3ae159bce31064e94cf452.jpg	t	20026.jpg
1121	639	f2d3a88a53aa2cf359f60eaf042fea24.jpg	t	20027.jpg
1122	640	87abc89f2ea0e67a21cbc1377e948825.jpg	t	20102.jpg
1123	640	84de46694d1f48a792ab0220d7c1d46e.jpg	t	20103.jpg
1124	641	f1218e6b358a77b61b8e97573cce5eb3.jpg	t	20008.jpg
1125	641	681e11e9da5d226dd5874221924f98b8.jpg	t	20009.jpg
1126	642	59e0ecdd8233620bf08a76b71e7d2928.jpg	t	20084.jpg
1127	642	c1f3184461acfaad1570d915c4f6037b.jpg	t	20085.jpg
1128	643	f49c46336d50fafe390776976c193ab5.jpg	t	20030.jpg
1129	643	6f343d59db8df25ec5f5fb181dc8594b.jpg	t	20031.jpg
1130	644	881c1523e98e957aa01c76f174d6659b.jpg	t	20058.jpg
1131	644	d45ca08da0dea78dfeff33776882a8e4.jpg	t	20059.jpg
1132	645	59bec9c03c37bc4c66f1f5c8f0f000a7.jpg	t	20088.jpg
1133	645	bad95186c71d1a16dce98de85bbae463.jpg	t	20089.jpg
1134	646	00a94505a82890abbe955499ecf175ab.jpg	t	20112.jpg
1135	646	1bc4eb885a67902bd3a98d33d3e4f2dd.jpg	t	20113.jpg
1136	647	bba0850b5e32aba71bfdb40f81877798.jpg	t	20110.jpg
1137	647	f8b30b2a9ece53e52ed26c6d57901ac3.jpg	t	20111.jpg
1138	648	2330cdecd2722fc479bdb25cb6ca6104.jpg	t	20096.jpg
1139	648	f436f23b81d489a1da24bd8bb7f84485.jpg	t	20097.jpg
1140	649	f2cf875940e79af943a258c2abd7dc32.jpg	t	20064.jpg
1141	649	119ae4118ba8620efe7907290110f7a1.jpg	t	20065.jpg
1142	650	c6da534cdee8061916ba437690d1c5fa.jpg	t	20048.jpg
1143	650	36f08cd7856684b8c46d6373d1850036.jpg	t	20049.jpg
1144	651	dd703e1939fe48d48e403661c0fa8cee.jpg	t	20040.jpg
1145	651	4c69e2c8c74484de5f8603331d5064c5.jpg	t	20041.jpg
1146	652	1d7d43e89f0a9691f9b29bad46c755c4.jpg	t	20090.jpg
1147	652	7f518c5b6fba99892e5db9503d41946b.jpg	t	20091.jpg
1148	653	4930d6c9559ac775e61e63b6b945ccb9.jpg	t	20082.jpg
1149	653	6b40a7373536b66500dcaa47c8a10277.jpg	t	20083.jpg
1150	654	6c2e8004afdac69076964aa6825e0088.jpg	t	20074.jpg
1151	654	f61999ec32546da9b6aaaef85198822f.jpg	t	20075.jpg
1152	655	87483fcdd65a6a062e77cfd33a2b969d.jpg	t	20034.jpg
1153	655	c057f1600724f547b0bcbe16e8451acd.jpg	t	20035.jpg
1154	656	4e164bda29ff53c932767bf731d35722.jpg	t	20416.jpg
1155	656	ba077b734858adcb9a6a30fb56c1668c.jpg	t	20417.jpg
1156	657	d546287842850bf5d59e92e654505547.jpg	t	20180.jpg
1157	657	b19e24169672c2bb73ec83c082cd2646.jpg	t	20181.jpg
1158	658	74eb496d2fbc127cf3fcc7b1a94a276a.jpg	t	20168.jpg
1159	658	1ba135b647c42169d0ef93723f5b641d.jpg	t	20169.jpg
1160	659	d546287842850bf5d59e92e654505547.jpg	t	20180.jpg
1161	659	b19e24169672c2bb73ec83c082cd2646.jpg	t	20181.jpg
1162	660	95690e9aa5d6a9d2d4c187ad7375d6d3.jpg	t	20222.jpg
1163	660	e044723c2684252625ccc12ed6b6c4c4.jpg	t	20223.jpg
1164	661	ba4107bcd6cbccad2057872b6e753041.jpg	t	20188.jpg
1165	661	903196057b1185dcc51c0a9997c2fea8.jpg	t	20189.jpg
1166	662	d0205e50bfeb31a336fe94cb89fe4bd7.jpg	t	20220.jpg
1167	662	00ecb0ee46a23c2251ffaca9ada80a4a.jpg	t	20221.jpg
1168	663	a04089d59be4b0e384f7db770fbd14e9.jpg	t	20410.jpg
1169	663	e824c2aaf4633f622d737fdbdec1188e.jpg	t	20411.jpg
1170	664	827d8b87903960c5b7d0f8cafb25c3ec.jpg	t	20426.jpg
1171	664	14bad2c543ab3028157c46afca923f93.jpg	t	20427.jpg
1172	665	4a362521a0de2f616af1e858405fd44b.jpg	t	20208.jpg
1173	665	f7c9c6a11654f315cb375cf56eccbdfb.jpg	t	20209.jpg
1174	666	294b2385be93cf9f2ee124450a7cb17e.jpg	t	20218.jpg
1175	666	5c64f9144ea85a42aea9402664e277c5.jpg	t	20219.jpg
1176	667	5ac27459555c69229d0c4a8c93d2f025.jpg	t	20204.jpg
1177	667	46f465110662b0db60251eae2f1b61bb.jpg	t	20205.jpg
1178	668	3cd18473433f34bf4642ceff27035a0e.jpg	t	20206.jpg
1179	668	cf1327dedbc4dfe3095f943ff8a75f88.jpg	t	20207.jpg
1180	669	2d2487d2a7311aa174b1b2d5a3d2ed86.jpg	t	20186.jpg
1181	669	31802fa7482c5f55a1f22e4a8d1d2e14.jpg	t	20187.jpg
1182	670	4f371b6a0b4686e2bc0051ee3348ef63.jpg	t	20224.jpg
1183	670	bd880ab7ef0f70ea4c7adbc4409f44e3.jpg	t	20225.jpg
1184	671	7f329876ea39b23666153b00b0896f3a.jpg	t	20194.jpg
1185	671	ea499307a809b7bf3d4c57d6a148dff6.jpg	t	20195.jpg
1186	672	81650cf6c602d9a7857c5590f2462927.jpg	t	20210.jpg
1187	672	69ee627f23da29514dd5b317fbc7c3c3.jpg	t	20211.jpg
1188	673	eca2e01feda1b049ee5ef175c92f7d57.jpg	t	20414.jpg
1189	673	0576cb87f95f455b1d22ae83a36be5a8.jpg	t	20415.jpg
1190	674	8dd7e00e74e8ae4b3799071137580778.jpg	t	20174.jpg
1191	674	e3fa291bf0cd97ffeca26d2a6d8e23ed.jpg	t	20175.jpg
1192	675	dcaf6519d51d8f6861679125eeb25e32.jpg	t	20200.jpg
1193	675	3209df6a509e4f19cb84e78e1c48029e.jpg	t	20201.jpg
1194	676	980431e1c6896d04417ae83f7628eefd.jpg	t	20777.jpg
1195	676	7b995f7c2e6f539578253ab7a02e90f3.jpg	t	20778.jpg
1196	677	82f163aa52ac37af8980103d85fd0348.jpg	t	20498.jpg
1197	677	465e7f3e6530f55365ae941fd818cf91.jpg	t	20499.jpg
1198	678	3a05bd449d432af310b5635f6f8de350.jpg	t	20785.jpg
1199	678	2d63933a6970a8dfe66dc7ae9e957ea5.jpg	t	20786.jpg
1200	679	44ac109fae6a811799bc2dd96aa76298.jpg	t	20781.jpg
1201	679	d4d574fc1dcb9fc68019c397b280f5a0.jpg	t	20782.jpg
1202	680	d11150d8c7a5dac6352e0a5b4090bb32.jpg	t	20494.jpg
1203	680	5d738f908b3495f5ee69c8104d90c83f.jpg	t	20495.jpg
1204	681	4d1d36297bbb4a31443e9fa6322cc151.jpg	t	20668.jpg
1205	681	55823b6027fd7d1f99a8e2333ece4a07.jpg	t	20669.jpg
1206	682	0490f57ea9af74278c9057d74cd946a5.jpg	t	20704.jpg
1207	682	a07aa4150b883ce880f2d96f7b73e001.jpg	t	20705.jpg
1208	683	65f7662bbdc49287becabe4adb64bb2d.jpg	t	20795.jpg
1209	683	248e17e28eb5dafc63d615d26b48cfa3.jpg	t	20796.jpg
1210	684	7b2fd3d4678033bb436c9ccb8cec9002.jpg	t	20751.jpg
1211	684	4dcbe182968af1be92c1dde4e2f5a3ad.jpg	t	20752.jpg
1212	685	65d37b1a0bf23300f67dc09648dd15fc.jpg	t	20702.jpg
1213	685	21c166a6c0dbf5ef76f7cb438cc64366.jpg	t	20703.jpg
1214	686	b7a97e518cf2eddc1d1574867d4909e4.jpg	t	20664.jpg
1215	686	89365a9e126d95c50c954823a889a35c.jpg	t	20665.jpg
1216	687	7dcd967cb08d89187c365cb7f47c4441.jpg	t	20660.jpg
1217	687	871691c8cbd8a15469ce78b2cf0391ad.jpg	t	20661.jpg
1218	688	afeed43ce17b7e482d86e5661c82708a.jpg	t	20763.jpg
1219	688	a0371ea0900c161be86868b3d66ca8d1.jpg	t	20764.jpg
1220	689	2dbf3088c171bdae383832438dc35b8c.jpg	t	20753.jpg
1221	689	53b8e44e008c67a8959d86edae293fcf.jpg	t	20754.jpg
1222	690	c2d326e2cdab9d3e81b6bab5ae6d60c6.jpg	t	20504.jpg
1223	690	0f2f669e43ecdcd51489acee2eafce65.jpg	t	20505.jpg
1224	691	0db1ce093f7a7eec1d2d088c2b172393.jpg	t	20797.jpg
1225	691	0936f73c1d0d5ee0614ce948d381c012.jpg	t	20798.jpg
1226	692	34f6d1ca3da6df29e2e75a04340ff6b9.jpg	t	20696.jpg
1227	692	f116c5066f8343555a2aa59c27ce287d.jpg	t	20697.jpg
1228	693	26ea173e84f9a3e35bd7b9988434b2d9.jpg	t	20694.jpg
1229	693	bd8183df294f157f1caa80e22fcbcb47.jpg	t	20695.jpg
1230	694	bef21c8204a200b8b1e4557ec86b9845.jpg	t	20680.jpg
1231	694	f07908562ccd283d9e8eb2d38b5a6587.jpg	t	20681.jpg
1232	695	b30bcc6e740decf3feede82568111fc9.jpg	t	20678.jpg
1233	695	a8302aa47a6284871b163064f0f39f46.jpg	t	20679.jpg
1234	696	33027b2725f071a4862a03088a1f6579.jpg	t	20500.jpg
1235	696	7cbaaca79d1123052e0514d932675794.jpg	t	20501.jpg
1236	697	5d5a4f0a00745ffbea7502fa4eb9b639.jpg	t	20674.jpg
1237	697	08e1185235bdb8bebc8ab68c42c59be6.jpg	t	20675.jpg
1238	698	aa10c9d970d9003e82a84ede184fc122.jpg	t	20686.jpg
1239	698	acaebdb83f1dee1eb27ccf1140a9eb03.jpg	t	20687.jpg
1240	699	aad9d0982ba42b2b0bd5b3aa9b9d3888.jpg	t	20773.jpg
1241	699	a8edd38573945ae5600eda52430f5dd5.jpg	t	20774.jpg
1242	700	3976565aa97d2df839da88a8155473d7.jpg	t	20488.jpg
1243	700	15a567bc3c03f3dc70fe8d60fbf10895.jpg	t	20489.jpg
1244	701	4675e80672177e3383484296628121a6.jpg	t	20514.jpg
1245	701	e7b300cac5679b0826d7fee4bed79f6e.jpg	t	20515.jpg
1246	702	5ac77aa28fbd27ec355d8a3bfbb1ad98.jpg	t	20759.jpg
1247	702	8eb9f40f15221e28541c1067a0628ee6.jpg	t	20760.jpg
1248	703	746b0175161679e9a6965090e668de60.jpg	t	20789.jpg
1249	703	67d9947a1741e91f13a8c74c507a5265.jpg	t	20790.jpg
1250	704	9fb482e3e528010e41eabf82b159e9e5.jpg	t	10815.jpg
1251	704	93f7c46d2deafde572c9913c01a6a942.jpg	t	10816.jpg
1252	705	db70a28c0a3b63c2db98348ec4382137.jpg	t	20771.jpg
1253	705	0846bcf9c3c26cf2f674a9971432f3e3.jpg	t	20772.jpg
1254	706	b3f4646711eab28a8623eb5b3a5a0229.jpg	t	20698.jpg
1255	706	f90f0d08c31caafa3401becbe707d99c.jpg	t	20699.jpg
1256	707	059c59b57636abdd179715956e237f7d.jpg	t	20492.jpg
1257	707	44c38ccae44b9feb7a83b31d63300702.jpg	t	20493.jpg
1258	708	dc38a6af07b55fc1ebe1f73ab5667ce9.jpg	t	20927.jpg
1259	708	85d00ed9c60d5a4152b5ed427eedd151.jpg	t	20928.jpg
1260	709	0571a9ca3d61ebc343ae8351ee0e2bf9.jpg	t	20474.jpg
1261	709	fa74a895eda386c37716718df86762f5.jpg	t	20475.jpg
1262	710	403e16bb9ea1f1e66ead2e4c47a1a829.jpg	t	20913.jpg
1263	710	5b28031dbfe7c8885b13b915a644b471.jpg	t	20914.jpg
1264	711	87498e2733255c4c154870462e99a928.jpg	t	21460.jpg
1265	711	547b3d6d55bd8cf6e97b6987ed412010.jpg	t	21461.jpg
1266	712	dcca82a84424155b05c6a9fc4772faac.jpg	t	10835.jpg
1267	712	1da3408a2582b39a3c72763b011fc674.jpg	t	10836.jpg
1268	713	4707c7983932be8a368e8df25ca8184e.jpg	t	20921.jpg
1269	713	385bee4aa524e555ce4f24c12de23c98.jpg	t	20922.jpg
1270	714	b48c269f797bd44f8816cf5d4620067c.jpg	t	21470.jpg
1271	714	c92f7e057b618480a369eb2b00273290.jpg	t	21471.jpg
1272	715	251509b17cdfe0b5fc45483ceed2f803.jpg	t	20941.jpg
1273	715	59b39a253ffac2186176b7a6d40ea3f7.jpg	t	20942.jpg
1274	716	8a99d41a4d30fcf867d6b264e12d4753.jpg	t	20945.jpg
1275	716	a6224b76968c3765aa5bd60bd0894c5e.jpg	t	20946.jpg
1276	717	e03fbb78d8b09bd20e7cf3e559526e15.jpg	t	10831.jpg
1277	717	4d2ab9d34e1b7ab2402168d67fb4dda3.jpg	t	10832.jpg
1278	718	19a4b5016052a6eb6b04236cd090da88.jpg	t	20915.jpg
1279	718	6e80cc641d9f2eb06b5492c32b3bf4b0.jpg	t	20916.jpg
1280	719	16f203e86254b66936d5f05b45fa24c8.jpg	t	10823.jpg
1281	719	2076b04da2dc9a4af023524f1863a096.jpg	t	10824.jpg
1282	720	6f7404bf4beb336a6d7d00f0a7702f8a.jpg	t	20959.jpg
1283	720	7c4eb1673aa73cf090ce247179b404ca.jpg	t	20960.jpg
1284	721	fa2d40d0e6827b3aa9b2a3b485cd236e.jpg	t	10819.jpg
1285	721	fd6fef8c5753e652a95b8cf21cd35865.jpg	t	10820.jpg
1286	722	c2dcc0d3fab47313421ecb8b0bc516e4.jpg	t	10803.jpg
1287	722	07d6d3f987d63901bc42ae46ec399c06.jpg	t	10804.jpg
1288	723	9819ee8e29dbaa7fef019979a775d334.jpg	t	20923.jpg
1289	723	5facc313c77b4156922a4c535e9ff951.jpg	t	20924.jpg
1290	724	353b1423ee2ab548de47a694c3bf16f2.jpg	t	20967.jpg
1291	724	523ac7ebd71fcc3aca2280c0a806091a.jpg	t	20968.jpg
1292	725	79893a6d4becf74e4182a0f7bcb64449.jpg	t	20951.jpg
1293	725	7327dab2f68e1a5588d3c618958b88d1.jpg	t	20952.jpg
1294	726	debe5482689051e715a5e3f5a2525b98.jpg	t	21486.jpg
1295	726	44fbf1e992967e8717085b7d6e072366.jpg	t	21487.jpg
1296	727	e09a37329602c4ccd337938029ddeb09.jpg	t	21482.jpg
1297	727	f14171e9ecd7c19e3b4c2af84ec18631.jpg	t	21483.jpg
1298	728	0f49346301cb024e000f30da7541424e.jpg	t	21474.jpg
1299	728	f8fc568e6c44b94932da9d2356d1b23b.jpg	t	21475.jpg
1300	729	b07e5e9ce4a516ed6ca7c76bb3d94716.jpg	t	20931.jpg
1301	729	32f7fce12735272dfdf16e4f03dede5e.jpg	t	20932.jpg
1302	730	69d537669da2b842d9480e8f1aa67d7a.jpg	t	20955.jpg
1303	730	1803083944da9fe3a12f6be6ddd45fc4.jpg	t	20956.jpg
1304	731	35821b9de9308401966fc6dd2256ef26.jpg	t	11204.jpg
1305	731	7b949542decb8ffbd3c6e136e3a30cc1.jpg	t	11205.jpg
1306	732	1df88727937658a6952ea33c0dc84204.jpg	t	21446.jpg
1307	732	0f058f3f5e90db3b319c364f3a01aab7.jpg	t	21447.jpg
1308	733	90b259a7fd8f5f3c6dcd21356b920110.jpg	t	21478.jpg
1309	733	4acd41d51e31c0dbdb776905341efaff.jpg	t	21479.jpg
1310	734	a5deba30f8d79589fefa8284d19a1362.jpg	t	10807.jpg
1311	734	8377fb2d7adc12e0cd4db906071aa7c6.jpg	t	10808.jpg
1312	735	d7ca63857885b4f61bbf4d5a675bff81.jpg	t	11434.jpg
1313	735	a06e055353789c905408378b6139f9ac.jpg	t	11435.jpg
1314	736	1c5e80b424516af3eb6fcb189e696d9e.jpg	t	11482.jpg
1315	736	2c9b641849fcb81dd47d9e531a4852f2.jpg	t	11483.jpg
1316	737	5ef6d051aec925340b017bd9c3467b11.jpg	t	11430.jpg
1317	737	bb46ae7c11e318151ccab518469ea817.jpg	t	11431.jpg
1318	738	5b99ac2b18cba534b1cec8c7e33a9495.jpg	t	11486.jpg
1319	738	8c569f66b4cde75017fb7b9ed572b0b5.jpg	t	11487.jpg
1320	739	0ee65b7f1c3a9e437bcab5b6e1055e8f.jpg	t	11416.jpg
1321	739	d65f02d2dce5b2301fa37285b469d087.jpg	t	11417.jpg
1322	740	7d7d025c84745e177c2f98db93f0e103.jpg	t	11402.jpg
1323	740	82960f6329c227e3147e89fd24f58d18.jpg	t	11403.jpg
1324	741	a5c1779601930d5ad4914e2d71a5d680.jpg	t	11418.jpg
1325	741	190a47398d5f10945b6fef2306365805.jpg	t	11419.jpg
1326	742	84006adda7207f3da1199cdb4d71e5e6.jpg	t	11382.jpg
1327	742	2ccb075690832e45fb8575e7a9fd7dba.jpg	t	11383.jpg
1328	743	200bb7b74e3cb87eae5a34ac68fa81f1.jpg	t	11374.jpg
1329	743	fc4e2b53cf012156b5f61e31a3b307ac.jpg	t	11375.jpg
1330	744	06d82e1bac15702775f359d135c9e88a.jpg	t	11490.jpg
1331	744	b8f5e44e11699a430517ddf748b0db68.jpg	t	11491.jpg
1332	745	199e982da1b3da6004bfcbc33b362cf4.jpg	t	11478.jpg
1333	745	ce2d4c32a0920c6a621c1263d99c1cac.jpg	t	11479.jpg
1334	746	9ddd7322d266d777b227e8c5af01dad0.jpg	t	11384.jpg
1335	746	690cf1fa092c2374ce56dd7f290a14cd.jpg	t	11385.jpg
1336	747	82ab3d40722661b43be8a2a531bbf4a1.jpg	t	11468.jpg
1337	747	e06ec03709260d8ff5579cb008f22efb.jpg	t	11469.jpg
1338	748	0962c0095097f38d7aa8743293325be7.jpg	t	11422.jpg
1339	748	382c6d9b064c35740e1e3b3d06013065.jpg	t	11423.jpg
1340	749	db79dd57841172c5770e31b132c0a82a.jpg	t	11456.jpg
1341	749	9b71c29b07f0c3b54aecdd476a195dd3.jpg	t	11457.jpg
1342	750	b35f26c6c2f24c2aa246df8edab5dd92.jpg	t	11404.jpg
1343	750	36a2ef4c0fde7ac1be301d9d1485b6aa.jpg	t	11405.jpg
1344	751	e9e0881b0e8b34d9b195b888d67a4029.jpg	t	11396.jpg
1345	751	01247225c459c16380b1b928ded9a61e.jpg	t	11397.jpg
1346	752	5fb9135aac41c59f70ee1247c44b0369.jpg	t	11438.jpg
1347	752	101ffb14620f8895e37b037046c4ed35.jpg	t	11439.jpg
1348	753	added21dce342977d2d388b1da884162.jpg	t	11460.jpg
1349	753	57e10a332b63e1f4fcdd90dbae5cbc77.jpg	t	11461.jpg
1350	754	18926935f4b70547964e82ee4ef352a0.jpg	t	21342.jpg
1351	754	d442859b4d83bdda9b7c5bf0eb84fe23.jpg	t	21343.jpg
1352	755	4bf53d6041c761cc59826eb2f3221aa2.jpg	t	11440.jpg
1353	755	c40452c9f650802f5983019754b4d96a.jpg	t	11441.jpg
1354	756	5299dc5d58f4b2b3897682000713bb04.jpg	t	11390.jpg
1355	756	76e38eb90776e4c7172bcefb1b074dee.jpg	t	11391.jpg
1356	757	37f5ba88f984debcdc8ad3839bcaae0d.jpg	t	11450.jpg
1357	757	af65d1a60237236fda76e0b66da1cde3.jpg	t	11451.jpg
1358	758	d1a3d1fe1f6a02a6e8c3c9be17b6d34c.jpg	t	11446.jpg
1359	758	5fff3ab4d6b6e898e3a08fdaffe314d8.jpg	t	11447.jpg
1360	759	e1abf5ff24a9b7771199fb4181079df0.jpg	t	11454.jpg
1361	759	945b2936dbcdc4d29b70557c7dd5c743.jpg	t	11455.jpg
1362	760	98eff10d980d8d928ede482746d65dd9.jpg	t	11376.jpg
1363	760	834bf5f6b793dc15f97ebd35f5eb9f68.jpg	t	11377.jpg
1364	761	c086d3c1e64a44258788e6829abf2f5a.jpg	t	11208.jpg
1365	761	405eddb1ff50d0199ed672ecf89b6c28.jpg	t	11209.jpg
1366	761	e0dba85623d80b111017c5e9bb947692.jpg	t	11210.jpg
1367	762	0508462fa0c7820430dfe99e185f5089.jpg	t	11180.jpg
1368	762	b6f9ecf476a01ea6e9efd7c7c4616cd6.jpg	t	11181.jpg
1369	763	e93d9124ac1f8cd436449b98ca007c9d.jpg	t	11252.jpg
1370	763	a4384817d60ee250835a9e2d28e18f35.jpg	t	11253.jpg
1371	764	a251f8466fbc354810a9a2303b462b17.jpg	t	11202.jpg
1372	764	34485eaf503ff5c9485565b3a4fca048.jpg	t	11203.jpg
1373	765	abdff2ac1e247c24c5504cf1e77a4d33.jpg	t	11215.jpg
1374	765	7e1cef47b09ccbcbe85f058720c14363.jpg	t	11216.jpg
1375	766	5e08f004f6f9b32b535e11360fa1f0de.jpg	t	11189.jpg
1376	766	46e65472e1266128d4768ce82cb9856a.jpg	t	11190.jpg
1377	766	00401a27b2908389d29993862ab6d7a4.jpg	t	11191.jpg
1378	767	2bef82295276786bab660d237befb15b.jpg	t	11194.jpg
1379	767	5cd59f58c2d914d53c04ac3e91a5a59d.jpg	t	11195.jpg
1380	768	8eb8e70d9f076c9b1bc210d8820732a4.jpg	t	11257.jpg
1381	768	d1b324bab900146dcc3546c2da6a93ee.jpg	t	11258.jpg
1382	769	922b229213aa051215da6e5e3287927a.jpg	t	11230.jpg
1383	769	7d9f6f9b3c9b6925685b8b2229ea08cc.jpg	t	11231.jpg
1384	770	b7ab180f74c9dfb60688b8b6f4fe7aff.jpg	t	11235.jpg
1385	770	2a6aef2e712c3cacda60066eb1875d5b.jpg	t	11236.jpg
1386	771	d140d78b2251ec0d48a8e6d0e13198ca.jpg	t	11200.jpg
1387	771	ee5577949c6732990489e0e8cfd0ea4e.jpg	t	11201.jpg
1388	772	6c646fc7dceaaa9f0df5ee29108092f4.jpg	t	11270.jpg
1389	772	037bb0323f5b20f7837d33096dc6e72c.jpg	t	11271.jpg
1390	773	d1af0b3ad2d48a4df126133cfc38b0e6.jpg	t	11240.jpg
1391	773	b66658da5ec46254c7e1f1816a5777a5.jpg	t	11241.jpg
1392	774	d14188cda582040829a1aa7fd6ac55c2.jpg	t	11225.jpg
1393	774	cf5f7d82ded2bafaa4ca55161f6afe50.jpg	t	11226.jpg
1394	775	2bbf32401a5ae0650a3bbd25fec0dfa5.jpg	t	11219.jpg
1395	775	b075d7f88366e7675b0dee57feb6dc5e.jpg	t	11220.jpg
1396	776	162fc46a0086f52736a8bf9ce4e1ca71.jpg	t	10565.jpg
1397	776	7aac359aa3428cb8b87ad488296c12f7.jpg	t	10566.jpg
1398	777	6e2d57cd406d8e597c08df14ae2efcf1.jpg	t	11248.jpg
1399	777	c3821e2c3f6288af5f2e2c2369b6de59.jpg	t	11249.jpg
1400	778	2f8363d12eb1f3108dcfb3067adebfe4.jpg	t	11262.jpg
1401	778	4f291b1cad1271b00cea2af46a5e0b58.jpg	t	11263.jpg
1402	779	c54d1fb0cc5b90188a948dc6adc365c2.jpg	t	11242.jpg
1403	779	3524f08becc8274cc185d351f1286dd1.jpg	t	11243.jpg
1404	780	a196647894b3c9dff3021154e19e6348.jpg	t	11184.jpg
1405	780	16246813e396eb975a281da4301af215.jpg	t	11185.jpg
1406	781	5ee0ca213f0298b6a7376d7748df0c84.jpg	t	11266.jpg
1407	781	a0ddfb180572629e7bc6633653a22404.jpg	t	11267.jpg
1408	782	ea13288a8b193a58fffe8676cf4fdf06.jpg	t	11175.jpg
1409	782	2435d3e0efc5d0addc96c0fc11db9218.jpg	t	11176.jpg
1410	783	de969f8c1a120d1b65f700bda06e711e.jpg	t	21131.jpg
1411	783	108093914c0f4937ad6bf2da3345bdb4.jpg	t	21132.jpg
1412	784	bd89a106cf0ccb001fef1449232ef884.jpg	t	21173.jpg
1413	784	f9fce86beb740025681e94889dcfcf9b.jpg	t	21174.jpg
1414	785	7bc9f8af4c8cc8f50e011d425dfede52.jpg	t	21157.jpg
1415	785	7ea9568efb1d89cda68b63a830f52ecf.jpg	t	21158.jpg
1416	786	27cc925923d996f2450f61b5a4d8c23e.jpg	t	21153.jpg
1417	786	0e847cb905d730d1a22fa2b52a38fd2a.jpg	t	21154.jpg
1418	787	10e2ab2496a81acaabfac599c7d7fe68.jpg	t	21167.jpg
1419	787	40896a0e8f5b2979112ef0bfd15cea64.jpg	t	21168.jpg
1420	788	9e3713bfe0b1ed981e99e9eee140320e.jpg	t	21123.jpg
1421	788	7d436b0cdf73b33fd0c0384d49898bb9.jpg	t	21124.jpg
1422	789	5866224479c48287c17c2b72d3e3a341.jpg	t	21165.jpg
1423	789	8de01a56e8e0e73030df88b7e299ca1d.jpg	t	21166.jpg
1424	790	c52bc5da794cdfde5c805db9ffc44b5f.jpg	t	21159.jpg
1425	790	20e5694979c2c4b0f2fff79e9bc8703e.jpg	t	21160.jpg
1426	791	ae08b3caff30bd3f2b3e225a01858a6d.jpg	t	21115.jpg
1427	791	00f93eaa786723d4ad86c2ed3c3b6567.jpg	t	21116.jpg
1428	792	4ca7a34560d77449e47754c314da1f45.jpg	t	21171.jpg
1429	792	847d3837ed19cc4a24564f863b54a2a2.jpg	t	21172.jpg
1430	793	7dded87fc92a21b48367339219092298.jpg	t	21129.jpg
1431	793	c108bb5689a585d7382bb2bb549c84b6.jpg	t	21130.jpg
1432	794	93d80900db35f252440a676ff4645035.jpg	t	21139.jpg
1433	794	d633d2b703cb99a8b2f198df9b6dc585.jpg	t	21140.jpg
1434	795	e5e3b99117d7e5f992ad97e0bebbc520.jpg	t	21184.jpg
1435	795	4b02fa24b5786c5dff0cdfa5c93134ab.jpg	t	21185.jpg
1436	796	0750fcb7207b2d4b1992177a4a00c7b9.jpg	t	21137.jpg
1437	796	51ea6f51d32659ec71a6b3ab4c5c2c6e.jpg	t	21138.jpg
1438	797	eadf02adab3e63efd5b178e796d9dd1e.jpg	t	21151.jpg
1439	797	f643b35851cdc1a2e599f7775cf31479.jpg	t	21152.jpg
1440	798	36cda2a0d9acb1f694dd75dd5be8c207.jpg	t	21143.jpg
1441	798	35f2a56947c4a593a31cdb2aa2f48462.jpg	t	21144.jpg
1442	799	25569e6a14e7b9d85639cb9de3ee10ff.jpg	t	21107.jpg
1443	799	13771523a64a27a1130a2a76cc7370f0.jpg	t	21108.jpg
1444	800	4193a3e56c0f1c04ea3b53bedcc881a7.jpg	t	21101.jpg
1445	800	8d5790766820873de55cbd34c0699137.jpg	t	21102.jpg
1446	801	2bfb8b42f39de6fa929161cc130a5eb0.jpg	t	21103.jpg
1447	801	73b8e484a4f6e572297fbe618a72b9f0.jpg	t	21104.jpg
1448	802	ce49498d24ef3590ab1f22eebffb3553.jpg	t	21113.jpg
1449	802	c41169f95d8489c9340ff0d53d530ab2.jpg	t	21114.jpg
1450	803	09e2938f33ebc9ca545aa60c3e80ff42.jpg	t	10959.jpg
1451	803	1837bcd75f42a31788a8ec553b4a2901.jpg	t	10960.jpg
1452	804	8ad601a3eeb8dbb56aeb9f9646accf21.jpg	t	10994.jpg
1453	804	7bc5a1cda54c6599dcb7e9aa4ac3b74a.jpg	t	10995.jpg
1454	805	742af62e1693164d898a6be2fc01770a.jpg	t	10724.jpg
1455	805	01f5e1f699811df152c64005d9ae9155.jpg	t	10725.jpg
1456	806	15b5a0e1cfd5cc9f061aa4e2c6509dc0.jpg	t	10738.jpg
1457	806	37776db68e51d441b628c9e0140a4a45.jpg	t	10739.jpg
1458	807	1891c794a05903508ee62bcf4d927666.jpg	t	10965.jpg
1459	807	eec1532b7439d04aa4da4645fac18602.jpg	t	10966.jpg
1460	807	44c11764a5e8d341f7f0ee81c5ea7a0f.jpg	t	10967.jpg
1461	808	2f6ff0a240540bb0be643295b4076774.jpg	t	10972.jpg
1462	808	5dd38938775ca5a5aed39eef619e1a2a.jpg	t	10973.jpg
1463	809	725482570be84d3e8f76abf2eaa3d718.jpg	t	10704.jpg
1464	809	5db00e98fe7bbc7a82528eafe043e950.jpg	t	10705.jpg
1465	810	7f13229d5d9ce17d783679240a6fa41d.jpg	t	10698.jpg
1466	810	2ac8c72d822ff25920c50eef39179a3b.jpg	t	10699.jpg
1467	811	6e98779cdeb89fc04f1e9d54ba0922cb.jpg	t	10732.jpg
1468	811	54c25c5125e6ccb2d9702672bfc74eea.jpg	t	10733.jpg
1469	812	741b9d9085021458749bf6bea460648d.jpg	t	10718.jpg
1470	812	34e15d43ebca8672f51d8026704e58dc.jpg	t	10719.jpg
1471	813	1c6210afa0046a58b25453ae242d64ee.jpg	t	10692.jpg
1472	813	273ed49f7bc890758ef0fcc9f159901d.jpg	t	10693.jpg
1473	814	3f9f3bd7c0341b7e1a1a0920463052b5.jpg	t	10708.jpg
1474	814	f14bd51adb85aedf7d5b69f8ef86867b.jpg	t	10709.jpg
1475	815	16d9317ff669bb058d784159206f64d8.jpg	t	10992.jpg
1476	815	3bd38b73c3511623af5a23c5fda18649.jpg	t	10993.jpg
1477	816	95bd3f94fedcda52f115f278e7afae32.jpg	t	10694.jpg
1478	816	bce8c20a92f95372d97c0e579ef255a7.jpg	t	10695.jpg
1479	817	5eb256f0654bfcd08a472d4884f42193.jpg	t	10990.jpg
1480	817	d33a854e2e8c4dbae4c3d94a6f1bdfac.jpg	t	10991.jpg
1481	818	1877ce35496733294740af270fc1732d.jpg	t	10716.jpg
1482	818	7fdaedc161d91ffed574acb9d8b3891a.jpg	t	10717.jpg
1483	819	e93217621c366365ed3ce18ab6953939.jpg	t	10955.jpg
1484	819	ce7f1619dae8ed253d3c5278881087a6.jpg	t	10956.jpg
1485	820	dea71e43c43aac1f278f0a7a2c544e18.jpg	t	10998.jpg
1486	820	1a33e278587461f1a7b46d10526c623c.jpg	t	10999.jpg
1487	821	4b2e717077915653564e6aeddf5c0620.jpg	t	10736.jpg
1488	821	e817e04225c7b75c44cf31f6893b0993.jpg	t	10737.jpg
1489	822	e4f89a3baa99e49a79fbe3c6146625f2.jpg	t	10368.jpg
1490	822	d5ed8428baf3ea6b20ef48590b213156.jpg	t	10369.jpg
1491	823	3383a5005796e97a84f33185150d6759.jpg	t	10951.jpg
1492	823	e813bf5a72aeda35272339cb2067d445.jpg	t	10952.jpg
1493	824	231f6307fd1ea7a2860843e01318ff32.jpg	t	10728.jpg
1494	824	d4c1536d6ac62f4ddb38712494d7b0f4.jpg	t	10729.jpg
1495	825	d28335d17b365ac8b9fe78e525876383.jpg	t	10961.jpg
1496	825	b8f3b963abc1214356934b01f906be80.jpg	t	10962.jpg
1497	826	af551948d60ec7ab16cea87b1e1ecee0.jpg	t	10712.jpg
1498	826	e12fce498b15bcdaaae6cad6ffce92e4.jpg	t	10713.jpg
1499	827	59629b932a29b438d1d55cfbf17e3054.jpg	t	21045.jpg
1500	827	71e291525d8df24ca2d426b57af47b28.jpg	t	21046.jpg
1501	828	8d45d9d2106792bd238d056597f8c8ef.jpg	t	21049.jpg
1502	828	0be3acd2039d0dfd98a331fdbbfbe23e.jpg	t	21050.jpg
1503	829	321e607502701cde21aaefb88b9a6cd5.jpg	t	21047.jpg
1504	829	e55f482a7ae15bda9e3ff850af6a34b8.jpg	t	21048.jpg
1505	830	f0fbe092f509b9ed68d69cb296fcdc70.jpg	t	21081.jpg
1506	830	d4cdbadc11c63e3b1ff1d46f8c9ca000.jpg	t	21082.jpg
1507	831	68103a70431bd1d75761a953b47206f0.jpg	t	21053.jpg
1508	831	ee7ec023e63a5c27ee87496b53496b9e.jpg	t	21054.jpg
1509	832	73d935ab0b699b386ca96b86aafb5b9b.jpg	t	21077.jpg
1510	832	71cb61c1dd7800a6e21471111ef81929.jpg	t	21078.jpg
1511	833	82ff44fb8724045fd8d61aba0dbdec29.jpg	t	21055.jpg
1512	833	966996157db3dc63a61df58f821d04c5.jpg	t	21056.jpg
1513	834	aea74dca16cdff8c7a57be886a0fb86d.jpg	t	21071.jpg
1514	834	390ab10de8f66542256bc0e90a5774e0.jpg	t	21072.jpg
1515	835	7ba6858f1ea5173c7b6c1f6d79b705bb.jpg	t	21067.jpg
1516	835	825ca8ba3c38302fcc8ce98ad5700660.jpg	t	21068.jpg
1517	836	73d935ab0b699b386ca96b86aafb5b9b.jpg	t	21077.jpg
1518	836	71cb61c1dd7800a6e21471111ef81929.jpg	t	21078.jpg
1519	837	2d882c74bbf67d7c2273dafdb03af999.jpg	t	21061.jpg
1520	837	6db3352b156b807cf56185e7ad8461e0.jpg	t	21062.jpg
1521	838	d16eed1da81c4c58dd88bd9bb5ca92ce.jpg	t	21214.jpg
1522	838	4c5fafbfdff972148951f89a80f81ee6.jpg	t	21215.jpg
1523	839	ca629ba74cf38fdbbef72f6c4d550fc6.jpg	t	21192.jpg
1524	839	b2a254342b3aa714a77e7e55dbb00fb9.jpg	t	21193.jpg
1525	840	b6ef01e19b85f6366dfc0c4f4fda04b8.jpg	t	10563.jpg
1526	840	f1e4dd7af2e22e545812e4d834a8894e.jpg	t	10564.jpg
1527	841	1b1bb1003f09cdbb6db224a5f58dcaf4.jpg	t	21085.jpg
1528	841	f0fddc4ca4b04b4e5228896997793789.jpg	t	21086.jpg
1529	842	00b9bbc79b69a5d862822317e3e65549.jpg	t	21206.jpg
1530	842	4e74b187e9a45aeecaf13f1d7ef6de07.jpg	t	21207.jpg
1531	843	3a586bffdb2933c10b81b4096adc4bbd.jpg	t	21196.jpg
1532	843	ee3093337f79857ea0be576e56607634.jpg	t	21197.jpg
1533	844	7668b5273f162463cfb4a904b1edf2f9.jpg	t	21095.jpg
1534	844	0f3eefaae22378cd82335d6fb16c6b5a.jpg	t	21096.jpg
1535	845	65ef13ac82c2be428e493fa33efe37f5.jpg	t	21198.jpg
1536	845	f3403ea6f700c0f57b712616d72d8c23.jpg	t	21199.jpg
1537	846	9e43812320c62298ad664a2a26e86a77.jpg	t	21063.jpg
1538	847	f633e49ee5db7ca87feb1a5ea1023b77.jpg	t	21089.jpg
1539	847	af70f7bc0116176279337bba48c5bf7b.jpg	t	21090.jpg
1540	848	898ee94ce9849169454e63eb01a94017.jpg	t	21190.jpg
1541	848	6f706637213922d5bab15ea3a4a09356.jpg	t	21191.jpg
1542	849	ed469207d31cda26887c1b9788bdb28e.jpg	t	21212.jpg
1543	849	37883a48855b2f783658cd4ef20c8c0e.jpg	t	21213.jpg
1544	850	9c29d5f6e4ade8fe601d348a45e16f9b.jpg	t	21202.jpg
1545	850	82037885a049ed2bb6112aac84e8e0f0.jpg	t	21203.jpg
1546	851	7346d80e013886e1284331d68731dc1c.jpg	t	10490.jpg
1547	851	1b233bd681a70ef332ded51a06779f56.jpg	t	10491.jpg
1548	852	828f0a3fc0864febcf5541018a17ad7a.jpg	t	10527.jpg
1549	852	eedb53df9222f2a866dee9d3bc07022a.jpg	t	10528.jpg
1550	853	8995ed5325230cc9aafaea027cb4b1a6.jpg	t	10549.jpg
1551	853	c3381a9c5c4b3b55c03b068bd27956e1.jpg	t	10550.jpg
1552	854	57269b180de6f3ee586dca719205522b.jpg	t	10511.jpg
1553	854	251bfee18ff803ef4b0c767286ff34ca.jpg	t	10512.jpg
1554	855	2d4263788f519bbf2766352b6dca2aba.jpg	t	10523.jpg
1555	855	7749e8233e0520d02378234df4c8620e.jpg	t	10524.jpg
1556	856	2a5da28ae1d7f1fb39f9f81bd25b3bb0.jpg	t	10513.jpg
1557	856	aabdfc7d34ca4c994ae6005d4ec62280.jpg	t	10514.jpg
1558	857	413ee6d138a43f8e3ccf7743e7a4aa51.jpg	t	10505.jpg
1559	857	72981c721dcfd93dab56ac1d986e8878.jpg	t	10506.jpg
1560	858	8a440c3c7cf0cec279ada9577486f9b2.jpg	t	10481.jpg
1561	858	a69ac4dcccb83ef3f487c96892604423.jpg	t	10482.jpg
1562	859	d5a511c562fa5ec39fa692f22dd45d9d.jpg	t	10502.jpg
1563	859	aa380e1b2e539c17c82286def90b69f9.jpg	t	10504.jpg
1564	860	9a354a3e40ebf4edfcf22a14cea4d6c1.jpg	t	10498.jpg
1565	860	a9106c0c98491929322cd7e1a98004d4.jpg	t	10499.jpg
1566	861	5a56e8f7c3c5dd7c84df917b9bc85174.jpg	t	10485.jpg
1567	861	c21f2530ffa6aaa2dbee77741af78ccc.jpg	t	10487.jpg
1568	862	6eec84effac9abb4e78d515526d755d9.jpg	t	10543.jpg
1569	862	23c6f44c909a9baf1a5fd7ed2d33d9a8.jpg	t	10544.jpg
1570	863	bfca5122bb08cc79a79d6eea90b6e6d2.jpg	t	10492.jpg
1571	863	957f381ed71bfc4a196bc497e03dea48.jpg	t	10493.jpg
1572	864	88e27150781ddc4013b7740f6c07314a.jpg	t	10559.jpg
1573	864	1071b1584e37b50e11971a922bc502b8.jpg	t	10560.jpg
1574	865	e3b2d669fdf03068ba1c5974bcd84ae3.jpg	t	10533.jpg
1575	865	7195e24c554da67621d2f5cbaf5a518f.jpg	t	10534.jpg
1576	866	76ee7b75bce87ed8ccdb3a4818feaf19.jpg	t	10557.jpg
1577	866	083627c7e8305f624caa8a706b1ef533.jpg	t	10558.jpg
1578	867	2f400b8908d200f5032843854534b900.jpg	t	10555.jpg
1579	867	4f5ef56a5f294cab30d7679faeebb69e.jpg	t	10556.jpg
1580	868	88f0f511a94fb71b35f0edf28ebf212a.jpg	t	10547.jpg
1581	868	357a04e316fadd8701e592012c948440.jpg	t	10548.jpg
1582	869	e1f243f8348fe2196f2bfca706d9bc4a.jpg	t	10551.jpg
1583	869	629d42039e99fa84fb018ebc034c7b29.jpg	t	10552.jpg
1584	870	406f22255a14080af4ff363944c430c7.jpg	t	10539.jpg
1585	870	86cd41ea42b6f8597afe504e245196ee.jpg	t	10540.jpg
1586	871	ad98e5f64b6ff7d9c5976bc4975f2853.jpg	t	10531.jpg
1587	871	f03ecdc1d66c31eb55b47ac7c35e8d38.jpg	t	10532.jpg
1588	872	1f95d91fc3b115aadc6b609840ef3268.jpg	t	10081.jpg
1589	872	702356673c33e390feece1ffbb3cd210.jpg	t	10082.jpg
1590	873	12b78beed826189677cd08b075835885.jpg	t	10114.jpg
1591	873	55ca3b8d0492f8990620ed8db268fda2.jpg	t	10115.jpg
1592	874	037f2cd68e559a85baf4b703a9948a44.jpg	t	10129.jpg
1593	874	86bb71c39a2bae8d1780ce29fbc65f10.jpg	t	10130.jpg
1594	874	cf94209c53126f29645dd9ae04b4f292.jpg	t	10131.jpg
1595	875	164ccd914df1b2ef9861ab4eca6ba4bb.jpg	t	10125.jpg
1596	875	6e6f22bb2ff23475b54f22c337b9864c.jpg	t	10126.jpg
1597	876	d0b7df04793fe81f6eefdb5bca48b50d.jpg	t	10087.jpg
1598	876	bdd2f959442e6cc02e04e1dc3fc166d3.jpg	t	10088.jpg
1599	877	334c7b89d8b8ed25680a45a5f8d34f0c.jpg	t	10069.jpg
1600	877	b9fb020398f3a51d078810f2ce3f6299.jpg	t	10070.jpg
1601	878	f700d2822fac726878832e5bdd5a02b5.jpg	t	10073.jpg
1602	878	68c6357ca769ecaa879e32073e7bdba0.jpg	t	10074.jpg
1603	879	80a08bca3d1abb29e02f240c23cbce0f.jpg	t	10091.jpg
1604	879	cc17a939c5010817bfacfe7cd3b10bae.jpg	t	10092.jpg
1605	880	d0b7df04793fe81f6eefdb5bca48b50d.jpg	t	10087.jpg
1606	880	bdd2f959442e6cc02e04e1dc3fc166d3.jpg	t	10088.jpg
1607	881	769ee64224a63710ae22a69e91fc8767.jpg	t	10148.jpg
1608	881	3510ef96c45d4df02a3b7baebd934381.jpg	t	10149.jpg
1609	882	15cee678b2362d82f6723779ae56ca1b.jpg	t	10063.jpg
1610	882	1bb0d068c821f5f73d37c5a10e80b09c.jpg	t	10064.jpg
1611	883	a3b3d5dd23aa3dc3d76369370700e183.jpg	t	10077.jpg
1612	883	2e4c017fde83ddee205f5273f0dd8bc3.jpg	t	10078.jpg
1613	884	85bf4e296a1408cf77570d2eaf70e78a.jpg	t	10059.jpg
1614	884	a3fe2830914ed0763a6f20fdbd2df334.jpg	t	10060.jpg
1615	885	15b6f4cd7e649194f3d64d5b2b3ddd93.jpg	t	10134.jpg
1616	885	58594390987bc57d3061a28e9a89db16.jpg	t	10135.jpg
1617	886	0820b6b0a977ae3a2d205a644fbc785b.jpg	t	10101.jpg
1618	886	ef5120683a5ad95d2e1516602ee43996.jpg	t	10102.jpg
1619	887	b1eb2086d7c5a615924d8fcf64b03b65.jpg	t	20999.jpg
1620	887	2cb3089d0cf9203e381fc6fdde413d24.jpg	t	21000.jpg
1621	888	f69d80722ce7075455f20625f3f20923.jpg	t	10108.jpg
1622	888	970a4bcfd1de61e9949491afb6a8a8c9.jpg	t	10109.jpg
1623	889	718907b097fd602fbccb165fa36fa55a.jpg	t	10112.jpg
1624	889	1bb9abd476f44ff7a152bc70f0cf0ced.jpg	t	10113.jpg
1625	890	ebabef4e8d69e221bdce886f0a6bd128.jpg	t	10099.jpg
1626	890	d6f4382478a0cf164c178d65aa101a37.jpg	t	10100.jpg
1627	891	e5ec5b028b796222ef3a2fbfd1b5711d.jpg	t	10142.jpg
1628	891	be641d662c5eaef276f89a65066e5736.jpg	t	10143.jpg
1629	892	3b2a5e6d2bb5a23cb866c8458abaf5bc.jpg	t	10121.jpg
1630	892	35ab7e17a89813ac38be42a67dd303fd.jpg	t	10122.jpg
1631	893	36f4d36d623cb18b030bb426aff5359b.jpg	t	10138.jpg
1632	893	21659d3489555518679b5a6cc1930934.jpg	t	10139.jpg
1633	894	c8d09c2a61c4feaecf4edcc1d6d268da.jpg	t	10806.jpg
1634	894	a5deba30f8d79589fefa8284d19a1362.jpg	t	10807.jpg
1635	895	7445dd09b7b1b7fc6a3506c54391dffe.jpg	t	30814.jpg
1636	895	074ccc546fc6238c5441a395ff344d44.jpg	t	30815.jpg
1637	896	e5440338a28c4a559371f3b8beecda75.jpg	t	10800.jpg
1638	896	16e72293d4349cabfec2db3344ca3d61.jpg	t	10801.jpg
1639	897	ba754f86926067c49a9e1c58b177a715.jpg	t	30812.jpg
1640	897	698e9e41678e04ea6a76240358110cd3.jpg	t	30813.jpg
1641	898	1b30e96a54b6772f546d7f62954efff3.jpg	t	30818.jpg
1642	898	77253e17bfc71b9ccdb01a7af329a9e4.jpg	t	30819.jpg
1643	899	8ac79038ac956c5c721d7be0cde5cc84.jpg	t	30822.jpg
1644	899	01030391b35f7a7e0c074cf99f33d55a.jpg	t	30823.jpg
1645	900	d9299c200c84d439b3cd85db108aca9f.jpg	t	30798.jpg
1646	900	3b68553130a38e307282ac189b6efda7.jpg	t	30799.jpg
1647	901	991ca0f162939c417e554a3bd377bbd3.jpg	t	30009.jpg
1648	901	4de67e59b1daf7d8589c60bf95d05f45.jpg	t	30010.jpg
1649	902	43e2224db26099ecf5c5e0728f8b9cea.jpg	t	30793.jpg
1650	902	e6a17e6dd66985ee5e94b2705e76195c.jpg	t	30792.jpg
1651	903	9f8ac5a7811b07182ee7d1a5a2e4b004.jpg	t	30790.jpg
1652	903	756662ddf73d04ba06c78762a847943e.jpg	t	30791.jpg
1653	904	9da370b93b77e3fcda19f68040c7ee6b.jpg	t	20376.jpg
1654	904	818bfcc21f8123f99251b32e68eb427e.jpg	t	20377.jpg
1655	905	6c4f2e1e355428304f54bbc01b190d02.jpg	t	20384.jpg
1656	905	5243dd2ae75449851579ea8f49bf42f5.jpg	t	20385.jpg
1657	906	214fe7311765c574072b5b6a2a15aba3.jpg	t	20382.jpg
1658	906	8a85629474ecf094e0aba61aa453970d.jpg	t	20383.jpg
1659	907	5dcefbb8272899f1cd6793122b91ba7e.jpg	t	20400.jpg
1660	907	5e0d805e94ba2ba56cbc7d79b20dd1e6.jpg	t	20401.jpg
1661	908	34e9b18648b8be011a90139f751cf7f0.jpg	t	20356.jpg
1662	908	3032e84a188ed619e0576eb4c658ccee.jpg	t	20357.jpg
1663	909	412c46e45baddfb443ad783fc3cf567f.jpg	t	20386.jpg
1664	909	50d14e7dbf6fafb27754b8144f5b800c.jpg	t	20387.jpg
1665	910	b0a1861819de8e7711e101356cbfa565.jpg	t	20358.jpg
1666	910	0c7272d6e9ad74cc7bc06342ce89de59.jpg	t	20359.jpg
1667	911	93abffe9209d5c963de6542ab8f8cbbf.jpg	t	20370.jpg
1668	911	5de5e9eb38268cf320e8e29188759f64.jpg	t	20371.jpg
1669	912	9301ece02c2ba2dbf2a790f040c4d272.jpg	t	20406.jpg
1670	912	de528689c7575769a7879688db4dbbd6.jpg	t	20407.jpg
1671	913	58b0074d341f965bcc8ee9cf870e077c.jpg	t	20368.jpg
1672	913	5749d7fe91e3ee15072cb2a943c99f6e.jpg	t	20369.jpg
1673	914	90a5087560642702382c13060909953f.jpg	t	20374.jpg
1674	914	fac13a63654f173329f298779ddccf9a.jpg	t	20375.jpg
1675	915	bc16b881e9a947c745f392ab392c6665.jpg	t	20404.jpg
1676	915	9ef0fc88f949279da33375299e687286.jpg	t	20405.jpg
1677	916	4a3e9a154167e8b47bc8967fd86c3516.jpg	t	20364.jpg
1678	916	401e0a90d25cb8f7b1bc0b27e7c11ebf.jpg	t	20365.jpg
1679	917	bc16b881e9a947c745f392ab392c6665.jpg	t	20404.jpg
1680	917	9ef0fc88f949279da33375299e687286.jpg	t	20405.jpg
1681	918	6d44807cab6259a8932fd609a2827686.jpg	t	20408.jpg
1682	918	88086f285ff7c52868ae8e015ebfe4d0.jpg	t	20409.jpg
1683	919	3079881c01cdddb03b03e4edb721baed.jpg	t	20378.jpg
1684	919	cee7485c9e17f0502571d72c59c8e892.jpg	t	20379.jpg
1685	920	9301ece02c2ba2dbf2a790f040c4d272.jpg	t	20406.jpg
1686	920	de528689c7575769a7879688db4dbbd6.jpg	t	20407.jpg
1687	921	412c46e45baddfb443ad783fc3cf567f.jpg	t	20386.jpg
1688	921	50d14e7dbf6fafb27754b8144f5b800c.jpg	t	20387.jpg
1689	922	35f099d04e09f33db9d69618e82e12e7.jpg	t	20594.jpg
1690	922	3cb9709fbba35bc6766c19f97a63f7e1.jpg	t	20595.jpg
1691	923	f472aad80fbb4d8fcfb66ffb41843251.jpg	t	20600.jpg
1692	923	112a5db2058f45a2af67640e440026ae.jpg	t	20601.jpg
1693	924	f00c83c2c30d9e58c64e2f7c969f362d.jpg	t	20580.jpg
1694	924	9e41e3dba80d73a471ef53424f30eee6.jpg	t	20581.jpg
1695	925	8968404bfb51c010912565ee4fad8b6f.jpg	t	20586.jpg
1696	925	4adfa62288d6f00f79892b53cd225f76.jpg	t	20587.jpg
1697	926	751944548ed1000befd1358b1b2f7337.jpg	t	10748.jpg
1698	926	23c9ac60f386db067a136ce7898174f4.jpg	t	10749.jpg
1699	927	30bf63d8b99e3497842e563ed88402a1.jpg	t	20548.jpg
1700	927	48a811571eb154a7444fd4e6b91c4acc.jpg	t	20549.jpg
1701	928	e147b614a2e0b15ede9e7695af3d69f5.jpg	t	20590.jpg
1702	928	93a190456978597431c9f8ca78f294a4.jpg	t	20591.jpg
1703	929	d0706455c97c6896694b936deaa23869.jpg	t	20610.jpg
1704	929	9d59c0a7983fbd783b57109224630694.jpg	t	20611.jpg
1705	930	770dad7d6e0fc9bcb9bb86701789700d.jpg	t	10756.jpg
1706	930	d024da28a112e18bdfe60f72e5f60779.jpg	t	10757.jpg
1707	931	28c3d92ede93f263825f1e0c9b3ad3ca.jpg	t	20618.jpg
1708	931	29abb6a2929c92d0607697bdc5fd0789.jpg	t	20619.jpg
1709	932	afbd8749616873693b75f4356c35ac2a.jpg	t	20528.jpg
1710	932	84353b054f580556d8dd1adb861b3ffd.jpg	t	20529.jpg
1711	933	b20f43849e49db502d56bdd3d239d0bc.jpg	t	10760.jpg
1712	933	786e22dab4e9380f058c79963a097f26.jpg	t	10761.jpg
1713	934	d64cf9c37cb91d70a8038bce45b2630a.jpg	t	20624.jpg
1714	934	0ad4c62a49c8141417f5f072388655da.jpg	t	20625.jpg
1715	935	5936738bba561408ad3d36db946254df.jpg	t	20616.jpg
1716	935	f55c55bc5c85fba1b1f95a637bf83ab0.jpg	t	20617.jpg
1717	936	9c8b4260c63d07674ef9cef9e39c56ed.jpg	t	20608.jpg
1718	936	b233c0d1b3ba60ad630bced7543c6c32.jpg	t	20609.jpg
1719	937	5169b40c2b1a45b18643c44a4b53a599.jpg	t	20576.jpg
1720	937	1f360db2f7606b968684d365dcf096f3.jpg	t	20577.jpg
1721	938	1938fd92fa36a0b0ed655118f8f4e760.jpg	t	20572.jpg
1722	938	8ddf12ecc18df7cb7481328b169be52a.jpg	t	20574.jpg
1723	939	d5f3d2b78022e45393b0e2c6b94ff33d.jpg	t	20532.jpg
1724	939	9774a687def35eb57188b944dee98593.jpg	t	20533.jpg
1725	940	8ddf12ecc18df7cb7481328b169be52a.jpg	t	20574.jpg
1726	940	987c843a87b96b1464cdfe725cc4f76d.jpg	t	20575.jpg
1727	941	db5b2c2d33b64d8297f33dea0b4b90c0.jpg	t	20602.jpg
1728	941	aea377dfb710e0e1d5fecdfd2d9cb2ab.jpg	t	20603.jpg
1729	942	9e672680fd541fe744230d1ce1325037.jpg	t	20540.jpg
1730	942	05a1cc730d1ba90ca31dbccf75137457.jpg	t	20541.jpg
1731	943	4c14b1f3e55bb1ebfbe469dbe110198b.jpg	t	10786.jpg
1732	943	08978faeb4cdf5e03bb2aba082c78fce.jpg	t	10787.jpg
1733	944	7bf51766bb1e10c70ab221e2db4c15f2.jpg	t	10778.jpg
1734	944	d8623a144ae2bb1c58d9078e5b1f90cf.jpg	t	10779.jpg
1735	945	2194aa20764d9076598307f8701d3f21.jpg	t	10780.jpg
1736	945	13bfe01c296bb9e871b7ef3bb1aeee1f.jpg	t	10781.jpg
1737	946	2487d75d946bb30641a7bc4d84d495e3.jpg	t	20536.jpg
1738	946	10b734eadfa0a3afa5b89a7bd25d65d7.jpg	t	20537.jpg
1739	947	75fb24e1e56a8f12e6fe1c175fffe16f.jpg	t	20542.jpg
1740	947	a26ad61c4a2af554c14575bb8e3d91d8.jpg	t	20543.jpg
1741	948	8f341d7649a5e7d860f131b1f865ce6c.jpg	t	20582.jpg
1742	948	75bacc81e93e60fbd6824c7392714c32.jpg	t	20583.jpg
1743	949	6bc1a3e5beffd7bb858166f2e7ac3b14.jpg	t	10768.jpg
1744	949	d708e639adef4c49ec5c287388299ad4.jpg	t	10769.jpg
1745	950	4ab8044578daf9b3d692282dfa823da1.jpg	t	10752.jpg
1746	950	bb85c026041f899c312c0947310784c8.jpg	t	10753.jpg
1747	951	73cc31d26cf89da68af08f3cab574fd9.jpg	t	20552.jpg
1748	951	1bedd8c02e6004aa7f911a498510a80d.jpg	t	20553.jpg
1749	952	d4b105a13d0e374376c301a2710622b4.jpg	t	11083.jpg
1750	952	fd283ebf6ee6ca1bad00636b76652491.jpg	t	11084.jpg
1751	953	6c6e19bc261637b18e8183776d5f3a18.jpg	t	10764.jpg
1752	953	50a91ac3436a1e9da16248dfd2c38065.jpg	t	10765.jpg
1753	954	9de9bf758ab43fd523a9cd9130f06111.jpg	t	11058.jpg
1754	954	03b01705f6c7b36f04d6fb311162c51a.jpg	t	11059.jpg
1755	955	4eda4b5d9090823a06486a37a76c38d2.jpg	t	11072.jpg
1756	955	5716d8c03a7eddf32c5444abadc3f6bd.jpg	t	11073.jpg
1757	956	798ef2794e224af05b1f482fcd065731.jpg	t	11062.jpg
1758	956	ac00d5308e41eecdfcdb31c5190af99c.jpg	t	11063.jpg
1759	957	448c5412f1aacf9f720367c4981cec30.jpg	t	11096.jpg
1760	957	0dbf46866df31c1e0cb87ada378c024b.jpg	t	11097.jpg
1761	958	6d36edfbb2bb801b9188a352160873cf.jpg	t	11028.jpg
1762	958	701c561ed1215df867d4c60e52f57739.jpg	t	11029.jpg
1763	959	c27304f03aafc24da8b2be701d254ae3.jpg	t	11002.jpg
1764	959	1be86454ef7d149039f55a1c9a3a8d73.jpg	t	11003.jpg
1765	960	a75bc7a54a75126daede5f7a5767a3e1.jpg	t	11018.jpg
1766	960	4d261dbc08bbf547fea6de4625ccc621.jpg	t	11019.jpg
1767	961	f3b365664c0f8c9777b0871ca77f4310.jpg	t	11034.jpg
1768	961	0906190966b8c1b22537f218f570dce7.jpg	t	11035.jpg
1769	962	1d713b49b73c6a14946ae43e347f4a0b.jpg	t	11010.jpg
1770	962	1a5586fdcaf805e580b4cdded6c070ef.jpg	t	11011.jpg
1771	963	9c7c6ca8e807320bc7ff778ef3df02dc.jpg	t	11056.jpg
1772	963	c3baa2e67aa19fe7391c3661447e5140.jpg	t	11057.jpg
1773	964	4f43399ddc4fdb503d589c470596212d.jpg	t	11038.jpg
1774	964	7ffb70acfb54e3b41d1562ecfd71a26e.jpg	t	11039.jpg
1775	965	fc8d86fac1e78bcdedb7e6f092105775.jpg	t	11042.jpg
1776	965	40596587ba81481c9c12cab0476ccfe9.jpg	t	11043.jpg
1777	966	75412286108c419bdd2181fb9ccdb836.jpg	t	11044.jpg
1778	966	85883977aa0dfba06885e27215b6f369.jpg	t	11045.jpg
1779	967	5b0f95addcce34568949ee452dcc9501.jpg	t	11067.jpg
1780	967	f051cd582ec8e1c4ed4a108945e5ef53.jpg	t	11068.jpg
1781	968	74462f41aab6cee190be9c516b227bb4.jpg	t	11014.jpg
1782	968	081a60751ab01657f612e166f4976a98.jpg	t	11015.jpg
1783	969	96d7694c186e294b761c36289094a90c.jpg	t	11076.jpg
1784	969	7c7c564b71468e98bb68a74e7acd9473.jpg	t	11077.jpg
1785	970	3c90c0a8f68b0b3777e173bfefd3cde8.jpg	t	11024.jpg
1786	970	f1a811d913a0ed602f3bc44e3ce3328b.jpg	t	11025.jpg
1787	971	b6fc505346a1b783e043463f34ca8ceb.jpg	t	11085.jpg
1788	971	adc0c0687345f3357cebdaf67b4a7a4e.jpg	t	11086.jpg
1789	971	13cf3ef1c909362c5919ca314915beec.jpg	t	11087.jpg
1790	972	4ec6ab835b647d706b6f7c03a572b29e.jpg	t	11006.jpg
1791	972	85ed33f9da93d57f1fb2268234f30f6e.jpg	t	11007.jpg
1792	973	389fb2499b51c0397c6e9bd0e42a4c22.jpg	t	11048.jpg
1793	973	e23f61c1511cc378ab5ba5e6831daf5a.jpg	t	11049.jpg
1794	974	d20766d8cc4b2682772575de634d0363.jpg	t	11092.jpg
1795	974	7001a67ee5444a5106ca0f7ac7dd6f37.jpg	t	11093.jpg
1796	975	da58e0e8db6b038beca4b39b1ea69bc3.jpg	t	11008.jpg
1797	975	ce4cbcff583f0e7e44b85526ae0bcd88.jpg	t	11009.jpg
1798	976	32214a32f563adb559fcb17a86337178.jpg	t	30618.jpg
1799	976	f5593310d9310a4f48ca7385e35e3af5.jpg	t	30619.jpg
1800	977	3afce7ee1589ed8b41a9dc23ccdb1f68.jpg	t	40401.jpg
1801	977	75169d719d547aadf05187fc9af7fec7.jpg	t	40402.jpg
1802	978	17c955cca6ff14ce5373706c0205e2dc.jpg	t	40479.jpg
1803	978	8bcf43ccb94020174a9085c4744aa8d0.jpg	t	40480.jpg
1804	979	664c4cd661258c5d126cf9b4d03dde85.jpg	t	40437.jpg
1805	979	fecb008453e04f2f377b05f544b610f9.jpg	t	40438.jpg
1806	980	ecc251a19c5b9a95f19062f9067d56b7.jpg	t	40493.jpg
1807	980	d62a2763cafb1a6965301fa0419e67a9.jpg	t	40494.jpg
1808	981	1251215ef4b320e6a18b87256a9e7ba3.jpg	t	40481.jpg
1809	981	2804a192fc4d129e2dcfce2e4c5b6600.jpg	t	40482.jpg
1810	982	463401d39da191c1b9d20dd05753f01d.jpg	t	40485.jpg
1811	982	b19c5ec3fe7f9ee426aedd6db31e723f.jpg	t	40486.jpg
1812	983	bb5e7000df32abcf5bfe3121d79ff37d.jpg	t	40463.jpg
1813	983	4a47fe69f394d5f82420042c3d8534b5.jpg	t	40464.jpg
1814	984	f63cac9983819313844912f1921d8faa.jpg	t	40391.jpg
1815	984	55c480e29fd1338afc5a9864ebde54b9.jpg	t	40392.jpg
1816	985	81fd1830f5fe8844bd64f7ffad13a80d.jpg	t	40471.jpg
1817	985	bd74fece5e329a1f3e495e1e4c103474.jpg	t	40472.jpg
1818	986	cca0bef23ecdb25035c61b1347539f14.jpg	t	40469.jpg
1819	986	17163bb26701bc9c4c98231e06abcbfb.jpg	t	40470.jpg
1820	987	88eed5d50742f53d65bab1fb5b2a7b78.jpg	t	40489.jpg
1821	987	be1da2cb5f9669c0d52c58d692551448.jpg	t	40490.jpg
1822	988	fba06685a8bc54ca8212155d48e7ec58.jpg	t	40473.jpg
1823	988	cc782c85342954f1e4c87ad902ffc4d7.jpg	t	40474.jpg
1824	989	093686b859b7e86ec0e3b69aee9832b0.jpg	t	40407.jpg
1825	989	fd9bdb2471a1abcbf32d2558cff8d145.jpg	t	40408.jpg
1826	990	75ceaa2fee811a2a8882cf3e1c0525c7.jpg	t	40433.jpg
1827	990	9f4a8bba209dc4aa471d80cf3699d601.jpg	t	40434.jpg
1828	991	0a7de84fae680c47faee49a30bf1a89b.jpg	t	40441.jpg
1829	991	86d58341f4373dda6d5545727c3c5f65.jpg	t	40442.jpg
1830	992	49b7fa343a22efc2463165212a0e6728.jpg	t	40403.jpg
1831	992	4d0518db02ab325f4a366296ad9fc260.jpg	t	40404.jpg
1832	993	54a35ed59d0b00d9929264418f253e01.jpg	t	40421.jpg
1833	993	9388a9f052c516ab07c37c46ab8d108c.jpg	t	40422.jpg
1834	994	d77571aeb7c5f89e2ff9496de6a6bbba.jpg	t	40423.jpg
1835	994	fc30e18bfcfa8bf19b7afb26abb2253c.jpg	t	40424.jpg
1836	995	d13afea4a795521ee425663a421897de.jpg	t	40445.jpg
1837	995	82bcd2d97ded5a80740836d383b22b02.jpg	t	40446.jpg
1838	996	1cef40c02593350cc4c4981f07648044.jpg	t	40459.jpg
1839	996	9a67edd0797c0e1925d3de6be71982ad.jpg	t	40460.jpg
1840	997	f2185cbab82e4cada5d0d97b6053fb88.jpg	t	40429.jpg
1841	997	7a4e80401b967384f805eafbbdfd4596.jpg	t	40430.jpg
1842	998	527979aede673fd3929de3f26c59555a.jpg	t	40447.jpg
1843	998	775a2cb166115a3614c500add78abad0.jpg	t	40448.jpg
1844	999	89488f5e4032068a0d4a47a7959bfbad.jpg	t	40453.jpg
1845	999	64bc30fb8975d2b6681279510f20791c.jpg	t	40454.jpg
1846	1000	2c49d8502098585ceb01cbf629382485.jpg	t	40409.jpg
1847	1000	d9d0a3bc5251fdb87ce367ad66e0fb0b.jpg	t	40410.jpg
1848	1001	82eb37d3c666599e24d051ee756b5ada.jpg	t	40413.jpg
1849	1001	eb73f4433a98c75ec67dd4c22bfbbf27.jpg	t	40414.jpg
1850	1002	d9bcab806399dae162d288e4f2aef79d.jpg	t	40419.jpg
1851	1002	01b3aacbbbc9ea8bc3c9ab5446143b67.jpg	t	40420.jpg
1852	1003	f978922c1501e63eef997af7660eed74.jpg	t	40395.jpg
1853	1003	47a915d689f00a3ac706d9c5cb7bcfbb.jpg	t	40396.jpg
1854	1004	cb643978d8b9a7ee048404475008f6f8.jpg	t	40491.jpg
1855	1004	1101e7d3373dd4c0e7e7c826a5bb28dd.jpg	t	40492.jpg
1856	1005	deed5f5f820cc3019b2b81aee3918e4b.jpg	t	20556.jpg
1857	1005	bc5fab89b3b87601dcbd8bffa54c9c60.jpg	t	20557.jpg
1858	1006	65eb863eae9c73d0bdd8266281d403b0.jpg	t	20366.jpg
1859	1006	550e44f6ae90f9e0344e6f12aa63c14a.jpg	t	20367.jpg
1860	1007	8270d433b5632579fb73c2730287ad4c.jpg	t	20520.jpg
1861	1007	1246061e12e9044540357205106433ad.jpg	t	20521.jpg
1862	1008	6b4840b057b75d7d954dca76dbf2e6bc.jpg	t	20522.jpg
1863	1008	2848d4ee085888bda43f1f35be473ef1.jpg	t	20523.jpg
1864	1009	a82b707cb492c4b400f768cb25238d2b.jpg	t	20524.jpg
1865	1009	5f539d00f0ff11989a496bfbf801d282.jpg	t	20525.jpg
1866	1010	4a3e9a154167e8b47bc8967fd86c3516.jpg	t	20364.jpg
1867	1010	401e0a90d25cb8f7b1bc0b27e7c11ebf.jpg	t	20365.jpg
1868	1011	5c21b5e52fed46bef9dbff158049fefb.jpg	t	20558.jpg
1869	1011	66537eca68a9f36365919d734802cb7a.jpg	t	20559.jpg
1870	1012	64c8affedda774b6d23b1909194a8c78.jpg	t	20482.jpg
1871	1012	738ac99fda0c8983992ed90068fa5845.jpg	t	20483.jpg
1872	1013	ce502ad76707893270617e6f85dcd1e1.jpg	t	21017.jpg
1873	1013	a6f6d2d6566a604b69f6c7408c00a668.jpg	t	21018.jpg
1874	1014	6ef1755d35dad5576dbe27d3a3f98dd6.jpg	t	20428.jpg
1875	1014	20755425b4df09218a2d6ededc7f4bd3.jpg	t	20429.jpg
1876	1015	a025a893cc8b4a64474ad348c4ddf58f.jpg	t	20979.jpg
1877	1015	f2645c99ec5a6207d07cb68a38d1d310.jpg	t	20980.jpg
1878	1016	4fff1c21a61c6beeb84bc3c7d1b858e3.jpg	t	21019.jpg
1879	1016	e2e9c0292e896c856c593c6294dfe36b.jpg	t	21020.jpg
1880	1017	fabcb1d5aaa61d334b1ef1df73c59442.jpg	t	20470.jpg
1881	1017	057db7c40699c36ad67510a7f0890c72.jpg	t	20471.jpg
1882	1018	d8f83a772de06a81639226304a48be7f.jpg	t	20432.jpg
1883	1018	068b445dceedfa9d7fc4f3667e7f2fc1.jpg	t	20433.jpg
1884	1019	c162443df110e19a5d32a4a1dc21e6cd.jpg	t	20446.jpg
1885	1019	e7704b5b790ef4823e14d0292a221770.jpg	t	20447.jpg
1886	1020	9a0e678a362519f2407ea8850c3294dc.jpg	t	20973.jpg
1887	1020	5a8c7d2362313fcd09c03c390f19a7b1.jpg	t	20974.jpg
1888	1021	40e1083e8fbeb8a17bbe2c51c38a6db7.jpg	t	21005.jpg
1889	1021	0f71ae4ab6c12ca34d303272d687f1c9.jpg	t	21006.jpg
1890	1022	e231effb8868c4ab1d78eabd02be88db.jpg	t	20997.jpg
1891	1022	07004cec8ed41718194d367cbbbd5160.jpg	t	20998.jpg
1892	1023	3cf35e8b18484735b7d79bee4f7b7dd9.jpg	t	20987.jpg
1893	1023	5db8f7201e563ecd4060102c4a2afa96.jpg	t	20988.jpg
1894	1024	12e7fa0a596dfd69480d509ac479a3b9.jpg	t	20991.jpg
1895	1024	df28b56c85fc90f7f90fe377e1a19f4d.jpg	t	20992.jpg
1896	1025	1b76a4ec2bf7e34fa15d8548c15f4684.jpg	t	21023.jpg
1897	1025	1fc95064f88d67559ab341eda06a58ef.jpg	t	21024.jpg
1898	1026	52501d042de4b50b12901d803f65e4bd.jpg	t	21013.jpg
1899	1026	60c66c35b27ab3e30d0fc84b58393054.jpg	t	21014.jpg
1900	1027	055872ce06d96dd87c912005c2967a51.jpg	t	20981.jpg
1901	1027	99eebd751d2aa439e007db571366131b.jpg	t	20982.jpg
1902	1028	2d37e6bf0a5ad9a94e8b79d05284578d.jpg	t	21007.jpg
1903	1028	c50e32dd3185fe9222a3031bb2cfe13f.jpg	t	21008.jpg
1904	1029	880c1a41b04796debdb61d7e54063228.jpg	t	20767.jpg
1905	1029	83c39859ca7bc129552b4d57c523f86c.jpg	t	20768.jpg
1906	1030	273787cffe5dbe1d4e1c830890e92b4c.jpg	t	20937.jpg
1907	1030	7a20bb79c8ee85c296c10a11f3c2de78.jpg	t	20938.jpg
1908	1031	daa85ded200bf0cafdd2b6020c2045cd.jpg	t	20969.jpg
1909	1031	cbdb029668e32adfc6805666b5b38c0a.jpg	t	20970.jpg
1910	1032	e0153c667658fe906234c3c66254c3d5.jpg	t	20478.jpg
1911	1032	86babcf105a688af67a6bd98f3f09cd5.jpg	t	20479.jpg
1912	1033	e5495233ccec0a78e9f1aa11ac371126.jpg	t	21029.jpg
1913	1033	226177c5aa0ec9fa6b968c165b90b58a.jpg	t	21030.jpg
1914	1034	442addcce2695d6fe2aa3929ad2e7c7a.jpg	t	21001.jpg
1915	1034	70620bd58ef3fa754898a623c7d5a134.jpg	t	21002.jpg
1916	1035	fec24fc3859d113affdfe1121a9113f9.jpg	t	21041.jpg
1917	1035	c44530ee58f15e442433de730599bc4f.jpg	t	21042.jpg
1918	1036	210bdec48c1c40dc054d22e010206176.jpg	t	20445.jpg
1919	1036	210bdec48c1c40dc054d22e010206176.jpg	t	20445.jpg
1920	1037	dbc4833892136994e4e3ce0d9d8042d0.jpg	t	20450.jpg
1921	1037	ea0eea596ed957373a27a97ebf114d64.jpg	t	20451.jpg
1922	1038	c69cd299bce3e4833788196138332a92.jpg	t	20460.jpg
1923	1038	ebdb5061631e7b1409264068bc9ec545.jpg	t	20461.jpg
1924	1039	52056d29bf250a6a345a84481a390440.jpg	t	20436.jpg
1925	1039	d0cb13c6c0e151f0bb29eb42da927904.jpg	t	20437.jpg
1926	1040	6ab3f923da575902c772fed1fee27002.jpg	t	20454.jpg
1927	1040	e32fee4598c2eac899bf4193a1cc01ce.jpg	t	20455.jpg
1928	1041	fd8ee45c6aa7ea7309080820223688d4.jpg	t	30651.jpg
1929	1041	de3bb2a3bb478074569dcf29ab85a7b5.jpg	t	30652.jpg
1930	1042	9579f273c05baf798a5b53546bf0a888.jpg	t	30647.jpg
1931	1042	ece1d0afcd042b16a806637bd9a5c5db.jpg	t	30648.jpg
1932	1043	9db4c6aa0da0a2b0617abe8afb8d99a5.jpg	t	40525.jpg
1933	1043	edc503d5fef9425f3528e3994a3ad343.jpg	t	40526.jpg
1934	1044	f021d358fa5aa0ee7a1b05cc3eec40a3.jpg	t	40519.jpg
1935	1044	78205fb46bd632ba767d3adbf340669f.jpg	t	40520.jpg
1936	1045	82b34439f0fa794ae207a9db4df83f8b.jpg	t	40521.jpg
1937	1045	dc6033ee110088f914ccab8f1809a739.jpg	t	40522.jpg
1938	1046	4166614323f1ff445c37b43c59c446a8.jpg	t	40561.jpg
1939	1046	2f1ba2bc0ed39b79d3efb5bbf95333d2.jpg	t	40562.jpg
1940	1047	e4c1567e3ae4aa895207cb449ef0f68e.jpg	t	30668.jpg
1941	1047	801cfab78da38e2112a82b76f37ec377.jpg	t	30669.jpg
1942	1048	633683d5be228f6793d7d44421da6ab7.jpg	t	30670.jpg
1943	1048	76c0960e27b0ce9bd0779c9ced021dc1.jpg	t	30672.jpg
1944	1049	7e8735f8cb3fb7d30589b6754950d28e.jpg	t	40547.jpg
1945	1049	b6c1ea6ccdf9ba9b06d80ac456acf79f.jpg	t	40548.jpg
1946	1050	f22faeb4b0a8c91336b407ba68e4eb45.jpg	t	30658.jpg
1947	1050	9788111000a3486fac330368a0077ec3.jpg	t	30659.jpg
1948	1051	9a3f5f6a95c2b223c703f720d35a2c5c.jpg	t	40555.jpg
1949	1051	f76a75b590414d161dfdb0628ef8b08f.jpg	t	40556.jpg
1950	1052	fe5ff8aeabac7c05b2b3553b73b4fbe1.jpg	t	40541.jpg
1951	1052	5c32f6fd0157f3f015c81ea397ef2b7c.jpg	t	40542.jpg
1952	1053	dd2aa377eeff305e08f1efd7d98478b0.jpg	t	40545.jpg
1953	1053	d09c7774fc87af76cac5a1f7630772ea.jpg	t	40546.jpg
1954	1054	bce45e47ce3afeee77254776a4b97258.jpg	t	40537.jpg
1955	1054	0ce4f0d373e2cec609b5b08702599b21.jpg	t	40538.jpg
1956	1055	b8f81e3449e42a616bddaa1cc7fa9076.jpg	t	40553.jpg
1957	1055	9030f7d05fa878dbaf65914542c28eca.jpg	t	40554.jpg
1958	1056	bc3ad59d8f7dfed6a94320e573a1f135.jpg	t	40551.jpg
1959	1056	cdd515b27f55f22c2927c39c6ba4e3d4.jpg	t	40552.jpg
1960	1057	a2a4fefc5bafecc06338449e40c2afb5.jpg	t	30185.jpg
1961	1057	d0e463e49b63c2d32489d1aeecf76164.jpg	t	30186.jpg
1962	1058	0bfb58e825e6af156e91aaf68aa399c2.jpg	t	10469.jpg
1963	1058	0c6086bcad4e6a04d12cacb64e82f117.jpg	t	10470.jpg
1964	1059	433e48da38a6239562fa5cbb15c6beca.jpg	t	30163.jpg
1965	1059	3fa94db3d6c4e32e9f66b1f23c75d42e.jpg	t	30164.jpg
1966	1060	33a8154c50db15d05d93e8d341faeb1a.jpg	t	30180.jpg
1967	1060	0ec16b6e58bd76f86ccf2bad7fa8702b.jpg	t	30181.jpg
1968	1061	02e717aa4c2505ae7fb963e2531f3daf.jpg	t	10443.jpg
1969	1061	42621faed681aae17fb4c0c658213613.jpg	t	10444.jpg
1970	1062	893b96fdb7c9c7b56272e7482f6f2d29.jpg	t	30179.jpg
1971	1062	f8a7c1ff3a54d8595a6c30802dcf9ff2.jpg	t	30184.jpg
1972	1063	d717cce6d131bef9ef093b990131210d.jpg	t	10447.jpg
1973	1063	bac7322682bc4fb40b5127d107100fc2.jpg	t	10448.jpg
1974	1064	1ade63393ffc0e9968b49d8e0cebf6aa.jpg	t	30203.jpg
1975	1064	baa9a73f90de3f47a18f97aa27d31eca.jpg	t	30204.jpg
1976	1065	8d8f05f6e670ca0a7cb0dff410d3c144.jpg	t	10459.jpg
1977	1065	aa71531e7bda28777da2cb15cb00692e.jpg	t	10460.jpg
1978	1066	ab96e6dc1dae27d75333d64223aefb6a.jpg	t	30197.jpg
1979	1066	9628bbbe5c2b712ed41848badfce9774.jpg	t	30198.jpg
1980	1067	1fe8e28139e3de7c9587b6a4164d0931.jpg	t	10475.jpg
1981	1067	69b474e9bcf490eac6b90e2167455d30.jpg	t	10476.jpg
1982	1068	ed8471edf420edda00b9aa930ff7aba6.jpg	t	30175.jpg
1983	1068	68ac381bf22c0868787ad5aa9fb92a40.jpg	t	30176.jpg
1984	1069	cd18f9e47dabe5d12abccfa454ee7ec4.jpg	t	10464.jpg
1985	1069	3c490ffcb7748d9646a8a5e2f123fc53.jpg	t	10465.jpg
1986	1070	b815b86c20b8e42c9f8f2588d40748a2.jpg	t	30191.jpg
1987	1070	5bbb2b5cf6ac12001398e8fd00502b68.jpg	t	30192.jpg
1988	1071	4f08df6d20fc02f43a1cf6bb8ba2fbdf.jpg	t	30169.jpg
1989	1071	a10ac05a69a7d9dbe03250ad08559359.jpg	t	30170.jpg
1990	1072	5a6bd28ec6a8a2b1a7d403de1b8849d9.jpg	t	10457.jpg
1991	1072	f614ec177dd8d2f03b6f4d777e90db3d.jpg	t	10458.jpg
1992	1073	dfdbf8b67ffbe0bbd792274f43a8b48c.jpg	t	10453.jpg
1993	1073	d54c6c3400d84380888806cdbab43f05.jpg	t	10454.jpg
1994	1074	ed1b05890a5e5d43844adfb437e1daf8.jpg	t	30201.jpg
1995	1074	a4cbedca8e14f1932834adc49e9df8c0.jpg	t	30202.jpg
1996	1075	290d3647ebbc58da59809cce8a927869.jpg	t	20654.jpg
1997	1075	4d4e8378c4c93220270dd94794e2e764.jpg	t	20655.jpg
1998	1076	9eb480081afa26ffeefbdac5b12a93f8.jpg	t	20640.jpg
1999	1076	0b453c0ed0cf37d22a8c789fa0553802.jpg	t	20641.jpg
2000	1077	601a95ef8b33ee36627956bd92248663.jpg	t	20658.jpg
2001	1077	1fd000e4a3a759c8f0799da610c4b0ec.jpg	t	20659.jpg
2002	1078	d2c3695cc2464bb62a2f7bfb1816bd01.jpg	t	20642.jpg
2003	1078	895a5ad3baa462cef79e9d883e9a9b01.jpg	t	20643.jpg
2004	1079	8ec778c676fc4eb3ee8955f45446f4a8.jpg	t	20278.jpg
2005	1079	0e3f435632fcae0b3f67a4b0bb9f4b33.jpg	t	20274.jpg
2006	1080	3fcd524f87a827cc9b2a08a9ef5ddb93.jpg	t	20286.jpg
2007	1080	f3fca5c652b296fe3a52f8b1e7252e60.jpg	t	20287.jpg
2008	1081	21ea38c29144480003ce72c888498378.jpg	t	20258.jpg
2009	1081	76eb5366bc9496f34e738e233dd23af6.jpg	t	20259.jpg
2010	1082	0a98ef9596c10a031c322ab90524bbd1.jpg	t	20254.jpg
2011	1082	da8f81aa47ab07d009bf6915d74858e4.jpg	t	20255.jpg
2012	1083	767b9723058b429aa762e52d40803f20.jpg	t	20234.jpg
2013	1083	69d6282174d63c49adf4b1f207411baf.jpg	t	20235.jpg
2014	1084	444be261f2674d15d3b4030bb31374d8.jpg	t	20262.jpg
2015	1084	a5b759a2a814bb6d541a93f0996c452f.jpg	t	20263.jpg
2016	1085	b7bb8ad011f22576dbda4bbe81e076de.jpg	t	20290.jpg
2017	1085	4dad0349b4a27600f70e2e74782e726b.jpg	t	20291.jpg
2018	1086	c093c6a5b2b22a1d34c7a411c9544852.jpg	t	20270.jpg
2019	1086	2de75ece839317fe8956fc5aafff10c1.jpg	t	20271.jpg
2020	1087	19a033c0a77ab2c70cd5a024ec909b36.jpg	t	10366.jpg
2021	1087	2390116a1a75a159ffd91b961da04967.jpg	t	10367.jpg
2022	1088	0e3f435632fcae0b3f67a4b0bb9f4b33.jpg	t	20274.jpg
2023	1088	2a938b0d65aa23f10bb034b2321f7f71.jpg	t	20275.jpg
2024	1089	62e3afc6af324fa14ecae86b4844c8c3.jpg	t	20236.jpg
2025	1089	f2ca95911484301beb56cf8cebb49673.jpg	t	20237.jpg
2026	1090	96e8e70a209138a139d2c374ac764fda.jpg	t	20248.jpg
2027	1090	1b608cf8c3d92e20a06a77031b4fa78f.jpg	t	20249.jpg
2028	1091	8bc31aa4dc925c03ca68ee645f5e51f6.jpg	t	20244.jpg
2029	1091	9b282c8df9a4db2be8a089b67792eb2b.jpg	t	20245.jpg
2030	1092	1c59d5462f8d4c3104788bf74e3eed4b.jpg	t	20282.jpg
2031	1092	ad059783515dd167fb73099e9dbf399a.jpg	t	20283.jpg
2032	1093	dd6b7584807ac7896e249bed7b15cc2a.jpg	t	20266.jpg
2033	1093	080b3b8adeff6291997ba8d4aa6531fa.jpg	t	20267.jpg
2034	1094	c2dc4c8f1d70a1474b763906993f279c.jpg	t	20242.jpg
2035	1094	6b7b2bcaa7dff7f2475d83ae7fde7cf6.jpg	t	20243.jpg
2036	1095	417501b375244df04b8c0e3202531e55.jpg	t	20636.jpg
2037	1095	20df201cdd91ed71a424b0308ca96f7a.jpg	t	20637.jpg
2038	1096	1482dbaece7a9f7980b32fba46d15300.jpg	t	20632.jpg
2039	1096	21e14bd483583c29c3dba8f108a70ddf.jpg	t	20633.jpg
2040	1097	b99c366c13a3a3f7c0dd96fe4af2c337.jpg	t	20226.jpg
2041	1097	d8ed18c5cb988ddba14a7f3cf94dfcf9.jpg	t	20227.jpg
2042	1098	1d5d17230d00d3b6df0b63a9e7d36a45.jpg	t	20646.jpg
2043	1098	942c412d80a3f361a6b897f40b48a934.jpg	t	20647.jpg
2044	1099	1b542f86f62f6c4668dea625cccf27c8.jpg	t	20628.jpg
2045	1099	9f8d121601691c7619d8e1077dccfdf5.jpg	t	20629.jpg
2046	1100	43924f16b3efdb0a40b7e869ff9c3866.jpg	t	20230.jpg
2047	1100	b3b94994cb633c39fca5f370c16c7c04.jpg	t	20231.jpg
2048	1101	2034ca5cd98b574cc0e2e509feace674.jpg	t	20294.jpg
2049	1101	1524b6b2f3b75dbf56a0698d343e630b.jpg	t	20295.jpg
2050	1102	466a09d18f5a43ca71def02842149f1e.jpg	t	20648.jpg
2051	1102	8071597009699c6f4f1c4d7b962805e3.jpg	t	20649.jpg
2052	1103	3d198be6b61f62a9f20ac535d8c6332d.jpg	t	40347.jpg
2053	1103	00bbf6c9c5aa81eae39115b8475cdb5f.jpg	t	40348.jpg
2054	1104	5858cd98711d392e9fc33dd84904088c.jpg	t	40343.jpg
2055	1104	1a50d549d1faaa6d7b59f5019d0fee3a.jpg	t	40344.jpg
2056	1105	9a3d552cae820e2e865a7bc7eb09172c.jpg	t	40305.jpg
2057	1105	f4535282bf5c2d754af66eb952ebf2f8.jpg	t	40306.jpg
2058	1106	a595109a09a074b58d353d9ae68973e2.jpg	t	30486.jpg
2059	1106	222740946394db6563ac5ad98f5399d6.jpg	t	30487.jpg
2060	1107	ee35457107558f458c7bff6762ad85f3.jpg	t	30483.jpg
2061	1107	b62c82e257571ba2af5bd63d725b7b65.jpg	t	30485.jpg
2062	1108	134dc95439bda6651e3de7686c07dd28.jpg	t	40311.jpg
2063	1108	a8be3c2784b1cd3e1daf78f79717476b.jpg	t	40312.jpg
2064	1109	b9e123b169bb414678cfdc1bdf48453e.jpg	t	40387.jpg
2065	1109	38648bb6ddd703bb986d806587b7f373.jpg	t	40388.jpg
2066	1110	cb2888f322f2dfb0ed729bec69ef94a6.jpg	t	40349.jpg
2067	1110	21b46f87b30792ba7e5a2d12561cbc40.jpg	t	40350.jpg
2068	1111	43280b76f0ceabe40f338187c8afc970.jpg	t	40351.jpg
2069	1111	007fed0d1204f861404489a5981d891d.jpg	t	40352.jpg
2070	1112	1551e3160c575c24964d116b65622de3.jpg	t	40389.jpg
2071	1112	7dc465bacc3316e15ed26a1516ee9947.jpg	t	40390.jpg
2072	1113	98a83c1fa208e1632d8ea5e5e1c19424.jpg	t	40361.jpg
2073	1113	d34e3c67a0e3ad0dc8c24875b86d2a57.jpg	t	40362.jpg
2074	1114	aa7e9c992160663c482a3e509b820da3.jpg	t	40359.jpg
2075	1114	0e9a273895f76823db932f54c5666e8a.jpg	t	40360.jpg
2076	1115	a1b2cf19e73a9dc824c107897c803aac.jpg	t	40355.jpg
2077	1115	f28c2e4c84e890771c7099fa4d8b7d8f.jpg	t	40356.jpg
2078	1116	04add28ee64e1977495d55123c073327.jpg	t	40379.jpg
2079	1116	964e18f2697c083e8b80040b9e78d358.jpg	t	40380.jpg
2080	1117	8421b4e8dd0deadf53e4d3d724687182.jpg	t	40319.jpg
2081	1117	c8c36e6bf17745a9303790028069748d.jpg	t	40320.jpg
2082	1118	6d95545aa77f692a3ccee2de6842e32f.jpg	t	40333.jpg
2083	1118	d1622c0085df8cc3a64c8f117e39f521.jpg	t	40334.jpg
2084	1119	bbfc82e94eb576bd2e2f765bdc7054e0.jpg	t	40321.jpg
2085	1119	835296c23fda7e98697c51d8454cd0db.jpg	t	40322.jpg
2086	1120	0277d80101b921ac3ec284ea590c2fcb.jpg	t	40337.jpg
2087	1120	aba6019eb8f4521d2c58b37e1ab4b13d.jpg	t	40338.jpg
2088	1121	7045db1d0dcc922c75b4539dcdfd51ba.jpg	t	40313.jpg
2089	1121	81ae8cf7c772ac897d732a7cc567a63c.jpg	t	40314.jpg
2090	1122	9c7c423693e48983355b5558e3ac001b.jpg	t	40325.jpg
2091	1122	d2c77abf4b9fbcc0c0d42c998c756661.jpg	t	40326.jpg
2092	1123	700b6f6682d7fecb0d459e2de6689e62.jpg	t	40309.jpg
2093	1123	b7160c1803f30de5ca198c9876277a27.jpg	t	40310.jpg
2094	1124	178e9554f2b66d78b9d3192b9d990056.jpg	t	40345.jpg
2095	1124	f96352f40fda5e102e7f674c010303a7.jpg	t	40346.jpg
2096	1125	31539f4a5474d310c5d504813b961ba3.jpg	t	40367.jpg
2097	1125	ea345ca93ea9505268f2637759671fc7.jpg	t	40368.jpg
2098	1126	b96df57886bcbdcdc32534886e3c371d.jpg	t	40245.jpg
2099	1126	2d7592948ad11964e58d463587b70933.jpg	t	40246.jpg
2100	1127	8546aa1f4a53f5bce0b8d496ddc67375.jpg	t	10355.jpg
2101	1127	57058acea75bd32c29a0a5dbfae88285.jpg	t	10356.jpg
2102	1128	d89eb3e0e681f1b60e0465772a2f0909.jpg	t	40383.jpg
2103	1128	5bc2ca03690d559d496b2b9a45b2dcc6.jpg	t	40384.jpg
2104	1129	55078ca8ce5cb0f47010000da94b765a.jpg	t	40373.jpg
2105	1129	2fe94592f6aa7ac326774fa20de7324d.jpg	t	40374.jpg
2106	1130	08e9cfb3818319ed0620e421e17890e6.jpg	t	40371.jpg
2107	1130	db40c1cc0c40c8a65212500d754eb601.jpg	t	40372.jpg
2108	1131	9542716a3d2ed3ac16b02889b857c04d.jpg	t	10688.jpg
2109	1131	77a740b630ec010b1a11279941eebb3c.jpg	t	10689.jpg
2110	1132	ca01257595d308457d14b4eefab2dcaa.jpg	t	10684.jpg
2111	1132	a304d84b8984de3a8573eeb91e0c246f.jpg	t	10685.jpg
2112	1133	48937549516ce56009c6717a90b63c39.jpg	t	10664.jpg
2113	1133	49cb6f465c3e4ae187fb0d2371625846.jpg	t	10665.jpg
2114	1134	9dda7b423455e8dad51c7f9b3f849f5c.jpg	t	10298.jpg
2115	1134	5feb937278610d334963187006bccabe.jpg	t	10299.jpg
2116	1135	1308c38f9450b38d4f8872210dd57b66.jpg	t	10374.jpg
2117	1135	822120d3f1ef22be8f871b79f9a86c90.jpg	t	10375.jpg
2118	1136	ab48f14290c9ef2165e6623a944adad7.jpg	t	10395.jpg
2119	1136	f1a999cc60a03b35b489b8f7c213a346.jpg	t	10396.jpg
2120	1137	0e4de9db5c2e0df791042a81305e440f.jpg	t	10349.jpg
2121	1137	519162780123df60384e5c2ccbe7d144.jpg	t	10350.jpg
2122	1138	3dc9e9aeed7d813bb6aa06d3cc7b08e5.jpg	t	10389.jpg
2123	1138	48c96e294ef1b424635aa44939842932.jpg	t	10390.jpg
2124	1139	e15993b12814afe4064140fe92972a04.jpg	t	10341.jpg
2125	1139	0e04919fb3e533bdfee3569a36d5e8bb.jpg	t	10342.jpg
2126	1140	f2ae0eb5228296013a59ee080ee8cac8.jpg	t	10674.jpg
2127	1140	409f8ca897859807275f9a60c79b4d5a.jpg	t	10675.jpg
2128	1141	e4da07572b8b1f816126de1d456abcff.jpg	t	10377.jpg
2129	1141	501a989bb9705ce983e0e15486a274a2.jpg	t	10378.jpg
2130	1142	8bf3b4e1fa5271bf27981c0efe825bac.jpg	t	10680.jpg
2131	1142	3ff332d1260edb1fe8ad88761124e2e8.jpg	t	10681.jpg
2132	1143	1b0073e4e5c5e775f7b04d290d9c7a2c.jpg	t	10672.jpg
2133	1143	104980a21f681d04090f9ee24f6c086d.jpg	t	10673.jpg
2134	1144	225957b671c40c3ef170a2d6734d5ca3.jpg	t	10384.jpg
2135	1144	9acc7c783f6da48a6310e0d3ce14b914.jpg	t	10385.jpg
2136	1145	f629aa959bcb78cffdaf90f44520629c.jpg	t	10668.jpg
2137	1145	5e9ca7c70e95d215e8cd47b780e938fc.jpg	t	10669.jpg
2138	1146	b3f2f1e56c7bcb7047fa50b23a6c4005.jpg	t	10380.jpg
2139	1146	9a4149acbaec24c4ce2d494c4544a8b4.jpg	t	10381.jpg
2140	1147	0f7ef4c3d8e4fa54c9d9d4731b4fe2c6.jpg	t	10351.jpg
2141	1147	84a46e3cca2447fc5107487e0d2d0af6.jpg	t	10352.jpg
2142	1148	a713360556e7c4676c5fa65075fb13ec.jpg	t	10405.jpg
2143	1148	029b036ea620af658e1958c64fad4376.jpg	t	10406.jpg
2144	1149	cecaa99ef3bbca30a4e91338e880e631.jpg	t	10399.jpg
2145	1149	3619765130c4fec7a72e2a85946044ab.jpg	t	10400.jpg
2146	1150	5797a1b5a76f0cf368c96302f279d19f.jpg	t	10357.jpg
2147	1150	00f3c34261bfa3c2f1aeaa4a1e978ce6.jpg	t	10358.jpg
2148	1151	5c11f28da2fc8d38811822695ebbdb42.jpg	t	10686.jpg
2149	1151	77a740b630ec010b1a11279941eebb3c.jpg	t	10689.jpg
2150	1152	9bba4d43f2ec3a51a94a30b22c4ac187.jpg	t	10359.jpg
2151	1152	3a94e66a7b8c9049f5c4e3f08d8e635b.jpg	t	10360.jpg
2152	1153	48a27ff67f3f14be27e48c8fc2d197cf.jpg	t	20895.jpg
2153	1153	8d569f4ee5e74fac60a004c595b3a1dd.jpg	t	20896.jpg
2154	1154	6e4e701fccf244242c793451433debed.jpg	t	20887.jpg
2155	1154	be4e808479405571db46858863a9be9f.jpg	t	20888.jpg
2156	1155	6e10ed35cface92f0a75b520dc472f26.jpg	t	20885.jpg
2157	1155	7cad19bc70615334a6c9b9c9cdb44b1c.jpg	t	20886.jpg
2158	1156	e9dd48a44567d8ebfede9f83c3cf9912.jpg	t	20865.jpg
2159	1156	cf032a8d79e02c03c191f84d7a39ee93.jpg	t	20866.jpg
2160	1157	13011561ea546a8020fd36882e42ce7a.jpg	t	20905.jpg
2161	1157	4ba283f5fee2be0f1b87ea86b683296e.jpg	t	20906.jpg
2162	1158	ad6f28d0058256b0afac579da745cc62.jpg	t	20907.jpg
2163	1158	50834c1a3a26d0bbd08db77cc5fa8d47.jpg	t	20908.jpg
2164	1159	15143e9a89c1a77c51e13f85779b8dbf.jpg	t	20801.jpg
2165	1159	4ee5cb48c2724060cb276161c36c02e8.jpg	t	20802.jpg
2166	1160	b24f81cd6a4a62603440588a36753fe1.jpg	t	20883.jpg
2167	1160	742ae15c1ae8f453d8147af4594c568f.jpg	t	20884.jpg
2168	1161	41d3176f4db769258f950c35eb1f8f0c.jpg	t	11272.jpg
2169	1161	a984f9a9e41734a630d50fcb8547064b.jpg	t	11273.jpg
2170	1162	c2ebe91f7a55e290b70b2d8da7af9ab1.jpg	t	11250.jpg
2171	1162	89290245029915dc6919370628d4dbb9.jpg	t	11251.jpg
2172	1163	a77eb3a113ed1c542c8e7cdf35340975.jpg	t	11232.jpg
2173	1163	66d50a6a5829be391cf415c847e610b7.jpg	t	11233.jpg
2174	1163	7c8f5687876882cdecbac8bcafb43dac.jpg	t	11234.jpg
2175	1164	97275d80839a215739da13ece38d6342.jpg	t	11244.jpg
2176	1164	0ac5637f3917293a1192e2ab600ceec4.jpg	t	11245.jpg
2177	1165	593d869a32ebd75a24b29d03c63ad6cf.jpg	t	11259.jpg
2178	1165	da5d32733b2e30b8cae7ddaf220b3e82.jpg	t	11260.jpg
2179	1165	110f511ec2eff4e0a6c954de41491c2c.jpg	t	11261.jpg
2180	1166	6f6f68bbceaa9ed2167e960a4d7a83b4.jpg	t	11237.jpg
2181	1166	96ef82acaba9d71c6354ea6bbeb19fdf.jpg	t	11238.jpg
2182	1166	aa957f7971818d2f4815c0ead1e4fd88.jpg	t	11239.jpg
2183	1167	22a0dd1e75847d487867ce7311b8b6ae.jpg	t	11246.jpg
2184	1167	0e7d83f8a673ef9a9fdf43433a35dbdc.jpg	t	11247.jpg
2185	1168	107e8f25ef4cdee6639f1cedbc271d94.jpg	t	11268.jpg
2186	1168	9370ea567f05b2f92772c4fd72acb0f1.jpg	t	11269.jpg
2187	1169	c60390ad81e7a0e8108f641e970b9dbe.jpg	t	11264.jpg
2188	1169	cfa3890a59bbe22f948fef5e9d2123c8.jpg	t	11265.jpg
2189	1170	18bdf236c852e08930a3e89c679ae62e.jpg	t	20871.jpg
2190	1170	99673b9b55a4a1a523b45b3b0502d746.jpg	t	20872.jpg
2191	1171	26b2e97b7b89ac8e992c0062fc5bced0.jpg	t	20889.jpg
2192	1171	3133668bcfeb33ef8b96d20cc75881f9.jpg	t	20890.jpg
2193	1172	76c23ef3c2566fefc4b166cd5432a9c1.jpg	t	10123.jpg
2194	1172	80556a8bb98d0ae4c916ec43b604ef64.jpg	t	10124.jpg
2195	1173	7bf224701d3ab79aedf9b3075751c029.jpg	t	20568.jpg
2196	1173	457d38766e32a4423cd66e707ad3bb84.jpg	t	20569.jpg
2197	1174	51f0b7a8e3f34e1df258c3c9cbbaae27.jpg	t	11138.jpg
2198	1174	4b2dff1a5b549227b56afa3966b71bf5.jpg	t	11139.jpg
2199	1175	9ea6ce43ef07ebadc7ce179b9e221269.jpg	t	11170.jpg
2200	1175	77529ff646ca325e74034e914321d384.jpg	t	11171.jpg
2201	1175	f4df91324cf471edfa2e544d3a957112.jpg	t	11172.jpg
2202	1176	e84205b30a535d95990834d7e3dedc80.jpg	t	40303.jpg
2203	1176	eea845d9d92618c9929f45d93f4f46be.jpg	t	40304.jpg
2204	1177	84d2ae27442890ba6b1df98d4b178f81.jpg	t	40301.jpg
2205	1177	bf5ecd1fcdd0e5936d6144a01da54ede.jpg	t	40302.jpg
2206	1178	24c93e15072238bf163731265df6e089.jpg	t	40375.jpg
2207	1178	fa2ed4debb953b617d1e66115bd19e9e.jpg	t	40376.jpg
2208	1179	1eb14749cc503e3e98a456564e5aaf92.jpg	t	40365.jpg
2209	1179	ff2c880c51aaadc79cd8aabb9492f158.jpg	t	40366.jpg
2210	1180	63e789c0e40accbb961c6d4ef2283ef5.jpg	t	40353.jpg
2211	1180	1f189ead354edf4f17067129b6218fa0.jpg	t	40354.jpg
2212	1181	0921b4cf47a98e935258c1223207a16b.jpg	t	40249.jpg
2213	1181	6829bdcf1e9357f2b9ae71302f3f7b74.jpg	t	40250.jpg
2214	1182	cb7f5871d2fcce01f1163baf65810f2e.jpg	t	40377.jpg
2215	1182	4859d2f7b8d67f73784640c1a67743a2.jpg	t	40378.jpg
2216	1183	f37c1acb19655234089f43126d433880.jpg	t	40255.jpg
2217	1183	e89cd368408834b23281239b745ae9ca.jpg	t	40256.jpg
2218	1184	78160074f2a88ba89f878e87c40de1c6.jpg	t	40247.jpg
2219	1184	c420e4f14c7f76de04d9181b9cbc60e9.jpg	t	40248.jpg
2220	1185	a9115968cbc23312728df141c28a117c.jpg	t	40251.jpg
2221	1185	f247fd362ee16e9fdfc32c4c4b958883.jpg	t	40252.jpg
2222	1186	38ca7669029e3401af204e524989576d.jpg	t	40357.jpg
2223	1186	fd92fa3dbe862d6d34ff93456164dd87.jpg	t	40358.jpg
2224	1187	685e5957686bead5957147269e4623ba.jpg	t	40381.jpg
2225	1187	0ca73b5d61d457b70f10ef245a58871c.jpg	t	40382.jpg
2226	1188	03dfba899594ce04c4a9b29a8cb30b6b.jpg	t	40385.jpg
2227	1188	a6a28dc43e69bfa7ab607f222fbd8da4.jpg	t	40386.jpg
2228	1189	d507768d16cd268334bf87ffeabc198a.jpg	t	40363.jpg
2229	1189	7c22c04f56fc9b71567dcbb24f91db3f.jpg	t	40364.jpg
2230	1190	65abf2a78e91720649c8d4f9f8a83d4e.jpg	t	40297.jpg
2231	1190	e5f9d57ddca0c6a2724e37932155f268.jpg	t	40299.jpg
2232	1191	757ce0e883b28f8d05a9404fd0944847.jpg	t	30525.jpg
2233	1191	69e9bb2b2727b81faca40e4b23907914.jpg	t	30528.jpg
2234	1192	28cc9e90ce4b08edaa482e8f244e0992.jpg	t	30529.jpg
2235	1192	dfec42de119b95d5521192652d42eb14.jpg	t	30530.jpg
2236	1193	74bc711e94a9b27a440c90ba66ff73d8.jpg	t	30682.jpg
2237	1193	3b4322f4e1714a934e629fe68e32864f.jpg	t	30683.jpg
2238	1194	80ef68721e0ade4a07afcfa12c00509d.jpg	t	30686.jpg
2239	1194	7532469ad3d35516bba45691ffc21aef.jpg	t	30687.jpg
2240	1195	16c27bf0498b6a41dbe1e86456e99bc2.jpg	t	30734.jpg
2241	1195	d1157fbba7438e300faa11588b7fa204.jpg	t	30735.jpg
2242	1196	111124aacbd12a9defe5f049d4a7ca19.jpg	t	30680.jpg
2243	1196	745103e117f273526918efaeb4901f6d.jpg	t	30681.jpg
2244	1197	38e18b789058279000a73c34d5a0026a.jpg	t	21087.jpg
2245	1197	137e24f298b81a77345867794b50474a.jpg	t	21088.jpg
2246	1198	30582d8eefdea6cc2f77fc2672865479.jpg	t	21083.jpg
2247	1198	c599f0b1e0a64ddefa083fcc1640fc3f.jpg	t	21084.jpg
2248	1199	e7bcadcd8dcaa16508266e104e89e030.jpg	t	40220.jpg
2249	1199	66c2ef7e0eaffdc0b862bc7916656287.jpg	t	40221.jpg
2250	1200	5a02cc1638198686963aee1abfc40d71.jpg	t	40231.jpg
2251	1200	7c08782c9d87b0f7ec48fc25f68a15bc.jpg	t	40232.jpg
2252	1201	b779ff8e7a5342f0782c3662a14441f2.jpg	t	21194.jpg
2253	1201	e1c49b2392481fe02e825f9745f0f270.jpg	t	21195.jpg
2254	1202	8a179970fc20ebb588fc481fa2d79948.jpg	t	40235.jpg
2255	1202	7fce274df97aee9b87a4253d0b6308e1.jpg	t	40236.jpg
2256	1203	ecde85a6b1d5264a7b7f4b6337117691.jpg	t	21208.jpg
2257	1203	414ccf9750e280568beecf44cfcf9e1d.jpg	t	21209.jpg
2258	1204	f633e49ee5db7ca87feb1a5ea1023b77.jpg	t	21089.jpg
2259	1204	af70f7bc0116176279337bba48c5bf7b.jpg	t	21090.jpg
2260	1205	0559ca37c3bb4ac690ec9fa79a7da645.jpg	t	21204.jpg
2261	1205	21376b89ce421632ac5751db0c2ef0bf.jpg	t	21205.jpg
2262	1206	984e47b3a66e9ae4b4703888361cf30d.jpg	t	21097.jpg
2263	1206	7c62d02398ba6e3b894b61f8547b19dd.jpg	t	21098.jpg
2264	1207	5a02cc1638198686963aee1abfc40d71.jpg	t	40231.jpg
2265	1207	7c08782c9d87b0f7ec48fc25f68a15bc.jpg	t	40232.jpg
2266	1208	203a358474635b902ba98d43025867da.jpg	t	40293.jpg
2267	1208	42852dfafc09f27d303358707b6c0766.jpg	t	40294.jpg
2268	1209	78160074f2a88ba89f878e87c40de1c6.jpg	t	40247.jpg
2269	1209	c420e4f14c7f76de04d9181b9cbc60e9.jpg	t	40248.jpg
2270	1210	cd1bb03c31ad09dc00e0edf9a541839c.jpg	t	21210.jpg
2271	1210	09e53d47e321785880fb6c1ae46620a6.jpg	t	21211.jpg
2272	1211	a99fe2054079ca73b85cd840652b4a20.jpg	t	21186.jpg
2273	1211	fbf07e8df49359b848761c04fa9ab421.jpg	t	21187.jpg
2274	1212	885589d30165e5fd24cb81357efbb14f.jpg	t	21200.jpg
2275	1212	c9e038a29c3819bd5b14e75072afedcd.jpg	t	21201.jpg
2276	1213	927da482bc50016e4ae19f5e366bd731.jpg	t	21188.jpg
2277	1213	f8b84b90023702babb32f4c923bc98f6.jpg	t	21189.jpg
2278	1214	ecec2b989643fd932cf4f88ff0c731d6.jpg	t	10103.jpg
2279	1214	e7ffa0795c553c01e7350c4db75309f9.jpg	t	10105.jpg
2280	1215	7ef46d64f008099013ab1e6b1204a903.jpg	t	11213.jpg
2281	1215	6233924b6d2e60f41b901277118e8115.jpg	t	11214.jpg
2282	1216	6e22f0caf031b8a76c1b6fd2e7a1d2b9.jpg	t	11177.jpg
2283	1216	86be8fa30927e89acf10fe81b67f4c72.jpg	t	11178.jpg
2284	1216	646a6a74d1c88c7caf23f2d0bef2b564.jpg	t	11179.jpg
2285	1217	d7ecd30957e59854873b4bd22632bdf1.jpg	t	11198.jpg
2286	1217	46a39af23d0eebdd887fa17574d194d8.jpg	t	11199.jpg
2287	1218	63d249969e35698120643c3374a2e1d2.jpg	t	10110.jpg
2288	1218	8c6ce1e3234da320fd08a92cd3b83e8d.jpg	t	10111.jpg
2289	1219	0ad1810c5b57c5092825081b82df56fd.jpg	t	10136.jpg
2290	1219	fa391b9ac49aa506e5f1a28ada3421b8.jpg	t	10137.jpg
2291	1220	c3b0c80326b5b36134f30302afe58843.jpg	t	10144.jpg
2292	1220	551e427f14d6f09a06bdab125033e55c.jpg	t	10145.jpg
2293	1221	9d70b3a42512b50fb7bf951fa66521c9.jpg	t	11186.jpg
2294	1221	586176e2788a5e48d33708bf29147445.jpg	t	11187.jpg
2295	1221	f4efb225a08580303db7133bb59572e3.jpg	t	11188.jpg
2296	1222	e3a5bcf076a424218a098686a6d7655d.jpg	t	10097.jpg
2297	1222	b291bd4d71b1752e988bfd6f9c7b7efb.jpg	t	10098.jpg
2298	1223	9b31f103e1dd75ecd7b42545943c8f3c.jpg	t	11221.jpg
2299	1223	9e2d0a2e77756bf8cf14ab36b1e521f9.jpg	t	11222.jpg
2300	1224	df454c47a2b926b418f9bf724e0f2d5d.jpg	t	10117.jpg
2301	1224	b012dec882dcb7a516dddd8421546df9.jpg	t	10118.jpg
2302	1225	9aa63f02257c22ef7f921fb6c1e8bed7.jpg	t	10545.jpg
2303	1225	034a26a991c238d0266fe63536159765.jpg	t	10546.jpg
2304	1226	3c5255919c6aeeb35b86843deace3d9b.jpg	t	10106.jpg
2305	1226	6196937cc60cd8f933da433bbc136dbf.jpg	t	10107.jpg
2306	1227	3879759a7ba09d0bc20d685a6e02c878.jpg	t	11254.jpg
2307	1227	7fd37107f21c62b46076dac72d6d219d.jpg	t	11255.jpg
2308	1227	6fe50ed5e3945ef9f5479655b5c8eb27.jpg	t	11256.jpg
2309	1228	c46d4055a34f1fc14eac3b521d6da2e3.jpg	t	10119.jpg
2310	1228	d7373cd02e2497dd31d29a4f2a8d3223.jpg	t	10120.jpg
2311	1229	d2bd5f5083816d6a5d54368eb99c94ee.jpg	t	10132.jpg
2312	1229	bff717428e0f3ebe152b33f731d5bf2f.jpg	t	10133.jpg
2313	1230	c05f8d8564ecaa71b5fee72cbe8aadb5.jpg	t	11192.jpg
2314	1230	277d50eb12d1be3850b8797376efca3d.jpg	t	11193.jpg
2315	1231	c48543fe3aec0e6e0740bfc9344d34ef.jpg	t	11206.jpg
2316	1231	b0b34b66567c5535aacb5272d5464abb.jpg	t	11207.jpg
2317	1232	af3625022450554b7933b8f789071259.jpg	t	11182.jpg
2318	1232	69524818c19752bb3ffc7133009b93ed.jpg	t	11183.jpg
2319	1233	d5ead35ed03dde39b6b1db49f01919a8.jpg	t	11227.jpg
2320	1233	cb97311ee823761cd7ca4035077b1318.jpg	t	11228.jpg
2321	1233	da3c505ba2f1e3bcbc291b3f10467bcc.jpg	t	11229.jpg
2322	1234	8660a18c85510bf018dd3889d4d088ae.jpg	t	10127.jpg
2323	1234	57a819f6b5b4500cdb028e208206f876.jpg	t	10128.jpg
2324	1235	1195d792ccc6d07a858f55ceeee3b20b.jpg	t	11211.jpg
2325	1235	6d7fd6c56b44c34b2d23711a4a22cb07.jpg	t	11212.jpg
2326	1236	9d9be70fde5684f907c5f6eea6219e1c.jpg	t	11197.jpg
2327	1236	580f76de2d4a97d49e82e2cf3db27033.jpg	t	11196.jpg
2328	1237	e9e1f7f594551b8bb4364a5f72a0ab7d.jpg	t	20612.jpg
2329	1237	c5aefba4213159b54991e1118e7131fc.jpg	t	20613.jpg
2330	1238	6c1baebed28c597b57a40f13bed9ef38.jpg	t	20579.jpg
2331	1238	6c1baebed28c597b57a40f13bed9ef38.jpg	t	20579.jpg
2332	1239	2043e2f0a6a12269b3ec9f7a03670edd.jpg	t	20570.jpg
2333	1239	bb77d46aaa8efe7024a4ac46a2f6f815.jpg	t	20571.jpg
2334	1240	0930cf49d0ecc1196a62a90711d2104e.jpg	t	20622.jpg
2335	1240	d01889cbc0972f691c9453707badb036.jpg	t	20623.jpg
2336	1241	55552cea98513320c287b24188817d4b.jpg	t	20606.jpg
2337	1241	dc79f15917e92b04a962810581417817.jpg	t	20607.jpg
2338	1242	b72762693c5b4ea8cfac8f44c19376e8.jpg	t	20614.jpg
2339	1242	ab4ac9392b29ec9387948a9cea8a4155.jpg	t	20615.jpg
2340	1243	0e985417c0a23bdc962cc917a43cc363.jpg	t	20596.jpg
2341	1243	22a9b8bca2c896215100290cebc45e5f.jpg	t	20597.jpg
2342	1244	0a3ffa49202b59ceedabf2474e428187.jpg	t	20604.jpg
2343	1244	14022536bcbbb7279068e2cb1a41a5c3.jpg	t	20605.jpg
2344	1245	3ad4ddc07b40ddf5236b1b20d1662e34.jpg	t	20588.jpg
2345	1245	d9dad7c47b7a18f632ad8da16b8e0226.jpg	t	20589.jpg
2346	1246	be85ef1d0f345a6b2215160e00af90e1.jpg	t	10477.jpg
2347	1246	2794a9f366fb66c163797eca439fb475.jpg	t	10478.jpg
2348	1247	bbcb9393ed4c4aefd44bce97e73ef7a2.jpg	t	20592.jpg
2349	1247	9fa12da9033c8b8e44466a51d8eab70a.jpg	t	20593.jpg
2350	1248	80217315ef44f792fca6da9acbf03841.jpg	t	20598.jpg
2351	1248	41e945166506d9bfc8a67a5369c51dae.jpg	t	20599.jpg
2352	1249	3971f85fb36290d17f281291ec256fd6.jpg	t	10071.jpg
2353	1249	3ae1ed4277c5d9d951ccb62e07b3c0a4.jpg	t	10072.jpg
2354	1250	280087b16fbc3da1d43c1f93487201f5.jpg	t	10079.jpg
2355	1250	70cdcc6fcd5299beb4eaa338e7aadde7.jpg	t	10080.jpg
2356	1251	de388a61f7d98d691e26eba44613d56d.jpg	t	10089.jpg
2357	1251	2bc75e5e0441ec2dede5109d72f4de6d.jpg	t	10090.jpg
2358	1252	41e34495cb8ca6105ebc8f0ca8131855.jpg	t	10085.jpg
2359	1252	e8ee0e73f33bafea98e304c3f1cb490f.jpg	t	10086.jpg
2360	1253	fa22c159e96f474684984c38d4068712.jpg	t	10095.jpg
2361	1253	58be844e3ab91405a9cd514c2ebf5d1d.jpg	t	10096.jpg
2362	1254	35e273093f6ab5580ddb9519d7be4ad6.jpg	t	10146.jpg
2363	1254	2e4972f40443b98cf3c7456d75883b35.jpg	t	10147.jpg
2364	1255	03825852523ddf57d884202524bf8c63.jpg	t	10061.jpg
2365	1255	8d5ca0b231d385b9330ec70cc1f6de1e.jpg	t	10062.jpg
2366	1256	7405b38de84e9fe8de6fbd5e0de37da5.jpg	t	10075.jpg
2367	1256	16f22b41503f0c44cbf16b38c50481e0.jpg	t	10076.jpg
2368	1257	9c725ea3734e435dc8d4fd21669ce667.jpg	t	10067.jpg
2369	1257	89cfb123a0eced894c0f9c410449bb3f.jpg	t	10068.jpg
2370	1258	cebb62f6f6380856f00408aaf4835647.jpg	t	10083.jpg
2371	1258	f6728a5be5512422fbee425160d11f07.jpg	t	10084.jpg
2372	1259	1eb2c93fbd7960d63b5c0d4cc7eb34e0.jpg	t	30545.jpg
2373	1259	32aa89042bcd2dc51ede4d2ac17d312d.jpg	t	30546.jpg
2374	1260	9d0fb4f5c0225fa1a2bfec4cb435f45b.jpg	t	30547.jpg
2375	1260	3909edb2f1aa41f8a1287a22dfd76f8a.jpg	t	30548.jpg
2376	1261	7dc283a5270d42d5bcb26273d01fd239.jpg	t	30551.jpg
2377	1261	865b7501768aedd56c4de8435989b1fd.jpg	t	30552.jpg
2378	1262	35be5e8a992d917f4f52ad9e97246c71.jpg	t	30531.jpg
2379	1262	644dcc95cad56790cd39fe0fa1ccfd55.jpg	t	30532.jpg
2380	1263	e4a99881d46c0415dc09308adff5be22.jpg	t	30676.jpg
2381	1263	c5b7b7019e44d791b98827cf31fa2b1d.jpg	t	30677.jpg
2382	1264	60e87e377b6be2f0715f5dcdffab18f8.jpg	t	30561.jpg
2383	1264	0dd2c1c074b149d8e7f7edde21c3db44.jpg	t	30562.jpg
2384	1265	fbda51cb42cd13ef536dedfbfcc03b4e.jpg	t	30563.jpg
2385	1265	6ea61b813a52e6aa06c3ea658329c4cd.jpg	t	30564.jpg
2386	1266	aa831fd880d33392fbe8b2becab80df7.jpg	t	30535.jpg
2387	1266	ab51af40c899857921dd9b33f6eab099.jpg	t	30536.jpg
2388	1267	1ba57b5a1f7a492f33eb750634a8d953.jpg	t	30541.jpg
2389	1267	0c676bcaed7ef810df17004434de7bbf.jpg	t	30542.jpg
2390	1268	7c8618833cd996e48adcd846f1024b8a.jpg	t	30539.jpg
2391	1268	6f2ead8d147dfe8839912ebe6bc08837.jpg	t	30540.jpg
2392	1269	fd4f5011cc62fe87e544e5a74fd18d97.jpg	t	30557.jpg
2393	1269	25c28fbed31182463ed52b16a9719079.jpg	t	30558.jpg
2394	1270	637add8f47057aad84992d4731aa70fc.jpg	t	30674.jpg
2395	1270	46b0c6e30e8f394b018a81a7d0618d25.jpg	t	30675.jpg
2396	1271	5808a2ba3232453c3ede30a756aeb71d.jpg	t	20518.jpg
2397	1271	9d47564a96a0691009c13f1d363a9941.jpg	t	20519.jpg
2398	1272	cb71da614f9dfcedde5f43ff7ba28fae.jpg	t	10535.jpg
2399	1272	0819857fe48b6375fece05cd65a32bc3.jpg	t	10536.jpg
2400	1273	62b3924715aa4fd2c349dc1eaf00ae7e.jpg	t	10553.jpg
2401	1273	e27ef55bcf78336edb87d2e98cac8a90.jpg	t	10554.jpg
2402	1274	5919f3f42633aa5177936dcfc04dc3b0.jpg	t	10537.jpg
2403	1274	d63b2a26c12c91b72ea5ab346e416001.jpg	t	10538.jpg
2404	1275	09f9bdffa07dd3c0965f2e8294edb6a1.jpg	t	10541.jpg
2405	1275	ee9ea2c0a82514d2e0b909849e129ae1.jpg	t	10542.jpg
2406	1276	8ad41c97ab30fe47f29cc4370bae401b.jpg	t	21057.jpg
2407	1276	8fbab2878eacc278593bfeade6c22569.jpg	t	21058.jpg
2408	1277	8695f7d9793f55f1d78722a0bddf538c.jpg	t	21069.jpg
2409	1277	6e625b03788d00d89f4f49d45fd2fdc5.jpg	t	21070.jpg
2410	1278	557c3293b089fb3969d5053935ecbe72.jpg	t	21073.jpg
2411	1278	f62c91eb0ca651ed3bee955bfb090e21.jpg	t	21074.jpg
2412	1279	d52de7bccfa7b7649fa93c1210fb2e9c.jpg	t	21051.jpg
2413	1279	89873d0c408267db051f42edacdd15a6.jpg	t	21052.jpg
2414	1280	b3d511fa204272502e8461b0fa97680c.jpg	t	21043.jpg
2415	1280	ce858020884b21c783d48d35664a23f2.jpg	t	21044.jpg
2416	1281	9030de4b15017dc4650f61c704142959.jpg	t	21065.jpg
2417	1281	0b208604c819c37c574574b40727b7d4.jpg	t	21066.jpg
2418	1282	8415c553c0fe2dfd5b9468054a66b091.jpg	t	21079.jpg
2419	1282	e960acfea025d74f79c7d8d42a3064ab.jpg	t	21080.jpg
2420	1283	388aa2a53548e2c17f8fccbd09f650a9.jpg	t	10507.jpg
2421	1283	f40aaea4803205bf406df0e995ed78d5.jpg	t	10508.jpg
2422	1284	bf74605e02f0a76ee2b678892cda6190.jpg	t	10494.jpg
2423	1284	6f7cbde2d6e843ab34602ae0d60a7c34.jpg	t	10495.jpg
2424	1285	ed9c2e31c1b3edf30365c48f8a410e0f.jpg	t	10325.jpg
2425	1285	a58e51725cf19c058fe2b3fc36f150b0.jpg	t	10326.jpg
2426	1286	07001e554dd55f663f9df038274de574.jpg	t	10509.jpg
2427	1286	16f61d3f475cdd6cab188ba980190a9c.jpg	t	10510.jpg
2428	1287	4280579b21b69298e45cd71d252e1741.jpg	t	10483.jpg
2429	1287	59f22379faf2995ccbc566adfc6d8a86.jpg	t	10484.jpg
2430	1288	05f7171659f3156246842ee0a5e9661d.jpg	t	10500.jpg
2431	1288	e494479c9fba942cb30ff8b71a43a630.jpg	t	10501.jpg
2432	1289	ab48dc13cb3000bc9506aec2445dda5e.jpg	t	10529.jpg
2433	1290	3091e7dcb3c8e6868ecbbd7b337afcf5.jpg	t	10230.jpg
2434	1291	d6d241899011d1e653d7bafb590fac73.jpg	t	10517.jpg
2435	1291	990d98d5958da64c396b0dcaba13dd9b.jpg	t	10520.jpg
2436	1292	2947f4596ba9191108e4e358e7a35dce.jpg	t	10521.jpg
2437	1292	36335ef36fb76769ae3ffa03b418df2e.jpg	t	10522.jpg
2438	1293	3a0e57bb51736b72134c68214a2d2bb3.jpg	t	10496.jpg
2439	1293	55f4a7b458bef2e7c374b94309e7132e.jpg	t	10497.jpg
2440	1294	51b937acd488759c8e2e0fe08e3a7a8e.jpg	t	10479.jpg
2441	1294	4229fa98e042a35bfd3babccd3c53f8b.jpg	t	10480.jpg
2442	1295	401d7babe9d211c0f8afd4ede46a3cf3.jpg	t	10794.jpg
2443	1295	bd238552c2d486220cd2a264b5542b4e.jpg	t	10795.jpg
2444	1296	e24cffddab6c061119991bc4409a175c.jpg	t	30284.jpg
2445	1296	b173a8dbd9907555659b6008b403efe1.jpg	t	30285.jpg
2446	1297	16e72293d4349cabfec2db3344ca3d61.jpg	t	10801.jpg
2447	1297	2f7db7a9c7c5be7513d5992f009e6041.jpg	t	10802.jpg
2448	1298	4bce5261e3e9fde1860b32290b252fe7.jpg	t	10750.jpg
2449	1298	11ef7ad14432b4a7dd94cf04c7239014.jpg	t	10751.jpg
2450	1299	156f863b1af6954fb99db5f42cabca45.jpg	t	10776.jpg
2451	1299	5c7eaa7710b12a6ef43051c700e3089e.jpg	t	10777.jpg
2452	1300	385bc0976602a71441a65d0c2c6feb2d.jpg	t	30304.jpg
2453	1300	cb991b12273287a2471c3dac30cc3a75.jpg	t	30305.jpg
2454	1300	438738cdf2e6ff252ae6659910962ce7.jpg	t	30306.jpg
2455	1301	a90212641ba5b8aee415da22ae88e9e4.jpg	t	10766.jpg
2456	1301	4cf29c00fd8391f5ae89c3a016929018.jpg	t	10767.jpg
2457	1302	b823d219be24a3d9fdb576d18fa1264f.jpg	t	30286.jpg
2458	1302	af6b29f4c308ec5bf2e4d0b4459a4471.jpg	t	30287.jpg
2459	1303	574d465de7401357f5c834ab6c4487b1.jpg	t	20620.jpg
2460	1303	4b3325e2d29ebe460e97389bc02fa6b0.jpg	t	20621.jpg
2461	1304	035c1b8a981aceafc16ac984364254c4.jpg	t	30280.jpg
2462	1304	2164fbd5a7506ac802ef1b93711742af.jpg	t	30281.jpg
2463	1305	59f22379faf2995ccbc566adfc6d8a86.jpg	t	10484.jpg
2464	1305	5a56e8f7c3c5dd7c84df917b9bc85174.jpg	t	10485.jpg
2465	1306	4e92128540083bac10ea5e5f897c3ddc.jpg	t	10770.jpg
2466	1306	a3524d5689c8c3828705a0e1b053dee7.jpg	t	10771.jpg
2467	1307	5dbaefeca139a68ea0ead6e8aeb86fd0.jpg	t	10462.jpg
2468	1307	46173b3c4ae5b4d9b77f59cbcf9b74b6.jpg	t	10463.jpg
2469	1308	8170c8cd8b05a101c63a75d007151a70.jpg	t	10782.jpg
2470	1308	996834da1d26d3095074ceb82dc6cbb9.jpg	t	10783.jpg
2471	1309	d16b1025adc39b04eb632beaa9ac13a4.jpg	t	10746.jpg
2472	1309	d7cde00a7d02fe44c4ab1c55421766c0.jpg	t	10747.jpg
2473	1310	6b525e95ad7241a72edb0026433d9746.jpg	t	10754.jpg
2474	1310	ee547d66ebe79fbb70450613940fcc6f.jpg	t	10755.jpg
2475	1311	5b4daaceb405ac2b8fd269fcc8c2932a.jpg	t	10788.jpg
2476	1311	58cf95c98e16875fc0298e853b33bfc1.jpg	t	10789.jpg
2477	1312	3d2aa72c16bf632e3010c3d0ce599b77.jpg	t	30300.jpg
2478	1312	e893c280ce4e2005dcc330daedd3c56e.jpg	t	30301.jpg
2479	1313	8867095ae83050f7dcaa46aca6d1cfd5.jpg	t	30309.jpg
2480	1313	3580553d56ac50c3afe943b0562ff237.jpg	t	30310.jpg
2481	1314	045e40d5b5db83f0a11583b706046b63.jpg	t	10774.jpg
2482	1314	52f88262068f77a10427671e4c55b128.jpg	t	10775.jpg
2483	1315	0ae733dc556f13bd5d4054931f26fa77.jpg	t	30294.jpg
2484	1315	d20173f78ef45a2f5672b3871c32d78e.jpg	t	30295.jpg
2485	1316	f55e091555b66e5cc08472ef289d48ed.jpg	t	30290.jpg
2486	1316	de1b45f8633cbd1ed1579e93b03dee14.jpg	t	30291.jpg
2487	1317	d0c7230716a8d14dbb6796acc33ade63.jpg	t	10758.jpg
2488	1317	ef25396e6a50a36c8a92c1a82669df00.jpg	t	10759.jpg
2489	1318	82ccf29286adaa9e193eb2a37a6f70ef.jpg	t	20546.jpg
2490	1318	308b1ef84901fac9fbec39d3f55380e2.jpg	t	20547.jpg
2491	1319	c565dd74efdfea9d3067bad98bb10604.jpg	t	20526.jpg
2492	1319	24914d9bcc148f7dade8e6aa01df5eb5.jpg	t	20527.jpg
2493	1320	4dedcbe54d593a1e8b9b414c8ef6848b.jpg	t	20538.jpg
2494	1320	fb6a6a42bb5980ade1355e5e45b2cc00.jpg	t	20539.jpg
2495	1321	1ba42e24b0c98a63bb188351fde7b104.jpg	t	20534.jpg
2496	1321	66aa404a0a3e2fc255e40690e1422f6c.jpg	t	20535.jpg
2497	1322	098c5bd8cfb4c68c8978e38f70890a43.jpg	t	20550.jpg
2498	1322	d2f0f5bfeabdd0ea7f24eb3fa6da3e17.jpg	t	20551.jpg
2499	1323	f7d17213e9628d771c04824f7b80bb16.jpg	t	20584.jpg
2500	1323	4dc8b0f833c0b801bf329665a455a06b.jpg	t	20585.jpg
2501	1324	4a339b7c9dab48e5e744c15b5fc753ea.jpg	t	20530.jpg
2502	1324	b67d42304483778ac009f90765c892ad.jpg	t	20531.jpg
2503	1325	66e36e13cee1d21ee53ddef4f3afe55d.jpg	t	20544.jpg
2504	1325	e5d09fd63151400aec536b2029f5451e.jpg	t	20545.jpg
2505	1326	445e29a2f68dba65c139f2c923c62f48.jpg	t	20560.jpg
2506	1326	ba68cb0f7b2a539a70599a98bb5d97bf.jpg	t	20561.jpg
2507	1327	53756014870b04928dbac5f320c2c099.jpg	t	20362.jpg
2508	1327	d76832c2e9b0c5b6f26cf134fe8686a3.jpg	t	20363.jpg
2509	1328	a428bd57c98248e761dfc03a2a46728e.jpg	t	20554.jpg
2510	1328	31fead34130d5a7caa0ba95597d50d59.jpg	t	20555.jpg
2511	1329	c8ff40accbd33cbee2cf412084b8c2a4.jpg	t	20803.jpg
2512	1329	7a766409ad036b86e5637252ed834381.jpg	t	20804.jpg
2513	1330	701d95f3efbdd37d6babd4b7b35a3dc9.jpg	t	20841.jpg
2514	1330	4af1d56faca355d66abdc558476cc1f4.jpg	t	20842.jpg
2515	1331	32e9ee869c4e12d30e68a3207d629f77.jpg	t	20823.jpg
2516	1331	3706b826166fc8cae9d110264541cf81.jpg	t	20824.jpg
2517	1332	813f8619633752051165f3516f055d8a.jpg	t	20821.jpg
2518	1332	79dd81b3197b7ca3d9fedd2223c114ab.jpg	t	20822.jpg
2519	1333	b12cf046b735614975a3aa101aebb176.jpg	t	20807.jpg
2520	1333	abfcab980c2f72512e76e54f8a78dde9.jpg	t	20808.jpg
2521	1334	ec64798d2887dc49a55afe3dc22907d6.jpg	t	20811.jpg
2522	1334	22e684a97d0ba71cd870f5be6d152d60.jpg	t	20812.jpg
2523	1335	e60d1c9287582554bd1d87b0980e26f1.jpg	t	20815.jpg
2524	1335	b4948d0f6dac549b0df83c4d8063746b.jpg	t	20816.jpg
2525	1336	5d36e5a1b9742b22ed1781eef4f83f53.jpg	t	20348.jpg
2526	1336	07d5fc35e08ec16069b2fa0d9131e81b.jpg	t	20349.jpg
2527	1337	a78e3b25422717c0b73f4cbba8cf367b.jpg	t	20837.jpg
2528	1337	e77e084176ceed1e5cd419b30612b3cb.jpg	t	20838.jpg
2529	1338	cbaaadb7c77ba5455a94cc268af32826.jpg	t	20859.jpg
2530	1338	9c1d4edf9e8f23960a05060630374c76.jpg	t	20860.jpg
2531	1339	f80bd95357de3c9fe18c88e930c4b24e.jpg	t	20849.jpg
2532	1339	77974d9fae97549ed8f93dd36f726b72.jpg	t	20850.jpg
2533	1340	0144cf16a191123266ba9f8943dec753.jpg	t	20829.jpg
2534	1340	8dbc40a2622deb5e42e8fbd1411cc370.jpg	t	20830.jpg
2535	1341	578b7eb7ca0fedc0c8a2956a7bbd6c86.jpg	t	20831.jpg
2536	1341	cbb93b33516e95a5cffcbcbc94bd4937.jpg	t	20832.jpg
2537	1342	88d0a3944facc2d5f7bfb8415560ce37.jpg	t	40265.jpg
2538	1342	97a74ab3d5273eb2227910ad45f33cae.jpg	t	40266.jpg
2539	1343	1cd2e9f83bf4d4505a13ebc5cbb0502c.jpg	t	40269.jpg
2540	1343	fb24a82d33dee886bbaec52bc6999bcf.jpg	t	40270.jpg
2541	1344	aa459f3d7c418cce864b426385b833e4.jpg	t	40283.jpg
2542	1344	6f47fcddf6c750962daa77b72ed17d4c.jpg	t	40284.jpg
2543	1345	a8cee8453f46a8cb9b9b0058d2e6ce27.jpg	t	40278.jpg
2544	1345	9a31d0ca54373811eb82aa1d83f46187.jpg	t	40280.jpg
2545	1346	aa9ac9da54f0add1d5de62ef7f4f6fc9.jpg	t	40287.jpg
2546	1346	7f5d45647c41319ab821d98284589ef1.jpg	t	40288.jpg
2547	1347	6960be1c9a2be7b4ca1b1e9122675fbe.jpg	t	40275.jpg
2548	1347	b41e224cd1a0a95edf1e085207b3d5ca.jpg	t	40276.jpg
2549	1348	7b3aba89426ab8948326c679f47865ef.jpg	t	11142.jpg
2550	1348	d507b4e6ccd0009d997dae258c9d7b59.jpg	t	11143.jpg
2551	1349	8e11ad4ac87c94b9564b84c63cd1df82.jpg	t	40327.jpg
2552	1349	fdf90c60d604db5594053fb2d2ca3365.jpg	t	40328.jpg
2553	1350	b81e279711aed94e4495347ef195ec54.jpg	t	11120.jpg
2554	1350	1a7217e8d5023598e623426251649336.jpg	t	11121.jpg
2555	1351	69605ef31ac010224a84ba96a881df68.jpg	t	40339.jpg
2556	1351	03ca624d85bfb6eb11e0626ac83a5d7c.jpg	t	40340.jpg
2557	1352	c34de68a36f8e8b03fa94f6ec703eb0b.jpg	t	40335.jpg
2558	1352	6770409d1cef5355b6d1953ab226a56d.jpg	t	40336.jpg
2559	1353	2fe5acc82bcc720e3107d953656ab31a.jpg	t	30313.jpg
2560	1353	0f353a358411824fd6c01e42324c6427.jpg	t	30314.jpg
2561	1354	cdc6c78129433c46ad6d8adc5e6278a5.jpg	t	11146.jpg
2562	1354	cd5bfc162719ddcbd025e1ace9bd15ca.jpg	t	11147.jpg
2563	1354	4b8646c33e28ab984dc38af59da111d2.jpg	t	11148.jpg
2564	1355	c9463c839021b3b4f2485daa5e36f144.jpg	t	11153.jpg
2565	1355	4fb615f2bea4007a1ca3768938b1b7b9.jpg	t	11154.jpg
2566	1356	0a66be1ae0b741d94d78ed43825f341d.jpg	t	11111.jpg
2567	1356	c3aafebc2ccb3416ec9d225a1d5a768e.jpg	t	11112.jpg
2568	1357	8d86e8718bdcaeaad43614095f3640d9.jpg	t	40317.jpg
2569	1357	5f187e78fe3eed734ed22f1d2a73a0f2.jpg	t	40318.jpg
2570	1358	81847afdddf37fa60f47ab1e8b63afa5.jpg	t	11106.jpg
2571	1358	b140a3ccb9fcdb97ff447abc8baab2c8.jpg	t	11107.jpg
2572	1358	6991be585ebc728c53bbf2455228dbcf.jpg	t	11108.jpg
2573	1359	89512a26b0169a23d6082d85d8cd3e61.jpg	t	40323.jpg
2574	1359	d8502f1cd403b3cee96c402d726efb2b.jpg	t	40324.jpg
2575	1360	caad4dff1a620f2a9431501a6965f525.jpg	t	11133.jpg
2576	1360	724fef1df1d1de4022a2edfc892e9054.jpg	t	11134.jpg
2577	1360	6b801711b7b1bb77febb9fd0cc160e85.jpg	t	11135.jpg
2578	1361	1ee163737ef0e4c85d8d0b4027256607.jpg	t	40331.jpg
2579	1361	df12008d261222dad08af54256801b42.jpg	t	40332.jpg
2580	1362	853809afe07363ba47bf27a2c392aaed.jpg	t	11115.jpg
2581	1362	ce76a0b0bdd843a1c3bbb2d9e11c6015.jpg	t	11117.jpg
2582	1363	d4063b2d85435c324ccc52dec8a06408.jpg	t	11125.jpg
2583	1363	1d0de5dce128e222f504d46c4eeaeccf.jpg	t	11126.jpg
2584	1364	91a7f632ad9424de09aa0f02e2b206bc.jpg	t	11163.jpg
2585	1364	b470e6b1743632dd87ff76ec07d557fe.jpg	t	11164.jpg
2586	1364	bb650c5f50f9862312c632a2f31f1c8e.jpg	t	11165.jpg
2587	1365	227359554002103f7cd6460ac3898e9d.jpg	t	11166.jpg
2588	1365	4170609234213dc54539495eb6c8883b.jpg	t	11167.jpg
2589	1365	c3e4a8a50fbf727e230b6356501cffc1.jpg	t	11169.jpg
2590	1366	eee5e66b16afec54c9a671dedd6cb7f6.jpg	t	21133.jpg
2591	1366	66317b86acc685554d1d7ec14dc933ae.jpg	t	21134.jpg
2592	1367	d7a4b1068915bb85958cda7e35a3a39e.jpg	t	21127.jpg
2593	1367	6bc6c9269ce5d3e2d05d1dab1797c801.jpg	t	21128.jpg
2594	1368	e7010e7af8afdea8a1c267e10f592365.jpg	t	21125.jpg
2595	1368	e02958e6e8b283552abdb35710524315.jpg	t	21126.jpg
2596	1369	7e75e0adab71547d8193766dfa62c0c5.jpg	t	30069.jpg
2597	1369	c50baac843e5a11f9990c206d9388b84.jpg	t	30070.jpg
2598	1370	07a65503f970c23c4b98f4517bda566e.jpg	t	30075.jpg
2599	1370	84d3e047e1c33324e36079369fde2f48.jpg	t	30076.jpg
2600	1371	b068593f076fab12b0ca246c6ded159f.jpg	t	30083.jpg
2601	1371	5a5151714c5fb418bf9f016a1185afd0.jpg	t	30084.jpg
2602	1372	2349c29e76c34e9ad7d05cecee9ec131.jpg	t	30079.jpg
2603	1372	313af3286c6f4f5e5d959cf828483a1d.jpg	t	30080.jpg
2604	1373	3547d65aaec5e83fed72149596ff3c07.jpg	t	11357.jpg
2605	1373	265fb7a4b50594dd8f22dd72f61c7852.jpg	t	11358.jpg
2606	1374	5a4c3add1b847f0bbee2f92c6d6329ca.jpg	t	11367.jpg
2607	1374	7fb53632612b7704b884eb5156fbef25.jpg	t	11368.jpg
2608	1374	ab024a755ff3fe48d69ffd6eb12e4327.jpg	t	11369.jpg
2609	1375	1228984acd94859b75801ce4d054fd77.jpg	t	11361.jpg
2610	1375	84bb0d08efd31fc76b83c25a135415fa.jpg	t	11362.jpg
2611	1376	dd697ce7f8e722b3bcecb21914b6c4e4.jpg	t	21180.jpg
2612	1376	fd826c4f7af537c898ab8c86ea537555.jpg	t	21181.jpg
2613	1377	0422c90eea29835223abc18214a78214.jpg	t	21119.jpg
2614	1377	b46f06215be6525446683f4116618965.jpg	t	21120.jpg
2615	1378	92bdb1e3a1185a7d883ea68c3e283cd0.jpg	t	21175.jpg
2616	1378	56639f2c2715fd5c71fed989aa5e4c81.jpg	t	21176.jpg
2617	1379	aa7d9fbd600903d5f15b5594400b0ec0.jpg	t	21177.jpg
2618	1379	149aeb5ba9e2778df3f129824e423f8d.jpg	t	21178.jpg
2619	1380	7b9dd984dc53153805beb9569538770d.jpg	t	30159.jpg
2620	1380	c060ebc2512135652730de5e5205470f.jpg	t	30160.jpg
2621	1381	de660a141b8933243d7976d6b58a6bb1.jpg	t	30636.jpg
2622	1381	9325e625ccb7f15f0223b8dec3ff916a.jpg	t	30637.jpg
2623	1382	80782c79f8dde7d99f7c735499891363.jpg	t	30614.jpg
2624	1382	d4c171597d7c8deb6c3dc935e7aeeca0.jpg	t	30615.jpg
2625	1383	88d7b3286f4418993a1e526a7c5765be.jpg	t	30526.jpg
2626	1383	313f01907666a5b7caebeb0f393c2762.jpg	t	30527.jpg
2627	1384	14bc811685b1ad2790f1939ef970eda2.jpg	t	30591.jpg
2628	1384	a59bfa46135f4a37c53d2d5d2a35b51b.jpg	t	30592.jpg
2629	1385	ae497f41b964f1d374aead56a504812b.jpg	t	30111.jpg
2630	1385	43e51c2c201f9342c3a1eb6a5b38acd4.jpg	t	30112.jpg
2631	1386	afe707f082d6d9496e90c4d86f36288e.jpg	t	30597.jpg
2632	1386	4e1745c05fc4f92f68b39a7f4a60915e.jpg	t	30598.jpg
2633	1387	30eb84fa9aa86cf6d6890ef2ff666d66.jpg	t	30616.jpg
2634	1387	b1ecb97c7a4c5cf07c36703bb48700e8.jpg	t	30617.jpg
2635	1388	4cc0829147e733e98b65cf2d67aafd02.jpg	t	30113.jpg
2636	1388	e201cd6c37f3a48239763432678417c4.jpg	t	30114.jpg
2637	1389	23c7cb5e41e6ef8594695384c2aa2780.jpg	t	30620.jpg
2638	1389	3d4b84923126ee7a167cc4017a9a305c.jpg	t	30621.jpg
2639	1390	fc6b082bb61ae1abed7b8a7c20d97196.jpg	t	10869.jpg
2640	1390	a0aee28a51b1540b2bd4fc916dc40c7f.jpg	t	10870.jpg
2641	1391	b8d5b39c8c2a8e270ff07c87c549dabd.jpg	t	10847.jpg
2642	1391	c3700165654c62187e1056dcb3c38d39.jpg	t	10848.jpg
2643	1392	71a3fb5736ed68382b4832b2e18b9b72.jpg	t	10909.jpg
2644	1392	b4ca449785da3f5129cc37dfa2c071fa.jpg	t	10910.jpg
2645	1393	8a0008d3ada3b3dbb19c4a0f56dfd4a2.jpg	t	10863.jpg
2646	1393	5391c4c3d4bbf0b9386c0cc85c4d49ff.jpg	t	10864.jpg
2647	1394	fd5e7a6662a5ab65e9c72403b6acf83a.jpg	t	10918.jpg
2648	1394	548710e3fa687a781ed331c3a28dd873.jpg	t	10919.jpg
2649	1395	4251f957a3835e7cdefcb6a30559023a.jpg	t	10855.jpg
2650	1395	f077f5a387f1501372bcf7d37bdad29f.jpg	t	10856.jpg
2651	1396	c37da8c696d8c6ec0d03be2fe716604a.jpg	t	10925.jpg
2652	1396	2aa245bef3431d39b06f1ba4149643f7.jpg	t	10926.jpg
2653	1397	a6924ecffb341ba3bb57dd582653ea1b.jpg	t	10933.jpg
2654	1397	6b824979da2ed4687634af2d2bc19cea.jpg	t	10934.jpg
2655	1398	690464b67426af12bbc7f2262fd8989e.jpg	t	10939.jpg
2656	1398	d361b75ac1f3817c1f2ab58f573731c7.jpg	t	10940.jpg
2657	1399	daf2b1ca8c23a9bdb88b28551260c202.jpg	t	10897.jpg
2658	1399	443eca5c6c72066f8e048c83cfe35ff2.jpg	t	10895.jpg
2659	1400	f9e37ac10d1aed29eed61682346dc521.jpg	t	10903.jpg
2660	1400	fd4768f8c23dd019e79b9a69308271f5.jpg	t	10904.jpg
2661	1401	50fe51867e58f61cc774221226f596f6.jpg	t	10857.jpg
2662	1401	11bf9713b8abfb10e8f30e6ba202f166.jpg	t	10858.jpg
2663	1402	59c318cf0af0eec63a16e0fb073988f1.jpg	t	10929.jpg
2664	1402	cfffd14b5e5af89d246965e29933b15a.jpg	t	10930.jpg
2665	1403	e48bc2006ab90ee7b49c9fbe4b1149fd.jpg	t	10873.jpg
2666	1403	39bb3db347deea900404b482ba74363b.jpg	t	10874.jpg
2667	1404	980ee6a2b3d295008eabed3abe1c520e.jpg	t	10877.jpg
2668	1404	6db5046b9fd7de39bf6dbacaea404197.jpg	t	10878.jpg
2669	1405	8ee9ac5ab567b745281f950946a0f910.jpg	t	10949.jpg
2670	1405	a850d474d37f34de3730dfd4b9a909b4.jpg	t	10950.jpg
2671	1406	3cd514f38b7f0ea787c4bdb5a57261eb.jpg	t	10881.jpg
2672	1406	c298bf98d287145d8e7c8e3135c73538.jpg	t	10882.jpg
2673	1407	d6ba99cd5fb4a4c3c613767fa2039359.jpg	t	10941.jpg
2674	1407	f23d6a2168cd84dce97a9982d983f8ad.jpg	t	10942.jpg
2675	1408	04dac34c883c85363665df21d52047b8.jpg	t	10865.jpg
2676	1408	680f85f780d25471f8e078cf0fb3f0d3.jpg	t	10866.jpg
2677	1409	869abdb4f4b82948e2b7e6a9375425f7.jpg	t	10901.jpg
2678	1409	71466e8195fb20118f247c3c565b2301.jpg	t	10902.jpg
2679	1410	284da5df8eb86c40e815d1f49e8babff.jpg	t	10879.jpg
2680	1410	caccf69c29175924aed0b6a33e346470.jpg	t	10880.jpg
2681	1411	c8410398c12eb3dcf4b8d4e088da2e73.jpg	t	11329.jpg
2682	1411	198e0bf7b69a5eb302f76eb346fbbc66.jpg	t	11330.jpg
2683	1411	a30bfa04a25c4fbf7c532542c91a1211.jpg	t	11331.jpg
2684	1412	14e5366bf7094bf89c1a5df87fe978ce.jpg	t	11338.jpg
2685	1412	ddad8f84dff12a71c011fdc0cc2b0264.jpg	t	11339.jpg
2686	1413	79af1f7009ff784109fd351a44fe7c78.jpg	t	11346.jpg
2687	1413	530ba9384c6f57018b1a844763df9900.jpg	t	11347.jpg
2688	1413	b80e01797bdcc086cac45cf20a52aca3.jpg	t	11348.jpg
2689	1414	862c45f8d180ceee8202273687af8ba2.jpg	t	11351.jpg
2690	1414	4375d45a0db49500437ce4d2b7e4ed28.jpg	t	11352.jpg
2691	1415	1e905b664bda5057058de2c731876f45.jpg	t	11334.jpg
2692	1415	4fe5fa802c2e3e13a9b8785f83710af2.jpg	t	11335.jpg
2693	1416	65ebacc769b499ffbc1a3369e724780a.jpg	t	11370.jpg
2694	1416	56cce415d864fb3399884b3036fc7007.jpg	t	11371.jpg
2695	1417	f63e21ce03c7e24fd7ded9628e878ca4.jpg	t	11325.jpg
2696	1417	762367212150a1462da76ea7c22460f6.jpg	t	11326.jpg
2697	1418	6f267ed7cbf84ed6151f76e69d0149ff.jpg	t	11320.jpg
2698	1418	61376abe38ebc6533277b9c7ede3b181.jpg	t	11321.jpg
2699	1419	f57d596e1d50ee6944076cbd110334e6.jpg	t	11315.jpg
2700	1419	d7a59175020acac3d5f8974091b57c9f.jpg	t	11316.jpg
2701	1420	ec545e986788dc5390d3a40fd2603d1e.jpg	t	10662.jpg
2702	1420	763bf1b6f639fe237d141d4496849b16.jpg	t	10663.jpg
2703	1421	db00a62f8017a9b4c20c5dca905834f8.jpg	t	30099.jpg
2704	1421	f35cf3dbed8aabe8761cdad5bbda3833.jpg	t	30100.jpg
2705	1422	b79ce50c96b20ba760f83e5edcf92a13.jpg	t	30067.jpg
2706	1422	e6127e83bc5c318ec1c36d72cbdf9c7d.jpg	t	30068.jpg
2707	1423	5af1454a209ee4af3b8cfcd7393431d0.jpg	t	30121.jpg
2708	1423	a77d5e603654fd95c8f7e67e9f6e15b6.jpg	t	30122.jpg
2709	1424	7dea926a23b7115a12ebbba877b3d83a.jpg	t	30063.jpg
2710	1424	ba14bb24d0137259052cc01a12adbf69.jpg	t	30064.jpg
2711	1425	b83b3ac93ce324431188cfab8cddc288.jpg	t	30153.jpg
2712	1425	f27ec7d0a9bba7cef2f94161c0403ae3.jpg	t	30154.jpg
2713	1426	e704f18511af9fb12a6b873cd515deb1.jpg	t	30123.jpg
2714	1426	4ffe8b656a00ddf7d2577612beba2903.jpg	t	30124.jpg
2715	1427	8e046c95fa1465d15f4b37be19a8bc74.jpg	t	30604.jpg
2716	1427	c30a1a4c778bdba53993819a1130e793.jpg	t	30605.jpg
2717	1428	bcabc6c4d7824098e703613908ae6806.jpg	t	30581.jpg
2718	1428	1f0debbc5c27987f7056f43cc26bc1ae.jpg	t	30582.jpg
2719	1429	afca22b2ad8cdde8570b8dfd45b14d4c.jpg	t	11276.jpg
2720	1429	591e86ac94703ffaf79d7e80a33aba82.jpg	t	11277.jpg
2721	1430	b36fa6252a807b9f7a13dd2640f68687.jpg	t	11289.jpg
2722	1430	39373f2591e60b7afe9e7afdddf96173.jpg	t	11290.jpg
2723	1431	ac698cbaa68bf153f6913e2a8c14c863.jpg	t	11282.jpg
2724	1431	e33e7d6646b9733a4a6aef308c952310.jpg	t	11283.jpg
2725	1431	0b94e1a5f47e433b42fe3b29a7729e69.jpg	t	11284.jpg
2726	1432	2189a1ef57c83d5760953f1828328c5e.jpg	t	11300.jpg
2727	1432	088e649d11949df2b4f4b1b64aa85dc5.jpg	t	11301.jpg
2728	1433	0553158612c8fd7b1410e6fdafce0dc4.jpg	t	11295.jpg
2729	1433	9b53836337ca833fd88aca033f3be023.jpg	t	11296.jpg
2730	1434	0a89d4312b6b8381e09a3c45f0027c84.jpg	t	11312.jpg
2731	1434	92b5c7b09945673da5c525d206355d75.jpg	t	11313.jpg
2732	1435	cd4741a0f2e7049f438ed8b89939ef96.jpg	t	11297.jpg
2733	1435	be232f4500ebdc7639b278e225e53854.jpg	t	11298.jpg
2734	1435	1fff3d87ee941e5dfda903c4d35a441e.jpg	t	11299.jpg
2735	1436	6f6c92bccf5ec94f5984864ed4dc4d2e.jpg	t	11306.jpg
2736	1436	76ed0f46d6078364b3f0b3bd13c63404.jpg	t	11307.jpg
2737	1437	ca6f9f62fdce4b293e522a804219a957.jpg	t	21141.jpg
2738	1437	538d171afd9c1c8c4a739ed8f94e798a.jpg	t	21142.jpg
2739	1438	8045bbe9b8f39b928736c77eb9855122.jpg	t	21169.jpg
2740	1438	55de7226b05c9ab9a5d3e593b8f16cc9.jpg	t	21170.jpg
2741	1439	0c7930a39ab7260536fa80089838c557.jpg	t	21147.jpg
2742	1439	1c7be550f2cc287904f2c34181fcb4db.jpg	t	21148.jpg
2743	1440	6498e8fe594a1f03caefbbad41bbbdc4.jpg	t	10843.jpg
2744	1440	a759705478c3e1edd024789724f21a9b.jpg	t	10844.jpg
2745	1441	2901b4b944bb48057ead12f54fb0a234.jpg	t	21135.jpg
2746	1441	5904b88016d0375dc34f5cbc281cff24.jpg	t	21136.jpg
2747	1442	5d306a3f16306014ccb25e83e033a157.jpg	t	21149.jpg
2748	1442	f01c29402c2ff79bcb6f15c2efa34547.jpg	t	21150.jpg
2749	1443	54db4818c9ab0daf6be38e00e4a20039.jpg	t	21155.jpg
2750	1443	377c8787a15ac2fa96d8b08fb59e316b.jpg	t	21156.jpg
2751	1444	489cca30a83f94fb424db3321565df5c.jpg	t	21145.jpg
2752	1444	ef9b0648b6ca7b7eb2b941db68403190.jpg	t	21146.jpg
2753	1445	d8b22371c9908430c0f1c882ea71062e.jpg	t	21161.jpg
2754	1445	f827be5dbefad704340398b831df0350.jpg	t	21162.jpg
2755	1446	e24bda76a00709f8bbfec1c759a1de33.jpg	t	21163.jpg
2756	1446	dc167497c72bd8cb17c5b1671f8f7601.jpg	t	21164.jpg
2757	1447	90ec06601b864bd7e3c9aab2334eee2d.jpg	t	10327.jpg
2758	1447	78339cd2266a9a882d9f9cf22a65531e.jpg	t	10328.jpg
2759	1448	19cda835a051c09c3277d2ff39e3d5b8.jpg	t	10329.jpg
2760	1448	f62bddb3c675f5f9e2d215db3c40633f.jpg	t	10330.jpg
2761	1449	ab0e2e8db14e647037128374fa20383e.jpg	t	40499.jpg
2762	1449	7611258b0449ed184513cbdb70ed89b2.jpg	t	40500.jpg
2763	1450	90816dcecb86de8192ac0c37ac8e710b.jpg	t	10333.jpg
2764	1450	c2d5b88d279ee1f6b19e010f7eda1b15.jpg	t	10334.jpg
2765	1451	440b04bf1bd1533cdc58450291a0a637.jpg	t	10335.jpg
2766	1451	223f53e0e60b6b2d4b6905338c500bc5.jpg	t	10336.jpg
2767	1452	ecd012d808b0d2ad21feea5f5da97cfe.jpg	t	30575.jpg
2768	1452	1e283faf469548e88fad2c0eab4208ce.jpg	t	30576.jpg
2769	1453	ca3cc2189c56fa726f57b4fc66ac45e9.jpg	t	30567.jpg
2770	1453	448d13e05ad249477d18e71187dde226.jpg	t	30568.jpg
2771	1454	6d38d8fac5cad6a8c3192a658833e264.jpg	t	20424.jpg
2772	1454	3793fd0b0c709574c9d6a760348ca8d2.jpg	t	20425.jpg
2773	1455	afd624e0bb7e515864741722f0b29b3f.jpg	t	20418.jpg
2774	1455	aaee842050b41b78fadfc04b924e02c6.jpg	t	20419.jpg
2775	1456	df2cd495c42a4eae5ab9b8ab43d9047b.jpg	t	20420.jpg
2776	1456	f24da549e9c6277ff49aa05b089b2330.jpg	t	20421.jpg
2777	1457	acf6da556028612af6fc527b41a18371.jpg	t	30690.jpg
2778	1457	97bb01b41c5c0d896faaa25613d1549f.jpg	t	30691.jpg
2779	1458	520b5b820248a4106d55e5c61d9f0916.jpg	t	40183.jpg
2780	1458	d2216c1f70f1fa84801832cd3623853e.jpg	t	40184.jpg
2781	1459	1c679196d0dd4936e8541843133b75fa.jpg	t	40128.jpg
2782	1459	49c593091bfb4449b4f130daa9656905.jpg	t	40129.jpg
2783	1459	ff370692e5129295f179dbae1538aa0e.jpg	t	40130.jpg
2784	1460	a95c74ab288e74bd5955f47dd2282e3e.jpg	t	20170.jpg
2785	1461	cf743db666df9b66e21dc22b167c7084.jpg	t	20184.jpg
2786	1461	c0844a1cbf32e5be5387836f8550c470.jpg	t	20185.jpg
2787	1462	07ab6e814b44a194f0e8bedcea78a11e.jpg	t	20182.jpg
2788	1462	6f90b995fe98fe6bdf2dddf0305af7d6.jpg	t	20183.jpg
2789	1463	0f8a7e95fc7c20a28e5f02c09bb968d8.jpg	t	20176.jpg
2790	1463	3baf5d4ae1a42bde43bb22eccbebf832.jpg	t	20177.jpg
2791	1464	0f8a7e95fc7c20a28e5f02c09bb968d8.jpg	t	20176.jpg
2792	1464	3baf5d4ae1a42bde43bb22eccbebf832.jpg	t	20177.jpg
2793	1465	b05a5e5db6900c0330d0cf712026a52a.jpg	t	20422.jpg
2794	1465	a92ff4f870486b25e3e4f66d632fa141.jpg	t	20423.jpg
2795	1466	cca094b32d69abe0128151f44937a021.jpg	t	20190.jpg
2796	1466	3792ce68b69593f6ac480bcb29b04b01.jpg	t	20191.jpg
2797	1467	508bd276ef8267ddf89f0513fe59df42.jpg	t	10670.jpg
2798	1467	0d55e52afd8b03c111adfe5f7957ec48.jpg	t	10671.jpg
2799	1468	e82fbd8c7eae5843f8bcb3c0dd7a1c12.jpg	t	10382.jpg
2800	1468	0dcfc575d162f1e1b3f4e37aeb178bfa.jpg	t	10383.jpg
2801	1469	aeb15bbce5b2f57bccc29e68ffb6cd68.jpg	t	30149.jpg
2802	1469	0ef944a0721c1c2a74586fc524c67c85.jpg	t	30150.jpg
2803	1470	95261b4db1694a8f6b0fbdb71250b005.jpg	t	10666.jpg
2804	1470	7832a39ec8b493dbca8f72990397f786.jpg	t	10667.jpg
2805	1471	5eefda11397947e36cf2a3645ca68a4f.jpg	t	10682.jpg
2806	1471	af10291cf5e2515fe1a79a100dc0fb04.jpg	t	10683.jpg
2807	1472	7320f2d2a66dad65ff583338a88a4acb.jpg	t	10676.jpg
2808	1472	1d8cd8132c224203112bc443c1a40574.jpg	t	10677.jpg
2809	1473	cda497ba664ae690c62004b99ac83e7d.jpg	t	30145.jpg
2810	1473	321f1f75f9f9d2617de6b483e551a993.jpg	t	30146.jpg
2811	1474	e077cef370dbce5e2703fcb4f8819b95.jpg	t	10678.jpg
2812	1474	28f170c3538204ec594ca8963a0eacf2.jpg	t	10679.jpg
2813	1475	d4ad4a317a75dafcbfa0505e55608ba1.jpg	t	10376.jpg
2814	1475	23e08313398c7d19e61eb45db59b6133.jpg	t	10379.jpg
2815	1476	9d3377d562b4e2090c6222ceececfe6c.jpg	t	10372.jpg
2816	1476	722d3e5ed5b5b39f89ee0a2e48be6475.jpg	t	10373.jpg
2817	1477	02d5e6a3117624dc1ed94401e939fe86.jpg	t	40417.jpg
2818	1477	935fa559b91cda61050d3c2acf9c9879.jpg	t	40418.jpg
2819	1478	bca6d1b3b7477be19cf1e343d9aa5566.jpg	t	40397.jpg
2820	1478	63e34bab977d483154414f36db15588a.jpg	t	40398.jpg
2821	1479	1fc8973431d144ca17ae36c4453da568.jpg	t	40411.jpg
2822	1479	384b533ee1111eb34610364e9b65dd30.jpg	t	40412.jpg
2823	1480	7f507c82e31fea2daa9d0dc90a0e585e.jpg	t	40405.jpg
2824	1480	bea8d41cc1babe1af2217efb20beb54c.jpg	t	40406.jpg
2825	1481	e732001d6214cc00cb2b7015f96dd17d.jpg	t	40415.jpg
2826	1481	d9da35edc7734041fca2efdcbe3dd560.jpg	t	40416.jpg
2827	1482	98bad1872e3f30b087483814e24bb84c.jpg	t	40393.jpg
2828	1482	09b85541dec3d152db6a3407d409c4e8.jpg	t	40394.jpg
2829	1483	5c4bfed303411dec9a201809e6b42d5f.jpg	t	20342.jpg
2830	1483	5e0e1225cee2648b191ae552b7eda2b4.jpg	t	20343.jpg
2831	1484	36f293cf647084b2905c0e78b700e55e.jpg	t	20346.jpg
2832	1484	dc5ebf9caeb8d759498d426cd7f12d9a.jpg	t	20347.jpg
2833	1485	5931f4680138f8b7830a6e9c9617e834.jpg	t	20336.jpg
2834	1485	f99065eaf502017c872bad9e204ffb58.jpg	t	20337.jpg
2835	1486	7dd5d3c008c893a347c10ae366236a6f.jpg	t	20268.jpg
2836	1486	ac8a06f941864f789d6b6bdd85bc01db.jpg	t	20269.jpg
2837	1487	8d2d0584acc213b1b48d1225afbfcee2.jpg	t	20644.jpg
2838	1487	daae85911515184b40a6fd148f2083ef.jpg	t	20645.jpg
2839	1488	7ab2abca8b94a17d2801e80d93c5dff6.jpg	t	20264.jpg
2840	1488	b58c717a908b68514333883402e7cc86.jpg	t	20265.jpg
2841	1489	6da46b31c03beeb02b39e5701e731af8.jpg	t	20276.jpg
2842	1489	605da7aa59359e794098ca7e189eaef4.jpg	t	20277.jpg
2843	1490	8ec6611d552cdf3cfaa1c106210f68b7.jpg	t	20272.jpg
2844	1490	d673d315d78f92fbb7b9a5469aa0f2a9.jpg	t	20273.jpg
2845	1491	b4b54efc97d125f040a4f954b0196239.jpg	t	20252.jpg
2846	1491	61aea82ca94121bedcefdc069d632ee4.jpg	t	20253.jpg
2847	1492	4bc4c5b83445e335fd2a484899d3b05e.jpg	t	20256.jpg
2848	1492	82acf028cfd05487c0cbeffdd75d32b8.jpg	t	20257.jpg
2849	1493	28f976610908a583d4aaa79a535ce22a.jpg	t	20292.jpg
2850	1493	33189e8cd86e63bafee1d4be9ce3ded5.jpg	t	20293.jpg
2851	1494	7c5d5dea36b3f479310d2c6245a05e9d.jpg	t	20284.jpg
2852	1494	51a9bc4193c986fecb28668e869192b1.jpg	t	20285.jpg
2853	1495	3e4cc5a98cbea2964ecbcaaf0c7a9026.jpg	t	20288.jpg
2854	1495	1e29ec0b4251cf0d7accdf38bc2ffceb.jpg	t	20289.jpg
2855	1496	b4b37af2bf39d3666e13cd8255fdd525.jpg	t	20280.jpg
2856	1496	77bf2c690f449cd8875824a7ab275674.jpg	t	20281.jpg
2857	1497	22d1b0f5d1efb6b4f62591856e7588f1.jpg	t	20260.jpg
2858	1497	86d399663def15fd6d84f253c24a1cc5.jpg	t	20261.jpg
2859	1498	69c38beff66ae501742b936b7e080dc2.jpg	t	20238.jpg
2860	1498	b0dc6a38f6b0d88724a3f41769c71738.jpg	t	20239.jpg
2861	1499	f85001206d0b7c0aea7f653299324e95.jpg	t	20228.jpg
2862	1499	8051a194c9b8f66dfd237e54762a8d92.jpg	t	20229.jpg
2863	1500	e6d5653a46fe5b5da062bdf5e1c3c8a2.jpg	t	20630.jpg
2864	1500	4632aa84567137e4c889919440bb9d71.jpg	t	20631.jpg
2865	1501	57394aa6bbfb08f139fdc253a134f875.jpg	t	20296.jpg
2866	1501	0d41eb1fd3cdbbd7c0a42ff16ca91b25.jpg	t	20297.jpg
2867	1502	49d4543c640e5f5fb217484d52fcef86.jpg	t	20626.jpg
2868	1502	206a92ee75aaa67cfe72d6e36fa0e7d9.jpg	t	20627.jpg
2869	1503	2095a0126aca5d4ae82e3449e9e94148.jpg	t	20198.jpg
2870	1503	304b2436743f19211c93d7ccda3cd294.jpg	t	20199.jpg
2871	1504	b9aca30fa2b9e7f9b12f690c7cbf646d.jpg	t	10323.jpg
2872	1505	c04e3bf9240ec2c309c0114139015e95.jpg	t	10033.jpg
2873	1506	7f86c84f1573b78bed5444824c837935.jpg	t	20412.jpg
2874	1506	f3fb6afb51c2a39f9cdf260c52fefbdf.jpg	t	20413.jpg
2875	1507	55fef91b55b44238fe236c43bafb233d.jpg	t	40399.jpg
2876	1507	e887a2f253cad96d276a81c8b95173aa.jpg	t	40400.jpg
2877	1508	f03cbea055a32eaef029ec69711bb8ba.jpg	t	20202.jpg
2878	1508	0db70c13c39c9e472d3893512cbdba97.jpg	t	20203.jpg
2879	1509	fb0f555c81916394d20ec9664a88d8bd.jpg	t	20214.jpg
2880	1509	0ca74139212c9c085df0e8978712c2e4.jpg	t	20215.jpg
2881	1510	20439b372ddc8933187b52166cf65af1.jpg	t	20192.jpg
2882	1510	0cdae584735fae95ddc45f3561407815.jpg	t	20193.jpg
2883	1511	503a7f91b7041564c9845a7aaa23e9fb.jpg	t	20196.jpg
2884	1511	b31edfd15bf682ae3d2752a00243b422.jpg	t	20197.jpg
2885	1512	1c6e48439079309db5a1ff78337bd473.jpg	t	20216.jpg
2886	1512	42b4d322c261f1f0e7cb791ac8ac54d3.jpg	t	20217.jpg
2887	1513	d891ea591c8e6cdded619b58d1c0ab0a.jpg	t	40483.jpg
2888	1513	bfcdb1e2852105c8351681a04b3fca68.jpg	t	40484.jpg
2889	1514	5c1b73e201af351c882f799d4a2f462f.jpg	t	40475.jpg
2890	1514	2a886dc128c4b8327a0d4d7f4934290f.jpg	t	40476.jpg
2891	1515	75462cfcb763fac9dfe4d31de5505218.jpg	t	40461.jpg
2892	1515	3087c9638d6f61a37e0f1e7154ac14a5.jpg	t	40462.jpg
2893	1516	32a8db47526d3443c906c31d248719ba.jpg	t	40427.jpg
2894	1516	d6c10dca3fea3e822e56ae6427bec0be.jpg	t	40428.jpg
2895	1517	b16747472f3f3cf1f324adffc1332b65.jpg	t	40431.jpg
2896	1517	115dabb68d9aaca0360afc1e94aafc69.jpg	t	40432.jpg
2897	1518	bbdde8402a67083e73b1984ab7aaeccd.jpg	t	40425.jpg
2898	1518	00d12da617db53d4797234d431e7a2d1.jpg	t	40426.jpg
2899	1519	48cedd84d47621e1c54d141a0a32cb7c.jpg	t	40439.jpg
2900	1519	b3751cb84ded906cb206c896b4922950.jpg	t	40440.jpg
2901	1520	fbec7f0d0544e520fb31c7b65f3031e4.jpg	t	40435.jpg
2902	1520	fd4c87d7d01a0bedd7fe3791acb6aabd.jpg	t	40436.jpg
2903	1521	d2d4e71d27f5d8e8004ce1fa8d23d839.jpg	t	40495.jpg
2904	1521	e8e3b5f886dde9364ebd9b7204822666.jpg	t	40496.jpg
2905	1522	fd9e4a0fefba3ff7a4a55f023cea636e.jpg	t	40449.jpg
2906	1522	538170941079e62b0f087001eb5a0805.jpg	t	40450.jpg
2907	1522	6d2fa2f723780977a32c6685ef2c85c2.jpg	t	40451.jpg
2908	1523	0fd5f64bce6f6ec761774a031bf88f4d.jpg	t	40467.jpg
2909	1523	4ce13e123089a7e7fd0fbbb25011964e.jpg	t	40468.jpg
2910	1524	7052fa7080abb7162acb2e1323601299.jpg	t	40465.jpg
2911	1524	aefe3d9b00f94f17ee2b9f78c1a87d1c.jpg	t	40466.jpg
2912	1525	f7001e70af426e8c51869c395f011741.jpg	t	40443.jpg
2913	1525	b78b986b31fa011f52487f10adb09c54.jpg	t	40444.jpg
2914	1526	058444543fa19d06ee0eb7c22d0818d0.jpg	t	40487.jpg
2915	1526	55e5b96937bc1e913bc3f57f65ba5397.jpg	t	40488.jpg
2916	1527	05087b2cc7b300fac5d47a3221a14192.jpg	t	40477.jpg
2917	1527	49475394b847c18d0860cf36c24753fc.jpg	t	40478.jpg
2918	1528	2c8d58443229ca05f3977a463f3992fb.jpg	t	30656.jpg
2919	1528	c43d2e710b5914acfe2cda8d81a38ebd.jpg	t	30657.jpg
2920	1529	3c4395ce82ed02c5e777883bdeda8ce3.jpg	t	40457.jpg
2921	1529	07f5cf3df27f4d3815ecb2b305e0d2a2.jpg	t	40458.jpg
2922	1530	f8a2914f7d12a5e355e00c28bb07e544.jpg	t	30131.jpg
2923	1530	fbb0c15a2af22a81c88901a81b31eda6.jpg	t	30132.jpg
2924	1531	037f9695e0d5c0531d2c5e12c5d8d389.jpg	t	10370.jpg
2925	1531	2e4b39ea7a8ff3218165424bff2d4e47.jpg	t	10371.jpg
2926	1532	11f67e5e2c3fabe46f224e9da8c13de9.jpg	t	10957.jpg
2927	1532	4fe0bb34501eec3074a0fe6ce0d1c2d8.jpg	t	10958.jpg
2928	1533	2f3c93a9f85fae26eca1e9e7e0ed9d53.jpg	t	10988.jpg
2929	1533	9c0addbdb846809820e3be3aa22b2ba2.jpg	t	10989.jpg
2930	1534	7235324fdfa21cc5268cf2d05faa4e34.jpg	t	30816.jpg
2931	1534	60b4a075c5b4726eba59e16c67cb8af4.jpg	t	30817.jpg
2932	1535	ac5c27e26bd984e588c2d8b481b80876.jpg	t	10714.jpg
2933	1535	e67c95be1a7b60d1f547b0f6cad80c44.jpg	t	10715.jpg
2934	1536	f3d02031741d98bbba6f341dc5474b8b.jpg	t	10702.jpg
2935	1536	c7101c7fedf886bab73350cd3548dd1a.jpg	t	10703.jpg
2936	1537	fce64b9206224a0d52c576a2424add48.jpg	t	30055.jpg
2937	1537	71f3660b1e0533d3f3dcec3c780994aa.jpg	t	30056.jpg
2938	1538	3a5744a0a214e1be37c1fae471d82528.jpg	t	30810.jpg
2939	1539	5141c21967463bd0622dbba1d9540d68.jpg	t	10811.jpg
2940	1540	cdeab66c8441cb6edaa54048517a4a64.jpg	t	10953.jpg
2941	1540	aa44526656441611c996cdcf9ad22378.jpg	t	10954.jpg
2942	1541	9bb132bd9ead281df9f2998388592ff5.jpg	t	10722.jpg
2943	1541	0e508dfe7863e0b314aba65aa17a694b.jpg	t	10723.jpg
2944	1542	f721ff0d175465e76cf9021d10e51c43.jpg	t	10700.jpg
2945	1542	1f9d407a30224e93b8a284ba3fc2ff57.jpg	t	10701.jpg
2946	1543	59436f8abbe356ecd6ad2f29efa4f4ac.jpg	t	10706.jpg
2947	1543	301a73b73904f18a6088affc70d8013f.jpg	t	10707.jpg
2948	1544	9b7eb9f9f29eb6e748fe1b9dcf2ab099.jpg	t	10710.jpg
2949	1544	624c6c2f88fce765d9243e64656e408a.jpg	t	10711.jpg
2950	1545	750928b788e42429d41088c246a005a7.jpg	t	30820.jpg
2951	1545	e77cc4470ba5ada640f3d573eb0c15b2.jpg	t	30821.jpg
2952	1546	cef0136b435d2d97a478834e2ee14983.jpg	t	30135.jpg
2953	1546	181a06f87a36e09c302fbb41e6124417.jpg	t	30136.jpg
2954	1547	91cb8c49b9e918a6e68f5fbd4cddcd95.jpg	t	10742.jpg
2955	1547	d5e2494bc756481609ed420f6f66ecc2.jpg	t	10743.jpg
2956	1548	1d22ba628b394e0458d1ebfe908affd6.jpg	t	10984.jpg
2957	1548	0ba3ae60491c07b825b7de4dd538f21b.jpg	t	10985.jpg
2958	1549	1df12a433dd4ce5ba65878ce61bd99bc.jpg	t	10734.jpg
2959	1549	5d403e13ef01351ff386aab98927f6da.jpg	t	10735.jpg
2960	1550	eb397bfd54b1ef9eec12604bc8b5bbdc.jpg	t	30049.jpg
2961	1550	1b6715ea74a2a987f123af2ffbe87098.jpg	t	30050.jpg
2962	1551	6b211473e3625c00fe977759c64e4cd0.jpg	t	30047.jpg
2963	1551	65976b61d9c1d236ff410a96d0dfc51d.jpg	t	30048.jpg
2964	1552	16ef84ec8dd53dd46d7f6f77ec9c3b68.jpg	t	10726.jpg
2965	1552	b5a9ce5a2477f98962e249e84088b911.jpg	t	10727.jpg
2966	1553	644442f4aba873ea8be17eec795eb498.jpg	t	10974.jpg
2967	1553	95e261a22f66f13bdbed82b897693818.jpg	t	10975.jpg
2968	1554	869b0129483389bf3d6b7fb6a86e5a8d.jpg	t	10970.jpg
2969	1554	1070eef99b8a582d48053379c75efde6.jpg	t	10971.jpg
2970	1555	068ad0223cdbf77d5116fac37b5c3d62.jpg	t	10730.jpg
2971	1555	4a3b752050368bdaeacdef4649807f7f.jpg	t	10731.jpg
2972	1556	c0074358525527b3a2828e1bc1b899ee.jpg	t	10963.jpg
2973	1556	d019a177eef9783b5b8933c829db604f.jpg	t	10964.jpg
2974	1557	928d68bd4c6f5c8e878e67d9183eaee6.jpg	t	10740.jpg
2975	1557	af69286413112bba79254fce4e9e1c4f.jpg	t	10741.jpg
2976	1558	39a244e7d3972b0ef12822780f5c2fdc.jpg	t	10976.jpg
2977	1558	074777bf818919fa3b18ef1eac93c522.jpg	t	10977.jpg
2978	1558	5c0a59ef444af76dc871d858f8d2f6ed.jpg	t	10978.jpg
2979	1559	b5345e349eedb36a8a6ec925cf400c03.jpg	t	11000.jpg
2980	1559	3d038e83e749d8ba4edd31e8d242b0bc.jpg	t	11001.jpg
2981	1560	2c8d58443229ca05f3977a463f3992fb.jpg	t	30656.jpg
2982	1560	c43d2e710b5914acfe2cda8d81a38ebd.jpg	t	30657.jpg
2983	1561	f629835a081f42571e4cf2912a352395.jpg	t	40543.jpg
2984	1561	a8ff1600c391eb1ef2c2ff37168dce9f.jpg	t	40544.jpg
2985	1562	4120bfd35bae84eb9b2161e4c72b5363.jpg	t	40535.jpg
2986	1562	46d416e5f0a0d611c7eedf351697a9c7.jpg	t	40536.jpg
2987	1563	a83b23756980fca248171146b7d78505.jpg	t	30662.jpg
2988	1563	8cb763fd6b05e4f3b3d0a80dc1578334.jpg	t	30663.jpg
2989	1564	8d7fe1e4e95520c84c9c1910e8f59bcd.jpg	t	30653.jpg
2990	1564	45147401f81845a684fc3966c940a298.jpg	t	30655.jpg
2991	1565	9e967ab7d043d4763e9d009e18c4d163.jpg	t	30654.jpg
2992	1565	45147401f81845a684fc3966c940a298.jpg	t	30655.jpg
2993	1566	939bc158303360bddc28cf63f6141df7.jpg	t	40539.jpg
2994	1566	5afa1bf2a0230c82fbf73af75615677c.jpg	t	40540.jpg
2995	1567	302ab402f7bae8f1f24a8bb042cb306e.jpg	t	40557.jpg
2996	1567	0287ff33b395cc77cbf64f7aaaf456c0.jpg	t	40558.jpg
2997	1568	47e36c3e95612af19fd292869c9701cb.jpg	t	10203.jpg
2998	1568	6f5da9094bd1d297a99b55e06d42720c.jpg	t	10204.jpg
2999	1569	9665d204cc34abf3429caeb238f3ed84.jpg	t	10170.jpg
3000	1569	97ae840acf09331a866d7ba91e60e02d.jpg	t	10171.jpg
3001	1570	10d7a2c910142518d159e349a063a546.jpg	t	10247.jpg
3002	1570	5f1a44772e21b597e6b14ca137002c9c.jpg	t	10248.jpg
3003	1571	91cd7bf1e17d13549c2f1a6d4c90ed22.jpg	t	10231.jpg
3004	1571	4310aa0ce752c42b25563be3ae017189.jpg	t	10232.jpg
3005	1572	cebf8f845fbdb79ca08d449f2631b95b.jpg	t	10193.jpg
3006	1572	eac734572affa7d2cc0de6d7aa14c414.jpg	t	10194.jpg
3007	1573	1b7234664cf62999276948c0513bf6ab.jpg	t	10182.jpg
3008	1573	a138f86b1771ef2e8e57e77257d82d85.jpg	t	10184.jpg
3009	1574	d7d1d60ecd07e23792f0546e1529e3eb.jpg	t	10160.jpg
3010	1574	0101f1f7ba38b894bbd7097154b36d55.jpg	t	10161.jpg
3011	1575	138b1e5ef505e1d422ec6e73b70061e7.jpg	t	10174.jpg
3012	1575	d62a740f9a111500a425f426be71ff4e.jpg	t	10175.jpg
3013	1576	6fe804a01b1a9123afa03b00193db981.jpg	t	10176.jpg
3014	1576	a58fd5d704b1c63e0f30b966e8be25cc.jpg	t	10177.jpg
3015	1577	282d9592dc3350b41ece2af7b611a1f8.jpg	t	10215.jpg
3016	1577	9c0af7350e7b951cdff4cac84c262e43.jpg	t	10216.jpg
3017	1578	d40e3bfe7291af63e0fb28409e4b2e0b.jpg	t	10213.jpg
3018	1578	cc00fef60cc4e5371db0acaa5bdd76c6.jpg	t	10214.jpg
3019	1579	4769a42d454db755f423f98653b47141.jpg	t	10209.jpg
3020	1579	94466e6636bd2c247ab8a45057cc96e4.jpg	t	10210.jpg
3021	1580	4961c83419ae01996534b9f87aceaaff.jpg	t	10187.jpg
3022	1580	5924be30f233a428bc2da906d61525da.jpg	t	10188.jpg
3023	1581	9675144c04cafc9ab38dc7a1f033f932.jpg	t	10199.jpg
3024	1581	a5c0de029233a9c30a2f65d655e8cd85.jpg	t	10200.jpg
3025	1582	6d993b6b1a7ba1c739d5c92ca40feb6c.jpg	t	10239.jpg
3026	1582	bf3f4b923e3fe6aac7f41be88c46d0cc.jpg	t	10240.jpg
3027	1583	40cf125229e425cf63799f464681751d.jpg	t	10235.jpg
3028	1583	8f70356dc8ae9f2334ab84ff5c930934.jpg	t	10236.jpg
3029	1584	61c7f2511740c2e4d35a302a5b5b426a.jpg	t	10197.jpg
3030	1584	4550ce40679b276db804ed14242821d8.jpg	t	10198.jpg
3031	1585	c9b1f1d6405f22e5ebde42b4df914a2c.jpg	t	10162.jpg
3032	1585	0a28b728931597fbd999414935e3bbf1.jpg	t	10163.jpg
3033	1586	403d77b34360858dd917fd0307773b63.jpg	t	10243.jpg
3034	1586	b11bc6e71807fbbfa36b91c95ff8d4b7.jpg	t	10244.jpg
3035	1587	bb7c6127523e5cbd3de90d86660b2d17.jpg	t	10225.jpg
3036	1587	d248307a7b1a69f55bd6a5626319a568.jpg	t	10226.jpg
3037	1588	75bacc81e93e60fbd6824c7392714c32.jpg	t	20583.jpg
3038	1588	f7d17213e9628d771c04824f7b80bb16.jpg	t	20584.jpg
3039	1589	14022536bcbbb7279068e2cb1a41a5c3.jpg	t	20605.jpg
3040	1589	55552cea98513320c287b24188817d4b.jpg	t	20606.jpg
3041	1590	26ddf7cb9b5db778cd68b6be0ebce9f0.jpg	t	30660.jpg
3042	1590	fe6958a7d87ecb72fec460342a1807b8.jpg	t	30661.jpg
3043	1591	ab4ac9392b29ec9387948a9cea8a4155.jpg	t	20615.jpg
3044	1591	5936738bba561408ad3d36db946254df.jpg	t	20616.jpg
3045	1592	22a9b8bca2c896215100290cebc45e5f.jpg	t	20597.jpg
3046	1592	80217315ef44f792fca6da9acbf03841.jpg	t	20598.jpg
3047	1593	d9dad7c47b7a18f632ad8da16b8e0226.jpg	t	20589.jpg
3048	1593	e147b614a2e0b15ede9e7695af3d69f5.jpg	t	20590.jpg
3049	1594	b233c0d1b3ba60ad630bced7543c6c32.jpg	t	20609.jpg
3050	1594	d0706455c97c6896694b936deaa23869.jpg	t	20610.jpg
3051	1595	980e2820a773740203899de29e6620d3.jpg	t	10397.jpg
3052	1595	2e4945a41dcf8919ec7487a0e2d47c4c.jpg	t	10398.jpg
3053	1596	33dd85edc503658663b9bbfba7246a17.jpg	t	10306.jpg
3054	1596	8c2cd6cdd178e0dcbcc65e01792dfdb9.jpg	t	10307.jpg
3055	1597	0b7991ddbca499b033ff0045df7a3460.jpg	t	10312.jpg
3056	1597	0b97e847bab1b3091e8e74d3e9e82e8f.jpg	t	10313.jpg
3057	1598	fd52e417a09d73f1ae3ad19011295425.jpg	t	10295.jpg
3058	1598	a35b9c3c5632cad9ee1d1c0712485623.jpg	t	10296.jpg
3059	1599	36ea72c05b3c7ec3c28fab57df2afa08.jpg	t	10314.jpg
3060	1599	ed0b18b73256342a4c39ff9de17bc341.jpg	t	10319.jpg
3061	1600	31fda07b2b1e8a72f9e2ccbdc160976f.jpg	t	10403.jpg
3062	1600	540b76b55a8253b59e71a913d7696b6c.jpg	t	10404.jpg
3063	1601	f2f12912cb495242e756c224c9413e72.jpg	t	10387.jpg
3064	1601	71ad11f74c767f2af630a1c37ae5097d.jpg	t	10388.jpg
3065	1602	b70466ab224c53278b5b196490d2885c.jpg	t	10337.jpg
3066	1602	dadb5f72c7042952e4e613fde7651b3a.jpg	t	10338.jpg
3067	1603	720f99fbf0c1d32737e31b506f6b6bd6.jpg	t	10393.jpg
3068	1603	9dabadd3ef5947a3562a4be1867d0157.jpg	t	10394.jpg
3069	1604	b8af55ec06d82bdbedff47ad995d6ab0.jpg	t	10386.jpg
3070	1604	71ad11f74c767f2af630a1c37ae5097d.jpg	t	10388.jpg
3071	1605	81f9fcbfc4aec941234a4c549cfb2da9.jpg	t	20240.jpg
3072	1605	358a64b1d432e7132f38b8d2ad54575f.jpg	t	20241.jpg
3073	1606	7a6428947de83b7a075047bd5e183c85.jpg	t	20638.jpg
3074	1606	2948047dcc923b363f143ce5c43e2320.jpg	t	20639.jpg
3075	1607	efbaa4d1fd1325e7a56037a9ad756f90.jpg	t	20656.jpg
3076	1607	4338fe1d1522126a9794c5ee56a0a3a6.jpg	t	20657.jpg
3077	1608	db603118e22159b176776eceb8b4689f.jpg	t	20652.jpg
3078	1608	56514a054cb2accc80184a725477295f.jpg	t	20653.jpg
3079	1609	88fcbbb1156006548cc3ca409bc52cec.jpg	t	20232.jpg
3080	1609	94b30eb6b1ae4441363337bbe6fe30ed.jpg	t	20233.jpg
3081	1610	e5d23736acd1c473be44094e02cd2d17.jpg	t	20246.jpg
3082	1610	645bc2fe4857c4ed244215fd750566ab.jpg	t	20247.jpg
3083	1611	e1d2ed5c8b4d429cab6b8dc9d4d93918.jpg	t	20250.jpg
3084	1611	1051341884aa6f3a2faf412b6d76eda8.jpg	t	20251.jpg
3085	1612	17d38273b4ac3cc81644f29c158a1db5.jpg	t	20650.jpg
3086	1612	30a011639351ad69f6468e9b1f20e932.jpg	t	20651.jpg
3087	1613	0395704a1909e56d07ef773d8a2955cb.jpg	t	30019.jpg
3088	1613	419b60fb0b8dea5eeda78367cd3cc03a.jpg	t	30020.jpg
3089	1614	3b4a7cf94366891fe07c0746321781c7.jpg	t	30023.jpg
3090	1614	bca56df89fbfee2c507a943dae4c85d4.jpg	t	30024.jpg
3091	1615	3c75d6fa862965af5f13b6e663088fb3.jpg	t	30794.jpg
3092	1615	7db6552a759614116aef9a209f03a8a8.jpg	t	30795.jpg
3093	1616	53756014870b04928dbac5f320c2c099.jpg	t	20362.jpg
3094	1616	d76832c2e9b0c5b6f26cf134fe8686a3.jpg	t	20363.jpg
3095	1617	b20c8a5d96e881fd1b748ed6e72f37b1.jpg	t	30007.jpg
3096	1617	f0697bd74484920dd9e44cd0182b1f99.jpg	t	30008.jpg
3097	1618	28e459ede6eec4d08667a43fea747976.jpg	t	30059.jpg
3098	1618	b69e4d9cd263e31ed8870871fec35548.jpg	t	30060.jpg
3099	1619	7c0a851506c60174367bb6da4185dd28.jpg	t	30011.jpg
3100	1619	fcd185d6f4f24a967498953c97927689.jpg	t	30012.jpg
3101	1620	5b0c0d3a525c71ecb30234a91f80c9a1.jpg	t	30788.jpg
3102	1620	110509e69d467324f697181c3133d7c9.jpg	t	30789.jpg
3103	1621	e2711bef43b859e1ab2450c87c4a69fb.jpg	t	30796.jpg
3104	1621	069d9612478ecc2a452c0d6d604a8c41.jpg	t	30797.jpg
3105	1622	d4c768f138c45b4611404c501bdb95e0.jpg	t	30001.jpg
3106	1622	5327cd6e107f93c07a6cb34dd699c30a.jpg	t	30002.jpg
3107	1623	40fb349e61e2fb8a23835da5c12f56f3.jpg	t	30031.jpg
3108	1623	0e381c60d9ad4771cff0804781a7c452.jpg	t	30032.jpg
3109	1624	7bc0f49f4fdad50d56701697989f5d81.jpg	t	30804.jpg
3110	1624	6252186551217747acfcf1e05296c865.jpg	t	30805.jpg
3111	1625	deaf37e620fd5cdd02e993f2375ab019.jpg	t	30025.jpg
3112	1625	f9ac4e869e2d66b593ce5ce0fe9cdb47.jpg	t	30026.jpg
3113	1626	7ad8a4aa598ce288499d9ea3a498c135.jpg	t	30043.jpg
3114	1626	4e6a6a9afe41dbc6315ede443ac0a48c.jpg	t	30044.jpg
3115	1627	27d28893fb009581830f810fdcadbb82.jpg	t	30802.jpg
3116	1627	e4721e6dfc630d397b4d3a3e511def29.jpg	t	30803.jpg
3117	1628	8377fb2d7adc12e0cd4db906071aa7c6.jpg	t	10808.jpg
3118	1628	e8ef66a5ec9aa1526fcbe3b28ed79bb0.jpg	t	10809.jpg
3119	1629	8bfa4362007f2542fd91e34a6373b879.jpg	t	30035.jpg
3120	1629	9e3b0a68513624ea8bdfe4e45a47160f.jpg	t	30036.jpg
3121	1630	d4c5d3b724fba1f959dc77e0e8499259.jpg	t	30039.jpg
3122	1630	9ace8182f5b1be3f161806c2f9ad6975.jpg	t	30040.jpg
3123	1631	2ce8f223c00d1a35085a57e5a7b3f805.jpg	t	10263.jpg
3124	1631	4fa04cb8b36ed25a78edddea5d1ac5f4.jpg	t	10264.jpg
3125	1632	326a2d5fe2614eae0bb54b66ff148ebb.jpg	t	40517.jpg
3126	1632	664e9ca3b9845b9d34889bfc67330a98.jpg	t	40518.jpg
3127	1633	dd996d80e90de9f9d77dd28dcdeb5a46.jpg	t	10150.jpg
3128	1633	237ae34ed84bc6f073ae08dccdf5c373.jpg	t	10151.jpg
3129	1634	793627e935eda476aecb167a26e6a332.jpg	t	40533.jpg
3130	1634	9b82a33918efcb5620d7f9818956ff66.jpg	t	40534.jpg
3131	1635	a50bd85a4ff708a1653b9b3a73663fca.jpg	t	40527.jpg
3132	1635	c826f2200d80aa733425ee2e7187f996.jpg	t	40528.jpg
3133	1636	20866498798c71725c70bef5dee6c9f0.jpg	t	40523.jpg
3134	1636	d4c0e38465af8024d86a2f537530e2a2.jpg	t	40524.jpg
3135	1637	bb95e24ab095de8e9fae3a2e550a8859.jpg	t	40513.jpg
3136	1637	29a500163b83103d77d901ad748f511a.jpg	t	40514.jpg
3137	1638	0d080cfd4fe643f217722760bfd67bd0.jpg	t	10279.jpg
3138	1638	f62d9bc36e36210f1a0cb6e753e3e13b.jpg	t	10280.jpg
3139	1639	a1c6b5493ed41b47e3a5aa8251092106.jpg	t	10273.jpg
3140	1639	2e7637cef15590025bf00007a7aa43a1.jpg	t	10274.jpg
3141	1640	6e771510bf51a1dd1654d51c8613729d.jpg	t	10271.jpg
3142	1641	5773cc8cb539f5a3a66f993b78480f08.jpg	t	10696.jpg
3143	1641	ef9dd309daab69735090b1114533ca5a.jpg	t	10697.jpg
3144	1642	ae054c3b34fffd544e515c8a3d37bdf0.jpg	t	30109.jpg
3145	1642	f8cf5733ec3934933962bb8c729a3452.jpg	t	30110.jpg
3146	1643	b699a26d29f17e17e6cd22dd1805ddff.jpg	t	30103.jpg
3147	1643	e160a3471775e1079061b74384c2acd2.jpg	t	30104.jpg
3148	1644	eca64b2eab63e5e2c2215cba204a2893.jpg	t	10690.jpg
3149	1644	3deb6acef4f1663869ce8ce6b834c952.jpg	t	10691.jpg
3150	1645	0be672abda260b2a2538f014eade9900.jpg	t	30089.jpg
3151	1645	c2fe197148c4ad3e93a41327de186884.jpg	t	30090.jpg
3152	1646	87a846593e63707c3dfa242de53b0d77.jpg	t	30093.jpg
3153	1646	b589f09baae6a077172a351d2c93d08e.jpg	t	30094.jpg
3154	1647	e08434fc3b494ebf054d8a6ea7188644.jpg	t	30107.jpg
3155	1647	b1a4c3aea66c1539a4cebb40e5c7350a.jpg	t	30108.jpg
3156	1648	b24b0433e5ac4b99b67cd796a52ec090.jpg	t	30726.jpg
3157	1648	22ec3210ab59992547d4910b971d7592.jpg	t	30727.jpg
3158	1649	9cdbe438e42b95c556333fc5583f9983.jpg	t	10347.jpg
3159	1649	e955e1d807622b78dfa1f703bb088061.jpg	t	10348.jpg
3160	1650	d42cf132a0f4c716a0d07c9fada3d214.jpg	t	30736.jpg
3161	1650	827c6159948ec0e99e0c6312010d030b.jpg	t	30737.jpg
3162	1651	929ed322df9406d5c9e62be61bccd88c.jpg	t	20310.jpg
3163	1651	e215f1e6d7c07028ba31006a48905d30.jpg	t	20311.jpg
3164	1652	e95652c368fa7e166d92d91c8312f3cd.jpg	t	20300.jpg
3165	1652	91125e10edd9219a9b07abce455ab907.jpg	t	20301.jpg
3166	1653	ece7ec6560a0122a0eb71b12e266c5d1.jpg	t	30740.jpg
3167	1653	fed77104fc93b567ddc56700d4f27e69.jpg	t	30741.jpg
3168	1654	f6b665fe77069d7d2a577a7480ed3e9c.jpg	t	20304.jpg
3169	1654	592c6236cdcb9f729990c8509b84fca7.jpg	t	20305.jpg
3170	1655	5c1ec0a47d035fbdf2d4e3980b033ee4.jpg	t	30746.jpg
3171	1655	1894ea46ef964bdaf8a8fbd2ef0f3b43.jpg	t	30747.jpg
3172	1656	b469a20f8d50052daf456c562dd59c09.jpg	t	20318.jpg
3173	1656	a304a95f201e1e6e55798fa14baadcb4.jpg	t	20319.jpg
3174	1657	711cd6c0d5d887ff26a1fff3f1c35567.jpg	t	10361.jpg
3175	1657	37a4af0fd6a73e004799c32f89e071bc.jpg	t	10362.jpg
3176	1657	fcd2a14a480b3a28c27358d3c59fcbc8.jpg	t	10363.jpg
3177	1658	cd416d16b04a252275cf136952871f71.jpg	t	20314.jpg
3178	1658	94c497bb8b60dbf2adffe671105d8020.jpg	t	20315.jpg
3179	1659	338b491622340d25964f7ef0e2dde70c.jpg	t	10353.jpg
3180	1659	5d35c71995f149dfaf96807892d09163.jpg	t	10354.jpg
3181	1660	fa23ccc4bdebafda26686d613ded6406.jpg	t	10364.jpg
3182	1660	c2dac99095d718b57fc9bb306c43d84b.jpg	t	10365.jpg
3183	1661	8ba6317b578a99f1d5296b192572b1cb.jpg	t	10156.jpg
3184	1661	261c0373ea072406c3cd2025868e4b53.jpg	t	10157.jpg
3185	1662	cad175d287aaa614cfbff86e28ad7bf7.jpg	t	10221.jpg
3186	1662	7b0d49fbf0257c52dc9896dff86d6427.jpg	t	10222.jpg
3187	1663	fb939d1f004f7e7a428128572accd7da.jpg	t	10265.jpg
3188	1663	587246868e426eabeab90e928912f0f5.jpg	t	10266.jpg
3189	1664	ac985f396c508cf875af133222001fe2.jpg	t	10256.jpg
3190	1665	ba1e9e360bd543e96da9bed277d93fbd.jpg	t	10968.jpg
3191	1665	54939957fee4c5d90dde08c634c70eac.jpg	t	10969.jpg
3192	1666	840f68a8389e3e0352ebf5392a84718a.jpg	t	10291.jpg
3193	1666	2fea4453e404c1f10f43265adf8b5c52.jpg	t	10292.jpg
3194	1667	ed4fcd5170f3a51e64d2636d86e54b04.jpg	t	10283.jpg
3195	1667	4b0dedde52bc00b860d2d6ae8a5a753c.jpg	t	10284.jpg
3196	1668	ba58bfdd095e434d616a958e4b994ea5.jpg	t	20334.jpg
3197	1668	0ae78f3f6b6beddc431155f0c26cbdcf.jpg	t	20335.jpg
3198	1669	34e8cc42b498ab952fbb150bf168dc23.jpg	t	20320.jpg
3199	1669	ee323dbd64691b4dce702ed08a77d92a.jpg	t	20321.jpg
3200	1670	3daca29d01665ac41dedf1ca6f25ca4d.jpg	t	20330.jpg
3201	1670	b4371eda10600939a18d0116bd788fbd.jpg	t	20331.jpg
3202	1671	606978f064dd645c56ab771c3128d2e1.jpg	t	20328.jpg
3203	1671	42d391fe6e7ce36c17bc365160141fc1.jpg	t	20329.jpg
3204	1672	ff47b773c2518a77f7626b1ee4930f00.jpg	t	10287.jpg
3205	1672	ce22a50c0e4c299a1ccf2c05fabd5865.jpg	t	10288.jpg
3206	1673	9922a0604c3f5b6997c2b1066d9af6b6.jpg	t	20396.jpg
3207	1673	7b361571b68d7d05fb0fba56df60b8d1.jpg	t	20397.jpg
3208	1674	d9fc52509a1931394b4370585e031beb.jpg	t	20402.jpg
3209	1674	fcbed1f11a32b03c5ef27cd1d5b76394.jpg	t	20403.jpg
3210	1675	3f6329056ebd8ea8b98e56a07672a3a7.jpg	t	21508.jpg
3211	1675	97bfd6fe621a8e3fb8fb8f00532ecd18.jpg	t	21509.jpg
3212	1676	d0678175ab50c0a3f10ace855738c6f1.jpg	t	20398.jpg
3213	1676	09a4f11ffcfa6a75531460081d01b4fe.jpg	t	20399.jpg
3214	1677	fa48b7dd28def20dda8ab0e3f92235ef.jpg	t	21390.jpg
3215	1677	6d92b55d4a0c67cbe9e0c5e5d6aa6902.jpg	t	21391.jpg
3216	1678	b0fb756054b96d3ef426772c1cd7b9b4.jpg	t	21392.jpg
3217	1678	2d1d77716a58d867f095eec4c5154010.jpg	t	21393.jpg
3218	1679	98dd0bb7aeb75ae35755aa9b095c468a.jpg	t	21408.jpg
3219	1679	182232d13ebb424c7cd8d6efd445776d.jpg	t	21409.jpg
3220	1680	52745de3bb1501edf92582c0825ae038.jpg	t	20723.jpg
3221	1680	98ea6dad3b3f015530edf0f01bd24b08.jpg	t	20724.jpg
3222	1681	603a526d5f4bb0a3d10c0967f1c2c7c2.jpg	t	21410.jpg
3223	1681	76d61a31ee60dee54ea68c2bb0c2f066.jpg	t	21411.jpg
3224	1682	b5b187c2caa678c8208b533d3c01ff23.jpg	t	21396.jpg
3225	1682	75d41fd54f55710c482e2a8373bb85b4.jpg	t	21397.jpg
3226	1683	c34e6147bd28b7b399329c783d4adf35.jpg	t	11378.jpg
3227	1683	d6d8fd0dd041cbc639494443330cb0b0.jpg	t	11379.jpg
3228	1684	91d107156089e40675b48481b6138c25.jpg	t	11386.jpg
3229	1684	ada4edc8a56b54eae3d1d0d12cada582.jpg	t	11387.jpg
3230	1685	4dcaa802b4624c8f16c127d493a69ab0.jpg	t	11372.jpg
3231	1685	950baad2dbaf38a723eb187cfbd03a8c.jpg	t	11373.jpg
3232	1686	03bfc3c9e6c5230418c019784bfd71c3.jpg	t	11380.jpg
3233	1686	d86f80e79ef9801a28f620e1a5ca793e.jpg	t	11381.jpg
3234	1687	1587447a7413cdac407382abc3a09e3a.jpg	t	20743.jpg
3235	1687	ad4a5cdbe8c225085de056285474e40d.jpg	t	20744.jpg
3236	1688	985f601afbcd7a70bb7607e01ec80d64.jpg	t	10258.jpg
3237	1688	3a2719c4e5f45490121162e8a1899a5b.jpg	t	10259.jpg
3238	1689	07ba150ca9eced0faeba08d5645ec0f3.jpg	t	20718.jpg
3239	1689	1588ecd927881c8914e8dcc659f6750a.jpg	t	20719.jpg
3240	1690	cd18f9e47dabe5d12abccfa454ee7ec4.jpg	t	10464.jpg
3241	1690	3c490ffcb7748d9646a8a5e2f123fc53.jpg	t	10465.jpg
3242	1691	d11bd52b0ccb049d390c8541c7bfd11c.jpg	t	10471.jpg
3243	1691	7cec1057609282dfe312ddb5db9586b8.jpg	t	10472.jpg
3244	1692	9d3cf0213076a8bdb6eccebb885ebf2e.jpg	t	20739.jpg
3245	1692	87d26c0efc91a352d711817c234dff08.jpg	t	20740.jpg
3246	1693	22b0a3077cc0812a46ffd62ee1573737.jpg	t	20716.jpg
3247	1693	d20fefbc345ffd562568f964fa9c32b1.jpg	t	20717.jpg
3248	1694	4592d9c2b3405f38daa3309b3b37783d.jpg	t	20706.jpg
3249	1694	cc43db4a5cdb08c9f617f69221802126.jpg	t	20707.jpg
3250	1695	de122a33995fa7056540fcfafda06108.jpg	t	20727.jpg
3251	1695	0cdca2f9dd089ad98c0dfb07a8e7333a.jpg	t	20728.jpg
3252	1696	a67d5f8a240a5dbbed7322ded27cae91.jpg	t	20710.jpg
3253	1696	80e6c713e83651c9e2200eaa27e5a380.jpg	t	20711.jpg
3254	1697	8e2c160fba8911bc4691d480a9fa8631.jpg	t	20735.jpg
3255	1697	68e60e63c73f9fbe754a8835cf556558.jpg	t	20736.jpg
3256	1698	fc3de5aaf96080daf51004981e141b04.jpg	t	20733.jpg
3257	1698	a94a8da9c90cc0db88f1c078576c9b35.jpg	t	20734.jpg
3258	1699	d54c6c3400d84380888806cdbab43f05.jpg	t	10454.jpg
3259	1699	cada84d2ce08e4a8614ed9a5c09cc191.jpg	t	10455.jpg
3260	1700	5dbaefeca139a68ea0ead6e8aeb86fd0.jpg	t	10462.jpg
3261	1700	46173b3c4ae5b4d9b77f59cbcf9b74b6.jpg	t	10463.jpg
3262	1701	40165fda817158ebdeb896793321e819.jpg	t	21298.jpg
3263	1701	f8ac398ca0338413e36ffafcecbc1958.jpg	t	21299.jpg
3264	1702	f29eedb105a287a6b41105cd3c840f8c.jpg	t	20714.jpg
3265	1702	ff48470c4a5d4ac73500da2dd8ac260d.jpg	t	20715.jpg
3266	1703	b1ab4cdeec836553e3b8f7f4e3e5f2ec.jpg	t	20354.jpg
3267	1703	287edc8368ac559b71eadf3b3f93511f.jpg	t	20355.jpg
3268	1704	878e3d12643c9217d8d4ea763a8a3f07.jpg	t	10437.jpg
3269	1704	c93b924cb52e13350cc6c19b5ea9806e.jpg	t	10438.jpg
3270	1705	0c4f04b7e80b04a25747f40ff2e1f1e4.jpg	t	20729.jpg
3271	1705	2457210a63263e2bc1a5079f277f9622.jpg	t	20730.jpg
3272	1706	39430dddaca4b557e28c191f77262751.jpg	t	10415.jpg
3273	1706	cc1801b7d7b12bc0cf02360db58843fc.jpg	t	10416.jpg
3274	1707	c19d67e0f956eaba9f1d690366dcdea4.jpg	t	10431.jpg
3275	1707	9a72dc788274ebf05637a17bfcba5d9b.jpg	t	10432.jpg
3276	1708	7ee70a39e136b2b077cf011c6bcdd95c.jpg	t	20731.jpg
3277	1708	3230b78ea52a4776f6d578ee797b73d5.jpg	t	20732.jpg
3278	1709	6b1cd05316483d47b9c181141a25caf9.jpg	t	10450.jpg
3279	1709	8ffb33bba3dd0b7eabe5e7b6ca50e8b0.jpg	t	10451.jpg
3280	1710	68ec5ec6f0f4573b0510a78de0eb4ff9.jpg	t	10446.jpg
3281	1710	d717cce6d131bef9ef093b990131210d.jpg	t	10447.jpg
3282	1711	aa71531e7bda28777da2cb15cb00692e.jpg	t	10460.jpg
3283	1711	cd05001f9530ee94fe0966f1daca88a9.jpg	t	10461.jpg
3284	1712	38e8d982fee33d384dad8eb8becde149.jpg	t	10433.jpg
3285	1712	4dfeb456f90dfa4c820a3570a2cf9c48.jpg	t	10434.jpg
3286	1713	65d670a4efdfa7b23e479c11406eb062.jpg	t	10427.jpg
3287	1713	66799e8a84dac61a113dd665c30cc60b.jpg	t	10428.jpg
3288	1714	944a6ae81eb4d4d24b3e5920db2b47e3.jpg	t	20725.jpg
3289	1714	dea45de1bab38168d3443ad4aa5d84eb.jpg	t	20726.jpg
3290	1715	bbb5fcd1f523bd9a4ece9d8f502494d1.jpg	t	10411.jpg
3291	1715	abd5790f24c27824a89616081ec7107e.jpg	t	10412.jpg
3292	1716	ad8158b1627171d455a26b4f3feee577.jpg	t	10421.jpg
3293	1716	99c608a5d30d06f691076a33704e8a72.jpg	t	10422.jpg
3294	1717	8a14ad95cfc4e17c148b002c0190ce13.jpg	t	20741.jpg
3295	1717	c8fbc4a4d3a856aacb014fa579823cba.jpg	t	20742.jpg
3296	1718	ba24ec83539f75d31b467be41c156f96.jpg	t	20038.jpg
3297	1718	3b8c042ea79d264797fea77f61f5f010.jpg	t	20039.jpg
3298	1719	e1c6896018778af3f1752592c15d0bc5.jpg	t	20046.jpg
3299	1719	18926d888bc2e13acef53dacdaf6aa15.jpg	t	20047.jpg
3300	1720	a2be1a73aa568c49c59995ccd8334731.jpg	t	20066.jpg
3301	1720	86b84e3e6c85757dd48c133a132361f9.jpg	t	20067.jpg
3302	1721	b6d3f21c55419da06865c2ab677cc0ea.jpg	t	20092.jpg
3303	1721	4deda0c5ebd63e992c2db54f2eb93824.jpg	t	20093.jpg
3304	1722	6136f81a88ceecd55d553132a652e20e.jpg	t	20114.jpg
3305	1722	90a556a488136fb9659e060d44eabec9.jpg	t	20115.jpg
3306	1723	f5765083a98c3d045b86bd6ac7a5a253.jpg	t	20056.jpg
3307	1723	bb76564ce6622346dd7c73ab9903e117.jpg	t	20057.jpg
3308	1724	7f8621105b7678f45fadf397de301699.jpg	t	20068.jpg
3309	1724	7aee760062f962440b673b9a05bf9167.jpg	t	20069.jpg
3310	1725	1e4b26fc319901232497ec1bbbf2c6de.jpg	t	20062.jpg
3311	1725	af955dccca038e607cfd93b5d6e2f8f0.jpg	t	20063.jpg
3312	1726	6e6a06ee9e42335681632278a51716d7.jpg	t	20052.jpg
3313	1726	09dc33a994cf6853cae6a5bcac92df58.jpg	t	20053.jpg
3314	1727	2521214ba31c7d0dc2f9dad6f071ed81.jpg	t	20044.jpg
3315	1727	a5ede5115a1b2ca5688c86ff63f957d7.jpg	t	20045.jpg
3316	1728	7ee9e4000f6c5546220e22584f2e2294.jpg	t	20050.jpg
3317	1728	7f187896473dd8ebe50eb88948c27c2b.jpg	t	20051.jpg
3318	1729	3162b6ea4b93a6a7350acf99ec7e3462.jpg	t	20094.jpg
3319	1729	66fbf031b9269a1ac9458516e744bd73.jpg	t	20095.jpg
3320	1730	fe43fafddb8b5dd4805546eff8918377.jpg	t	20098.jpg
3321	1730	356c6dfa5ebf309f55ac027783d1aa17.jpg	t	20099.jpg
3322	1731	dae02d675e23a2d3d7b76a12edf76e5b.jpg	t	20106.jpg
3323	1731	d5e1f3f341038a48a6630481d604f956.jpg	t	20107.jpg
3324	1732	784b61f541c78f6698998b6333f9ff41.jpg	t	20100.jpg
3325	1732	a0ef9acb2e8154c60feff649c867bc1f.jpg	t	20101.jpg
3326	1733	1b832dc72b62ec4f5289a159dd1251d1.jpg	t	20042.jpg
3327	1733	d047bcb173f92af70c90c08cdca96cb8.jpg	t	20043.jpg
3328	1734	ba7eae73afb14460ac35d433043f4766.jpg	t	20080.jpg
3329	1734	0d9672a8442a1756884d88658e4a38a0.jpg	t	20081.jpg
3330	1735	a80abb0dc03aa7ca283ca5674d4bf387.jpg	t	20006.jpg
3331	1735	dc31099d6379ee752052e12102cd7ae2.jpg	t	20007.jpg
3332	1736	50248c9db441b27ff2bdfa2746b4260b.jpg	t	20020.jpg
3333	1736	b715f015152a3017f815195450b16794.jpg	t	20021.jpg
3334	1737	700e86947cc49ee90906bdae19c11d69.jpg	t	20086.jpg
3335	1737	203425d1211bae90d967d0ee1a01339c.jpg	t	20087.jpg
3336	1738	fdba249971800e6dcc0a92410a433caf.jpg	t	20028.jpg
3337	1738	2c7d0be15b7ece460da2f8c68428d7f1.jpg	t	20029.jpg
3338	1739	092ab21c3ba31eb581685537b4d73f68.jpg	t	20072.jpg
3339	1739	3b235c6d213dccfe607b9d40e941797a.jpg	t	20073.jpg
3340	1740	8032e183a5f6b5bdfefc6c999199a452.jpg	t	20014.jpg
3341	1740	1b22bae483d40acd269937d19b20f3d5.jpg	t	20015.jpg
3342	1741	cbb7a27ee1e893f6f4082ccf5f6a41ad.jpg	t	20004.jpg
3343	1741	e04bac210c2510b45d5170e7fa4a3bee.jpg	t	20005.jpg
3344	1742	7402e6b1ca981a553cf830647352137f.jpg	t	21354.jpg
3345	1742	ce17557dbeebe47b55fcee9435513a83.jpg	t	21355.jpg
3346	1743	9b6c721464bb5fd8b68840cebceffe3a.jpg	t	21428.jpg
3347	1743	560843579b495b1c55282e2931a41a44.jpg	t	21429.jpg
3348	1744	91d38eb39ca3de727192979376714b0a.jpg	t	21426.jpg
3349	1744	3e7f7618abd1ecc3b38893a9fb2ac8ed.jpg	t	21427.jpg
3350	1745	7e0f8c53ef6596a63f3a76e923896ea3.jpg	t	21424.jpg
3351	1745	f8a588c8f486e8d21966e0bb57613cca.jpg	t	21425.jpg
3352	1746	ca853513a18248e5e3faaea60fbbb08e.jpg	t	20390.jpg
3353	1746	fd3d27353c747571383fba861d471056.jpg	t	20391.jpg
3354	1747	3c4ad3bc350693c48dae3b6dd754fcfd.jpg	t	21340.jpg
3355	1747	bb8cdb0076b4a00192bd5eb373cd3574.jpg	t	21341.jpg
3356	1748	85bf174a7c894322c187ea3ad51b8415.jpg	t	21416.jpg
3357	1748	bee12412716a7cec3bc7760401590a73.jpg	t	21417.jpg
3358	1749	a615159f4a80d26b4d22271e93ceb019.jpg	t	21350.jpg
3359	1749	f64e28ea283ec95d7b5ce6b59ceee81b.jpg	t	21351.jpg
3360	1750	480ca591b0d995280f3acaea823ca152.jpg	t	21422.jpg
3361	1750	d1ea40024ef4024a795eaaa9be29dca6.jpg	t	21423.jpg
3362	1751	c8bd6dfccd2749e09be28a734cecd4bb.jpg	t	21352.jpg
3363	1751	5bcc8948f5777bcc2f1503d95fe0a0f7.jpg	t	21353.jpg
3364	1752	c7d17838a57ef98adb3caaddcb0109a9.jpg	t	21324.jpg
3365	1752	43e4ca1579a52f44dad901b6896e02e7.jpg	t	21325.jpg
3366	1753	c3796887fcbf8094ff9acbe37a0dd92d.jpg	t	21322.jpg
3367	1753	13ddd6536accf9b1955c65b39eff47fa.jpg	t	21323.jpg
3368	1754	e8f05ac30454f220d30316a21f4ed455.jpg	t	21336.jpg
3369	1754	765ce085b5e426c1bb4f465d214a6642.jpg	t	21337.jpg
3370	1755	eb56bc5e583d772e59f92ee323ee109f.jpg	t	21328.jpg
3371	1755	756adeaa9dad2240d680e210242e37c5.jpg	t	21329.jpg
3372	1756	067122ede780f03b158098d7f4c4dfe3.jpg	t	21330.jpg
3373	1756	4852d1f27cf55a5c04a1fdcfa51a0830.jpg	t	21331.jpg
3374	1757	69d10229a973ecede7a471b6f9604e84.jpg	t	21432.jpg
3375	1757	9bd1783499524ec56847ad7a5ef5f70e.jpg	t	21433.jpg
3376	1758	823035d0ad06309211a4c002ed736ab7.jpg	t	21434.jpg
3377	1758	838ce6524042cb694fb1be5673a882c5.jpg	t	21435.jpg
3378	1759	53fe7c40586a5d9fde27340b6f32f31f.jpg	t	21418.jpg
3379	1759	88008585ad63d8bf26de3ba0b8747ffc.jpg	t	21419.jpg
3380	1760	d5d4edfe6717891cd8f6b261773c6c02.jpg	t	21334.jpg
3381	1760	f4d6cb96af3704e0e1fa866013e13a54.jpg	t	21335.jpg
3382	1761	69c2a24c785fa86208801e575c93abb4.jpg	t	21414.jpg
3383	1761	29f9a8c24b67f48cecf920a890831137.jpg	t	21415.jpg
3384	1762	9e6087fbc9b4f0c9a5d5b112e6af2c63.jpg	t	11462.jpg
3385	1762	b5056094a532657232ba8f42f27f6a73.jpg	t	11463.jpg
3386	1763	1caca5a7c6bbe4cf0dee9114d81374e6.jpg	t	11420.jpg
3387	1763	b1a527d24b1d1e39c9facda5258f1227.jpg	t	11421.jpg
3388	1764	62c418be4442bb0c6a2d224d52f3d3b3.jpg	t	11442.jpg
3389	1764	27e858519f34c581b50c095ce95eeeeb.jpg	t	11443.jpg
3390	1765	829279610801c1fd7b85be7bb2f5e06c.jpg	t	11444.jpg
3391	1765	98b0f64067e71fdd5e4bc72bb09c1bde.jpg	t	11445.jpg
3392	1766	871ce8a55fd9761c99cd8722290432ef.jpg	t	11470.jpg
3393	1766	8d693bbc2de102188b8378c1bf82b0cb.jpg	t	11471.jpg
3394	1767	ae7e78db5836e223c013241406189e76.jpg	t	11476.jpg
3395	1767	38e9dda3ed629ff64021432904b6f4a4.jpg	t	11477.jpg
3396	1768	d9a724b763697664052e9af283b185c4.jpg	t	11492.jpg
3397	1768	1461b62cfcb9cfd13c7946b278f621dc.jpg	t	11493.jpg
3398	1769	f48236e22db608680c609040845f6634.jpg	t	11432.jpg
3399	1769	740d048e6c19f68caea2b2663446574d.jpg	t	11433.jpg
3400	1770	71edae17a933df4b04ceae66ce44166b.jpg	t	11424.jpg
3401	1770	8472d690e166de432a80815e1e13c288.jpg	t	11425.jpg
3402	1771	3a5e8a106e3ad600fc58435a2a273135.jpg	t	11426.jpg
3403	1771	80710cf9dd7033185482f5950a4a8332.jpg	t	11427.jpg
3404	1772	7bf40013561e12c0de816052e0365d51.jpg	t	11480.jpg
3405	1772	a32abb9690bb39ec8b188b4de4b7f44d.jpg	t	11481.jpg
3406	1773	7eb79cc396a08534cea50bc05ec50502.jpg	t	11466.jpg
3407	1773	36c8b9d9e9706d6273b86baaa2b4f405.jpg	t	11467.jpg
3408	1774	f22a9a1d69590a685d947952df9505ad.jpg	t	11472.jpg
3409	1774	3ef2817d99b07c498e8c8fa704a50d46.jpg	t	11473.jpg
3410	1775	c7dc554a839930a49d908f45502ed790.jpg	t	11488.jpg
3411	1775	59c710d887a8eacb6aab5058de39ea62.jpg	t	11489.jpg
3412	1776	6604d0a6024d3e0c7b836a06b7d49af5.jpg	t	21344.jpg
3413	1776	ae2b668988017ebaba48e094ee32d7ae.jpg	t	21345.jpg
3414	1777	776f9c3b1198c71f9edaddcaa9eeed7d.jpg	t	11436.jpg
3415	1777	50ce15923bea758f4c1d1c27f12a7a4b.jpg	t	11437.jpg
3416	1778	9db4e0f40a328092c3112bdc76fb6b76.jpg	t	11448.jpg
3417	1778	276123947c323329b19d0adf54424c7a.jpg	t	11449.jpg
3418	1779	4af6fe04724ec69269c48a8193d09743.jpg	t	11414.jpg
3419	1779	76c0409b39b0d5ef80e5758f157e36e8.jpg	t	11415.jpg
3420	1780	f5536b917e8820078aa15090d8fa8084.jpg	t	11458.jpg
3421	1780	963ecd5bc46a2df52b70e3c6a7a4322d.jpg	t	11459.jpg
3422	1781	f906abf0c2b77b7de1862ef26baa900a.jpg	t	11452.jpg
3423	1781	12c97dca46f37be6f1ebf29a8b731d53.jpg	t	11453.jpg
3424	1782	35b4f35b43a733635b3783bae3dd69dc.jpg	t	11484.jpg
3425	1782	17489b133b6c1e5d27e04edd72e56406.jpg	t	11485.jpg
3426	1783	05e0ac446fef68d375ed39fcae087352.jpg	t	11494.jpg
3427	1783	425779c9b52ce5f120ca6ad7f3f9e31f.jpg	t	11495.jpg
3428	1784	b1b596c59ba8ef420fecf16f236a56ce.jpg	t	21304.jpg
3429	1784	d2386678839b2d0c55a5ac28f3a7f3f7.jpg	t	21305.jpg
3430	1785	59824e992cb8be57d740974511268ea8.jpg	t	21316.jpg
3431	1785	a20ed8d47d54ec6c18ff8c94175c5d66.jpg	t	21317.jpg
3432	1786	4286572a8f279b97dada8fb5e8619f3b.jpg	t	21306.jpg
3433	1786	d721f1ee291d18ddc8cec9f35ca6fda5.jpg	t	21307.jpg
3434	1787	bcc1b4455ec330178de6610fed508b36.jpg	t	21099.jpg
3435	1787	4afdebea620bdfdc904cd0f1aefcd347.jpg	t	21100.jpg
3436	1788	c8bffb45784bd4f0f40e2af14873074c.jpg	t	21109.jpg
3437	1788	e60ddb08500aeead2ddc732d082add26.jpg	t	21110.jpg
3438	1789	89cdfb46792d50da957c460b91c6d2a8.jpg	t	11392.jpg
3439	1789	f1d139798bfb1c618d748e0d7da8bab1.jpg	t	11393.jpg
3440	1790	af6897834102bcf7de21e3b045000d4b.jpg	t	11412.jpg
3441	1790	08dfed36a7bbcb8b4c19c4cd165c3b81.jpg	t	11413.jpg
3442	1791	0b5fd9c5388b5d81bae771bbdaa8a5f5.jpg	t	11406.jpg
3443	1791	0e4fdc75e929dc658f421ba560a4c550.jpg	t	11407.jpg
3444	1792	182bf21c70671b0bdb3bf978dac7464a.jpg	t	40575.jpg
3445	1792	7f4828ff98e1e035a84b2699f7f281e1.jpg	t	40576.jpg
3446	1793	94d89e323a3d17d251554c93257f394a.jpg	t	40567.jpg
3447	1793	ad31b2f2aecf49ad1fe41961e5c2b5f6.jpg	t	40568.jpg
3448	1794	7c1bd22bc38e0798830a3ae22c5a6e6f.jpg	t	40581.jpg
3449	1794	0febdd4503942f7335a39126f9de8f5c.jpg	t	40582.jpg
3450	1795	b6dbf0ac706ef1b5c666ead36891e3a3.jpg	t	11388.jpg
3451	1795	76d03d725abc2fb8c0c908d4b5eefaef.jpg	t	11389.jpg
3452	1796	70ad58b4c7cd8db814b7b3e0650a7580.jpg	t	11398.jpg
3453	1796	2e887afa50bf913bac4a481de4ce37ea.jpg	t	11399.jpg
3454	1797	e274d5d27dac87b4635408a6a35035e0.jpg	t	11400.jpg
3455	1797	3e0c1f41b5539cfb165154c5cb9e1305.jpg	t	11401.jpg
3456	1798	9856f089473f4b4f7ab9f1a2eb401fee.jpg	t	11394.jpg
3457	1798	07fdde6cfeca6afb868bf0f4c01da6d1.jpg	t	11395.jpg
3458	1799	52bbfb7b6edd9c39fad05a99a342168f.jpg	t	21270.jpg
3459	1799	fc65b5b17592daf36e1e41b839d52525.jpg	t	21271.jpg
3460	1800	5bf9c5261434b91ec9c58452d31936f1.jpg	t	11410.jpg
3461	1800	b429b24f10790cee6f88867b9b17a777.jpg	t	11411.jpg
3462	1801	d990031b9db62ff7b9b5007b0aac65f1.jpg	t	11408.jpg
3463	1801	3d159b900fa76ed9d4998d14c003d49c.jpg	t	11409.jpg
3464	1802	fb6dc8f1e8fce3a95471f318be3ac61a.jpg	t	21276.jpg
3465	1802	3a7ea1910e37a14a8fc1020a08f44f87.jpg	t	21277.jpg
3466	1803	b1b6ddab8b59e0da7599c2e16dc582d1.jpg	t	40565.jpg
3467	1803	9921da089996c4d6352342004595cf2f.jpg	t	40566.jpg
3468	1804	b526f9f3c6f8192638777039a02b3355.jpg	t	40569.jpg
3469	1804	632c258fbda030bca9f4b457c03e8463.jpg	t	40570.jpg
3470	1805	8ec3067353c6892be6cb2ebe81193567.jpg	t	20394.jpg
3471	1805	acb9e17cd5bbb030f8e7361fb5105d90.jpg	t	20395.jpg
3472	1806	71e2b2db2cb5e97d132419121c356e93.jpg	t	20392.jpg
3473	1806	fff087475f185fbb73daeeb2ed095e71.jpg	t	20393.jpg
3474	1807	1b3f6cd427efc32ab9ffaba7f549b1e2.jpg	t	20388.jpg
3475	1807	faadd8757cb2a01d8f2ff1c46a1b21e9.jpg	t	20389.jpg
3476	1808	14b8e75826909c755b72c4e17451c879.jpg	t	20380.jpg
3477	1808	56e6b067c8e06956c8dd4049161589c9.jpg	t	20381.jpg
3478	1809	0016395d259da1f892a48731d744c07b.jpg	t	21218.jpg
3479	1809	b995c5ad2860312a0f7390a14f186baf.jpg	t	21219.jpg
3480	1810	4ee62cfde8add9b5195f56637c36d542.jpg	t	21233.jpg
3481	1810	6830f46e5545465d60e8977772c3af6f.jpg	t	21234.jpg
3482	1810	9053115fc3344d28a734967a572779e1.jpg	t	21235.jpg
3483	1811	7a8455033e5290b8a88721b9143cb871.jpg	t	21236.jpg
3484	1811	066970fa2a1d291c3fb3e98fefe7fbe4.jpg	t	21237.jpg
3485	1812	086770741d41e94724faaa7eb298ae23.jpg	t	21224.jpg
3486	1812	323365b5bd8a202b56b48bc33faa7968.jpg	t	21225.jpg
3487	1812	8dcccd75beff27b4c5f0032d1d25b24d.jpg	t	21226.jpg
3488	1813	bba0d78915747353338b0a2dbe2a3494.jpg	t	21280.jpg
3489	1813	0dd4d9ea31b38501da2696856bd8ed2e.jpg	t	21281.jpg
3490	1814	80e2754033087bf77c8e541c5a937352.jpg	t	21222.jpg
3491	1814	f7429b720c282929fad5f07e0fe39cbc.jpg	t	21223.jpg
3492	1815	bf0938eebaae04e1e9cfd170d52c23ff.jpg	t	21240.jpg
3493	1815	8a3c3f78aefe86b3748d4a395c7abe05.jpg	t	21241.jpg
3494	1816	0f7c5b93db32373d3de89f8b588c0448.jpg	t	21274.jpg
3495	1816	a4ed0b9e5ab059fcbc31593f0c58625f.jpg	t	21275.jpg
3496	1817	90703a4f68acee10744336fcaecece96.jpg	t	21282.jpg
3497	1817	7045782097ee2e6afd29d0179ad85169.jpg	t	21283.jpg
3498	1818	0b141a13843d12e50bbb241116a8ce11.jpg	t	21229.jpg
3499	1818	4a7387432303c7d1ba60ff581c43c9a9.jpg	t	21230.jpg
3500	1819	343be334de19567be70ad3958a9bbb1f.jpg	t	21111.jpg
3501	1819	818d1c67a16eafaeef29084af2df4324.jpg	t	21112.jpg
3502	1820	5218b2707b61680200c3c6aa1aef506a.jpg	t	21121.jpg
3503	1820	90dbf54efbdf7e544ba802b2de770af5.jpg	t	21122.jpg
3504	1821	9e83942e48e37652df7ed0e0eaecf375.jpg	t	21105.jpg
3505	1821	bdad583078634ca67dac0f3d24463596.jpg	t	21106.jpg
3506	1822	70570ac24f01fad56a27b1351134ef16.jpg	t	21182.jpg
3507	1822	8d1cbc8da2f3b8182c5b97eada860385.jpg	t	21183.jpg
3508	1823	3bf7d69eb833b7d388b7cf5e2e40527f.jpg	t	21117.jpg
3509	1823	b9983a9b8ed9432c5c925ac3ac9f3151.jpg	t	21118.jpg
3510	1824	936ce871d11f5b890d312f122949964c.jpg	t	21290.jpg
3511	1824	2764ac0f7d53be2b7268769ae8c84439.jpg	t	21291.jpg
3512	1825	d0e577050dc403ee3d8b77eb0335b0ca.jpg	t	21382.jpg
3513	1825	0acb438d2aadf00005c547eeab57df76.jpg	t	21383.jpg
3514	1826	136cfdf461e3593806962433bdb5db6b.jpg	t	21366.jpg
3515	1826	c1e0ba88f383f73844299f5c0a120d2c.jpg	t	21367.jpg
3516	1827	ab6081bd1fd190211bf741ee0edc9852.jpg	t	21244.jpg
3517	1827	e74d03b11ab40a02077a572f1698e0b3.jpg	t	21245.jpg
3518	1828	5ae78c3fa5636688c2a72e15170b755c.jpg	t	21260.jpg
3519	1828	788e71e8db8ee71c37b64e154a0b4036.jpg	t	21261.jpg
3520	1829	d9b8148ecd601ef13b9d5868906d7d4d.jpg	t	21266.jpg
3521	1829	a6e03eb68a7b0f104aff1d391aadfbc3.jpg	t	21267.jpg
3522	1830	344909de26ea83b28fc6cc90be929fac.jpg	t	21358.jpg
3523	1830	cbf86812fc15fdd7ef28351403f19726.jpg	t	21359.jpg
3524	1831	6a4a8f647f8c15975544e8513aa8b11e.jpg	t	21264.jpg
3525	1831	26609885c99758c37bf3a940940f212b.jpg	t	21265.jpg
3526	1832	3d988b96329af0b6c05f4c91b99c54cb.jpg	t	21302.jpg
3527	1832	066b0177775b79cc76a8410358843c66.jpg	t	21303.jpg
3528	1833	5ae8f78b9a6c9b2f924f8d8c1531cbdf.jpg	t	21292.jpg
3529	1833	5c020d25da6817b00525aa2fe0f731ea.jpg	t	21293.jpg
3530	1834	8317d83244d13eb63cb57dd20dcbce79.jpg	t	21370.jpg
3531	1834	4bf5aa4cb41466528f2300df1d86ab01.jpg	t	21371.jpg
3532	1835	f9e2f147d2d940beeaaf0c447f6af13c.jpg	t	21286.jpg
3533	1835	d046a36f50b309274d3b14ba0be9d4e5.jpg	t	21287.jpg
3534	1836	1d8dc97d41b053e45e9e51caa3aa030d.jpg	t	21362.jpg
3535	1836	3469cf468762da7d47a338126ae6aa74.jpg	t	21363.jpg
3536	1837	72d8dda0f8d7e1e9ded3b1337dfae962.jpg	t	21378.jpg
3537	1837	15c234694f529d6a7b9a4ea0e786c0ec.jpg	t	21379.jpg
3538	1838	ce77e8e609646a7a06c3a302e0140f81.jpg	t	21252.jpg
3539	1838	d9e0b66efd69252644915256b6a53d96.jpg	t	21253.jpg
3540	1839	545357ba2cf7e1d95a9f8b1a3b4e2ff7.jpg	t	21300.jpg
3541	1839	575ee511ac039c34418f323af226bc9d.jpg	t	21301.jpg
3542	1840	fcf1df0f13b307d8b4137a3413ddd325.jpg	t	21294.jpg
3543	1840	afb6ade64856926afa910496325f5d23.jpg	t	21295.jpg
3544	1841	acc540c2623b9f37536cff61d54d2646.jpg	t	21248.jpg
3545	1841	cce22ff1bd2d8b2f9b5a346ea1476a5b.jpg	t	21249.jpg
3546	1842	9012c11045a2f6216466ed182a651d06.jpg	t	21288.jpg
3547	1842	044c21a6d439f260020393a327fd262d.jpg	t	21289.jpg
3548	1843	36d7217f5f5f32138c83966672322ce7.jpg	t	21256.jpg
3549	1843	62b915bf6bf02b1a33c329f6cd36591b.jpg	t	21257.jpg
3550	1844	072b3cceb1eb706fb6f719b3b3d0be66.jpg	t	20360.jpg
3551	1844	839e4e62bf909169717f636992f7213f.jpg	t	20361.jpg
3552	1845	5bbe8966c49fd269f75c8cdc8b460c14.jpg	t	10007.jpg
3553	1845	09538b76b9f11e49a84a4c1dd9f84b54.jpg	t	10008.jpg
3554	1846	af08d0ded8c57e3bb38db3bf64d50266.jpg	t	10016.jpg
3555	1846	6e8440e08c0c09066cd1fac33a4a26cc.jpg	t	10017.jpg
3556	1847	b7e9766ae159a787b2a320b41a91303e.jpg	t	10020.jpg
3557	1847	d00d74c862d1c629808a79beb7a9f9a3.jpg	t	10021.jpg
3558	1848	4144705004ce58a4bb6f9fe57293fb6e.jpg	t	10024.jpg
3559	1848	155f15aba1adfe28078afac50ad19b4b.jpg	t	10025.jpg
3560	1849	3c00ba9b30ad89cd9f9f13782f26fec2.jpg	t	10036.jpg
3561	1849	34d60e6a687b7d240514ffd2bdaeeb49.jpg	t	10037.jpg
3562	1850	427799065ef6fcc2d51a30bd9a81afd7.jpg	t	10041.jpg
3563	1850	ed3d7e3db412cc43fd8db3a45e01661b.jpg	t	10042.jpg
3564	1851	5a40986c8ba4c8cd260a75ecd10915df.jpg	t	10001.jpg
3565	1851	a9de3923925743d24999de96f04e9180.jpg	t	10002.jpg
3566	1852	82244a4f74329af3bc62bd98ceb4161d.jpg	t	10034.jpg
3567	1852	ba565984e96483a75abb0e26d5d6984c.jpg	t	10035.jpg
3568	1853	5152f637eecdc25475a7a446a840b783.jpg	t	11428.jpg
3569	1853	11d3aa8768dec4a8518f3f9ee5d4bb58.jpg	t	11429.jpg
3570	1854	c27d0e95e6fb0eb689a8443e5f318e37.jpg	t	10045.jpg
3571	1854	a390471df3be12443c90f3aec3ca99ca.jpg	t	10046.jpg
3572	1855	15f9d92da416414f011e364f2d19b331.jpg	t	10055.jpg
3573	1855	02f70f29ed24c1e02976bb72e56a437e.jpg	t	10056.jpg
3574	1856	c05b210d5cdab2c291659c2a9d277719.jpg	t	20129.jpg
3575	1856	a0344ea14d53be722feb7bed60691f40.jpg	t	20130.jpg
3576	1857	ac6fb43c964cad745ec62d2d1a4622c2.jpg	t	10051.jpg
3577	1857	4b6b8b62561801f6b2e56e3bc2d40465.jpg	t	10052.jpg
3578	1858	1edd137463cf61a7217698d5ce513dd6.jpg	t	20123.jpg
3579	1858	854061e28484e45f8c5be92b7621512b.jpg	t	20124.jpg
3580	1859	d5608e3840ffe5c54e1e11b0c30ed204.jpg	t	20372.jpg
3581	1859	27450a3dfc5969db003840f15fff75fb.jpg	t	20373.jpg
3582	1860	77db4796381d9961012a1dcf81615b78.jpg	t	21314.jpg
3583	1860	81141d7b32ffc365d722330c90927c05.jpg	t	21315.jpg
3584	1861	72eaded1439ca6e25a9885154a212ec7.jpg	t	21308.jpg
3585	1861	9065e8cb5965cfc1c7825307c28e1062.jpg	t	21309.jpg
3586	1862	adfd2ce4efadae6c6d4a57f0aa1502f4.jpg	t	40015.jpg
3587	1862	2af50118abb7b4fbde1841ec90167fa7.jpg	t	40016.jpg
3588	1863	cd5db1cb7c7cf5b90a0839fe94da216f.jpg	t	30641.jpg
3589	1863	179df930e8decd299d74d27402925f1c.jpg	t	30642.jpg
3590	1864	024415abbabbc4e06e77d8c288623277.jpg	t	40031.jpg
3591	1864	fd4398a5b0f7cd15662d5797d126ef59.jpg	t	40032.jpg
3592	1865	60602e04f1ffa81df8417dc4e48dff72.jpg	t	40003.jpg
3593	1865	936f882c7945d5ca39698fdea66ea89a.jpg	t	40004.jpg
3594	1866	a34a4639de47f4ececb965a3a26a65ee.jpg	t	40019.jpg
3595	1866	d75ee5e94e4ec78d149a0940f6cff069.jpg	t	40020.jpg
3596	1867	ef81221e0ffdd6cb7116c04b475f7b23.jpg	t	40007.jpg
3597	1867	ef4ad56b9c760665f48b85cf6bfce638.jpg	t	40008.jpg
3598	1868	cd895685e5c0ff781e743918dfdb141a.jpg	t	40011.jpg
3599	1868	bcd29dd447230a8b54a5a20ffb0b62ee.jpg	t	40012.jpg
3600	1869	b7b82cb92954c6514b31f8c7a5ecc1d5.jpg	t	40025.jpg
3601	1869	27b338872afc606f8e178c6d80d89ad8.jpg	t	40026.jpg
3602	1870	b6416c822f3444190a691f36dc4ab5c8.jpg	t	30226.jpg
3603	1870	462fd2ce25777900135b317c01fb920f.jpg	t	30227.jpg
3604	1871	29730f78712db7b41a2e7e55b1d211ef.jpg	t	40050.jpg
3605	1871	e3419a6e8a333ffeca5f194a5c8b151a.jpg	t	40051.jpg
3606	1871	0510c9f7f7e755d947766f01dea43005.jpg	t	40052.jpg
3607	1872	a585c1570fafbdf94b9f6c21fc68340a.jpg	t	40039.jpg
3608	1872	94d4631f7c7f9d6f55494600c156dd99.jpg	t	40040.jpg
3609	1873	a1ad48cc25df37d82d7d4111275ef5af.jpg	t	30240.jpg
3610	1873	698a6d0269942fd99abe474f106e1ed2.jpg	t	30241.jpg
3611	1874	39202915dbe436fc21d0b63e1e190096.jpg	t	30232.jpg
3612	1874	28151a30f00637825effe3e2ff0a8bf4.jpg	t	30233.jpg
3613	1875	6e592d7ad66a2675fe290e2d524a3d2a.jpg	t	30224.jpg
3614	1875	67db40b47e29d5d454316ab54cb11b0b.jpg	t	30225.jpg
3615	1876	85ccd4942d9fcd14fac08ecaddc667bc.jpg	t	40037.jpg
3616	1876	680b7f5956a1c4d3ed17c8c4f6d13af1.jpg	t	40038.jpg
3617	1877	687660c5748758c3a5917d8afa64b2b0.jpg	t	40043.jpg
3618	1877	3c12e485ebe9aa62145e636d0b338ce8.jpg	t	40044.jpg
3619	1878	f55d6de096cf07ed4a91465dfb522512.jpg	t	30216.jpg
3620	1878	921a018519bb3a49ac7dde534af53fba.jpg	t	30217.jpg
3621	1879	07e843735efe0d61cc423bc07873efb0.jpg	t	21490.jpg
3622	1879	3a4adad54c13d56c460d7b55ae3ae22e.jpg	t	21491.jpg
3623	1880	f38723efa24f4f65c1445371d9172278.jpg	t	30327.jpg
3624	1880	cb856f0ea94264941d8f30d407a53468.jpg	t	30328.jpg
3625	1881	ad1700c8cd823f9454806c7ea9abaca0.jpg	t	30272.jpg
3626	1881	03f94b2b26755d55b6c1a757c71fa8f3.jpg	t	30273.jpg
3627	1882	f2566e3a18f5f055b2733c1249fcb823.jpg	t	21492.jpg
3628	1882	a76b65561a8ede1094db633e839158c8.jpg	t	21493.jpg
3629	1883	071e4236e2f8d090368f05f44f5c8a8c.jpg	t	30317.jpg
3630	1883	f92beeed57f9788cfb16c36d6eef1d26.jpg	t	30318.jpg
3631	1884	cbea0ef893274676601b75960189af54.jpg	t	30218.jpg
3632	1884	364a62e61f625904effe3964ab920526.jpg	t	30219.jpg
3633	1885	f35ac5b5aa4f6814d33b0d8fc7629ca6.jpg	t	30374.jpg
3634	1885	857e5fa0f1bee9ba0f9d0936dd8c2d85.jpg	t	30375.jpg
3635	1886	e80defbb40cefac02d7fa76008689efb.jpg	t	30376.jpg
3636	1886	48102e2bc973105cd2bcdd4cdd472a10.jpg	t	30378.jpg
3637	1887	9114f65f66b9e5d0dda744d597d3e010.jpg	t	30385.jpg
3638	1887	2873e94809933425b0f33c06a0a0c33f.jpg	t	30386.jpg
3639	1888	b4be19be4f716245e934ee27270e7ee3.jpg	t	21550.jpg
3640	1888	d2c8fa95b1a9244a7ed82fab655740ab.jpg	t	21551.jpg
3641	1889	50b434b65658af5f91c5cfea0bf1c9b5.jpg	t	21545.jpg
3642	1890	57587e08b390bb1f4abf11940c56666a.jpg	t	21552.jpg
3643	1890	0654442ea89a4259f08a484c308c806b.jpg	t	21553.jpg
3644	1891	213bcedf17eea78122bd22c6d877d085.jpg	t	21542.jpg
3645	1891	9ab4652b8d2e711c6f59d670f49fed02.jpg	t	21543.jpg
3646	1892	fa69668f83d34f0b461fe6d71a06f1dc.jpg	t	21520.jpg
3647	1892	3620c3ee0e286b4c9c0e00a12bec192e.jpg	t	21521.jpg
3648	1893	508f3ee63300d156cf9e4e7fc875e99a.jpg	t	21516.jpg
3649	1893	b6561a1a6afa00d60aaeb5162f73e088.jpg	t	21517.jpg
3650	1894	6f62ed288ab53a7f8f75cee3bda15e25.jpg	t	21522.jpg
3651	1894	72e2b042ab6dc659e880d31f7221690f.jpg	t	21523.jpg
3652	1895	a42e6b1e5beb09a7170cbc7ccc6a8491.jpg	t	40122.jpg
3653	1895	bfd030c480f8cfd3dc1d7beeecf879d2.jpg	t	40123.jpg
3654	1896	0ba71f597dd4353b6ccf31f468fb5b9a.jpg	t	40097.jpg
3655	1896	5ef6bc246fa18899c0ae476e1acda80b.jpg	t	40098.jpg
3656	1897	28761927a8063343b3a7ee1c15964db9.jpg	t	40067.jpg
3657	1897	a20aab6412d8373e4463136609745ae9.jpg	t	40068.jpg
3658	1898	5f4589d832a60282902fc78a151dd2ba.jpg	t	30260.jpg
3659	1898	e2593871413ba5a9960b6590b31b87ee.jpg	t	30261.jpg
3660	1899	16cb686088ae05bdf7f1fa75199d87a3.jpg	t	40079.jpg
3661	1899	b4ad388f0a01f6a71d52733af81f6e61.jpg	t	40080.jpg
3662	1900	61d150774e8ac88be89745e3b1b62b57.jpg	t	40087.jpg
3663	1900	ba29a7b9b8cc9910d881f5345220fdcb.jpg	t	40088.jpg
3664	1901	658fd34780ee173060b15ab84cb48ec8.jpg	t	30329.jpg
3665	1901	1e948755099e740f26e0f0f7d8615b82.jpg	t	30330.jpg
3666	1902	392da332f97e979c74f6944d4583ea14.jpg	t	21540.jpg
3667	1902	532fa25ee563a593c54be94bfac2138b.jpg	t	21541.jpg
3668	1903	b19c7eec6591b1ae95aec23fe059a401.jpg	t	30349.jpg
3669	1903	52c4dee7a053d0656ac6d27ce91fa59e.jpg	t	30350.jpg
3670	1904	47b34b20783116ea867424e097d66fcb.jpg	t	30359.jpg
3671	1904	b7b3b356ede1df434c322672bdb1db18.jpg	t	30361.jpg
3672	1905	1ca6b78a1d40cbf1b4ad2460185579eb.jpg	t	21546.jpg
3673	1905	5940fa0fc3a270df7209d4450e52760d.jpg	t	21547.jpg
3674	1906	a7fa438f30e1a010c1491d14a636184f.jpg	t	30353.jpg
3675	1906	2ac49dfd49d78cd258bba54197e6db0a.jpg	t	30354.jpg
3676	1907	74f87c1fc62d51547b6465f26ca14a0d.jpg	t	30345.jpg
3677	1907	1264ca72cb309cbf0b1fc89342146c65.jpg	t	30346.jpg
3678	1908	b9f1b41d82b37a139728e3b27501b80e.jpg	t	30357.jpg
3679	1908	7ee2ec053bd11273bef72f083471c5ff.jpg	t	30358.jpg
3680	1909	16e3c95061bfb62bcee69a295e76e5a6.jpg	t	21494.jpg
3681	1909	c24cfbf12a4992a626d7b959322ae99e.jpg	t	21495.jpg
3682	1910	42ed8472306b0914e1416a8ddac2581c.jpg	t	21496.jpg
3683	1910	558008ae5474124c4c55907eb8e4971e.jpg	t	21497.jpg
3684	1911	244f001ebc80b442c47071e37e42cb15.jpg	t	30355.jpg
3685	1911	5b2a5b393fac26299989b765081911d0.jpg	t	30326.jpg
3686	1912	99fd5f64da2bc7677128f140c7de61f5.jpg	t	30332.jpg
3687	1912	fcce244b5d57333c62537826044e68a8.jpg	t	30333.jpg
3688	1913	b9f1b41d82b37a139728e3b27501b80e.jpg	t	30357.jpg
3689	1913	7ee2ec053bd11273bef72f083471c5ff.jpg	t	30358.jpg
3690	1914	f0251f7015d22ee3a009a7256a05e790.jpg	t	30334.jpg
3691	1914	8816f33905df7f974f6e730243af79c4.jpg	t	30335.jpg
3692	1915	46173b3c4ae5b4d9b77f59cbcf9b74b6.jpg	t	10463.jpg
3693	1915	cd18f9e47dabe5d12abccfa454ee7ec4.jpg	t	10464.jpg
3694	1916	cada84d2ce08e4a8614ed9a5c09cc191.jpg	t	10455.jpg
3695	1916	c8dddca023826e5eed6a29e4676eebe7.jpg	t	10456.jpg
3696	1917	aaf6acd89985c621ab7a0371eb85f96c.jpg	t	10467.jpg
3697	1917	e0b4a14cf358a34da9905080fb23554d.jpg	t	10468.jpg
3698	1918	8ffb33bba3dd0b7eabe5e7b6ca50e8b0.jpg	t	10451.jpg
3699	1918	271910008d28ced73553f22e2fbbabdf.jpg	t	10452.jpg
3700	1919	51b937acd488759c8e2e0fe08e3a7a8e.jpg	t	10479.jpg
3701	1919	4229fa98e042a35bfd3babccd3c53f8b.jpg	t	10480.jpg
3702	1920	13fe111b8a6190afd807915efb26a9f8.jpg	t	10449.jpg
3703	1920	6b1cd05316483d47b9c181141a25caf9.jpg	t	10450.jpg
3704	1921	aa74b99b19e57e1b40f92a7e68b4ea71.jpg	t	30193.jpg
3705	1921	19c6eb6def25f3c72f481df6d1e0355d.jpg	t	30194.jpg
3706	1923	74f7fa290056b005e67079b51d6b01b3.jpg	t	30189.jpg
3707	1923	74e45a1d732021364a71ca784e7ffbb6.jpg	t	30190.jpg
3708	1924	067690606e5721097f8b17dcffb83a1b.jpg	t	30205.jpg
3709	1924	e40da8417f59956b5612f02b75b5d068.jpg	t	30206.jpg
3710	1925	d0d72d1eee59b4338f9e2dcf0eb2d2d2.jpg	t	30195.jpg
3711	1925	09c28e466560232383ac80c90299e8c7.jpg	t	30196.jpg
3712	1926	c25ca2b4213879062219b5c9d63eccdd.jpg	t	30187.jpg
3713	1926	f363efb87ca67324cc4af10a051e9330.jpg	t	30188.jpg
3714	1927	43c1d5a7204b88230209adcf034352d2.jpg	t	30199.jpg
3715	1927	d63b30ea121c4ea6496dbfdba49f5be5.jpg	t	30200.jpg
3716	1928	be85ef1d0f345a6b2215160e00af90e1.jpg	t	10477.jpg
3717	1928	2794a9f366fb66c163797eca439fb475.jpg	t	10478.jpg
3718	1929	bdb769213045a554a747561c3a652074.jpg	t	10445.jpg
3719	1929	68ec5ec6f0f4573b0510a78de0eb4ff9.jpg	t	10446.jpg
3720	1930	54ffdd3bd601398ec27cb66c06b329a3.jpg	t	30207.jpg
3721	1930	03972bf2254a1dfaa0700caec141a9b2.jpg	t	30208.jpg
3722	1931	b0d7ca43b72bf499359bb7def18a6249.jpg	t	30182.jpg
3723	1931	5dfcc1e0abc8525d8fa9d2f1fce38909.jpg	t	30183.jpg
3724	1932	1cfdaeaf6549396c813863779c27822e.jpg	t	40133.jpg
3725	1932	01afd33b50eb582833b24c2cc8ee0523.jpg	t	40134.jpg
3726	1933	19636b1532db2f31f8b323cf206f5808.jpg	t	40137.jpg
3727	1933	7fa8c3b0547b4ff0127c572aa54c0b47.jpg	t	40138.jpg
3728	1934	60a7d344c7fd36a18fb5d0f6ac548ee9.jpg	t	30432.jpg
3729	1934	09e02409022cae53e58d1d973add223c.jpg	t	30433.jpg
3730	1935	610e155aa1ab2e167bb74dfbd11ae4c5.jpg	t	40149.jpg
3731	1935	30e71efb4ae71eac55fa5010dcdc9a89.jpg	t	40150.jpg
3732	1936	f190f67b89fe96983e706cc7ee037ec3.jpg	t	30510.jpg
3733	1936	e2f183c4ee3acbdd87a50b9a407e69dd.jpg	t	30511.jpg
3734	1937	5d70046d38fb9415873736d7f0f952f7.jpg	t	30508.jpg
3735	1937	19a33d542e08c454f61ab087e9b2e22e.jpg	t	30509.jpg
3736	1938	db001d4ee368bb7932d8d16c4de01be2.jpg	t	30512.jpg
3737	1938	3f6a34d83aa723ebb6247a37a5d3a4a4.jpg	t	30513.jpg
3738	1939	4b020880ecfc1decb9be69b82fe45b23.jpg	t	30506.jpg
3739	1939	6ed6d092704a2987f2be2ca16dd890c2.jpg	t	30507.jpg
3740	1940	199689243412c2c74b6b5564e6ab501b.jpg	t	30437.jpg
3741	1940	23d5339f4347074e5cb9c34e8c063086.jpg	t	30438.jpg
3742	1941	b74d41638f165a68ba46fa80373fe1d5.jpg	t	30420.jpg
3743	1941	c50f322e8bd231b1bd0a4857fc343085.jpg	t	30422.jpg
3744	1942	d2a87b5db925a6d681de51ef6bcb2159.jpg	t	30393.jpg
3745	1942	6292f0a37372895c4c2732e0333b7403.jpg	t	30394.jpg
3746	1943	d37651e9a16a6fba4394c1c5879b8217.jpg	t	30439.jpg
3747	1943	752d608d04181d21a584ed3543cd6872.jpg	t	30440.jpg
3748	1944	013f83854c2aac19794b71c0a3c6782f.jpg	t	30427.jpg
3749	1944	ff90bafa25665024d0c7bb9ca2623ba4.jpg	t	30429.jpg
3750	1945	cef68ef305de3d0c2b8f4bafcc9b4973.jpg	t	30419.jpg
3751	1945	c50f322e8bd231b1bd0a4857fc343085.jpg	t	30422.jpg
3752	1946	6b98ca750f2585a598dd7ee4b6c616cf.jpg	t	30421.jpg
3753	1946	c50f322e8bd231b1bd0a4857fc343085.jpg	t	30422.jpg
3754	1947	d2a87b5db925a6d681de51ef6bcb2159.jpg	t	30393.jpg
3755	1947	6292f0a37372895c4c2732e0333b7403.jpg	t	30394.jpg
3756	1948	64e5f7f846473ba80892e55cc4efa807.jpg	t	30425.jpg
3757	1948	76f8d6c14a02608ae47d8de38c5da55d.jpg	t	30426.jpg
3758	1949	3e3b4620f91369f4ee045abcf25ddaa6.jpg	t	30428.jpg
3759	1949	ff90bafa25665024d0c7bb9ca2623ba4.jpg	t	30429.jpg
3760	1950	6f3e262407ec7983a73ad963db1b526c.jpg	t	30387.jpg
3761	1950	09273a00314f09c13d759fdcb230a08a.jpg	t	30388.jpg
3762	1951	72bf7987d958fef962827925e2407653.jpg	t	20139.jpg
3763	1951	a5ed17d8872f7ab4a2eaea152682ec79.jpg	t	20140.jpg
3764	1952	fcb7f87f3a7927f59447f8534f407b71.jpg	t	20141.jpg
3765	1952	80fc16dcfbe3008bc5fa8f6060c3787d.jpg	t	20142.jpg
3766	1953	9276b785a8112182641dc5ecc5a6b40c.jpg	t	20119.jpg
3767	1953	8f1c5c5184f7fdfd297a5d303f2e814c.jpg	t	20120.jpg
3768	1954	ca0b8c0dbd2af885f6f82b3da25227a7.jpg	t	20145.jpg
3769	1954	bbca540ec7c86507c424ce93d0d487ac.jpg	t	20146.jpg
3770	1955	ac45a4feba01b8acc14bbf493f5d3cd2.jpg	t	20154.jpg
3771	1955	68240a170ef830d5ca444619dba7e764.jpg	t	20155.jpg
3772	1956	fc9e103b2b3dd35339ef4eef9e154553.jpg	t	20164.jpg
3773	1956	5e78e02dbc2457c6832b01be5802427b.jpg	t	20165.jpg
3774	1957	7f9f6f91d84b9116af740f65688b6467.jpg	t	20147.jpg
3775	1957	ebf80fef3a1c926327a617dcb9f8804a.jpg	t	20148.jpg
3776	1957	c3829ddf84a64a9f29ea967a740cb157.jpg	t	20149.jpg
3777	1958	4e5d344d617cb8816c7539a46e6aaaff.jpg	t	21524.jpg
3778	1958	58bcd41d42bb5ff7b9ab91e86c25d492.jpg	t	21525.jpg
3779	1959	a9cc7ce488944457931a17937c4d6a47.jpg	t	30407.jpg
3780	1959	a98ba1b685d02ce66b82a42e038a3061.jpg	t	30408.jpg
3781	1960	87e10df06eab710b11cc06f4234e9e86.jpg	t	30415.jpg
3782	1960	5a8b10896fa773e65b419378cc27d6af.jpg	t	30416.jpg
3783	1961	2d09161ff326652f2735bcfd5603ea7c.jpg	t	30171.jpg
3784	1961	4a5d5c71b5e4f28a22686e5b382794a0.jpg	t	30172.jpg
3785	1962	eb44fe7345f6de280f89242c7be09662.jpg	t	30173.jpg
3786	1962	288864ed74c30c098c605698445d51bd.jpg	t	30174.jpg
3787	1963	4513be3cc9d56069152d51764fe43f09.jpg	t	30490.jpg
3788	1963	dd82ee8b8eff3d203e52da83e00cb91f.jpg	t	30491.jpg
3789	1964	937591474b6f8ccad34a7ac72c2a6146.jpg	t	30177.jpg
3790	1964	17cf5f9afc7aeec7a7ede9997da27fd7.jpg	t	30178.jpg
3791	1965	8fb0353f8237732888b88db9c5f3ee83.jpg	t	30165.jpg
3792	1965	74c6ca6b12d972254ea8d741b66f78d0.jpg	t	30166.jpg
3793	1966	da83420224ee57d178d9d110e5b65831.jpg	t	30496.jpg
3794	1966	f85f6c9f3e93497b9b15783a1569135e.jpg	t	30497.jpg
3795	1967	3c8d456d3edeb7725eac2753d86f515f.jpg	t	30161.jpg
3796	1967	e892c134ee6321aa4796919a53cac6ee.jpg	t	30162.jpg
3797	1968	d12606aefe1fc1f27b728e879beac7dd.jpg	t	30494.jpg
3798	1968	7263d76d4f85d0e2e3fca672750841d4.jpg	t	30495.jpg
3799	1969	9c02b4ab1b341501eaafdfb637a6f881.jpg	t	20787.jpg
3800	1969	fff7ac3bbdd95ee8a810756b01f64e66.jpg	t	20788.jpg
3801	1970	985dcf7cad3c0959dc289ec4fc6e5eee.jpg	t	20749.jpg
3802	1970	06dce8af691b86ad3de6d7b21fb3b683.jpg	t	20750.jpg
3803	1971	90d94f7bcba1971b61aff315f326543c.jpg	t	20775.jpg
3804	1971	4f27e2be3ff553fd89b8043764d5307f.jpg	t	20776.jpg
3805	1972	cb4248ead78d7aca0ed923805f224631.jpg	t	20791.jpg
3806	1972	ac798eceea1ad6f332b16a4921c59f02.jpg	t	20792.jpg
3807	1973	04b575647efe6596fe73d42584801542.jpg	t	20757.jpg
3808	1973	52f006a7671c959cf1d44ec0a87d0496.jpg	t	20758.jpg
3809	1974	0faa91dde7472de448f6a54195b0e57d.jpg	t	20692.jpg
3810	1974	cb7f3b73c055c09125e4056dbd4b7836.jpg	t	20693.jpg
3811	1975	3571bb02eb3b3ab7146ccdc2346be8a6.jpg	t	20512.jpg
3812	1975	eddb1a5536c52e16a0f646f13cb2952b.jpg	t	20513.jpg
3813	1976	6c2de01470ce05039e0572fe3ae9a282.jpg	t	20755.jpg
3814	1976	19af6a92687a9fd18185c34a6713d7f1.jpg	t	20756.jpg
3815	1977	c7863086210deae5901b248d1da056a5.jpg	t	20779.jpg
3816	1977	49a1af890195a1161472d348aacf10f1.jpg	t	20780.jpg
3817	1978	1abad433dec5facdda8eebb039bc836b.jpg	t	20769.jpg
3818	1978	59961045b883da8feae469d564cebd6e.jpg	t	20770.jpg
3819	1979	f1d2955798312ebf581a485877d381f3.jpg	t	20793.jpg
3820	1979	c1cef73b650ae14b27c1301476146c07.jpg	t	20794.jpg
3821	1980	cd9744f3503629d5d82187838e57c58d.jpg	t	20799.jpg
3822	1980	727876bffdbe34c6471b7b3e6cb9f67e.jpg	t	20800.jpg
3823	1981	df786364d74a8a631cd492ae0c57a01d.jpg	t	20700.jpg
3824	1981	f1541a18758fc2fe8aedfea7513c316c.jpg	t	20701.jpg
3825	1982	4675e80672177e3383484296628121a6.jpg	t	20514.jpg
3826	1982	e7b300cac5679b0826d7fee4bed79f6e.jpg	t	20515.jpg
3827	1983	5a46423da1164dc4b6168e13b272df9e.jpg	t	20783.jpg
3828	1983	60bd76bd1209936bf2a39e7d78e5a615.jpg	t	20784.jpg
3829	1984	4c81f31332926b6ede06de0ce94e6a63.jpg	t	10611.jpg
3830	1984	e77716608e763c090a983173e82a9d93.jpg	t	10612.jpg
3831	1985	b9e52eddca34e5f8b15c3e94228f4845.jpg	t	10607.jpg
3832	1985	2036ff6d34f1849e6dcbcc9e6a750a13.jpg	t	10608.jpg
3833	1986	b94aa6256a900ee48977d697d394be24.jpg	t	11040.jpg
3834	1986	7d92f966b330f752b56de9f6564e08b8.jpg	t	11041.jpg
3835	1987	0aa730535595c68d0c6bfbb33c482c0f.jpg	t	11091.jpg
3836	1987	357ccd76362b89601ee9994a0c19d29b.jpg	t	11090.jpg
3837	1988	6ff953652e1f1063fd8bdc7799b805ae.jpg	t	11020.jpg
3838	1988	9f872829edd6c0499b7ed656e5f37dce.jpg	t	11021.jpg
3839	1989	773928183d53f3db382e5a5f6c453557.jpg	t	11022.jpg
3840	1989	5335664a60256ec2c6f4a648e9d98744.jpg	t	11023.jpg
3841	1990	1eb411e9d9f0fa50eebd4aceae23008e.jpg	t	11098.jpg
3842	1990	21ad8e0697425262bea032063720a89c.jpg	t	11099.jpg
3843	1991	178730b31c74d0f3a49786f283e72758.jpg	t	11036.jpg
3844	1991	ac769b46ba93aaf092928674306fdbc9.jpg	t	11037.jpg
3845	1992	f09741f8e843733c514151f2f217643d.jpg	t	11030.jpg
3846	1992	8e0ecd0cf88d1140ba8b1e1c1bc055e0.jpg	t	11031.jpg
3847	1993	4b6be35c666bbee03d4c437796c85c98.jpg	t	11101.jpg
3848	1993	322bc63c802cbe5b0822b973080d0b2d.jpg	t	11102.jpg
3849	1994	0d44b37b0bf674c0974b754a7ee11e68.jpg	t	11047.jpg
3850	1995	389fb2499b51c0397c6e9bd0e42a4c22.jpg	t	11048.jpg
3851	1996	408bacc1dd73fafa9e1e48b54d8a8790.jpg	t	11012.jpg
3852	1996	28a56a930c097c7a261c821bcbffddd2.jpg	t	11013.jpg
3853	1997	908dedde02e831c74ab98cd32ae770ac.jpg	t	11094.jpg
3854	1997	a07fffe3b99ae360f16bc74d85b2060f.jpg	t	11095.jpg
3855	1998	f2c497fec5a04f8bafc687c16a2a4ff4.jpg	t	11032.jpg
3856	1998	789b44b0adef540bbcb42e28386508b4.jpg	t	11033.jpg
3857	1999	5a1f02d147f95d88fcc37709eb33f1d4.jpg	t	11016.jpg
3858	1999	6eea7bccda0255a3bfdd14119887b9f0.jpg	t	11017.jpg
3859	2000	d84385dff7b251c7bedbb28e3b1c7f48.jpg	t	11026.jpg
3860	2000	99f3a3557528154a86658bddc5cf3033.jpg	t	11027.jpg
3861	2001	581bdd291eca0ae4399fccb630699af6.jpg	t	11004.jpg
3862	2001	c2b7efbfd6fb569614f7775a3a68ed89.jpg	t	11005.jpg
3863	2002	1134906c925a109a23365f37952aa779.jpg	t	21440.jpg
3864	2002	8e53908747bb381156cc4ce6bfbe0753.jpg	t	21441.jpg
3865	2003	e0c2ff8b46a43cc1188308cd812757a6.jpg	t	21444.jpg
3866	2003	35756ab2e42c69a74453df1404fd930f.jpg	t	21445.jpg
3867	2004	f0892337616b9ec5b0846d619694c470.jpg	t	20961.jpg
3868	2004	8b7d7cb8bbed71fd9b8ccd48ea614cd7.jpg	t	20962.jpg
3869	2005	a84dfbce878a9e44a0ae5b520d917de3.jpg	t	20953.jpg
3870	2005	96310205b2859aa273bcd8adae404f60.jpg	t	20954.jpg
3871	2006	c1b8c06a58d07091f111c48ed4895431.jpg	t	10656.jpg
3872	2006	314cdabbef7c1c79f705afa839824891.jpg	t	10657.jpg
3873	2007	452801cf298a791ce0658cf1328fc529.jpg	t	20949.jpg
3874	2007	3e49afd640b25cab662ff78f7a0770e2.jpg	t	20950.jpg
3875	2008	66d07e21504400f5de880c50fed5d96d.jpg	t	20957.jpg
3876	2008	8248c88d4d6ff504bb797dfbaedde5c5.jpg	t	20958.jpg
3877	2009	3ed810f7aab69095da397bf08f346cd3.jpg	t	21448.jpg
3878	2009	85a3312b01d8b9e50a60a03d9858c6cf.jpg	t	21449.jpg
3879	2010	72c331f292439bb88d19ab856ba117c4.jpg	t	10637.jpg
3880	2010	4e1dd0433d9b79f47e4c61a5ed8bc49b.jpg	t	10638.jpg
3881	2011	413cb6426c7aa32d02842ef5c69e84bc.jpg	t	10643.jpg
3882	2011	cde0b73ea3eaeba6395138f5b6aea106.jpg	t	10644.jpg
3883	2012	825dcc321f69fed9aea983412e27cb70.jpg	t	10654.jpg
3884	2012	56475bcb9a3fbf39dc08508cbb22bace.jpg	t	10655.jpg
3885	2013	6b1e932cb189395575c8cd56c5077b80.jpg	t	20496.jpg
3886	2013	c806517916885aa0a22f2ca3413c5fdc.jpg	t	20497.jpg
3887	2014	1ea8d5ff1c37eb676dbc351be3f4b987.jpg	t	10647.jpg
3888	2014	05ec28f1668d9f82b08f2e58fc5cd405.jpg	t	10648.jpg
3889	2015	27e93559d6b3380dae200e08390a555a.jpg	t	10585.jpg
3890	2015	b8f5d964d13f4025ff549791083f03fe.jpg	t	10586.jpg
3891	2016	476d9837619a3f7f765bf4ed4b9ac2f1.jpg	t	10651.jpg
3892	2016	525debb7602cbd708aeb17067fa3647a.jpg	t	10653.jpg
3893	2017	c9f6a776f2ca288a5264cc9e93b41da5.jpg	t	10569.jpg
3894	2017	f7915654a5d6a59fe480ba5881686bb4.jpg	t	10572.jpg
3895	2018	d1c12d41a28744c53494e00b9da8c097.jpg	t	10577.jpg
3896	2018	5c686b73803069aa3f54f573349176e5.jpg	t	10578.jpg
3897	2019	dd651bd6e6aebe98fd60e2ff52b8ae8f.jpg	t	21450.jpg
3898	2019	6e21e317cf02c39c61741f64d08986a9.jpg	t	21451.jpg
3899	2020	4fe789a55de8ac6eda11040e29aa405f.jpg	t	10573.jpg
3900	2020	104ac75a7db62255f0a400fee68c085f.jpg	t	10574.jpg
3901	2021	a451ded5c825d48711ce73836f317494.jpg	t	20506.jpg
3902	2021	ef431cf0639a9a9a809d6b4a2bdcfbf9.jpg	t	20507.jpg
3903	2022	5cac1c3abcb5d4a61769b191b3448453.jpg	t	20510.jpg
3904	2022	bb6faa2acd0a325cc0c3122697dba412.jpg	t	20511.jpg
3905	2023	838cc0038918e24cb7af11ce0ebdd302.jpg	t	20490.jpg
3906	2023	8b549a19d0b85d19a1857d03ed5689ad.jpg	t	20491.jpg
3907	2024	0d51f3b42b670d03d27fa2e9c5661c05.jpg	t	20508.jpg
3908	2024	80bd32dd80415b2f29f36396f9486a86.jpg	t	20509.jpg
3909	2025	7c72ea24ff89991cd4e9d66208bba750.jpg	t	21025.jpg
3910	2025	ea9e53b8c1f52bb7e5ba36ff066494bd.jpg	t	21026.jpg
3911	2026	27b95fc80be5be6ffaa329cd56989110.jpg	t	40151.jpg
3912	2026	4508929e1adad927bb03bfa4b5424c91.jpg	t	40152.jpg
3913	2027	ae24ef114bfc7e2858b845de5b5c4da4.jpg	t	30708.jpg
3914	2027	c27e9d9cc9db33b829918f3fbe94719d.jpg	t	30709.jpg
3915	2028	880e58bc197ad36e8496f253794149ca.jpg	t	40167.jpg
3916	2028	1e44c7d51e3bb537b13f9156bf4e3481.jpg	t	40168.jpg
3917	2029	ddb6994badd908bba12d9fe3a16abc94.jpg	t	40205.jpg
3918	2029	22505cdaa0d023d75bbc15815705e146.jpg	t	40206.jpg
3919	2030	82b503e979f9acdaccfc91a0aa8519e8.jpg	t	40157.jpg
3920	2030	985e44e613c6aa443702f8b11e49724d.jpg	t	40158.jpg
3921	2031	b70ec7cb8c892de5766bbbf3b748dab4.jpg	t	40177.jpg
3922	2031	dff9f83bdc5eb9a378900e8b8a1e0b0a.jpg	t	40178.jpg
3923	2032	c7994fff0432d94dc70c6a632da1549d.jpg	t	40199.jpg
3924	2032	6fb29f34321029467efc88a8f9788d7a.jpg	t	40200.jpg
3925	2033	424282dfc4cd8e381540e9e332604d65.jpg	t	40215.jpg
3926	2033	4e9ca91364713678679a46aee315376d.jpg	t	40216.jpg
3927	2034	b5837edb890e7b0987caa2579846437b.jpg	t	40143.jpg
3928	2034	0e7840765d54ec16daef35eb7ab93836.jpg	t	40144.jpg
3929	2035	37f660b98f0b5a89345d182c51e55ec8.jpg	t	40201.jpg
3930	2035	3872847c8a72b59641619a0b3710c622.jpg	t	40202.jpg
3931	2036	ddb6994badd908bba12d9fe3a16abc94.jpg	t	40205.jpg
3932	2036	22505cdaa0d023d75bbc15815705e146.jpg	t	40206.jpg
3933	2037	a05eaa63644083743635dd4df4ec7b8d.jpg	t	40171.jpg
3934	2037	a14088592b2a5a726aac381c0ad7e8d1.jpg	t	40172.jpg
3935	2038	ae96023be0e1d492d1e438d080118ff2.jpg	t	40189.jpg
3936	2038	b1ff3036e688b3cf41d8b6309142b9d2.jpg	t	40190.jpg
3937	2039	4461c29c466757bc835f52bd1a32cd63.jpg	t	21003.jpg
3938	2039	801b4af1aa4c9168efca822c4d7041b8.jpg	t	21004.jpg
3939	2040	73557fb423b55ef164b288bda7c57f98.jpg	t	21009.jpg
3940	2040	c408170281cb686b47093c926334aa33.jpg	t	21010.jpg
3941	2041	34e5ae9ba5f988b90eece988e234521f.jpg	t	20480.jpg
3942	2041	190fb1714d9b6ebd03f7fe6b21873296.jpg	t	20481.jpg
3943	2042	432be8d2c80c46dfee98ad5cf056bccf.jpg	t	20995.jpg
3944	2042	812ba47fc32aa9e39d518e2176c0f51c.jpg	t	20996.jpg
3945	2043	f39964060d3babd7beaf1fd07ee394ed.jpg	t	20765.jpg
3946	2043	bbc30809a0d91ba4deca3c6239ffac5b.jpg	t	20766.jpg
3947	2044	190ec709fa13b62584a7fb07da26da21.jpg	t	21031.jpg
3948	2044	db1e0a66c4bec5a8791584cf3bceeaaa.jpg	t	21032.jpg
3949	2045	ac11ee8a713af574cda2670e680757ce.jpg	t	20466.jpg
3950	2045	20477d321452d3bde19507561c8202b3.jpg	t	20467.jpg
3951	2046	2430a0542c58972962e016cbc423db3f.jpg	t	21015.jpg
3952	2046	be3c55d8eb0f723c9729a810f2572d10.jpg	t	21016.jpg
3953	2047	1e17d1f5c367141818d7a06e16b45527.jpg	t	21021.jpg
3954	2047	b1bcaab9bc5a8174fba8b8849a383359.jpg	t	21022.jpg
3955	2048	21a09304c9f06eebeafce9907e94baf3.jpg	t	21035.jpg
3956	2048	7ac32d99330f9f54ba229e451c174798.jpg	t	21036.jpg
3957	2049	d991b4009a8eed7c380f2cdc32edea10.jpg	t	21039.jpg
3958	2049	c2a6c7ec84760fad40f6a008ab04e66b.jpg	t	21040.jpg
3959	2050	4b9744d152215c6e0ed392bc1832c2f9.jpg	t	21011.jpg
3960	2050	7bf655e2861f3c878400f491746eb696.jpg	t	21012.jpg
3961	2051	82df562264d7eede0a064a02f569eb10.jpg	t	20971.jpg
3962	2051	9b63deb5471fd6f5350203a90848bed9.jpg	t	20972.jpg
3963	2052	683f7ece12f31886ce56b9fbf381746f.jpg	t	21488.jpg
3964	2052	ce9993e816e7b6992409b991c59fee40.jpg	t	21489.jpg
3965	2053	a1fb5b95d75f3b8465e7ed87bf62961b.jpg	t	21484.jpg
3966	2053	8712fc00e865ad569b740499e5c72d5a.jpg	t	21485.jpg
3967	2054	f7ffe70be16779bc54a161524142d7e9.jpg	t	21472.jpg
3968	2054	6ecb8b775b39f32f5ab71f7533cd66b8.jpg	t	21473.jpg
3969	2055	940ebf95784ef17ae7b94361a595ee71.jpg	t	20486.jpg
3970	2055	df5ec8534c314da9764a141604568ff1.jpg	t	20487.jpg
3971	2056	05b594ec2039ffc8acb6beac7b963367.jpg	t	21480.jpg
3972	2056	37175b740972ed2a20ff26d8069701dc.jpg	t	21481.jpg
3973	2057	b3aaf11fd35d86a166fef8693e368539.jpg	t	10805.jpg
3974	2057	c8d09c2a61c4feaecf4edcc1d6d268da.jpg	t	10806.jpg
3975	2058	56b7d2936248bdb0601f66f90eaf6be4.jpg	t	20476.jpg
3976	2058	c03939d2f18fbcb4ddd065ef68c930b1.jpg	t	20477.jpg
3977	2059	30ce9a420797fb2f97cc56c0b6580445.jpg	t	20761.jpg
3978	2059	df62b079709ce4c9d8250b0a6163a02a.jpg	t	20762.jpg
3979	2060	0765c7abd1253df5d935d58bb4a3c5e5.jpg	t	21476.jpg
3980	2060	f5964a8644ab708a5893d135ee9f71ba.jpg	t	21477.jpg
3981	2061	7994932023fdcb8c8b7352a5faecb3de.jpg	t	21438.jpg
3982	2061	3fa6d9cb8920725161488375013eafe6.jpg	t	21439.jpg
3983	2062	91e7a7a6164e045de2ddca337667eebd.jpg	t	21466.jpg
3984	2062	7aa4107e04d667bc8eae4da8af7b815d.jpg	t	21467.jpg
3985	2063	206c0e784314d9c51571d05cc06a6191.jpg	t	21464.jpg
3986	2063	e31c4773f6620a88f161d96e6224f4c1.jpg	t	21465.jpg
3987	2064	953592002640756d55945484150a4fea.jpg	t	20484.jpg
3988	2064	355248c4b5b2099b80a60eede0e2eead.jpg	t	20485.jpg
3989	2065	6a747c224aaf82dad9c737fbb36d9065.jpg	t	21468.jpg
3990	2065	af84d4495454d798198cc1505b969af0.jpg	t	21469.jpg
3991	2066	afaefb542d6ebad507f19b9d4f10fabe.jpg	t	20933.jpg
3992	2066	9fdc44bceb25dcb637c8e0cc581ddc03.jpg	t	20934.jpg
3993	2067	846ec8e64ca2628a87ba872f852297b1.jpg	t	20458.jpg
3994	2067	edcfaeaf218fb2a29ce0ce4d71af2a7c.jpg	t	20459.jpg
3995	2068	f3a37efe2b5aad318391b435916bbef8.jpg	t	20929.jpg
3996	2068	b45cc5b104d28bea159019958a42c5f0.jpg	t	20930.jpg
3997	2069	64947f3b6d7d234575512b2118122999.jpg	t	20919.jpg
3998	2069	f253562093e1b635b045fd3b36c52fc3.jpg	t	20920.jpg
3999	2070	ce21fa687f6cd5bdee05c74a8517f4a7.jpg	t	20438.jpg
4000	2070	88ff77c25d44acc76f2513158838d92f.jpg	t	20439.jpg
4001	2071	390163af5eedb2175aec84c117e452b0.jpg	t	20430.jpg
4002	2071	9e1b5d794a49aae1066d9d295a270462.jpg	t	20431.jpg
4003	2072	5fe7f538c5ffc62e02e57482099e2ef5.jpg	t	20464.jpg
4004	2072	c41ada04d82e91f55acf368f03cb052b.jpg	t	20465.jpg
4005	2073	d888dc2182256bd9c4779c2347ef6bce.jpg	t	20925.jpg
4006	2073	cc663bc342127e20e617ec6470dd36c4.jpg	t	20926.jpg
4007	2074	bf040f4c1c43f07fd985379a922d7a29.jpg	t	20452.jpg
4008	2074	9cf5ab56ac5d29e7ad6d2c5ed387c668.jpg	t	20453.jpg
4009	2075	c66f2e19edcb6f44358b471b44c60109.jpg	t	20456.jpg
4010	2075	0cccf9d7db3a125e066aab17b10476f8.jpg	t	20457.jpg
4011	2076	110011b8d6bf2b5cf3c50b22b5de2fc6.jpg	t	20440.jpg
4012	2076	adc3c0b28632a086932c0245e702f8d9.jpg	t	20441.jpg
4013	2077	856405668920de7dd342da40e01cedfd.jpg	t	20682.jpg
4014	2077	e28ae45d3f1d139976fdcc815db0d6e5.jpg	t	20683.jpg
4015	2078	1a3c324a52ee21d208c4187774cfc93b.jpg	t	40163.jpg
4016	2078	5315acb2be032c62ee48dd509fc8f716.jpg	t	40164.jpg
4017	2079	7c0e6523e020cca57966dbc72174a4e7.jpg	t	10633.jpg
4018	2079	e910157dcfbeb04ea710def517e4422d.jpg	t	10634.jpg
4019	2080	9d771f509787f9d3be81cee21d2eee13.jpg	t	21456.jpg
4020	2080	48a3d7107842dd32f8e747ad02ab2196.jpg	t	21457.jpg
4021	2081	c5ab09e4d286478ad22b12b0e94071a9.jpg	t	10629.jpg
4022	2081	832682940b36b14d3f0b0da2b4dbdefc.jpg	t	10630.jpg
4023	2082	b45e02c5e40ed2e315b3b51ee052f6bc.jpg	t	30718.jpg
4024	2082	3e258aaaf1bd1f13abb382a289831169.jpg	t	30719.jpg
4025	2083	35331f4c9de9121707435e2d93e64141.jpg	t	40159.jpg
4026	2083	d9da0b35133333006945d422879d491f.jpg	t	40160.jpg
4027	2084	4b4de4457b32e249e4d9203e2c7be2e6.jpg	t	10631.jpg
4028	2084	ef9ef5f9c53581536fa94ae02c460b52.jpg	t	10632.jpg
4029	2085	9cc3ee4a50279b38d0b55cbf4ae116cb.jpg	t	30712.jpg
4030	2085	3588a6fe63b171eac93b6c49bf31b800.jpg	t	30713.jpg
4031	2086	0c70f1e2f1e61f8d7ad078f7496c4518.jpg	t	30698.jpg
4032	2086	d0ea184a48d2bf1e71e9e4dead3a087d.jpg	t	30699.jpg
4033	2087	e08bf00a8d3df6e9b4d0b6d4e031f8fb.jpg	t	40191.jpg
4034	2087	f62eb0b90c96f397e0f6cdf54d869108.jpg	t	40192.jpg
4035	2088	7b8d64479f55794b7920acfbedf3ad33.jpg	t	30700.jpg
4036	2088	e6c3beb116c8b878eb60b6eb826c5dd9.jpg	t	30701.jpg
4037	2089	8caed08754c0c5e5d111505fd71a7d48.jpg	t	40197.jpg
4038	2089	b632bd0e4ede69129d5a8db80149cf30.jpg	t	40198.jpg
4039	2090	5cf8dc45dfc6f50e0b69de736095e70b.jpg	t	30704.jpg
4040	2090	2bdec3ade4059bb192a78c4e7826d077.jpg	t	30705.jpg
4041	2091	189320983adc1c42fd699b233093c2be.jpg	t	21458.jpg
4042	2091	fad25c0f41a7e425a1c01833c2f9195c.jpg	t	21459.jpg
4043	2092	e8ef66a5ec9aa1526fcbe3b28ed79bb0.jpg	t	10809.jpg
4044	2092	5818fe5a9c512af2678e82dd4030d17f.jpg	t	10810.jpg
4045	2093	5141c21967463bd0622dbba1d9540d68.jpg	t	10811.jpg
4046	2093	72e3ea2e4c20d16df2f6231c828e35e4.jpg	t	10812.jpg
4047	2094	05d02dd0820a63efee53fc4af3db0b78.jpg	t	21462.jpg
4048	2094	6bbfc3fe690660c0c779fbd4c77eea76.jpg	t	21463.jpg
4049	2095	723451a44e54eb6c82f595dcd7a4c402.jpg	t	20943.jpg
4050	2095	3df0385a1df0318913ad3cdf321b351f.jpg	t	20944.jpg
4051	2096	44a57907dbf26d05cd93cd84530495ff.jpg	t	20917.jpg
4052	2096	3032d0ac1d6b98aed5c09fa30f8e27df.jpg	t	20918.jpg
4053	2097	7d4bfdc9eab9f95049a60434dc897920.jpg	t	20947.jpg
4054	2097	518043b8a9e26c2d7b2ad46b5024b1ed.jpg	t	20948.jpg
4055	2098	6c325dc0060b76ce396354da0f0578fa.jpg	t	20472.jpg
4056	2098	d3687f5a9ef8c238f07d199703b0b84e.jpg	t	20473.jpg
4057	2099	be54f146a8f0e4b72294779843f48091.jpg	t	20939.jpg
4058	2099	f7ebf062efb323ed6cfe237f77331101.jpg	t	20940.jpg
4059	2100	90ac01fd9e1150b62beffa11dfaf4c12.jpg	t	20688.jpg
4060	2100	092c681dd0aaa9ebaa1dbd5a76a07525.jpg	t	20689.jpg
4061	2101	96d5d44bfccd68d590849fee479653ab.jpg	t	20684.jpg
4062	2101	3ec9f2d45bb4b081196e9e612b09db77.jpg	t	20685.jpg
4063	2102	c5669af5dc099a4c3f10b09b5b56b1de.jpg	t	10833.jpg
4064	2102	4b9d16cd0d8322baa9a246d8025c7360.jpg	t	10834.jpg
4065	2103	2303a1b3269aa2d53e15da26bffc979a.jpg	t	10821.jpg
4066	2103	30dfc82f3b54fc7dc063b5d84740b63f.jpg	t	10822.jpg
4067	2104	171f4fdbb8e2b98c1a18d00de601a831.jpg	t	10813.jpg
4068	2104	52d4b9edf9b23553d17a25beb417b160.jpg	t	10814.jpg
4069	2105	26ce3f2dd18a53686eef8db5add6629c.jpg	t	20662.jpg
4070	2105	0b2c2739d162af48710c5c54bc2f1670.jpg	t	20663.jpg
4071	2106	5b86929b83a5910e5c63b19e8521a232.jpg	t	20666.jpg
4072	2106	acce2b163eef2c06339f1df50255029c.jpg	t	20667.jpg
4073	2107	ae0e00f6e90cec0068b3f6ba3bf59267.jpg	t	20670.jpg
4074	2107	1d380fae0e2abe36eaf4b73232833451.jpg	t	20671.jpg
4075	2108	c00c7ea8f2d5c00dcfdbf37ff7c9f102.jpg	t	10827.jpg
4076	2108	12689a00cb4a6e267360843cf08b21dd.jpg	t	10828.jpg
4077	2109	5f61c052049a2c02c511f1a0ce8a73b1.jpg	t	10825.jpg
4078	2109	3ff24ead5d553db25e2d9facd9bcc093.jpg	t	10826.jpg
4079	2110	4d943d15d904266ca88c777867f7bbd2.jpg	t	20672.jpg
4080	2110	06b24167646ead8ec08ce7960b4e58b3.jpg	t	20673.jpg
4081	2111	6a4ad99da1275c67a88046d0b2ba520f.jpg	t	10829.jpg
4082	2111	54ae68467583e473e61c609ac2a02851.jpg	t	10830.jpg
4083	2112	600f44299d8afb52f64c8ce1ed9d0a4b.jpg	t	10817.jpg
4084	2112	49f593fb4492a754119b3615f5275aca.jpg	t	10818.jpg
4085	2113	ba8a620248688f792e9089ab98bc771b.jpg	t	20448.jpg
4086	2113	d2073f6a0dc0e97eabfe46b53701af77.jpg	t	20449.jpg
4087	2114	21cc87ef18279d214c869b6bfbaae336.jpg	t	20935.jpg
4088	2114	54c7799c467d1140ee609f7cc05f7e70.jpg	t	20936.jpg
4089	2115	822916c905a00f32b287dd672edc267f.jpg	t	20442.jpg
4090	2115	639d466fc2033c81c9b6f77ce2f39d37.jpg	t	20443.jpg
4091	2116	6866b36bc44a58c23429dc1a618abfdc.jpg	t	20985.jpg
4092	2116	d07c66ad21ea8c3de3fcc09f0d5c6d9c.jpg	t	20986.jpg
4093	2117	c825154911a87e8622568a944328e48c.jpg	t	20983.jpg
4094	2117	8319515897cb190aa22b06904ef6da36.jpg	t	20984.jpg
4095	2118	ea7dba0c01692457a152887e270bdc0e.jpg	t	20993.jpg
4096	2118	67402c52498a667e581286fac7ef6faa.jpg	t	20994.jpg
4097	2119	0ebb73d35dba18f39a8f901083ddd157.jpg	t	20975.jpg
4098	2119	3ee116c371db22a1885a63627c9d9a25.jpg	t	20976.jpg
4099	2120	23553ba6ba21bee0f93d6c85bc8559dd.jpg	t	21027.jpg
4100	2120	19477ff605a894ed17ef1b9dced621e5.jpg	t	21028.jpg
4101	2121	0fa037b09328a25e46f8707a0a670823.jpg	t	20977.jpg
4102	2121	716fa7aa69676c1fcf93bab235d687a7.jpg	t	20978.jpg
4103	2122	221c2950f99167dde7c1fcfe411e52dc.jpg	t	20434.jpg
4104	2122	6cf479612c0eb63ae568a3a080737a23.jpg	t	20435.jpg
4105	2123	23ccf006977f1dc9193bbcccd43ffde4.jpg	t	20989.jpg
4106	2123	1d90dbc244a5d578f13dcc455c31129f.jpg	t	20990.jpg
4107	2124	0455cae1c9419de039b454c13016e54e.jpg	t	20468.jpg
4108	2124	064064bd6b67bcfcf2a31ac45467d4e1.jpg	t	20469.jpg
4109	2125	6c056133bf7b675421142cca6ee3389a.jpg	t	10597.jpg
4110	2125	5ab4c94ec91d784e87249489eee66871.jpg	t	10598.jpg
4111	2126	035ac3666dabf634d2cf0805faa19f41.jpg	t	11069.jpg
4112	2126	236437f5baeea1c1f0702d15f70d1ebf.jpg	t	11070.jpg
4113	2126	206ee36cb0cd55331c6f62993f12f385.jpg	t	11071.jpg
4114	2127	2cab8dbbf0895765715cf01908c4b7b7.jpg	t	10615.jpg
4115	2127	cf5b35e71e0fafdb5fd01778c25a1b97.jpg	t	10616.jpg
4116	2128	d33396ca16a6cc9664d440d600e44a71.jpg	t	10601.jpg
4117	2128	d98b4407cc96619b1b4c61aa811816c1.jpg	t	10602.jpg
4118	2129	1998d3bc25bfe1033d32c093e436e92a.jpg	t	11078.jpg
4119	2129	ed280503c63c37c01fb79c725b7f7882.jpg	t	11079.jpg
4120	2129	fca06a6f77ccff4bd9c438e070cfca6b.jpg	t	11080.jpg
4121	2130	466b2c3ff6e548aa2224f8dfde9f060d.jpg	t	11074.jpg
4122	2130	9e6c982d30bb6c28c4bbc174e0750bcf.jpg	t	11075.jpg
4123	2131	9c674cca6fbc1d15075405bd8cc00925.jpg	t	11065.jpg
4124	2131	3215c1a23daa97313cb3c10da3b8b4f0.jpg	t	11066.jpg
4125	2132	8638facb052418c2ce5b53350468be0f.jpg	t	10605.jpg
4126	2132	bab1c16c061a98a34920fe647adccee2.jpg	t	10606.jpg
4127	2133	1eb106821fa54e98194e6e317ff72a83.jpg	t	10621.jpg
4128	2133	62899ed06d870fdbb3f47d1404bc5649.jpg	t	10622.jpg
4129	2134	b04b3aca3f4cfaffad009890663edb3c.jpg	t	10625.jpg
4130	2134	c1f9de4ff6405e7a038816d91ca12a5c.jpg	t	10626.jpg
4131	2135	461ef208d7a05164287ca6ccabd12082.jpg	t	10591.jpg
4132	2135	d61e2da04420d80bde187fafc80785f6.jpg	t	10592.jpg
4133	2136	71fad8d532c3e8f60f28078a54e6f8b5.jpg	t	10595.jpg
4134	2136	6f2e8b19f276c64947f4967c328532c8.jpg	t	10596.jpg
4135	2137	479f3238b651a996822e5fc57e870b34.jpg	t	11060.jpg
4136	2137	3177d1880d9980b7fc4f8f5056463a67.jpg	t	11061.jpg
4137	2138	2cdc3a780f730028637145005746e9c8.jpg	t	11081.jpg
4138	2138	8a34c901d53d23e5d24fbe1342339ec0.jpg	t	11082.jpg
4139	2139	305024e26a0b2aa9a7541f26db1df81d.jpg	t	11088.jpg
4140	2139	c4c77e7b8d053fe7c83d8e0b0bf7435e.jpg	t	11089.jpg
4141	2140	179a7cbdc3a1e594c939d3159e3f25a8.jpg	t	11054.jpg
4142	2140	047ed9f11b319e391be33ee8bd5ec7bd.jpg	t	11055.jpg
4143	2141	8efe80b4e5000fb4551004937fa21648.jpg	t	31173.jpg
4144	2141	5f7ef0592a75dbbf264452c819531c03.jpg	t	31174.jpg
4145	2142	4fb11dabb968ee34200f0fe0099b9b5e.jpg	t	31175.jpg
4146	2142	f045db55f2d3b677c4df36ef49be550c.jpg	t	31176.jpg
4147	2143	7cfbbc8531455d22ff3ebe6603efe2bb.jpg	t	41246.jpg
4148	2143	e5a3d4616b5763404410fba3cb1b7fee.jpg	t	41247.jpg
4149	2144	0a1c7d279e215f3bdd614db9c0f26d82.jpg	t	41214.jpg
4150	2144	dbf692594b78862d19b708a469225bc3.jpg	t	41215.jpg
4151	2145	bda0e93924ddbf1276ee0f1d63382a8d.jpg	t	31169.jpg
4152	2145	c913b39a00134a5d18a4a3b08f465484.jpg	t	31170.jpg
4153	2146	75dec5828f9d03e9607386b098833fd0.jpg	t	41208.jpg
4154	2146	0956afddcf9c58849de3c562621b4123.jpg	t	41209.jpg
4155	2147	b89b3ad3133949751cbb17100cf51e74.jpg	t	41096.jpg
4156	2147	0ea840794ab4da97dd9af6e636151a50.jpg	t	41097.jpg
4157	2148	145ed52d4d5cc1d19f1d0b84db6ec2cb.jpg	t	41210.jpg
4158	2148	674d450b2d258e724be12d94f91953a9.jpg	t	41211.jpg
4159	2149	cf1a19aed9b248176065aba93cced8b9.jpg	t	40960.jpg
4160	2149	0914a223714841b6c2b7e47e97b06d8a.jpg	t	40961.jpg
4161	2150	ea11cb310a72e087ee821071639e7cf8.jpg	t	41206.jpg
4162	2150	8eb961facd9b6fb483cef633d2b736bc.jpg	t	41207.jpg
4163	2151	8eb961facd9b6fb483cef633d2b736bc.jpg	t	41207.jpg
4164	2152	18e76214c59795fefd359653a8564a58.jpg	t	41092.jpg
4165	2152	51c819cf0353750c17a540072fa96dda.jpg	t	41093.jpg
4166	2153	48b9cc2287faeb155ddb8f1ca237f9e6.jpg	t	41234.jpg
4167	2153	0801838c387f142a2f1a0d0d514b3b16.jpg	t	41235.jpg
4168	2154	2ffebdaa066e5ef5000adca96072da6f.jpg	t	41200.jpg
4169	2154	3cfbdc3d72d22637c2e6c6c162ce66ef.jpg	t	41201.jpg
4170	2155	eef45a4fcce2ea7e5e084ebf2d872ba0.jpg	t	41094.jpg
4171	2155	7f42f66ce1843adc6fb0c49b68f87743.jpg	t	41095.jpg
4172	2156	1c713836f8509e14fb9c5992b96da9d1.jpg	t	40962.jpg
4173	2156	10c40976829a3498c3ac90e84a862c4c.jpg	t	40963.jpg
4174	2157	836ebf50cf33b6ed850dc8b5c61357dc.jpg	t	30898.jpg
4175	2157	e73664bd65d9ec882216e9653e7d4e51.jpg	t	30899.jpg
4176	2158	9852793c069b2c7b413951b37ac83104.jpg	t	30900.jpg
4177	2158	3b6e5ce313e2ba777a03194fe584c833.jpg	t	30901.jpg
4178	2159	ba9b6a79db190c80462b4287e8ad3f8d.jpg	t	41236.jpg
4179	2159	b000c9f832913f9142e56409de260401.jpg	t	41237.jpg
4180	2160	95af8058b1b9cd56eec98bba6be102e1.jpg	t	41216.jpg
4181	2160	00314b971f42939264b41ae8e2cdb6ad.jpg	t	41217.jpg
4182	2161	23c5348c52455f628e16ecffde4bb2e7.jpg	t	40956.jpg
4183	2161	5b1f6893675b9fd2fd9377505ade3ad8.jpg	t	40957.jpg
4184	2162	5e1e23eacc361676c5800783942302c0.jpg	t	31326.jpg
4185	2162	a4cc1e323097abaac3a827e1abf82090.jpg	t	31327.jpg
4186	2163	7e81203f653279609fb716ce429e2845.jpg	t	41122.jpg
4187	2163	7aacd71b6c6fef0eadeec7eba253e0fb.jpg	t	41123.jpg
4188	2164	51b5857128f48d4acc5ea5501a23a011.jpg	t	31163.jpg
4189	2164	48af94ef3f1b385c7b8becdb60866ce1.jpg	t	31164.jpg
4190	2165	a196f484eaa9bbd0ccffa1d71ee6f532.jpg	t	31354.jpg
4191	2165	dcf0a12e71dc5ded691f520a7963bf80.jpg	t	31355.jpg
4192	2166	51b5857128f48d4acc5ea5501a23a011.jpg	t	31163.jpg
4193	2166	48af94ef3f1b385c7b8becdb60866ce1.jpg	t	31164.jpg
4194	2167	833ab93d2c81fef959684ed456623012.jpg	t	41052.jpg
4195	2167	03a7f3b3351bdd0a8a26c18773434885.jpg	t	41053.jpg
4196	2168	48b9cc2287faeb155ddb8f1ca237f9e6.jpg	t	41234.jpg
4197	2168	0801838c387f142a2f1a0d0d514b3b16.jpg	t	41235.jpg
4198	2169	06c1767cf7734eb0febff290a9615a8c.jpg	t	40986.jpg
4199	2169	3a2843a70a99073855f71c8bfc2dbf8f.jpg	t	40987.jpg
4200	2170	ffcc3eed57bef649c5526577a3425f75.jpg	t	41232.jpg
4201	2170	0ef9fb8bd301778a77cb90e46aad3f2e.jpg	t	41233.jpg
4202	2171	fa04e325b6fa6355e3e2ff35c806ce45.jpg	t	31348.jpg
4203	2171	fc53ff4b6064df29ef0bba08d61db54c.jpg	t	31349.jpg
4204	2172	bcc45108fecfad684a7f19eea154b8dc.jpg	t	41238.jpg
4205	2172	a2bfe38f325c937797a767b4c7925165.jpg	t	41239.jpg
4206	2173	06d155ff34bb0588e70305b03a071261.jpg	t	40990.jpg
4207	2173	6079787e7f0ed1ed4c9f0cf47043ea20.jpg	t	40991.jpg
4208	2174	75dec5828f9d03e9607386b098833fd0.jpg	t	41208.jpg
4209	2174	0956afddcf9c58849de3c562621b4123.jpg	t	41209.jpg
4210	2175	c6f874cd44c8718a30826ecdbfe789ea.jpg	t	40978.jpg
4211	2175	d118255a8c32e215d33b8f91f049493b.jpg	t	40979.jpg
4212	2176	e96529d26d093af72fbc2fcc7bca0a03.jpg	t	31346.jpg
4213	2176	1631b2e3a1c290d4a4d6eeaa151dd219.jpg	t	31347.jpg
4214	2177	8cd21162e48ab60c1edfd5ee844eacc3.jpg	t	40728.jpg
4215	2177	7a96c502437db87b5fe7b86d3d946a81.jpg	t	40729.jpg
4216	2178	271caef3695bbc5ae3597195edfcd006.jpg	t	40976.jpg
4217	2178	a23cfd9acab07abd0deccc04ef1f43c1.jpg	t	40977.jpg
4218	2179	801311b68e45652bf4976290d9147c49.jpg	t	20010.jpg
4219	2179	02a2f95918907f6abff696aaebe4b07a.jpg	t	20011.jpg
4220	2180	444fce2c5b0af13a9d237523fa3c365c.jpg	t	40968.jpg
4221	2180	81c6f5be7cde690eb3fc9499883b0cae.jpg	t	40973.jpg
4222	2181	6066d02293658f065b92225be06114c5.jpg	t	40972.jpg
4223	2181	10aabcb41370b3108857931964cf4841.jpg	t	40969.jpg
4224	2182	c8bca4138f85061c630c22fdf496c196.jpg	t	40994.jpg
4225	2182	6cba008f4478d6969ac49ee873ede30e.jpg	t	40995.jpg
4226	2183	8f203afd48a7ee6069e5170d622f5b54.jpg	t	40964.jpg
4227	2183	9831670080526d95cb155bce8ab7f967.jpg	t	40965.jpg
4228	2184	79116b5992464fca0ea5938118aebc87.jpg	t	40988.jpg
4229	2184	e286e787deb9c7bdff59d17810b384db.jpg	t	40989.jpg
4230	2185	aa572224d42a296b21d7eb1d3645f5a7.jpg	t	40980.jpg
4231	2185	93612f90f7b81950cf971e06418ba9f0.jpg	t	40981.jpg
4232	2186	589752897e9bd2b24fbfe207d05b565f.jpg	t	40992.jpg
4233	2186	91e2ebe7e657ce4f7f213aadebe1095f.jpg	t	40993.jpg
4234	2187	b1e0e86025c84d2fa05d210cdc9e59fb.jpg	t	40966.jpg
4235	2187	6dc88d3408ae4797f64a612b59587a94.jpg	t	40967.jpg
4236	2188	9492d7d1b785d75b4503e5fe70947b43.jpg	t	40970.jpg
4237	2188	378667101d5f8b384718e5daa918c4b0.jpg	t	40971.jpg
4238	2189	ccd7e2d750fdc69ae9e0b6e572bc135e.jpg	t	40958.jpg
4239	2189	b1298c789d329061541248d9eaeb6a5d.jpg	t	40959.jpg
4240	2190	4a46f9c508ff0cd0cc7258d9ed17644f.jpg	t	40984.jpg
4241	2190	bdb5214b6e37238ddb87a38208852ffb.jpg	t	40985.jpg
4242	2191	ca521476fe6a2f46a83b203f7f2cae9b.jpg	t	40982.jpg
4243	2191	1eb2cd46e3ddd7322198eecc459d31fd.jpg	t	40983.jpg
4244	2192	798b03ec2511469b0c5cd8f8549e5227.jpg	t	31365.jpg
4245	2192	ea09494fd83aae31b82922460d5cc1e8.jpg	t	31366.jpg
4246	2193	6764b9ae18eebf099b360b894de08e5f.jpg	t	30977.jpg
4247	2193	637cff737ea395fc689fd974fb860fec.jpg	t	30978.jpg
4248	2194	e3127fb99c05449cf6790e721e651d08.jpg	t	41190.jpg
4249	2194	fde166924b0f1fe42968b3885930ff9f.jpg	t	41191.jpg
4250	2195	b7d7737407987ff5e5033c7b0821e4ea.jpg	t	41194.jpg
4251	2195	137cd93de84fa9d82ab4d87a9f90984b.jpg	t	41195.jpg
4252	2196	506d367223e7d59ba47b333d18b0a66d.jpg	t	40974.jpg
4253	2196	0607c2b7d1e4fc76ce248c753977315b.jpg	t	40975.jpg
4254	2197	d64ecf50f9cd455c46a76e2863dcbd05.jpg	t	31179.jpg
4255	2197	13c1e1d66e7710b049ce5dbc4af8ed3c.jpg	t	31180.jpg
4256	2198	f46d1cb3b900a482dd9bf911fb302525.jpg	t	31182.jpg
4257	2198	39d710be00dc16b7d9c9a78d4381596c.jpg	t	31183.jpg
4258	2199	4b2defe1eb47895f7c5a648c8f0b06a2.jpg	t	31161.jpg
4259	2199	c3719c44e1ccce0efae207d03c6e8230.jpg	t	31162.jpg
4260	2200	06fec6c7baa0b82d607674464d122744.jpg	t	30461.jpg
4261	2200	bd83664821f4b891840bdfcf1aa21ece.jpg	t	30462.jpg
4262	2201	81b90b0028eebc78c00c13f36670a355.jpg	t	31322.jpg
4263	2201	c56d8cef41790e96c63294cabdf40001.jpg	t	31323.jpg
4264	2202	f671ecdfd93bc76518fbc429c8fd608e.jpg	t	41038.jpg
4265	2202	9efc5fa5762622152a69d7dc3c153550.jpg	t	41039.jpg
4266	2203	d31d23da76e68505a120e85b26b63256.jpg	t	41020.jpg
4267	2203	4ccde167a8485342bd7db09f34ad5e65.jpg	t	41021.jpg
4268	2204	c685cea982fd63f96e809deec3bfc229.jpg	t	40948.jpg
4269	2204	3b9ce16c89ee90e6c6cc4245d9593865.jpg	t	40949.jpg
4270	2206	19cefc418939b8d6933050b972853dc6.jpg	t	41022.jpg
4271	2206	19d6c2875c7016a9184fd5e3d6243c60.jpg	t	41023.jpg
4272	2207	1aacfaac54b53b2cbea7e400b5ede082.jpg	t	41130.jpg
4273	2207	b6688443d5b430bbe252ca149762c17c.jpg	t	41131.jpg
4274	2208	b7dfc2d31e2a39cf078342ce1a676a3a.jpg	t	41026.jpg
4275	2208	3d6988f31fc3feef633d65f14841f2a4.jpg	t	41027.jpg
4276	2209	5a16ea55c1530d732a825abd8981de12.jpg	t	31324.jpg
4277	2209	48d7fcb26f00aa72e77896e1661689c8.jpg	t	31325.jpg
4278	2210	1fa5a9eedef8aaa45397dab105219077.jpg	t	41124.jpg
4279	2210	589036972612bac308db474c5a4c700b.jpg	t	41125.jpg
4280	2211	5913ef41dd3ce87beb1ea65e39fffcd9.jpg	t	30331.jpg
4281	2211	1e948755099e740f26e0f0f7d8615b82.jpg	t	30330.jpg
4282	2212	4f9a89f94a5749e5c32ea7a06a380314.jpg	t	40665.jpg
4283	2212	0d27efa9e61efbc27d65ba88fd4d1404.jpg	t	40666.jpg
4284	2213	e54592705e94a65e0bff9a302649dad3.jpg	t	31328.jpg
4285	2213	56cdcd46f54b07b15341e91e9d23ec95.jpg	t	31329.jpg
4286	2214	a2c405409e6326bcd2cb609bdb8c2758.jpg	t	41104.jpg
4287	2214	afbca358631ee42d6ec5c04259997cce.jpg	t	41105.jpg
4288	2215	39a7e04362ade7f1333849beb7d1b0bb.jpg	t	41098.jpg
4289	2215	c0db6de39cb9ecedcf294dd2235af8ff.jpg	t	41099.jpg
4290	2216	943e8876f5e52b6af948cb40b512902a.jpg	t	40675.jpg
4291	2216	dc5badd300c9ffcc501e424de5d8417d.jpg	t	40676.jpg
4292	2217	f6059324558d677d4453f61a673e3513.jpg	t	40659.jpg
4293	2217	d087d0b830f339dfaa46289e5ac11a8f.jpg	t	40660.jpg
4294	2218	02f84c29bc2a1e2484ac916de4be554d.jpg	t	40881.jpg
4295	2219	ad6734fe7405289f0aec1f85c88e6f3e.jpg	t	40677.jpg
4296	2219	e8ebcd21e698fe76f9fde88aaa859ed5.jpg	t	40678.jpg
4297	2220	39a7e04362ade7f1333849beb7d1b0bb.jpg	t	41098.jpg
4298	2220	c0db6de39cb9ecedcf294dd2235af8ff.jpg	t	41099.jpg
4299	2221	5e1e23eacc361676c5800783942302c0.jpg	t	31326.jpg
4300	2221	a4cc1e323097abaac3a827e1abf82090.jpg	t	31327.jpg
4301	2222	62118518fed4f65ef14661d0161f672d.jpg	t	41120.jpg
4302	2222	666d1a571a0c97e4b8784a3b950a3876.jpg	t	41121.jpg
4303	2223	cdf1ffa099028cb56bc00a16adadbff2.jpg	t	40649.jpg
4304	2223	e154b8b00afcc8976d8644cb307bc131.jpg	t	40650.jpg
4305	2224	879bd6749ad4059a9b23f0b45d05556c.jpg	t	41108.jpg
4306	2224	84c020006c4f3a25930f9ea5c2d64a79.jpg	t	41109.jpg
4307	2225	848b213fb5ec562d7bc68a4419ec174a.jpg	t	40637.jpg
4308	2225	d3395e1047121b645f7cfb0a231ed2bb.jpg	t	40638.jpg
4309	2226	736360f53edc83abcf6bfaa97bfe0fe2.jpg	t	40671.jpg
4310	2226	ac304845664a0835ff5118907b8d306e.jpg	t	40672.jpg
4311	2227	51943fca2f490233009432004e628d61.jpg	t	40645.jpg
4312	2227	fa3d7301d03b684b4593bb4bc5f2aa96.jpg	t	40646.jpg
4313	2228	cccb9347849ac3b10b15509f6d2899d4.jpg	t	40667.jpg
4314	2228	c5016c4b26ccd8c9adbc4d7c2154508f.jpg	t	40668.jpg
4315	2229	494d8e825ad60423d9993fccd3750dd6.jpg	t	40623.jpg
4316	2229	302b7d82aabd96a8224f8fe18c6c5f0c.jpg	t	40624.jpg
4317	2230	e782190a3794a282e4669e62c5766b58.jpg	t	40625.jpg
4318	2230	241d8c9145a531eebe93ff7da4be2ab1.jpg	t	40626.jpg
4319	2231	ddfaaff9d9ca25c1aeca44933c7a9ebc.jpg	t	40669.jpg
4320	2231	4b44f601b7abf77295ba793dcb76e46a.jpg	t	40670.jpg
4321	2232	50c44766dcbc02255a8c5a89025f0036.jpg	t	30264.jpg
4322	2232	83c6859de8e450393ce0844c1aa9a9a1.jpg	t	30265.jpg
4323	2233	e266acd8f003cb29843096d9fa3fd154.jpg	t	40633.jpg
4324	2233	876ffbc872102b5ffaa13da29d6e5fe8.jpg	t	40634.jpg
4325	2234	5d7266d880e583599a5455049dc725fb.jpg	t	40934.jpg
4326	2234	f67778be953cfef776cf91a743983651.jpg	t	40935.jpg
4327	2235	4479d0290f12638e7249c65b4fc456b6.jpg	t	41220.jpg
4328	2235	44bc8defa12287953ebf567332242405.jpg	t	41221.jpg
4329	2236	c1fa531d89aba233432fd2556c6b8ad5.jpg	t	40946.jpg
4330	2236	e49336d9c4c9c8a954debb344c3861a3.jpg	t	40947.jpg
4331	2237	7e40409a33b533358103c7fda47f4a14.jpg	t	40621.jpg
4332	2237	2b85e1121576039bb6c14bb9712d402f.jpg	t	40622.jpg
4333	2238	c21593fa2a3d4459611ef4e263c21e03.jpg	t	41008.jpg
4334	2238	115a39a4b45efd0268e637692f64ae5c.jpg	t	41009.jpg
4335	2239	eb75e4aebb5deb1ca281832d018d2e39.jpg	t	41032.jpg
4336	2239	ec9761acea58318300611bfb713f3098.jpg	t	41033.jpg
4337	2240	caf9e9deed10b4861de9e5db1c3c5606.jpg	t	41040.jpg
4338	2240	be7d7c03340c1a1d8f92e8423f6b450a.jpg	t	41041.jpg
4339	2241	f05c58395ff5101518b6d1841c18ef27.jpg	t	41028.jpg
4340	2241	115d2f822eb25a5ace0d976801c2376a.jpg	t	41029.jpg
4341	2242	224457e71f4bb1fa6df7ecc64f5452fd.jpg	t	40655.jpg
4342	2242	1cfdd4fb6d04a4446156b67e7d4f9915.jpg	t	40656.jpg
4343	2243	16d868a4f011c768556cbda7d0fd8fe0.jpg	t	41012.jpg
4344	2243	a76f7e391dc77bd4b3e1dfc666c1e6d0.jpg	t	41013.jpg
4345	2244	9273289aab51979db3030670441e63d0.jpg	t	40651.jpg
4346	2244	a7c905a47ee10d09fc5fdfc905fbe0ae.jpg	t	40652.jpg
4347	2245	a3adf7eb739bb29b5bd74be54b4633a0.jpg	t	40661.jpg
4348	2245	25d9c9933d91b5deb45fc6571223b209.jpg	t	40662.jpg
4349	2246	c24f1ccc4fef5bec1639250659f84137.jpg	t	41018.jpg
4350	2246	7980a441cc42466a9c2213e6a1580c74.jpg	t	41019.jpg
4351	2247	3ae239663627c7b2ce909647623d4fdd.jpg	t	40952.jpg
4352	2247	0995f46dbceb3c2519d1a1d3022e295d.jpg	t	40953.jpg
4353	2248	bd806fcc3225db3affeccf8d94c7c002.jpg	t	41046.jpg
4354	2248	057a7a7bb91c3e11547dbf87e2b2edd3.jpg	t	41047.jpg
4355	2249	5a0a5ac3c079994aba682ffc01693606.jpg	t	41016.jpg
4356	2249	c2db3201b4075f3cf41b66d841701933.jpg	t	41017.jpg
4357	2250	aa981e3d32841e59103fefe023c6c2f2.jpg	t	41014.jpg
4358	2250	c497f18b8502f1bdc30b259322f997e3.jpg	t	41015.jpg
4359	2251	32bf56bd4578fea69dada13f6bafe730.jpg	t	40631.jpg
4360	2251	b3aca4adfb98f5528ce04daed48e4260.jpg	t	40632.jpg
4361	2252	cec39f3de1f2f80c0261c7db823e9a0a.jpg	t	31368.jpg
4362	2252	d14970d2fb12786d037044652414ee25.jpg	t	31367.jpg
4363	2253	c28e9bc34428c126ea36942306f0158b.jpg	t	41010.jpg
4364	2253	fe9bb1a650f91b6a3b2783067a1f4fd0.jpg	t	41011.jpg
4365	2254	6e74e7b124329f3c746560ae51cad988.jpg	t	10641.jpg
4366	2254	a91c57c58d6d40c828abf50dafa5b09d.jpg	t	10642.jpg
4367	2255	f30ac32a2eebad2a7b3d90793365debc.jpg	t	31081.jpg
4368	2255	bd047c149ce6729ad30fe5497ad68bdb.jpg	t	31082.jpg
4369	2256	71144b5aa66c20a69e0e576a9788f33c.jpg	t	30484.jpg
4370	2256	b62c82e257571ba2af5bd63d725b7b65.jpg	t	30485.jpg
4371	2257	4d32f2778cf6898cf94b3f4506ebef21.jpg	t	31356.jpg
4372	2257	9a41849c7a2505faf82a1de44985fb15.jpg	t	31358.jpg
4373	2258	ddf6c2f59ba9a6d6bdb0518873fe3923.jpg	t	40119.jpg
4374	2258	de0c7cb191cde99bca5ad8c5524b8dcb.jpg	t	40120.jpg
4375	2259	049cf3cfe349a99cc0c5fa8aa4e5b322.jpg	t	30876.jpg
4376	2259	720c5c77419223b71b2ccd73fb9e621b.jpg	t	30877.jpg
4377	2260	f3a26e000f4122375c7a0bac4aae40bd.jpg	t	30874.jpg
4378	2260	f1ddf10da08752c203941777542132c1.jpg	t	30875.jpg
4379	2261	0b1fe8def442c0cdeb9c82596a7bcb0f.jpg	t	40124.jpg
4380	2261	fa6b23905c8eb722c68dd70bc3bb3602.jpg	t	40125.jpg
4381	2262	3bd83b54a5dfc73d49e14c0974e61c32.jpg	t	31001.jpg
4382	2262	ff98df215b15a2457c8de32d46d6f6e4.jpg	t	31002.jpg
4383	2263	10267f351192b6de7f398762adc7b58d.jpg	t	50028.jpg
4384	2263	94900238aff33aa9084bf9958d12f0db.jpg	t	50029.jpg
4385	2264	69843b62940483aeb6c23fd88d82ef67.jpg	t	50056.jpg
4386	2264	a48888938a9950724441237f64722bd7.jpg	t	50057.jpg
4387	2265	8918dcc1edb2a7e6bec38b2f6691bbbd.jpg	t	31003.jpg
4388	2265	6bf389f785a0260956eb919457528024.jpg	t	31004.jpg
4389	2266	7f821ccd259aa75f63ac9d7c3d7950fa.jpg	t	30005.jpg
4390	2266	acb4c3f2ba35ea4961a319c0bd38ced0.jpg	t	30006.jpg
4391	2267	7071d93bcc1a5bcb147917b9120d0e2e.jpg	t	30003.jpg
4392	2267	0f67474065726dda0296b7cd6f27b132.jpg	t	30004.jpg
4393	2268	4b0e25f0b7d858dccc549301bab4cad7.jpg	t	30017.jpg
4394	2268	be694bc50f4034605b32e3c922cd3bbc.jpg	t	30018.jpg
4395	2269	87321d385b1e44e7a326841b64e0fa01.jpg	t	30021.jpg
4396	2269	aa1904c14885a5b7b28a7bd817c92eb5.jpg	t	30022.jpg
4397	2270	5e396b0e848b878749ef266fefb2f1a2.jpg	t	30015.jpg
4398	2270	496642cf8ad0e37da41e32c8eb19cd21.jpg	t	30016.jpg
4399	2271	48a970f69f4e03ec04d352ee62010847.jpg	t	30057.jpg
4400	2271	15ba67b9000226c80fd4f51b45d95b02.jpg	t	30058.jpg
4401	2272	e3127fb99c05449cf6790e721e651d08.jpg	t	41190.jpg
4402	2272	fde166924b0f1fe42968b3885930ff9f.jpg	t	41191.jpg
4403	2273	8f15f4850630a29e2cb67a5c592f5e9d.jpg	t	31392.jpg
4404	2273	70c9d0b1b0e26c11bd5a08b28be0c08d.jpg	t	31393.jpg
4405	2274	457b9929a3b58f85cfaca8a761a4f51f.jpg	t	41164.jpg
4406	2274	6fc6896c1620c61f0161abb727f49a58.jpg	t	41165.jpg
4407	2275	a4bd7feee730cbc6d1894b80fba96a3f.jpg	t	30549.jpg
4408	2275	d0d2f106673164074ae49e02cac8c1f7.jpg	t	30550.jpg
4409	2276	4f287145dfc2d26d23afd090b60cc722.jpg	t	41148.jpg
4410	2276	2bc346e79e6cf9c4443fbf4c3062b3c6.jpg	t	41149.jpg
4411	2277	9911a09d73a3605df261fa0a27711bf7.jpg	t	30959.jpg
4412	2277	a0ae57886379fa3bc109a411d5f35066.jpg	t	30960.jpg
4413	2278	1fa5a9eedef8aaa45397dab105219077.jpg	t	41124.jpg
4414	2278	589036972612bac308db474c5a4c700b.jpg	t	41125.jpg
4415	2279	651f1f3a85ae2b9a548b63702b90dc29.jpg	t	41000.jpg
4416	2279	24a3c9e732c59bd44c9cc23d09b46b40.jpg	t	41001.jpg
4417	2280	0a989817592ee4e34bf7b652b7721157.jpg	t	50052.jpg
4418	2281	f976f2948ed91f484319c3ea9e9ce445.jpg	t	50048.jpg
4419	2281	49de5ae337fe3cb39bba0e18c4adb6b1.jpg	t	50049.jpg
4420	2282	34acf95563ba98132e0755c7eb113dec.jpg	t	30981.jpg
4421	2283	0a17ecf0e753cc43e2fec2b4d99790f8.jpg	t	50050.jpg
4422	2283	d77b1913a4d09a7024d8098fbe006f01.jpg	t	50051.jpg
4423	2284	4f9a95cbdc58e8a3d3ef14c1397b422e.jpg	t	31244.jpg
4424	2284	b78a836ce6d72bfb11f877c6dd01e670.jpg	t	31245.jpg
4425	2285	1aca5d4f6ddf80c7c30e217865078ca3.jpg	t	41004.jpg
4426	2285	f358ef5d85c4ae5fca0690bbb0049c51.jpg	t	41005.jpg
4427	2286	a563243a75b3cea00f4058be264ddf60.jpg	t	31071.jpg
4428	2286	b89f027f80443f49f9b5b4a798c7f341.jpg	t	31072.jpg
4429	2287	81b90b0028eebc78c00c13f36670a355.jpg	t	31322.jpg
4430	2287	c56d8cef41790e96c63294cabdf40001.jpg	t	31323.jpg
4431	2288	accd75874f4db8b944dee940b2ec6db5.jpg	t	31075.jpg
4432	2288	9e98cd0f0042649d1701ad1d043b1d45.jpg	t	31076.jpg
4433	2289	2a192636bb734a5681f68844c8c7fc68.jpg	t	31248.jpg
4434	2289	0fefc6f9246eaeb8ec827edd47c1f9d4.jpg	t	31249.jpg
4435	2290	509b48ead0a6113a01eadd6e0882b6fb.jpg	t	31280.jpg
4436	2290	594e6bd8d67d0efda0eaf60f79acfd5c.jpg	t	31281.jpg
4437	2291	1657b0e8dcf0b0e496a7f1132aae04da.jpg	t	31284.jpg
4438	2291	4f01a4c3e02e263787b828a4a1dfd33f.jpg	t	31285.jpg
4439	2292	57219708aea400e2fa51f7485ec2bc4e.jpg	t	31266.jpg
4440	2292	f73bcbefe9e361845b1605615f3a98da.jpg	t	31267.jpg
4441	2293	a82cc98e03555d1a377d418017ec0226.jpg	t	31282.jpg
4442	2293	b34047e66298011b0f7c66fbc0434a4c.jpg	t	31283.jpg
4443	2294	32b2cec01aff11f4cb83e718a8f42938.jpg	t	31294.jpg
4444	2294	9dcb3849b333cfeb55cf0bb626e862d1.jpg	t	31295.jpg
4445	2295	57ed03a131f180b8d0dc458e20593ddf.jpg	t	31264.jpg
4446	2295	f20cf05b3fe5219b494d72436d5504d2.jpg	t	31265.jpg
4447	2296	08e676752cb07ca44993afc0a504f059.jpg	t	31268.jpg
4448	2296	2fe0494f847e4048870126baedbc96a9.jpg	t	31269.jpg
4449	2297	fe671dd1517afa9a681cc1455947c90b.jpg	t	31278.jpg
4450	2297	04e4ce699b8b10a54105889c63369255.jpg	t	31279.jpg
4451	2298	c65d1f852a3542252d2bd29b4582bfe9.jpg	t	30858.jpg
4452	2298	334fe448068824104ebf9cd3442b12aa.jpg	t	30859.jpg
4453	2299	245ba7815b0a1726120d857d117e475d.jpg	t	10720.jpg
4454	2299	b1d738d226ccc25b8eb328a67eef5445.jpg	t	10721.jpg
4455	2300	a7da75e9e77a99c158518de10df4ff4f.jpg	t	31371.jpg
4456	2300	1cee4c9eec67a0c65aa92c70c3f74e42.jpg	t	31372.jpg
4457	2301	8ed29e27eeaec031979aed9b7bcb0768.jpg	t	40719.jpg
4458	2301	484f428fb2bd453b2d3b8b56198424bd.jpg	t	40717.jpg
4459	2302	69843b62940483aeb6c23fd88d82ef67.jpg	t	50056.jpg
4460	2302	a48888938a9950724441237f64722bd7.jpg	t	50057.jpg
4461	2303	c97c03e21cf53697397b5ebcf3bed1b9.jpg	t	31256.jpg
4462	2303	8c56cc4f2c8409c48cff985cd4a1fd84.jpg	t	31257.jpg
4463	2304	86acf20c777c651a25d6e42c21d91af3.jpg	t	50046.jpg
4464	2304	fd22014eb8d00bd76a2072833200cccd.jpg	t	50047.jpg
4465	2305	f02bce933696cd7e92e7a88e13111ca2.jpg	t	31025.jpg
4466	2305	86d6b20393a3735530ae22b2c29d467e.jpg	t	31026.jpg
4467	2306	2176e601038810d6a971390f88f7eba1.jpg	t	31023.jpg
4468	2306	3c83e58f92baf479ac868e9da5cf77fb.jpg	t	31024.jpg
4469	2307	1594dfe204c1353451d2e364e1b13803.jpg	t	31031.jpg
4470	2307	a5d6cd4590c23b1c29559bdbdb4d387a.jpg	t	31032.jpg
4471	2308	569fc6b9b30f981b264e9da90df5006a.jpg	t	30029.jpg
4472	2308	461361d484a3d1566f388b21d5c43610.jpg	t	30030.jpg
4473	2309	69ad3b64a280e7556756707037bba538.jpg	t	30037.jpg
4474	2309	d128cb7be803cae9ac1f293e19ca0d35.jpg	t	30038.jpg
4475	2310	3866ac9b683ee24e559400adaf1c4d39.jpg	t	30033.jpg
4476	2310	488047a2145fac2a9a6cef77f0335cd1.jpg	t	30034.jpg
4477	2311	75f7699098f8b8857443be0e1f03b45a.jpg	t	50009.jpg
4478	2311	e287c7c9c8a9f6f83dd8027437b5d56c.jpg	t	50010.jpg
4479	2312	8ed29e27eeaec031979aed9b7bcb0768.jpg	t	40719.jpg
4480	2312	484f428fb2bd453b2d3b8b56198424bd.jpg	t	40717.jpg
4481	2313	7002b26156c8408d689257c36f15cba8.jpg	t	30027.jpg
4482	2313	6aa7f2f7a34e366a054fe2ffdcfae6e8.jpg	t	30028.jpg
4483	2314	96442d8d23e4ea1395c6ed1e20b090c4.jpg	t	50053.jpg
4484	2314	a8fa9528d55682f68f3470427cc81782.jpg	t	50054.jpg
4485	2315	400d9f52a6c5bdd3c29857dbef9a7a48.jpg	t	30051.jpg
4486	2315	d5c2797e3aab7b26b2295f79de19bad3.jpg	t	30052.jpg
4487	2316	a2084f6a2fc64060deb1f783bdaf253e.jpg	t	30045.jpg
4488	2316	43af81817fa4d143946d9c0e88cac668.jpg	t	30046.jpg
4489	2317	224457e71f4bb1fa6df7ecc64f5452fd.jpg	t	40655.jpg
4490	2317	1cfdd4fb6d04a4446156b67e7d4f9915.jpg	t	40656.jpg
4491	2318	c88ecdbeb7f6b38da97a13d9013a0f5a.jpg	t	20309.jpg
4492	2318	c88ecdbeb7f6b38da97a13d9013a0f5a.jpg	t	20309.jpg
4493	2319	72a724fc9f21ab52a9224373d54a50c5.jpg	t	30732.jpg
4494	2319	a65f5439e9dd564c9752dda25e8cc90f.jpg	t	30733.jpg
4495	2320	d86e85367b27b41c4f25b8443760cf44.jpg	t	30744.jpg
4496	2320	e28f55cfc576908217a1fe718b62f9ea.jpg	t	30745.jpg
4497	2321	9ab983e6f22dd448bece0f89efe0ddad.jpg	t	50016.jpg
4498	2321	8d07644de5171ad5d87f7efdddff56d5.jpg	t	50017.jpg
4499	2322	3323591c456c0abfe778f59be882db6a.jpg	t	30742.jpg
4500	2322	42083653b4ec95092efec19fddcfb5ae.jpg	t	30743.jpg
4501	2323	545aac82a938d019012313b18e063187.jpg	t	50007.jpg
4502	2323	0934213c2b858620a117fdaa024172db.jpg	t	50008.jpg
4503	2324	08d9822a229ac6af557e54726e461977.jpg	t	50001.jpg
4504	2324	721ec9da844ce00ade0e2b57f7852138.jpg	t	50004.jpg
4505	2325	dc3271e42c10bf4fcc7d0b374173b2a6.jpg	t	50018.jpg
4506	2325	8560140ee6e6b010d9214040a561870c.jpg	t	50019.jpg
4507	2326	c83196fb1a1f294bd998507cfc1b629b.jpg	t	30053.jpg
4508	2326	00d3fc6934582303b3cb2732154c6e8e.jpg	t	30054.jpg
4509	2327	34e14c2179da973448027a2ddebf1a1d.jpg	t	40852.jpg
4510	2327	e237566f32b5d1f745635b7e7110b6a9.jpg	t	40853.jpg
4511	2328	8c46e6849627773bd4fcb7d02749f889.jpg	t	31035.jpg
4512	2328	a0503cc70e8a726dc1731b4248de5db9.jpg	t	31036.jpg
4513	2329	4f0f8e0724331ab34954a6b2769cbe8c.jpg	t	31054.jpg
4514	2329	6deaf84c5b7050021d869666fbc40957.jpg	t	31055.jpg
4515	2330	6e55edb8c3aa02fe31a87e8c3864da0f.jpg	t	31056.jpg
4516	2330	80d6770e0e223d3c8e290d94a65586a1.jpg	t	31057.jpg
4517	2331	bfdfecc0ba9f5dd7b62d00614fc28fe0.jpg	t	31314.jpg
4518	2331	e06d6575bcc42b1ec2293584b4cc2e56.jpg	t	31315.jpg
4519	2332	683db72d217458af85b73e1083c24b71.jpg	t	31052.jpg
4520	2332	a757a51f08fc33e86b26ab68d21238a2.jpg	t	31053.jpg
4521	2333	c3c7c81bc11b7db4a13819bdfba145ef.jpg	t	31306.jpg
4522	2333	80f6aeede528787ee4cf934c9d4b10c8.jpg	t	31307.jpg
4523	2334	772e6932b4e89a73ed7e74f29adcda95.jpg	t	31041.jpg
4524	2334	28108df8bb7f492d35884d2ca208a9e5.jpg	t	31042.jpg
4525	2335	b8fa350c4503d70a542571d0a48fda19.jpg	t	31113.jpg
4526	2335	4aeee1839988b515bc16b85181665f8f.jpg	t	31114.jpg
4527	2336	7aa39fd7d51dd80d6a3a411d53fcd78d.jpg	t	31316.jpg
4528	2336	39907bbbd2f51df14b3cb45d058435dd.jpg	t	31317.jpg
4529	2337	c39a1f5bc2256890c92e429d752ede65.jpg	t	40832.jpg
4530	2337	270a8ed4e7d29e36617aa25e786c8f87.jpg	t	40833.jpg
4531	2338	e6efc5bd51ca555e65c746836d67c093.jpg	t	31051.jpg
4532	2338	a757a51f08fc33e86b26ab68d21238a2.jpg	t	31053.jpg
4533	2339	60638bd8b8721c9c54e16eae2c3551ad.jpg	t	31125.jpg
4534	2339	1af715fffdc1f81bb6f91abbdf2f2688.jpg	t	31126.jpg
4535	2340	0179ecc95c0a39976856e6fe99f99183.jpg	t	31310.jpg
4536	2340	ff22ffb324829a928300affd5808af91.jpg	t	31311.jpg
4537	2341	a992d999fdefcef54e59371e4f44da6c.jpg	t	30553.jpg
4538	2341	533bfda332dcad9649fda51fa8ac2f8e.jpg	t	30554.jpg
4539	2342	98cd65eece028536adb5f3d6673da319.jpg	t	31121.jpg
4540	2342	3f710b12dd82b4e078501bbda18f9fcd.jpg	t	31122.jpg
4541	2343	1098334b1c7b939dddf9f49ca33266fc.jpg	t	31135.jpg
4542	2343	1ca6b0800a8e145f1b1f88aa10e12deb.jpg	t	31136.jpg
4543	2344	eb4074e7c68d6383563d901c792ef443.jpg	t	41168.jpg
4544	2344	c12e6ac75882020c05ba3ac99b1845b2.jpg	t	41169.jpg
4545	2345	9f44302e85a3b2d2b5ad2bc8f7f5b273.jpg	t	41080.jpg
4546	2345	9061f52b24b64e06de10acbc02fa3398.jpg	t	41081.jpg
4547	2346	a8fc462259ea1e432c0c09ab35e36cc8.jpg	t	31109.jpg
4548	2346	11f3b54429e29fe3c483f28414b1a137.jpg	t	31110.jpg
4549	2347	f9f6bbddaa2f24d8be5b759c30197356.jpg	t	31105.jpg
4550	2347	ee80f7072a607d2e2f6ba6f360ef56d1.jpg	t	31106.jpg
4551	2348	8e3e4a8e4a46728e8adfaa5666e3dae0.jpg	t	31312.jpg
4552	2348	2f436086f6c342c2fbd74c5724041e12.jpg	t	31313.jpg
4553	2349	698653123311b0a3c0d02809b1f1f887.jpg	t	31129.jpg
4554	2349	0fdde248c44cf660ed67be999bd79a26.jpg	t	31130.jpg
4555	2350	e441d06f2e6835c9c51aa4112e2b9353.jpg	t	31119.jpg
4556	2350	7f52eef1a2c3daaabb42a33046cb604d.jpg	t	31120.jpg
4557	2351	e467c698ae352dbcbe390d4a00e8fd64.jpg	t	40822.jpg
4558	2351	678d7c1fcf748802afec824147ecb41c.jpg	t	40823.jpg
4559	2352	33c106087a8a3de4aea67945a6fd23a2.jpg	t	41054.jpg
4560	2353	b2173de45d88c373833f4d0d1f602392.jpg	t	40818.jpg
4561	2353	6d1a4655c384023753d40dc1cc6d780a.jpg	t	40819.jpg
4562	2354	da3d618165da4c07199ce12d84cec909.jpg	t	31210.jpg
4563	2354	07e08830bcb7e74bfd13d54ff9eff8d3.jpg	t	31211.jpg
4564	2355	a5e0fa097e3bcf3c22af2eea927a97ee.jpg	t	31208.jpg
4565	2355	bc76a115052363a5649ea2089477b9d9.jpg	t	31209.jpg
4566	2356	a914201473a39aeb4232e297e3a22de6.jpg	t	31157.jpg
4567	2356	76424bb13bc6469bcdde489d95bb9b7a.jpg	t	31158.jpg
4568	2357	3c097cff3b60d2b0a77f242357476b86.jpg	t	40938.jpg
4569	2357	6fe654921fa6379eddd589deffb5980f.jpg	t	40939.jpg
4570	2358	eb75e4aebb5deb1ca281832d018d2e39.jpg	t	41032.jpg
4571	2358	ec9761acea58318300611bfb713f3098.jpg	t	41033.jpg
4572	2359	899ba7ed209e32392eef5ac622645f9b.jpg	t	40942.jpg
4573	2359	22d4fe6a2bf2c13ce83a89aa6bf70c0b.jpg	t	40943.jpg
4574	2360	227d09afd532c8d9431697d23bcc0121.jpg	t	20212.jpg
4575	2360	22ebd062a723812094a9298171abf88a.jpg	t	20213.jpg
4576	2361	0a17ecf0e753cc43e2fec2b4d99790f8.jpg	t	50050.jpg
4577	2361	d77b1913a4d09a7024d8098fbe006f01.jpg	t	50051.jpg
4578	2362	0f56b59394c5d9e957668bd0bc186e98.jpg	t	31192.jpg
4579	2362	95e9b57e129e97137b9b64588d63dad2.jpg	t	31193.jpg
4580	2363	7baa0c4cc93ac4beca45e72b7a92945e.jpg	t	31186.jpg
4581	2363	bd2fd8d7e1aef0eea3017ec5b25c9200.jpg	t	31187.jpg
4582	2364	7baa0c4cc93ac4beca45e72b7a92945e.jpg	t	31186.jpg
4583	2364	bd2fd8d7e1aef0eea3017ec5b25c9200.jpg	t	31187.jpg
4584	2365	bb515e1bc9502d5089a172f8c99c1441.jpg	t	50022.jpg
4585	2365	6eb82fafb8662b3e720bc478671899c3.jpg	t	50023.jpg
4586	2366	5bdfa94fc96d58fd6f9f42220302ebf3.jpg	t	31384.jpg
4587	2366	1eca53c2db607032644596bc2ea84952.jpg	t	31385.jpg
4588	2367	380a6af2d1457748bbffbcd27834ccb5.jpg	t	31381.jpg
4589	2367	03618c76b0cbeb6d162ff5c858ead433.jpg	t	31383.jpg
4590	2368	dbd642e2fcd15deaa13523ebaca3d5f1.jpg	t	31390.jpg
4591	2368	6d606a58fb51523c768d15e2f0472b7c.jpg	t	31391.jpg
4592	2369	db8ef1b9339fcf443f686b2d4040bbda.jpg	t	31400.jpg
4593	2369	9cb3afd27ee3e77a845fef5a897ae575.jpg	t	31401.jpg
4594	2370	8e12ba4b61255ed093efc7e08fa530dc.jpg	t	30868.jpg
4595	2370	e94a19eda35f6f28ba79b424706b68f5.jpg	t	30870.jpg
4596	2371	1503642c40cccde8ece4a33ae1eeae97.jpg	t	31288.jpg
4597	2371	27ab1dc9e061fc44971f8cccbc1a2b76.jpg	t	31289.jpg
4598	2372	c39ded3cbbf87ddf6aba8d2aaf5c8d52.jpg	t	31098.jpg
4599	2372	335f8d17e99f84c948352b8b40fe0c71.jpg	t	31099.jpg
4600	2373	dcf02cf6ffb06434f056bb5678937aab.jpg	t	31067.jpg
4601	2373	3b17bb4acc078cb78aeb60feb1b8ad34.jpg	t	31068.jpg
4602	2374	305c8c24c82205020ab061f63015a818.jpg	t	31096.jpg
4603	2374	fa6138b889744c405c5028112f72877c.jpg	t	31097.jpg
4604	2375	0772a55b7e0e7139ec3fcf6536856985.jpg	t	31270.jpg
4605	2375	208ee4f46755b8054e9102c2f5e86ee6.jpg	t	31271.jpg
4606	2376	630b5cd9369c1ca36d1b2c4877577658.jpg	t	31063.jpg
4607	2376	bed4e6cea6f840d85d0258759c5c1146.jpg	t	31064.jpg
4608	2377	f4b7b02572db2fd53e84249563e30778.jpg	t	31272.jpg
4609	2377	b544526b7e88f94b1179c87168436dfe.jpg	t	31273.jpg
4610	2378	25c33cf40e243e06478ddc391137037a.jpg	t	31073.jpg
4611	2378	b98c1552da9dbd90cacc386096a8f063.jpg	t	31074.jpg
4612	2379	849734f64efd76a2ffcc7903b3c3173c.jpg	t	31262.jpg
4613	2379	a2fa9bd176f454de139e957300c18703.jpg	t	31263.jpg
4614	2380	f21c4b724459041e64332d2d8f1add93.jpg	t	31230.jpg
4615	2380	f5321656dc63cde5ddcf3118c41f6612.jpg	t	31231.jpg
4616	2381	fe671dd1517afa9a681cc1455947c90b.jpg	t	31278.jpg
4617	2381	04e4ce699b8b10a54105889c63369255.jpg	t	31279.jpg
4618	2382	fe671dd1517afa9a681cc1455947c90b.jpg	t	31278.jpg
4619	2382	04e4ce699b8b10a54105889c63369255.jpg	t	31279.jpg
4620	2383	7374cca1c7644dd9a74329be70805a2a.jpg	t	30780.jpg
4621	2383	086ffe264f56bb54deed5b9bc3105c67.jpg	t	30781.jpg
4622	2384	ab633ff58a53d4f137bf6bce068760d3.jpg	t	40757.jpg
4623	2384	727c5f36756167d563f1c6b3a3de5b5f.jpg	t	40758.jpg
4624	2385	7b9474e264c529e2124c0b91190a5101.jpg	t	30991.jpg
4625	2385	33b0c341e20a9f7b04250b5e994c67dd.jpg	t	30992.jpg
4626	2386	fe223a4bea50e5f69d4360262bbb39dc.jpg	t	30993.jpg
4627	2386	29feda66f3ad2f07c06c442e8b21214a.jpg	t	30994.jpg
4628	2387	54a01e679d557151297cacd692851e70.jpg	t	30995.jpg
4629	2387	610eca77792ba20535550093dbf8b20c.jpg	t	30996.jpg
4630	2388	ac98c3b1de00fb549ba301d8dc3d8f82.jpg	t	10057.jpg
4631	2388	353c7c5db5fb5221f458ca3c911309d6.jpg	t	10058.jpg
4632	2389	27b8416bb6326254a1016842ed4db384.jpg	t	40767.jpg
4633	2389	d0643d0a7d06fdbcafb8aeee83e9da30.jpg	t	40768.jpg
4634	2390	f21c4b724459041e64332d2d8f1add93.jpg	t	31230.jpg
4635	2390	f5321656dc63cde5ddcf3118c41f6612.jpg	t	31231.jpg
4636	2391	e70e548d82d927adfc6d89925fbbbd3a.jpg	t	40765.jpg
4637	2391	a1524a88d1811c8dfcaa5450e24af82c.jpg	t	40766.jpg
4638	2392	f05b894723da894699710b8ccd320758.jpg	t	40761.jpg
4639	2392	ca3536b42bfe0e7b2f580171fdf36401.jpg	t	40762.jpg
4640	2393	415e9f9430eefd35fc6deb98d185e3ea.jpg	t	40763.jpg
4641	2393	32a28f16940fb9df010ae68a80676f03.jpg	t	40764.jpg
4642	2394	11d3a3ae6233714f2fea852d12b3c038.jpg	t	31011.jpg
4643	2394	173f1db08bf0d1c278ebba25bedfaedc.jpg	t	31012.jpg
4644	2395	f21c4b724459041e64332d2d8f1add93.jpg	t	31230.jpg
4645	2395	f5321656dc63cde5ddcf3118c41f6612.jpg	t	31231.jpg
4646	2396	e2b141c237d2bb193a0e92217c8c4007.jpg	t	40755.jpg
4647	2396	e168ea6e8226879f52eb4f1cd603cd7d.jpg	t	40756.jpg
4648	2397	95819fc02d1781577b45fa6a168f860b.jpg	t	31009.jpg
4649	2397	3ec70f886d0c71cf54d6c64e04a18ea5.jpg	t	31010.jpg
4650	2398	e4155a3656714f8446a7e3655d5d22c8.jpg	t	31019.jpg
4651	2398	afb4ae58dd675c677dc1f773300ac1de.jpg	t	31020.jpg
4652	2399	6e755aa1a9445afd389881ce7a9fd23a.jpg	t	31013.jpg
4653	2399	f4a570fef7f694ab226016ee7857e68a.jpg	t	31014.jpg
4654	2400	cc8f3646e88ae24ee95f5d3c0997549c.jpg	t	31017.jpg
4655	2400	6f6c60fd322c50f31af52faa382aaba0.jpg	t	31018.jpg
4656	2401	9e2f6a9b69bf057b3452f067c324e343.jpg	t	30886.jpg
4657	2401	bcb96f556635bd415805c3c374e6cb90.jpg	t	30887.jpg
4658	2402	86336ca5af21b2d3274959b82d8bf653.jpg	t	40773.jpg
4659	2402	aabf8d5faa871bb308d4aa848787b5b2.jpg	t	40774.jpg
4660	2403	aed2c68cbe0783470bc2011b539980ab.jpg	t	50062.jpg
4661	2403	b42cc922c74cc61c7b8453080ced2043.jpg	t	50063.jpg
4662	2404	e58b6782818bcc49fc79133d8e0a740d.jpg	t	40771.jpg
4663	2404	6c58c3ed9fd4ff07b3a0569d9e4104d0.jpg	t	40772.jpg
4664	2405	f676b65d64eec4f2a367b941809d00d1.jpg	t	31403.jpg
4665	2405	bf349cbc3410f1d9b15e860ea6e94250.jpg	t	31402.jpg
4666	2406	83b1470d2a1a8d8a4be7e06da58c4422.jpg	t	30848.jpg
4667	2406	6b390d8c290cce3fa6a14dab4d3045e2.jpg	t	30849.jpg
4668	2407	876dc8cd2a3f58030c246384ae63d461.jpg	t	10211.jpg
4669	2407	42f67a7ef22d97e18fd2e007d3893806.jpg	t	10212.jpg
4670	2408	2b2b69798bb64c31110d84cfe95a86b5.jpg	t	30844.jpg
4671	2408	74c2f3027b93af0867f8abea3852535e.jpg	t	30845.jpg
4672	2409	3f08eda17632fafefd3d6da837ab78b6.jpg	t	30738.jpg
4673	2409	e09de95b17e26aed44cbf985a61ec1af.jpg	t	30739.jpg
4674	2410	8bae53d1aa3c9d3c53bef0972d3058d8.jpg	t	10407.jpg
4675	2410	ed88380668c479fb16f2adeb734f1f48.jpg	t	10408.jpg
4676	2411	311bee32a520faa7a4ede5541a66b8d9.jpg	t	30041.jpg
4677	2411	6b407f721bdb40cfc039115d1bad7eef.jpg	t	30042.jpg
4678	2412	8a4dc0865d519207cc4772e07910d0c2.jpg	t	10261.jpg
4679	2412	743c4013665e241f80f17f47d56ce52f.jpg	t	10262.jpg
4680	2413	0230b7000ddc2bffe9cb935c6b19afab.jpg	t	40559.jpg
4681	2413	94831ee1b3add680599e89c1491b9203.jpg	t	40560.jpg
4682	2414	fda6fe74d2c403576011c4b4b4bc9eec.jpg	t	31189.jpg
4683	2415	7429716d9782f18454cc46927b6f4f37.jpg	t	50066.jpg
4684	2415	125d27e1b7201d40d9c68d7291f79b85.jpg	t	50067.jpg
4685	2416	a914201473a39aeb4232e297e3a22de6.jpg	t	31157.jpg
4686	2416	76424bb13bc6469bcdde489d95bb9b7a.jpg	t	31158.jpg
4687	2417	c8dddca023826e5eed6a29e4676eebe7.jpg	t	10456.jpg
4688	2417	5a6bd28ec6a8a2b1a7d403de1b8849d9.jpg	t	10457.jpg
4689	2418	2346688cbe70f6d0a58a1565e50b6928.jpg	t	31155.jpg
4690	2418	844da4971ff7b6f15fde16c7ff730f7c.jpg	t	31156.jpg
4691	2419	d1af605a7f412ac8de6a8dfa4aad6717.jpg	t	10093.jpg
4692	2419	ff9676330635c10cac61db182d5f7361.jpg	t	10094.jpg
4693	2420	2346688cbe70f6d0a58a1565e50b6928.jpg	t	31155.jpg
4694	2420	844da4971ff7b6f15fde16c7ff730f7c.jpg	t	31156.jpg
4695	2421	53357936994fe8e44b94ff3a9969892c.jpg	t	31015.jpg
4696	2421	637ee12192329c56d1a931915cd4bd17.jpg	t	31016.jpg
4697	2422	a86df32129fb1a0a74dc8cc019b974b8.jpg	t	31286.jpg
4698	2422	2a54c0d107111aee3428a277069bfaf5.jpg	t	31287.jpg
4699	2423	32b2cec01aff11f4cb83e718a8f42938.jpg	t	31294.jpg
4700	2423	9dcb3849b333cfeb55cf0bb626e862d1.jpg	t	31295.jpg
4701	2424	61e67234ee997af882534eec0d53bf81.jpg	t	31292.jpg
4702	2424	721922c109e7a085e65f5d6de7a2c5e3.jpg	t	31293.jpg
4703	2425	fe671dd1517afa9a681cc1455947c90b.jpg	t	31278.jpg
4704	2425	04e4ce699b8b10a54105889c63369255.jpg	t	31279.jpg
4705	2426	374fe19aa22bf21cd61c2989f1e7f4b6.jpg	t	10931.jpg
4706	2426	df590a5c89ed1d935fb74d4a2d70ad1c.jpg	t	10932.jpg
4707	2427	83b7d0f281f0a276c870721e8f7159bf.jpg	t	31290.jpg
4708	2427	078b20375e59688a7e668a10117dc863.jpg	t	31291.jpg
4709	2428	688257ed6227dc77e2414035ebd86e6b.jpg	t	31369.jpg
4710	2428	5feb72a940df1da2b8b70c81456317c7.jpg	t	31370.jpg
4711	2429	38d4fd9933c5e8d63211796bcf9f97c2.jpg	t	31260.jpg
4712	2429	4e8aa5816cb1cbb808721fa70417b2c2.jpg	t	31261.jpg
4713	2430	849734f64efd76a2ffcc7903b3c3173c.jpg	t	31262.jpg
4714	2430	a2fa9bd176f454de139e957300c18703.jpg	t	31263.jpg
4715	2431	408a82c2b5d4706a099cd1cae92fd1ea.jpg	t	41224.jpg
4716	2431	eab60bfb9ef8bbd2cf89604bfa412292.jpg	t	41225.jpg
4717	2432	408a82c2b5d4706a099cd1cae92fd1ea.jpg	t	41224.jpg
4718	2432	eab60bfb9ef8bbd2cf89604bfa412292.jpg	t	41225.jpg
4719	2433	a82cc98e03555d1a377d418017ec0226.jpg	t	31282.jpg
4720	2433	b34047e66298011b0f7c66fbc0434a4c.jpg	t	31283.jpg
4721	2434	1c73bc4c9ca0ddf8b37c66854e031566.jpg	t	30786.jpg
4722	2434	89c18388478bd2c36d493c3f6c588ed5.jpg	t	30787.jpg
4723	2435	8693fe906a0711c9c5020ddb7b1d6f64.jpg	t	31149.jpg
4724	2435	2852c1d6cfacf9ca42e3a98c5202802a.jpg	t	31150.jpg
4725	2436	7374cca1c7644dd9a74329be70805a2a.jpg	t	30780.jpg
4726	2436	086ffe264f56bb54deed5b9bc3105c67.jpg	t	30781.jpg
4727	2437	0ba04dfe104c1efefede06e9176e70d9.jpg	t	31151.jpg
4728	2437	881b648d4e9ed195f5459d106f8c1a1f.jpg	t	31152.jpg
4729	2438	509b48ead0a6113a01eadd6e0882b6fb.jpg	t	31280.jpg
4730	2438	594e6bd8d67d0efda0eaf60f79acfd5c.jpg	t	31281.jpg
4731	2439	a95a3555555e00558c0a38b7e4039d1e.jpg	t	50058.jpg
4732	2439	6aa466323587674f9c50ff9cdeba9c17.jpg	t	50059.jpg
4733	2440	17baedb37ac8590d78623850326c6379.jpg	t	30997.jpg
4734	2440	aec821be7926d45a94059832f1be17b7.jpg	t	30998.jpg
4735	2441	93915831c69dcbf4a7db29ac2735e8e0.jpg	t	41226.jpg
4736	2441	8ca8d4c71f63b8dc750adf84e5921635.jpg	t	41227.jpg
4737	2442	4b40a5d95e28112e7d15e31c51084a96.jpg	t	30381.jpg
4738	2442	177b81df503d5fea4824e8ae6ee540b9.jpg	t	30382.jpg
4739	2443	61a683f6352a3ed866b8c6a62a363af0.jpg	t	30383.jpg
4740	2443	8457bae5a3e0fb88ebaad8064cba01f1.jpg	t	30384.jpg
4741	2444	663efe7cdb33cf2e1b09abcb440f3da5.jpg	t	30880.jpg
4742	2444	9590f518178e4158aac8b000516e7345.jpg	t	30881.jpg
4743	2445	17baedb37ac8590d78623850326c6379.jpg	t	30997.jpg
4744	2445	aec821be7926d45a94059832f1be17b7.jpg	t	30998.jpg
4745	2446	5e1f625b537132eca42a73eb0c3a1132.jpg	t	30834.jpg
4746	2446	bcf2611bca3e51b7a7725c79e791c8d6.jpg	t	30835.jpg
4747	2447	1b35de912e0ee7ade20019eefd215d66.jpg	t	30842.jpg
4748	2447	46c6f7ed3290d1a23dddf1f7f7248c26.jpg	t	30843.jpg
4749	2448	194da4b87351a4e0a42d59f4928eb649.jpg	t	41140.jpg
4750	2448	d398bf5d3197cc4a9221d5d4ee5c1a49.jpg	t	41141.jpg
4751	2449	cf608b453e16cc7ec0ab639828d26ee2.jpg	t	31147.jpg
4752	2449	01fc729d13e0328a263fc58b3bfe2311.jpg	t	31148.jpg
4753	2450	10b76104c956ffa552f2c9faa2aa41c0.jpg	t	20835.jpg
4754	2450	5711b573d5fddb5dd7c721ae1091fe26.jpg	t	20836.jpg
4755	2451	aaae4441981fe55f7c8516e023c3c3c8.jpg	t	10152.jpg
4756	2451	2e5d75ca5769d26766697586025cf4b9.jpg	t	10153.jpg
4757	2452	62e8bd4a49b3741ef93a97f8a1fa59c5.jpg	t	21091.jpg
4758	2452	b4fd5d4db78672a4a9feebb46c6bb46b.jpg	t	21092.jpg
4759	2453	53a07ea06e527dc9e5c0d1eeeca1907a.jpg	t	40237.jpg
4760	2453	b4303d5bfd53982bbe53dcf449776893.jpg	t	40238.jpg
4761	2454	3572538fa5549fd4eca4de891df64b34.jpg	t	41078.jpg
4762	2454	b978a8405a03f042bd19fbfff3b276a2.jpg	t	41079.jpg
4763	2455	ba4ccebe267fd583d18d358d2838486b.jpg	t	40922.jpg
4764	2455	c97b73e2ebad9a728d39ee78b7860563.jpg	t	40923.jpg
4765	2456	f34fe83fc535f141df07250f942decf4.jpg	t	40341.jpg
4766	2456	29ceffa195fe1a88364549187be9de21.jpg	t	40342.jpg
4767	2457	f5645fb523d79a927b74277b2f7589f9.jpg	t	40912.jpg
4768	2457	a1f4ed9734c80a8ed56dcfd4d02f1942.jpg	t	40913.jpg
4769	2458	e30bf77aff064d8b29b93fffa75efa77.jpg	t	40924.jpg
4770	2458	80cbb1d0a475a42a2208c8eeabd851e3.jpg	t	40925.jpg
4771	2459	ae20c9e8a8cca10c509532e74770645d.jpg	t	40906.jpg
4772	2459	2c482748c1b42d071a8ec156a642707e.jpg	t	40907.jpg
4773	2460	40a098d5b31ca2097ce7432787f048d7.jpg	t	40910.jpg
4774	2460	0fe2d8b2cf7d6a29a2512ec91fbd14fb.jpg	t	40911.jpg
4775	2461	1123eef192f495ade7bbde9df2a7bbb1.jpg	t	41074.jpg
4776	2461	dd131f59ff00ef97df53a915cab36e3e.jpg	t	41075.jpg
4777	2462	023c5779e285a0099d5613ec405e3871.jpg	t	40930.jpg
4778	2462	ffc79640d337183dec17c49839f768ad.jpg	t	40931.jpg
4779	2463	c7c273a6e04a6f3b47f37aae994bb939.jpg	t	20833.jpg
4780	2463	7d72857a8332cef0e8daff68819901b9.jpg	t	20834.jpg
4781	2464	26d1e02a33d73357921cc61f7552e2f2.jpg	t	41082.jpg
4782	2464	db6be08451635b4840e81f2f0db118c2.jpg	t	41083.jpg
4783	2465	59b3e3635a2ee64a76d34069fb72476f.jpg	t	40926.jpg
4784	2465	f033da2f963d958aff54d3e6ec590490.jpg	t	40927.jpg
4785	2466	057888cd9cc8364bff330c3a752df954.jpg	t	20827.jpg
4786	2466	b214c2635b1cd583ae52ca93310f1ac9.jpg	t	20828.jpg
4787	2467	ae3324d02904c81c8a916db15aa1a7f3.jpg	t	31033.jpg
4788	2467	15e1565fe155933b70516f6f158884b7.jpg	t	31034.jpg
4789	2468	d868179de72e48a756463a2a0676305d.jpg	t	40846.jpg
4790	2468	ee6f7796f2be483994a58f8e1dd405ba.jpg	t	40847.jpg
4791	2469	8ea29c44d780801e060fddcab5c0fb2b.jpg	t	40824.jpg
4792	2469	e231b63ce3de11aa0f1572b68659cc27.jpg	t	40825.jpg
4793	2470	ced1b9a28f7eeb0008eb76255c32b3d2.jpg	t	40854.jpg
4794	2470	e96a442086650ec3998e1588e67c1de3.jpg	t	40855.jpg
4795	2471	cfef1887102a0be856b9d17f5c07d2b3.jpg	t	40515.jpg
4796	2471	76c5ae515734605b9f100db09527d6b2.jpg	t	40516.jpg
4797	2472	236bf715f53923f8913d1604dab7697b.jpg	t	40898.jpg
4798	2472	071ea7dbd78ba79706ddf1a8a922a22a.jpg	t	40899.jpg
4799	2473	3689f86041d42eb168fefe2472048b75.jpg	t	41068.jpg
4800	2473	bbba56b7e185861297fe1aebf0a9f383.jpg	t	41069.jpg
4801	2474	0a552e5ce42dd01da2bcd216f2d2ec53.jpg	t	40904.jpg
4802	2474	385170ec0422b9577183c2d7502f42a4.jpg	t	40905.jpg
4803	2475	9124932b23568e1100e697864820daae.jpg	t	40900.jpg
4804	2475	2cd1497b62580a0871b8dd54275928be.jpg	t	40901.jpg
4805	2476	68b7eb196b6cb13b454e4df1200c5f18.jpg	t	40914.jpg
4806	2476	850578ac6d8220738369415678ddef7a.jpg	t	40915.jpg
4807	2477	4aa66cd43d60c11988bb236bfd6856f8.jpg	t	41058.jpg
4808	2477	bf86187cff02d74c13d57abb9aee6b05.jpg	t	41059.jpg
4809	2478	12116ef488fd4a8e053af43252a2a336.jpg	t	41064.jpg
4810	2478	dcaaf3e1f988e547a33e6146823a77f0.jpg	t	41065.jpg
4811	2479	470cb00fd6683255c2a76053ccf867ac.jpg	t	41086.jpg
4812	2479	062a2ac538f5942b901080e0bcee0a4d.jpg	t	41087.jpg
4813	2480	e1d294df8da94decd5fc8838ac1c6fa2.jpg	t	31296.jpg
4814	2480	e63e5e9c4be30b107c59ba114968399c.jpg	t	31297.jpg
4815	2481	5fffea77da452ebde509bbcca151ebc1.jpg	t	40834.jpg
4816	2481	828db23629dc8dc260da8fff272739a5.jpg	t	40835.jpg
4817	2482	0c44ea7e113ba50c259c4d7723f39017.jpg	t	31133.jpg
4818	2482	09669f6cca04f6c250d25face2cf0996.jpg	t	31134.jpg
4819	2483	d1ef01b7f404099e5b08f019b9474f13.jpg	t	31043.jpg
4820	2483	e172055b687f43716ea3137d5d31a9bc.jpg	t	31044.jpg
4821	2484	0e0857ddfdd43105946368887b596160.jpg	t	31320.jpg
4822	2484	513f6dc23287092b49b23a04b3d962c9.jpg	t	31321.jpg
4823	2485	7cd8ee8d55d42bcc5e8324b698ea43ad.jpg	t	31298.jpg
4824	2485	ef6e14aed143f6531434fd574c09d8f8.jpg	t	31299.jpg
4825	2486	c3c7c81bc11b7db4a13819bdfba145ef.jpg	t	31306.jpg
4826	2486	80f6aeede528787ee4cf934c9d4b10c8.jpg	t	31307.jpg
4827	2487	7c5e38d141dea3c15b561d6bf5c00115.jpg	t	41062.jpg
4828	2487	c4e5c5d5ba1f9dceb321e25a29ee0212.jpg	t	41063.jpg
4829	2488	c3a3537d06e03e79ec6ec9faf4a1559d.jpg	t	10772.jpg
4830	2488	1d2e2ed5f8aef7bcbf68facdc47a6f65.jpg	t	10773.jpg
4831	2489	236313390fe7b5801e3aa26b26d99575.jpg	t	30838.jpg
4832	2489	ecb30dd284c8e4c188c63bd7cf8bdc56.jpg	t	30839.jpg
4833	2490	4237cff9e93a6a1fbf513945ea71fb24.jpg	t	30862.jpg
4834	2490	14a9933e9b522dff904344f89113ae14.jpg	t	30863.jpg
4835	2491	1a9f660ee6db16fb72ffef13f51a48a4.jpg	t	30828.jpg
4836	2491	0b69d24747976f5f9dac7dc3de869358.jpg	t	30829.jpg
4837	2492	72964b381b5057ed922ca00d802df045.jpg	t	30973.jpg
4838	2492	8590718f81f926919019a3e6a530c0a8.jpg	t	30974.jpg
4839	2493	873f074be613dca37962c1f762e4dd0c.jpg	t	30864.jpg
4840	2493	9e9a9fca65871e3dafb44f72c10f7f87.jpg	t	30865.jpg
4841	2494	cfafc980049d9a229d4f254884fb5032.jpg	t	30965.jpg
4842	2494	75dc20a1fff8297158fb1a69929ae1a3.jpg	t	30966.jpg
4843	2495	2041b912620ce581538539505055aea2.jpg	t	30666.jpg
4844	2495	e4c192cd1ea24ea354b20af9d828c4d9.jpg	t	30667.jpg
4845	2496	7e8735f8cb3fb7d30589b6754950d28e.jpg	t	40547.jpg
4846	2496	b6c1ea6ccdf9ba9b06d80ac456acf79f.jpg	t	40548.jpg
4847	2497	bdd771a8cd9e6b37fbc21d471fb8c700.jpg	t	30722.jpg
4848	2497	cdd878f9350491e9583c4554c916f96a.jpg	t	30723.jpg
4849	2498	6d9dc2e3c71ec20965879ae71ee90148.jpg	t	50011.jpg
4850	2498	048e8d96c1678fc9bb9b60e8e903d543.jpg	t	50012.jpg
4851	2499	8adec01fec2fb126c4c1b952fd014117.jpg	t	50013.jpg
4852	2499	48343f10faf1254a39b68f1383073821.jpg	t	50015.jpg
4853	2500	fc2aabe645017998277375ab68bece1f.jpg	t	10300.jpg
4854	2500	c44c26946bee2f429024a74fb71ee993.jpg	t	10301.jpg
4855	2501	fad000c4550a28ad53318e69da286523.jpg	t	50020.jpg
4856	2501	cc8fbe989bc2d570a187435a2f310563.jpg	t	50021.jpg
4857	2502	004a442b28ff35e1eaa73ea4db365c7f.jpg	t	50014.jpg
4858	2502	48343f10faf1254a39b68f1383073821.jpg	t	50015.jpg
4859	2503	bb515e1bc9502d5089a172f8c99c1441.jpg	t	50022.jpg
4860	2503	6eb82fafb8662b3e720bc478671899c3.jpg	t	50023.jpg
4861	2504	69e97f8098c732105b322e750009c9f4.jpg	t	10401.jpg
4862	2504	412333b4c2d4b3fb3b17ba10ecffba40.jpg	t	10402.jpg
4863	2505	a713360556e7c4676c5fa65075fb13ec.jpg	t	10405.jpg
4864	2505	029b036ea620af658e1958c64fad4376.jpg	t	10406.jpg
4865	2506	f603a8e57e9d4b850391f38c161d1d70.jpg	t	10996.jpg
4866	2506	cfc0fff06cbf2614b2d18170342f51b2.jpg	t	10997.jpg
4867	2507	d58240d3ea41d5253026c9a4297ac9aa.jpg	t	50038.jpg
4868	2507	92635851f9114c0feb9072b8d7e14b6f.jpg	t	50039.jpg
4869	2508	2b825365a31956134abef212abfa2c0c.jpg	t	30860.jpg
4870	2508	0dbade487f7d9ee87a324aec5a8be417.jpg	t	30861.jpg
4871	2509	24232ea924ba7a14d626d9e12b600778.jpg	t	41132.jpg
4872	2509	1aed4575e33e149256f5144e8bff5ae4.jpg	t	41133.jpg
4873	2510	96da145169798a16d76a27fd9063d885.jpg	t	31115.jpg
4874	2510	83e9e1fcc7d58d5e2e3f7bebbd078e23.jpg	t	31116.jpg
4875	2511	9d0a53a5fbe4235410fa11839b418cff.jpg	t	41136.jpg
4876	2511	89153c4f7dc63b1a845d86112f57f902.jpg	t	41137.jpg
4877	2512	ab88491be6444827189d3652424ceedb.jpg	t	50064.jpg
4878	2512	189430ba972ae53f1b2a1e080e553ec9.jpg	t	50065.jpg
4879	2513	077e4a1606af179eb4762d28f4773332.jpg	t	50042.jpg
4880	2513	4872e9ac15f795036901da807d384373.jpg	t	50043.jpg
4881	2514	4a704d2d18e8f1efaf4c383dec64f671.jpg	t	50060.jpg
4882	2514	6bd626e313c975c39609ba0479df4400.jpg	t	50061.jpg
4883	2515	2fada9009ed8c44e5770125a01eb45ad.jpg	t	31005.jpg
4884	2515	9903e544342d797fbe3e516ba35dd7db.jpg	t	31006.jpg
4885	2516	f992f95aa2ba95cffa1002c69a6d2fe2.jpg	t	50044.jpg
4886	2516	b0e821cf241fc2e6faddf34a656b150b.jpg	t	50045.jpg
4887	2517	d58240d3ea41d5253026c9a4297ac9aa.jpg	t	50038.jpg
4888	2517	92635851f9114c0feb9072b8d7e14b6f.jpg	t	50039.jpg
4889	2518	970b00ab7779eaf4aeb90a92302fecb8.jpg	t	50055.jpg
4890	2519	ea44ad7b276afd6a19fcb94aa4e07240.jpg	t	31194.jpg
4891	2519	f45824473a47c82f78bd7cd862d32e8c.jpg	t	31195.jpg
4892	2520	d1aa5fdd844850ade8e957b297ffe218.jpg	t	31204.jpg
4893	2520	23f69ecde4447aa73fe47619ad6de85d.jpg	t	31205.jpg
4894	2521	062fe2b292d98ceb4b9302fcb5585571.jpg	t	10440.jpg
4895	2521	9d1acef431dfbcf65aee27dd15b8a4da.jpg	t	10441.jpg
4896	2522	81b90b0028eebc78c00c13f36670a355.jpg	t	31322.jpg
4897	2522	c56d8cef41790e96c63294cabdf40001.jpg	t	31323.jpg
4898	2523	285dcfc5f615f6d4bed970c50ac90ad8.jpg	t	41112.jpg
4899	2523	8e0615e18f76899914673b3b8d6b1449.jpg	t	41113.jpg
4900	2524	ef735b6be8484242448e39cd0af31d8c.jpg	t	41126.jpg
4901	2524	2b54edfe4da9cd69956be4744b4dc210.jpg	t	41127.jpg
4902	2525	cd07186f1c2649e822136a705baa51b3.jpg	t	31304.jpg
4903	2525	185022ed7c7edc09291e8e3b5ca9fdfe.jpg	t	31305.jpg
4904	2526	c1fa531d89aba233432fd2556c6b8ad5.jpg	t	40946.jpg
4905	2526	e49336d9c4c9c8a954debb344c3861a3.jpg	t	40947.jpg
4906	2527	5ebc0feb7738e567863adca198c07445.jpg	t	40751.jpg
4907	2527	115514394ebc2184d9b7a5ad6b58bf86.jpg	t	40752.jpg
4908	2528	7c188cfa880f7c06ebb2f89a0acfdd4c.jpg	t	41100.jpg
4909	2528	9c44837c54192d180840d6c8e867d9bf.jpg	t	41101.jpg
4910	2529	82e3af5bbc0a720956d69d1354fd3b68.jpg	t	41114.jpg
4911	2529	01664209abdd18eb3cc0ee55718f5770.jpg	t	41115.jpg
4912	2530	1882cf6bbf40eb5540e4677d77713e61.jpg	t	40777.jpg
4913	2530	4606d51048622283aeb40e4668101784.jpg	t	40778.jpg
4914	2531	1aca5d4f6ddf80c7c30e217865078ca3.jpg	t	41004.jpg
4915	2531	f358ef5d85c4ae5fca0690bbb0049c51.jpg	t	41005.jpg
4916	2532	c685cea982fd63f96e809deec3bfc229.jpg	t	40948.jpg
4917	2532	3b9ce16c89ee90e6c6cc4245d9593865.jpg	t	40949.jpg
4918	2533	899ba7ed209e32392eef5ac622645f9b.jpg	t	40942.jpg
4919	2533	22d4fe6a2bf2c13ce83a89aa6bf70c0b.jpg	t	40943.jpg
4920	2534	b6af2877810a61a5afbb8179271cf8fd.jpg	t	30953.jpg
4921	2534	2838d66394840f5afa7c7132726a4460.jpg	t	30954.jpg
4922	2535	4cf4525a4d1efa2386b3536f5263bcf5.jpg	t	40126.jpg
4923	2535	85354739993e9f2ae91b90d0bfac3915.jpg	t	40127.jpg
4924	2536	cbc93dc3a733b02d1bd75f968bfd75d5.jpg	t	30945.jpg
4925	2536	93cf524d60fe6f9516173a78d8268ace.jpg	t	30946.jpg
4926	2537	f5413eb3efe247415a6d8a039e2573c1.jpg	t	30645.jpg
4927	2537	660c102a9f4f16a154679553d60cc422.jpg	t	30646.jpg
4928	2538	70cf6e8db1ee2704d300e5d3d63f6993.jpg	t	41228.jpg
4929	2538	645ee95165aaf3b89c72352a1acb0ba7.jpg	t	41229.jpg
4930	2539	11a51d16747815340ed304f122d9deb5.jpg	t	41024.jpg
4931	2539	3b187ca6b329b9572cf8fe6f01faf0cc.jpg	t	41025.jpg
4932	2540	5bdc66eebd6c680ee3749cfd35ccbe64.jpg	t	31102.jpg
4933	2540	aad7dc38e1c9a6c09a077ff2ce520a10.jpg	t	31104.jpg
4934	2541	af221eabb17fc7175a947dae45252104.jpg	t	40799.jpg
4935	2541	ec9b45521af0ace6e6ed7bde888d5a93.jpg	t	40800.jpg
4936	2542	deae236b2487896f70731629add4bbed.jpg	t	41162.jpg
4937	2542	81a59e9fa2a47c98164ca982c7678ac0.jpg	t	41163.jpg
4938	2543	5da06863c26638ec1176090ed66f8725.jpg	t	31226.jpg
4939	2543	b5fcd514860ccf96837ae4a6d0ab0ad6.jpg	t	31227.jpg
4940	2544	85f89b7a9ed8e33e58d0340136f704b7.jpg	t	30379.jpg
4941	2544	04b2187d170c668c66c726f25770457d.jpg	t	30380.jpg
4942	2545	38b68f0ce312daf41123f2e4829dec23.jpg	t	31224.jpg
4943	2545	2285355f0afa6f057e3f3655ef3e387c.jpg	t	31225.jpg
4944	2546	befc34ca242efc45fa5244f7886c1138.jpg	t	10391.jpg
4945	2546	62353c4ddfbdf07a541a70005ed6ec03.jpg	t	10392.jpg
4946	2547	1476ec3f95355a3e7b5797f5d6c5e773.jpg	t	41230.jpg
4947	2547	e656642133667cd3e900de1947fd09c4.jpg	t	41231.jpg
4948	2548	5da06863c26638ec1176090ed66f8725.jpg	t	31226.jpg
4949	2548	b5fcd514860ccf96837ae4a6d0ab0ad6.jpg	t	31227.jpg
4950	2549	e25ad1a790bbb8f8675fa2c2f09e70fd.jpg	t	30370.jpg
4951	2549	d848f70cedaa5b5edc04519f27f216c7.jpg	t	30371.jpg
4952	2550	376690d21e996979b8511195b5ef68e2.jpg	t	31254.jpg
4953	2550	3a377285d16fdc15d5b908fe47ff00c9.jpg	t	31255.jpg
4954	2551	93915831c69dcbf4a7db29ac2735e8e0.jpg	t	41226.jpg
4955	2551	8ca8d4c71f63b8dc750adf84e5921635.jpg	t	41227.jpg
4956	2552	74f016ab9e1c2839b89530e4dfd873fb.jpg	t	31086.jpg
4957	2552	f5275e11bce7a8fac3b0c3cc702b11d5.jpg	t	31087.jpg
4958	2553	3daa486dfa9e0431cc3aa88b848f996e.jpg	t	31240.jpg
4959	2553	2668dbbac630eccf9e3358b6b46fe417.jpg	t	31241.jpg
4960	2554	74f016ab9e1c2839b89530e4dfd873fb.jpg	t	31086.jpg
4961	2554	f5275e11bce7a8fac3b0c3cc702b11d5.jpg	t	31087.jpg
4962	2555	ee3e8e86e3cb6a64e9bed2f2f23c14a2.jpg	t	31238.jpg
4963	2555	2f8df582127c6a9c57a31eff947f8307.jpg	t	31239.jpg
4964	2556	d3cd1d0cfbaadf2f7052369adac7141a.jpg	t	31236.jpg
4965	2556	b7e222dd5d18be3ed7d288bfaa4c27b6.jpg	t	31237.jpg
4966	2557	268615ab8d25db11367455ae45cbc3f5.jpg	t	30488.jpg
4967	2557	db3547c94e0a30396c88e321afa7de14.jpg	t	30489.jpg
4968	2558	3a7d9b16c6b61727e73995c8e40b5c2a.jpg	t	31145.jpg
4969	2558	e2e1c3d45cde705e30fefb1c0bd5334a.jpg	t	31146.jpg
4970	2559	dda5822c53f7f04bffbd500bced68ce6.jpg	t	41198.jpg
4971	2559	d220d1bd04e9f0d691febfbba01a8560.jpg	t	41199.jpg
4972	2560	932224b5c0cc29b47133639293be34ea.jpg	t	40840.jpg
4973	2560	cc8ded3aa29b38dbf9d7f34ecbbd31a7.jpg	t	40841.jpg
4974	2561	1bfe437577d837aa5cae04ee56881e42.jpg	t	31077.jpg
4975	2561	a80c4e7dabe7e87fca0467a69b1a147b.jpg	t	31078.jpg
4976	2562	f2c9ba29b13490caf416293c6717ebd3.jpg	t	40759.jpg
4977	2562	96de26d67875a42cecf0f1937c2677cc.jpg	t	40760.jpg
4978	2563	a45e93be91feded75bc52e6edcb66112.jpg	t	40769.jpg
4979	2563	a5a7a58f16312f60d38c601da9d03605.jpg	t	40770.jpg
4980	2564	59cb8abb2ce2e5fae47bfcdbc49c0ae0.jpg	t	31184.jpg
4981	2564	f08145c74f1639c392106dcb454ba799.jpg	t	31185.jpg
4982	2565	1341e9010b166d02bf2a8dd5b3f9ae60.jpg	t	31181.jpg
4983	2565	39d710be00dc16b7d9c9a78d4381596c.jpg	t	31183.jpg
4984	2566	025ade4c814f65b01f19ee71580b3d18.jpg	t	31167.jpg
4985	2566	9a9172d5c18e3a264581bf770db73cb5.jpg	t	31168.jpg
4986	2567	b844ad31114b122a8b46939675737a29.jpg	t	31177.jpg
4987	2567	7e0888e39b6aa9e47bdc14e6e1c22d45.jpg	t	31178.jpg
4988	2568	86b333dc05473c27c548de8fec1b2d2b.jpg	t	31398.jpg
4989	2568	2acfebf9f3b10ae0a1827df8fae04193.jpg	t	31399.jpg
4990	2569	d7b6f44b4de71cc53d128c8979f689e0.jpg	t	31405.jpg
4991	2569	76633f43cf1b54a3de2d9e407fa86fdb.jpg	t	31404.jpg
4992	2570	750be2408578fa35e6e258be1df440f7.jpg	t	31386.jpg
4993	2570	eb9fbbfeb03b7d097eca2be4ea416680.jpg	t	31387.jpg
4994	2571	842c226ba9c5d093bd415acb6086569a.jpg	t	50068.jpg
4995	2571	3d0d3fb8bfc5bfccef248d6dd09fd818.jpg	t	50070.jpg
4996	2572	23efff9301872d871125abfc88f5a2c6.jpg	t	50071.jpg
4997	2572	f377bf188b212158eaa41ff44c641bbd.jpg	t	50072.jpg
4998	2573	310183d658c1a47a0e815de397c59878.jpg	t	41180.jpg
4999	2573	cd8b71b505cfcea9999e2c84f17b7479.jpg	t	41181.jpg
5000	2574	b498b677b0ed1e1711296bc399d1b3b3.jpg	t	41186.jpg
5001	2574	3ad8a27ea526f37e2a62c67030dac957.jpg	t	41187.jpg
5002	2575	4efcceb75300293e4ecb85391c9d177a.jpg	t	41182.jpg
5003	2575	e88538c69ea887c2dd95c5cc54c2dbad.jpg	t	41183.jpg
5004	2576	2bcb2448b596db22e3e58165df5ec65f.jpg	t	41184.jpg
5005	2576	a59e5daa3abb9b73b068cc97eae31653.jpg	t	41185.jpg
5006	2577	b3194742a8da827ac66c07be4a0c5b54.jpg	t	10579.jpg
5007	2577	8fb1c90c7e15ca21e337051684c69e86.jpg	t	10580.jpg
5008	2578	22916d288bc441d01b019e5618b14cbf.jpg	t	40998.jpg
5009	2578	437507623c82516993e898fb562892d9.jpg	t	40999.jpg
5010	2579	8c5caa74228ac3e350c6286fae83b6d2.jpg	t	40940.jpg
5011	2579	f28d0534eb7d35daa58d64865c229303.jpg	t	40941.jpg
5012	2580	6952c40bbee9be09e2a552f7a0498b5b.jpg	t	41002.jpg
5013	2580	0806976f96f1311ca1ee790675bb5948.jpg	t	41003.jpg
5014	2581	cd49deb0d6a493d2db66c3324daba601.jpg	t	40936.jpg
5015	2581	0f316a6597b3e79cb0380c0363f6dea9.jpg	t	40937.jpg
5016	2582	287899238c4a3fec4d20a71377f6a710.jpg	t	40996.jpg
5017	2582	5bdba3457d141aa51d98b0e9cc9d471e.jpg	t	40997.jpg
5018	2583	006d63f3ea248e8d58543e73070d11d0.jpg	t	40950.jpg
5019	2583	b112983d2c6a746752386abbbbd8738a.jpg	t	40951.jpg
5020	2584	af0281a114bbaec9ceb35be824c9dfa3.jpg	t	40954.jpg
5021	2584	a268fb82c90f265bf3a6cdc84da3b730.jpg	t	40955.jpg
5022	2585	a309acc43be62202c750973a80d82bf0.jpg	t	30943.jpg
5023	2585	b1bc4bc66a07a68ed9b4983adcfdbadc.jpg	t	30944.jpg
5024	2586	fabc8fae1fb019db80a3b47f93fe1245.jpg	t	31344.jpg
5025	2586	406ce31e00d412559bc810d4e1e11387.jpg	t	31345.jpg
5026	2587	75eaa666e884efd870b4b7a759a54a3b.jpg	t	30254.jpg
5027	2587	1e9b248c29a90156ac4949ee573edc48.jpg	t	30255.jpg
5028	2588	b19c7eec6591b1ae95aec23fe059a401.jpg	t	30349.jpg
5029	2588	52c4dee7a053d0656ac6d27ce91fa59e.jpg	t	30350.jpg
5030	2589	5fd8e4a819ed5ef4000efa9057179635.jpg	t	40872.jpg
5031	2589	7bd889a9860c041b7bd9de056d0c23e0.jpg	t	40873.jpg
5032	2590	869c030b736adc5d8eb5d9847b1b4266.jpg	t	40862.jpg
5033	2590	b23f1cc55d1339408f22d251fe344952.jpg	t	40863.jpg
5034	2591	612b8650b0ca77818da1b0d0ba793450.jpg	t	40874.jpg
5035	2591	61bb81671ca34bbd30a99b5f4953da0b.jpg	t	40875.jpg
5036	2592	a280fdf18004008044a32dadb305ef15.jpg	t	31250.jpg
5037	2592	6aeb7151f050aee9b71e3fe4b5a4730c.jpg	t	31251.jpg
5038	2593	0ef3da4246a6e46ccbdc99bf8279f38a.jpg	t	31092.jpg
5039	2593	4782f3622d22ef818bb46036909f5adb.jpg	t	31093.jpg
5040	2594	bd7d5fa4f89f6c920cd0bbe657c5505b.jpg	t	31090.jpg
5041	2594	386ecceec57803f1c7e5dedbc01fd8f8.jpg	t	31091.jpg
5042	2595	20667797f625ecd228a226b090fe2a5b.jpg	t	31094.jpg
5043	2595	3b8e6c86a450c298c6a62762d2f3af4a.jpg	t	31095.jpg
5044	2596	fc39f25b95b304f63adb9758fcd78788.jpg	t	40657.jpg
5045	2596	7bd4c75348ef4b32888cb72011b22c5d.jpg	t	40658.jpg
5046	2597	9ce9b243a0fe1bbc50a2f201b2685cbc.jpg	t	10887.jpg
5047	2597	b2f9b179aea49befbd7915554e987810.jpg	t	10888.jpg
5048	2598	7ba1f0338621c93181d0570f254dd9d5.jpg	t	40663.jpg
5049	2598	9ca3dd174fe87658b3481a624bf633fd.jpg	t	40664.jpg
5050	2599	45e4a784c6139092e89bcdc9b7fd9239.jpg	t	10893.jpg
5051	2599	cce2702792cfc992f9f2c4c84522c1da.jpg	t	10894.jpg
5052	2600	3f1d6afcb668500603ba20737602b610.jpg	t	30155.jpg
5053	2600	92e191f118aa1f2ee5f7cd4b7e97673b.jpg	t	30156.jpg
5054	2601	23828ec31f181a2cdadd4bc63cbfdba6.jpg	t	41240.jpg
5055	2601	8465b58b6021f73738378335b429c2f5.jpg	t	41241.jpg
5056	2602	60affc65d821199fe6860421690ba754.jpg	t	41174.jpg
5057	2602	8b19348690c603384fc38104a4a58858.jpg	t	41175.jpg
5058	2603	b3b91be1b3d539c4f479a04dd3c57427.jpg	t	41178.jpg
5059	2603	16000485b58416a7f26e0e5ca593a7a6.jpg	t	41179.jpg
5060	2604	85effd78eda1cd3a3c1375a677cbbc4d.jpg	t	30766.jpg
5061	2604	944f6c9ee2bd8d380610681891985fc0.jpg	t	30767.jpg
5062	2605	e2c6e39b3d6908222b2843a866d98c1c.jpg	t	41172.jpg
5063	2605	92512ca9847faa7e37a9601882431115.jpg	t	41173.jpg
5064	2606	87323d9d1f73f2a5d3de43b86f12da2c.jpg	t	41176.jpg
5065	2606	86ca3d295c52542e2795ce45c1db532b.jpg	t	41177.jpg
5066	2607	f51103ba0455360d43140fd3ff11aebc.jpg	t	30758.jpg
5067	2607	c392a1859f191f7a537c7b83ecc6a489.jpg	t	30759.jpg
5068	2608	6787a9e4a059453c9abc6a554dbf9002.jpg	t	30772.jpg
5069	2608	338efd3820ce3294574ae3435eaf1673.jpg	t	30773.jpg
5070	2609	e5455737630f7b73167d6dc95515b9ac.jpg	t	30774.jpg
5071	2609	4ad56cebe84dc65d71578b45edcaf744.jpg	t	30775.jpg
5072	2610	91866af0d936bb7270e032d169fd3db7.jpg	t	30983.jpg
5073	2610	2522c1f1b85bd2b15b0ee792c894d377.jpg	t	30984.jpg
5074	2611	6d010d3e33fed5a63ea45950b9364d8b.jpg	t	31141.jpg
5075	2611	6eb263144f5f971a98b06eacd7c111a3.jpg	t	31142.jpg
5076	2612	d7bad3720b7fd72ba87f24eee5d6b109.jpg	t	31143.jpg
5077	2612	a8ee3aa33b236129b535d913bffec116.jpg	t	31144.jpg
5078	2613	ad1caa65435e6ee5de103cbbfca35f10.jpg	t	31359.jpg
5079	2613	9220df48279a5d6c8dcdb9a3e506ade5.jpg	t	31360.jpg
5080	2614	b6906bbcb06467541c11ccb9c532b79d.jpg	t	30987.jpg
5081	2614	de31c57aae4712a17b3de8ca313b10f3.jpg	t	30988.jpg
5082	2615	aceeb080c0f495e2fd8165f1cdeb8e34.jpg	t	31352.jpg
5083	2615	783e6f6aa8d5437d88d23ef2dcc14cda.jpg	t	31353.jpg
5084	2616	b70495a4a6b6a67d5b6e86db3ac47ff9.jpg	t	30971.jpg
5085	2616	a3324cfb453c61b1a44cfe4684f26b7e.jpg	t	30972.jpg
5086	2617	5e225063e7014ccd2961174bbffa8c0e.jpg	t	31357.jpg
5087	2617	9a41849c7a2505faf82a1de44985fb15.jpg	t	31358.jpg
5088	2618	9b126e088aa3e943a7a2d035d213e264.jpg	t	30985.jpg
5089	2618	9df6964ed5dd3bf57cbdeaa5d9681e12.jpg	t	30986.jpg
5090	2619	89e655d8a6159d9ba3e4e2cf4a1a5bda.jpg	t	30989.jpg
5091	2619	0698f406f2161571fc7e65698fa2738a.jpg	t	30990.jpg
5092	2620	1e0b00bbfab940d416c16a55b16d333c.jpg	t	30878.jpg
5093	2620	0b91635045fba153d2df02c7625b4360.jpg	t	30879.jpg
5094	2621	894cc6cfe88d3d07853a2f2485ca9153.jpg	t	30884.jpg
5095	2621	4a661d497dc4c4a11bc5d4b2d722d9cc.jpg	t	30885.jpg
5096	2622	c1a4d1d19a941f77ee62791b8344d499.jpg	t	30720.jpg
5097	2622	b2ed50aa84dba969c237d9acff7195c3.jpg	t	30721.jpg
5098	2623	a501069094e13d0194e90e0b0f14914e.jpg	t	31379.jpg
5099	2623	cc351bf81139673b34a73ef2a985b4b1.jpg	t	31380.jpg
5100	2624	4d4ea22033acc7bad63dc1aad963cf1f.jpg	t	31388.jpg
5101	2624	e2407f3adeda77d3eac7a1f8c6541e1a.jpg	t	31389.jpg
5102	2625	db9a60f25ff0256cac048c121643fec0.jpg	t	31394.jpg
5103	2625	053a1948f6316ffaccb1849aaab6770d.jpg	t	31395.jpg
5104	2626	031ec33c9781109a661d39e96fd9f207.jpg	t	20965.jpg
5105	2626	263058a1a40323f4c3b6d5e37b3c2785.jpg	t	20966.jpg
5106	2627	d7034b14d9c23b530f51c1485f7896c0.jpg	t	20963.jpg
5107	2627	30ed2886d4e54794f3feb3ad8ab8e3a4.jpg	t	20964.jpg
5108	2628	c08b593903eec627e17b5ea0bb3a59bc.jpg	t	40892.jpg
5109	2628	2181fd075e59be9b20c50ac21b0c6513.jpg	t	40893.jpg
5110	2629	d6fdcb1ac9cf3f1fb0404c896df11d9a.jpg	t	40880.jpg
5111	2629	02f84c29bc2a1e2484ac916de4be554d.jpg	t	40881.jpg
5112	2630	19061b5647c8ccfcc4f41118fb83e666.jpg	t	40888.jpg
5113	2630	1202a676161bb6c9d0be70603faa98b9.jpg	t	40889.jpg
5114	2631	cb6b2838109a22d6a9da41089fc29926.jpg	t	30951.jpg
5115	2631	84c02fc7ea157ee148ecfb97170c9c8a.jpg	t	30952.jpg
5116	2632	fb2968697767e768751219ec3699872e.jpg	t	40882.jpg
5117	2632	b48f35c84e48e3c04d27a3f62feee6ef.jpg	t	40883.jpg
5118	2633	c4ade746f8a2de52de6a0afd1e76d509.jpg	t	40894.jpg
5119	2633	3c0ee6fd72733de095a91f08b3d99829.jpg	t	40895.jpg
5120	2634	cbeff3f1eb8dafe4a3dffe09a9fb6aad.jpg	t	40878.jpg
5121	2634	6a73999e195e410ce40f1fafa796e631.jpg	t	40879.jpg
5122	2635	72ce12521e5c2ea2e5acc52f61fcd6af.jpg	t	40890.jpg
5123	2635	34a7a76ed3bd54f3e9d614eff15a8ab9.jpg	t	40891.jpg
5124	2636	d20f8d802fd933bd513ee5ecee4fae03.jpg	t	40886.jpg
5125	2636	e2fd41a07ec6508846d0d4fecca33a4a.jpg	t	40887.jpg
5126	2637	3603652a94e1ec9d49d43820ad30ec03.jpg	t	40884.jpg
5127	2637	2ee400798a64b6e76309afbf70e90169.jpg	t	40885.jpg
5128	2638	8abe73e123174feecb04f225be7d9087.jpg	t	31302.jpg
5129	2638	6c5d804b25de8fe6908e6bd73d3c2c9e.jpg	t	31303.jpg
5130	2639	235cf211d3da1a5e7b97ca9a8007491e.jpg	t	40844.jpg
5131	2639	bccdf21f38d0f68c216732e7c6ba258e.jpg	t	40845.jpg
5132	2640	d570cfbecdf1ac06df6b2e7b9ecaad6b.jpg	t	31137.jpg
5133	2640	9bdbb5a09f54f794c8c5ea867e149511.jpg	t	31138.jpg
5134	2641	c66bd81972f08ae527b0898d9e804712.jpg	t	40838.jpg
5135	2641	fcdab968322dc6e344d7c70bece182bc.jpg	t	40839.jpg
5136	2642	9bbe9d7fa281303418cf352d117f52bd.jpg	t	31308.jpg
5137	2642	de6530887f4e2b8389d01bf93df14b87.jpg	t	31309.jpg
5138	2643	f0e17d3cd16b29185df242728b6d9a38.jpg	t	40836.jpg
5139	2643	cb5e26ddbba6a649dd999d960a3a9f2a.jpg	t	40837.jpg
5140	2644	da65e76118a9e3b9226686f566f04fbd.jpg	t	40830.jpg
5141	2644	0648d9daac77b6624f668037ef0cd66a.jpg	t	40831.jpg
5142	2645	d11f1219dae5e5cc9e6a9454a4935b97.jpg	t	40826.jpg
5143	2645	e7eb47abcbdce0981db2d7587d1b2f2c.jpg	t	40827.jpg
5144	2646	0c121de887d5527d8ae615a804e992c8.jpg	t	31127.jpg
5145	2646	3ec0a09bcaae1a053d891a10b91eda2b.jpg	t	31128.jpg
5146	2647	e5109169a03e48a27250bc4f03d356bd.jpg	t	31131.jpg
5147	2647	f3822ff7492984dad7c936d028173484.jpg	t	31132.jpg
5148	2648	021b0935ea391f9fddda17c54518183f.jpg	t	31123.jpg
5149	2648	0e12ad7c37d3dff8f251419bfaf3d03a.jpg	t	31124.jpg
5150	2649	5cac2408eddcf068e4fcfd8f7a8ea242.jpg	t	31300.jpg
5151	2649	4af6592052372440a65b74c2e810cfe9.jpg	t	31301.jpg
5152	2650	132cf7fe0ac425ae82c7c7859fae4396.jpg	t	31117.jpg
5153	2650	bfa46776cc894b963e5af6dc3e2c3ea4.jpg	t	31118.jpg
5154	2651	1da48c4124fbaa32068e45b30fb884b9.jpg	t	40876.jpg
5155	2651	1f243498dec5ba0d0e4e045e53b4d3ae.jpg	t	40877.jpg
5156	2652	1f243498dec5ba0d0e4e045e53b4d3ae.jpg	t	40877.jpg
5157	2653	18cda1c04b29c4394e9f8db2b55241f4.jpg	t	30908.jpg
5158	2653	691dbca020092cc0109bcc75f327e489.jpg	t	30909.jpg
5159	2654	3da666e8968c13e5fa1409bd8eb03418.jpg	t	30999.jpg
5160	2654	e0299672a2cb5dc1d937faa6a8ae5edc.jpg	t	31000.jpg
5161	2655	18cda1c04b29c4394e9f8db2b55241f4.jpg	t	30908.jpg
5162	2655	691dbca020092cc0109bcc75f327e489.jpg	t	30909.jpg
5163	2656	4affacd93ed08478b771613aeaf56085.jpg	t	31234.jpg
5164	2656	51ffa2839b31f0e6eccb2745b58824fb.jpg	t	31235.jpg
5165	2657	2219a12760ad681369192b1f028c8529.jpg	t	31232.jpg
5166	2657	a433cd5fe43b5f625697f2998dac77e0.jpg	t	31233.jpg
5167	2658	4ec5c3638299a8477fc10879f04d3381.jpg	t	30890.jpg
5168	2658	d04c3dd9f73ea0e14b5efca6229b689a.jpg	t	30891.jpg
5169	2659	1854a9f1c9af090a49ef0b648d8ac4c7.jpg	t	30918.jpg
5170	2659	db6a74de1351a573656cd11d96db60ef.jpg	t	30919.jpg
5171	2660	1adaa12b01ae7ac5cf366b0dc2cd3e69.jpg	t	30916.jpg
5172	2660	c29301cf6cb45446fa9ac9095dfc0297.jpg	t	30917.jpg
5173	2661	291975ce92a28f7289479658cf40e98a.jpg	t	30910.jpg
5174	2661	95b54db8795fec17f1f36dad013749b6.jpg	t	30911.jpg
5175	2662	8b718e8601a0db91e966c849a7f1da11.jpg	t	30920.jpg
5176	2662	c69d3af08076e1450a1828c3a5da2d08.jpg	t	30921.jpg
5177	2663	79136ce803fd293b4daeea0f2f5716a9.jpg	t	30912.jpg
5178	2663	74e737970c5f8a910aac26c64d968717.jpg	t	30913.jpg
5179	2664	6807d599c637759b9e0f17e29469d19f.jpg	t	30914.jpg
5180	2664	71e6170fc6568cbdb58f9ecf2e2ca98c.jpg	t	30915.jpg
5181	2665	16d119acd7a79daf1b436407dfd49b30.jpg	t	31159.jpg
5182	2665	32c255e0eb6b4075dcc8d55c61d1e065.jpg	t	31160.jpg
5183	2666	4ada4556e5ded43cbce46fdc73f131b0.jpg	t	31153.jpg
5184	2666	834477996175bb9b9f1e54f977916d41.jpg	t	31154.jpg
5185	2667	88f426773d17cd11325855c51cf3aafd.jpg	t	30377.jpg
5186	2667	48102e2bc973105cd2bcdd4cdd472a10.jpg	t	30378.jpg
5187	2668	9999e19fe0f611cce9fca4ab628ed829.jpg	t	41222.jpg
5188	2668	8a570ce08fdae00af02d8f35fbf6dc2f.jpg	t	41223.jpg
5189	2669	dabb03e8fba8714ac7a062000fbb3c38.jpg	t	40684.jpg
5190	2669	ccd6da095e366c15ad5840d7793a303c.jpg	t	40685.jpg
5191	2670	ef07dd978840116e20afd727c7c03c0d.jpg	t	40688.jpg
5192	2671	329c2cc9357d56d52d85aded4b9cb491.jpg	t	40686.jpg
5193	2671	6e8f4c4727468a6ebe9c08243b9631c8.jpg	t	40687.jpg
5194	2672	f132ee13639ef8f357f07fc2ac15c9d8.jpg	t	31007.jpg
5195	2672	0528d6ceb6ec101dc0cca132b0723f3c.jpg	t	31008.jpg
5196	2673	119915013e4e1ae385fce8402a2d5728.jpg	t	40753.jpg
5197	2673	da9c1baed776642d9614f4cdb49ae484.jpg	t	40754.jpg
5198	2674	263b7e17e9321edfdf25f9225cfbf88c.jpg	t	30929.jpg
5199	2674	5314d32151db00e47ff597f06f97040b.jpg	t	30930.jpg
5200	2675	6b1d6e6f4cac60a8a6aa74b5e5c61690.jpg	t	30924.jpg
5201	2676	7da4ff21a3a7f3521b4cff5bef20834d.jpg	t	30925.jpg
5202	2676	32d8a458b14868b392a450ea80e68902.jpg	t	30926.jpg
5203	2677	8ec99b089aec4c6360b0f9d3a39d564f.jpg	t	30927.jpg
5204	2677	fed9e2d1b17fea63556dc459164ca117.jpg	t	30928.jpg
5205	2678	6938491a4f385d43c9c4b8941194a6ca.jpg	t	50005.jpg
5206	2678	02652134d753d920ba9122172d2078f9.jpg	t	50006.jpg
5207	2679	dc1e9e0cc3e8a11631d574c9edf9fe17.jpg	t	50002.jpg
5208	2679	b7f8f33eddcdff898c62bde246411c05.jpg	t	50003.jpg
5209	2680	ec113b3ec8260c56110c418de4e22e1b.jpg	t	30649.jpg
5210	2680	40fb3c269869cfb7ca91aa3f956c4fee.jpg	t	30650.jpg
5211	2681	df10e064693aef7173c6285c3e08c2b8.jpg	t	41110.jpg
5212	2681	91b9f117215597db7c1e9293b9c51661.jpg	t	41111.jpg
5213	2682	aa39f462652793efe4c0b2969384e245.jpg	t	41128.jpg
5214	2682	bbc291769d3dcc7625f5b999a110985e.jpg	t	41129.jpg
5215	2683	aabbaf48f069ae833a85031e0c08a4e7.jpg	t	50030.jpg
5216	2683	59411fd55418f99fc965c2e2bc86688a.jpg	t	50031.jpg
5217	2684	a3e04517b243525bae9004ab8fdcdff4.jpg	t	50024.jpg
5218	2684	b3d9629bc4e684c226a917abfb04c60c.jpg	t	50025.jpg
5219	2685	41d4cd9926ecfeb843adc61a9eb5321b.jpg	t	50026.jpg
5220	2685	536f80cd2c9e213904392b618ddf0feb.jpg	t	50027.jpg
5221	2686	b6b8334ffaba05879ebaa775aba042e7.jpg	t	31350.jpg
5222	2686	c73472b20395783fb1a13862e1f65d90.jpg	t	31351.jpg
5223	2687	7aefe1f1b92ace15076a8134e90f1c04.jpg	t	31216.jpg
5224	2687	f0eac6f4760812c1664d6acc5244c219.jpg	t	31217.jpg
5225	2688	b6632d4aa3e4c10ed9148dfbeca48dbd.jpg	t	31220.jpg
5226	2688	d99fbd9563295b8348ddaad17d0c91ef.jpg	t	31221.jpg
5227	2689	4af23674a00faedcff2fe437a3c8c650.jpg	t	31103.jpg
5228	2689	aad7dc38e1c9a6c09a077ff2ce520a10.jpg	t	31104.jpg
5229	2690	2961821265bc260b28b2e803aa597ba4.jpg	t	31222.jpg
5230	2690	2928895b38dd53493446eac10363e0df.jpg	t	31223.jpg
5231	2691	02051dc91f74e72fbd6deecdc7d2aff1.jpg	t	31100.jpg
5232	2691	34795ac1357ea74e56dea5c2d795ac0e.jpg	t	31101.jpg
5233	2692	71fe007b0f9fd6f831f7d78320025b8b.jpg	t	31242.jpg
5234	2692	0aeaea02d13bf42fa07ea34f6a45f468.jpg	t	31243.jpg
5235	2693	02cc3c1a051e3263b158058a3ed2e051.jpg	t	31218.jpg
5236	2693	63b88a4fdc84fc9ccaa0d025a1228c39.jpg	t	31219.jpg
5237	2694	30310739dc860aac147913ea1c72d3bf.jpg	t	31228.jpg
5238	2694	8c2248c983297e74b234acd69e81e569.jpg	t	31229.jpg
5239	2695	3946f7904165b5d0d6dc918b29fa1c8f.jpg	t	31252.jpg
5240	2695	d29a484e9ba20c77f701615a2b87e8af.jpg	t	31253.jpg
5241	2696	d67dc0c1ccfa7ff18ae44590f10eff19.jpg	t	31246.jpg
5242	2696	400929171ac61b7f5971b855eeb805e7.jpg	t	31247.jpg
5243	2697	4cdd9477b14166245685a9f0f1e0cca9.jpg	t	40690.jpg
5244	2697	aa34b904e268242037a4c8360a287fb6.jpg	t	40691.jpg
5245	2698	f5c96a6a12a0215a4d7c21b0fd889058.jpg	t	40775.jpg
5246	2698	b81d5bcfc196806f826b30f39e077331.jpg	t	40776.jpg
5247	2699	cfab94ce3b35d03a70b7c0c1336cc118.jpg	t	30905.jpg
5248	2699	7a0149f248e3c4ac1ff0f6eb0b822407.jpg	t	30906.jpg
5249	2700	31f3638808379ba5b018dcbc66d9f96e.jpg	t	30904.jpg
5250	2700	cfab94ce3b35d03a70b7c0c1336cc118.jpg	t	30905.jpg
5251	2701	ee99da224622d19edbf64b756471aa4e.jpg	t	30892.jpg
5252	2701	392eb5f337574bb54e1621dd3982cc45.jpg	t	30893.jpg
5253	2702	c222e8d57eb0f025d35a592b88bd3b7a.jpg	t	40693.jpg
5254	2702	b44aa6c5f10ff187b33b38c97e219e8c.jpg	t	40694.jpg
5255	2703	da65e76118a9e3b9226686f566f04fbd.jpg	t	40830.jpg
5256	2703	0648d9daac77b6624f668037ef0cd66a.jpg	t	40831.jpg
5257	2704	41bff343fe5f952e6184507efee782f2.jpg	t	30824.jpg
5258	2704	872f6ec5adc49b5b41804a6bbd9e993f.jpg	t	30825.jpg
5259	2705	140642aaa46da32cb9104172614207ac.jpg	t	50032.jpg
5260	2705	9b0bbe56cdf4e7ff22e8831a7cfd7f21.jpg	t	50033.jpg
5261	2706	de739394f54e3163313b6c61a4abdac6.jpg	t	50034.jpg
5262	2706	c2ddabf52db41ec8d87a3449d52b3ee5.jpg	t	50035.jpg
5263	2707	ce403e45419f1942665c74ec39b2ea16.jpg	t	20676.jpg
5264	2707	0165d96248bc704da75ea4fa3568112a.jpg	t	20677.jpg
5265	2708	4f0f2ac789821b936b400d857176396e.jpg	t	40749.jpg
5266	2708	15634f84c1b057ffe53b3161a46e1b45.jpg	t	40750.jpg
5267	2709	4f0f2ac789821b936b400d857176396e.jpg	t	40749.jpg
5268	2709	15634f84c1b057ffe53b3161a46e1b45.jpg	t	40750.jpg
5269	2710	d11449f15f2b1521be678a1d5fdf46d1.jpg	t	31334.jpg
5270	2710	a1e067c9bca9d674fe5d4056dfaf4141.jpg	t	31335.jpg
5271	2711	3eda5bc4d5bc36f4dc571c85c89125e2.jpg	t	31330.jpg
5272	2711	b984c17f522336e5c63b2e793af8fdba.jpg	t	31331.jpg
5273	2712	4db310a89ebaeb9b98d4e43d002257f7.jpg	t	31336.jpg
5274	2712	20fd2757b3b9cfa6a30248a5244b045b.jpg	t	31337.jpg
5275	2713	6a59410e2e5893c417d2fc6d14946bbe.jpg	t	31332.jpg
5276	2713	86c2b380d2408864525f8d629c989ee3.jpg	t	31333.jpg
5277	2714	1151535ea40b7d882bf9b29023359f5e.jpg	t	31340.jpg
5278	2714	5307fcec704af0b5cf11d91bdd1fb226.jpg	t	31341.jpg
5279	2715	3b195a7006e76eb383d1deed9cbe0497.jpg	t	31342.jpg
5280	2715	28d3e36c250b4e9340359f0f579d12f3.jpg	t	31343.jpg
5281	2716	9e9c00fc7858721f6d8922f35dcc6a86.jpg	t	41134.jpg
5282	2716	10c82cc91acfc3351d6d3aa812055969.jpg	t	41135.jpg
5283	2717	af0673dcc26fd7bdb1b43fa8b58fffbb.jpg	t	41138.jpg
5284	2717	e2cdfc454656e321666b42dc3cf311a7.jpg	t	41139.jpg
5285	2718	4c9587263916540d5afd420dc93c290f.jpg	t	41170.jpg
5286	2718	cad18ed395258bb44d0b1eb7389ea931.jpg	t	41171.jpg
5287	2719	e47ac2f7e38fe8753590b6ab892fc0bd.jpg	t	41166.jpg
5288	2719	f05607ab39ca299740ccf4b9ea92ee18.jpg	t	41167.jpg
5289	2720	27f6be53ccaa0bf7a63d6d22921d1054.jpg	t	41150.jpg
5290	2720	f17751a06f73ade2a8914453d9241106.jpg	t	41151.jpg
5291	2721	1c4b770f0a0f6b2a67278d6f72adae03.jpg	t	41142.jpg
5292	2721	bcaebd6141ec2bb588ae60ed25b61721.jpg	t	41143.jpg
5293	2722	e94dfbf920c758db0028a3f2bd0add9e.jpg	t	31171.jpg
5294	2722	9ef1985e442c8e200f39faf1cf8f6be7.jpg	t	31172.jpg
5295	2723	cfdba7e5c240b4967aa9463fc687cf66.jpg	t	31165.jpg
5296	2723	dcc96b1df9089195dd5f72dafa771f2a.jpg	t	31166.jpg
5297	2724	17172049cad017d7fe001ac21ba86847.jpg	t	30167.jpg
5298	2724	7254db40617701b23aa0c6717ae7e160.jpg	t	30168.jpg
5299	2725	399394a962e0a81e6d45ef59f28c7b5a.jpg	t	40635.jpg
5300	2725	439ce2ee7d4fd819fb30b0755d67924f.jpg	t	40636.jpg
5301	2726	eafaa720d0c11bb4940b1e6209255eed.jpg	t	40627.jpg
5302	2726	7610f2559515c36160f230777c08159b.jpg	t	40628.jpg
5303	2727	4d299f22a20d4541444d9223902f260a.jpg	t	40629.jpg
5304	2727	041ac92bb31ac6a39e8162baa88d1541.jpg	t	40630.jpg
5305	2728	73da2f34e84c29972557dd223f072630.jpg	t	40639.jpg
5306	2728	0a9b19fe2bc91286f57dc2ec00984cb1.jpg	t	40640.jpg
5307	2729	f853f6e05cb32933ca1969f925f9425d.jpg	t	40593.jpg
5308	2729	6fa57850e6cc83019672d25d589f65f4.jpg	t	40594.jpg
5309	2730	f3e1532d4c7d7d95c8f570511168d72a.jpg	t	30013.jpg
5310	2730	ebe8b6fd4f94557f3df9fdb7c39bda55.jpg	t	30014.jpg
5311	2731	158d8f48bcb575b011d46a6007b233ce.jpg	t	40643.jpg
5312	2731	748f3a8577c8bd5131d1af1e773b3b54.jpg	t	40644.jpg
5313	2732	a829964c4927041afa444bda6de9d2d7.jpg	t	40647.jpg
5314	2732	31449c44a7f100946d246be9a3155673.jpg	t	40648.jpg
5315	2733	6340b5b5eae25a14915617e649298830.jpg	t	31202.jpg
5316	2733	275a47975e13d6a22cd4f37b4b42c20b.jpg	t	31203.jpg
5317	2734	28d85812956c55eb80edee86304735b8.jpg	t	31212.jpg
5318	2734	ad913be09aea1d66dd6dbf5728ddec1b.jpg	t	31213.jpg
5319	2735	e55f4bbc82ea92984bcb77684fa1e410.jpg	t	31206.jpg
5320	2735	33da1792d5e337de68f8b72b2f2bfbe0.jpg	t	31207.jpg
5321	2736	91c009e78ce772d44b627a2807a55813.jpg	t	31214.jpg
5322	2736	643927acb27b71096ef6faa902659eca.jpg	t	31215.jpg
5323	2737	298b0c291affba008c4ffee9ffb200d1.jpg	t	30961.jpg
5324	2737	616148cedf01c27f7b1203343b2db483.jpg	t	30962.jpg
5325	2738	8febd98f288453e207dca7742db3831a.jpg	t	30963.jpg
5326	2738	1d4ae27630d287a1e834c5949a56adfc.jpg	t	30964.jpg
5327	2739	768eb97162892e515be1524972434873.jpg	t	30967.jpg
5328	2739	4a0b42dcdb5486fef10cba5da3011346.jpg	t	30968.jpg
5329	2740	74471e2510510acbc58c38afe2c728ad.jpg	t	30957.jpg
5330	2740	0562216ad36c10510c7ed4019b5e3343.jpg	t	30958.jpg
5331	2741	21e4b647fa0f3092be9567bb9bd5fc56.jpg	t	30949.jpg
5332	2741	ecee87db4cd5a77bf7231a2ca20393d7.jpg	t	30950.jpg
5333	2742	c45f246af330e7a1cfa5bd679d487eb0.jpg	t	31375.jpg
5334	2742	1528645b24141447c67ecb880510039b.jpg	t	31376.jpg
5335	2743	232512f9dc83cb1a0992c2c984eadc39.jpg	t	30947.jpg
5336	2743	833e9e60d5d53af619c30dbe8d6028bf.jpg	t	30948.jpg
5337	2744	c53fc0c2f430b4185de705454240468a.jpg	t	31373.jpg
5338	2744	a6bcf33435954e84dbebc4a6cdd67a8f.jpg	t	31374.jpg
5339	2745	c53fc0c2f430b4185de705454240468a.jpg	t	31373.jpg
5340	2745	a6bcf33435954e84dbebc4a6cdd67a8f.jpg	t	31374.jpg
5341	2746	e72fcd2bc03aa208f29aef5b497f09aa.jpg	t	40902.jpg
5342	2746	40638d593285f76fcc1480d8d85cf5ec.jpg	t	40903.jpg
5343	2747	32e83473f4d0794383a76e0ddcc83739.jpg	t	40920.jpg
5344	2747	61c651f59cbe58213db15a94c16d3a72.jpg	t	40921.jpg
5345	2748	8340cccf0282b8215fd14821583b95ee.jpg	t	41088.jpg
5346	2748	c2e776aba3b523f0ad662473a559f7dd.jpg	t	41089.jpg
5347	2749	f7658eb346618b4bdd95f86f48ce9c4c.jpg	t	40908.jpg
5348	2749	91dc96693fb95a57a10bac5a99d70a15.jpg	t	40909.jpg
5349	2750	96ecf3884c45b88eb1473d4767e00c77.jpg	t	40928.jpg
5350	2750	3189c48550f612a1db1c3228937dde96.jpg	t	40929.jpg
5351	2751	a7a2427e75c5cd09e3607bb6fed12af4.jpg	t	41090.jpg
5352	2751	32c8f2bebc31b7043f921297d0fa253d.jpg	t	41091.jpg
5353	2752	d8a39b661032799bf240e69c1965a90b.jpg	t	40916.jpg
5354	2752	2470e1a1385c87e856a8653337a785c3.jpg	t	40917.jpg
5355	2753	e80991efa5368b599fb463aeb7e3bfb4.jpg	t	40932.jpg
5356	2753	035d8bd4535bbd0b05ab961e6f49b2be.jpg	t	40933.jpg
5357	2754	b12fd3d0775a1e6a6229b81844f2ad0a.jpg	t	20032.jpg
5358	2754	6c397f16eec2312760d4e0fcc97543d9.jpg	t	20033.jpg
5359	2755	3dfd6462cb45dc9225e9c3a6c269ffb7.jpg	t	40789.jpg
5360	2755	28255125dafdae3da87f69d7282769c5.jpg	t	40790.jpg
5361	2756	0dbba45f9ba7dd5c3d541b04b383ccc0.jpg	t	40791.jpg
5362	2756	b444e2b42eaff7ea6c1d5ffd2e39dbf3.jpg	t	40792.jpg
5363	2757	7e1c01944737ca98c54b7ad5136e1f85.jpg	t	40779.jpg
5364	2757	d7c8e6c8f7d64497b8c1e063ee87ed27.jpg	t	40780.jpg
5365	2758	c285ed449e8550bbeeb55546c89b07c3.jpg	t	40781.jpg
5366	2758	0fdc1f829097d9adfd5a94be0ac1f934.jpg	t	40782.jpg
5367	2759	fa8c51cbc2eea80317b51dc4f9aadecf.jpg	t	40787.jpg
5368	2759	fbf7fa29ac25f1fd1dad07beee7335c6.jpg	t	40788.jpg
5369	2760	1329fc457fc469ede194b4f5dbc765d2.jpg	t	40783.jpg
5370	2760	0859931abd9f77eb3664f64651924cd9.jpg	t	40784.jpg
5371	2761	4a6d15d75308618388617c6d8e1a1b41.jpg	t	40785.jpg
5372	2761	529f8295f92676747c8336e9c8cc70e1.jpg	t	40786.jpg
5373	2762	46d8a6e724d7e2e05daf370cd60c8336.jpg	t	30840.jpg
5374	2762	cd938b81e0e45df53fe6ecf8c73c2773.jpg	t	30841.jpg
5375	2763	78411006b17c2dab42ff9414c7099f0e.jpg	t	30832.jpg
5376	2763	49bec3d8aa54cf7131089723fe02b48c.jpg	t	30833.jpg
5377	2764	43b46bed3c23223ca807449179b0ee40.jpg	t	30856.jpg
5378	2764	c13f27b0794613756f1f078083aad73b.jpg	t	30857.jpg
5379	2765	30f470f8ea2ecc1e0d6e7f4f0f149019.jpg	t	30846.jpg
5380	2765	bf509a376c67a9c2a351c3bbc62cfe3a.jpg	t	30847.jpg
5381	2766	99f72307a03298d20f231498feef6181.jpg	t	30836.jpg
5382	2766	8f35bd8e84edb038a55983ec96b8777a.jpg	t	30837.jpg
5383	2767	3c223d2a4e92a7e81d0d709cb36317db.jpg	t	40549.jpg
5384	2767	ff364607a330d0d66fa2c67f072d37ee.jpg	t	40550.jpg
5385	2768	12132c2be6bea4fb7d86fddb0b5bbb65.jpg	t	41106.jpg
5386	2768	a641bacf080b091c97010a697304ccc3.jpg	t	41107.jpg
5387	2769	5619327f255761c469ac61b33fc06977.jpg	t	41102.jpg
5388	2769	3ef5581a2fd865b8ce8303ff159626ad.jpg	t	41103.jpg
5389	2770	c1ff572d1e3999539c3be98b2e3025bd.jpg	t	40816.jpg
5390	2770	97945b0088b500a22af5239ea66850e6.jpg	t	40817.jpg
5391	2771	5f27c11f61a85a52adb028dab5dd537d.jpg	t	40856.jpg
5392	2771	de62a30f8b5e4fd3b3cf77f3f4b40b1c.jpg	t	40857.jpg
5393	2772	8a5268ff88cd1d1717dbb5000b8a9eda.jpg	t	40848.jpg
5394	2772	6defb501dd6d1f2126b589efedcefa82.jpg	t	40849.jpg
5395	2773	9100b328ad12d3fc19b7096191bc1afb.jpg	t	40858.jpg
5396	2773	e36c10fd9062572dc8f74fb1b9d1a4d1.jpg	t	40859.jpg
5397	2774	e7aab673dbc7e9a17f492aefd7cc506e.jpg	t	31274.jpg
5398	2774	550a7743c0544239bd902981c6c99801.jpg	t	31275.jpg
5399	2775	2fde63ca8a8c2c28fa48f527fe893b92.jpg	t	30902.jpg
5400	2775	7f84c57fc690642f489e6d32632bd52f.jpg	t	30903.jpg
5401	2776	94acae8bc86d8c2569efc89cf1fe7839.jpg	t	40704.jpg
5402	2776	a1f89b2791c2a9465d1c074b4aee9573.jpg	t	40705.jpg
5403	2777	0499ae947dbe53c4f96fff5d6a181af6.jpg	t	30894.jpg
5404	2777	4fbb0f9c91ebb9e375a963674a52a5fb.jpg	t	30895.jpg
5405	2778	b33a60dc801f01186cfd227d94a3e5fc.jpg	t	30896.jpg
5406	2778	701fee0124c9ff011f903063823c493e.jpg	t	30897.jpg
5407	2779	c54378bedc16b475531715a83538fef6.jpg	t	10488.jpg
5408	2779	274488e325a9fb56155d859d5f300402.jpg	t	10489.jpg
5409	2780	b74db56974251dd584ca0b100b87b0f2.jpg	t	30724.jpg
5410	2780	f182283e593b71fa9dfc70a6e27d82c5.jpg	t	30725.jpg
5411	2781	45c96fbb49d000e98d7992d29dcb2ed8.jpg	t	40793.jpg
5412	2781	0a84f18a0c1e673a26e2fdebc0134313.jpg	t	40794.jpg
5413	2782	5c77a6c126ae994e3568b2e09063e9d0.jpg	t	40702.jpg
5414	2783	8d8c8c9e0bc7637f9874ca0f25cbb94b.jpg	t	40703.jpg
5415	2784	c684e4fd3f700ff611fb01998225b898.jpg	t	40699.jpg
5416	2785	6a909b60b7594b1cef6684c719ccda40.jpg	t	40697.jpg
5417	2785	62a72fd750f3e1433dd366fa7e437041.jpg	t	40698.jpg
5418	2786	c2e129a8acb93efe83ef001666a50216.jpg	t	30778.jpg
5419	2786	26f1e03a40ef64a9fb92b552e5020564.jpg	t	30779.jpg
5420	2787	4002be4ce419a849111a7c324ef93b4b.jpg	t	30784.jpg
5421	2787	2dfc4fbd8b87596fcebf0f139b9fa6f3.jpg	t	30785.jpg
5422	2788	6a909b60b7594b1cef6684c719ccda40.jpg	t	40697.jpg
5423	2788	62a72fd750f3e1433dd366fa7e437041.jpg	t	40698.jpg
5424	2789	e0bf1b075b032f54c1373f16d34a47f9.jpg	t	30782.jpg
5425	2789	14582e55965c8ae99f39ea6c3845168c.jpg	t	30783.jpg
5426	2790	5055948cdaca9acbf1dbaf662aff32bc.jpg	t	40700.jpg
5427	2790	315b102dde511bfed51a7fc83e3047b6.jpg	t	40701.jpg
5428	2791	bbb31958ebc12494cff94883cad56498.jpg	t	30871.jpg
5429	2791	358b4ebf408d0814e3a1db998e2ddeb1.jpg	t	30872.jpg
5430	2792	cd89a21094049a895eb5e8af4d772bc7.jpg	t	30882.jpg
5431	2792	218bc413416aa6dba60b448e951303d6.jpg	t	30883.jpg
5432	2793	fd8504d5d5e36f412856640bb0329b2b.jpg	t	30888.jpg
5433	2793	241cafe1586645b96869c8d136cfbc4a.jpg	t	30889.jpg
5434	2794	cd125807dcdf616c8afae342de978f8c.jpg	t	40808.jpg
5435	2794	8714d2e6595c6e2bcb7120af8e8d53db.jpg	t	40809.jpg
5436	2795	b607a42ab2c1c7e3109da6cd70176ec6.jpg	t	30873.jpg
5437	2795	f1ddf10da08752c203941777542132c1.jpg	t	30875.jpg
5438	2796	c4ff98222e99e4b319de7c0ba35a424f.jpg	t	40810.jpg
5439	2796	30fccdbc92d432d836ea5b948d9a568f.jpg	t	40811.jpg
5440	2797	181d64892937bd55e87ecb7f66c570a2.jpg	t	30869.jpg
5441	2797	e94a19eda35f6f28ba79b424706b68f5.jpg	t	30870.jpg
5442	2798	a074dfac2876165741e7ff1e9766d70d.jpg	t	40797.jpg
5443	2798	9c10e5d86ab6f4dd115dc4f524a3089d.jpg	t	40798.jpg
5444	2799	be10f4f7f06d6cfc276909b25ef75e2e.jpg	t	40803.jpg
5445	2799	bd4ecae06f538441157462a0dc776244.jpg	t	40804.jpg
5446	2800	c16057e59aca5afec07555211590db13.jpg	t	40801.jpg
5447	2800	9999979a758ed29145aba63778834111.jpg	t	40802.jpg
5448	2801	89dde862acc0f29c25c275e6927e07fb.jpg	t	40805.jpg
5449	2802	d43b0cfa96b74bc19812554ed126afd6.jpg	t	40795.jpg
5450	2802	ece301fd93f83630182deed687dda150.jpg	t	40796.jpg
5451	2803	477ec3b532f4bde2ac42612c421dfe87.jpg	t	31079.jpg
5452	2803	e3cfbdf1a1d8cbfd760c62d886955b7b.jpg	t	31080.jpg
5453	2804	f00d22b88e5776528978f93d0b68a36d.jpg	t	31088.jpg
5454	2804	4f74dd0e0c80239d65573456eb0f0226.jpg	t	31089.jpg
5455	2805	d9682aa0777746243e039a2d538cce16.jpg	t	31065.jpg
5456	2805	8fa6b6f920320aa14ccc17c5341c17a4.jpg	t	31066.jpg
5457	2806	8545bb435a4de44284357e081ec88fb2.jpg	t	31258.jpg
5458	2806	bcd689481c0588975d0c95e430f9c71f.jpg	t	31259.jpg
5459	2807	90897c9775a101ea5873abf2919f332c.jpg	t	31060.jpg
5460	2807	f1c60ca63e42c4a332942e3191fe6961.jpg	t	31062.jpg
5461	2808	3c2de3ca38972dc5d382e1c3c6a8ca5d.jpg	t	31083.jpg
5462	2808	d45769a516ba0bdd28b3c5fa49a4a48e.jpg	t	31085.jpg
5463	2809	bec0839cfecf225321fad26193d5d0fb.jpg	t	31058.jpg
5464	2809	e6a5230433937d6b9df383db5efb6df3.jpg	t	31059.jpg
5465	2810	2536e749561c2057510cecca2f6fd80d.jpg	t	40860.jpg
5466	2810	392f0205e59303f21a98400321cbdd41.jpg	t	40861.jpg
5467	2811	c03a3f90168e7ff930940e223212daad.jpg	t	31069.jpg
5468	2811	1349df3c5429d69c1937451fb634bf2c.jpg	t	31070.jpg
5469	2812	3561686ac14d83499a80501158bf77ae.jpg	t	31084.jpg
5470	2812	d45769a516ba0bdd28b3c5fa49a4a48e.jpg	t	31085.jpg
5471	2813	fe6acb10c04cf49ca285aafdaa8450db.jpg	t	31196.jpg
5472	2813	d32e84dc7820918d39d8a523de9b563c.jpg	t	31199.jpg
5473	2814	cf993cec73cf0df301caa1cc34466d55.jpg	t	31197.jpg
5474	2814	d32e84dc7820918d39d8a523de9b563c.jpg	t	31199.jpg
5475	2815	9a6770ac9fa3469791109cce0ab00653.jpg	t	31198.jpg
5476	2815	d32e84dc7820918d39d8a523de9b563c.jpg	t	31199.jpg
5477	2816	d2e49510bbcaeb1c9318e0946ef56dfb.jpg	t	31200.jpg
5478	2816	3ab27a318c6857c83fabdbaff13e956e.jpg	t	31201.jpg
5479	2817	b09f503f86ef38098d4de066641ef12a.jpg	t	30430.jpg
5480	2817	4c8030264f41230bec9eecb513984353.jpg	t	30431.jpg
5481	2818	c2b01c4278d3af7702e888917ed41ab2.jpg	t	40736.jpg
5482	2818	864d9863ebe823eaccc1408489393667.jpg	t	40737.jpg
5483	2819	204960ffc3b891b4d27e0f73d8a37f84.jpg	t	40740.jpg
5484	2819	688eb100aaaa5fd7121cbe627f91b961.jpg	t	40741.jpg
5485	2820	4d3ce7e251e67841cac08842bda7dd8b.jpg	t	31377.jpg
5486	2820	ab403c29c485b3c4bb85e3a3197dcf65.jpg	t	31378.jpg
5487	2821	14940ce7c7f3a496b5db77d619542831.jpg	t	40742.jpg
5488	2821	c3432ae07635d2436707a502b875f0bd.jpg	t	40743.jpg
5489	2822	756bc957a52d5aa8e693b0a933b6d95b.jpg	t	40747.jpg
5490	2822	a4081d214083ebeaf9ce935ec2982bd5.jpg	t	40748.jpg
5491	2823	108c021cf1606da1a929440fcfa456ab.jpg	t	40744.jpg
5492	2824	bda7b0f5433233a59d3878fffdde8c2b.jpg	t	40745.jpg
5493	2824	6f3022f82cee471640f94adbcc38d04b.jpg	t	40746.jpg
5494	2825	314432b193156194684902e1229722cf.jpg	t	40738.jpg
5495	2825	950b22b49980ea55019ea06d1c745700.jpg	t	40739.jpg
5496	2826	94917de864b5a352895be4ec61a0aa01.jpg	t	41030.jpg
5497	2826	5fb6a4a271e70ee457046ed36a6138be.jpg	t	41031.jpg
5498	2827	ab1166a604d75d547e8b4497b254710a.jpg	t	40511.jpg
5499	2827	c35f81b8fb9e5c1ef74dc6c6f46b8d73.jpg	t	40512.jpg
5500	2828	1511264bc6c592b989108d6e787da567.jpg	t	41034.jpg
5501	2828	2ced25e69c327d4ef171ec78934cc938.jpg	t	41035.jpg
5502	2829	e9697bb89267fbdc67006f25f8aa1385.jpg	t	41048.jpg
5503	2829	d0fab37e7d4dbd7601597e0095a63cbc.jpg	t	41049.jpg
5504	2830	57067e231a1680c72e3b8ffeea48a908.jpg	t	41042.jpg
5505	2830	3cc051ac10be7d8179cb659fcc800722.jpg	t	41043.jpg
5506	2831	7bd1122169656e2fab456a49ee636412.jpg	t	41036.jpg
5507	2831	e71681eadb1a398ecf9758a68b359a67.jpg	t	41037.jpg
5508	2832	f43b899c6c946659334a2c488c4ce7eb.jpg	t	41050.jpg
5509	2832	b7b533461dc8b3210da333e44fdbfe82.jpg	t	41051.jpg
5510	2833	3c88e87f266bf25b5bf36a480c142096.jpg	t	30931.jpg
5511	2833	c6e7c487ecf26de7879ae309588c4661.jpg	t	30932.jpg
5512	2834	05a2426ed207d4c546f0154f312f7d3a.jpg	t	30933.jpg
5513	2834	8195d80b80443dbb552374453784225d.jpg	t	30934.jpg
5514	2835	fc951f59a98adbaf739e483191c13307.jpg	t	40724.jpg
5515	2835	1c716dc2cd11bf345f81a9a885ecec74.jpg	t	40725.jpg
5516	2836	01046e53d81d1eb47acb13c5e825f28a.jpg	t	30922.jpg
5517	2836	011be0260d2d8d167fcb39aa90f63bb6.jpg	t	30923.jpg
5518	2837	09d00a86bc2d470a579da02819d46396.jpg	t	30941.jpg
5519	2837	5be6d6ad6ae44a7fce68474bff3a49e6.jpg	t	30942.jpg
5520	2838	1c716dc2cd11bf345f81a9a885ecec74.jpg	t	40725.jpg
5521	2839	0ec3b508f136ffdbcd653fab132cae3e.jpg	t	30939.jpg
5522	2839	f1f9ee4790f4dd0608b1188d20c28d6e.jpg	t	30940.jpg
5523	2840	aa6ebee834d8a84e8cf2d3429e4ae994.jpg	t	41212.jpg
5524	2840	70efb3ebd922793b45c859a4d890fc3b.jpg	t	41213.jpg
5525	2841	8f866354df5bce559d361aee42ec32ce.jpg	t	40718.jpg
5526	2841	8ed29e27eeaec031979aed9b7bcb0768.jpg	t	40719.jpg
5527	2842	32a449a44f2325531325ed5c09c2c3bb.jpg	t	40726.jpg
5528	2842	b1585c966979224b3b3d4be26d5c7000.jpg	t	40727.jpg
5529	2843	066053d51ca3c85705c8ae6e7a80fdc7.jpg	t	40720.jpg
5530	2843	28424da845e436afca14c31379de81be.jpg	t	40721.jpg
5531	2844	ee4281df9809652a86db7f71618179c7.jpg	t	30937.jpg
5532	2844	709a6884c90126eaae3660d1d9ac9f30.jpg	t	30938.jpg
5533	2845	d5691363b9c7bbf6059267351c7f69fd.jpg	t	40722.jpg
5534	2845	80f560be08b1cf8c519c72d6f441f191.jpg	t	40723.jpg
5535	2846	90ad8b357659530f34e3d29665e20397.jpg	t	30935.jpg
5536	2846	57c7035bd2a8a1f5e64c0d8bc63ed32a.jpg	t	30936.jpg
5537	2847	8b158be4127ac0f4dfb539ef3d2aaa82.jpg	t	41188.jpg
5538	2847	654c36a79807f0430965db50a3ec6401.jpg	t	41189.jpg
5539	2848	3c097cff3b60d2b0a77f242357476b86.jpg	t	40938.jpg
5540	2849	fd794cd45f73bf8cc033c0961c0f6a8e.jpg	t	41204.jpg
5541	2849	df5cbbfe731792825860d4b93cc99be8.jpg	t	41205.jpg
5542	2850	77a3dec4964c683a1bf762a1a905528b.jpg	t	41202.jpg
5543	2850	764021b74751ce8961097a7c28dac8d0.jpg	t	41203.jpg
5544	2851	1d995fc88fa7361a68f3fb6e9adc310d.jpg	t	40734.jpg
5545	2851	7f85adc34d4214a60b326901ade73629.jpg	t	40735.jpg
5546	2852	df5cbbfe731792825860d4b93cc99be8.jpg	t	41205.jpg
5547	2853	083402f7c4db41221df8bf8050fcb4b4.jpg	t	40732.jpg
5548	2853	ab7a5f764a111b8b77c50949c6c77ecd.jpg	t	40733.jpg
5549	2854	efb544169f88c70e8829eb083cb1e754.jpg	t	40730.jpg
5550	2854	836112fc3c2a76d6acdeccd4da8d465e.jpg	t	40731.jpg
5551	2855	c9b1d5295e7e4da418841ca76d3cc080.jpg	t	40714.jpg
5552	2855	67f96a5660607d8af1407ed41f4c7808.jpg	t	40715.jpg
5553	2856	d1cf584ad7149e94f6ab8f3064c37541.jpg	t	40712.jpg
5554	2856	c376cb6385a48b3582c47dc45efbe9e1.jpg	t	40713.jpg
5555	2857	31352b9223833432be8542084123d625.jpg	t	40708.jpg
5556	2857	b9202b1b566715a151ad9d8bf75522fb.jpg	t	40709.jpg
5557	2858	240bf38cab3f24a8f667397ccc154663.jpg	t	40706.jpg
5558	2858	390898ad3b2fb2381f9d2eef459c9031.jpg	t	40707.jpg
5559	2859	b5a6eb6a283efbbaf0070571c77cf2dd.jpg	t	40710.jpg
5560	2859	cfbffa7adce1e4b403a214ef4523bdc9.jpg	t	40711.jpg
5561	2860	1a8de5f53fac8bdde4b3eba98d88f4ea.jpg	t	30764.jpg
5562	2860	f25e789eb7b2a338dfa4285f971bfaa6.jpg	t	30765.jpg
5563	2861	e819127c55807299cf45266d54ca0759.jpg	t	30756.jpg
5564	2861	d6d49031639c024a0ef173ad8ea08bfc.jpg	t	30757.jpg
5565	2862	029d6af3ea668a57c3144f5aa19e870f.jpg	t	30750.jpg
5566	2862	5a3274e37a22e8ba563e0278f1675aa1.jpg	t	30751.jpg
5567	2863	8ce1481dd21f09f4514fec4a09c52698.jpg	t	40619.jpg
5568	2863	5ff6e6751ba7073aba5870eb8423e1f3.jpg	t	40620.jpg
5569	2864	81bdf86c6ba5030325703326076a8c03.jpg	t	40641.jpg
5570	2864	dbcb4faa11581e846774def20f9069c4.jpg	t	40642.jpg
5571	2865	36a1226f70b9ac64dec990ff213ad908.jpg	t	30569.jpg
5572	2865	254347d825c321b40660f8c024d4cb4c.jpg	t	30570.jpg
5573	2866	5beeef4f38a6b8f45a0429dfee01d449.jpg	t	40680.jpg
5574	2866	9406db3051508130a8ea617cbcb2aa85.jpg	t	40681.jpg
5575	2867	215a186d4feee53f5a9166bda77c5d13.jpg	t	40682.jpg
5576	2867	702ab17be2707a636fcfdd5ae35e7505.jpg	t	40683.jpg
5577	2868	aeeefc681212192058bedcf99516328f.jpg	t	40679.jpg
5578	2869	ffe44f9ae013595007f7d5a4fcaa2a3e.jpg	t	30975.jpg
5579	2869	637cff737ea395fc689fd974fb860fec.jpg	t	30978.jpg
5580	2870	4f86b9bf957bc8aa031cc4444bc21581.jpg	t	30979.jpg
5581	2870	637cff737ea395fc689fd974fb860fec.jpg	t	30978.jpg
5582	2871	8b7322b4f63aa09904fb4c0fcd3270e8.jpg	t	41118.jpg
5583	2871	f1603f5de4a8ca7d0db0359b21e10207.jpg	t	41119.jpg
5584	2872	05d0749fdb9aca132c52c61c09e16250.jpg	t	41116.jpg
5585	2872	7c4bd956fa4f8875d0c80c1e1a73f8be.jpg	t	41117.jpg
5586	2873	d5f7381eacd1f8206e34a938955d9068.jpg	t	20502.jpg
5587	2873	d8d2fa642604326787b6aff773d85aa2.jpg	t	20503.jpg
5588	2992	b8f576e3ea8efbc906d6bea3c9eb2427.jpg	t	31029.jpg
5589	2992	4aa9e8afcb0494daa7455b2f0601300d.jpg	t	31030.jpg
5590	2993	10e3f53a6d425d5f746d77c8c64b90eb.jpg	t	40850.jpg
5591	2993	2c8fa8c53fe19897b1024673964b4c89.jpg	t	40851.jpg
5592	2994	ffdb572ec81a3325727c5f5867c0321d.jpg	t	41076.jpg
5593	2994	f35ee69d6d2e5ba084705c576d637f08.jpg	t	41077.jpg
5594	2995	d11e5c835021014c27053b8daa591984.jpg	t	41056.jpg
5595	2995	9dcffb5abaa89d478b90385955cf517d.jpg	t	41057.jpg
5596	2996	4fa13efd150b4b3d553275b7789088cb.jpg	t	41084.jpg
5597	2996	bf8c27ccbcd22520014e521304df1219.jpg	t	41085.jpg
5598	2997	7f5ad298415a4a2b3134a057c5725992.jpg	t	41060.jpg
5599	2997	4c3b50f6d8106d85bd6e2992438286a1.jpg	t	41061.jpg
5600	2998	c827c5b23f7b68a8e412257e04afba26.jpg	t	41070.jpg
5601	2998	ea88be58c705098928d7d3c0b71419e2.jpg	t	41071.jpg
5602	2999	0ccd347ee36366f2118fb9af7f0208cd.jpg	t	41066.jpg
5603	2999	259678cbd3bdbdc5441e5cb5a47cb0a3.jpg	t	41067.jpg
5604	3000	4002d17dd96e47eada2449c3208be50f.jpg	t	41072.jpg
5605	3000	d2b964455f9bf8dbe547fe7b7f1cd106.jpg	t	41073.jpg
5606	3001	9047e99a87c76ae8f05d5ed5fd03c281.jpg	t	31045.jpg
5607	3001	1a47280b476f9922a78c71fba0e3afda.jpg	t	31046.jpg
5608	3002	378b14eecbdb009694d0e7d8489fa4ed.jpg	t	31037.jpg
5609	3002	b00ee69b6d44c106ff107882faa640a9.jpg	t	31038.jpg
5610	3003	7106440f3d3e81632ef46835d0101fc8.jpg	t	31107.jpg
5611	3003	91e4b31eb289c769bdd9deec532a57f7.jpg	t	31108.jpg
5612	3004	3da8cdcfe5fc12f154a0831c37e5bcb6.jpg	t	31111.jpg
5613	3004	4553de7005026f90f62daa4a44e31c29.jpg	t	31112.jpg
5614	3005	0afc5a07bc3b30348b2326272548f283.jpg	t	31027.jpg
5615	3005	8ff9f0ba7ab80eb12ee7a2334b64f780.jpg	t	31028.jpg
5616	3006	beeb9f6b46c1f187cd49bb9d5a4830c8.jpg	t	31021.jpg
5617	3006	f3b8124b3ec04efe830d2a839db63abc.jpg	t	31022.jpg
5618	3007	c09a59928b838f7e0a9498d13d974034.jpg	t	31039.jpg
5619	3007	9c42576ff32cd1226eb48c781cc64dfa.jpg	t	31040.jpg
5620	3008	8313af38464a09d912d2a01c91d9c145.jpg	t	31049.jpg
5621	3008	ccbe3146c70ae480db07b58b513b096b.jpg	t	31050.jpg
5622	3009	e0000a110e66f37998a0fbc593467362.jpg	t	40820.jpg
5623	3009	3bbb0fefd63aa6333b9a42e15f4a1fb9.jpg	t	40821.jpg
5624	3010	d41d8cd98f00b204e9800998ecf8427e.jpg	t	30826.jpg
5625	3010	965d31d2a49947d2b67436020c9f5219.jpg	t	30827.jpg
5626	2881	ad08fe53a5e484ea568d60544ef3f05c.jpg	t	pics1.rar
5627	2881	ad08fe53a5e484ea568d60544ef3f05c.jpg	t	pics4.rar
5628	2881	ad08fe53a5e484ea568d60544ef3f05c.jpg	t	pics3.rar
5629	2892	97bfe1bdb2156b8f6edf99c952c818b3.jpg	t	Image0200[1].jpg
5630	2876	7c28bd0f77fb6b538e0a5edb82add079.jpg	t	DSC04196 GUHPS MUSLIM COLONY.JPG
5631	2909	ed75257a8419d08388a9f74c2a000d59.jpg	t	23072011059.jpg
5632	2892	6b55195ae346c17a1792241fb54a0c32.jpg	t	Image0195[1].jpg
5633	2909	28e5adc365aa6ed1e0d08fdd42730055.jpg	t	23072011055.jpg
5634	2892	e1f4bd0c8fa614853f1c1ebb7c174d08.jpg	t	Image0203[1].jpg
5635	2923	d41d8cd98f00b204e9800998ecf8427e.01	t	2011-03-22 20.01.40.jpg
5636	2923	d41d8cd98f00b204e9800998ecf8427e.01	t	2011-03-22 20.01.40.jpg
5637	2923	d22c71fb7b8c2de02f9944fb9a5ee818.jpg	t	1.jpg
5638	2947	6efb64a434459356968282e73b2763a3.jpg	t	report.jpg
5639	3015	32e58fd9d9469c1875be3c6fac998e54.jpg	t	toilet.jpg
5640	2948	6efb64a434459356968282e73b2763a3.jpg	t	report.jpg
5641	2989	6c8febc89c080298667bd52e7e4da18d.jpg	t	18102010456.jpg
5642	2989	0527cc8132b61e00cae1a448e7df24b3.jpg	t	18102010457.jpg
5643	2989	284e775a1546333271d1426adc26e019.jpg	t	18102010458.jpg
5644	2989	a6863a28cb30c69bf77acff857631094.jpg	t	18102010459.jpg
5645	2989	86d8354afa4cfb4a60f5ec8d8246ea86.jpg	t	18102010460.jpg
5646	2989	f497faab96e6e564a567fd1fb092b1fd.jpg	t	18102010461.jpg
5647	2989	54271aa556c28c37e727bb7194163601.jpg	t	18102010462.jpg
5648	2989	bbd1fcb03a00a8d08cf95c149700b53c.jpg	t	18102010463.jpg
5649	2989	47af27938f4c5f201b6608baf5f83b4e.jpg	t	18102010464.jpg
5650	2989	f166530db31a05f0dfb0c0dc2c695a3e.jpg	t	18102010465.jpg
5651	2989	3497910a01c249cd9203becfbfb191a0.jpg	t	18102010466.jpg
5652	2989	72465796fd3a63bc6aeec81cc4e624e1.jpg	t	18102010467.jpg
5653	2989	18acd3fc0d761b75ff61132c500a824c.jpg	t	18102010468.jpg
5654	2989	6503780b305e989d5f9cd8be966844de.jpg	t	18102010469.jpg
5655	2989	81cd772607847bcab6ef513fdb663179.jpg	t	18102010470.jpg
5656	2936	afdcfab363dde8d15d255fbd3aa80629.jpg	t	panorama.jpg
5657	2939	b030e98c5cad020263353cb4d3d48837.jpg	t	IMAG0031.jpg
5658	2939	43bb49de1bd73267dc5ec7dc637d09fe.jpg	t	IMAG0030.jpg
5659	2939	092be5d98447046a1a02c3b9a4f67412.jpg	t	IMAG0027.jpg
5660	2911	e0aebf23a546e09cfd98622335bcb11d.jpg	t	11051.jpg
5661	2911	6d7a35ae8323f670724459264c37b609.jpg	t	11050.jpg
5662	2205	4bfe0dfa62771d009e95714d0408fceb.jpg	t	11052.jpg
5663	2205	6bec8e62c2bfffaa41dd8da067dfafba.jpg	t	11053.jpg
5664	3011	9b67e114f61def337203dc14daf8f0f3.png	t	Screen Shot 2012-09-03 at 10.48.09 AM.png
5665	3013	77204e5f69d06a3aba4493e851fc0661.jpg	t	IMAG0034.jpg
5666	3013	09c6ac6666ed0d5b584d7e227b7c905c.jpg	t	IMAG0033.jpg
5667	3014	0cfb7d6d6a1bf3b75e03909682cefeb0.jpg	t	IMAG0039.jpg
5668	3019	fd902182cddce723454c6da239a17980.jpg	t	toilet.jpg
5669	3015	f534dd4b47a18511abafdce83874b6d7.jpg	t	TLM.jpg
5670	3019	5e67c9e54553eca5f3d8716348a5a216.jpg	t	food_littered_on_the_ground.jpg
5671	3019	45f4ea9b57d0a65bb7c30278b4937fa4.jpg	t	school_buildings_with_ground.jpg
5672	3015	1bb34b8763082e51453ff0067e898fe2.jpg	t	lunch.jpg
5673	3015	b8d2c7fbc38ad87c678fffb86bdb650d.jpg	t	stove_at_far_end.jpg
5674	3023	4947e7791feaa22af36825d2ffc0f448.jpg	t	IMAG0050.jpg
5675	3023	5c254fabc82016f775c542d3b154b4a5.jpg	t	IMAG0055.jpg
5676	3023	71ff74c3efd4e6bb5e518d6af962140f.jpg	t	IMAG0052.jpg
5677	3023	b682792c1944b9e04564cce8a7a14a81.jpg	t	IMAG0056.jpg
5678	3023	6245a35b6cfed9e580ee77121f83ebc8.jpg	t	IMAG0053.jpg
5679	3026	1406aeda82cccb42c1b4f4f5b754b9c8.jpg	t	d3141-large.jpg
5680	3026	c264762fe95a6928a466cdd2dd4a03ae.jpg	t	d3140-large.jpg
5681	3030	55b92bedc33169e3ccdae807c63b36ee.JPG	t	_DSC0206.JPG
5682	3029	c8367d8372de00f227b515f02d9b1756.JPG	t	DSC04353.JPG
5683	3029	7b641df46076066ba87b4358fe79fb98.JPG	t	DSC04360.JPG
5684	3030	948fcc619087c23157292933318e73ba.JPG	t	_DSC0249.JPG
5685	3030	12b9e90e85f51efbec677ef08688cb84.JPG	t	_DSC0230.JPG
5686	3029	1b7c1abc38f3f1c004355688d9a0887d.JPG	t	DSC04402.JPG
5687	3029	9fe6c86026f6919f2d2aa2be56ea9319.JPG	t	DSC04405.JPG
5688	3029	665a93c5ba6f09c795182aeb7f0377f8.JPG	t	DSC04413.JPG
5689	3036	57495acbd28dd781ce999e6160422ffe.JPG	t	_DSC0308.JPG
5690	3036	98df12c2e3fd6a524ddeb79692519b58.JPG	t	_DSC0309.JPG
5691	3036	a5a24cc3674c19ad3651c329bfeddfd4.JPG	t	_DSC0312.JPG
5692	3036	8fbfc93fa4a4f4852113e39dbf69a865.JPG	t	_DSC0307.JPG
5693	3036	bda198e58a96afd7fd756ecc03279f40.JPG	t	_DSC0310.JPG
5694	3037	0b7cc8c7ff02e1306d5b37c527e04d26.jpg	t	IMG_20121130_110508.jpg
5695	3037	a4ba12727a5ef88f3878a8e571646cdf.jpg	t	IMG_20121130_104847.jpg
5696	3038	6cf491ad4be2298e6ec8157bdb4bbd5e.jpg	t	30352_2.jpg
5697	3017	1d12a7c544c57854397777af42c010ae.jpg	t	IMG_20121130_113048.jpg
5698	3038	27de81bf0bbb7d27a07f536b5922b979.jpg	t	30352_1.jpg
5699	3017	fdd84bd6dad0b3733c227e0ee2821cae.jpg	t	IMG_20121130_112543.jpg
5700	3037	fca06bde25f0fe77f9bade8dfe06fec3.jpg	t	IMG_20121130_104940.jpg
5701	3017	8bc4fa18c6dc5db3cff825a4a50e0f8f.jpg	t	IMG_20121130_113231.jpg
5702	3038	2d881c8532425da133786fd655e6ce6d.jpg	t	30352_3.jpg
5703	3018	0f03ecbffc41dcb899b5458275b1b87a.jpg	t	30584_2.jpg
5704	3018	3ddca13163ae542377f155ccc8c10773.jpg	t	30584_3.jpg
5705	3017	33cbea0323c4ad4a26f08e428d0f0754.jpg	t	IMG_20121130_112724.jpg
5706	3018	2cd9c11be55c918d333c2e14f3641feb.jpg	t	30584_1.jpg
5707	3041	8bdf783e2f4b034525364b0975a3cb6d.JPG	t	IMG_0240.JPG
5708	3041	15b00239a39b778c8d0f6c84a796f638.JPG	t	IMG_0232.JPG
5709	3041	b9ab82376d4cefb6fa1bf265fc4e7424.JPG	t	IMG_0239.JPG
5710	3041	b83a16192797380ae62630f87566dc5e.JPG	t	IMG_0237.JPG
5711	3041	a0fb90446e8d429b43f404a34f5a2701.JPG	t	IMG_0233.JPG
5712	3310	08c2f0d2700c09f101ffc3192de118a4.jpg	t	IMG_20130803_125940.jpg
5713	3112	c017994dfc1414a49b7a9c7e57b88ffe.JPG	t	018.JPG
5714	3310	002bb2545a573e67ad32bcabf4fcf4df.jpg	t	IMG_20130803_125946.jpg
5715	3315	2ee977099881ccde2cb44577965ffc21.jpg	t	IMG_20130828_112311.jpg
5716	3315	5ad479231b1b6bb498701a292f682c26.jpg	t	IMG_20130828_112013.jpg
5717	3315	7999a920b6b6d51f55e53eaf131c4b83.jpg	t	IMG_20130828_112051.jpg
5718	3318	871185582b90e751a6c2e4a1f1a92c3d.jpg	t	Photo0252.jpg
5719	3318	871185582b90e751a6c2e4a1f1a92c3d.jpg	t	Photo0252.jpg
5720	3318	ceef37e2e75c3e277f095615c4dcd27e.jpg	t	Photo0249.jpg
5721	3318	a98144411c10f704516e5e09051e1403.jpg	t	Photo0246.jpg
5722	3317	4db150dcf0fb0b0ef3f842817b660492.jpg	t	IMG_20130828_104851.jpg
5723	3318	bed39ec7da7af71e86ecb162a0a74b4d.jpg	t	Photo0251.jpg
5724	3317	de0f9fa4c9efe2abdd13dc86d2e4a933.jpg	t	IMG_20130828_105015.jpg
5725	3086	202bd324f79128964dd7deb3bf184cf8.JPG	t	DSCN0507.JPG
5726	3086	16abd25f2b662ab50a460f8e94ca04aa.JPG	t	DSCN0481.JPG
5727	3085	7db20c023dbaa5d08b8372af9b435a76.JPG	t	DSCN0512.JPG
5728	3085	9803551db4004f4b48f55e36690a5a2e.JPG	t	DSCN0511.JPG
5729	3086	0313d4f9848cf9073d3902070b633c17.JPG	t	DSCN0466.JPG
5730	3086	9a3cbad6317db264e000a739bbe71d41.JPG	t	DSCN0471.JPG
5731	3085	fa72ae578c0f56da8bdd9a2a2451aba6.JPG	t	DSCN0509.JPG
5732	3085	57977d89406ef404bb9f9d3fb2088708.JPG	t	DSCN0510.JPG
5733	3086	f7b121f8ca4b8a042152cbfcbac88121.JPG	t	DSCN0467.JPG
5734	3310	76bc4c5f996b4fdd55db409c87d430bc.jpg	t	IMG_20130803_130053.jpg
5735	3112	3233c261a1bff306ad8e60d4e89756db.JPG	t	020.JPG
5736	3310	fa3a6bd786324a9ff387835026a0f53f.jpg	t	IMG_20130803_125955.jpg
5737	3112	44948e8269051f8f5cdb7962363175f8.JPG	t	022.JPG
5738	3112	53e2d99dba3e7f884ce14c1a4a402e6d.JPG	t	021.JPG
5739	3112	34993a9e61c1d25e1d137aad6a1551a9.JPG	t	019.JPG
5740	3310	1bb9f263cbe421d31e3b2fd673e4f9b7.jpg	t	IMG_20130803_130105.jpg
5741	3545	0d385f02e47e4103a45f97ef652f4ee3.JPG	t	DSCF0455.JPG
5742	3545	145b39b126f2f3d8e01713e9be70d1cf.JPG	t	DSCF0462.JPG
5743	3545	290a48b630f44e1613552b5013c69c31.JPG	t	DSCF0463.JPG
5744	3545	529d941a7023d37d118eaab422dd9461.JPG	t	DSCF0454.JPG
5745	3547	73eff190fb8492159ffd58dfbd3f823a.JPG	t	SANY0024.JPG
5746	3547	593d4e45f4e59aff7bc2e6bdfa6e44c9.JPG	t	SANY0026.JPG
5747	3550	202369e809f930de5352f733ee80a2a5.JPG	t	SANY0031.JPG
5748	3550	908b9ccb6a452cac3b1a62f4b96135ba.JPG	t	SANY0030.JPG
5749	3546	b7e997b6172f4242a00bdf26f5d55f54.JPG	t	SANY0006.JPG
5750	3550	6a7e3cf5207e69df79028706dcfa9dbb.JPG	t	SANY0029.JPG
5751	3546	94edb2feb93df0ccf463e69786aec921.JPG	t	SANY0004.JPG
5752	3547	d842b2ad04ace8eb3b49e01d5a4ee436.JPG	t	SANY0036.JPG
5753	3546	70880f654c082ee43c063c9e8986311c.JPG	t	SANY0002.JPG
5754	3547	d9020148065cb19d03c0e52c1faf18b8.JPG	t	SANY0039.JPG
5755	3546	5beec8ad5c15be5e65c4f3e4f934a315.JPG	t	SANY0013.JPG
5756	3546	f9fb049c060003e075643dbc50edd220.JPG	t	SANY0010.JPG
5757	3547	8df1073280203e5a8efd46a450bfc3e1.JPG	t	SANY0022.JPG
5758	3550	484afd10870467888a00cd594aaee8be.JPG	t	SANY0028.JPG
\.


--
-- Name: stories_storyimage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: klp
--

SELECT pg_catalog.setval('stories_storyimage_id_seq', 5758, true);


--
-- Name: stories_answer_pkey; Type: CONSTRAINT; Schema: public; Owner: klp; Tablespace: 
--

ALTER TABLE ONLY stories_answer
    ADD CONSTRAINT stories_answer_pkey PRIMARY KEY (id);


--
-- Name: stories_question_pkey; Type: CONSTRAINT; Schema: public; Owner: klp; Tablespace: 
--

ALTER TABLE ONLY stories_question
    ADD CONSTRAINT stories_question_pkey PRIMARY KEY (id);


--
-- Name: stories_questiongroup_pkey; Type: CONSTRAINT; Schema: public; Owner: klp; Tablespace: 
--

ALTER TABLE ONLY stories_questiongroup
    ADD CONSTRAINT stories_questiongroup_pkey PRIMARY KEY (id);


--
-- Name: stories_questiongroup_question_questiongroup_id_question_id_key; Type: CONSTRAINT; Schema: public; Owner: klp; Tablespace: 
--

ALTER TABLE ONLY stories_questiongroup_questions
    ADD CONSTRAINT stories_questiongroup_question_questiongroup_id_question_id_key UNIQUE (questiongroup_id, question_id);


--
-- Name: stories_questiongroup_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: klp; Tablespace: 
--

ALTER TABLE ONLY stories_questiongroup_questions
    ADD CONSTRAINT stories_questiongroup_questions_pkey PRIMARY KEY (id);


--
-- Name: stories_questiontype_pkey; Type: CONSTRAINT; Schema: public; Owner: klp; Tablespace: 
--

ALTER TABLE ONLY stories_questiontype
    ADD CONSTRAINT stories_questiontype_pkey PRIMARY KEY (id);


--
-- Name: stories_source_pkey; Type: CONSTRAINT; Schema: public; Owner: klp; Tablespace: 
--

ALTER TABLE ONLY stories_source
    ADD CONSTRAINT stories_source_pkey PRIMARY KEY (id);


--
-- Name: stories_story_pkey; Type: CONSTRAINT; Schema: public; Owner: klp; Tablespace: 
--

ALTER TABLE ONLY stories_story
    ADD CONSTRAINT stories_story_pkey PRIMARY KEY (id);


--
-- Name: stories_storyimage_pkey; Type: CONSTRAINT; Schema: public; Owner: klp; Tablespace: 
--

ALTER TABLE ONLY stories_storyimage
    ADD CONSTRAINT stories_storyimage_pkey PRIMARY KEY (id);


--
-- Name: stories_answer_question_id; Type: INDEX; Schema: public; Owner: klp; Tablespace: 
--

CREATE INDEX stories_answer_question_id ON stories_answer USING btree (question_id);


--
-- Name: stories_answer_story_id; Type: INDEX; Schema: public; Owner: klp; Tablespace: 
--

CREATE INDEX stories_answer_story_id ON stories_answer USING btree (story_id);


--
-- Name: stories_question_question_type_id; Type: INDEX; Schema: public; Owner: klp; Tablespace: 
--

CREATE INDEX stories_question_question_type_id ON stories_question USING btree (question_type_id);


--
-- Name: stories_questiongroup_questions_question_id; Type: INDEX; Schema: public; Owner: klp; Tablespace: 
--

CREATE INDEX stories_questiongroup_questions_question_id ON stories_questiongroup_questions USING btree (question_id);


--
-- Name: stories_questiongroup_questions_questiongroup_id; Type: INDEX; Schema: public; Owner: klp; Tablespace: 
--

CREATE INDEX stories_questiongroup_questions_questiongroup_id ON stories_questiongroup_questions USING btree (questiongroup_id);


--
-- Name: stories_questiongroup_source_id; Type: INDEX; Schema: public; Owner: klp; Tablespace: 
--

CREATE INDEX stories_questiongroup_source_id ON stories_questiongroup USING btree (source_id);


--
-- Name: stories_story_group_id; Type: INDEX; Schema: public; Owner: klp; Tablespace: 
--

CREATE INDEX stories_story_group_id ON stories_story USING btree (group_id);


--
-- Name: stories_story_school_id; Type: INDEX; Schema: public; Owner: klp; Tablespace: 
--

CREATE INDEX stories_story_school_id ON stories_story USING btree (school_id);


--
-- Name: stories_story_user_id; Type: INDEX; Schema: public; Owner: klp; Tablespace: 
--

CREATE INDEX stories_story_user_id ON stories_story USING btree (user_id);


--
-- Name: stories_storyimage_story_id; Type: INDEX; Schema: public; Owner: klp; Tablespace: 
--

CREATE INDEX stories_storyimage_story_id ON stories_storyimage USING btree (story_id);


--
-- Name: questiongroup_id_refs_id_433e7df2; Type: FK CONSTRAINT; Schema: public; Owner: klp
--

ALTER TABLE ONLY stories_questiongroup_questions
    ADD CONSTRAINT questiongroup_id_refs_id_433e7df2 FOREIGN KEY (questiongroup_id) REFERENCES stories_questiongroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: stories_answer_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: klp
--

ALTER TABLE ONLY stories_answer
    ADD CONSTRAINT stories_answer_question_id_fkey FOREIGN KEY (question_id) REFERENCES stories_question(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: stories_answer_story_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: klp
--

ALTER TABLE ONLY stories_answer
    ADD CONSTRAINT stories_answer_story_id_fkey FOREIGN KEY (story_id) REFERENCES stories_story(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: stories_question_question_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: klp
--

ALTER TABLE ONLY stories_question
    ADD CONSTRAINT stories_question_question_type_id_fkey FOREIGN KEY (question_type_id) REFERENCES stories_questiontype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: stories_question_school_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: klp
--

ALTER TABLE ONLY stories_question
    ADD CONSTRAINT stories_question_school_type_fkey FOREIGN KEY (school_type) REFERENCES tb_boundary_type(id);


--
-- Name: stories_questiongroup_questions_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: klp
--

ALTER TABLE ONLY stories_questiongroup_questions
    ADD CONSTRAINT stories_questiongroup_questions_question_id_fkey FOREIGN KEY (question_id) REFERENCES stories_question(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: stories_questiongroup_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: klp
--

ALTER TABLE ONLY stories_questiongroup
    ADD CONSTRAINT stories_questiongroup_source_id_fkey FOREIGN KEY (source_id) REFERENCES stories_source(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: stories_story_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: klp
--

ALTER TABLE ONLY stories_story
    ADD CONSTRAINT stories_story_group_id_fkey FOREIGN KEY (group_id) REFERENCES stories_questiongroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: stories_story_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: klp
--

ALTER TABLE ONLY stories_story
    ADD CONSTRAINT stories_story_school_id_fkey FOREIGN KEY (school_id) REFERENCES tb_school(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: stories_story_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: klp
--

ALTER TABLE ONLY stories_story
    ADD CONSTRAINT stories_story_user_id_fkey FOREIGN KEY (user_id) REFERENCES users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: stories_storyimage_story_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: klp
--

ALTER TABLE ONLY stories_storyimage
    ADD CONSTRAINT stories_storyimage_story_id_fkey FOREIGN KEY (story_id) REFERENCES stories_story(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--


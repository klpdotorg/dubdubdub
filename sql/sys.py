import psycopg2


# tb_sys_data
#  id                | integer                  | not null default nextval('tb_sys_data_id_seq'::regclass)
#  schoolid          | integer                  |
#  name              | character varying(100)   |
#  email             | character varying(100)   |
#  telephone         | character varying(50)    |
#  dateofvisit       | character varying(50)    |
#  comments          | character varying(2000)  |
#  entered_timestamp | timestamp with time zone | not null default now()
#  verified          | character varying(1)     | default 'N'::character varying

# stories_story
# id                | integer                  | not null default nextval('stories_story_id_seq'::regclass)
# user_id           | integer                  |
# school_id         | integer                  | not null
# group_id          | integer                  | not null
# is_verified       | boolean                  | not null
# name              | character varying(100)   |
# email             | character varying(100)   |
# date              | character varying(50)    |
# telephone         | character varying(50)    |
# entered_timestamp | timestamp with time zone |
# comments          | varchar(20000)

# tb_sys_questions
#                                   Table "public.tb_sys_questions"
#   Column  |          Type          |                           Modifiers
# ----------+------------------------+---------------------------------------------------------------
#  id       | integer                | not null default nextval('tb_sys_questions_id_seq'::regclass)
#  hiertype | integer                |
#  qtext    | character varying(500) |
#  qfield   | character varying(50)  |

# stories_question
# -----
#  id               | integer | not null default nextval('stories_question_id_seq'::regclass)
#  text             | text    | not null
#  data_type        | integer | not null
#  question_type_id | integer | not null
#  options          | text    |
#  is_active        | boolean | not null
#  school_type integer
#  qid  integer

# ----------+--------------------------+--------------------------------------------------------------
#  id       | integer                  | not null default nextval('tb_sys_displayq_id_seq'::regclass)
#  hiertype | integer                  |
#  qtext    | character varying(500)   |
#  qfield   | character varying(50)    |
#  qtype    | sys_question_type        |
#  options  | character varying(500)[] |

# stories_answer
# -------------+---------+-------------------------------------------------------------
#  id          | integer | not null default nextval('stories_answer_id_seq'::regclass)
#  story_id    | integer | not null
#  question_id | integer | not null
#  text        | text    | not null

# tb_sys_qans
# --------+------------------------+-----------
#  sysid  | integer                | not null
#  qid    | integer                |
#  answer | character varying(500) |

# stories_storyimage
# -------------+------------------------+-----------------------------------------------------------------
#  id          | integer                | not null default nextval('stories_storyimage_id_seq'::regclass)
#  story_id    | integer                | not null
#  image       | character varying(100) | not null
#  is_verified | boolean                | not null
#  filename    | character varying(50)  |

school_type_map = {
    'ang': 1,
    'school': 2
}

question_type_map = {
    'radio': 1,
    'checkbox': 2
}

query = {
    'get_sys_data': 'SELECT * from tb_sys_data;',
    'insert_to_stories': 'INSERT INTO stories_story (user_id, school_id, group_id, is_verified, name, email, date, telephone, entered_timestamp, comments, sysid) VALUES (%(user_id)s, %(school_id)s, %(group_id)s, %(is_verified)s, %(name)s, %(email)s, %(date)s, %(telephone)s, %(entered_ts)s, %(comments)s, %(sysid)s)',
    'get_invalid_schools': 'select schoolid from tb_sys_data where schoolid not in (select id from tb_school) order by schoolid DESC',
    'get_questions': 'select * from tb_sys_questions',
    'get_displayq': 'select * from tb_sys_displayq where qfield=%(field)s',
    'get_displayq_type': 'select qtype from tb_sys_displayq where qtext=%(text)s',
    'insert_to_questions': 'INSERT INTO stories_question (text, data_type, question_type_id, options, is_active, school_type, qid) VALUES (%(text)s, %(data_type)s, %(question_type_id)s, %(options)s, %(is_active)s, %(school_type)s, %(qid)s)',
    'get_answers': 'select * from tb_sys_qans',
    'get_new_story_id': 'select id from stories_story where sysid=%(old_id)s',
    'get_new_qid': 'select id from stories_question where qid=%(old_qid)s',
    'insert_to_answers': 'INSERT INTO stories_answer (story_id, question_id, text) VALUES (%(story_id)s, %(question_id)s, %(text)s)',
    'insert_question_order': 'INSERT INTO stories_questiongroup_questions (questiongroup_id, question_id, sequence) VALUES (1, %(qid)s, %(seq)s)',
    'get_images': 'select * from tb_sys_images',
    'insert_images': 'INSERT INTO stories_storyimage (story_id, image, is_verified, filename) VALUES (%(story_id)s, %(hash)s, %(is_verified)s, %(filename)s)'
}

# ---------------+------------------------+--------------------------------
#  schoolid      | integer                |
#  original_file | character varying(100) |
#  hash_file     | character varying(100) |
#  verified      | character varying(1)   | default 'N'::character varying
#  sysid         | integer                | not null

def connection():
    connection = psycopg2.connect("dbname=klpwww_ver4 user=klp")
    cursor = connection.cursor()
    return connection, cursor

def get_stories():
    connec, cursor = connection();
    cursor.execute(query['get_sys_data'])
    sys_data = cursor.fetchall()

    cursor.execute(query['get_invalid_schools'])
    invalid_schools = cursor.fetchall()

    for d in sys_data:
        is_verified = False
        print 'sysid', d[0]
        print 'school_id', d[1]

        if d[8] == 'Y':
            is_verified = True
        else:
            is_verified = False

        if d[1] is not None and (d[1],) not in invalid_schools:
            print 'execute'
            cursor.execute(query['insert_to_stories'], {'user_id': 1, 'school_id': d[1], 'group_id': 1, 'is_verified': is_verified, 'name': d[2], 'email': d[3], 'telephone': d[4], 'date': d[5], 'entered_ts':d[7], 'comments': d[6], 'sysid': d[0]})

    connection.commit()
    cursor.close()
    connection.close()

def insert_questions():
    connec, cursor = connection()
    cursor.execute(query['get_questions'])
    questions = cursor.fetchall()
    for question in questions:
        qid = question[0]
        hiertype = question[1]
        text = question[2]
        field = question[3]

        school_type = school_type_map[field.split('q')[0]]
        data_type = 1

        cursor.execute(query['get_displayq'], {'field': field})
        displayq = cursor.fetchall()
        if displayq:
            print displayq
            question_type = question_type_map[displayq[0][4]]
            options = displayq[0][5]
        else:
            question_type = 2
            options = None

        data = {
            'text': text,
            'data_type': data_type,
            'question_type_id': question_type,
            'options': options,
            'is_active': True,
            'school_type': school_type,
            'qid': qid
        }
            # print '-----displayq', displayq

        cursor.execute(query['insert_to_questions'], data)

        cursor.execute(query['get_new_qid'], {'old_qid': qid})
        new_qid = cursor.fetchall()[0]
        question_order = int(field.split('q')[1])
        cursor.execute(query['insert_question_order'], {'qid': new_qid,'seq': question_order})
        connec.commit()

def insert_answers():
    connec, cursor = connection()
    cursor.execute(query['get_answers'])
    answers = cursor.fetchall()

    for answer in answers:
        sysid = answer[0]
        qid = answer[1]
        text = answer[2] or ''

        print 'old_story_id', sysid
        cursor.execute(query['get_new_story_id'], {'old_id': sysid})
        story_ids = cursor.fetchall()
        if story_ids:
            story_id = story_ids[0]
            cursor.execute(query['get_new_qid'], {'old_qid': qid})
            new_qid = cursor.fetchall()[0]

            # print 'story_id', story_id
            # print 'new_qid', new_qid
            # print 'answer', text.lower()

            cursor.execute(query['insert_to_answers'], {'story_id': story_id, 'question_id': new_qid, 'text': text})

        connec.commit()

def populate_image():
    connec, cursor = connection()
    cursor.execute(query['get_images'])
    images = cursor.fetchall()
    for image in images:
        filename = image[1]
        hashname = image[2]
        is_verified = True
        sysid = image[4]

        cursor.execute(query['get_new_story_id'], {'old_id': sysid})
        story_id = cursor.fetchall()
        if story_id:
            story_id = story_id[0]
            print 'story_id', story_id
            print 'hash', hashname
            print 'filename', filename

            cursor.execute(query['insert_images'], {'story_id': story_id, 'hash': hashname, 'is_verified': True, 'filename': filename})

    connec.commit()


if __name__ == '__main__':
    insert_questions()
    insert_answers()
    populate_image()

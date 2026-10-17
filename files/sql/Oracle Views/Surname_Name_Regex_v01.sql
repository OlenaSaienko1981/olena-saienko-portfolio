-- Task 1.1  Search for "John" in all spellings
SELECT
    first_name,
    last_name,
    department_id
FROM employees
WHERE REGEXP_LIKE(
    first_name,
    '^(Jon|John|Jonathon)$',
    'i'
);
--  Task 1.2  Surnames that are easy to misspell
SELECT
    last_name,
    first_name
FROM employees
WHERE REGEXP_LIKE(
    LOWER(last_name),
    '([a-z])\1'
)
ORDER BY last_name;

-- McCain is included because LOWER(last_name)
-- produces 'mccain', which contains 'cc'.
-- McLeod is excluded because 'mcleod'
-- contains no consecutive identical letters.

-- Task 1.3: Names that will not fit the new system
SELECT
    employee_id,
    first_name,
    last_name
FROM employees
WHERE REGEXP_LIKE(first_name, '[[:space:]]')
   OR REGEXP_LIKE(last_name, '[[:space:]]')
ORDER BY employee_id;

-- Task 1.4: Protect names from automatic capitalisation
SELECT
    employee_id,
    first_name,
    INITCAP(first_name) AS first_name_initcap,
    last_name,
    INITCAP(last_name) AS last_name_initcap
FROM employees
WHERE REGEXP_LIKE(
          first_name,
          '[[:alpha:]][[:upper:]]',
          'c'
      )
   OR REGEXP_LIKE(
          last_name,
          '[[:alpha:]][[:upper:]]',
          'c'
      )
ORDER BY last_name, first_name;

-- Task 2.1: Generate the new e-mail addresses
SELECT
    employee_id,
    first_name,
    last_name,
    REGEXP_REPLACE(
        LOWER(first_name),
        '[^a-z]',
        ''
    )
    || '.' ||
    REGEXP_REPLACE(
        LOWER(last_name),
        '[^a-z]',
        ''
    )
    || '@company.com' AS new_email
FROM employees
ORDER BY employee_id;

-- Task 2.2: Audit logins against the naming policy
WITH login_analysis AS (
    SELECT
        employee_id,
        first_name,
        last_name,
        email,
        SUBSTR(
            UPPER(
                REGEXP_REPLACE(
                    SUBSTR(first_name, 1, 1) || last_name,
                    '[^a-zA-Z]',
                    ''
                )
            ),
            1,
            8
        ) AS expected_login
    FROM employees
)
SELECT
    employee_id,
    first_name,
    last_name,
    email,
    expected_login
FROM login_analysis
WHERE email <> expected_login
ORDER BY employee_id;

-- Task 2.3: Mask logins in the migration report
SELECT
    employee_id,
    REGEXP_REPLACE(
        email,
        '^(.).*(.)$',
        '\1*****\2'
    ) AS masked_login
FROM employees
ORDER BY employee_id;

-- Task 3.1: Profile the phone number formats
WITH phone_analysis AS (
    SELECT
        employee_id,
        phone_number,
        REGEXP_COUNT(phone_number, '\.') + 1 AS group_count
    FROM employees
)
SELECT
    group_count,
    COUNT(*) AS employee_count
FROM phone_analysis
WHERE group_count IN (3, 4)
GROUP BY group_count
ORDER BY group_count;

-- Task 3.2 (Part 1): Extract phone extensions
SELECT
    employee_id,
    phone_number,
    REGEXP_SUBSTR(
        phone_number,
        '[0-9]{4}$'
    ) AS extension
FROM employees
ORDER BY employee_id;

-- Task 3.2 (Part 2): Dialling prefixes
SELECT
    REGEXP_SUBSTR(
        phone_number,
        '^[0-9]+'
    ) AS dialling_prefix,
    COUNT(*) AS employee_count
FROM employees
GROUP BY
    REGEXP_SUBSTR(
        phone_number,
        '^[0-9]+'
    )
ORDER BY
    employee_count DESC,
    dialling_prefix;
    
    -- Task 3.3: Reformat numbers for the phone display
SELECT
    employee_id,
    phone_number,
    REGEXP_REPLACE(
        REGEXP_REPLACE(
            phone_number,
            '^([0-9]+)\.',
            '(\1) '
        ),
        '\.',
        '-'
    ) AS display_number
FROM employees
ORDER BY employee_id;
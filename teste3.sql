select
    cts.contest_id
    ,cts.hacker_id
    ,cts.name
    ,sum(chg.total_submissions) total_submissions
    ,sum(chg.total_accepted_submissions) total_accepted_submissions
    ,sum(chg.total_views) total_views
    ,sum(chg.total_unique_views) total_unique_views
from contests cts
left join colleges clg on cts.contest_id=clg.contest_id 
left join (
    select
        distinct c.college_id 
        ,sum(ss.total_submissions) as total_submissions
        ,sum(ss.total_accepted_submissions) as total_accepted_submissions
        ,sum(vs.total_views) as total_views
        ,sum(vs.total_unique_views) as total_unique_views
    from challenges c
    LEFT JOIN (
        select
            challenge_id
            ,sum(total_submissions) total_submissions
            ,sum(total_accepted_submissions) total_accepted_submissions
        from Submission_Stats
        group by challenge_id
        ) ss ON ss.challenge_id = c.challenge_id
    left join (
        select
            challenge_id
            ,sum(total_views) total_views
            ,sum(total_unique_views) total_unique_views
        from View_Stats
        group by challenge_id
    ) vs on vs.challenge_id=c.challenge_id 
    group by c.college_id 
) chg on clg.college_id=chg.college_id
group by cts.contest_id
    ,cts.hacker_id
    ,cts.name
having sum(ifnull(chg.total_submissions,0)
    +ifnull(chg.total_accepted_submissions,0)
    +ifnull(chg.total_views,0)
    +ifnull(chg.total_unique_views,0))>0
    order by cts.contest_id;
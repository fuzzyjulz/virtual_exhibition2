update events
set event_url = replace(old_events.event_url, 'http://vc.', 'http://staging.')
from (select * from events) as old_events
where events.id = old_events.id;

update events
set event_url = 'http://vc-staging.herokuapp.com.au'
where event_url = 'http://stemexpo.sciencealert.com.au';

update users
set email = 'staging'||users.id||'@commstrat.com.au'
where email not like '%@commstrat.com.au';
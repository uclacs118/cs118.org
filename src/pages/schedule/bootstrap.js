import moment from "moment";
import fse from "fs-extra";

const weeks = [];
for (let i = 1; i <= 10; i++) weeks.push("week" + i);
weeks.push("finals");

const contents = [
    "## Lecture: Course Intro, Bandwidth & Delay\n<b style='color: var(--good)'>Project 0 Released</b>",
    "",
    "## Lecture: Socket Programming, Web & HTTP",
    "\n<br /><b style='color: var(--good)'>Homework 1 Released</b>",
    "## Discussion: End-to-End Model, Sockets",
    "## Lecture: HTTP",
    "",
    "## Lecture: DNS",
    "",
    "## Discussion: HTTP\n<b style='color: var(--good)'>Project 1 Released</b>\n<br /><b style='color: var(--bad)'>Project 0 Due</b>",
    "\n<br /><b style='color: var(--acc)'>Martin Luther King Jr. Day</b>",
    "\n<br /><b style='color: var(--bad)'>Homework 1 Due</b>",
    "## Lecture: DNS",
    "\n<br /><b style='color: var(--good)'>Homework 2 Released</b>",
    "## Discussion: DNS",
    "## Lecture: Transport Protocols",
    "",
    "## Lecture: TCP",
    "",
    "## Discussion: Midterm Review",
    "## Lecture: Congestion Control",
    "\n<br /><b style='color: var(--bad)'>Homework 2 Due</b>",
    "<h1 style='color: var(--acc)'>Midterm</h1>In class",
    "\n<br /><b style='color: var(--good)'>Homework 3 Released</b>",
    "## Discussion: Transport",
    "## Lecture: Security 101",
    "",
    "## Lecture: Internet Protocol (IP)",
    "",
    "## Discussion: Security\n<b style='color: var(--good)'>Project 2 Released</b>\n<br /><b style='color: var(--bad)'>Project 1 Due</b>",
    "\n<br /><b style='color: var(--acc)'>Presidents' Day</b>",
    "\n<br /><b style='color: var(--bad)'>Homework 3 Due</b>",
    "## Lecture: Addressing, NAT, IPv6",
    "\n<br /><b style='color: var(--good)'>Homework 4 Released</b>",
    "## Discussion: Internet Protocol",
    "## Lecture: Routing Algorithms and Protocols 1",
    "",
    "## Lecture: Routing Algorithms and Protocols 2",
    "",
    "## Discussion: Routing + BGP",
    "## Lecture: Routing in the Internet",
    "\n<br /><b style='color: var(--bad)'>Homework 4 Due</b>",
    "## Lecture: Link Layer (Ethernet)",
    "",
    "## Discussion: Link Layer",
    "## Lecture: Hubs and Switches",
    "",
    "## Lecture: Course Review",
    "",
    "## Discussion: Final Review\n<b style='color: var(--bad)'>Project 2 Due</b>",
    "",
    "",
    "",
    "",
    "<h1 style='color: var(--acc)'>Final</h1>Location TBD",
]
const startingDay = moment.utc('2025-01-06');

let dayCounter = 0;
let weekCounter = 0;

for (let content of contents) {
    if (content) {
        fse.outputFileSync(`${weeks[weekCounter]}/${startingDay.format('YYYY-MM-DD')}.mdx`, content);
    }

    dayCounter += 1;
    if (dayCounter % 5 == 0) {
        weekCounter += 1;
        startingDay.add(3, "day");
    } else {
        startingDay.add(1, "day");
    }
}



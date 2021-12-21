local HttpService = game:GetService("HttpService")

local GITHUB_URI = "https://raw.githubusercontent.com/7kayoh/discourage/main/phrases.json"

local defaultList = {
	"You stink!",
	"You can't even improve",
	"Let's just stop, okay?",
	"At this point, just play something else",
	"Select all and hit delete, your work is terrible",
	"No one will like your work tbh",
	"Even Steve Jobs and Bill Gates hate your work",
	"Your work is disgusting, it is killing my eyes",
	"Alt F4 or Command Q for free robux",
	"240P quality, awesome!",
	"The world if without your work: 🌏",
	"The world if with your work: 🌋",
	"Fun fact, free models are better than your work",
	"Stop wasting time on this piece of crap! Go back and do your chores!",
	"Hello? Did I spot a terrible work here?",
	"Every time you make something in Studio, someone dies because of it",
	"I will stop if you make actually good work, but you never can",
	"Your crap work is the reason why we got global warming",
	"I am being serious, your work is actually terrible",
	"Gordon Ramsay will call your work trash even he is not a developer",
	"Terrible Work Award " .. os.date("*t").year .. " goes to you!",
	"OH MY GOD! LOOK! People are being 🤮 after looking at your work!",
	"Your brain is just as small as a piece of dust",
	"Smooth brain no winkles",
	"Congratulations, the test turned out to be negative, but your IQ is 0",
	"print(\"Hello world!\") look! I can code better than you!",
	"Your parents after looking at your work: 🤮\nYour parents after looking at your friend's work: 🤩",
	"Top 10 reasons why you are a god dev: \n \n Thanks for watching"
}

local status, data = pcall(HttpService.GetAsync, HttpService, GITHUB_URI)
if status then
    data = HttpService:JSONDecode(data)
	return {table.unpack(defaultList), table.unpack(data)}
else
	warn(status, data)
end

return defaultList
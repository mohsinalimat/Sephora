import Vapor
import HTTP
import Sessions

let memory = MemorySessions()
let sessions = SessionsMiddleware(sessions: memory)

let drop = Droplet()
drop.middleware.append(sessions)
if drop.environment == .development { print("Sephora is running in dev mode") }


// Index
drop.get(){ IndexHandler().index($0)}
drop.get("index"){ IndexHandler().index($0)}

// Users
drop.get("register"){ RegisterHandler().form($0) }
drop.get("register/user/:user"){ RegisterHandler().fetch($0) }
drop.get("login"){ LoginHandler().login($0) }
drop.get("login/github/:user"){ LoginHandler().loginGithub($0) }
drop.get("authorize"){ LoginHandler().authorize($0) }
drop.get("profile"){ TodoHandler().show($0) }
drop.get("user"){ AppHandler().redirectToIndex($0) }
drop.get("user/:user"){ UserHandler().show($0) }
drop.get("logout"){ LoginHandler().logout($0) }

// Forums
drop.get("forum") { request in Response(redirect: "/forum/general") }
drop.get("forum/:forum"){ ForumHandler().show($0) }
drop.post("forum/:forum/submit"){ PostHandler().submit($0) }
drop.get("forum/:forum/post/:post"){ PostHandler().show($0) }
drop.post("forum/:forum/post/:post/reply"){ ReplyHandler().submit($0) }

// Admin
drop.get("admin/dbinfo"){ AdminHandler().dbinfo($0) }
drop.get("admin/users"){ AdminHandler().users($0) }
drop.get("admin/logs"){ AdminHandler().log($0) }
drop.get("test"){ TestHandler().show($0) }
drop.get("404") { request in throw Abort.notFound }


drop.run()


// End
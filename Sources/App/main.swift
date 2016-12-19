import Vapor
import VaporPostgreSQL
import Foundation

let drop = Droplet()
try? drop.addProvider(VaporPostgreSQL.Provider.self)
let driver = drop.database?.driver as? PostgreSQLDriver
let ds = DataStore(driver!)
ds.verifyIntegrity()

/*
if let database_connection_info = ProcessInfo.processInfo.environment["DATABASE_URL"] {
    print("DATABASE_URL: ", database_connection_info)
} else {
	print("NO DATABASE_URL ENV")
}
*/

// Public
drop.get                            { IndexHandler($0).view }
drop.get("index")                   { IndexHandler($0).view }
drop.get("test")                    { TestHandler($0).view }
drop.get("login")                   { LoginHandler($0).view }
drop.get("register")                { RegisterHandler($0).view }
drop.get("user")                    { AppHandler($0).redirect("/") }
drop.get("user/:user")              { UserHandler($0).view }
drop.get("forum")                   { AppHandler($0).redirect("/forum/general") }
drop.get("forum/:forum")            { ForumHandler($0).view }
drop.get("forum/:forum/post/:post") { ThreadHandler($0).view }
drop.get("404")                     { response in throw Abort.notFound }

// Admin
drop.get("install")                 { AdminHandler($0, context: ds).install }
drop.get("admin/dbinfo")            { AdminHandler($0, context: ds).dbinfo }
drop.get("admin/users")             { AdminHandler($0, context: ds).users }

drop.run()

package main

import (
	"database/sql"
	"fmt"
	"log"
	"time"

	_ "github.com/go-sql-driver/mysql"

	"html/template"

	"net/http"
)

/*type rawTime []byte

func (t rawTime) Time() (time.Time, error) {
	return time.Parse("2006-01-02 15:04:05", string(t))
}*/

/*type MyField struct {
	Key   string `json:"key"`
	Value string `json:"value"`
}*/

type Post struct {
	Id          int
	User_id     int
	Name        string
	Message     string
	Date        time.Time
	Content_id  int
	Category_id string //JSON in MySQL
	Meta_id     string //JSON in MySQL
}

type Content struct {
	Id      int
	Post_id int
	Type    string
	Name    string
}

type Commentary struct {
	Id      int
	User_id int
	Message string
	Date    time.Time
	Post_id int
}

type User struct {
	Id          int
	Name        string
	Password    string
	Signup_date time.Time
}

type Category struct {
	Id   int
	Name string
}

type Meta struct {
	Id   int
	Name string
}

type Score struct {
	Id      int
	Post_id int
	User_id int
	Count   int
}

var database *sql.DB

/*func (m *MyField) Scan(src interface{}) error {
	val := src.([]uint8)
	return json.Unmarshal(val, &m)
}*/

func IndexHandler(w http.ResponseWriter, r *http.Request) {

	r_post, err := database.Query("select * from image_board.post")
	if err != nil {
		log.Println(err)
	}
	defer r_post.Close()
	posts := []Post{}

	for r_post.Next() {
		var p Post

		err := r_post.Scan(&p.Id, &p.User_id, &p.Name, &p.Message, &p.Date,
			&p.Content_id, &p.Category_id, &p.Meta_id)

		if err != nil {
			fmt.Println(err)
			continue
		}

		posts = append(posts, p)
	}

	r_content, err := database.Query("select * from image_board.content")
	if err != nil {
		log.Println(err)
	}
	defer r_content.Close()
	contents := []Content{}

	for r_content.Next() {
		c := Content{}
		err := r_content.Scan(&c.Id, &c.Post_id, &c.Type, &c.Name)
		if err != nil {
			fmt.Println(err)
			continue
		}
		contents = append(contents, c)
	}

	r_commentary, err := database.Query("select * from image_board.commentary")
	if err != nil {
		log.Println(err)
	}
	defer r_commentary.Close()
	commentarys := []Commentary{}

	for r_commentary.Next() {
		com := Commentary{}
		err := r_commentary.Scan(&com.Id, &com.User_id, &com.Message, &com.Date, &com.Post_id)
		if err != nil {
			fmt.Println(err)
			continue
		}
		commentarys = append(commentarys, com)
	}

	r_user, err := database.Query("select * from image_board.user")
	if err != nil {
		log.Println(err)
	}
	defer r_user.Close()
	users := []User{}

	for r_user.Next() {
		u := User{}
		err := r_user.Scan(&u.Id, &u.Name, &u.Password, &u.Signup_date)
		if err != nil {
			fmt.Println(err)
			continue
		}
		users = append(users, u)
	}

	r_category, err := database.Query("select * from image_board.category")
	if err != nil {
		log.Println(err)
	}
	defer r_category.Close()
	categorys := []Category{}

	for r_category.Next() {
		cat := Category{}
		err := r_category.Scan(&cat.Id, &cat.Name)
		if err != nil {
			fmt.Println(err)
			continue
		}
		categorys = append(categorys, cat)
	}

	r_meta, err := database.Query("select * from image_board.meta")
	if err != nil {
		log.Println(err)
	}
	defer r_meta.Close()
	metas := []Meta{}

	for r_meta.Next() {
		m := Meta{}
		err := r_meta.Scan(&m.Id, &m.Name)
		if err != nil {
			fmt.Println(err)
			continue
		}
		metas = append(metas, m)
	}

	r_score, err := database.Query("select * from image_board.score")
	if err != nil {
		log.Println(err)
	}
	defer r_score.Close()
	scores := []Score{}

	for r_score.Next() {
		s := Score{}
		err := r_score.Scan(&s.Id, &s.Post_id, &s.User_id, &s.Count)
		if err != nil {
			fmt.Println(err)
			continue
		}
		scores = append(scores, s)
	}

	result := struct {
		Posts       []Post
		Contents    []Content
		Commentarys []Commentary
		Users       []User
		Categorys   []Category
		Metas       []Meta
		Scores      []Score
	}{posts, contents, commentarys, users, categorys, metas, scores}
	tmpl, _ := template.ParseFiles("index.html")
	tmpl.Execute(w, result)
}

func main() {
	db, err := sql.Open("mysql", "root:cola@tcp(localhost:3306)/image_board?parseTime=true&loc=EST")

	if err != nil {
		log.Println(err)
	}
	database = db
	defer db.Close()

	http.HandleFunc("/", IndexHandler)
	fs_css := http.FileServer(http.Dir("css"))
	http.Handle("/css/", http.StripPrefix("/css/", fs_css))
	fs_image := http.FileServer(http.Dir("image"))
	http.Handle("/image/", http.StripPrefix("/image/", fs_image))
	fmt.Println("Server is listening...")
	http.ListenAndServe(":8181", nil)
}

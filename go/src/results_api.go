package results_api

import (
	"encoding/json"
	"io/ioutil"
	"log"
)

type EvaluatorKind string

const (
	Descending     EvaluatorKind = "descending"
	Ascending      EvaluatorKind = "ascending"
	Parallel       EvaluatorKind = "parallel"
	SelfEvaluation EvaluatorKind = "autoevaluation"
)

type Result struct {
	Id         int           `json:"id"`
	EvaluadoId int           `json:"evaluado_id"`
	Result     int           `json:"result"`
	Kind       EvaluatorKind `json:"kind"`
}

type ApiClient struct {
	db       map[int][]Result
	pagesize int
}

type Response struct {
	Page    int      `json:"page"`
	Results []Result `json:"results"`
}

func NewApi() *ApiClient {
	fileContent, err := ioutil.ReadFile("./data/example.json")
	if err != nil {
		log.Fatal("ERROR while opening file. Aborting! Error: {}", err)
	}

	tmp := make([]Result, len(fileContent)/20)
	err = json.Unmarshal(fileContent, &tmp)
	if err != nil {
		log.Fatal("ERROR Unmarshaling data: {}\n\n Aborting!", err)
	}

	db := make(map[int][]Result, len(tmp))
	for _, val := range tmp {
		if _, ok := db[val.EvaluadoId]; ok {
			db[val.EvaluadoId] = append(db[val.EvaluadoId], val)
		} else {
			db[val.EvaluadoId] = make([]Result, 0, 5)
			db[val.EvaluadoId] = append(db[val.EvaluadoId], val)
		}
	}

	return &ApiClient{
		db:       db,
		pagesize: 10,
	}
}

func (this *ApiClient) FetchParticipants() string {
	keys := make([]int, len(this.db))
	i := 0
	for id := range this.db {
		keys[i] = id
		i++
	}
	bytes, err := json.Marshal(keys)
	if err != nil {
		log.Print("Unexpected Error")
		return "500 Internal Server Error"
	}
	return string(bytes)
}

func (this *ApiClient) FetchResults(employee_id int, page int) string {
	if page <= 0 {
		bytes, err := json.Marshal(Response{Page: page, Results: nil})
		if err != nil {
			log.Print("Unexpected Error")
			return "500 Internal Server Error"
		}
		return string(bytes)
	}
	if employees, ok := this.db[employee_id]; ok {
		bytes, err := json.Marshal(Response{
			Page:    page,
			Results: this.paginate(page, &employees),
		})
		if err != nil {
			log.Print("Unexpected Error")
			return "500 Internal Server Error"
		}
		return string(bytes)
	}
	bytes, err := json.Marshal(Response{Page: page, Results: nil})
	if err != nil {
		log.Print("Unexpected Error")
		return "500 Internal Server Error"
	}
	return string(bytes)
}

func (this *ApiClient) paginate(page int, result_slice *[]Result) []Result {
	slice_len := len(*result_slice)
	start, end := this.min((page-1)*this.pagesize, slice_len), this.min(page*this.pagesize, slice_len)
	return (*result_slice)[start:end]
}

func (this *ApiClient) min(n1 int, n2 int) int {
	if n1 > n2 {
		return n2
	}
	return n1
}

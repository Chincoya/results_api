import data from '../data/example.json';

export type Result = {
  id: number,
  evaluado_id: number,
  result: number,
  kind: string
}

export class ExternalApi {
  db: Object;
  pageSize: number;

  constructor() {
    this.pageSize = 10;
    let tmp = (data as Result[]);
    this.db = {};
    tmp.forEach((item) => {
      if(!(item.evaluado_id in this.db)) {
        this.db[item.evaluado_id] = new Array()
      }
      this.db[item.evaluado_id].push(item)
    });
  }

  fetch_participants() {
    return Object.keys(this.db);
  }

  fetch_results(employee_id: string, page:number= 1) {
    /*
     * returns {"page": number, "results": [{"id": number, "evaluado_id": number, "result": number, "kind": string}]}
     */
    if(page <= 0 || !(employee_id in this.db)) {
      return JSON.stringify({page: page, results: null});
    }
    let start: number = this.pageSize * (page - 1);
    let end: number = start + this.pageSize;
    return JSON.stringify(
      {
        page: page,
        results: this.db[employee_id]?.slice(start, end)
      }
    );
  }
}

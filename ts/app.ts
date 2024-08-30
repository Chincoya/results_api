import { Result, ExternalApi } from './src/external_api';


const client: ExternalApi = new ExternalApi();
console.log(client)
console.log(client.fetch_participants());
console.log(client.fetch_results('2'));


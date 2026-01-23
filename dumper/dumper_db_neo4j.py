import json
from neo4j import GraphDatabase
from neo4j.time import Date, DateTime, Time, Duration

# --- CONFIGURAÇÕES (Seus dados) ---
NEO4J_URI = "neo4j+s://708ee9de.databases.neo4j.io"
NEO4J_USERNAME = "neo4j"
# Recomendo usar variáveis de ambiente em produção, mas para seu teste:
NEO4J_PASSWORD = "dt29otQi253D5Gn6krWbR__P6TYorsMj4ZRloO-Yly0" 

class Neo4jDumper:
    def __init__(self, uri, user, password):
        self.driver = GraphDatabase.driver(uri, auth=(user, password))

    def close(self):
        self.driver.close()

    def serializar_neo4j(self, obj):
        """Ajuda o JSON a entender datas e tipos específicos do Neo4j"""
        if isinstance(obj, (Date, DateTime, Time)):
            return str(obj)
        if isinstance(obj, Duration):
            return str(obj)
        return obj

    def realizar_dump(self, nome_arquivo="backup_aura.json"):
        dados_totais = {
            "meta": {
                "origem": NEO4J_URI,
                "tipo": "Full Dump JSON"
            },
            "nos": [],
            "relacionamentos": []
        }

        print(f"🔄 Conectando a {NEO4J_URI}...")
        
        try:
            with self.driver.session() as session:
                # 1. Extrair NÓS
                print("📦 Baixando Nós...")
                query_nos = """
                MATCH (n) 
                RETURN elementId(n) as id, labels(n) as labels, properties(n) as props
                """
                result_nos = session.run(query_nos)
                for record in result_nos:
                    dados_totais["nos"].append({
                        "id": record["id"],
                        "labels": list(record["labels"]),
                        "properties": record["props"]
                    })
                print(f"   ✅ {len(dados_totais['nos'])} nós encontrados.")

                # 2. Extrair RELACIONAMENTOS
                print("🔗 Baixando Relacionamentos...")
                query_rels = """
                MATCH (a)-[r]->(b) 
                RETURN elementId(r) as id, type(r) as type, properties(r) as props, 
                       elementId(a) as start_id, elementId(b) as end_id
                """
                result_rels = session.run(query_rels)
                for record in result_rels:
                    dados_totais["relacionamentos"].append({
                        "id": record["id"],
                        "type": record["type"],
                        "start_node": record["start_id"],
                        "end_node": record["end_id"],
                        "properties": record["props"]
                    })
                print(f"   ✅ {len(dados_totais['relacionamentos'])} relacionamentos encontrados.")

            # 3. Salvar no arquivo
            print(f"💾 Salvando em '{nome_arquivo}'...")
            with open(nome_arquivo, "w", encoding="utf-8") as f:
                json.dump(dados_totais, f, indent=4, default=self.serializar_neo4j, ensure_ascii=False)
            
            print("✨ Dump concluído com sucesso!")

        except Exception as e:
            print(f"❌ Erro durante o dump: {e}")
        finally:
            self.close()

if __name__ == "__main__":
    # Instancia e roda o backup
    dumper = Neo4jDumper(NEO4J_URI, NEO4J_USERNAME, NEO4J_PASSWORD)
    dumper.realizar_dump()
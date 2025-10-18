import pandas as pd
import sqlite3
import os
import glob

USER_DESKTOP_PATH = os.path.join(os.environ['USERPROFILE'], 'Desktop', 'sql-data-analysis')
BASE_PATH = USER_DESKTOP_PATH 

DB_FILE = os.path.join(BASE_PATH, 'sql_queries.db')
conn = sqlite3.connect(DB_FILE)
print(f"Conectado ao DB: {DB_FILE}")


def import_single_file(folder, filename, table_name):
    file_path = os.path.join(BASE_PATH, folder, filename)
    print(f"Carregando: {table_name} de {file_path}")
    
    df = pd.read_csv(file_path, encoding='latin1', sep=',') 
    df.to_sql(table_name, conn, if_exists='replace', index=False)
    print(f"Sucesso: {table_name} com {len(df)} linhas.")


try:
    import_single_file('lookup_tables', 'airline_id.csv', 'airline_lookup')
    import_single_file('lookup_tables', 'destin_airport_id.csv', 'destin_airport_lookup')
    print("\nImportação das tabelas de lookup concluída.")
except Exception as e:
    print(f"AVISO: Não foi possível importar as tabelas de lookup. Detalhe: {e}")



def consolidate_and_import(folder, table_name):
    print(f"\nConsolidando dados em {folder} para a tabela {table_name}...")
    full_df = pd.DataFrame()
    
    search_path = os.path.join(BASE_PATH, folder, '*.csv')
    
  
    csv_files = glob.glob(search_path)
    
    if not csv_files:
        print(f"ERRO CRÍTICO: glob não encontrou arquivos CSV no caminho: {search_path}")
        print("AVISO: Nenhuma linha importada. O caminho absoluto está incorreto ou a pasta está vazia.")
        if folder == 'dataset_2023':
            print("Tentando caminho com 'D' maiúsculo...")
            search_path_fallback = os.path.join(BASE_PATH, 'Dataset_2023', '*.csv')
            csv_files = glob.glob(search_path_fallback)
            if csv_files:
                print("Tentativa com 'D' maiúsculo foi bem sucedida!")
            else:
                print("Tentativa com 'D' maiúsculo também falhou.")
                return
        else:
            return


    for i, file_path in enumerate(csv_files):
        file_name = os.path.basename(file_path)
        print(f"  Adicionando {file_name}...")
        
        try:
            if full_df.empty:
                df_temp = pd.read_csv(file_path, encoding='latin1', sep=',')
                full_df = pd.concat([full_df, df_temp], ignore_index=True)
            else:
                df_temp = pd.read_csv(file_path, header=None, encoding='latin1', sep=',')
                df_temp.columns = full_df.columns
                full_df = pd.concat([full_df, df_temp], ignore_index=True)

        except Exception as e:
            print(f"ERRO ao ler {file_name}: {e}")
            
    if not full_df.empty:
        full_df.to_sql(table_name, conn, if_exists='replace', index=False)
        print(f"SUCESSO: {table_name} finalizada com {len(full_df)} linhas totais.")
    else:
        print(f"AVISO: A importação de {table_name} falhou após a leitura.")

consolidate_and_import('data_2023', 'faa_data_2023')
consolidate_and_import('data_2024', 'faa_data_2024')


conn.close()
print("\nProcesso ETL concluído e conexão fechada. Os dados estão prontos no sql_queries.db!")
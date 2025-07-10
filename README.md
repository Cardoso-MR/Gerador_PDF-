# 📄 Gerador de PDF em ABAP

Este repositório contém um programa ABAP para geração de PDF a partir de dados de tabelas SAP.

---

## 🔍 Visão Geral

O programa `ZCLAB_CONVERT_TABLE_PDF.ABAP` é uma classe ABAP que permite converter dados de tabelas internas do SAP em documentos PDF formatados.

---

## ✨ Funcionalidades

- ✅ Conversão de tabelas internas ABAP para PDF  
- 🎨 Formatação automática de cabeçalhos e dados  
- 🛠️ Personalização de layout do PDF  
- 📑 Suporte a múltiplas páginas para grandes conjuntos de dados  

---

## ⚙️ Requisitos

- Sistema SAP com módulo de geração de PDF instalado  
- Autorizações adequadas para execução de programas ABAP  

---

## 🚀 Como Usar

1. Inclua a classe `ZCLAB_CONVERT_TABLE_PDF` em seu programa ABAP  
2. Crie uma instância da classe  
3. Passe os dados da tabela interna que deseja converter  
4. Chame o método de geração de PDF  

### 📋 Exemplo Básico

```abap
DATA: lo_pdf TYPE REF TO zclab_convert_table_pdf,
      lv_pdf TYPE xstring.

CREATE OBJECT lo_pdf.
lo_pdf->add_table( it_data = lt_my_data ).
lv_pdf = lo_pdf->generate( ).
```
---

## 🔧 Métodos Principais

|   Método   |             Descrição                       |
|------------|---------------------------------------------|
| ADD_TABLE	 | Adiciona uma tabela interna para conversão  |
| GENERATE 	 | Gera o documento PDF e retorna como XSTRING |
| SET_HEADER | Define um cabeçalho personalizado para o PDF|
| SET_FOOTER | Define um rodapé personalizado para o PDF   |

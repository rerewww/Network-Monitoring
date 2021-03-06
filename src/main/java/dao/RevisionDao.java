package dao;

import dao.model.Revision;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.core.RowMapper;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/**
 * Created by son on 2018-12-02.
 */
public class RevisionDao {
    private JdbcTemplate jdbcTemplate;
    @Autowired
    public RevisionDao(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }
    public void insert(final Map<String, String> contents) {
        jdbcTemplate.update(new PreparedStatementCreator() {
            @Override
            public PreparedStatement createPreparedStatement(Connection con)
                    throws SQLException {
                PreparedStatement pstmt = con.prepareStatement(
                        "insert into revision (local_address, remote_address, protocol, info) "+
                                "values (?, ?, ?, ?)");
                pstmt.setString(1,  contents.get("localAddress"));
                pstmt.setString(2,  contents.get("remoteAddress"));
                pstmt.setString(3,  contents.get("protocol"));
                pstmt.setString(4,  contents.get("info"));
                return pstmt;
            }
        });
    }
    public List<Revision> select() {
        List<Revision> results = jdbcTemplate.query("select * from revision", new RowMapper<Revision>() {
            @Override
            public Revision mapRow(ResultSet resultSet, int rowNum)
                    throws SQLException {
                Revision revision = new Revision(resultSet.getString("local_address"),
                        resultSet.getString("remote_address"),
                        resultSet.getString("protocol"),
                        resultSet.getString("info"));
                return revision;
            }
        });
        return results;
    }
}

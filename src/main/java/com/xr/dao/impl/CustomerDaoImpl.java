package com.xr.dao.impl;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.query.Query;
import org.springframework.stereotype.Repository;

import com.xr.dao.CustomerDao;
import com.xr.entity.Boss;
import com.xr.entity.Customer;
import com.xr.entity.JL;
import com.xr.util.HibernateUtil;
@Repository
public class CustomerDaoImpl implements CustomerDao {

	@Override
	public List<Customer> getCustomerByRole(Boss boss,String bj) {
		Session session = HibernateUtil.getSession();
		List<Customer> Customers=null;
		if(boss.getNewBranch()!=null){
			 int bid = boss.getNewBranch().getBid();
			 Customers=bj.equals("b") ? session.createQuery("FROM Customer WHERE partid="+bid).list():session.createQuery("FROM Customer WHERE bid="+bid).list();
		}else{
			Customers = session.createQuery("FROM Customer").list();
		}
		return Customers;
	}

	@Override
	public List<Customer> getAllCustomerByWhere(String name, String phone, String zdn, String fdn){
		StringBuffer hql=new StringBuffer("FROM Customer WHERE ");
			//如果是""则不按名称搜索支持模糊查询
			hql.append("".equals(name) ? "":"cname like '%"+name+"%' and ");
			//如果是""则不按名称号码支持模糊查询
			hql.append("".equals(phone) ? "":"phone like '%"+phone+"%' and ");
			if(zdn.equals("a") && fdn.equals("b")){
				
			}else if(zdn.equals("a")&&!fdn.equals("b")||!fdn.equals("b")&&!zdn.equals("a")){
				System.out.println("a!b");
				hql.append("branch.bid="+fdn+" and ");
			}else if(fdn.equals("b")&&!zdn.equals("a")){
				System.out.println("b!a");
				hql.append("branch.partid="+zdn+" and ");
			}
			hql.append("1=1");
			System.out.println(hql);
			Session session = HibernateUtil.getSession();
			List<Customer> customers = session.createQuery(hql.toString()).list();
		return customers;
	}
	/**
	 * 查询登录的检测者
	 */
	@Override
	public Customer findByCustomer(Customer customer) throws Exception {
		Session session = HibernateUtil.getSession();
		Query query = session.createQuery("from Customer where phone=?0");
		query.setParameter(0,customer.getPhone());
		Customer customer1=(Customer) query.uniqueResult();
		return customer1;
	}


	@Override
	public int[] FindAgeByCustomerWhere(String zd, String fd, String start, String end) throws SQLException {
		Session session = HibernateUtil.getSession();
		StringBuilder hql=new StringBuilder("FROM JL WHERE");
		StringBuilder hql2=null;
		if(zd.equals("a")&&!fd.equals("b")){
			hql.append(" JL.cids.branch="+fd+" and ");
		}else if(!zd.equals("a")&&fd.equals("b")){
			hql.append("JL.cids.branch.partId="+zd+" and ");
			hql2.append("FROM JL WHERE JL.cids.branch="+zd+" and ");
		}else if(!zd.equals("a")&&!fd.equals("b")){
			hql.append("JL.cids.branch="+fd+" and ");
		}
		if(start.equals("")&&!end.equals("")){
			hql.append(" JL.time >='2010-10-10' and JL.time<"+"'"+end+"' and ");
			if(hql2!=null){
				hql2.append("JL.time >='2010-10-10' and JL.time<"+"'"+end+"' and ");
			}
		}else if(!start.equals("")&&end.equals("")){
			String format = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
			hql.append(" JL.time >="+start+" and JL.time<"+"'"+format+"' and ");
			if(hql2!=null){
				hql2.append(" JL.time >="+start+" and JL.time<"+"'"+format+"' and ");
			}
		}else if(!start.equals("")&&!end.equals("")){
			hql.append(" JL.time >="+start+" and JL.time<"+"'"+end+"' and ");
			if(hql2!=null){
				hql2.append(" JL.time >="+start+" and JL.time<"+"'"+end+"' and ");
			}
		}
		hql.append(" 1=1 ");
		List<JL> list = session.createQuery(hql.toString()).list();
		if(hql2!=null){
			 List<JL> list2 = session.createQuery(hql2.toString()).list();
			 list.addAll(list2);
		}
		System.out.println("--------------------------"+list.size()+"--------------------------");
		return null;
	}





}
